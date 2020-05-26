const pgp = require('pg-promise')(/* initialization options */);
const nominatim_api = require('./nominatim_api');

const cn = {
    host: 'localhost', 
    port: 6432,
    database: 'domicilios',
    user: 'postgres',
    password: '1234'
};

const db = pgp(cn);

(async()=>{
  
  const direccion = {
    street:null,
    city:null,
    county:null,
    state:null,
    country:"Argentina",
    postalcode:null,
    polygon_geojson:1,
    format:"json"
  }
  
  const result  = await db.many("select * from provincias");

  result.forEach(async p=>{

    direccion.county = p.nombre;

    const res = await nominatim_api.get(direccion);

    if("display_name" in res[0]){
      console.log(res[0].display_name);
    }
  

  })


})();
