const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    dialect: 'postgres',
    logging: process.env.NODE_ENV === 'development'? console.log : false,
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    },
    dialectOptions: {
      ssl: process.env.DB_SSL === 'true' ? {
        require: true,
        rejectUnauthorized: false
      } : false
    }
  }
);

// Test the connection with error handling
const testConnection = async () => {
  try {
    await sequelize.authenticate();
    // console.log('✅ Database connected successfully');
  } catch (err) {
    // console.error('❌ Database connection error:', err);
    process.exit(1); // Exit if we can't connect to database
  }
};

testConnection();

module.exports = sequelize;