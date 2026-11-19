const express = require('express');
const router = express.Router();
const {
  createOrder,
  getOrders,
  getOrderById,
  updateOrderStatus,
} = require('../controllers/order.controller');
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant } = require('../middleware/tenant.middleware');

// Semua route order butuh login & tenant aktif (owner/manager/staff semua boleh)
router.use(authMiddleware, requireActiveTenant);

router.post('/', createOrder);
router.get('/', getOrders);
router.get('/:id', getOrderById);
router.put('/:id/status', updateOrderStatus);

module.exports = router;
