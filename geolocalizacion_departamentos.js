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
      const prov_norm = await client.query('select id_provincia, nombre_nominatim as nombre from provincias p where id_provincia = 20');
      
      prov_norm.rows.forEach(async p => {

        direccion.state = p.nombre;

            const dep_norm = await client.query(`select d.id_departamento, 
                                                  d.prefijo||' '||d.nombre as nombre 
                                                  from departamentos d 
                                                  where id_provincia = $1
                                                  union
                                                  select sd.id_departamento, 
                                                  d.prefijo||' '||sinonimo as nombre 
                                                  from sinonimos_departamentos sd 
                                                  inner join 
                                                  departamentos d on d.id_departamento = sd.id_departamento 
                                                  where d.id_provincia = $1`,[p.id_provincia]);

            dep_norm.rows.forEach(async (d)=>{

                
                d.nombre = d.nombre.replace("\n","");
                d.nombre = d.nombre.replace("  "," ").trim();
                direccion.county = d.nombre;
                
                const dep_geo = await nominatim_api.get(direccion);

                if(dep_geo.length && "display_name" in dep_geo[0]){

                  const values = [dep_geo[0].lat,
                                  dep_geo[0].lon,
                                  dep_geo[0].osm_id,
                                  dep_geo[0].display_name.split(",")[0].trim(),
                                  dep_geo[0].display_name.trim(),
                                  d.id_departamento];

                  await client.query(`update departamentos d
                                                        set latitud = $1, 
                                                        longitud = $2, 
                                                        relation = $3,
                                                        nombre_nominatim = $4,
                                                        nombre_nominatim_long = $5,
                                                        fuente_ubicacion = 'NOMINATIM',
                                                        f_actualizacion = now()
                                                        where id_departamento = $6`,values);

                }
                else{
                    // await client.query(`INSERT INTO osm_departamentos_excluidos(id_departamento, nombre)
                    // VALUES ($1, $2)`,[d.id_departamento,d.nombre]);
                    console.log("no encontrado "+d.nombre)
                }

            })

        
          
      });
      
    } finally {
      client.release()
    }
  })().catch(err => console.log(err.stack))