const express = require('express');
const router = express.Router();
const {
  getPayments,
  getPayment,
  createPayment,
  updatePayment,
  deletePayment,
} = require('../controllers/tenantPayment.controller');
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant } = require('../middleware/tenant.middleware');

// All payment routes require authentication and active tenant
router.use(authMiddleware, requireActiveTenant);

router.get('/', getPayments);
router.post('/', createPayment);
router.get('/:id', getPayment);
router.put('/:id', updatePayment);
router.delete('/:id', deletePayment);

module.exports = router;
