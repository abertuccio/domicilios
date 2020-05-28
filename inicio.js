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
    format:"json",
    "accept-language":"es"
  }
  
  const provincias_n  = await db.many("select * from provincias where id_provincia in (1)");

  provincias_n.forEach(async p=>{

    direccion.state = p.nombre;

    const res = await nominatim_api.get(direccion);

    if(res.length && "display_name" in res[0]){
       console.log("P_B: "+ p.nombre + "    -    P_N :"+res[0].display_name);

       const departamentos_n  = await db.many("select * from departamentos where id_provincia = "+p.id_provincia);

       departamentos_n.forEach(async d=>{
        d.nombre = d.nombre.replace("\n","");
        direccion.county = d.nombre.trim();

        //console.log(direccion)

        if(direccion.county.length){

          const res2 = await nominatim_api.get(direccion);

          if(res2.length && "display_name" in res2[0]){
            console.log("D_B_P "+direccion.state+": "+ d.nombre + "    -    P_N_P "+direccion.state+":"+res2[0].display_name);
          }
          else{
            "!!!!!!!!!!!!!!!!!!!!!!!! "+d.nombre+" no encontrada !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
          } 


        }        
        
        

       })

     }
     else{
       "!!!!!!!!!!!!!!!!!!!!!!!! "+p.nombre+" no encontrada !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
     }
  

  })


})();
