const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const routes = require('./routes/routes');
const swaggerUi = require('swagger-ui-express');
const swaggerDocs = require('./Config/swaggerConfig');
require('dotenv').config();
const morgan = require('morgan'); // Logging middleware
const helmet = require('helmet'); // Security middleware
const sequelize = require('./Config/database');
const logger = require('./logger'); // Import the logger

const app = express();

// Middleware Configuration
app.use(bodyParser.json()); // Parse JSON bodies
app.use(bodyParser.urlencoded({ extended: true })); // Parse URL-encoded bodies
app.use(cors({ origin: '*' })); // Allow CORS for all origins
app.use(helmet()); // Security headers
app.use(morgan('dev')); // Log HTTP requests

// Routes
app.use('/', routes);

// Swagger Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs));

// Global Error Handling Middleware
app.use((err, req, res, next) => {
  logger.error('🔥 Error:', err);
  res.status(err.status || 500).json({ error: err.message || 'Internal Server Error' });
});

// Start the server
const PORT = process.env.PORT || 3000;

const startServer = async () => {
  try {
    await sequelize.authenticate();
    logger.info('✅ Database connected successfully');
    app.listen(PORT, () => {
      logger.info(`⚡ Server running on port ${PORT}`);
      logger.info(`📑 Swagger Docs available at http://localhost:${PORT}/api-docs`);
    });
  } catch (err) {
    logger.error('❌ Unable to connect to the database:', err);
  }
};

startServer();

module.exports = app;
