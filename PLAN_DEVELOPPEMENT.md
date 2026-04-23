# Plan de Développement - Restaurant Togo (7 Semaines)

**Objectif:** MVP fonctionnel pour restaurant togolais avec mode hors ligne obligatoire  
**Budget:** 0$ - tout gratuit ou open source  
**Développeur:** Vianney, étudiant fullstack au Togo

---

## Semaine 1: Fondations & Authentification
**Durée:** 7 jours | **Priorité:** HAUTE

### Tâches:
- [x] **Structure de base** (backend + frontend)
- [x] **Configuration Node.js + Express** avec sécurité de base
- [x] **Setup React + Vite + Tailwind** avec PWA
- [x] **Authentification multi-rôles** (gérant, caissier, cuisinier, livreur)
- [ ] **Tests d'auth** et validation des rôles
- [ ] **Déploiement test** sur Vercel (frontend) + Railway (backend)

### Livrables:
- Login/logout fonctionnel
- 4 rôles avec permissions différentes
- PWA installable sur mobile
- Base de données Supabase configurée

### Ressources:
- Supabase: https://supabase.com (gratuit 500MB)
- Railway: https://railway.app (5$ crédits gratuits)
- Vercel: https://vercel.com (gratuit)

---

## Semaine 2: Module Ventes Hors Ligne
**Durée:** 7 jours | **Priorité:** HAUTE

### Tâches:
- [x] **POS (Point de Vente)** avec interface tactile
- [x] **Gestion panier** en temps réel
- [x] **Mode hors ligne** avec localStorage
- [x] **Sync automatique** quand réseau revient
- [ ] **QR Code scanner** pour menus
- [ ] **Validation des paiements** (cash, mobile money, Mixx)

### Livrables:
- POS fonctionnel hors ligne
- Synchronisation transparente
- Scan QR codes menus
- 3 méthodes de paiement

### Astuces Togo:
```
- Boutons larges pour doigts sur mobile
- Pas d'animations sur 2G
- Cache des produits fréquents
- Sync toutes les 5 minutes max
```

### Ressources:
- QR Code JS: https://github.com/davidshimjs/qrcodejs
- HTML5 QR Scanner: https://github.com/mebjas/html5-qrcode

---

## Semaine 3: Dashboard & Statistiques
**Durée:** 7 jours | **Priorité:** MOYENNE

### Tâches:
- [x] **Dashboard principal** avec stats du jour
- [x] **Chart.js léger** compatible 2G
- [x] **Alertes intelligentes** (stock critique, charges >80%)
- [x] **Performance mobile** (cache, lazy loading)
- [ ] **Graphiques avancés** (ventes par heure, produits populaires)
- [ ] **Export CSV** des rapports

### Livrables:
- Dashboard responsive mobile-first
- Graphiques qui fonctionnent sur 2G
- Alertes temps réel
- Export des données

### Optimisation 2G:
```
- Pas d'animations CSS
- Images compressées < 50KB
- Charts en canvas (pas SVG)
- Cache HTTP 7 jours
```

### Ressources:
- Chart.js: https://chartjs.org (20KB gzipped)
- Lodash: https://lodash.com (pour performance)

---

## Semaine 4: Gestion des Stocks
**Durée:** 7 jours | **Priorité:** MOYENNE

### Tâches:
- [x] **Interface stock** avec alertes seuil
- [x] **Import Excel** des produits existants
- [x] **Mouvements automatiques** (ventes -> stock)
- [ ] **Alertes WhatsApp** stock critique
- [ ] **Historique des mouvements**
- [ ] **Prévisions de réapprovisionnement**

### Livrables:
- Gestion stock complète
- Import Excel/CSV fonctionnel
- Alertes automatiques
- Historique détaillé

### Import Excel:
```javascript
// Format attendu:
// Nom | Catégorie | Prix | Stock initial | Seuil alerte
// Riz sauce arachide | Plats | 1500 | 50 | 10
// Poulet braisé | Plats | 2500 | 30 | 5
```

### Ressources:
- SheetJS: https://sheetjs.com (Excel import)
- Papaparse: https://papaparse.com (CSV parsing)

---

## Semaine 5: WhatsApp & QR Codes
**Durée:** 7 jours | **Priorité:** MOYENNE

