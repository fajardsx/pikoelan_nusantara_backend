const { sendResponse } = require('../utils/response');
const { ROLE } = require('../config/permissions');
const { canAccess } = require('../services/permission.service');

// Middleware factory untuk mengecek privilege role pada satu menu.
// Contoh: requireMenuPermission('menu', 'create')
// Wajib dipasang SETELAH authMiddleware.
// superadmin selalu lolos karena punya akses penuh.
const requireMenuPermission = (menuKey, action) => {
  return async (req, res, next) => {
    try {
      if (!req.user) {
        return sendResponse(res, 401, false, 'Authentication required');
      }

      if (req.user.role === ROLE.SUPERADMIN || req.user.role === ROLE.OWNER) {
        return next();
      }

      if (!req.user.tenantId) {
        return sendResponse(res, 403, false, 'User is not associated with any restaurant');
      }

      const allowed = await canAccess({
        tenantId: req.user.tenantId,
        role: req.user.role,
        menuKey,
        action,
      });

      if (!allowed) {
        return sendResponse(
          res,
          403,
          false,
          `You do not have permission to ${action} ${menuKey}`,
        );
      }

      next();
    } catch (error) {
      console.error('Permission middleware error:', error.message);
      return sendResponse(res, 500, false, 'Server error');
    }
  };
};

module.exports = { requireMenuPermission };
