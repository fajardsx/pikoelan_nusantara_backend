const { Op } = require('sequelize');
const { db } = require('../models');

const Member = db.Member;
const MemberPointHistory = db.MemberPointHistory;
const Order = db.Order;

module.exports = {
  async createMember(data) {
    return await Member.create(data);
  },
  async findMembers(where, limit, offset, order) {
    return await Member.findAndCountAll({ where, limit, offset, order });
  },
  async findById(id, tenantId) {
    return await Member.findOne({ where: { id, tenantId } });
  },
  async updateMember(id, tenantId, updates) {
    const member = await Member.findOne({ where: { id, tenantId } });
    if (!member) return null;
    return await member.update(updates);
  },
  async deleteMember(id, tenantId) {
    const member = await Member.findOne({ where: { id, tenantId } });
    if (!member) return null;
    await member.destroy();
    return true;
  },
  async adjustPoints(memberId, tenantId, points, type, description, orderId = null) {
    const member = await Member.findOne({ where: { id: memberId, tenantId } });
    if (!member) return null;
    member.points += points;
    await member.save();
    const record = await MemberPointHistory.create({ tenantId, memberId, orderId, type, points, description });
    return { member, record };
  },
  async getStats(tenantId) {
    const totalMembers = await Member.count({ where: { tenantId } });
    const activeMembers = await Member.count({ where: { tenantId, isActive: true } });
    const tiers = ['bronze', 'silver', 'gold', 'platinum'];
    const tierCounts = {};
    for (const t of tiers) {
      tierCounts[t] = await Member.count({ where: { tenantId, tier: t } });
    }
    const totalPoints = await Member.sum('points', { where: { tenantId } });
    return { totalMembers, activeMembers, tierBreakdown: tierCounts, totalPointsInCirculation: totalPoints || 0 };
  },
};