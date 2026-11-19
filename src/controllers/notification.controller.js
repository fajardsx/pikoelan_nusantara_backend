const {sendResponse} = require("../utils/response");
const {subscribe, getSseStats} = require("../utils/sse");

const isValidTenantId = (value) => /^\d+$/.test(String(value || ""));

// ============== STREAM NOTIFIKASI ORDER (SSE) ==============
// Event yang dikirim:
//   connected            -> handshake, berisi clientId & tenantId
//   order.created        -> ada order baru (staff maupun pelanggan)
//   order.status_updated -> kasir/dapur mengubah status atau paymentMethod
//   order.cancelled      -> pelanggan membatalkan order lewat menu digital
//
// Endpoint ini hanya satu arah (server -> klien). Untuk aksi tulis (buat order,
// ubah status) tetap pakai REST seperti biasa.
const streamOrderNotifications = (req, res) => {
  const isSuperadmin = req.user.role === "superadmin";

  // Staff hanya boleh mendengarkan tenant miliknya. Superadmin tidak punya
  // tenant, jadi harus menyebutkan ?tenantId= secara eksplisit.
  const tenantId = isSuperadmin ? req.query.tenantId : req.user.tenantId;

  if (!tenantId) {
    return sendResponse(
      res,
      400,
      false,
      isSuperadmin
        ? "tenantId query parameter is required for superadmin"
        : "User is not associated with any restaurant",
    );
  }

  if (isSuperadmin && !isValidTenantId(tenantId)) {
    return sendResponse(res, 400, false, "tenantId must be a number");
  }

  const result = subscribe({tenantId, userId: req.user.id, res});

  if (result.error) {
    return sendResponse(res, 429, false, result.error);
  }

  // Setelah subscribe() sukses, response sudah menjadi stream - jangan kirim
  // JSON lagi. Pembersihan koneksi ditangani oleh utils/sse.js.
};

// ============== MONITORING (superadmin) ==============
const getNotificationStats = (req, res) => {
  return sendResponse(res, 200, true, "SSE stats retrieved successfully", getSseStats());
};

module.exports = {
  streamOrderNotifications,
  getNotificationStats,
};
