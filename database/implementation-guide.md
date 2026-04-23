# Guide d'Implémentation PostgreSQL - Restaurant Gout Divin

## Étapes d'Installation Complètes

### 1. Prérequis

**Compte Supabase :**
- Créez un compte sur https://supabase.com
- Vérifiez votre email
- Choisissez un plan (Free tier suffisant pour commencer)

**Configuration Régionale :**
- **Recommandé pour le Togo** : EU West (Irlande/Frankfurt)
- Alternative : West Africa si disponible
- Évitez US East pour des raisons de latence

### 2. Création du Projet

1. **Connectez-vous** à Supabase Dashboard
2. **Cliquez** sur "New Project"
3. **Configurez** :
   - **Nom du projet** : `gout-divin-restaurant`
   - **Mot de passe base** : Choisissez un mot de passe sécurisé (notez-le)
   - **Région** : EU West (ou West Africa)
   - **Organisation** : Personal ou votre entreprise

4. **Attendez** la création du projet (2-3 minutes)

### 3. Récupération des Clés

1. **Allez** dans Settings > API
2. **Copiez** ces informations :
   - **Project URL** : `https://votre-projet.supabase.co`
   - **Anon Key** : `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - **Service Role Key** (gardée secrète pour le backend)

### 4. Configuration des Variables d'Environnement

#### Backend (`backend/.env`)
```bash
# Remplacez par vos vraies valeurs
SUPABASE_URL=https://votre-projet-id.supabase.co
SUPABASE_ANON_KEY=votre_cle_anon_supabase
JWT_SECRET=votre_jwt_secret_tres_secret_12345
TWILIO_ACCOUNT_SID=demo_sid
TWILIO_AUTH_TOKEN=demo_token
TWILIO_WHATSAPP_NUMBER=whatsapp:+14155238886
NODE_ENV=development
PORT=3000
```

#### Frontend (`frontend/.env`)
```bash
# Configuration Frontend
VITE_SUPABASE_URL=https://votre-projet-id.supabase.co
VITE_SUPABASE_ANON_KEY=votre_cle_anon_supabase
VITE_API_URL=http://localhost:3000
```

### 5. Exécution du Schéma SQL

#### Méthode 1 : Via Supabase Dashboard (Recommandé)

1. **Allez** dans SQL Editor dans votre dashboard Supabase
2. **Cliquez** sur "New query"
3. **Copiez-collez** tout le contenu de `database/postgresql-schema-complete.sql`
4. **Cliquez** sur "Run" pour exécuter
5. **Vérifiez** que toutes les tables sont créées

#### Méthode 2 : Via CLI (Avancé)

```bash
# Installer Supabase CLI
npm install -g supabase

# Se connecter
supabase login

# Lier au projet
supabase link --project-ref votre-projet-id

# Exécuter le schéma
supabase db push database/postgresql-schema-complete.sql
```

### 6. Vérification de l'Installation

#### Vérification via Dashboard Supabase

1. **Table Editor** : Vous devriez voir 12 tables
2. **Vérifiez** les données de test :
   - `restaurants` : 1 restaurant (Gout Divin)
   - `users` : 2 utilisateurs (manager, caissier)
   - `categories` : 4 catégories
   - `products` : 6 produits
   - `clients` : 3 clients
   - `stock` : 6 entrées de stock

#### Vérification via SQL

```sql
-- Compter les tables
SELECT COUNT(*) FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
-- Résultat attendu : 12

-- Vérifier les données de test
SELECT COUNT(*) as restaurants FROM restaurants;
SELECT COUNT(*) as users FROM users;
SELECT COUNT(*) as products FROM products;
SELECT COUNT(*) as clients FROM clients;
```

### 7. Test de Connexion Backend

1. **Redémarrez** le backend :
```bash
cd backend
npm start
```

2. **Vérifiez** les logs :
```
Server running on port 3000
Connected to Supabase successfully
```

3. **Testez** l'API :
```bash
curl http://localhost:3000/api/clients
# Devrait retourner les clients de test
```

### 8. Test de l'Application Complète

1. **Démarrez** le frontend :
```bash
cd frontend
npm run dev
```

2. **Ouvrez** http://localhost:5173

3. **Connectez-vous** avec les comptes de test :
   - **Email** : manager@goutdivin.tg
   - **Mot de passe** : password123

4. **Testez** une vente :
   - Allez dans le POS
   - Ajoutez des produits au panier
   - Saisissez un nom de client
   - Validez la commande
   - **Vérifiez** que le client apparaît dans la base

### 9. Configuration Supplémentaire

#### Row Level Security (RLS)

Le schéma active déjà RLS. Pour vérifier :

```sql
-- Vérifier les politiques RLS
SELECT schemaname, tablename, policyname, cmd, roles 
FROM pg_policies 
WHERE schemaname = 'public';
```

#### Index Performance

```sql
-- Vérifier les index créés
SELECT schemaname, tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public' 
ORDER BY tablename, indexname;
```

### 10. Dépannage Commun

#### Erreur "Connection refused"
- **Cause** : Mauvaises clés Supabase
- **Solution** : Vérifiez les variables `.env`

#### Erreur "Table does not exist"
- **Cause** : Schéma non exécuté
- **Solution** : Ré-exécutez le script SQL

#### Erreur "Permission denied"
- **Cause** : RLS bloquant l'accès
- **Solution** : Vérifiez l'authentification JWT

#### Performance lente
- **Cause** : Index manquants
- **Solution** : Vérifiez la création des index

### 11. Maintenance

#### Sauvegardes Automatiques
Supabase fournit des sauvegardes automatiques. Configurez :

1. **Settings > Database** : Activez les sauvegardes quotidiennes
2. **Point-in-time recovery** : Configurez si nécessaire

#### Monitoring
1. **Settings > Logs** : Surveillez les erreurs
2. **Settings > Database** : Surveillez la performance
3. **Usage** : Surveillez les quotas

### 12. Sécurité

#### Clés API
- **Anon Key** : Utilisable côté client (publique)
- **Service Role Key** : Serveur uniquement (secrète)
- **Jamais** exposer la Service Role Key dans le frontend

#### RLS Policies
Les politiques sont déjà configurées pour :
- Isoler les données par restaurant
- Protéger les informations sensibles
- Autoriser uniquement les accès légitimes

### 13. Évolution du Schéma

#### Pour ajouter une nouvelle table :
1. **Créez** la table SQL
2. **Ajoutez** les index nécessaires
3. **Activez** RLS si nécessaire
4. **Ajoutez** les politiques RLS

#### Pour modifier une table existante :
1. **Utilisez** ALTER TABLE
2. **Mettez à jour** les triggers si besoin
3. **Testez** avec des données de test

### 14. Checklist Finale

- [ ] Projet Supabase créé
- [ ] Clés configurées dans `.env`
- [ ] Schéma SQL exécuté
- [ ] Données de test vérifiées
- [ ] Backend connecté
- [ ] Frontend fonctionnel
- [ ] Test de vente avec client réussi
- [ ] RLS activé et testé
- [ ] Index créés et vérifiés
- [ ] Sauvegardes configurées

### 15. Prochaines Étapes

Une fois la base configurée :

1. **Personnalisez** les produits et prix
2. **Ajoutez** vos propres utilisateurs
3. **Configurez** les méthodes de paiement locales
4. **Implémentez** les notifications SMS/WhatsApp
5. **Déployez** en production

---

**Support technique :**
- Documentation Supabase : https://supabase.com/docs
- Community Discord : https://discord.gg/supabase
- Issues GitHub : https://github.com/supabase/supabase/issues
