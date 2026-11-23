const { sequelize } = require('../config/db');
const Tenant = require('./tenant');
const TenantPayment = require('./tenantPayment');
const User = require('./user');
const Message = require('./message');
const MenuCategory = require('./menuCategory');
const MenuItem = require('./menuItem');
const PromoCode = require('./promoCode');
const Member = require('./member');
const Order = require('./order');
const OrderItem = require('./orderItem');
const RolePermission = require('./rolePermission');
const PromoUsage = require('./promoUsage');
const MemberPointHistory = require('./memberPointHistory');
// Stock modules
const StockUnit = require('./stockUnit');
const StockCategory = require('./stockCategory');
const StockItem = require('./stockItem');
const StockMovement = require('./stockMovement');
const MenuItemStock = require('./menuItemStock');

// ============== ASSOCIATIONS ==============
// 1 Tenant (restoran) punya banyak User (staff) dan banyak Message
Tenant.hasMany(User, { foreignKey: 'tenantId', as: 'users' });
User.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// Pemilik restoran (khusus, terpisah dari daftar staff biasa)
Tenant.belongsTo(User, { foreignKey: 'ownerId', as: 'owner' });

Tenant.hasMany(Message, { foreignKey: 'tenantId', as: 'messages' });
Message.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// Menu: Tenant -> Category -> Item
Tenant.hasMany(MenuCategory, { foreignKey: 'tenantId', as: 'menuCategories' });
MenuCategory.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

Tenant.hasMany(MenuItem, { foreignKey: 'tenantId', as: 'menuItems' });
MenuItem.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// New many-to-many association between MenuItem and MenuCategory
const MenuItemCategory = require('./menuItemCategory');
MenuItem.belongsToMany(MenuCategory, { through: MenuItemCategory, foreignKey: 'menuItemId', otherKey: 'menuCategoryId', as: 'categories' });
MenuCategory.belongsToMany(MenuItem, { through: MenuItemCategory, foreignKey: 'menuCategoryId', otherKey: 'menuItemId', as: 'items' });

// Promo Codes
Tenant.hasMany(PromoCode, { foreignKey: 'tenantId', as: 'promoCodes' });
PromoCode.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// Membership
Tenant.hasMany(Member, { foreignKey: 'tenantId', as: 'members' });
Member.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

Member.hasMany(MemberPointHistory, { foreignKey: 'memberId', as: 'pointHistories' });
MemberPointHistory.belongsTo(Member, { foreignKey: 'memberId', as: 'member' });

// Order: Tenant -> Order -> OrderItem -> MenuItem
Tenant.hasMany(Order, { foreignKey: 'tenantId', as: 'orders' });
Order.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

User.hasMany(Order, { foreignKey: 'createdBy', as: 'orders' });
Order.belongsTo(User, { foreignKey: 'createdBy', as: 'staff' });

Order.hasMany(OrderItem, { foreignKey: 'orderId', as: 'items' });
OrderItem.belongsTo(Order, { foreignKey: 'orderId', as: 'order' });

MenuItem.hasMany(OrderItem, { foreignKey: 'menuItemId', as: 'orderItems' });
OrderItem.belongsTo(MenuItem, { foreignKey: 'menuItemId', as: 'menuItem' });

Member.hasMany(Order, { foreignKey: 'memberId', as: 'orders' });
Order.belongsTo(Member, { foreignKey: 'memberId', as: 'member' });

PromoCode.hasMany(Order, { foreignKey: 'promoCodeId', as: 'orders' });
Order.belongsTo(PromoCode, { foreignKey: 'promoCodeId', as: 'promoCode' });

// Promo Usages
PromoCode.hasMany(PromoUsage, { foreignKey: 'promoId', as: 'usages' });
PromoUsage.belongsTo(PromoCode, { foreignKey: 'promoId', as: 'promo' });

Order.hasOne(PromoUsage, { foreignKey: 'orderId', as: 'promoUsage' });
PromoUsage.belongsTo(Order, { foreignKey: 'orderId', as: 'order' });

