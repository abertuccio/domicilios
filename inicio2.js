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
      const prov_norm = await client.query('select * from provincias where id_provincia = 13');
      //const prov_norm = await client.query('select * from provincias');
      
      prov_norm.rows.forEach(async p => {

        direccion.state = p.nombre;
          
        const prov_geo = await nominatim_api.get(direccion);

        if(prov_geo.length && "display_name" in prov_geo[0]){

            //console.log("P_B: "+ p.nombre + "    -    P_N :"+prov_geo[0].display_name);

            const dep_norm = await client.query(`select id_departamento, (case 
                                                when p.prefijo_departamento_municipio is null 
                                                then '' 
                                                else p.prefijo_departamento_municipio END)||' '||nombre as nombre  
                                                from prefijos p 
                                                CROSS JOIN
                                                (select d.id_departamento, d.nombre from departamentos d 
                                                where d.id_provincia = $1
                                                union 
                                                select sd.id_departamento, sd.sinonimo as nombre 
                                                from sinonimos_departamentos sd
                                                where id_departamento 
                                                in (select d.id_departamento from departamentos d 
                                                where d.id_provincia = $1)) as nom
                                                where p.id_provincia = $1 `,[13]);

            dep_norm.rows.forEach(async (d)=>{

                d.nombre = d.nombre.replace("\n","");
                direccion.county = d.nombre;

                const dep_geo = await nominatim_api.get(direccion);

                if(dep_geo.length && "display_name" in dep_geo[0]){
/* 
                  console.log(dep_geo[0].lat)
                  console.log(dep_geo[0].lon) 
                  console.log(dep_geo[0].osm_id) 
                  console.log(dep_geo[0].display_name) */

                  const values = [dep_geo[0].lat,
                                  dep_geo[0].lon,
                                  dep_geo[0].osm_id,
                                  d.id_departamento];

                  const insert = await client.query(`update departamentos d
                                                        set latitud = $1, 
                                                        longitud = $2, 
                                                        relation = $3,
                                                        fuente_ubicacion = 'NOMINATIM',
                                                        f_actualizacion = now()
                                                        where id_departamento = $4`,values);

                }
                else{
                    //console.log("no se encontro: "+d.nombre)
                    //console.log(direccion)
                }

            })

        }
          
      });
      
    } finally {
      client.release()
    }
  })().catch(err => console.log(err.stack))