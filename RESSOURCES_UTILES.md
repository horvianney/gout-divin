# Ressources Utiles - Restaurant Togo

**Outils gratuits et liens essentiels pour ton projet**

---

## Plateformes Principales

### Supabase (Base de données)
- **URL:** https://supabase.com
- **Coût:** Gratuit (500MB DB, 2GB bandwidth)
- **Usage:** PostgreSQL + Auth + Storage
- **Setup:** Créer projet > Importer schema.sql > Générer clés API

### Vercel (Frontend)
- **URL:** https://vercel.com
- **Coût:** Gratuit
- **Usage:** Déploiement React/Vite
- **Setup:** Connecter GitHub > Auto-deploy sur push

### Railway (Backend)
- **URL:** https://railway.app
- **Coût:** 5$/mois (5$ crédits gratuits)
- **Usage:** Node.js backend
- **Setup:** Fork repo > Connecter Railway > Deploy

---

## WhatsApp & Communication

### Twilio WhatsApp API
- **URL:** https://twilio.com
- **Coût:** 15$ crédits gratuits
- **Prix:** ~0.05$ par message
- **Setup:** 
  1. Créer compte Twilio
  2. Activer WhatsApp Sandbox
  3. Obtenir Account SID + Auth Token
  4. Configurer webhook

**Messages Templates (Togo):**
```
- Commande prête: "Votre commande #{order_id} est prête! Merci de votre confiance."
- Stock critique: "URGENT: Stock {product_name} critique ({quantity} restants)"
- Promotion: "PROMO SPÉCIALE: -20% sur tous les plats aujourd'hui seulement!"
```

---

## Design & UI

### Tailwind CSS
- **URL:** https://tailwindcss.com
- **Coût:** Gratuit
- **Usage:** Styles rapides, responsive
- **CDN:** `<script src="https://cdn.tailwindcss.com"></script>`

### Lucide Icons
- **URL:** https://lucide.dev
- **Coût:** Gratuit
- **Usage:** Icônes modernes, légères
- **Installation:** `npm install lucide-react`

### Google Fonts (Optimisé 2G)
- **URL:** https://fonts.google.com
- **Recommandé:** Inter (400, 600, 700)
- **Optimisation:** Preload critical fonts

---

## Graphiques & Charts

### Chart.js
- **URL:** https://chartjs.org
- **Coût:** Gratuit
- **Poids:** 20KB gzipped
- **Optimisation 2G:** Désactiver animations

**Configuration optimisée:**
```javascript
options: {
  animation: { duration: 0 }, // Pas d'animations 2G
  responsive: true,
  maintainAspectRatio: false
}
```

---

## QR Codes

### QR Code.js
- **URL:** https://github.com/davidshimjs/qrcodejs
- **Coût:** Gratuit
- **Usage:** Générer QR codes pour menus
- **Installation:** `npm install qrcode`

**Exemple usage:**
```javascript
import QRCode from 'qrcode'
QRCode.toDataURL('https://restaurant.togo/menu/1')
```

---

## PDF Generation

### jsPDF
- **URL:** https://github.com/parallax/jsPDF
- **Coût:** Gratuit
- **Usage:** Rapports PDF mensuels
- **Installation:** `npm install jspdf`

**Template Rapport:**
```javascript
const doc = new jsPDF()
doc.setFontSize(20)
doc.text('Rapport Restaurant', 20, 20)
doc.setFontSize(12)
doc.text(`Période: ${startDate} - ${endDate}`, 20, 30)
```

---

## Excel/CSV Import

### SheetJS
- **URL:** https://sheetjs.com
- **Coût:** Gratuit
- **Usage:** Importer produits depuis Excel
- **Installation:** `npm install xlsx`

**Format Excel attendu:**
```
| Nom Produit       | Catégorie | Prix | Stock | Seuil |
|------------------|-----------|-------|-------|-------|
| Riz sauce arachide| Plats     | 1500  | 50    | 10    |
| Poulet braisé    | Plats     | 2500  | 30    | 5     |
```

