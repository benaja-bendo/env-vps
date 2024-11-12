const { Pool } = require('pg');

const pool = new Pool({
    user: process.env.PG_USER || 'root',
    host: process.env.PG_HOST || 'postgres',
    database: process.env.PG_DATABASE || 'first-db',
    password: process.env.PG_PASSWORD || 'root',
    port: process.env.PG_PORT || 5432,
});

module.exports = pool;
