const { Op } = require('sequelize');
const { db } = require('../models');
const { sendResponse } = require('../utils/response');
const { validatePromoCode } = require('../services/promo.service');

const PromoCode = db.PromoCode;
const PromoUsage = db.PromoUsage;
const Order = db.Order;
const Member = db.Member;

// ============== CREATE PROMO CODE ==============
const createPromo = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const {
      code,
      title,
      description,
      discountType,
      discountValue,
      minOrderAmount,
      maxDiscountAmount,
      usageLimit,
      startDate,
      endDate,
      applicableTier,
      isActive,
    } = req.body;

    if (!code || !title || discountValue === undefined) {
      return sendResponse(res, 400, false, 'Code, title, and discountValue are required');
    }

    const cleanCode = String(code).trim().toUpperCase();

    // Cek duplikasi kode di tenant yang sama
    const existing = await PromoCode.findOne({
      where: { tenantId, code: cleanCode },
    });

    if (existing) {
      return sendResponse(res, 400, false, `Promo code "${cleanCode}" already exists for this restaurant`);
    }

    // Validasi discountType
    const type = discountType || 'fixed';
    if (!['percentage', 'fixed'].includes(type)) {
      return sendResponse(res, 400, false, 'discountType must be either "percentage" or "fixed"');
    }

    if (type === 'percentage' && (parseFloat(discountValue) <= 0 || parseFloat(discountValue) > 100)) {
      return sendResponse(res, 400, false, 'Percentage discount must be between 1 and 100');
    }

    const promo = await PromoCode.create({
      tenantId,
      code: cleanCode,
      title,
      description: description || null,
      discountType: type,
      discountValue: parseFloat(discountValue),
      minOrderAmount: minOrderAmount ? parseFloat(minOrderAmount) : 0,
      maxDiscountAmount: maxDiscountAmount ? parseFloat(maxDiscountAmount) : null,
      usageLimit: usageLimit ? parseInt(usageLimit, 10) : null,
      usageCount: 0,
      startDate: startDate ? new Date(startDate) : null,
      endDate: endDate ? new Date(endDate) : null,
      applicableTier: applicableTier || 'all',
      isActive: isActive !== undefined ? Boolean(isActive) : true,
    });

    return sendResponse(res, 201, true, 'Promo code created successfully', { promo });
  } catch (error) {
    console.error('Create promo error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET ALL PROMO CODES ==============
const getPromos = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const {
      search,
      isActive,
      applicableTier,
      discountType,
      page = 1,
      limit = 20,
    } = req.query;

    const where = { tenantId };

    if (search) {
      where[Op.or] = [
        { code: { [Op.iLike]: `%${search}%` } },
        { title: { [Op.iLike]: `%${search}%` } },
      ];
    }

    if (isActive !== undefined) {
      where.isActive = isActive === 'true' || isActive === true;
    }

    if (applicableTier) {
      where.applicableTier = applicableTier;
    }

    if (discountType) {
      where.discountType = discountType;
    }

    const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
    const { count, rows: promos } = await PromoCode.findAndCountAll({
      where,
      limit: parseInt(limit, 10),
      offset,
      order: [['createdAt', 'DESC']],
    });

    return sendResponse(res, 200, true, 'Promo codes retrieved successfully', {
      promos,
      pagination: {
        totalItems: count,
        totalPages: Math.ceil(count / limit),
        currentPage: parseInt(page, 10),
        limit: parseInt(limit, 10),
      },
    });
  } catch (error) {
    console.error('Get promos error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET PROMO CODE BY ID ==============
const getPromoById = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const promo = await PromoCode.findOne({
      where: { id, tenantId },
      include: [
        {
          model: PromoUsage,
          as: 'usages',
          limit: 10,
          order: [['createdAt', 'DESC']],
          include: [
            {
              model: Member,
              as: 'member',
              attributes: ['id', 'name', 'phone', 'tier'],
            },
            {
              model: Order,
              as: 'order',
              attributes: ['id', 'orderNumber', 'totalAmount'],
            },
          ],
        },
      ],
    });

    if (!promo) {
      return sendResponse(res, 404, false, 'Promo code not found');
    }

    return sendResponse(res, 200, true, 'Promo details retrieved successfully', { promo });
  } catch (error) {
    console.error('Get promo by id error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== UPDATE PROMO CODE ==============
const updatePromo = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;
    const {
      code,
      title,
      description,
      discountType,
      discountValue,
      minOrderAmount,
      maxDiscountAmount,
      usageLimit,
      startDate,
      endDate,
      applicableTier,
      isActive,
    } = req.body;

    const promo = await PromoCode.findOne({ where: { id, tenantId } });

    if (!promo) {
      return sendResponse(res, 404, false, 'Promo code not found');
    }

    if (code) {
      const cleanCode = String(code).trim().toUpperCase();
      if (cleanCode !== promo.code) {
        const existing = await PromoCode.findOne({
          where: { tenantId, code: cleanCode, id: { [Op.ne]: id } },
        });
        if (existing) {
          return sendResponse(res, 400, false, `Promo code "${cleanCode}" is already in use`);
        }
        promo.code = cleanCode;
      }
    }

    if (title !== undefined) promo.title = title;
    if (description !== undefined) promo.description = description;
    if (discountType !== undefined) promo.discountType = discountType;
    if (discountValue !== undefined) promo.discountValue = parseFloat(discountValue);
    if (minOrderAmount !== undefined) promo.minOrderAmount = parseFloat(minOrderAmount);
    if (maxDiscountAmount !== undefined) {
      promo.maxDiscountAmount = maxDiscountAmount ? parseFloat(maxDiscountAmount) : null;
    }
    if (usageLimit !== undefined) {
      promo.usageLimit = usageLimit ? parseInt(usageLimit, 10) : null;
    }
    if (startDate !== undefined) {
      promo.startDate = startDate ? new Date(startDate) : null;
    }
    if (endDate !== undefined) {
      promo.endDate = endDate ? new Date(endDate) : null;
    }
    if (applicableTier !== undefined) promo.applicableTier = applicableTier;
    if (isActive !== undefined) promo.isActive = Boolean(isActive);

    await promo.save();

    return sendResponse(res, 200, true, 'Promo code updated successfully', { promo });
  } catch (error) {
    console.error('Update promo error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== TOGGLE PROMO STATUS ==============
const togglePromoStatus = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const promo = await PromoCode.findOne({ where: { id, tenantId } });
    if (!promo) {
      return sendResponse(res, 404, false, 'Promo code not found');
    }

    promo.isActive = !promo.isActive;
    await promo.save();

    return sendResponse(res, 200, true, `Promo code ${promo.isActive ? 'activated' : 'deactivated'} successfully`, {
      promo,
    });
  } catch (error) {
    console.error('Toggle promo error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== DELETE PROMO CODE ==============
const deletePromo = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const promo = await PromoCode.findOne({ where: { id, tenantId } });
    if (!promo) {
      return sendResponse(res, 404, false, 'Promo code not found');
    }

    // Jika sudah ada riwayat pemakaian, nonaktifkan saja alih-alih hard delete
    const usageCount = await PromoUsage.count({ where: { promoId: id } });
    if (usageCount > 0) {
      promo.isActive = false;
      await promo.save();
      return sendResponse(
        res,
        200,
        true,
        'Promo has recorded usages, so it was deactivated instead of deleted',
        { promo }
      );
    }

    await promo.destroy();
    return sendResponse(res, 200, true, 'Promo code deleted successfully');
  } catch (error) {
    console.error('Delete promo error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== VALIDATE PROMO CODE (API Kasir / Staff) ==============
const validatePromo = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { code, orderAmount, memberId } = req.body;

    const result = await validatePromoCode({
      tenantId,
      code,
      orderAmount,
      memberId,
    });

    if (!result.valid) {
      return sendResponse(res, 400, false, result.message);
    }

    return sendResponse(res, 200, true, 'Promo code is valid', result);
  } catch (error) {
    console.error('Validate promo error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET PROMO STATISTICS ==============
const getPromoStats = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;

    const totalPromos = await PromoCode.count({ where: { tenantId } });
    const activePromos = await PromoCode.count({ where: { tenantId, isActive: true } });
    const totalUsages = await PromoUsage.count({ where: { tenantId } });
    const totalDiscountResult = await PromoUsage.sum('discountAmount', { where: { tenantId } });

    return sendResponse(res, 200, true, 'Promo statistics retrieved successfully', {
      totalPromos,
      activePromos,
      totalUsages,
      totalDiscountGiven: totalDiscountResult || 0,
    });
  } catch (error) {
    console.error('Get promo stats error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  createPromo,
  getPromos,
  getPromoById,
  updatePromo,
  togglePromoStatus,
  deletePromo,
  validatePromo,
  getPromoStats,
};

