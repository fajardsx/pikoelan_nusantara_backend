const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

// Junction table for many‑to‑many relationship between MenuItem and MenuCategory
const MenuItemCategory = sequelize.define(
  'MenuItemCategory',
  {
    menuItemId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: 'menu_items', key: 'id' },
    },
    menuCategoryId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: 'menu_categories', key: 'id' },
    },
  },
  {
    tableName: 'menu_item_categories',
    timestamps: false,
    underscored: true,
  }
);

module.exports = MenuItemCategory;
