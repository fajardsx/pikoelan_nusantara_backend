const express = require('express');
const router = express.Router();
const {
  registerTenant,
  getMyTenant,
  updateMyTenant,
  inviteStaff,
  getAllTenants,
  updateTenantStatus,
  deleteStaff,
} = require('../controllers/tenant.controller');
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant, requireRole } = require('../middleware/tenant.middleware');
const { registerLimiter } = require('../middleware/rateLimit.middleware');
const upload = require('../middleware/upload.middleware');
const uploadFields = upload.fields([
  { name: 'logo', maxCount: 1 },
  { name: 'qris', maxCount: 1 },
]);

// Public: onboarding restoran baru (bikin tenant + akun owner sekaligus)
router.post('/register', registerLimiter, registerTenant);

// Superadmin: kelola semua tenant di platform
router.get('/', authMiddleware, requireRole('superadmin'), getAllTenants);
router.put('/:id/status', authMiddleware, requireRole('superadmin'), updateTenantStatus);

// Protected: info restoran - SENGAJA tidak pakai requireActiveTenant, supaya
// pemilik restoran yang belum verifikasi email tetap bisa lihat status akunnya.
router.get('/me', authMiddleware, getMyTenant);
router.put('/me', authMiddleware, requireActiveTenant, requireRole('owner', 'manager'), uploadFields, updateMyTenant);

// Protected: tambah staff baru ke restoran
router.post('/staff', authMiddleware, requireActiveTenant, requireRole('owner', 'manager'), inviteStaff);
router.delete('/staff/:id', authMiddleware, requireActiveTenant, requireRole('owner', 'manager'), deleteStaff);

module.exports = router;
