-- ========================================
-- SCHÉMA POSTGRESQL COMPLET POUR RESTAURANT GOUT DIVIN
-- Compatible avec Supabase (PostgreSQL 15+)
-- ========================================

-- Extension UUID pour les IDs uniques
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- TABLES PRINCIPALES
-- ========================================

-- Restaurants
CREATE TABLE restaurants (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(255),
    logo_url TEXT,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Utilisateurs avec rôles
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('gerant', 'caissier', 'cuisinier', 'livreur')),
    phone VARCHAR(50),
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Catégories de produits
CREATE TABLE categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    color VARCHAR(20) DEFAULT '#f59e0b',
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Produits/Menu
CREATE TABLE products (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    cost_price DECIMAL(10,2) CHECK (cost_price >= 0),
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Stock
CREATE TABLE stock (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    quantity DECIMAL(10,2) NOT NULL DEFAULT 0,
    min_quantity DECIMAL(10,2) DEFAULT 5,
    unit VARCHAR(50) DEFAULT 'unité',
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Mouvements de stock
CREATE TABLE stock_movements (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    movement_type VARCHAR(20) NOT NULL CHECK (movement_type IN ('in', 'out', 'adjustment')),
    quantity DECIMAL(10,2) NOT NULL,
    reason TEXT,
    user_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Clients
CREATE TABLE clients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(255),
    address TEXT,
    loyalty_points INTEGER DEFAULT 0,
    total_spent DECIMAL(10,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ventes
CREATE TABLE sales (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id),
    client_id UUID REFERENCES clients(id) ON DELETE SET NULL,
    items JSONB NOT NULL, -- [{product_id, name, price, quantity}]
    subtotal_amount DECIMAL(10,2) NOT NULL CHECK (subtotal_amount >= 0),
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    payment_method VARCHAR(50) NOT NULL CHECK (payment_method IN ('cash', 'mobile_money', 'mixx', 'card')),
    payment_status VARCHAR(20) DEFAULT 'paid' CHECK (payment_status IN ('paid', 'pending', 'cancelled')),
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('completed', 'cancelled', 'refunded')),
    table_number VARCHAR(20),
    notes TEXT,
    is_offline BOOLEAN DEFAULT false,
    sync_status VARCHAR(20) DEFAULT 'synced' CHECK (sync_status IN ('synced', 'pending', 'error')),
    cancelled_by UUID REFERENCES users(id),
    cancelled_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Livraisons
CREATE TABLE deliveries (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    sale_id UUID REFERENCES sales(id) ON DELETE CASCADE,
    client_id UUID REFERENCES clients(id) ON DELETE CASCADE,
    delivery_address TEXT NOT NULL,
    delivery_phone VARCHAR(50),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'preparing', 'ready', 'delivering', 'delivered', 'cancelled')),
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    delivery_person VARCHAR(255),
    estimated_time TIMESTAMP WITH TIME ZONE,
    delivered_at TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Charges/Dépenses
CREATE TABLE expenses (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    category VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    description TEXT,
    expense_date DATE NOT NULL,
    receipt_url TEXT,
    user_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Alertes
CREATE TABLE alerts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL CHECK (type IN ('stock_low', 'expense_high', 'client_loyalty', 'system')),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    severity VARCHAR(20) DEFAULT 'medium' CHECK (severity IN ('low', 'medium', 'high')),
    is_read BOOLEAN DEFAULT false,
    data JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications WhatsApp
CREATE TABLE whatsapp_notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    recipient_phone VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'sent', 'failed')),
    twilio_sid VARCHAR(255),
    error_message TEXT,
    sent_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================
-- FONCTIONS SQL UTILES
-- ========================================

-- Fonction pour décrémenter le stock
CREATE OR REPLACE FUNCTION decrement_stock(item_id UUID, qty DECIMAL)
RETURNS VOID AS $$
BEGIN
    UPDATE stock 
    SET quantity = quantity - qty,
        last_updated = NOW()
    WHERE product_id = item_id;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour incrémenter le stock
CREATE OR REPLACE FUNCTION increment_stock(item_id UUID, qty DECIMAL)
RETURNS VOID AS $$
BEGIN
    UPDATE stock 
    SET quantity = quantity + qty,
        last_updated = NOW()
    WHERE product_id = item_id;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour mettre à jour le total dépensé d'un client
CREATE OR REPLACE FUNCTION update_client_total_spent(client_uuid UUID, amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    UPDATE clients 
    SET total_spent = total_spent + amount,
        updated_at = NOW()
    WHERE id = client_uuid;
END;
$$ LANGUAGE plpgsql;

-- Fonction pour mettre à jour les points de fidélité
CREATE OR REPLACE FUNCTION update_loyalty_points(client_uuid UUID, amount DECIMAL)
RETURNS VOID AS $$
BEGIN
    UPDATE clients 
    SET loyalty_points = loyalty_points + FLOOR(amount / 1000), -- 1 point par 1000 FCFA
        updated_at = NOW()
    WHERE id = client_uuid;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour mettre à jour le timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- TRIGGERS
-- ========================================

-- Appliquer le trigger aux tables pertinentes
CREATE TRIGGER update_restaurants_updated_at BEFORE UPDATE ON restaurants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_clients_updated_at BEFORE UPDATE ON clients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_deliveries_updated_at BEFORE UPDATE ON deliveries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Trigger pour mettre à jour le client lors d'une vente
CREATE OR REPLACE FUNCTION update_client_on_sale()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.client_id IS NOT NULL AND NEW.status = 'completed' THEN
        PERFORM update_client_total_spent(NEW.client_id, NEW.total_amount);
        PERFORM update_loyalty_points(NEW.client_id, NEW.total_amount);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_client_on_sale 
    AFTER INSERT ON sales 
    FOR EACH ROW EXECUTE FUNCTION update_client_on_sale();

-- ========================================
-- INDEX POUR OPTIMISATION
-- ========================================

CREATE INDEX idx_users_restaurant_id ON users(restaurant_id);
CREATE INDEX idx_sales_restaurant_id ON sales(restaurant_id);
CREATE INDEX idx_sales_created_at ON sales(created_at);
CREATE INDEX idx_sales_client_id ON sales(client_id);
CREATE INDEX idx_sales_status ON sales(status);
CREATE INDEX idx_stock_restaurant_id ON stock(restaurant_id);
CREATE INDEX idx_stock_product_id ON stock(product_id);
CREATE INDEX idx_clients_restaurant_id ON clients(restaurant_id);
CREATE INDEX idx_clients_phone ON clients(phone);
CREATE INDEX idx_deliveries_status ON deliveries(status);
CREATE INDEX idx_deliveries_sale_id ON deliveries(sale_id);
CREATE INDEX idx_alerts_restaurant_id ON alerts(restaurant_id);
CREATE INDEX idx_alerts_is_read ON alerts(is_read);
CREATE INDEX idx_expenses_restaurant_id ON expenses(restaurant_id);
CREATE INDEX idx_expenses_expense_date ON expenses(expense_date);
CREATE INDEX idx_products_restaurant_id ON products(restaurant_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_categories_restaurant_id ON categories(restaurant_id);

-- ========================================
-- VUES POUR STATISTIQUES
-- ========================================

-- Vue pour les statistiques du dashboard
CREATE VIEW dashboard_stats AS
SELECT 
    r.id as restaurant_id,
    COUNT(DISTINCT s.id) as total_sales,
    COALESCE(SUM(s.total_amount), 0) as total_revenue,
    COUNT(DISTINCT c.id) as total_clients,
    COUNT(DISTINCT CASE WHEN st.quantity <= st.min_quantity THEN st.product_id END) as low_stock_items,
    COUNT(DISTINCT CASE WHEN s.created_at >= CURRENT_DATE THEN s.id END) as today_sales,
    COALESCE(SUM(CASE WHEN s.created_at >= CURRENT_DATE THEN s.total_amount END), 0) as today_revenue,
    COUNT(DISTINCT CASE WHEN s.created_at >= CURRENT_DATE - INTERVAL '7 days' THEN s.id END) as week_sales,
    COALESCE(SUM(CASE WHEN s.created_at >= CURRENT_DATE - INTERVAL '7 days' THEN s.total_amount END), 0) as week_revenue,
    COUNT(DISTINCT CASE WHEN s.created_at >= CURRENT_DATE - INTERVAL '30 days' THEN s.id END) as month_sales,
    COALESCE(SUM(CASE WHEN s.created_at >= CURRENT_DATE - INTERVAL '30 days' THEN s.total_amount END), 0) as month_revenue
FROM restaurants r
LEFT JOIN sales s ON r.id = s.restaurant_id AND s.status = 'completed'
LEFT JOIN clients c ON r.id = c.restaurant_id
LEFT JOIN stock st ON r.id = st.restaurant_id
GROUP BY r.id;

-- Vue pour les produits les plus vendus
CREATE VIEW top_products AS
SELECT 
    p.id,
    p.name,
    p.price,
    COUNT(s.id) as times_sold,
    COALESCE(SUM((s.items->>'quantity')::decimal * (s.items->>'price')::decimal), 0) as total_revenue
FROM products p
LEFT JOIN sales s ON s.items @> jsonb_build_object('product_id', p.id::text)
WHERE p.restaurant_id = s.restaurant_id
GROUP BY p.id, p.name, p.price
ORDER BY times_sold DESC;

-- Vue pour les clients fidèles
CREATE VIEW loyal_customers AS
SELECT 
    c.id,
    c.name,
    c.phone,
    c.loyalty_points,
    c.total_spent,
    COUNT(s.id) as total_orders,
    MAX(s.created_at) as last_order_date
FROM clients c
LEFT JOIN sales s ON c.id = s.client_id AND s.status = 'completed'
GROUP BY c.id, c.name, c.phone, c.loyalty_points, c.total_spent
ORDER BY c.loyalty_points DESC, c.total_spent DESC;

-- ========================================
-- RLS (ROW LEVEL SECURITY)
-- ========================================

-- Activer RLS sur les tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE stock ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliveries ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Politiques RLS
CREATE POLICY "Users can view own restaurant data" ON users
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Sales can view own restaurant data" ON sales
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Stock can view own restaurant data" ON stock
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Clients can view own restaurant data" ON clients
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Deliveries can view own restaurant data" ON deliveries
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Expenses can view own restaurant data" ON expenses
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Alerts can view own restaurant data" ON alerts
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Products can view own restaurant data" ON products
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

CREATE POLICY "Categories can view own restaurant data" ON categories
    FOR ALL USING (restaurant_id = (auth.jwt() ->> 'restaurant_id')::uuid);

-- ========================================
-- DONNÉES DE TEST POUR LE TOGO
-- ========================================

-- Restaurant de test
INSERT INTO restaurants (id, name, address, phone, email) VALUES 
('550e8400-e29b-41d4-a716-446655440000', 'Restaurant Gout Divin', 'Lomé, Togo', '+228 90 00 00 00', 'contact@goutdivin.tg');

-- Utilisateurs de test
INSERT INTO users (id, restaurant_id, name, email, password, role) VALUES 
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Vianney Manager', 'manager@goutdivin.tg', '$2a$10$hashedpassword123', 'gerant'),
('550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440000', 'Caissier Principal', 'caissier@goutdivin.tg', '$2a$10$hashedpassword456', 'caissier');

-- Catégories
INSERT INTO categories (id, restaurant_id, name, color) VALUES 
('550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440000', 'Plats Principaux', '#f59e0b'),
('550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440000', 'Boissons', '#3b82f6'),
('550e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440000', 'Entrées', '#10b981'),
('550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440000', 'Desserts', '#ef4444');

-- Produits
INSERT INTO products (id, restaurant_id, category_id, name, description, price, cost_price) VALUES 
('550e8400-e29b-41d4-a716-446655440020', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440010', 'Riz sauce arachide', 'Riz blanc accompagné de sauce arachide traditionnelle', 1500.00, 800.00),
('550e8400-e29b-41d4-a716-446655440021', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440010', 'Poulet braisé', 'Poulet grillé aux épices locales', 2500.00, 1500.00),
('550e8400-e29b-41d4-a716-446655440022', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440011', 'Soda', 'Boisson gazeuse rafraîchissante', 500.00, 250.00),
('550e8400-e29b-41d4-a716-446655440023', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440011', 'Eau minérale', 'Eau purifiée en bouteille', 300.00, 150.00),
('550e8400-e29b-41d4-a716-446655440024', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440010', 'Attiéké poisson', 'Attiéké frais avec poisson frit', 2000.00, 1200.00),
('550e8400-e29b-41d4-a716-446655440025', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440012', 'Salade tropicale', 'Salade fraîche avec fruits tropicaux', 800.00, 400.00);

-- Stock initial
INSERT INTO stock (id, restaurant_id, product_id, quantity, min_quantity, unit) VALUES 
('550e8400-e29b-41d4-a716-446655440030', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440020', 50.00, 10.00, 'portions'),
('550e8400-e29b-41d4-a716-446655440031', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440021', 30.00, 5.00, 'portions'),
('550e8400-e29b-41d4-a716-446655440032', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440022', 100.00, 20.00, 'bouteilles'),
('550e8400-e29b-41d4-a716-446655440033', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440023', 200.00, 50.00, 'bouteilles'),
('550e8400-e29b-41d4-a716-446655440034', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440024', 40.00, 8.00, 'portions'),
('550e8400-e29b-41d4-a716-446655440035', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440025', 25.00, 5.00, 'portions');

-- Clients de test
INSERT INTO clients (id, restaurant_id, name, phone, email, address) VALUES 
('550e8400-e29b-41d4-a716-446655440040', '550e8400-e29b-41d4-a716-446655440000', 'Koffi Amédée', '+228 91 23 45 67', 'koffi@email.com', 'Lomé, Bè'),
('550e8400-e29b-41d4-a716-446655440041', '550e8400-e29b-41d4-a716-446655440000', 'Awa Traoré', '+228 92 34 56 78', 'awa@email.com', 'Lomé, Tokoin'),
('550e8400-e29b-41d4-a716-446655440042', '550e8400-e29b-41d4-a716-446655440000', 'Mensah Komlan', '+228 93 45 67 89', NULL, 'Lomé, Agoè');

-- ========================================
-- VALIDATION FINALE
-- ========================================

-- Vérification que tout est bien créé
DO $$
BEGIN
    RAISE NOTICE 'Schéma PostgreSQL créé avec succès pour Restaurant Gout Divin';
    RAISE NOTICE 'Tables créées : %', (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE');
    RAISE NOTICE 'Vues créées : %', (SELECT COUNT(*) FROM information_schema.views WHERE table_schema = 'public');
    RAISE NOTICE 'Fonctions créées : %', (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'public');
    RAISE NOTICE 'Triggers créés : %', (SELECT COUNT(*) FROM information_schema.triggers WHERE trigger_schema = 'public');
END $$;
