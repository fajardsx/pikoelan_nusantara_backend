const {sendResponse} = require("../utils/response");
const {db} = require("../models");
const {publishToTenant} = require("../utils/sse");
const {validatePromoCode} = require("../services/promo.service");
const {
  evaluateTier,
  calculatePointsEarned,
  addPointRecord,
  getPhoneVariants,
} = require("../services/member.service");

const Order = db.Order;
const OrderItem = db.OrderItem;
const MenuItem = db.MenuItem;
const Tenant = db.Tenant;
const PromoCode = db.PromoCode;
const PromoUsage = db.PromoUsage;
const Member = db.Member;
const MemberPointHistory = db.MemberPointHistory;

// Bikin nomor order yang enak dibaca: ORD-20260721-0001 (reset tiap hari, per tenant)
const generateOrderNumber = async (tenantId) => {
  const TZ = "Asia/Jakarta";
  const now = new Date();

  // Ambil tanggal dalam WIB untuk datePart (format: YYYYMMDD)
  const datePart = now
    .toLocaleDateString("en-CA", {timeZone: TZ}) // "2026-10-07"
    .replace(/-/g, "");

  // Hitung awal hari WIB sebagai UTC Date
  const jakartaDateStr = now.toLocaleDateString("en-CA", {timeZone: TZ}); // "2026-10-07"
  const startOfDayJakarta = new Date(`${jakartaDateStr}T00:00:00+07:00`);

  const countToday = await Order.count({
    where: {
      tenantId,
      createdAt: {[db.sequelize.Sequelize.Op.gte]: startOfDayJakarta},
    },
  });

  const sequence = String(countToday + 1).padStart(4, "0");
  return `ORD-${datePart}-${sequence}`;
};

