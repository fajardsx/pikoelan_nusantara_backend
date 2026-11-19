const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/db");

const MenuCategory = sequelize.define(
  "MenuCategory",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    tenantId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: "tenants", key: "id" },
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: { notEmpty: true, len: [1, 100] },
    },
    categoriesPicture: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    },
    sortOrder: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: 0,
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  },
  {
    tableName: "menu_categories",
    timestamps: true,
    underscored: true,
  },
);

module.exports = MenuCategory;
