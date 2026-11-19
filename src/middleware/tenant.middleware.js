const { sendResponse } = require('../utils/response');
const { db } = require('../models');

// Wajib dipasang SETELAH authMiddleware.
// Memastikan user memiliki tenant yang valid & masih aktif (belum suspend/nonaktif),
// lalu menempelkan data tenant ke req.tenant supaya bisa dipakai controller lain.
const requireActiveTenant = async (req, res, next) => {
  try {
    if (req.user.role === 'superadmin') {
      // superadmin platform tidak terikat satu tenant
      return next();
    }

    if (!req.user.tenantId) {
      return sendResponse(res, 403, false, 'User is not associated with any restaurant');
    }

    const tenant = await db.Tenant.findByPk(req.user.tenantId);

    if (!tenant) {
      return sendResponse(res, 404, false, 'Restaurant not found');
    }

    if (!tenant.isActive) {
      // Bedakan pesan: belum verifikasi email vs sengaja dinonaktifkan superadmin
      const owner = await db.User.findByPk(tenant.ownerId);
      if (owner && !owner.emailVerified) {
        return sendResponse(res, 403, false, 'Please verify your email before using this restaurant account', {
          reason: 'email_not_verified',
        });
      }
      return sendResponse(res, 403, false, 'Restaurant account is inactive, please contact support', {
        reason: 'suspended',
      });
    }

    req.tenant = tenant;
    next();
  } catch (error) {
    console.error('Tenant middleware error:', error.message);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// Middleware factory untuk membatasi endpoint berdasarkan role.
// Contoh: requireRole('owner', 'manager')
const requireRole = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user || !allowedRoles.includes(req.user.role)) {
      return sendResponse(res, 403, false, 'You do not have permission to perform this action');
    }
    next();
  };
};

module.exports = { requireActiveTenant, requireRole };
