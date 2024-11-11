require('dotenv').config(); // Charge les variables d’environnement
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

const connectMongoDB = require('./config/mongodb');
const userRoutes = require('./routes/users');

// Connexion à MongoDB
connectMongoDB().then(db => {
    // Stockez la référence MongoDB si nécessaire
    app.locals.mongoDb = db;
});

app.use((req, res, next) => {
    console.log(`${req.method} ${req.url}`);
    next();
});

app.get('/', (req, res) => {
    res.json({ message: 'welcome' });
});

app.get('/api', (req, res) => {
    res.json({ message: 'Hello from the API!' });
});

// Utilisation des routes
app.use(userRoutes);

app.listen(PORT, () => {
    console.log(`API listening on port ${PORT}`);
});
