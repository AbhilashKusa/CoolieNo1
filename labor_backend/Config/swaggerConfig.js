const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

// Swagger configuration options
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Labor Marketplace API',
      version: '1.0.0',
      description: 'API documentation for the Labor Marketplace application',
      contact: {
        name: 'Support Team',
        email: 'support@example.com',
      },
    },
    servers: [
      {
        url: 'http://localhost:3000/api',
        description: 'Local development server',
      },
    ],
  },
  apis: ['./routes/routes.js'], // Path to API documentation
};

// Initialize Swagger docs
const swaggerDocs = swaggerJsDoc(swaggerOptions);

module.exports = { swaggerUi, swaggerDocs };
