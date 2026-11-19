// Jalankan sekali lewat terminal untuk membuat akun superadmin pertama:
//   node src/scripts/seed-superadmin.js "Nama Admin" admin@example.com passwordRahasia
//
// Sengaja TIDAK dibuat sebagai endpoint API publik - superadmin punya akses
// ke semua tenant, jadi pembuatannya harus lewat akses server langsung.
require('dotenv').config();
const bcrypt = require('bcryptjs');
const { db, syncDatabase } = require('../models');

const run = async () => {
  const [, , name, email, password] = process.argv;

  if (!name || !email || !password) {
    console.log('Usage: node src/scripts/seed-superadmin.js "Nama Admin" admin@example.com password123');
    process.exit(1);
  }

  await syncDatabase();

  const existing = await db.User.findOne({ where: { email } });
  if (existing) {
    console.log(`User with email ${email} already exists.`);
    process.exit(1);
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  const user = await db.User.create({
    name,
    email,
    password: hashedPassword,
    role: 'superadmin',
    tenantId: null,
  });

  console.log(`✅ Superadmin created: ${user.email} (id: ${user.id})`);
  process.exit(0);
};

run().catch((err) => {
  console.error('Failed to seed superadmin:', err);
  process.exit(1);
});
