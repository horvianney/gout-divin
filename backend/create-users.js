const bcrypt = require('bcryptjs');

async function createUsers() {
  try {
    // Créer les hash corrects
    const managerPassword = await bcrypt.hash('manager123', 10);
    const caissierPassword = await bcrypt.hash('caissier123', 10);
    
    console.log('Hash des mots de passe créés:');
    console.log('Manager:', managerPassword);
    console.log('Caissier:', caissierPassword);
    
    // Mettre à jour le fichier server-simple.js avec ces hash
    console.log('\nCopie ces hash dans server-simple.js:');
    console.log('manager:', managerPassword);
    console.log('caissier:', caissierPassword);
    
  } catch (error) {
    console.error('Erreur:', error);
  }
}

createUsers();
