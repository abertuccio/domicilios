const { Pool } = require('pg')
const nominatim_api = require('./nominatim_api');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'domicilios',
  password: '1234',
  port: 9999,
});

const direccion = {
    street:null,
    city:null,
    county:null,
    state:null,
    country:"Argentina",
    postalcode:null,
    polygon_geojson:1,
    format:"json",
    "accept-language":"es"
  }

;(async () => {
    const client = await pool.connect()
    try {
      const prov_norm = await client.query('select id_provincia, nombre from provincias');
      
      prov_norm.rows.forEach(async p => {

        direccion.state = p.nombre;
          
        const prov_geo = await nominatim_api.get(direccion);

        if(prov_geo.length && "display_name" in prov_geo[0]){

            const nombres = [prov_geo[0].display_name.split(",")[0].trim(),
                            prov_geo[0].display_name.trim(),
                            prov_geo[0].osm_id,
                            p.id_provincia];

            await client.query(`UPDATE provincias SET nombre_nominatim = $1,
                                                nombre_nominatim_long = $2,
                                                relation = $3
                                                where id_provincia = $4`,nombres);

        }
          
      });
      
    } finally {
      client.release()
    }
  })().catch(err => console.log(err.stack))