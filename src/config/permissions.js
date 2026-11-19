// ============== KONFIGURASI PRIVILEGE ROLE ==============
// File ini adalah "sumber kebenaran" untuk:
//   1. daftar role yang ada di platform,
//   2. daftar menu/modul yang bisa diatur aksesnya,
//   3. privilege default tiap role (dipakai kalau tenant belum override).
//
// Privilege disimpan per tenant di tabel role_permissions. Kalau sebuah role
// belum punya baris untuk menu tertentu, nilai default di bawah ini yang dipakai.

const ROLE = {
  SUPERADMIN: 'superadmin',
  OWNER: 'owner',
  MANAGER: 'manager',
  STAFF: 'staff',
  KASIR: 'kasir',
  WAITER: 'waiter',
  KITCHEN: 'kitchen',
};

const ROLES = Object.values(ROLE);

// superadmin platform selalu punya akses penuh dan privilege-nya TIDAK bisa diubah
const CONFIGURABLE_ROLES = ROLES.filter((role) => role !== ROLE.SUPERADMIN);

// Menu = modul/fitur yang tampil di aplikasi (sidebar / halaman).
// Tambahkan di sini kalau nanti ada modul baru.
const MENUS = [
  { key: 'dashboard', label: 'Dashboard' },
  { key: 'menu', label: 'Menu' },
  { key: 'staff', label: 'Staf' },
  { key: 'transactions', label: 'Transaksi' },
  { key: 'reports', label: 'Laporan' },
  { key: 'settings', label: 'Pengaturan' },
  { key: 'notifications', label: 'Notifikasi' },
  { key: 'promos', label: 'Promo & Diskon' },
  { key: 'memberships', label: 'Membership' },
  { key: 'stock', label: 'Stok Bahan Baku' },
];

const MENU_KEYS = MENUS.map((menu) => menu.key);

// Aksi CRUD yang bisa diatur untuk setiap menu
const ACTIONS = ['create', 'read', 'update', 'delete'];

const ACTION_FLAGS = {
  create: 'canCreate',
  read: 'canRead',
  update: 'canUpdate',
  delete: 'canDelete',
};

const PERMISSION_FLAGS = ['canCreate', 'canRead', 'canUpdate', 'canDelete'];

const allow = (canCreate, canRead, canUpdate, canDelete) => ({
  canCreate,
  canRead,
  canUpdate,
  canDelete,
});

const FULL_ACCESS = allow(true, true, true, true);
const READ_ONLY = allow(false, true, false, false);

// Utility: bikin privilege penuh / read-only untuk sekumpulan menu
const onlyMenus = (menuKeys, flags) => {
  return menuKeys.reduce((acc, key) => {
    acc[key] = { ...flags };
    return acc;
  }, {});
};

// Privilege default tiap role kalau tenant belum melakukan override.
// Sengaja disamakan dengan perilaku endpoint yang sudah ada:
//   - owner & manager: full akses ke semua modul
//   - role operasional: hanya baca menu, akses transaksi terbatas
const DEFAULT_PERMISSIONS = {
  [ROLE.OWNER]: onlyMenus(MENU_KEYS, FULL_ACCESS),
  [ROLE.MANAGER]: onlyMenus(MENU_KEYS, FULL_ACCESS),
  [ROLE.STAFF]: {
    dashboard: { ...READ_ONLY },
    menu: { ...READ_ONLY },
    staff: { ...READ_ONLY },
    transactions: allow(true, true, true, false),
    notifications: { ...READ_ONLY },
    promos: { ...READ_ONLY },
    memberships: { ...READ_ONLY },
    stock: { ...READ_ONLY },
  },
  [ROLE.KASIR]: {
    dashboard: { ...READ_ONLY },
    menu: { ...READ_ONLY },
    transactions: { ...FULL_ACCESS },
    reports: { ...READ_ONLY },
    notifications: { ...READ_ONLY },
    promos: allow(false, true, false, false), // Kasir can read and apply promos
    memberships: allow(true, true, true, false), // Kasir can register & lookup members
    stock: { ...READ_ONLY }, // Kasir bisa lihat stok tapi tidak bisa edit
  },
  [ROLE.WAITER]: {
    dashboard: { ...READ_ONLY },
    menu: { ...READ_ONLY },
    transactions: allow(true, true, false, false),
    notifications: { ...READ_ONLY },
    promos: { ...READ_ONLY },
    memberships: { ...READ_ONLY },
    stock: allow(false, false, false, false),
  },
  [ROLE.KITCHEN]: {
    dashboard: { ...READ_ONLY },
    menu: { ...READ_ONLY },
    transactions: allow(false, true, true, false),
    notifications: { ...READ_ONLY },
    promos: allow(false, false, false, false),
    memberships: allow(false, false, false, false),
    stock: allow(false, true, false, false), // Dapur bisa lihat stok untuk referensi
  },
};

const NO_ACCESS = allow(false, false, false, false);

const isValidRole = (role) => ROLES.includes(role);

const isConfigurableRole = (role) => CONFIGURABLE_ROLES.includes(role);

const isValidMenuKey = (menuKey) => MENU_KEYS.includes(menuKey);

const getMenu = (menuKey) => MENUS.find((menu) => menu.key === menuKey) || null;

// Ambil privilege default (sudah di-clone supaya tidak termutasi)
const getDefaultPermission = (role, menuKey) => {
  const roleDefaults = DEFAULT_PERMISSIONS[role];
  const flags = roleDefaults ? roleDefaults[menuKey] : null;
  return { ...(flags || NO_ACCESS) };
};

// Ubah nama aksi (create/read/...) jadi nama kolom (canCreate/canRead/...)
const getPermissionFlag = (action) => ACTION_FLAGS[action] || null;

// Format privilege jadi objek konsisten untuk response API
const formatPermission = (menuKey, flags = {}) => ({
  menuKey,
  label: getMenu(menuKey)?.label || menuKey,
  canCreate: Boolean(flags.canCreate),
  canRead: Boolean(flags.canRead),
  canUpdate: Boolean(flags.canUpdate),
  canDelete: Boolean(flags.canDelete),
});

const pickPermissionFlags = (source = {}) => {
  return PERMISSION_FLAGS.reduce((acc, flag) => {
    acc[flag] = Boolean(source[flag]);
    return acc;
  }, {});
};

module.exports = {
  ROLE,
  ROLES,
  CONFIGURABLE_ROLES,
  MENUS,
  MENU_KEYS,
  ACTIONS,
  ACTION_FLAGS,
  PERMISSION_FLAGS,
  DEFAULT_PERMISSIONS,
  FULL_ACCESS,
  READ_ONLY,
  NO_ACCESS,
  isValidRole,
  isConfigurableRole,
  isValidMenuKey,
  getMenu,
  getDefaultPermission,
  getPermissionFlag,
  formatPermission,
  pickPermissionFlags,
};
