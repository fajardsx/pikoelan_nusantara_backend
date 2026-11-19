const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/db");

// Tenant = 1 restoran = 1 pelanggan SaaS
const Tenant = sequelize.define(
  "Tenant",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    ownerId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "users",
        key: "id",
      },
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [2, 150],
      },
    },
    // dipakai untuk identifikasi tenant di URL/subdomain (mis. warung-bu-siti)
    slug: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        notEmpty: true,
        is: /^[a-z0-9-]+$/, // hanya huruf kecil, angka, strip
      },
    },
    address: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    phone: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    email: {
      type: DataTypes.STRING,
      allowNull: true,
      validate: { isEmail: true },
    },
    logoUrl: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    },
    // QRIS payment URL for the tenant, optional
    qrisUrl: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    },
    bankAccountNumber: {
      type: DataTypes.STRING,
      allowNull: true,
      validate: {
        isNumeric: true,
        len: [5, 30],
      },
    },
    // paket langganan, siap dipakai untuk fitur billing nanti
    plan: {
      type: DataTypes.ENUM("free", "basic", "pro"),
      allowNull: false,
      defaultValue: "free",
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: true,
    },
  },
  {
    tableName: "tenants",
    timestamps: true,
    underscored: true,
  },
);

module.exports = Tenant;
