const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

const MemberPointHistory = sequelize.define('MemberPointHistory', {
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
  memberId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: { model: 'members', key: 'id' }
  },
  orderId: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: { model: 'orders', key: 'id' }
  },
  type: {
    type: DataTypes.ENUM('earn', 'redeem', 'adjustment'),
    allowNull: false,
    defaultValue: 'earn'
  },
  points: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  description: {
    type: DataTypes.STRING(255),
    allowNull: true
  }
}, {
  tableName: 'member_point_histories',
  timestamps: true,
  underscored: true
});

module.exports = MemberPointHistory;

