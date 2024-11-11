const express = require('express');
const router = express.Router();
const pool = require('../config/postgres');

// Endpoint pour récupérer les utilisateurs de PostgreSQL
router.get('/api/users', async (req, res) => {
    try {
        const checkTable = await pool.query(`
            SELECT EXISTS (
                SELECT 1
                FROM information_schema.tables 
                WHERE table_name = 'users'
            );
        `);

        if (!checkTable.rows[0].exists) {
            await pool.query(`
                CREATE TABLE users (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(100) NOT NULL,
                    email VARCHAR(100) NOT NULL UNIQUE
                );
            `);

            const users = [
                { name: 'User 1', email: 'user1@example.com' },
                { name: 'User 2', email: 'user2@example.com' },
                { name: 'User 3', email: 'user3@example.com' },
                { name: 'User 4', email: 'user4@example.com' },
                { name: 'User 5', email: 'user5@example.com' },
            ];

            const insertUsers = users.map(user => {
                return pool.query('INSERT INTO users (name, email) VALUES ($1, $2)', [user.name, user.email]);
            });

            await Promise.all(insertUsers);
        }

        const result = await pool.query('SELECT * FROM users');
        res.json(result.rows);
    } catch (err) {
        console.error('Erreur lors de la récupération des utilisateurs:', err);
        res.status(500).send('Erreur du serveur');
    }
});

module.exports = router;
