const {sendResponse} = require("../utils/response");
const {db} = require("../models");
const {Op} = require("sequelize");
// Temporary in-memory storage (sama dengan di auth.controller.js)
// Nanti kalau pakai database, import dari database
// const users = require('./auth.controller');
// import shared users array
//const users = require("../data/users");
const User = db.User;
// Get all users
const getAllUsers = async (req, res) => {
  try {
    // Remove passwords from response
    // const usersWithoutPasswords = users.map(user => {
    //   const { password, ...userWithoutPassword } = user;
    //   return userWithoutPassword;
    // });
    const users = await User.findAll({
      where: {
        id: {
          [Op.ne]: req.user.id,
        },
        // scoping: staff hanya boleh lihat sesama staff di restoran yang sama
        tenantId: req.user.tenantId,
      },
      attributes: {exclude: ["password"]},
      order: [["created_at", "DESC"]],
    });

    return sendResponse(res, 200, true, "Users retrieved successfully", {
      users,
      total: users.length,
    });
  } catch (error) {
    console.error("Get all users error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// Get user by ID
const getUserById = async (req, res) => {
  try {
    const {id} = req.params;

    const user = await User.findOne({
      where: { id, tenantId: req.user.tenantId }, // cegah akses user milik tenant lain
      attributes: {exclude: ["password"]},
    });

    if (!user) {
      return sendResponse(res, 404, false, "User not found");
    }

    return sendResponse(res, 200, true, "User retrieved successfully", {
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    });
  } catch (error) {
    console.error("Get user by ID error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// Update user (own profile)
const updateUser = async (req, res) => {
  try {
    const {id} = req.params;
    const {name, email} = req.body;

    // Authorization
    if (parseInt(id) !== req.user.id) {
      return sendResponse(
        res,
        403,
        false,
        "You can only update your own profile",
      );
    }

    // Find User
    const user = await User.findByPk(id);
    if (!user) {
      return sendResponse(res, 404, false, "User not found");
    }

    // Check if email already exists
    if (email && email !== user.email) {
      const existingUser = await User.findOne({where: {email}});
      if (existingUser) {
        return sendResponse(res, 400, false, "Email already in use");
      }
    }

    // Update User
    await user.update({
      name: name || user.name,
      email: email || user.email,
    });

    return sendResponse(res, 200, true, "Profile updated successfully", {
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      },
    });
  } catch (error) {
    console.error("Update user error:", error);
    if (error.name == "SequelizeValidationError") {
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, "Server error");
  }
};

// Delete user
const deleteUser = async (req, res) => {
  try {
    const {id} = req.params;

    // Authorization
    if (parseInt(id) !== req.user.id) {
      return sendResponse(
        res,
        403,
        false,
        "You can only update your own profile",
      );
    }

    // Find User
    const user = await User.findByPk(id);
    if (!user) {
      return sendResponse(res, 404, false, "User not found");
    }

    // Delete user
    await user.destroy();

    return sendResponse(res, 200, true, "Account deleted successfully", {
      deletedUser: {
        id: user.id,
        email: user.email,
      },
    });
  } catch (error) {}
};

module.exports = {
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser,
};
