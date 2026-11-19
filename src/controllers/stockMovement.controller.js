const { Op } = require('sequelize');
const { db } = require('../models');
const { sendResponse } = require('../utils/response');

const StockMovement = db.StockMovement;
const StockItem = db.StockItem;
const StockUnit = db.StockUnit;

/**
 * Helper untuk memvalidasi dan memproses filter rentang tanggal pergerakan stok.
 * Mendukung:
 * - date: Filter 1 hari spesifik (format YYYY-MM-DD)
 * - startDate & endDate: Filter rentang tanggal (format YYYY-MM-DD)
 * - allTime=true: Mengambil semua data tanpa batasan tanggal
 * - Default: Mengambil data 1 bulan terakhir (30 hari terakhir s/d hari ini)
 */
const parseDateRangeFilter = (query) => {
  const { date, startDate, endDate, allTime } = query;
  const TZ = 'Asia/Jakarta';

  const isValidDateStr = (s) =>
    typeof s === 'string' &&
    /^\d{4}-\d{2}-\d{2}$/.test(s) &&
    !isNaN(new Date(`${s}T00:00:00Z`).getTime());

  // 1. Opsi jika klien secara eksplisit meminta data all-time tanpa filter tanggal
  if (allTime === 'true' || allTime === true) {
    return { filter: null, range: { allTime: true, isDefault: false } };
  }

  // 2. Filter satu tanggal tertentu (misal: ?date=2026-11-08)
  if (date) {
    if (!isValidDateStr(date)) {
      return { error: 'Invalid date format. Use YYYY-MM-DD (e.g. 2026-11-08)' };
    }
    return {
      filter: date,
      range: { startDate: date, endDate: date, isDefault: false },
    };
  }

  // 3. Filter pilihan range tanggal (misal: ?startDate=2026-10-01&endDate=2026-11-08)
  if (startDate || endDate) {
    if (startDate && !isValidDateStr(startDate)) {
      return { error: 'Invalid startDate format. Use YYYY-MM-DD (e.g. 2026-10-01)' };
    }
    if (endDate && !isValidDateStr(endDate)) {
      return { error: 'Invalid endDate format. Use YYYY-MM-DD (e.g. 2026-11-08)' };
    }

    const rangeFilter = {};
    if (startDate) rangeFilter[Op.gte] = startDate;
    if (endDate) rangeFilter[Op.lte] = endDate;

    return {
      filter: rangeFilter,
      range: {
        startDate: startDate || null,
        endDate: endDate || null,
        isDefault: false,
      },
    };
  }

  // 4. Default: 1 bulan terakhir (30 hari ke belakang sampai hari ini, zona WIB)
  const now = new Date();
  const todayStr = now.toLocaleDateString('en-CA', { timeZone: TZ });
  const past30Days = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
  const defaultStartStr = past30Days.toLocaleDateString('en-CA', { timeZone: TZ });

  return {
    filter: {
      [Op.gte]: defaultStartStr,
      [Op.lte]: todayStr,
    },
    range: {
      startDate: defaultStartStr,
      endDate: todayStr,
      isDefault: true,
    },
  };
};