Member.hasMany(PromoUsage, { foreignKey: 'memberId', as: 'promoUsages' });
PromoUsage.belongsTo(Member, { foreignKey: 'memberId', as: 'member' });

// Privilege role per menu (per tenant)
Tenant.hasMany(TenantPayment, { foreignKey: 'tenantId', as: 'payments' });
TenantPayment.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });
RolePermission.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// ============== STOCK ASSOCIATIONS ==============
// Tenant -> StockUnit (satuan stok per restoran)
Tenant.hasMany(StockUnit, { foreignKey: 'tenantId', as: 'stockUnits' });
StockUnit.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// Tenant -> StockCategory
Tenant.hasMany(StockCategory, { foreignKey: 'tenantId', as: 'stockCategories' });
StockCategory.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// StockItem -> StockUnit (setiap bahan baku punya satuan)
StockUnit.hasMany(StockItem, { foreignKey: 'unitId', as: 'stockItems' });
StockItem.belongsTo(StockUnit, { foreignKey: 'unitId', as: 'unit' });

// StockItem -> StockCategory
StockCategory.hasMany(StockItem, { foreignKey: 'categoryId', as: 'stockItems' });
StockItem.belongsTo(StockCategory, { foreignKey: 'categoryId', as: 'category' });

// Tenant -> StockItem
Tenant.hasMany(StockItem, { foreignKey: 'tenantId', as: 'stockItems' });
StockItem.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// StockItem -> StockMovement (riwayat mutasi stok)
StockItem.hasMany(StockMovement, { foreignKey: 'stockItemId', as: 'movements' });
StockMovement.belongsTo(StockItem, { foreignKey: 'stockItemId', as: 'stockItem' });

Tenant.hasMany(StockMovement, { foreignKey: 'tenantId', as: 'stockMovements' });
StockMovement.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// User yang mencatat mutasi stok
User.hasMany(StockMovement, { foreignKey: 'userId', as: 'stockMovements' });
StockMovement.belongsTo(User, { foreignKey: 'userId', as: 'recordedBy' });

// MenuItem <-> StockItem (BOM: bahan baku per menu)
MenuItem.hasMany(MenuItemStock, { foreignKey: 'menuItemId', as: 'ingredients' });
MenuItemStock.belongsTo(MenuItem, { foreignKey: 'menuItemId', as: 'menuItem' });

StockItem.hasMany(MenuItemStock, { foreignKey: 'stockItemId', as: 'usedInMenus' });
MenuItemStock.belongsTo(StockItem, { foreignKey: 'stockItemId', as: 'stockItem' });

Tenant.hasMany(MenuItemStock, { foreignKey: 'tenantId', as: 'menuItemStocks' });
MenuItemStock.belongsTo(Tenant, { foreignKey: 'tenantId', as: 'tenant' });

// Initialize models
const db = {
  sequelize,
  Tenant,
  User,
  Message,
  MenuCategory,
  MenuItem,
  PromoCode,
  Member,
  Order,
  OrderItem,
  TenantPayment,
  RolePermission,
  PromoUsage,
  MemberPointHistory,
  StockUnit,
  StockCategory,
  StockItem,
  StockMovement,
  MenuItemStock,
};

// Sync database (create tables)
const syncDatabase = async () => {
  try {
    // Urutan sync: tabel yang tidak punya FK duluan, lalu tabel yang bergantung padanya
    await Member.sync({ alter: true });
    await PromoCode.sync({ alter: true });
    await PromoUsage.sync({ alter: true });
    await MemberPointHistory.sync({ alter: true });
    // Stock: unit & category dulu sebelum stockItem
    await StockUnit.sync({ alter: true });
    await StockCategory.sync({ alter: true });
    await StockItem.sync({ alter: true });
    await StockMovement.sync({ alter: true });
    await MenuItemStock.sync({ alter: true });
    // Sisanya melalui sequelize.sync
    await sequelize.sync({ alter: true });
    console.log('✅ Database synced successfully');
  } catch (error) {
    console.error('❌ Database sync failed:', error.message);
  }
};

module.exports = { db, syncDatabase };
