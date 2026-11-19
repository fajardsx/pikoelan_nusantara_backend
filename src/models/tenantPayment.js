const {DataTypes} = require("sequelize");
const {sequelize} = require("../config/db");

// Tenant = 1 restoran = 1 pelanggan SaaS
const TenantPayment = sequelize.define(
  "TenantPayment",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    tenantId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {model: "tenants", key: "id"},
    },
    // QRIS payment URL for the tenant, optional
    qrisUrl: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    },
    bankAccountName: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    bankAccountNumber: {
      type: DataTypes.STRING,
      allowNull: true,
      validate: {
        isNumeric: true,
        len: [5, 30],
      },
    },
    phoneConfirmation: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    deliveryDescription: {
      type: DataTypes.STRING,
      allowNull: true,
    },
  },
  {
    tableName: "tenant_payment",
    timestamps: true,
    underscored: true,
  },
);

module.exports = TenantPayment;
