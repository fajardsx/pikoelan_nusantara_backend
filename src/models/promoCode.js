const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

const PromoCode = sequelize.define('PromoCode', {
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
  code: {
    type: DataTypes.STRING(50),
    allowNull: false,
    set(val) {
      if (val) this.setDataValue('code', val.trim().toUpperCase());
    }
  },
  title: {
    type: DataTypes.STRING(150),
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  discountType: {
    type: DataTypes.ENUM('percentage', 'fixed'),
    allowNull: false,
    defaultValue: 'fixed'
  },
  discountValue: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false
  },
  minOrderAmount: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false,
    defaultValue: 0
  },
  maxDiscountAmount: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: true // null jika tidak ada batas maksimal potongan (misal fixed diskon)
  },
  usageLimit: {
    type: DataTypes.INTEGER,
    allowNull: true // null jika kuota pemakaian tidak dibatasi
  },
  usageCount: {
    type: DataTypes.INTEGER,
    allowNull: false,
    defaultValue: 0
  },
  startDate: {
    type: DataTypes.DATE,
    allowNull: true
  },
  endDate: {
    type: DataTypes.DATE,
    allowNull: true
  },
  applicableTier: {
    type: DataTypes.ENUM('all', 'bronze', 'silver', 'gold', 'platinum'),
    allowNull: false,
    defaultValue: 'all'
  },
  isActive: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: true
  }
}, {
  tableName: 'promo_codes',
  timestamps: true,
  underscored: true,
  indexes: [
    {
      unique: true,
      fields: ['tenant_id', 'code']
    }
  ]
});

module.exports = PromoCode;

