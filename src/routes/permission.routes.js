const express = require('express');
const router = express.Router();
const {
  getPermissions,
  getMyPermissions,
  updateRolePermissions,
  resetRolePermissionsToDefault,
} = require('../controllers/permission.controller');
const authMiddleware = require('../middleware/auth.middleware');
const { requireActiveTenant, requireRole } = require('../middleware/tenant.middleware');

// Semua endpoint privilege butuh login & tenant aktif
router.use(authMiddleware, requireActiveTenant);

// Semua user boleh lihat privilege miliknya sendiri (untuk render menu di app)
router.get('/me', getMyPermissions);

// Melihat & mengubah privilege hanya owner, manager, dan superadmin
router.get('/', requireRole('owner', 'manager', 'superadmin'), getPermissions);
router.put('/:role', requireRole('owner', 'manager', 'superadmin'), updateRolePermissions);
router.delete(
  '/permissions/:role',
  requireRole('owner', 'manager', 'superadmin'),
  resetRolePermissionsToDefault,
);

module.exports = router;
