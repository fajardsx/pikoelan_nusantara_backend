const { Sequelize } = require('sequelize');
require('dotenv').config();

console.log('🔍 Checking DATABASE_URL...');
console.log('DATABASE_URL exists:', !!process.env.DATABASE_URL);

if (!process.env.DATABASE_URL) {
  console.error('❌ DATABASE_URL is not set in .env file');
  process.exit(1);
}

// Hide password in logs
const maskedUrl = process.env.DATABASE_URL.replace(/:([^@]+)@/, ':****@');
console.log('📡 Connecting to:', maskedUrl);

// Create Sequelize instance
const sequelize = new Sequelize(process.env.DATABASE_URL, {
  dialect: 'postgres',
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false // Untuk Supabase
    }
  },
  logging: console.log, // Set true untuk lihat SQL queries di console
  pool: {
    max: 5,
    min: 0,
    acquire: 30000,
    idle: 10000
  }
});

// Test connection
const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Database connection established successfully');
  } catch (error) {
    console.error('❌ Unable to connect to database:', error.message);
    console.error('Error name:', error.name);
    console.error('Error message:', error.message);
    process.exit(1);
  }
};

module.exports = { sequelize, testConnection };