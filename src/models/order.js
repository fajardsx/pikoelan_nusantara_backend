const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

const Order = sequelize.define('Order', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  tenantId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'tenants', key: 'id' }
  },
  // nomor pesanan yang enak dibaca kasir/staff, mis. ORD-20260721-0001
  orderNumber: {
    type: DataTypes.STRING,
    allowNull: false
  },
  orderType: {
    type: DataTypes.ENUM('dine_in', 'takeaway', 'delivery'),
    allowNull: false,
    defaultValue: 'dine_in'
  },
  tableNumber: {
    type: DataTypes.STRING,
    allowNull: true
  },
  customerName: {
    type: DataTypes.STRING,
    allowNull: true
  },
  status: {
    type: DataTypes.ENUM('new', 'proses', 'ready','deliver', 'completed', 'cancelled'),
    allowNull: false,
    defaultValue: 'new'
  },
  subtotal: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false,
    defaultValue: 0
  },
  discountAmount: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false,
    defaultValue: 0
  },
  totalAmount: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false,
    defaultValue: 0
  },
  memberId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: { model: 'members', key: 'id' }
  },
  promoCodeId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: { model: 'promo_codes', key: 'id' }
  },
  pointsEarned: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0
  },
  pointsRedeemed: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0
  },
  notes: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  // NEW: address for delivery orders
  address: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  // NEW: phone for delivery orders
  phone: {
    type: DataTypes.STRING,
    allowNull: true,
  },

  // dari mana pesanan ini dibuat - penting supaya staf tahu mana yang perlu direspons manual
  source: {
    type: DataTypes.ENUM('staff', 'waiter','customer'),
    allowNull: false,
    defaultValue: 'staff'
  },
  // staff yang membuat/menangani pesanan ini
  createdBy: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: { model: 'users', key: 'id' }
  },

  // NEW: metode pembayaran yang dipilih (contoh: 'credit_card', 'paypal', dsb.)
  paymentMethod: {
    type: DataTypes.ENUM('qrcode', 'cash','transfer'),
    allowNull: true
  },
  // NEW: flag indicating payment confirmation
  paymentConfirmation: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false,
  },


}, {
  tableName: 'orders',
  timestamps: true,
  underscored: true
});

module.exports = Order;

