const { Op } = require('sequelize');
const { db } = require('../models');
const { sendResponse } = require('../utils/response');
const {
  generateMemberCode,
  evaluateTier,
  calculatePointsEarned,
  addPointRecord,
  normalizePhoneNumber,
  isValidPhoneNumber,
  getPhoneVariants,
} = require('../services/member.service');

const Member = db.Member;
const MemberPointHistory = db.MemberPointHistory;
const Order = db.Order;

// ============== CREATE MEMBER ==============
const createMember = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { name, phone, email, birthDate, address, notes, memberCode } = req.body;

    if (!name || !phone) {
      return sendResponse(res, 400, false, 'Name and phone number are required');
    }
    if (!isValidPhoneNumber(phone)) {
      return sendResponse(
        res,
        400,
        false,
        'Invalid phone number format. Phone number must be 9-15 digits (e.g. 08123456789 or +628123456789)'
      );
    }

    // Cek duplikasi nomor telepon per tenant
    const cleanPhone = normalizePhoneNumber(phone);
    const phoneVariants = getPhoneVariants(phone);

    // Cek duplikasi nomor telepon per tenant (mencakup variasi 08, 62, +62)
    const existingPhone = await Member.findOne({
      where: { tenantId, phone: cleanPhone },
      where: {
        tenantId,
        phone: { [Op.in]: phoneVariants },
      },
    });
    if (existingPhone) {
      return sendResponse(res, 400, false, `Member with phone number "${cleanPhone}" already exists`);
    }

    // Kode member bisa custom atau auto-generated
    let finalCode = memberCode ? String(memberCode).trim().toUpperCase() : null;
    if (finalCode) {
      const existingCode = await Member.findOne({
        where: { tenantId, memberCode: finalCode },
      });
      if (existingCode) {
        return sendResponse(res, 400, false, `Member code "${finalCode}" is already taken`);
      }
    } else {
      finalCode = await generateMemberCode(tenantId);
    }

    const member = await Member.create({
      tenantId,
      memberCode: finalCode,
      name: name.trim(),
      phone: cleanPhone,
      email: email ? email.trim() : null,
      birthDate: birthDate || null,
      address: address || null,
      notes: notes || null,
      tier: 'bronze',
      points: 0,
      totalSpent: 0,
      totalVisits: 0,
      isActive: true,
    });

    return sendResponse(res, 201, true, 'Member registered successfully', { member });
  } catch (error) {
    console.error('Create member error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET ALL MEMBERS ==============
const getMembers = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const {
      search,
      tier,
      isActive,
      page = 1,
      limit = 20,
      sortBy = 'createdAt',
      order = 'DESC',
    } = req.query;

    const where = { tenantId };

    if (search) {
      where[Op.or] = [
        { name: { [Op.iLike]: `%${search}%` } },
        { phone: { [Op.iLike]: `%${search}%` } },
        { memberCode: { [Op.iLike]: `%${search}%` } },
        { email: { [Op.iLike]: `%${search}%` } },
      ];
    }

    if (tier) {
      where.tier = tier;
    }

    if (isActive !== undefined) {
      where.isActive = isActive === 'true' || isActive === true;
    }

    const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
    const validSortFields = ['createdAt', 'name', 'points', 'totalSpent', 'totalVisits'];
    const sortField = validSortFields.includes(sortBy) ? sortBy : 'createdAt';
    const sortOrder = order.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

    const { count, rows: members } = await Member.findAndCountAll({
      where,
      limit: parseInt(limit, 10),
      offset,
      order: [[sortField, sortOrder]],
    });

    return sendResponse(res, 200, true, 'Members retrieved successfully', {
      members,
      pagination: {
        totalItems: count,
        totalPages: Math.ceil(count / limit),
        currentPage: parseInt(page, 10),
        limit: parseInt(limit, 10),
      },
    });
  } catch (error) {
    console.error('Get members error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== VALIDATE MEMBER BY PHONE ==============
const validateMemberByPhone = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const rawPhone = req.body.phone || req.query.phone || req.params.phone;

    if (!rawPhone) {
      return sendResponse(res, 400, false, 'Phone number is required');
    }

    if (!isValidPhoneNumber(rawPhone)) {
      return sendResponse(
        res,
        400,
        false,
        'Invalid phone number format. Phone number must be 9-15 digits (e.g. 08123456789 or +628123456789)',
        { inputPhone: rawPhone }
      );
    }

    const cleanPhone = normalizePhoneNumber(rawPhone);
    const phoneVariants = getPhoneVariants(rawPhone);

    const member = await Member.findOne({
      where: {
        tenantId,
        phone: { [Op.in]: phoneVariants },
      },
      include: [
        {
          model: MemberPointHistory,
          as: 'pointHistories',
          limit: 5,
          order: [['createdAt', 'DESC']],
        },
      ],
    });

    if (!member) {
      return sendResponse(res, 404, false, 'Member with this phone number is not registered', {
        isMember: false,
        phone: cleanPhone,
      });
    }

    if (!member.isActive) {
      return sendResponse(res, 400, false, 'Member account is inactive or suspended', {
        isMember: true,
        isActive: false,
        member: {
          id: member.id,
          memberCode: member.memberCode,
          name: member.name,
          phone: member.phone,
        },
      });
    }

    return sendResponse(res, 200, true, 'Member valid and active', {
      isMember: true,
      isActive: true,
      member: {
        id: member.id,
        tenantId: member.tenantId,
        memberCode: member.memberCode,
        name: member.name,
        phone: member.phone,
        email: member.email,
        tier: member.tier,
        points: member.points,
        totalSpent: member.totalSpent,
        totalVisits: member.totalVisits,
        joinDate: member.joinDate,
        birthDate: member.birthDate,
        address: member.address,
        notes: member.notes,
        pointHistories: member.pointHistories,
      },
    });
  } catch (error) {
    console.error('Validate member by phone error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== LOOKUP MEMBER (Fast search by phone or code) ==============
const lookupMember = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { query } = req.query;

    if (!query) {
      return sendResponse(res, 400, false, 'Query parameter "query" is required');
    }

    const cleanQuery = String(query).trim();
    const phoneVariants = getPhoneVariants(cleanQuery);

    const member = await Member.findOne({
      where: {
        tenantId,
        isActive: true,
        [Op.or]: [
          { phone: cleanQuery },
          { phone: { [Op.in]: phoneVariants } },
          { memberCode: cleanQuery.toUpperCase() },
        ],
      },
    });

    if (!member) {
      return sendResponse(res, 404, false, 'Member not found');
    }

    return sendResponse(res, 200, true, 'Member found', { member });
  } catch (error) {
    console.error('Lookup member error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET MEMBER BY ID ==============
const getMemberById = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const member = await Member.findOne({
      where: { id, tenantId },
      include: [
        {
          model: MemberPointHistory,
          as: 'pointHistories',
          limit: 10,
          order: [['createdAt', 'DESC']],
        },
        {
          model: Order,
          as: 'orders',
          limit: 5,
          order: [['createdAt', 'DESC']],
          attributes: ['id', 'orderNumber', 'orderType', 'status', 'totalAmount', 'createdAt'],
        },
      ],
    });

    if (!member) {
      return sendResponse(res, 404, false, 'Member not found');
    }

    return sendResponse(res, 200, true, 'Member details retrieved successfully', { member });
  } catch (error) {
    console.error('Get member by id error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== UPDATE MEMBER ==============
const updateMember = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;
    const { name, phone, email, birthDate, address, notes, tier, isActive } = req.body;

    const member = await Member.findOne({ where: { id, tenantId } });
    if (!member) {
      return sendResponse(res, 404, false, 'Member not found');
    }

    if (phone) {
      const cleanPhone = String(phone).trim();
      if (cleanPhone !== member.phone) {
        const existing = await Member.findOne({
          where: { tenantId, phone: cleanPhone, id: { [Op.ne]: id } },
        });
        if (existing) {
          return sendResponse(res, 400, false, `Phone number "${cleanPhone}" is already used by another member`);
        }
        member.phone = cleanPhone;
      if (!isValidPhoneNumber(phone)) {
        return sendResponse(
          res,
          400,
          false,
          'Invalid phone number format. Phone number must be 9-15 digits (e.g. 08123456789 or +628123456789)'
        );
      }
      const cleanPhone = normalizePhoneNumber(phone);
      const phoneVariants = getPhoneVariants(phone);

      const isExisting = await Member.findOne({
        where: {
          tenantId,
          phone: { [Op.in]: phoneVariants },
          id: { [Op.ne]: id },
        },
      });
      if (isExisting) {
        return sendResponse(res, 400, false, `Phone number "${cleanPhone}" is already used by another member`);
      }
      member.phone = cleanPhone;
    }

    if (name !== undefined) member.name = name.trim();
    if (email !== undefined) member.email = email ? email.trim() : null;
    if (birthDate !== undefined) member.birthDate = birthDate || null;
    if (address !== undefined) member.address = address || null;
    if (notes !== undefined) member.notes = notes || null;
    if (tier !== undefined) {
      const validTiers = ['bronze', 'silver', 'gold', 'platinum'];
      if (!validTiers.includes(tier)) {
        return sendResponse(res, 400, false, `Invalid tier. Allowed: ${validTiers.join(', ')}`);
      }
      member.tier = tier;
    }
    if (isActive !== undefined) member.isActive = Boolean(isActive);

    await member.save();

    return sendResponse(res, 200, true, 'Member updated successfully', { member });
  }
  } catch (error) {
    console.error('Update member error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== ADJUST MEMBER POINTS ==============
const adjustMemberPoints = async (req, res) => {
  const t = await db.sequelize.transaction();
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;
    const { points, type = 'adjustment', description } = req.body;

    const pointsNum = parseInt(points, 10);
    if (isNaN(pointsNum) || pointsNum === 0) {
      await t.rollback();
      return sendResponse(res, 400, false, 'Points must be a non-zero integer');
    }

    const member = await Member.findOne({
      where: { id, tenantId },
      transaction: t,
      lock: true,
    });

    if (!member) {
      await t.rollback();
      return sendResponse(res, 404, false, 'Member not found');
    }

    let finalType = type;
    if (!['earn', 'redeem', 'adjustment'].includes(finalType)) {
      finalType = 'adjustment';
    }

    // Jika redeem atau penyesuaian minus, pastikan poin mencukupi
    const pointDelta = finalType === 'redeem' ? -Math.abs(pointsNum) : pointsNum;
    const newTotalPoints = member.points + pointDelta;

    if (newTotalPoints < 0) {
      await t.rollback();
      return sendResponse(res, 400, false, `Insufficient points balance. Current points: ${member.points}`);
    }

    member.points = newTotalPoints;
    await member.save({ transaction: t });

    const record = await addPointRecord(
      {
        tenantId,
        memberId: member.id,
        type: finalType,
        points: pointDelta,
        description: description || `Points ${pointDelta > 0 ? 'added' : 'deducted'} by staff`,
      },
      t
    );

    await t.commit();

    return sendResponse(res, 200, true, 'Member points updated successfully', {
      member: {
        id: member.id,
        name: member.name,
        points: member.points,
      },
      pointRecord: record,
    });
  } catch (error) {
    await t.rollback();
    console.error('Adjust points error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET MEMBER POINT HISTORY ==============
const getMemberPointHistory = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;
    const { page = 1, limit = 20 } = req.query;

    const member = await Member.findOne({ where: { id, tenantId } });
    if (!member) {
      return sendResponse(res, 404, false, 'Member not found');
    }

    const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
    const { count, rows: history } = await MemberPointHistory.findAndCountAll({
      where: { memberId: id, tenantId },
      limit: parseInt(limit, 10),
      offset,
      order: [['createdAt', 'DESC']],
      include: [
        {
          model: Order,
          as: 'order',
          attributes: ['id', 'orderNumber', 'totalAmount'],
        },
      ],
    });

    return sendResponse(res, 200, true, 'Member point history retrieved successfully', {
      member: { id: member.id, name: member.name, currentPoints: member.points },
      history,
      pagination: {
        totalItems: count,
        totalPages: Math.ceil(count / limit),
        currentPage: parseInt(page, 10),
        limit: parseInt(limit, 10),
      },
    });
  } catch (error) {
    console.error('Get point history error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== DELETE / DEACTIVATE MEMBER ==============
const deleteMember = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;
    const { id } = req.params;

    const member = await Member.findOne({ where: { id, tenantId } });
    if (!member) {
      return sendResponse(res, 404, false, 'Member not found');
    }

    const orderCount = await Order.count({ where: { memberId: id } });
    if (orderCount > 0) {
      member.isActive = false;
      await member.save();
      return sendResponse(res, 200, true, 'Member has order history, deactivated instead of deleted', {
        member,
      });
    }

    await member.destroy();
    return sendResponse(res, 200, true, 'Member deleted successfully');
  } catch (error) {
    console.error('Delete member error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== GET MEMBERSHIP STATS ==============
const getMemberStats = async (req, res) => {
  try {
    const tenantId = req.user.tenantId;

    const totalMembers = await Member.count({ where: { tenantId } });
    const activeMembers = await Member.count({ where: { tenantId, isActive: true } });

    // Breakdown per tier
    const tiers = ['bronze', 'silver', 'gold', 'platinum'];
    const tierCounts = {};
    for (const t of tiers) {
      tierCounts[t] = await Member.count({ where: { tenantId, tier: t } });
    }

    const totalPointsResult = await Member.sum('points', { where: { tenantId } });

    return sendResponse(res, 200, true, 'Membership statistics retrieved successfully', {
      totalMembers,
      activeMembers,
      tierBreakdown: tierCounts,
      totalPointsInCirculation: totalPointsResult || 0,
    });
  } catch (error) {
    console.error('Get member stats error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  createMember,
  getMembers,
  lookupMember,
  validateMemberByPhone,
  getMemberById,
  updateMember,
  adjustMemberPoints,
  getMemberPointHistory,
  deleteMember,
  getMemberStats,
};

