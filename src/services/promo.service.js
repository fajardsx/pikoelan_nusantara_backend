const { Op } = require('sequelize');
const { db } = require('../models');

const PromoCode = db.PromoCode;
const Member = db.Member;
const PromoUsage = db.PromoUsage;

const TIER_LEVELS = {
  bronze: 1,
  silver: 2,
  gold: 3,
  platinum: 4,
};

/**
 * Validasi dan hitung diskon promo code
 * @param {Object} params
 * @param {number} params.tenantId
 * @param {string} params.code
 * @param {number} params.orderAmount
 * @param {number} [params.memberId]
 * @returns {Promise<{valid: boolean, message?: string, promo?: Object, discountAmount?: number, finalAmount?: number}>}
 */
const validatePromoCode = async ({ tenantId, code, orderAmount, memberId }) => {
  if (!code) {
    return { valid: false, message: 'Promo code is required' };
  }

  const normalizedCode = code.trim().toUpperCase();
  const promo = await PromoCode.findOne({
    where: {
      tenantId,
      code: normalizedCode,
    },
  });

  if (!promo) {
    return { valid: false, message: 'Promo code not found or invalid' };
  }

  if (!promo.isActive) {
    return { valid: false, message: 'This promo code is currently inactive' };
  }

  const now = new Date();

  if (promo.startDate && new Date(promo.startDate) > now) {
    return { valid: false, message: 'This promo has not started yet' };
  }

  if (promo.endDate && new Date(promo.endDate) < now) {
    return { valid: false, message: 'This promo has expired' };
  }

  if (promo.usageLimit !== null && promo.usageCount >= promo.usageLimit) {
    return { valid: false, message: 'Promo usage limit has been reached' };
  }

  const numericOrderAmount = parseFloat(orderAmount) || 0;
  const minAmount = parseFloat(promo.minOrderAmount) || 0;

  if (numericOrderAmount < minAmount) {
    return {
      valid: false,
      message: `Minimum order amount for this promo is Rp ${minAmount.toLocaleString('id-ID')}`,
    };
  }

  // Cek kriteria member tier jika ada
  let member = null;
  if (memberId) {
    member = await Member.findOne({ where: { id: memberId, tenantId, isActive: true } });
  }

  if (promo.applicableTier && promo.applicableTier !== 'all') {
    if (!member) {
      return {
        valid: false,
        message: `This promo is exclusive to ${promo.applicableTier.toUpperCase()} members`,
      };
    }

    const memberTierLevel = TIER_LEVELS[member.tier] || 0;
    const requiredTierLevel = TIER_LEVELS[promo.applicableTier] || 0;

    // Member dengan tier sama atau lebih tinggi berhak memakai promo tier
    if (memberTierLevel < requiredTierLevel) {
      return {
        valid: false,
        message: `This promo requires ${promo.applicableTier.toUpperCase()} membership tier or higher (your tier: ${member.tier.toUpperCase()})`,
      };
    }
  }

  // Hitung besaran diskon
  let discountAmount = 0;
  const discountVal = parseFloat(promo.discountValue) || 0;

  if (promo.discountType === 'percentage') {
    let rawDiscount = (numericOrderAmount * discountVal) / 100;
    if (promo.maxDiscountAmount !== null && promo.maxDiscountAmount !== undefined) {
      const maxDiscount = parseFloat(promo.maxDiscountAmount);
      rawDiscount = Math.min(rawDiscount, maxDiscount);
    }
    discountAmount = rawDiscount;
  } else if (promo.discountType === 'fixed') {
    discountAmount = Math.min(discountVal, numericOrderAmount);
  }

  discountAmount = Math.round(discountAmount * 100) / 100;
  const finalAmount = Math.max(0, Math.round((numericOrderAmount - discountAmount) * 100) / 100);

  return {
    valid: true,
    promo,
    discountAmount,
    finalAmount,
    orderAmount: numericOrderAmount,
    member: member ? { id: member.id, name: member.name, tier: member.tier } : null,
  };
};

module.exports = {
  validatePromoCode,
  TIER_LEVELS,
};

