const { db } = require('../models');
const {
  ROLE,
  CONFIGURABLE_ROLES,
  MENUS,
  ACTIONS,
  isValidMenuKey,
  isValidRole,
  getPermissionFlag,
  getDefaultPermission,
  formatPermission,
  pickPermissionFlags,
} = require('../config/permissions');

const RolePermission = db.RolePermission;

// Gabungkan default role dengan override milik tenant.
// Override hanya berlaku untuk menu yang punya baris di role_permissions.
const buildEffectivePermissions = (role, rows = []) => {
  const overrideByMenu = new Map(rows.map((row) => [row.menuKey, row]));

  return MENUS.map((menu) => {
    const override = overrideByMenu.get(menu.key);
    const flags = override
      ? pickPermissionFlags(override)
      : getDefaultPermission(role, menu.key);

    return formatPermission(menu.key, flags);
  });
};

// Superadmin platform tidak dibatasi privilege per tenant
const getSuperadminPermissions = () => {
  return MENUS.map((menu) =>
    formatPermission(menu.key, {
      canCreate: true,
      canRead: true,
      canUpdate: true,
      canDelete: true,
    }),
  );
};

// Privilege efektif satu role di satu tenant
const getEffectivePermissions = async ({ tenantId, role }) => {
  if (role === ROLE.SUPERADMIN) {
    return getSuperadminPermissions();
  }

  const rows = await RolePermission.findAll({
    where: { tenantId, role },
    order: [['menuKey', 'ASC']],
  });

  return buildEffectivePermissions(role, rows);
};

// Matriks privilege semua role (satu tenant) untuk halaman pengaturan
const getTenantPermissionMatrix = async (tenantId) => {
  const rows = await RolePermission.findAll({
    where: { tenantId },
    order: [['role', 'ASC'], ['menuKey', 'ASC']],
  });

  const rowsByRole = rows.reduce((acc, row) => {
    if (!acc[row.role]) {
      acc[row.role] = [];
    }
    acc[row.role].push(row);
    return acc;
  }, {});

  const roles = CONFIGURABLE_ROLES.map((role) => ({
    role,
    permissions: buildEffectivePermissions(role, rowsByRole[role] || []),
  }));

  return {
    tenantId,
    menus: MENUS.map((menu) => ({ key: menu.key, label: menu.label })),
    actions: ACTIONS,
    roles,
  };
};

// Cek izin satu aksi pada satu menu, dipakai middleware requireMenuPermission
const canAccess = async ({ tenantId, role, menuKey, action }) => {
  if (role === ROLE.SUPERADMIN) {
    return true;
  }

  const flag = getPermissionFlag(action);
  if (!flag || !isValidMenuKey(menuKey) || !isValidRole(role)) {
    return false;
  }

  const row = await RolePermission.findOne({ where: { tenantId, role, menuKey } });
  const flags = row ? pickPermissionFlags(row) : getDefaultPermission(role, menuKey);

  return Boolean(flags[flag]);
};

// Simpan override privilege. Field yang tidak dikirim akan memakai nilai efektif
// saat ini (partial update), jadi client tidak wajib mengirim keempat flag.
const saveRolePermissions = async ({ tenantId, role, updates }) => {
  const current = await getEffectivePermissions({ tenantId, role });
  const currentByMenu = new Map(current.map((item) => [item.menuKey, item]));

  const transaction = await db.sequelize.transaction();

  try {
    for (const update of updates) {
      const base = currentByMenu.get(update.menuKey);

      await RolePermission.upsert(
        {
          tenantId,
          role,
          menuKey: update.menuKey,
          canCreate: update.canCreate !== undefined ? update.canCreate : base.canCreate,
          canRead: update.canRead !== undefined ? update.canRead : base.canRead,
          canUpdate: update.canUpdate !== undefined ? update.canUpdate : base.canUpdate,
          canDelete: update.canDelete !== undefined ? update.canDelete : base.canDelete,
        },
        { transaction },
      );
    }

    await transaction.commit();
  } catch (error) {
    await transaction.rollback();
    throw error;
  }

  return getEffectivePermissions({ tenantId, role });
};

// Hapus override tenant -> role kembali memakai privilege default
const resetRolePermissions = async ({ tenantId, role }) => {
  await RolePermission.destroy({ where: { tenantId, role } });
  return getEffectivePermissions({ tenantId, role });
};

module.exports = {
  getEffectivePermissions,
  getTenantPermissionMatrix,
  canAccess,
  saveRolePermissions,
  resetRolePermissions,
};
