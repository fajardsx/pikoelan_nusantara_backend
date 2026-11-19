const express = require("express");
const router = express.Router();
const {
  register,
  login,
  getProfile,
  changePassword,
  verifyEmail,
  resendVerification,
  forgotPassword,
  resetPassword,
} = require("../controllers/auth.controller");
const authMiddleware = require("../middleware/auth.middleware");
const { loginLimiter, emailActionLimiter } = require("../middleware/rateLimit.middleware");

// Public routes
router.post("/register", register);
router.post("/login", loginLimiter, login);

// Verifikasi email & lupa password (semua dibatasi rate biar tidak disalahgunakan untuk spam)
router.post("/verify-email", verifyEmail);
router.post("/resend-verification", emailActionLimiter, resendVerification);
router.post("/forgot-password", emailActionLimiter, forgotPassword);
router.post("/reset-password", resetPassword);

// Protected routes (butuh token)
router.get("/profile", authMiddleware, getProfile);
router.put("/change-password", authMiddleware, changePassword);

module.exports = router;