---

## Monitoring & Debug

### Uptime Robot
- **URL:** https://uptimerobot.com
- **Coût:** Gratuit (50 monitors)
- **Usage:** Vérifier disponibilité API

### Logtail
- **URL:** https://betterstack.com/logs
- **Coût:** Gratuit (1M logs/mois)
- **Usage:** Logs d'erreurs en production

---

## Domain Togo

### .tg Domain Registration
- **Registrar:** GoDaddy, Namecheap
- **Coût:** ~10$/année
- **Recommandé:** restaurant-nom.tg

---

## Performance Mobile 2G

### Test Tools
- **Lighthouse:** https://web.dev/lighthouse
- **PageSpeed Insights:** https://pagespeed.web.dev
- **Network Throttling:** Chrome DevTools

### Optimisations Essentielles
```javascript
// Service Worker pour cache
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  )
})

// Lazy loading images
const imgObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const img = entry.target
      img.src = img.dataset.src
    }
  })
})
```

---

## Sécurité

### OWASP Checklist
- **HTTPS:** Obligatoire (Let's Encrypt gratuit)
- **Rate Limiting:** 100 req/15min par IP
- **Input Validation:** Joi ou Zod
- **Password Hashing:** bcrypt
- **JWT:** 7 jours expiration

### Tools
- **Helmet.js:** https://helmetjs.github.io
- **bcrypt:** `npm install bcryptjs`
- **Joi:** `npm install joi`

---

## Déploiement Automatisé

### GitHub Actions
```yaml
name: Deploy to Production
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
```

---

## Formation Équipe

### Vidéos Tutoriels (Français)
- **React Base:** https://www.youtube.com/playlist?list=PLjwdMgw5TtYq6X2c0CfaQr9H_x8p3QYnM
- **Node.js:** https://www.youtube.com/playlist?list=PLjwdMgw5TtYq6X2c0CfaQr9H_x8p3QYnM
- **Supabase:** https://www.youtube.com/playlist?list=PLjwdMgw5TtYq6X2c0CfaQr9H_x8p3QYnM

### Documentation Utilisateur
- **Guide Serveur:** 2 pages max, images grandes
- **Guide Caissier:** Étapes simples 1-2-3
- **Guide Gérant:** Dashboard + rapports

---

## Backup & Recovery

### Stratégie Backup
```javascript
// Backup automatique quotidien
const backupData = async () => {
  const data = {
    sales: await getAllSales(),
    stock: await getAllStock(),
    clients: await getAllClients()
  }
  
  // Envoyer vers Supabase Storage
  await supabase.storage
    .from('backups')
    .upload(`backup-${Date.now()}.json`, JSON.stringify(data))
}
```

---

## Communauté Togo

### Groups & Forums
- **Togo Dev Community:** https://togo-dev.slack.com
- **Africa Developers:** https://github.com/africa-developers
- **React Africa:** https://twitter.com/ReactAfrica

### Meetups (Lomé)
- **Lomé Tech Meetup:** 1er jeudi chaque mois
- **Togo JavaScript:** 2ème vendredi chaque mois

---

## Emergency Contacts

### Support Technique
- **Supabase:** https://supabase.com/help
- **Vercel:** https://vercel.com/support
- **Railway:** https://railway.app/help

### Local Togo
- **Internet Providers:** Togocom, Moov
- **Power Backup:** ONRES (pour serveur local)
- **Tech Communities:** Lomé Tech Hub

---

## Quick Start Commands

```bash
# Backend
cd backend
npm install
npm run dev

# Frontend  
cd frontend
npm install
npm run dev

# Build Production
npm run build

# Deploy
git push origin main
```

---

**Made with love for Togo developers**  
*Resources curated by Vianney - Lomé, Togo*
