const { Op } = require('sequelize');
const { db } = require('../models');

const PromoCode = db.PromoCode;
const PromoUsage = db.PromoUsage;

module.exports = {
  async createPromo(data) {
    return await PromoCode.create(data);
  },
  async findPromos(where, limit, offset, order) {
    return await PromoCode.findAndCountAll({ where, limit, offset, order });
  },
  async findById(id, tenantId) {
    return await PromoCode.findOne({ where: { id, tenantId } });
  },
  async updatePromo(id, tenantId, updates) {
    const promo = await PromoCode.findOne({ where: { id, tenantId } });
    if (!promo) return null;
    return await promo.update(updates);
  },
  async toggleStatus(id, tenantId) {
    const promo = await PromoCode.findOne({ where: { id, tenantId } });
    if (!promo) return null;
    promo.isActive = !promo.isActive;
    return await promo.save();
  },
  async deletePromo(id, tenantId) {
    const promo = await PromoCode.findOne({ where: { id, tenantId } });
    if (!promo) return null;
    await promo.destroy();
    return true;
  },
  async countPromos(tenantId) {
    return await PromoCode.count({ where: { tenantId } });
  },
  async countActivePromos(tenantId) {
    return await PromoCode.count({ where: { tenantId, isActive: true } });
  },
  async totalUsages(tenantId) {
    return await PromoUsage.count({ where: { tenantId } });
  },
  async totalDiscountGiven(tenantId) {
    const result = await PromoUsage.sum('discountAmount', { where: { tenantId } });
    return result || 0;
  },
  async usageCount(promoId) {
    return await PromoUsage.count({ where: { promoId } });
  },
};