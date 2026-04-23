const express = require('express');
const twilio = require('twilio');
const router = express.Router();

// Configuration Twilio
const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
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

// Envoyer un message WhatsApp
router.post('/send', authenticateToken, async (req, res) => {
  try {
    const { to, message } = req.body;

    if (!to || !message) {
      return res.status(400).json({ error: 'Destinataire et message requis' });
    }

    const result = await client.messages.create({
      body: message,
      from: process.env.TWILIO_WHATSAPP_NUMBER,
      to: `whatsapp:${to}`
    });

    res.json({
      success: true,
      messageId: result.sid,
      status: result.status
    });

  } catch (error) {
    console.error('Erreur WhatsApp:', error);
    res.status(500).json({ error: 'Erreur envoi message' });
  }
});

module.exports = router;