### Tâches:
- [x] **Intégration Twilio WhatsApp**
- [x] **QR Codes menus** personnalisés
- [x] **Notifications automatiques**
- [ ] **Templates messages** (promos, rappels)
- [ ] **Stats WhatsApp** (taux d'ouverture)
- [ ] **Campagnes marketing** via WhatsApp

### Livrables:
- WhatsApp API fonctionnelle
- QR codes pour chaque table/menu
- Messages automatiques
- Analytics de base

### Messages WhatsApp (Togo):
```
- "Votre commande #123 est prête! 15min de retard prévu"
- "Stock critique: Poulet braisé (reste 5 unités)"
- "Promo du jour: -20% sur tous les plats"
```

### Ressources:
- Twilio: https://twilio.com (15$ crédits gratuits)
- QR Code Generator: https://qr-code-generator.com

---

## Semaine 6: Rapports PDF & Sync Avancé
**Durée:** 7 jours | **Priorité:** MOYENNE

### Tâches:
- [x] **Génération PDF** des rapports
- [x] **Envoi automatique** par WhatsApp
- [x] **Sync avancée** (conflits, priorités)
- [ ] **Rapports personnalisés**
- [ ] **Backup automatique** des données
- [ ] **Restauration données** (si perte)

### Livrables:
- PDF rapports mensuels
- Envoi WhatsApp automatique
- Sync robuste avec gestion conflits
- Backup/restore fonctionnel

### Structure PDF:
```
Rapport Restaurant Chez Vianney
Période: 1-30 Novembre 2024
- Revenu total: 2,450,000 FCFA
- Ventes: 1,234 commandes
- Top produit: Poulet braisé (456 ventes)
- Stock critique: 3 produits
```

### Ressources:
- jsPDF: https://github.com/parallax/jsPDF
- html2canvas: https://html2canvas.hertzen.com

---

## Semaine 7: Tests & Déploiement Production
**Durée:** 7 jours | **Priorité:** HAUTE

### Tâches:
- [ ] **Tests complets** (unitaires + E2E)
- [ ] **Performance optimisation** (mobile 2G)
- [ ] **Sécurité audit** (OWASP basics)
- [ ] **Documentation utilisateur**
- [ ] **Formation équipe** (serveurs, cuisiniers)
- [ ] **Déploiement production** monitoring

### Livrables:
- Application 100% testée
- Documentation complète
- Équipe formée
- Production monitoring

### Checklist Sécurité:
```
- HTTPS obligatoire
- Rate limiting activé
- Passwords hashés (bcrypt)
- Input validation
- CORS restrictif
- Pas de secrets en frontend
```

### Monitoring:
- Uptime Robot: https://uptimerobot.com (gratuit)
- Logtail: https://betterstack.com/logs (gratuit)

---

## Coûts Mensuels (Production)

| Service | Coût | Usage |
|---------|------|-------|
| Supabase | 0$ | 500MB DB, 2GB Bandwidth |
| Railway | 5$ | Backend Node.js |
| Vercel | 0$ | Frontend statique |
| Twilio | 10$ | WhatsApp messages |
| Domain | 10$ | .tg domain |
| **Total** | **25$** | **Budget respecté** |

---

## Timeline Visuel

```
Semaine 1:  [##########] Auth & Structure
Semaine 2:  [##########] Ventes Hors Ligne  
Semaine 3:  [##########] Dashboard & Stats
Semaine 4:  [##########] Gestion Stocks
Semaine 5:  [##########] WhatsApp & QR
Semaine 6:  [##########] PDF & Sync
Semaine 7:  [##########] Tests & Prod
```

---

## Risques & Solutions

### Risque 1: Réseau Togo instable
**Solution:** Mode hors ligne obligatoire + sync intelligent

### Risque 2: Budget limité
**Solution:** 100% stack open source + crédits gratuits

### Risque 3: Utilisateurs peu techniques
**Solution:** Interface ultra-simple + formation pratique

### Risque 4: Maintenance limitée
**Solution:** Code simple + documentation complète

---

## Succès Métriques

- **Performance:** < 3s chargement sur 2G
- **Disponibilité:** 99% uptime 
- **Adoption:** 80% ventes via app en 1 mois
- **Satisfaction:** < 5min formation par utilisateur

---

## Prochaines Étapes (Post-MVP)

1. **App mobile native** (si budget permet)
2. **Intégration paiement** (Wave, Orange Money)
3. **Multi-restaurants** (franchise)
4. **IA prédictions** (ventes, stock)
5. **Marketplace** (fournisseurs locaux)

---

**Made with love for Togo restaurants**  
*Par Vianney, dev fullstack togolais*  
*Lomé, Togo - Novembre 2024*
