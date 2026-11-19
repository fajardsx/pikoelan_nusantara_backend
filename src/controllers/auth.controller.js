const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const {Op} = require("sequelize");
const {sendResponse} = require("../utils/response");
const {generateToken, hashToken} = require("../utils/token");
const {sendVerificationEmail, sendPasswordResetEmail} = require("../utils/email");
const {db} = require("../models");

// shared users array
const User = db.User;

// Temporary in-memory storage (nanti ganti dengan database)

// Register user
// CATATAN MULTI-TENANT: endpoint ini sekarang hanya untuk kasus khusus
// (mis. superadmin platform tanpa tenant). Untuk daftar restoran baru,
// gunakan POST /api/tenants/register (buat tenant + owner sekaligus).
// Untuk tambah staff ke restoran yang sudah ada, gunakan POST /api/tenants/staff.
const register = async (req, res) => {
  try {
    const {name, email, password} = req.body;

    // Validation
    if (!name || !email || !password) {
      return sendResponse(
        res,
        400,
        false,
        "Please provide all required fields"
      );
    }

    // Check if user already exists
    const existingUser = await User.findOne({where:{email}});
    if (existingUser) {
      return sendResponse(res, 400, false, "User already exists");
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create(
      {
        name,
        email,
        password:hashedPassword
      }
    )

    // Generate JWT token
    const token = jwt.sign(
      {id: user.id, email: user.email, tenantId: user.tenantId, role: user.role},
      process.env.JWT_SECRET,
      {expiresIn: process.env.JWT_EXPIRE}
    );

    return sendResponse(res, 201, true, "User registered successfully", {
      user: {
        id:user.id,
        name:user.name,
        email:user.email,
        role:user.role,
        tenantId:user.tenantId,
        createdAt:user.createdAt
      },
      token,
    });
  } catch (error) {
    console.error("Register error:", error);
    if(error.name === 'SequelizeValidationError'){
      return sendResponse(res, 400, false, error.errors[0].message);
    }
    return sendResponse(res, 500, false, "Server error");
  }
};

// Login user
const login = async (req, res) => {
  try {
    const {email, password} = req.body;

    // Validation
    if (!email || !password) {
      return sendResponse(res, 400, false, "Please provide email and password");
    }

    // Find user
    //const user = users.find((u) => u.email === email);
    const user = await User.findOne({where:{email}});
    if (!user) {
      return sendResponse(res, 400, false, "Invalid credentials");
    }

    // Check password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return sendResponse(res, 400, false, "Invalid credentials");
    }

    // Generate JWT token (tenantId & role dibawa supaya request berikutnya
    // otomatis ter-scope ke restoran yang benar)
    const token = jwt.sign(
      {id: user.id, email: user.email, tenantId: user.tenantId, role: user.role},
      process.env.JWT_SECRET,
      {expiresIn: process.env.JWT_EXPIRE}
    );

    return sendResponse(res, 200, true, "Login successful", {
      user: {
        id:user.id,
        name:user.name,
        email:user.email,
        role:user.role,
        tenantId:user.tenantId,
        createdAt:user.createdAt
      },
      token,
    });
  } catch (error) {
    console.error("Login error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// Get current user profile
const getProfile = async (req, res) => {
  try {
    // req.user sudah diisi oleh authMiddleware
    //const user = users.find((u) => u.id === req.user.id);
    const user = await User.findByPk(req.user.id,{
      attributes:{exclude:['password']}// exclude password dari response
    })

    if (!user) {
      return sendResponse(res, 404, false, "User not found");
    }

    // const {password: _, ...userWithoutPassword} = user;
    const profilePictureUrl = user.profilePicture || null;

    return sendResponse(res, 200, true, "Profile retrieved successfully", {
      user: {
        id:user.id,
        name:user.name,
        email:user.email,
        role:user.role,
        tenantId:user.tenantId,
        emailVerified:user.emailVerified,
        profilePicture:user.profilePicture,
        profilePictureUrl:profilePictureUrl,
        createdAt:user.createdAt,
        updatedAt:user.updatedAt
      },
    });
  } catch (error) {
    console.error("Get profile error:", error);
    return sendResponse(res, 500, false, "Server error");
  }
};

// Change Password
const changePassword = async (req,res)=>{
  try {
    const {currentPassword, newPassword} = req.body;

    // Validation
    if(!currentPassword || !newPassword){
      return sendResponse(res,400,false,'Please provide current and new password');
    }
    if (newPassword.length < 6) {
      return sendResponse(res, 400, false, 'New password must be at least 6 characters');
    }

    // Find user
    const user = await User.findByPk(req.user.id);
    if (!user) {
      return sendResponse(res, 404, false, 'User not found');
    }

    // Verify current password
    const isPasswordValid = await bcrypt.compare(currentPassword, user.password);
    if (!isPasswordValid) {
      return sendResponse(res, 401, false, 'Current password is incorrect');
    }

    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update password
    await user.update({ password: hashedPassword });

    return sendResponse(res, 200, true, 'Password changed successfully');

  } catch (error) {
    console.error('Change password error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
}

// ============== Verifikasi email (dari link yang dikirim saat daftar) ==============
const verifyEmail = async (req, res) => {
  try {
    const { token } = req.body;
    if (!token) {
      return sendResponse(res, 400, false, 'Verification token is required');
    }

    const hashedToken = hashToken(token);
    const user = await User.findOne({
      where: {
        emailVerificationToken: hashedToken,
        emailVerificationExpires: { [Op.gt]: new Date() },
      },
    });

    if (!user) {
      return sendResponse(res, 400, false, 'Verification link is invalid or has expired');
    }

    await user.update({
      emailVerified: true,
      emailVerificationToken: null,
      emailVerificationExpires: null,
    });

    // owner yang emailnya baru diverifikasi -> aktifkan restorannya
    if (user.role === 'owner' && user.tenantId) {
      await db.Tenant.update({ isActive: true }, { where: { id: user.tenantId } });
    }

    return sendResponse(res, 200, true, 'Email verified successfully');
  } catch (error) {
    console.error('Verify email error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== Kirim ulang email verifikasi ==============
const resendVerification = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return sendResponse(res, 400, false, 'Email is required');
    }

    const user = await User.findOne({ where: { email } });

    // Respons yang sama baik email ada atau tidak, supaya tidak bisa dipakai
    // untuk menebak-nebak email mana saja yang terdaftar.
    const genericMessage = 'If that email is registered and not yet verified, a new verification link has been sent.';

    if (!user || user.emailVerified) {
      return sendResponse(res, 200, true, genericMessage);
    }

    const { rawToken, hashedToken } = generateToken();
    await user.update({
      emailVerificationToken: hashedToken,
      emailVerificationExpires: new Date(Date.now() + 24 * 60 * 60 * 1000),
    });

    await sendVerificationEmail(user, rawToken);

    return sendResponse(res, 200, true, genericMessage);
  } catch (error) {
    console.error('Resend verification error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== Lupa password: kirim link reset ==============
const forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return sendResponse(res, 400, false, 'Email is required');
    }

    const user = await User.findOne({ where: { email } });
    const genericMessage = 'If that email is registered, a password reset link has been sent.';

    // Sengaja tidak bilang "email tidak ditemukan" - mencegah orang lain
    // memeriksa email siapa saja yang punya akun di sistem ini.
    if (!user) {
      return sendResponse(res, 200, true, genericMessage);
    }

    const { rawToken, hashedToken } = generateToken();
    await user.update({
      resetPasswordToken: hashedToken,
      resetPasswordExpires: new Date(Date.now() + 60 * 60 * 1000), // 1 jam
    });

    await sendPasswordResetEmail(user, rawToken);

    return sendResponse(res, 200, true, genericMessage);
  } catch (error) {
    console.error('Forgot password error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

// ============== Reset password pakai token dari email ==============
const resetPassword = async (req, res) => {
  try {
    const { token, newPassword } = req.body;
    if (!token || !newPassword) {
      return sendResponse(res, 400, false, 'Token and new password are required');
    }
    if (newPassword.length < 6) {
      return sendResponse(res, 400, false, 'New password must be at least 6 characters');
    }

    const hashedToken = hashToken(token);
    const user = await User.findOne({
      where: {
        resetPasswordToken: hashedToken,
        resetPasswordExpires: { [Op.gt]: new Date() },
      },
    });

    if (!user) {
      return sendResponse(res, 400, false, 'Reset link is invalid or has expired');
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await user.update({
      password: hashedPassword,
      resetPasswordToken: null,
      resetPasswordExpires: null,
    });

    return sendResponse(res, 200, true, 'Password reset successfully. You can now log in with your new password.');
  } catch (error) {
    console.error('Reset password error:', error);
    return sendResponse(res, 500, false, 'Server error');
  }
};

module.exports = {
  register,
  login,
  getProfile,
  changePassword,
  verifyEmail,
  resendVerification,
  forgotPassword,
  resetPassword,
};
