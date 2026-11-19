const { sendResponse } = require('../utils/response');
const {
  ROLE,
  PERMISSION_FLAGS,
  isValidMenuKey,
  isValidRole,
  isConfigurableRole,
} = require('../config/permissions');
const {
  getEffectivePermissions,
  getTenantPermissionMatrix,
  saveRolePermissions,
  resetRolePermissions,
} = require('../services/permission.service');

// Tenant yang diatur:
//   - owner/manager/staff -> selalu tenant miliknya sendiri
//   - superadmin           -> wajib menyebut tenantId (query atau body)
const resolveTenantId = (req) => {
  const isSuperadmin = req.user.role === ROLE.SUPERADMIN;

  if (!isSuperadmin) {
    return req.user.tenantId ? Number(req.user.tenantId) : null;
  }

  const raw = req.body?.tenantId ?? req.query.tenantId;
  if (raw === undefined || raw === null || raw === '') {
    return null;
  }

  return /^\d+$/.test(String(raw)) ? Number(raw) : null;
};

const validatePermissionUpdates = (permissions) => {
  if (!Array.isArray(permissions) || permissions.length === 0) {
    return 'permissions must be a non-empty array';
  }

  const seen = new Set();

  for (const item of permissions) {
    if (!item || typeof item !== 'object' || !item.menuKey) {
      return 'Each permission must have menuKey';
    }

    if (!isValidMenuKey(item.menuKey)) {
      return `Unknown menuKey: ${item.menuKey}`;
    }

    if (seen.has(item.menuKey)) {
      return `Duplicate menuKey: ${item.menuKey}`;
    }
    seen.add(item.menuKey);

    for (const flag of PERMISSION_FLAGS) {
      if (item[flag] !== undefined && typeof item[flag] !== 'boolean') {
        return `${flag} must be a boolean`;
      }
    }
  }

  return null;
};

// GET /api/permissions -> matriks privilege semua role di satu tenant
const getPermissions = async (req, res) => {
  try {
    const tenantId = resolveTenantId(req);

    if (!tenantId) {
      return sendResponse(
        res,
        400,
        false,
        req.user.role === ROLE.SUPERADMIN
          ? 'tenantId query parameter is required for superadmin'
          : 'User is not associated with any restaurant',
      );
    }

    const matrix = await getTenantPermissionMatrix(tenantId);
    return sendResponse(res, 200, true, 'Role permissions retrieved successfully', matrix);
  } catch (error) {
    console.error('Get role permissions error:', error.message);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// GET /api/permissions/me -> privilege milik user yang sedang login
// Dipakai aplikasi untuk menyembunyikan/menampilkan menu sesuai izin.
const getMyPermissions = async (req, res) => {
  try {
    if (req.user.role === ROLE.SUPERADMIN) {
      return sendResponse(res, 200, true, 'Role permissions retrieved successfully', {
        role: req.user.role,
        tenantId: null,
        permissions: await getEffectivePermissions({
          tenantId: null,
          role: ROLE.SUPERADMIN,
        }),
      });
    }
    if (req.user.role === ROLE.OWNER) {
      return sendResponse(res, 200, true, 'Role permissions retrieved successfully', {
        role: req.user.role,
        tenantId: null,
        permissions: await getEffectivePermissions({
          tenantId: null,
          role: ROLE.OWNER,
        }),
      });
    }

    if (!req.user.tenantId) {
      return sendResponse(res, 403, false, 'User is not associated with any restaurant');
    }

    const permissions = await getEffectivePermissions({
      tenantId: req.user.tenantId,
      role: req.user.role,
    });

    return sendResponse(res, 200, true, 'Role permissions retrieved successfully', {
      role: req.user.role,
      tenantId: req.user.tenantId,
      permissions,
    });
  } catch (error) {
    console.error('Get my permissions error:', error.message);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// PUT /api/permissions/:role -> ubah privilege satu role (owner/manager/superadmin)
const updateRolePermissions = async (req, res) => {
  try {
    const { role } = req.params;

    if (!isValidRole(role)) {
      return sendResponse(res, 400, false, `Unknown role: ${role}`);
    }

    if (!isConfigurableRole(role)) {
      return sendResponse(
        res,
        400,
        false,
        'superadmin always has full access and cannot be changed',
      );
    }

    const tenantId = resolveTenantId(req);

    if (!tenantId) {
      return sendResponse(
        res,
        400,
        false,
        req.user.role === ROLE.SUPERADMIN
          ? 'tenantId query parameter or body field is required for superadmin'
          : 'User is not associated with any restaurant',
      );
    }

    const validationError = validatePermissionUpdates(req.body?.permissions);
    if (validationError) {
      return sendResponse(res, 400, false, validationError);
    }

    const permissions = await saveRolePermissions({
      tenantId,
      role,
      updates: req.body.permissions,
    });

    return sendResponse(res, 200, true, 'Role permissions updated successfully', {
      tenantId,
      role,
      permissions,
    });
  } catch (error) {
    console.error('Update role permissions error:', error.message);
    if (error.name === 'SequelizeValidationError') {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, 'Server error');
  }
};

// DELETE /api/permissions/:role -> reset ke privilege default
const resetRolePermissionsToDefault = async (req, res) => {
  try {
    const { role } = req.params;

    if (!isValidRole(role)) {
      return sendResponse(res, 400, false, `Unknown role: ${role}`);
    }

    if (!isConfigurableRole(role)) {
      return sendResponse(
        res,
        400,
        false,
        'superadmin always has full access and cannot be changed',
      );
    }

    const tenantId = resolveTenantId(req);

    if (!tenantId) {
      return sendResponse(
        res,
        400,
        false,
        req.user.role === ROLE.SUPERADMIN
          ? 'tenantId query parameter is required for superadmin'
          : 'User is not associated with any restaurant',
      );
    }

    const permissions = await resetRolePermissions({ tenantId, role });

    return sendResponse(res, 200, true, 'Role permissions reset to default', {
      tenantId,
      role,
      permissions,
    });
  } catch (error) {
    console.error('Reset role permissions error:', error.message);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  getPermissions,
  getMyPermissions,
  updateRolePermissions,
  resetRolePermissionsToDefault,
};