// ============== CATAT MUTASI STOK ==============
// Endpoint utama untuk input stok masuk, keluar, dan penyesuaian
const recordMovement = async (req, res) => {
  const t = await db.sequelize.transaction();
  try {
    const tenantId = req.user.tenantId;
    const {
      stockItemId,
      type,        // 'in' | 'out' | 'adjustment'
      reason,      // 'purchase' | 'production' | 'waste' | 'return' | 'transfer' | 'adjustment' | 'initial'
      quantity,
      unitCost,
      referenceNumber,
      notes,
      movementDate,
    } = req.body;

    // ---- Validasi wajib ----
    if (!stockItemId || !type || !quantity) {
      await t.rollback();
      return sendResponse(res, 400, false, 'stockItemId, type, and quantity are required');
    }

    const validTypes = ['in', 'out', 'adjustment'];
    if (!validTypes.includes(type)) {
      await t.rollback();
      return sendResponse(res, 400, false, `type must be one of: ${validTypes.join(', ')}`);
    }

    const validReasons = ['purchase', 'production', 'waste', 'return', 'transfer', 'adjustment', 'initial'];
    const finalReason = validReasons.includes(reason) ? reason : 'adjustment';

    const qty = parseFloat(quantity);
    if (isNaN(qty) || qty <= 0) {
      await t.rollback();
      return sendResponse(res, 400, false, 'quantity must be a positive number');
    }

    // ---- Ambil stok item dengan lock ----
    const item = await StockItem.findOne({
      where: { id: stockItemId, tenantId, isActive: true },
      transaction: t,
      lock: true,
    });

    if (!item) {
      await t.rollback();
      return sendResponse(res, 404, false, 'Stock item not found or inactive');
    }

    const stockBefore = parseFloat(item.currentStock);
    let stockAfter;

    if (type === 'in') {
      stockAfter = stockBefore + qty;
    } else if (type === 'out') {
      if (stockBefore < qty) {
        await t.rollback();
        return sendResponse(
          res, 400, false,
          `Insufficient stock. Current: ${stockBefore}, Requested out: ${qty}`,
          { currentStock: stockBefore, unit: item.unitId }
        );
      }
      stockAfter = stockBefore - qty;
    } else {
      // adjustment: qty adalah nilai BARU stok (bukan selisih)
      // Nilai baru tidak boleh < 0
      if (qty < 0) {
        await t.rollback();
        return sendResponse(res, 400, false, 'Adjustment quantity (new stock value) cannot be negative');
      }
      stockAfter = qty; // adjustment langsung set nilai stok baru
    }

    const unitCostVal = unitCost ? parseFloat(unitCost) : null;
    const totalCostVal = unitCostVal !== null ? unitCostVal * qty : null;
    const effectiveDate = movementDate
      ? movementDate
      : new Date().toISOString().slice(0, 10);

    // ---- Hitung quantity yang benar-benar tercatat (untuk adjustment adalah selisih) ----
    const recordedQty = type === 'adjustment' ? Math.abs(stockAfter - stockBefore) : qty;

    const movement = await StockMovement.create(
      {
        tenantId,
        stockItemId,
        userId: req.user.id,
        type,
        reason: finalReason,
        quantity: recordedQty,
        stockBefore,
        stockAfter,
        unitCost: unitCostVal,
        totalCost: totalCostVal,
        referenceNumber: referenceNumber || null,
        notes: notes || null,
        movementDate: effectiveDate,
      },
      { transaction: t }
    );

    // Update stok di tabel stock_items
    await item.update({ currentStock: stockAfter }, { transaction: t });

    // Jika ada harga beli baru saat transaksi 'in', update costPrice (moving average)
    if (type === 'in' && unitCostVal && unitCostVal > 0) {
      const oldStock = stockBefore;
      const oldCost = parseFloat(item.costPrice || 0);
      const newCostPrice = oldStock <= 0
        ? unitCostVal
        : ((oldStock * oldCost) + (qty * unitCostVal)) / (oldStock + qty);
      await item.update({ costPrice: Math.round(newCostPrice * 100) / 100 }, { transaction: t });
    }

    await t.commit();

    const fullMovement = await StockMovement.findByPk(movement.id, {
      include: [
        {
          model: StockItem,
          as: 'stockItem',
          attributes: ['id', 'name', 'currentStock'],
          include: [{ model: StockUnit, as: 'unit', attributes: ['id', 'name', 'symbol'] }],
        },
        { model: db.User, as: 'recordedBy', attributes: ['id', 'name'] },
      ],
    });

    return sendResponse(res, 201, true, 'Stock movement recorded successfully', { movement: fullMovement });
  } catch (error) {
    await t.rollback();
    console.error('Record movement error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET RIWAYAT MUTASI STOK ==============
// Default: mengambil data 1 bulan terakhir
// Pilihan range: ?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD atau ?date=YYYY-MM-DD atau ?allTime=true
const getMovements = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const {
      stockItemId, type, reason,
      page = 1, limit = 30,
    } = req.query;

    const dateResult = parseDateRangeFilter(req.query);
    if (dateResult.error) {
      return sendResponse(res, 400, false, dateResult.error);
    }

    const where = { tenantId };
    if (stockItemId) where.stockItemId = stockItemId;
    if (type) where.type = type;
    if (reason) where.reason = reason;
    if (dateResult.filter) where.movementDate = dateResult.filter;

    const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);

    const { count, rows: movements } = await StockMovement.findAndCountAll({
      where,
      limit: parseInt(limit, 10),
      offset,
      order: [['movementDate', 'DESC'], ['createdAt', 'DESC']],
      include: [
        {
          model: StockItem,
          as: 'stockItem',
          attributes: ['id', 'name'],
          include: [{ model: StockUnit, as: 'unit', attributes: ['id', 'name', 'symbol'] }],
        },
        { model: db.User, as: 'recordedBy', attributes: ['id', 'name'] },
      ],
    });

    return sendResponse(res, 200, true, 'Stock movements retrieved successfully', {
      movements,
      dateRange: dateResult.range,
      pagination: {
        totalItems: count,
        totalPages: Math.ceil(count / limit),
        currentPage: parseInt(page, 10),
        limit: parseInt(limit, 10),
      },
    });
  } catch (error) {
    console.error('Get movements error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET RIWAYAT MUTASI PER ITEM ==============
// Default: mengambil data 1 bulan terakhir untuk item terkait
// Pilihan range: ?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD atau ?date=YYYY-MM-DD atau ?allTime=true
const getMovementsByItem = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { stockItemId } = req.params;
    const { page = 1, limit = 30 } = req.query;

    const item = await StockItem.findOne({ where: { id: stockItemId, tenantId } });
    if (!item) {
      return sendResponse(res, 404, false, 'Stock item not found');
    }

    const dateResult = parseDateRangeFilter(req.query);
    if (dateResult.error) {
      return sendResponse(res, 400, false, dateResult.error);
    }

    const where = { tenantId, stockItemId };
    if (dateResult.filter) where.movementDate = dateResult.filter;

    const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);

    const { count, rows: movements } = await StockMovement.findAndCountAll({
      where,
      limit: parseInt(limit, 10),
      offset,
      order: [['movementDate', 'DESC'], ['createdAt', 'DESC']],
      include: [
        { model: db.User, as: 'recordedBy', attributes: ['id', 'name'] },
      ],
    });

    return sendResponse(res, 200, true, 'Stock item movements retrieved', {
      stockItem: { id: item.id, name: item.name, currentStock: item.currentStock },
      movements,
      dateRange: dateResult.range,
      pagination: {
        totalItems: count,
        totalPages: Math.ceil(count / limit),
        currentPage: parseInt(page, 10),
        limit: parseInt(limit, 10),
      },
    });
  } catch (error) {
    console.error('Get movements by item error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  recordMovement,
  getMovements,
  getMovementsByItem,
};
