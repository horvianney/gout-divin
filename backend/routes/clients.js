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

// Récupérer les clients
router.get('/', authenticateToken, async (req, res) => {
  try {
    const { data: clients, error } = await supabase
      .from('clients')
      .select('*')
      .eq('restaurant_id', req.user.restaurant_id)
      .order('created_at', { ascending: false });

    if (error) {
      return res.status(400).json({ error: 'Erreur récupération clients' });
    }

    res.json({ clients });
  } catch (error) {
    console.error('Erreur clients:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Créer un client
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { name, phone, email, address } = req.body;

    if (!name) {
      return res.status(400).json({ error: 'Nom du client requis' });
    }

    // Vérifier si le client existe déjà par téléphone
    if (phone) {
      const { data: existingClient } = await supabase
        .from('clients')
        .select('*')
        .eq('restaurant_id', req.user.restaurant_id)
        .eq('phone', phone)
        .single();

      if (existingClient) {
        return res.status(409).json({ error: 'Client existe déjà', client: existingClient });
      }
    }

    const { data: client, error } = await supabase
      .from('clients')
      .insert([{
        restaurant_id: req.user.restaurant_id,
        name,
        phone,
        email,
        address
      }])
      .select()
      .single();

    if (error) {
      return res.status(400).json({ error: 'Erreur création client' });
    }

    res.status(201).json({ client });
  } catch (error) {
    console.error('Erreur création client:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

// Rechercher un client par téléphone
router.get('/search', authenticateToken, async (req, res) => {
  try {
    const { phone } = req.query;

    if (!phone) {
      return res.status(400).json({ error: 'Téléphone requis' });
    }

    const { data: client, error } = await supabase
      .from('clients')
      .select('*')
      .eq('restaurant_id', req.user.restaurant_id)
      .eq('phone', phone)
      .single();

    if (error && error.code !== 'PGRST116') { // PGRST116 = not found
      return res.status(400).json({ error: 'Erreur recherche client' });
    }

    res.json({ client: client || null });
  } catch (error) {
    console.error('Erreur recherche client:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

module.exports = router;
