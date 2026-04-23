const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Données de démo (sans base de données)
const users = [
  {
    id: '1',
    name: 'Vianney Manager',
    email: 'manager@restaurant.tg',
    password: '$2a$10$IMBycsKeF2tqaOzjNGtzP.6BZVuuPVmBuPYBxD6NA9YdgOVgdBFbi', // 'manager123'
    role: 'gerant',
    restaurant_id: '1'
  },
  {
    id: '2',
    name: 'Caissier Test',
    email: 'caissier@restaurant.tg',
    password: '$2a$10$VnKfWyU1dgoStc3Ma/ep2ey0gyUdo8RvUudjmAjfQ6T672lX6hTfq', // 'caissier123'
    role: 'caissier',
    restaurant_id: '1'
  }
];

const products = [
  { id: 1, name: 'Riz sauce arachide', price: 1500, category: 'Plats', stock: 50 },
  { id: 2, name: 'Poulet braisé', price: 2500, category: 'Viandes', stock: 30 },
  { id: 3, name: 'Soda', price: 500, category: 'Boissons', stock: 100 },
  { id: 4, name: 'Eau minérale', price: 300, category: 'Boissons', stock: 200 }
];

// Routes
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const user = users.find(u => u.email === email);
    if (!user) {
      return res.status(401).json({ error: 'Utilisateur non trouvé' });
    }

    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Mot de passe incorrect' });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role, name: user.name, restaurant_id: user.restaurant_id },
      'demo_secret_key',
      { expiresIn: '7d' }
    );

    res.json({
      message: 'Connexion réussie',
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        restaurant_id: user.restaurant_id
      }
    });
  } catch (error) {
    console.error('Erreur login:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.post('/api/auth/register', async (req, res) => {
  res.json({ message: 'Inscription non disponible en mode démo' });
});

app.get('/api/users/me', (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token requis' });
  }

  try {
    const decoded = jwt.verify(token, 'demo_secret_key');
    const user = users.find(u => u.id === decoded.id);
    
    if (!user) {
      return res.status(404).json({ error: 'Utilisateur non trouvé' });
    }

    res.json({ 
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        restaurant_id: user.restaurant_id
      }
    });
  } catch (error) {
    res.status(403).json({ error: 'Token invalide' });
  }
});

app.get('/api/stock', (req, res) => {
  res.json({ stock: products });
});

app.get('/api/clients', (req, res) => {
  res.json({ clients: [] });
});

app.get('/api/reports/dashboard', (req, res) => {
  res.json({
    todaySales: 15,
    todayRevenue: 45000,
    lowStockItems: 1,
    activeClients: 23,
    salesChart: [
      { label: 'Lun', value: 35000 },
      { label: 'Mar', value: 42000 },
      { label: 'Mer', value: 38000 },
      { label: 'Jeu', value: 45000 },
      { label: 'Ven', value: 52000 },
      { label: 'Sam', value: 48000 },
      { label: 'Dim', value: 45000 }
    ],
    alerts: [
      {
        type: 'stock',
        severity: 'high',
        title: 'Stock critique',
        message: 'Poulet braisé - Reste 5 unités',
        actionText: 'Voir le stock'
      }
    ]
  });
});

app.post('/api/sales', (req, res) => {
  res.json({ message: 'Vente enregistrée', sale: { id: Date.now() } });
});

// Route de santé
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Restaurant Togo Backend fonctionne',
    timestamp: new Date().toISOString(),
    version: '1.0.0-demo'
  });
});

// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`\n\n`);
  console.log(`====================================`);
  console.log(`Restaurant Togo Backend DÉMO`);
  console.log(`Port: ${PORT}`);
  console.log(`Utilisateurs de démo:`);
  console.log(`- Manager: manager@restaurant.tg / manager123`);
  console.log(`- Caissier: caissier@restaurant.tg / caissier123`);
  console.log(`====================================`);
  console.log(`\n`);
});

module.exports = app;
