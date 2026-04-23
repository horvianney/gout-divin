const express = require('express');
const { createClient } = require('@supabase/supabase-js');
const router = express.Router();

// Connexion Supabase
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

// Middleware pour vérifier le token JWT
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token requis' });
  }

  const jwt = require('jsonwebtoken');
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Token invalide' });
    }
    req.user = user;
    next();
  });
};

// Dashboard stats
router.get('/dashboard', authenticateToken, async (req, res) => {
  try {
    const today = new Date().toISOString().split('T')[0];
    
    // Ventes du jour
    const { data: todaySales, error: salesError } = await supabase
      .from('sales')
      .select('total_amount, payment_method')
      .eq('restaurant_id', req.user.restaurant_id)
      .gte('created_at', today)
      .eq('status', 'completed');

    // Stock critique
    const { data: lowStock, error: stockError } = await supabase
      .from('stock')
      .select('product_id, quantity, min_quantity, products(name)')
      .eq('restaurant_id', req.user.restaurant_id)
      .lt('quantity', 'min_quantity')
      .lte('stock', 'products');

    // Clients actifs
    const { data: clients, error: clientsError } = await supabase
      .from('clients')
      .select('id')
      .eq('restaurant_id', req.user.restaurant_id);

    const stats = {
      todaySales: todaySales?.length || 0,
      todayRevenue: todaySales?.reduce((sum, sale) => sum + (sale.total_amount || 0), 0) || 0,
      lowStockItems: lowStock?.length || 0,
      activeClients: clients?.length || 0,
      salesChart: [], // À implémenter
      alerts: lowStock?.map(item => ({
        type: 'stock',
        severity: 'high',
        title: 'Stock critique',
        message: `${item.products?.name} - Reste ${item.quantity} unités`,
        actionText: 'Voir le stock'
      })) || []
    };

    res.json(stats);
  } catch (error) {
    console.error('Erreur dashboard:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

module.exports = router;
