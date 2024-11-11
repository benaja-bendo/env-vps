const { Pool } = require('pg');

const pool = new Pool({
    user: process.env.PG_USER || 'your_pg_user',
    host: process.env.PG_HOST || 'localhost',
    database: process.env.PG_DATABASE || 'your_pg_database',
    password: process.env.PG_PASSWORD || 'your_pg_password',
    port: process.env.PG_PORT || 5432,
});

module.exports = pool;
