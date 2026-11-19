const express = require("express");
const router = express.Router();
const {
  streamOrderNotifications,
  getNotificationStats,
} = require("../controllers/notification.controller");
const sseAuthMiddleware = require("../middleware/sseAuth.middleware");
const {requireRole} = require("../middleware/tenant.middleware");

// Notifikasi realtime order untuk dashboard kasir/dapur.
// Browser: new EventSource(`${API_URL}/api/notifications/orders/stream?token=${jwt}`)
// Non-browser: header Authorization: Bearer <jwt>
router.get("/orders/stream", sseAuthMiddleware, streamOrderNotifications);

// Monitoring jumlah koneksi SSE aktif (superadmin)
router.get(
  "/stats",
  sseAuthMiddleware,
  requireRole("superadmin"),
  getNotificationStats,
);

module.exports = router;