// Logika inti bikin order - dipakai bareng oleh staf (lewat dasbor) dan
// pelanggan (lewat menu digital publik). tenantId sudah divalidasi oleh pemanggil.
const buildOrder = async ({
  tenantId,
  orderType,
  tableNumber,
  customerName,
  notes,
  paymentMethod,
  items,
  createdBy,
  source,
  memberId,
  memberPhone,
  promoCode,
  redeemPoints,
}) => {
  if (!Array.isArray(items) || items.length === 0) {
    return {error: "Order must have at least one item"};
  }

  const menuItemIds = items.map((i) => i.menuItemId);
  const menuItems = await MenuItem.findAll({
    where: {id: menuItemIds, tenantId, isAvailable: true},
  });

  if (menuItems.length !== menuItemIds.length) {
    return {error: "One or more menu items are invalid or no longer available"};
  }

  const menuItemMap = new Map(menuItems.map((mi) => [mi.id, mi]));
  let subtotal = 0;
  const t = await db.sequelize.transaction();

  try {
    // 1. Identifikasi Member jika disertakan
    let member = null;
    if (memberId) {
      member = await Member.findOne({
        where: {id: memberId, tenantId, isActive: true},
        transaction: t,
        lock: true,
      });
    } else if (memberPhone) {
      const phoneVariants = getPhoneVariants(memberPhone);
      member = await Member.findOne({
        where: {phone: String(memberPhone).trim(), tenantId, isActive: true},
        where: {
          phone: {[db.sequelize.Sequelize.Op.in]: phoneVariants},
          tenantId,
          isActive: true,
        },
        transaction: t,
        lock: true,
      });
    }

    const finalCustomerName = customerName || (member ? member.name : null);
    const orderNumber = await generateOrderNumber(tenantId);
    const jakartaISO =
      new Date()
        .toLocaleString("sv-SE", {
          timeZone: "Asia/Jakarta",
          hour12: false,
        })
        .replace(" ", "T") + "+07:00";
    const order = await Order.create(
      {
        tenantId,
        orderNumber,
        orderType: orderType || "dine_in",
        tableNumber: tableNumber || null,
        customerName: finalCustomerName,
        notes: notes || null,
        paymentMethod: paymentMethod || null,
        status: "new",
        source: source || "staff",
        createdBy: createdBy || null,
        subtotal: 0,
        discountAmount: 0,
        totalAmount: 0,
        memberId: member ? member.id : null,
        createdAt: new Date(jakartaISO),
      },
      {transaction: t},
    );

    const orderItemsData = items.map((i) => {
      const menuItem = menuItemMap.get(i.menuItemId);
      const quantity = Math.max(1, parseInt(i.quantity, 10) || 1);
      const itemSubtotal = parseFloat(menuItem.price) * quantity;
      subtotal += itemSubtotal;

      return {
        orderId: order.id,
        menuItemId: menuItem.id,
        itemName: menuItem.name,
        price: menuItem.price,
        quantity,
        subtotal: itemSubtotal,
        notes: i.notes || null,
      };
    });

    await OrderItem.bulkCreate(orderItemsData, {transaction: t});

    let discountAmount = 0;
    let promoRecord = null;

    // 2. Validasi & Hitung Promo Code jika ada
    if (promoCode) {
      const promoResult = await validatePromoCode({
        tenantId,
        code: promoCode,
        orderAmount: subtotal,
        memberId: member ? member.id : null,
      });

      if (!promoResult.valid) {
        await t.rollback();
        return {error: promoResult.message};
      }

      promoRecord = promoResult.promo;
      discountAmount += promoResult.discountAmount;

      // Update counter pemakaian promo
      await promoRecord.increment("usageCount", {by: 1, transaction: t});

      // Catat penggunaan promo
      await PromoUsage.create(
        {
          tenantId,
          promoId: promoRecord.id,
          orderId: order.id,
          memberId: member ? member.id : null,
          discountAmount: promoResult.discountAmount,
          orderAmount: subtotal,
        },
        {transaction: t},
      );
    }

    // 3. Redeem Poin Member jika diminta (1 poin = Rp 100)
    let pointsRedeemedCount = 0;
    if (member && redeemPoints && parseInt(redeemPoints, 10) > 0) {
      const pointsToRedeem = parseInt(redeemPoints, 10);
      if (member.points < pointsToRedeem) {
        await t.rollback();
        return {error: `Member only has ${member.points} points available`};
      }

      const pointDiscount = pointsToRedeem * 100;
      const remainingAmount = Math.max(0, subtotal - discountAmount);
      const actualPointDiscount = Math.min(pointDiscount, remainingAmount);
      pointsRedeemedCount = Math.ceil(actualPointDiscount / 100);

      discountAmount += actualPointDiscount;

      await addPointRecord(
        {
          tenantId,
          memberId: member.id,
          orderId: order.id,
          type: "redeem",
          points: -pointsRedeemedCount,
          description: `Tukar ${pointsRedeemedCount} poin untuk diskon pesanan #${orderNumber}`,
        },
        t,
      );
    }

    const finalTotalAmount = Math.max(
      0,
      Math.round((subtotal - discountAmount) * 100) / 100,
    );

    // 4. Perolehan Poin Member & Auto-Upgrade Tier
    let pointsEarnedCount = 0;
    if (member) {
      pointsEarnedCount = calculatePointsEarned(finalTotalAmount, member.tier);
      const newPoints = member.points - pointsRedeemedCount + pointsEarnedCount;
      const newTotalSpent = parseFloat(member.totalSpent) + finalTotalAmount;
      const newTotalVisits = (member.totalVisits || 0) + 1;
      const newTier = evaluateTier(newTotalSpent, newTotalVisits);

      await member.update(
        {
          points: newPoints,
          totalSpent: newTotalSpent,
          totalVisits: newTotalVisits,
          tier: newTier,
        },
        {transaction: t},
      );

      if (pointsEarnedCount > 0) {
        await addPointRecord(
          {
            tenantId,
            memberId: member.id,
            orderId: order.id,
            type: "earn",
            points: pointsEarnedCount,
            description: `Perolehan poin dari transaksi #${orderNumber}`,
          },
          t,
        );
      }
    }

    await order.update(
      {
        subtotal,
        discountAmount,
        totalAmount: finalTotalAmount,
        promoCodeId: promoRecord ? promoRecord.id : null,
        pointsEarned: pointsEarnedCount,
        pointsRedeemed: pointsRedeemedCount,
      },
      {transaction: t},
    );

    await t.commit();

    const fullOrder = await Order.findByPk(order.id, {
      include: [
        {model: OrderItem, as: "items"},
        {
          model: Member,
          as: "member",
          attributes: ["id", "memberCode", "name", "phone", "tier", "points"],
        },
        {
          model: PromoCode,
          as: "promoCode",
          attributes: ["id", "code", "title", "discountType", "discountValue"],
        },
      ],
    });

    // Notifikasi realtime ke dashboard kasir/dapur (SSE).
    publishToTenant(tenantId, "order.created", {
      order: fullOrder ? fullOrder.toJSON() : null,
    });

    return {order: fullOrder};
  } catch (error) {
    await t.rollback();
    throw error;
  }
};

