# Guide de création de la base de données Supabase

## Étapes à suivre

### 1. Créer le projet Supabase
1. Allez sur https://supabase.com
2. Connectez-vous avec GitHub/Google
3. Cliquez sur "New Project"
4. Nom : `gout-divin-restaurant`
5. Mot de passe de la base : choisissez un mot de passe sécurisé
6. Région : Europe (ou la plus proche du Togo)

### 2. Obtenir les clés
1. Une fois le projet créé, allez dans **Settings > API**
2. Copiez le **Project URL** et **anon key**
3. Mettez à jour le fichier `backend/.env` :
   ```
   SUPABASE_URL=https://votre-projet.supabase.co
   SUPABASE_ANON_KEY=votre_cle_anon_supabase
   ```

### 3. Exécuter le script SQL
1. Allez dans **SQL Editor** dans votre dashboard Supabase
2. Copiez-collez le contenu du fichier `database/supabase-schema.sql`
3. Cliquez sur **Run** pour exécuter le script

### 4. Vérifier la création des tables
Après exécution, vous devriez voir ces tables :
- `restaurants`
- `users`
- `categories`
- `products`
- `stock`
- `stock_movements`
- `clients`
- `sales`
- `deliveries`
- `expenses`
- `alerts`
- `whatsapp_notifications`

### 5. Tester la connexion
1. Redémarrez le backend : `npm start`
2. Testez une vente avec un client
3. Vérifiez que le client apparaît bien dans la base

### 6. Configuration RLS (Row Level Security)
Le script active déjà la sécurité au niveau des lignes. Chaque restaurant ne verra que ses propres données.

## Notes importantes
- Gardez vos clés secrètes
- Le script inclut des données de test pour le restaurant
- Les tables sont déjà configurées avec les index et triggers nécessaires
