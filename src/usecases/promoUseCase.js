const { validatePromoCode } = require('../services/promo.service');
const promoRepo = require('../repositories/promoRepository');

module.exports = {
  async createPromo(data) {
    // Direct repo call; validation handled in service if needed
    return await promoRepo.createPromo(data);
  },
  async getPromos(params) {
    const { where, limit, offset, order } = params;
    return await promoRepo.findPromos(where, limit, offset, order);
  },
  async getPromoById(id, tenantId) {
    return await promoRepo.findById(id, tenantId);
  },
  async updatePromo(id, tenantId, updates) {
    return await promoRepo.updatePromo(id, tenantId, updates);
  },
  async togglePromoStatus(id, tenantId) {
    return await promoRepo.toggleStatus(id, tenantId);
  },
  async deletePromo(id, tenantId) {
    // repo handles hard delete; controller may check usage before calling
    return await promoRepo.deletePromo(id, tenantId);
  },
  async getPromoStats(tenantId) {
    const totalPromos = await promoRepo.countPromos(tenantId);
    const activePromos = await promoRepo.countActivePromos(tenantId);
    const totalUsages = await promoRepo.totalUsages(tenantId);
    const totalDiscountGiven = await promoRepo.totalDiscountGiven(tenantId);
    return { totalPromos, activePromos, totalUsages, totalDiscountGiven };
  },
  async validatePromo(params) {
    return await validatePromoCode(params);
  },
};