// ============== CREATE ORDER (staf, lewat dasbor - perlu login) ==============
const createOrder = async (req, res) => {
  try {
    const result = await buildOrder({
      ...req.body,
      tenantId: req.user.tenantId,
      createdBy: req.user.id,
      //source: "staff",
    });

    if (result.error) {
      return sendResponse(res, 400, false, result.error);
    }

    return sendResponse(res, 201, true, "Order created successfully", {
      order: result.order,
    });
  } catch (error) {
    console.error("Create order error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== CREATE ORDER (pelanggan, lewat menu digital publik - tanpa login) ==============
const createPublicOrder = async (req, res) => {
  try {
    const {slug} = req.params;

    const tenant = await Tenant.findOne({where: {slug, isActive: true}});
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }

    const result = await buildOrder({
      ...req.body,
      tenantId: tenant.id,
      createdBy: null,
      source: "customer",
    });

    if (result.error) {
      return sendResponse(res, 400, false, result.error);
    }

    return sendResponse(res, 201, true, "Order placed successfully", {
      orderNumber: result.order.orderNumber,
      status: result.order.status,
      totalAmount: result.order.totalAmount,
    });
  } catch (error) {
    console.error("Create public order error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== LIST ORDERS ==============
// Query params:
// - status, orderType (filter biasa)
// - date=YYYY-MM-DD (filter 1 hari, zona Asia/Jakarta)
// - startDate & endDate (filter rentang, format YYYY-MM-DD, zona Asia/Jakarta)
// - Jika tidak ada filter tanggal, default ke bulan ini (Asia/Jakarta)
// - order_number (search public by order number, no auth, uses tenant slug)
const getOrders = async (req, res) => {
  try {
    const {status, orderType, date, startDate, endDate} = req.query;
    const {Op} = db.sequelize.Sequelize;

    const where = {tenantId: req.user.tenantId};
    if (status) where.status = status;
    if (orderType) where.orderType = orderType;

    const isValidDateStr = (s) =>
      typeof s === "string" &&
      /^\d{4}-\d{2}-\d{2}$/.test(s) &&
      !isNaN(new Date(`${s}T00:00:00+07:00`).getTime());

    if (date) {
      if (!isValidDateStr(date))
        return sendResponse(
          res,
          400,
          false,
          "Invalid date format. Use YYYY-MM-DD (e.g. 2026-10-10)",
        );
      where.createdAt = {
        [Op.gte]: new Date(`${date}T00:00:00+07:00`),
        [Op.lte]: new Date(`${date}T23:59:59.999+07:00`),
      };
    } else if (startDate || endDate) {
      if (startDate && !isValidDateStr(startDate))
        return sendResponse(
          res,
          400,
          false,
          "Invalid startDate format. Use YYYY-MM-DD",
        );
      if (endDate && !isValidDateStr(endDate))
        return sendResponse(
          res,
          400,
          false,
          "Invalid endDate format. Use YYYY-MM-DD",
        );
      where.createdAt = {};
      if (startDate)
        where.createdAt[Op.gte] = new Date(`${startDate}T00:00:00+07:00`);
      if (endDate)
        where.createdAt[Op.lte] = new Date(`${endDate}T23:59:59.999+07:00`);
    } else {
      const now = new Date();
      const tz = "Asia/Jakarta";
      const year = now.toLocaleString("en-CA", {timeZone: tz, year: "numeric"});
      const month = now.toLocaleString("en-CA", {
        timeZone: tz,
        month: "2-digit",
      });
      const startOfMonth = new Date(`${year}-${month}-01T00:00:00+07:00`);
      const nextMonth = new Date(startOfMonth);
      nextMonth.setMonth(nextMonth.getMonth() + 1);
      where.createdAt = {
        [Op.gte]: startOfMonth,
        [Op.lt]: nextMonth,
      };
    }

    const orders = await Order.findAll({
      where,
      include: [{model: OrderItem, as: "items"}],
      order: [["created_at", "DESC"]],
      limit: 100,
    });

    return sendResponse(res, 200, true, "Orders retrieved successfully", {
      orders,
      total: orders.length,
    });
  } catch (error) {
    console.error("Get orders error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== PUBLIC LIST ORDERS (search by order_number) ==============
// Accessible without auth. Uses tenant slug param to identify tenant.
// Query param: order_number (exact match). Returns matching orders with items.
const getOrdersPublic = async (req, res) => {
  try {
    const {slug} = req.params;
    const {order_number} = req.query;
    if (!order_number) {
      return sendResponse(
        res,
        400,
        false,
        "order_number query parameter required",
      );
    }
    const tenant = await Tenant.findOne({where: {slug, isActive: true}});
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }
    const {Op} = db.sequelize.Sequelize;
    const where = {
      tenantId: tenant.id,
      orderNumber: {[Op.like]: `%${order_number}%`},
    };
    const orders = await Order.findAll({
      where,
      include: [{model: OrderItem, as: "items"}],
      order: [["created_at", "DESC"]],
    });
    return sendResponse(res, 200, true, "Public orders retrieved", {
      orders,
      total: orders.length,
    });
  } catch (error) {
    console.error("Get public orders error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};
// ============== CANCEL PUBLIC ORDER ==============
// Public endpoint to cancel an order. No auth, uses tenant slug.
// ============== CANCEL PUBLIC ORDER BY ORDER_NUMBER ==============
// Public endpoint to cancel an order using order_number. No auth, uses tenant slug.
// Query param: order_number (required).
// Only allowed if order not completed or already cancelled.
const cancelPublicOrder = async (req, res) => {
  try {
    const {slug} = req.params;
    const {order_number} = req.query;
    if (!order_number) {
      return sendResponse(
        res,
        400,
        false,
        "order_number query parameter required",
      );
    }
    const tenant = await Tenant.findOne({where: {slug, isActive: true}});
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }
    const order = await Order.findOne({
      where: {orderNumber: order_number, tenantId: tenant.id},
    });
    if (!order) {
      return sendResponse(res, 404, false, "Order not found");
    }
    if (order.status === "completed" || order.status === "cancelled") {
      return sendResponse(
        res,
        400,
        false,
        `Order is already ${order.status} and cannot be cancelled`,
      );
    }
    const previousStatus = order.status;
    await order.update({status: "cancelled"});

    publishToTenant(tenant.id, "order.cancelled", {
      order: order.toJSON(),
      previousStatus,
    });

    return sendResponse(res, 200, true, "Order cancelled successfully", {
      order,
    });
  } catch (error) {
    console.error("Cancel public order error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== GET ORDER DETAIL ==============
const getOrderById = async (req, res) => {
  try {
    const {id} = req.params;

    const order = await Order.findOne({
      where: {id, tenantId: req.user.tenantId},
      include: [
        {model: OrderItem, as: "items"},
        {
          model: Member,
          as: "member",
          attributes: ["id", "memberCode", "name", "phone", "tier", "points"],
        },
        {
          model: PromoCode,
          as: "promoCode",
          attributes: ["id", "code", "title", "discountType", "discountValue"],
        },
      ],
    });

    if (!order) {
      return sendResponse(res, 404, false, "Order not found");
    }

    return sendResponse(res, 200, true, "Order retrieved successfully", {
      order,
    });
  } catch (error) {
    console.error("Get order by id error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== UPDATE ORDER STATUS ==============
const VALID_STATUSES = [
  "new",
  "proses",
  "ready",
  "deliver",
  "completed",
  "cancelled",
];

const updateOrderStatus = async (req, res) => {
  try {
    const {status, paymentMethod, items, paymentConfirmation} = req.body; // NEW: allow updates to paymentConfirmation

    const {id} = req.params;

    if (status && !VALID_STATUSES.includes(status)) {
      return sendResponse(
        res,
        400,
        false,
        `Status must be one of: ${VALID_STATUSES.join(", ")}`,
      );
    }

    const order = await Order.findOne({
      where: {id, tenantId: req.user.tenantId},
    });
    if (!order) {
      return sendResponse(res, 404, false, "Order not found");
    }

    if (order.status === "completed" || order.status === "cancelled") {
      return sendResponse(
        res,
        400,
        false,
        `Order is already ${order.status} and cannot be changed`,
      );
    }

    const previousStatus = order.status;
    const updateData = {};
    // Enum status di model hanya: new, proses, ready, deliver, completed, cancelled.
    if (paymentConfirmation !== undefined)
      updateData.paymentConfirmation = paymentConfirmation;

    // Sebelumnya ada mapping ke "preparing" yang tidak ada di enum -> request 500.
    if (status) updateData.status = status;
    if (paymentMethod) updateData.paymentMethod = paymentMethod; // NEW
    await order.update(updateData);

    // Beri tahu dashboard lain (kasir/dapur/waiter) bahwa status berubah
    publishToTenant(req.user.tenantId, "order.status_updated", {
      order: order.toJSON(),
      previousStatus,
      changedBy: req.user.id,
    });

    // Optional: handle items updates if needed (not implemented here)

    return sendResponse(res, 200, true, "Order status updated successfully", {
      order,
    });
  } catch (error) {
    console.error("Update order status error:", error.message);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== VALIDATE PUBLIC PROMO (Untuk Menu Digital Meja) ==============
const validatePublicPromo = async (req, res) => {
  try {
    const {slug} = req.params;
    const {code, orderAmount, phone} = req.body;

    const tenant = await Tenant.findOne({where: {slug, isActive: true}});
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }

    let memberId = null;
    if (phone) {
      const phoneVariants = getPhoneVariants(phone);
      const member = await Member.findOne({
        where: {
          tenantId: tenant.id,
          phone: String(phone).trim(),
          isActive: true,
        },
        where: {
          tenantId: tenant.id,
          phone: {[db.sequelize.Sequelize.Op.in]: phoneVariants},
          isActive: true,
        },
      });
      if (member) memberId = member.id;
    }

    const result = await validatePromoCode({
      tenantId: tenant.id,
      code,
      orderAmount,
      memberId,
    });

    if (!result.valid) {
      return sendResponse(res, 400, false, result.message);
    }

    return sendResponse(res, 200, true, "Promo code is valid", result);
  } catch (error) {
    console.error("Validate public promo error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// ============== LOOKUP PUBLIC MEMBER (Untuk Menu Digital Meja) ==============
const lookupPublicMember = async (req, res) => {
  try {
    const {slug} = req.params;
    const {phone} = req.query;

    if (!phone) {
      return sendResponse(res, 400, false, "Phone query parameter is required");
    }

    const tenant = await Tenant.findOne({where: {slug, isActive: true}});
    if (!tenant) {
      return sendResponse(res, 404, false, "Restaurant not found");
    }

    const phoneVariants = getPhoneVariants(phone);
    const member = await Member.findOne({
      where: {
        tenantId: tenant.id,
        phone: String(phone).trim(),
        phone: {[db.sequelize.Sequelize.Op.in]: phoneVariants},
        isActive: true,
      },
      attributes: ["name", "phone", "tier", "points"],
    });

    if (!member) {
      return sendResponse(res, 404, false, "Member not registered");
    }

    return sendResponse(res, 200, true, "Member found", {member});
  } catch (error) {
    console.error("Lookup public member error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

module.exports = {
  createOrder,
  createPublicOrder,
  getOrders,
  getOrdersPublic,
  cancelPublicOrder,
  getOrderById,
  updateOrderStatus,
  validatePublicPromo,
  lookupPublicMember,
};
