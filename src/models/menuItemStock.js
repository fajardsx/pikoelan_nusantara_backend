const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

// MenuItemStock = Relasi berapa banyak bahan baku yang dipakai per 1 porsi menu item
// (Bill of Materials / BOM sederhana)
const MenuItemStock = sequelize.define(
  'MenuItemStock',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    tenantId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: 'tenants', key: 'id' },
    },
    menuItemId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: 'menu_items', key: 'id' },
    },
    stockItemId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: 'stock_items', key: 'id' },
    },
    // Jumlah bahan baku yang dikonsumsi per 1 porsi menu item
    quantityPerServing: {
      type: DataTypes.DECIMAL(14, 4),
      allowNull: false,
      validate: { min: 0.0001 },
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: 'menu_item_stocks',
    timestamps: true,
    underscored: true,
    indexes: [
      {
        unique: true,
        fields: ['menu_item_id', 'stock_item_id'],
      },
    ],
  }
);

module.exports = MenuItemStock;

