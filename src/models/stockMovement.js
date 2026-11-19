const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/db');

// StockMovement = Riwayat mutasi stok (masuk, keluar, penyesuaian)
const StockMovement = sequelize.define(
  'StockMovement',
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
    stockItemId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: { model: 'stock_items', key: 'id' },
    },
    // User yang mencatat mutasi ini
    userId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: { model: 'users', key: 'id' },
    },
    // Jenis mutasi stok
    type: {
      type: DataTypes.ENUM('in', 'out', 'adjustment'),
      allowNull: false,
    },
    // Alasan / sub-tipe mutasi
    reason: {
      type: DataTypes.ENUM(
        'purchase',     // Pembelian bahan baku baru
        'production',   // Pemakaian untuk produksi / memasak
        'waste',        // Terbuang / kadaluarsa
        'return',       // Retur ke supplier
        'transfer',     // Transfer antar gudang (reserved, single-tenant saat ini)
        'adjustment',   // Penyesuaian manual (opname)
        'initial'       // Saldo awal saat pertama kali input
      ),
      allowNull: false,
      defaultValue: 'adjustment',
    },
    // Jumlah mutasi (selalu positif; tanda +/- ditentukan oleh `type`)
    quantity: {
      type: DataTypes.DECIMAL(14, 4),
      allowNull: false,
      validate: { min: 0.0001 },
    },
    // Stok sebelum mutasi ini terjadi (untuk audit trail)
    stockBefore: {
      type: DataTypes.DECIMAL(14, 4),
      allowNull: false,
    },
    // Stok setelah mutasi
    stockAfter: {
      type: DataTypes.DECIMAL(14, 4),
      allowNull: false,
    },
    // Harga per unit pada saat mutasi (untuk kalkulasi nilai stok)
    unitCost: {
      type: DataTypes.DECIMAL(14, 2),
      allowNull: true,
    },
    // Nilai total mutasi (quantity × unitCost)
    totalCost: {
      type: DataTypes.DECIMAL(14, 2),
      allowNull: true,
    },
    // Nomor referensi (mis. nomor PO, nomor opname, nomor pesanan)
    referenceNumber: {
      type: DataTypes.STRING(100),
      allowNull: true,
    },
    notes: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    // Tanggal efektif mutasi (jika berbeda dengan createdAt, mis. entry telat)
    movementDate: {
      type: DataTypes.DATEONLY,
      allowNull: false,
    },
  },
  {
    tableName: 'stock_movements',
    timestamps: true,
    underscored: true,
    indexes: [
      { fields: ['tenant_id', 'stock_item_id'] },
      { fields: ['tenant_id', 'movement_date'] },
    ],
  }
);

module.exports = StockMovement;

