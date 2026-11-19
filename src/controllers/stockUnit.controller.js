const { Op } = require('sequelize');
const { db } = require('../models');
const { sendResponse } = require('../utils/response');

const StockUnit = db.StockUnit;

// ============== CREATE SATUAN ==============
const createUnit = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { name, symbol, conversionFactor, baseUnit, description } = req.body;

    if (!name || !symbol) {
      return sendResponse(res, 400, false, 'Name and symbol are required');
    }

    const cleanSymbol = String(symbol).trim().toLowerCase();

    const existing = await StockUnit.findOne({
      where: { tenantId, symbol: cleanSymbol },
    });
    if (existing) {
      return sendResponse(res, 400, false, `Unit with symbol "${cleanSymbol}" already exists`);
    }

    const unit = await StockUnit.create({
      tenantId,
      name: name.trim(),
      symbol: cleanSymbol,
      conversionFactor: conversionFactor ? parseFloat(conversionFactor) : 1,
      baseUnit: baseUnit ? String(baseUnit).trim() : null,
      description: description || null,
      isActive: true,
    });

    return sendResponse(res, 201, true, 'Stock unit created successfully', { unit });
  } catch (error) {
    console.error('Create unit error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET ALL SATUAN ==============
const getUnits = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { isActive } = req.query;

    const where = { tenantId };
    if (isActive !== undefined) {
      where.isActive = isActive === 'true' || isActive === true;
    }

    const units = await StockUnit.findAll({
      where,
      order: [['name', 'ASC']],
    });

    return sendResponse(res, 200, true, 'Stock units retrieved successfully', { units });
  } catch (error) {
    console.error('Get units error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET SATUAN BY ID ==============
const getUnitById = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const unit = await StockUnit.findOne({ where: { id, tenantId } });
    if (!unit) {
      return sendResponse(res, 404, false, 'Stock unit not found');
    }

    return sendResponse(res, 200, true, 'Stock unit retrieved successfully', { unit });
  } catch (error) {
    console.error('Get unit by id error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== UPDATE SATUAN ==============
const updateUnit = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;
    const { name, symbol, conversionFactor, baseUnit, description, isActive } = req.body;

    const unit = await StockUnit.findOne({ where: { id, tenantId } });
    if (!unit) {
      return sendResponse(res, 404, false, 'Stock unit not found');
    }

    if (symbol) {
      const cleanSymbol = String(symbol).trim().toLowerCase();
      if (cleanSymbol !== unit.symbol) {
        const dup = await StockUnit.findOne({
          where: { tenantId, symbol: cleanSymbol, id: { [Op.ne]: id } },
        });
        if (dup) {
          return sendResponse(res, 400, false, `Unit with symbol "${cleanSymbol}" already exists`);
        }
        unit.symbol = cleanSymbol;
      }
    }

    if (name !== undefined) unit.name = name.trim();
    if (conversionFactor !== undefined) unit.conversionFactor = parseFloat(conversionFactor);
    if (baseUnit !== undefined) unit.baseUnit = baseUnit ? String(baseUnit).trim() : null;
    if (description !== undefined) unit.description = description || null;
    if (isActive !== undefined) unit.isActive = Boolean(isActive);

    await unit.save();
    return sendResponse(res, 200, true, 'Stock unit updated successfully', { unit });
  } catch (error) {
    console.error('Update unit error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== DELETE SATUAN ==============
const deleteUnit = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const unit = await StockUnit.findOne({ where: { id, tenantId } });
    if (!unit) {
      return sendResponse(res, 404, false, 'Stock unit not found');
    }

    // Cek apakah satuan sudah digunakan di bahan baku
    const used = await db.StockItem.count({ where: { unitId: id } });
    if (used > 0) {
      // Nonaktifkan saja, jangan hapus (sudah ada data terikat)
      unit.isActive = false;
      await unit.save();
      return sendResponse(res, 200, true, 'Unit is in use by stock items; deactivated instead of deleted', { unit });
    }

    await unit.destroy();
    return sendResponse(res, 200, true, 'Stock unit deleted successfully');
  } catch (error) {
    console.error('Delete unit error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = { createUnit, getUnits, getUnitById, updateUnit, deleteUnit };

