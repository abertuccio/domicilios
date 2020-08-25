const { Pool } = require('pg')
const nominatim_api = require('./nominatim_api');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'dbname',
  password: 'password',
  port: 0000,
  idleTimeoutMillis: 0,
  connectionTimeoutMillis: 0,
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
      
            const ase_norm_query = await client.query(`select a.id_asentamiento, a.nombre, d.nombre_nominatim as departamento, p.nombre_nominatim as provincia from asentamientos a
            inner join departamentos d on a.id_departamento = d.id_departamento 
            inner join provincias p on p.id_provincia = d.id_provincia
            where a.relation is null
            union 
            select sa.id_asentamiento, sa.sinonimo as nombre, d.nombre_nominatim as departamento, p.nombre_nominatim as provincia from sinonimos_asentamientos sa 
            inner join asentamientos a on a.id_asentamiento = sa.id_asentamiento 
            inner join departamentos d on a.id_departamento = d.id_departamento 
            inner join provincias p on p.id_provincia = d.id_provincia
            where a.relation is null`);
                                                  
            const ase_norm =  ase_norm_query.rows;

            let encontrados = 0;
            let no_encontrados = 0;

            for (let i = 0; i < ase_norm.length; i++){

                setTimeout(async function () { 

                    ase_norm[i].nombre = ase_norm[i].nombre.replace("\n","");
                    ase_norm[i].nombre = ase_norm[i].nombre.replace("  "," ").trim();
                
                    direccion.state = ase_norm[i].provincia;
                    direccion.county = ase_norm[i].departamento;
                    direccion.city = ase_norm[i].nombre;

                    const ase_geo = await nominatim_api.get(direccion);

                    // console.log(ase_geo);


                    if(ase_geo.length && "display_name" in ase_geo[0]){

                        console.log(ase_geo[0]);

                          encontrados++;

                          
                          const values = [ase_geo[0].osm_id,
                          ase_geo[0].display_name.split(",")[0].trim(),
                          ase_geo[0].display_name.trim(),
                          ase_norm[i].id_asentamiento];
                          
                          //   console.log(ase_norm[i].id_asentamiento);
                          
                          await client.query(`update asentamientos a
                                              set relation = $1,
                                              nombre_nominatim = $2,
                                              nombre_nominatim_long = $3,
                                              fuente_ubicacion = 'NOMINATIM',
                                              f_actualizacion = now()
                                              where id_asentamiento = $4`,values);

                          poligon = ase_geo[0].geojson                          
                          poligon.crs = JSON.parse('{"type":"name","properties":{"name":"EPSG:4326"}}')

                          if(ase_geo[0].geojson.type == "Polygon"){
                            await client.query(`update asentamientos 
                                                set poligono = ST_TRANSFORM(ST_GeomFromGeoJSON('${JSON.stringify(poligon)}'),3857)
                                                where id_asentamiento = ${ase_norm[i].id_asentamiento}`);                   

                          }


                    }
                    else{
                        no_encontrados++;
                        //console.log("No se encontró "+ase_norm[i].nombre);
                    }

                    console.log("Procesesado: "+ Math.floor(i*100/ase_norm.length)+"%"+" - Encontrados: "+encontrados+" - No encontrados: "+no_encontrados);

                 }, 50 * i);

                 
                }                           
                
                console.log("FIN");
                  //  await client.query(`update asentamientos 
                  //                       set poligono = x.geometry
                  //                       from
                  //                       (SELECT osm_id, geometry FROM dblink
                  //                           ('nomimap',
                  //                           'select 
                  //                               osm_type,
                  //                               osm_id, 
                  //                               geometry 
                  //                           from public.placex'
                  //                           ) 
                  //                       AS DATA(
                  //                           osm_type bpchar,
                  //                           osm_id int8, 
                  //                           geometry geometry
                  //                       )
                  //                       where osm_type = 'R'
                  //                       and osm_id in (select relation from asentamientos)) as x
                  //                       where relation = x.osm_id`);
      
    } finally {
      client.release()
    }
  })().catch(err => console.log(err.stack))

