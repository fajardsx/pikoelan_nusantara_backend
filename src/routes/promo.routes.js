const express = require('express');
const router = express.Router();
const {
  createPromo,
  getPromos,
  getPromoById,
  updatePromo,
  togglePromoStatus,
  deletePromo,
  validatePromo,
  getPromoStats,
} = require('../controllers/promo.controller');
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant } = require('../middleware/tenant.middleware');
const { requireMenuPermission } = require('../middleware/permission.middleware');

// Semua route promo butuh login & tenant aktif
router.use(authMiddleware, requireActiveTenant);

// Statistik & Validasi
router.get('/stats', requireMenuPermission('promos', 'read'), getPromoStats);
router.post('/validate', requireMenuPermission('promos', 'read'), validatePromo);

// CRUD Promo
router.get('/', requireMenuPermission('promos', 'read'), getPromos);
router.post('/', requireMenuPermission('promos', 'create'), createPromo);
router.get('/:id', requireMenuPermission('promos', 'read'), getPromoById);
router.put('/:id', requireMenuPermission('promos', 'update'), updatePromo);
router.patch('/:id/toggle', requireMenuPermission('promos', 'update'), togglePromoStatus);
router.delete('/:id', requireMenuPermission('promos', 'delete'), deletePromo);

module.exports = router;

