const rateLimit = require('express-rate-limit');

const makeLimiter = (windowMinutes, max, message) => rateLimit({
  windowMs: windowMinutes * 60 * 1000,
  max,
  standardHeaders: true,
  legacyHeaders: false,
  message: { code: 429, success: false, message },
});

// Login: batasi percobaan biar tidak bisa brute-force password
const loginLimiter = makeLimiter(15, 10, 'Terlalu banyak percobaan masuk. Coba lagi dalam beberapa menit.');

// Daftar restoran baru: cegah bot bikin tenant spam
const registerLimiter = makeLimiter(60, 5, 'Terlalu banyak percobaan pendaftaran dari alamat ini. Coba lagi nanti.');

// Lupa password / kirim ulang verifikasi: cegah orang lain nge-spam inbox orang lain
const emailActionLimiter = makeLimiter(60, 5, 'Terlalu banyak permintaan. Coba lagi dalam 1 jam.');

// Pesan lewat menu digital publik: cegah orang iseng nge-spam pesanan ke dapur
const publicOrderLimiter = makeLimiter(10, 8, 'Terlalu banyak pesanan dari perangkat ini. Coba lagi dalam beberapa menit.');

module.exports = { loginLimiter, registerLimiter, emailActionLimiter, publicOrderLimiter };
