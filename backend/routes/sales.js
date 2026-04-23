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

// Créer une vente (fonctionne hors ligne)
router.post('/', authenticateToken, async (req, res) => {
  try {
    const {
      items,
      total_amount,
      payment_method,
      client_id,
      table_number,
      notes,
      is_offline = false
    } = req.body;

    if (!items || !total_amount || !payment_method) {
      return res.status(400).json({ 
        error: 'Items, montant total et méthode de paiement requis' 
      });
    }

    const saleData = {
      items,
      total_amount,
      payment_method,
      client_id: client_id || null,
      table_number: table_number || null,
      notes: notes || '',
      user_id: req.user.id,
      restaurant_id: req.user.restaurant_id,
      status: 'completed',
      is_offline,
      created_at: new Date().toISOString()
    };

    // Si hors ligne, marquer pour sync plus tard
    if (is_offline) {
      saleData.sync_status = 'pending';
    }

    const { data: sale, error } = await supabase
      .from('sales')
      .insert(saleData)
      .select()
      .single();

    if (error) {
      console.error('Erreur création vente:', error);
      return res.status(400).json({ error: 'Erreur création vente' });
    }

    // Mettre à jour le stock
    for (const item of items) {
      await supabase
        .from('stock')
        .update({ 
          quantity: supabase.rpc('decrement_stock', { 
            item_id: item.product_id, 
            quantity: item.quantity 
          })
        })
        .eq('product_id', item.product_id);
    }

    res.status(201).json({
      message: 'Vente créée avec succès',
      sale
    });

  } catch (error) {
    console.error('Erreur vente:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les ventes du jour
router.get('/today', authenticateToken, async (req, res) => {
  try {
    const today = new Date().toISOString().split('T')[0];

    const { data: sales, error } = await supabase
      .from('sales')
      .select(`
        *,
        users(name),
        clients(name)
      `)
      .eq('restaurant_id', req.user.restaurant_id)
      .gte('created_at', today)
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: 'Erreur récupération ventes' });
    }

    // Calculer les statistiques
    const stats = {
      total_sales: sales.length,
      total_amount: sales.reduce((sum, sale) => sum + sale.total_amount, 0),
      cash_amount: sales.filter(s => s.payment_method === 'cash').reduce((sum, s) => sum + s.total_amount, 0),
      mobile_money_amount: sales.filter(s => s.payment_method === 'mobile_money').reduce((sum, s) => sum + s.total_amount, 0),
      mixx_amount: sales.filter(s => s.payment_method === 'mixx').reduce((sum, s) => sum + s.total_amount, 0)
    };

    res.json({
      sales,
      stats
    });

  } catch (error) {
    console.error('Erreur ventes du jour:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Récupérer les ventes avec filtres
router.get('/', authenticateToken, async (req, res) => {
  try {
    const { 
      start_date, 
      end_date, 
      payment_method, 
      status = 'completed',
      limit = 50 
    } = req.query;

    let query = supabase
      .from('sales')
      .select(`
        *,
        users(name),
        clients(name)
      `)
      .eq('restaurant_id', req.user.restaurant_id)
      .eq('status', status)
      .order('created_at', { ascending: false })
      .limit(limit);

    // Appliquer les filtres
    if (start_date) {
      query = query.gte('created_at', start_date);
    }
    if (end_date) {
      query = query.lte('created_at', end_date);
    }
    if (payment_method) {
      query = query.eq('payment_method', payment_method);
    }

    const { data: sales, error } = await query;

    if (error) {
      return res.status(400).json({ error: 'Erreur récupération ventes' });
    }

    res.json({ sales });

  } catch (error) {
    console.error('Erreur ventes:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Annuler une vente
router.patch('/:id/cancel', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    // Vérifier que la vente appartient au restaurant
    const { data: sale, error: fetchError } = await supabase
      .from('sales')
      .select('*')
      .eq('id', id)
      .eq('restaurant_id', req.user.restaurant_id)
      .single();

    if (fetchError || !sale) {
      return res.status(404).json({ error: 'Vente non trouvée' });
    }

    // Mettre à jour le statut
    const { data: updatedSale, error } = await supabase
      .from('sales')
      .update({ 
        status: 'cancelled',
        cancelled_by: req.user.id,
        cancelled_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: 'Erreur annulation vente' });
    }

    // Remettre les produits en stock
    for (const item of sale.items) {
      await supabase
        .from('stock')
        .update({ 
          quantity: supabase.rpc('increment_stock', { 
            item_id: item.product_id, 
            quantity: item.quantity 
          })
        })
        .eq('product_id', item.product_id);
    }

    res.json({
      message: 'Vente annulée avec succès',
      sale: updatedSale
    });

  } catch (error) {
    console.error('Erreur annulation:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

module.exports = router;
