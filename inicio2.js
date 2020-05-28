const { Pool } = require('pg')
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'domicilios',
  password: '1234',
  port: 6432,
});

(async () => {
    const client = await pool.connect()
    try {
      const res = await client.query('select * from provincias');
      console.log(res)
    } finally {
      client.release()
    }
  })().catch(err => console.log(err.stack))