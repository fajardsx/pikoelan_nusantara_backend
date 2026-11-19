const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

const PromoUsage = sequelize.define('PromoUsage', {
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
  promoId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'promo_codes', key: 'id' }
  },
  orderId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'orders', key: 'id' }
  },
  memberId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: { model: 'members', key: 'id' }
  },
  discountAmount: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false,
    defaultValue: 0
  },
  orderAmount: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false,
    defaultValue: 0
  }
}, {
  tableName: 'promo_usages',
  timestamps: true,
  underscored: true
});

module.exports = PromoUsage;

