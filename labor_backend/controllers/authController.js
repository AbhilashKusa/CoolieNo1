const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
require('dotenv').config();
const sequelize = require('../Config/database');
const logger = require('../logger');
const JWT_SECRET = process.env.JWT_SECRET;

// Register Controller
exports.register = async (req, res) => {
    const transaction = await sequelize.transaction();
    try {
        const { name, mobile, email, password, role } = req.body;
        
        logger.info(`🔧 Attempting registration for: ${email}`);

        // Basic validation
        if (!name || !mobile || !email || !password) {
            await transaction.rollback();
            logger.warn('⚠️ Registration failed: All fields are required');
            return res.status(400).json({ error: 'All fields are required' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const [result] = await sequelize.query(
            `SELECT * FROM register_user($1, $2, $3, $4, $5)`,
            {
                bind: [name.trim(), mobile.trim(), email.trim().toLowerCase(), hashedPassword, role?.trim() || 'laborer'],
                type: sequelize.QueryTypes.SELECT,
                transaction
            }
        );

        await transaction.commit();

        if (!result || !result[0] || !result[0].new_user_id) {
            const errorMessage = result?.[0]?.message || 'Registration failed';
            logger.warn(`⚠️ Registration failed for ${email}: ${errorMessage}`);
            return res.status(400).json({ error: errorMessage });
        }

        const token = jwt.sign(
            { userId: result[0].new_user_id, email: email.trim().toLowerCase() },
            JWT_SECRET,
            { expiresIn: '1h' }
        );

        logger.info(`✅ Successfully registered user: ${email}`);
        res.status(201).json({
            message: 'User registered successfully',
            token,
            userId: result[0].new_user_id
        });

    } catch (error) {
        await transaction.rollback();
        logger.error(`❌ Registration error for ${email}: ${error.message}`);
        res.status(500).json({ 
            error: 'Internal server error',
            details: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// Login Controller
exports.login = async (req, res) => {
    const { email, password } = req.body;

    try {
        logger.info(`🔐 Logging in user: ${email}`);

        const query = `SELECT * FROM login_user($1)`;
        const replacements = [email.trim().toLowerCase()];

        const [result] = await sequelize.query(query, {
            bind: replacements,
            type: sequelize.QueryTypes.SELECT,
        });

        if (!result || !result[0] || !result[0].user_id) {
            logger.warn(`⚠️ Login failed for ${email}: Invalid email or password`);
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const isPasswordValid = await bcrypt.compare(password, result[0].user_password);
        if (!isPasswordValid) {
            logger.warn(`⚠️ Login failed for ${email}: Invalid email or password`);
            return res.status(400).json({ error: 'Invalid email or password' });
        }

        const token = jwt.sign(
            { userId: result[0].user_id, email },
            JWT_SECRET,
            { expiresIn: '1h' }
        );

        logger.info(`✅ Login successful for user: ${email}`);
        res.status(200).json({
            message: 'Login successful',
            token,
            userId: result[0].user_id
        });

    } catch (error) {
        logger.error(`❌ Login error for ${email}: ${error.message}`);
        res.status(500).json({ 
            error: 'Internal server error',
            details: error.message 
        });
    }
};