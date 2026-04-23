# Installation Rapide - Restaurant Togo

**Setup en 15 minutes pour ton restaurant au Togo**

---

## Prérequis

- Node.js 18+ (https://nodejs.org)
- Git (https://git-scm.com)
- Un compte Supabase (https://supabase.com)
- Un téléphone Android/iOS pour tester le PWA

---

## 1. Cloner le Projet

```bash
git clone https://github.com/vianney-togo/restaurant-togo.git
cd restaurant-togo
```

---

## 2. Configuration Supabase

1. **Créer un projet Supabase**
   - Aller sur https://supabase.com
   - Sign up > New Project
   - Nom: `restaurant-togo`
   - Region: choisir la plus proche (Afrique du Sud)

2. **Importer le schéma**
   - Dans Supabase Dashboard > SQL Editor
   - Copier-coller le contenu de `database/supabase-schema.sql`
   - Cliquer "Run"

3. **Récupérer les clés**
   - Settings > API
   - Copier `Project URL` et `anon public key`

---

## 3. Configuration Backend

```bash
cd backend
npm install
```

Créer fichier `.env`:
```env
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_ANON_KEY=votre_cle_anon
JWT_SECRET=super_secret_key_12345
TWILIO_ACCOUNT_SID=votre_sid_twilio
TWILIO_AUTH_TOKEN=votre_token_twilio
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
NODE_ENV=development
PORT=3000
```

Démarrer le backend:
```bash
npm run dev
```

Vérifier: http://localhost:3000/health

---

## 4. Configuration Frontend

```bash
cd frontend
npm install
```

Créer fichier `.env`:
```env
VITE_SUPABASE_URL=https://votre-projet.supabase.co
VITE_SUPABASE_ANON_KEY=votre_cle_anon
VITE_API_URL=http://localhost:3000
```

Démarrer le frontend:
```bash
npm run dev
```

Ouvrir: http://localhost:5173

---

## 5. Premier Utilisateur

1. **Créer le gérant**
   - Aller sur http://localhost:5173/register
   - Email: `manager@restaurant.tg`
   - Mot de passe: `manager123`
   - Nom: `Vianney Manager`
   - Rôle: `gerant`
   - Restaurant ID: `550e8400-e29b-41d4-a716-446655440000`

2. **Se connecter**
   - Aller sur http://localhost:5173/login
   - Utiliser les identifiants ci-dessus

---

## 6. Test Hors Ligne

1. **Activer le mode hors ligne**
   - Dans Chrome DevTools > Network > Offline
   - Ou déconnecter WiFi

2. **Tester le POS**
   - Aller sur /pos
   - Ajouter des produits au panier
   - Valider une vente

3. **Revenir en ligne**
   - Réactiver le réseau
   - Les données devraient se synchroniser automatiquement

---

## 7. Configuration WhatsApp (Optionnel)

1. **Créer compte Twilio**
   - Aller sur https://twilio.com
   - Sign up > Get API Key

2. **Configurer WhatsApp Sandbox**
   - Messaging > Try it out > WhatsApp
   - Suivre les instructions pour joindre le sandbox

3. **Ajouter les clés dans .env**
   - TWILIO_ACCOUNT_SID
   - TWILIO_AUTH_TOKEN

---

## 8. Test Mobile (PWA)

1. **Sur téléphone**
   - Ouvrir http://localhost:5173
   - Chrome menu > "Add to Home Screen"
   - L'application devrait s'installer

2. **Test complet**
   - Déconnecter WiFi
   - Utiliser l'application hors ligne
   - Reconnecter et vérifier la sync

---

## 9. Importer des Produits

Créer fichier `produits.xlsx`:
```
Nom Produit       | Catégorie | Prix | Stock | Seuil
Riz sauce arachide| Plats     | 1500  | 50    | 10
Poulet braisé    | Plats     | 2500  | 30    | 5
Soda             | Boissons  | 500   | 100   | 20
Eau minérale     | Boissons  | 300   | 200   | 50
```

Dans l'app: Settings > Importer > Choisir le fichier

---

## 10. Déploiement Production

### Frontend (Vercel)
```bash
# Installer Vercel CLI
npm i -g vercel

# Déployer
cd frontend
vercel --prod
```

### Backend (Railway)
```bash
# Installer Railway CLI
npm i -g @railway/cli

# Déployer
cd backend
railway login
railway init
railway up
```

---

## Vérification Finale

- [ ] Backend: http://localhost:3000/health = OK
- [ ] Frontend: http://localhost:5173 = Dashboard visible
- [ ] Login: manager@restaurant.tg / manager123 = Connecté
- [ ] POS: Ajout produit = Fonctionne
- [ ] Hors ligne: Vente possible = OK
- [ ] Sync: Retour online = Données synchronisées
- [ ] Mobile: PWA installée = OK

---

## Problèmes Communs

### "Connection refused"
```bash
# Vérifier si le backend tourne
curl http://localhost:3000/health
```

### "Supabase connection error"
```bash
# Vérifier les clés .env
echo $SUPABASE_URL
echo $SUPABASE_ANON_KEY
```

### "PWA ne s'installe pas"
- Vérifier HTTPS en production
- Vérifier le manifest.json
- Vérifier le service worker

---

## Support

- **Documentation:** `/RESSOURCES_UTILES.md`
- **Plan développement:** `/PLAN_DEVELOPPEMENT.md`
- **Issues:** GitHub du projet
- **WhatsApp Togo:** +228 90 00 00 00 (support local)

---

**Bon courage pour ton restaurant!**  
*Ce starter kit est fait pour le Togo, par un développeur togolais*
