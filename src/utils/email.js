const nodemailer = require('nodemailer');

// ============================================================
// Setup Gmail SMTP
// Di .env butuh:
//   EMAIL_USER=akunkamu@gmail.com
//   EMAIL_PASS=app_password_16_digit   (BUKAN password Gmail biasa!)
//   EMAIL_FROM="Menu Maju <akunkamu@gmail.com>"   (opsional, default pakai EMAIL_USER)
//   FRONTEND_URL=http://localhost:5500   (alamat frontend, dipakai untuk link di email)
//
// Cara bikin App Password Gmail:
//   1. Aktifkan verifikasi 2 langkah di akun Google kamu
//   2. Buka https://myaccount.google.com/apppasswords
//   3. Bikin app password baru, pilih "Mail", copy 16 digit yang muncul
//   4. Pakai itu sebagai EMAIL_PASS (bukan password akun Google kamu)
// ============================================================

let transporter = null;

const getTransporter = () => {
  if (transporter) return transporter;

  if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
    console.warn('⚠️  EMAIL_USER / EMAIL_PASS belum diset di .env - email tidak akan terkirim (hanya dicetak ke console).');
    return null;
  }

  transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });
  return transporter;
};

const sendEmail = async ({ to, subject, html }) => {
  const t = getTransporter();

  if (!t) {
    // Fallback dev: kalau SMTP belum dikonfigurasi, tampilkan isinya di console
    // supaya development tetap bisa jalan tanpa akun Gmail asli.
    console.log('\n📧 [EMAIL DEV MODE] Email tidak benar-benar dikirim. Isi email:');
    console.log(`To: ${to}\nSubject: ${subject}\n${html}\n`);
    return;
  }

  await t.sendMail({
    from: process.env.EMAIL_FROM || process.env.EMAIL_USER,
    to,
    subject,
    html,
  });
};

const FRONTEND_URL = (process.env.FRONTEND_URL || 'http://localhost:5500').replace(/\/$/, '');

const sendVerificationEmail = async (user, rawToken) => {
  const link = `${FRONTEND_URL}/verify-email.html?token=${rawToken}`;
  await sendEmail({
    to: user.email,
    subject: 'Verifikasi email restoranmu',
    html: `
      <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto;">
        <h2>Halo, ${user.name}</h2>
        <p>Terima kasih sudah mendaftar. Sebelum bisa mulai pakai dasbor restoranmu, verifikasi dulu email ini ya.</p>
        <p><a href="${link}" style="display:inline-block; background:#3F6B4F; color:#fff; padding:10px 18px; border-radius:6px; text-decoration:none;">Verifikasi Email</a></p>
        <p style="font-size:12px; color:#888;">Atau salin tautan ini ke browser: ${link}</p>
        <p style="font-size:12px; color:#888;">Tautan ini berlaku 24 jam.</p>
      </div>
    `,
  });
};

const sendPasswordResetEmail = async (user, rawToken) => {
  const link = `${FRONTEND_URL}/reset-password.html?token=${rawToken}`;
  await sendEmail({
    to: user.email,
    subject: 'Atur ulang kata sandi',
    html: `
      <div style="font-family: sans-serif; max-width: 480px; margin: 0 auto;">
        <h2>Halo, ${user.name}</h2>
        <p>Ada permintaan untuk mengatur ulang kata sandi akunmu. Kalau ini bukan kamu, abaikan saja email ini.</p>
        <p><a href="${link}" style="display:inline-block; background:#3F6B4F; color:#fff; padding:10px 18px; border-radius:6px; text-decoration:none;">Atur Ulang Kata Sandi</a></p>
        <p style="font-size:12px; color:#888;">Atau salin tautan ini ke browser: ${link}</p>
        <p style="font-size:12px; color:#888;">Tautan ini berlaku 1 jam.</p>
      </div>
    `,
  });
};

module.exports = { sendEmail, sendVerificationEmail, sendPasswordResetEmail };
