const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

// StockItem = Data master bahan baku / ingredient
const StockItem = sequelize.define(
  'StockItem',
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
    // Kategori bahan baku (opsional)
    categoryId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: { model: 'stock_categories', key: 'id' },
    },
    // Satuan stok (wajib)
    unitId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: 'stock_units', key: 'id' },
    },
    // Kode SKU bahan baku (opsional, untuk identifikasi internal)
    sku: {
      type: DataTypes.STRING(60),
      allowNull: true,
    },
    name: {
      type: DataTypes.STRING(150),
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [1, 150],
      },
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    // Stok saat ini
    currentStock: {
      type: DataTypes.DECIMAL(14, 4),
      allowNull: false,
      defaultValue: 0,
    },
    // Stok minimum sebelum alarm low-stock muncul
    minimumStock: {
      type: DataTypes.DECIMAL(14, 4),
      allowNull: false,
      defaultValue: 0,
    },
    // Harga beli per satuan (opsional, untuk kalkulasi HPP)
    costPrice: {
      type: DataTypes.DECIMAL(14, 2),
      allowNull: true,
      defaultValue: 0,
    },
    // Supplier / vendor bahan baku (opsional, teks bebas)
    supplier: {
      type: DataTypes.STRING(200),
      allowNull: true,
    },
    // Catatan tambahan
    notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  },
  {
    tableName: 'stock_items',
    timestamps: true,
    underscored: true,
    indexes: [
      {
        unique: true,
        fields: ['tenant_id', 'name'],
      },
      {
        // Index non-unique untuk sku (boleh null, cukup unique per tenant jika diisi)
        fields: ['tenant_id', 'sku'],
      },
    ],
  }
);

module.exports = StockItem;

