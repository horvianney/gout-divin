const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Sécurité et performance pour Togo
app.use(helmet());
app.use(cors({
  origin: ['http://localhost:5173', 'http://localhost:3000', 'https://*.vercel.app'],
  credentials: true
}));

// Rate limiting pour éviter les abus
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limite chaque IP à 100 requêtes
  message: 'Trop de requêtes, réessayez plus tard'
});
app.use(limiter);

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/users', require('./routes/users'));
app.use('/api/sales', require('./routes/sales'));
app.use('/api/stock', require('./routes/stock'));
app.use('/api/clients', require('./routes/clients'));
app.use('/api/reports', require('./routes/reports'));
app.use('/api/whatsapp', require('./routes/whatsapp'));

// Route de santé pour vérifier que le serveur fonctionne
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Restaurant Togo Backend fonctionne',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Route 404
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Route non trouvée',
    message: 'Cette route n\'existe pas'
  });
});

// Gestion des erreurs
app.use((err, req, res, next) => {
  console.error('Erreur:', err);
  res.status(err.status || 500).json({
    error: 'Erreur serveur',
    message: process.env.NODE_ENV === 'production' 
      ? 'Une erreur est survenue' 
      : err.message
  });
});

app.listen(PORT, () => {
  console.log(`\n\n`);
  console.log(`====================================`);
  console.log(`Restaurant Togo Backend démarré`);
  console.log(`Port: ${PORT}`);
  console.log(`Environnement: ${process.env.NODE_ENV || 'development'}`);
  console.log(`====================================`);
  console.log(`\n`);
  console.log(`API disponibles:`);
  console.log(`- POST /api/auth/login`);
  console.log(`- POST /api/auth/register`);
  console.log(`- GET /api/users/me`);
  console.log(`- POST /api/sales`);
  console.log(`- GET /api/stock`);
  console.log(`- GET /api/clients`);
  console.log(`- GET /api/reports/dashboard`);
  console.log(`- POST /api/whatsapp/send`);
  console.log(`\n`);
});

module.exports = app;
