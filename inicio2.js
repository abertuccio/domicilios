const { Pool } = require('pg')
const nominatim_api = require('./nominatim_api');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'domicilios',
  password: '1234',
  port: 6432,
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
      const prov_norm = await client.query('select * from provincias where id_provincia = 4');
      //const prov_norm = await client.query('select * from provincias');
      
      prov_norm.rows.forEach(async p => {

        direccion.state = p.nombre;
          
        const prov_geo = await nominatim_api.get(direccion);

        if(prov_geo.length && "display_name" in prov_geo[0]){

            //console.log("P_B: "+ p.nombre + "    -    P_N :"+prov_geo[0].display_name);

            const dep_norm = await client.query(`select (select p.prefijo_departamento_municipio 
            from prefijos p 
            where p.id_provincia = $1)||' '||nombre as nombre,
            codigo 
            from departamentos d 
            where id_provincia = $1
          union 
          select 
            (select p.prefijo_departamento_municipio 
            from prefijos p 
            where p.id_provincia = $1)||' '||rs.sinonimo as nombre,
            codigo 
            from rnpr_sinonimos rs
          where rs.codigo 
          in (select 
            codigo 
            from departamentos d 
            where id_provincia =$1)`,[4]);

            dep_norm.rows.forEach(async (d)=>{

                d.nombre = d.nombre.replace("\n","");
                direccion.county = d.nombre;

                const dep_geo = await nominatim_api.get(direccion);

                if(dep_geo.length && "display_name" in dep_geo[0]){
                    //console.log(dep_geo[0].display_name);
                }
                else{
                    console.log("no se encontro: "+d.nombre)
                    //console.log(direccion)
                }

            })

        }
          
      });
      
    } finally {
      client.release()
    }
  })().catch(err => console.log(err.stack))