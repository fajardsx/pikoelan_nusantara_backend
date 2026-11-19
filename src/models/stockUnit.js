const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

// StockUnit = Satuan pengukuran bahan baku (gram, kg, liter, ml, pcs, lusin, dll.)
const StockUnit = sequelize.define(
  'StockUnit',
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
    // Nama satuan, mis: "Kilogram", "Liter", "Pcs"
    name: {
      type: DataTypes.STRING(100),
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [1, 100],
      },
    },
    // Singkatan/simbol satuan, mis: "kg", "L", "pcs"
    symbol: {
      type: DataTypes.STRING(20),
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [1, 20],
      },
    },
    // Faktor konversi ke satuan dasar (opsional, untuk keperluan laporan terpadu)
    // Contoh: 1 kg = 1000 gram → conversionFactor = 1000 jika baseUnit = 'gram'
    conversionFactor: {
      type: DataTypes.DECIMAL(14, 6),
      allowNull: true,
      defaultValue: 1,
    },
    // Satuan dasar yang menjadi referensi konversi (opsional)
    baseUnit: {
      type: DataTypes.STRING(20),
      allowNull: true,
    },
    description: {
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
    tableName: 'stock_units',
    timestamps: true,
    underscored: true,
    indexes: [
      {
        unique: true,
        fields: ['tenant_id', 'symbol'],
      },
    ],
  }
);

module.exports = StockUnit;

