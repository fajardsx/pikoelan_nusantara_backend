const { DataTypes } = require("sequelize");
const { sequelize } = require("../config/db");

const User = sequelize.define(
  "User",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
    },
    // null hanya untuk superadmin platform (bukan milik satu tenant manapun)
    tenantId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: "tenants",
        key: "id",
      },
    },
    role: {
      type: DataTypes.ENUM(
        "superadmin",
        "owner",
        "manager",
        "staff",
        "kasir",
        "waiter",
        "kitchen",
      ),
      allowNull: false,
      defaultValue: "staff",
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [2, 100],
      },
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true,
      },
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        notEmpty: true,
        len: [6, 255],
      },
    },
    profilePicture: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    },
    // superadmin dianggap terverifikasi sejak dibuat (dibuat lewat CLI, bukan form publik)
    emailVerified: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    },
    emailVerificationToken: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    },
    emailVerificationExpires: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
    },
    resetPasswordToken: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
    },
    resetPasswordExpires: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
    },
  },
  {
    tableName: "users",
    timestamps: true, // Otomatis bikin createdAt & updatedAt
    underscored: true, // Use snake_case untuk column names
  },
);

module.exports = User;
