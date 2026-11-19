const crypto = require('crypto');

// Bikin token acak yang dikirim ke email (mentah), plus versi hash-nya yang disimpan di DB.
// Yang disimpan di DB SELALU versi hash - supaya kalau database bocor, token asli tidak ikut bocor.
const generateToken = () => {
  const rawToken = crypto.randomBytes(32).toString('hex');
  const hashedToken = crypto.createHash('sha256').update(rawToken).digest('hex');
  return { rawToken, hashedToken };
};

const hashToken = (rawToken) => crypto.createHash('sha256').update(rawToken).digest('hex');

module.exports = { generateToken, hashToken };
