const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'food_delivery_db',
  password: 'AllforOne@1912',
  port: 5432,
});

async function checkConnection() {
  try {
    const client = await pool.connect();
    console.log('Connected to database');
    client.release();
  } catch (error) {
    console.error('Error connecting to database:', error.message);
  }
}

module.exports = { pool, checkConnection };