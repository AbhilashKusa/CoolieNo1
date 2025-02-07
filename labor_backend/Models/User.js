const { DataTypes } = require('sequelize');
const sequelize = require('../Config/database');
const bcrypt = require('bcrypt');
const logger = require('../logger'); // Import the Winston logger

/**
 * 🗄️ Define the User Model
 * This model represents the structure of the 'users' table.
 * It includes fields for user details and security features like password hashing.
 */
const User = sequelize.define('users', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [2, 255],
    },
  },
  mobile: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
      len: [10, 15], // Updated mobile number length
    },
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
    validate: {
      isEmail: true,
      notEmpty: true,
    },
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false,
    validate: {
      notEmpty: true,
    },
  },
  role: {
    type: DataTypes.STRING,
    allowNull: false,
    defaultValue: 'laborer', // Default role for users
  },
  isEmailVerified: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  lastLogin: {
    type: DataTypes.DATE,
  },
}, {
  timestamps: true,       // Automatically adds createdAt & updatedAt timestamps
  tableName: 'users',     // Use lowercase table name to match your stored procedure
  hooks: {
    // 🔐 Hash password before creating a new user
    beforeCreate: async (user) => {
      try {
        logger.info(`🔧 Hashing password for user: ${user.email}`);
        user.password = await bcrypt.hash(user.password, 10);
      } catch (error) {
        logger.error(`❌ Error hashing password for user: ${user.email} - ${error.message}`);
        throw error;
      }
    },
    // 🔐 Hash password before updating a user
    beforeUpdate: async (user) => {
      if (user.changed('password')) {
        try {
          logger.info(`🔧 Hashing updated password for user: ${user.email}`);
          user.password = await bcrypt.hash(user.password, 10);
        } catch (error) {
          logger.error(`❌ Error hashing updated password for user: ${user.email} - ${error.message}`);
          throw error;
        }
      }
    },
  },
});

/**
 * 🔍 Validate Password
 * Compares the hashed password stored in the database with the entered password.
 */
User.prototype.validatePassword = async function(password) {
  return bcrypt.compare(password, this.password);
};

// 🚀 Sync Model with Database
sequelize.sync()
  .then(() => console.log('✅ User table synced successfully'))
  .catch((err) => console.error('❌ Error syncing User table:', err));


module.exports = User;
