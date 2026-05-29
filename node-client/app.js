// Client Node.js — Interroge l'API Python et affiche un rapport des logs Azure
// -----------------------------------------------------------------

const path = require('path');

// Configuration partagée chargée depuis config.json (à la racine du projet)
const config = require(path.join(__dirname, '..', 'config.json'));
const API_URL = `http://${config.api.host}:${config.api.port}${config.api.route}`;

const axios = require('axios');

async function getLogs() {
    try {
        const response = await axios.get(API_URL);

        const data = response.data;

        console.log('\n========================================');
        console.log('   RAPPORT D\'ANALYSE DES LOGS AZURE    ');
        console.log('========================================');
        console.log(`  Erreurs detectees  : ${data.error_count}`);
        console.log(`  Avertissements     : ${data.warning_count}`);
        console.log(`  Messages info      : ${data.info_count}`);
        console.log('\n--- Detail des erreurs ---');
        data.errors.forEach(err => console.log(` > ${err}`));
        console.log('\n--- Detail des avertissements ---');
        data.warnings.forEach(warn => console.log(` > ${warn}`));
        console.log('========================================\n');

    } catch (error) {
        console.error('Erreur de connexion a l\'API Python :', error.message);
    }
}

getLogs();
