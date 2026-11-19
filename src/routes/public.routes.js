const express = require('express');
const router = express.Router();
const {
  getOrdersPublic,
  cancelPublicOrder,
  createPublicOrder,
  validatePublicPromo,
  lookupPublicMember,
} = require('../controllers/order.controller');
const { getPublicMenu } = require('../controllers/menu.controller');
const { publicOrderLimiter } = require('../middleware/rateLimit.middleware');

// Menu digital publik, diakses lewat QR code di meja - tanpa login
router.get('/menu/:slug', getPublicMenu);

router.get('/menu/:slug/my_orders', getOrdersPublic);

// Pelanggan pesan langsung dari menu digital - tanpa login, dibatasi rate limit
router.post('/menu/:slug/order', publicOrderLimiter, createPublicOrder);
router.delete('/menu/:slug/order', cancelPublicOrder);

// Validasi kode promo & cek status member dari menu digital publik
router.post('/menu/:slug/promo/validate', validatePublicPromo);
router.get('/menu/:slug/member/lookup', lookupPublicMember);

module.exports = router;
