const jwt = require('jsonwebtoken');
const { sendResponse } = require('../utils/response');

// Khusus endpoint SSE.
// Browser hanya punya EventSource untuk konsumsi SSE, dan EventSource TIDAK
// bisa mengirim header Authorization. Karena itu token boleh dikirim lewat
// query `?token=...`. Header `Authorization: Bearer ...` tetap didukung untuk
// klien non-browser (curl, Node, mobile).
//
// Catatan keamanan: token di query string bisa tercatat di access log / history.
// Kalau itu jadi masalah, pakai endpoint tiket sekali-pakai (short-lived token)
// sebelum membuka stream.
const sseAuthMiddleware = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    let token = null;

    if (authHeader && authHeader.startsWith('Bearer ')) {
      token = authHeader.split(' ')[1];
    } else if (typeof req.query.token === 'string' && req.query.token.trim() !== '') {
      token = req.query.token.trim();
    }

    if (!token) {
      return sendResponse(res, 401, false, 'No token provided');
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;

    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return sendResponse(res, 401, false, 'Token expired');
    }
    return sendResponse(res, 401, false, 'Invalid token');
  }
};

module.exports = sseAuthMiddleware;
