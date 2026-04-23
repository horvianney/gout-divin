# Restaurant Togo - Starter Kit Complet

**Application de gestion de restaurant pour le Togo**  
Hors ligne, mobile-first, multi-rôles, budget 0$

## Features Principales
- **Hors ligne 100%** : fonctionne même sans réseau 2G
- **Multi-rôles** : gérant, caissier, cuisinier, livreur
- **Sync automatique** : localStorage vers Supabase quand réseau revient
- **Dashboard simple** : compatible 2G, pas d'animations lourdes
- **WhatsApp intégré** : alertes et rapports via WhatsApp
- **QR Code menus** : scan pour commander
- **Gestion complète** : ventes, stocks, clients, charges, livraisons

## Stack Technique
- **Backend** : Node.js + Express
- **Frontend** : React + Vite + Tailwind CSS (PWA)
- **Base de données** : PostgreSQL via Supabase (gratuit)
- **Charts** : Chart.js (léger, compatible 2G)
- **WhatsApp** : Twilio WhatsApp API
- **QR Codes** : qrcode.js

## Structure du Projet
```
restaurant-togo/
backend/
  - server.js
  - auth/
  - models/
  - routes/
frontend/
  - src/
    - components/
    - pages/
    - hooks/
    - utils/
```

## Installation Rapide
```bash
# Backend
cd backend
npm install
npm run dev

# Frontend
cd frontend
npm install
npm run dev
```

## Variables d'Environnement
Crée un fichier `.env` dans backend et frontend :

**Backend (.env)**
```
SUPABASE_URL=ta_supabase_url
SUPABASE_ANON_KEY=ta_supabase_key
JWT_SECRET=ton_jwt_secret
TWILIO_ACCOUNT_SID=ton_sid
TWILIO_AUTH_TOKEN=ton_token
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
```

**Frontend (.env)**
```
VITE_SUPABASE_URL=ta_supabase_url
VITE_SUPabase_ANON_KEY=ta_supabase_key
VITE_API_URL=http://localhost:3000
```

## Plan de Développement (7 semaines)
1. **Semaine 1** : Authentification + structure de base
2. **Semaine 2** : Module ventes hors ligne
3. **Semaine 3** : Dashboard et statistiques
4. **Semaine 4** : Gestion des stocks
5. **Semaine 5** : WhatsApp + QR Codes
6. **Semaine 6** : Rapports PDF + sync
7. **Semaine 7** : Tests et déploiement

## Ressources Gratuites
- **Supabase** : https://supabase.com (gratuit 500MB)
- **Twilio** : https://twilio.com (15$ crédits gratuits)
- **Chart.js** : https://chartjs.org (open source)
- **Tailwind CSS** : https://tailwindcss.com (open source)
- **QR Code** : https://github.com/davidshimjs/qrcodejs

## Astuces Togo
- Utilise WhatsApp au lieu d'email (plus fiable)
- Cache les images lourdes sur mobile
- Pré-charge les données importantes
- Boutons larges pour les doigts sur mobile
- Pas d'animations sur 2G

## Démo
Dashboard simple avec :
- Ventes du jour
- Stock critique
- Commandes en attente
- Alertes WhatsApp

---

**Made with love for Togo restaurants**  
*Par Vianney, dev fullstack togolais*
