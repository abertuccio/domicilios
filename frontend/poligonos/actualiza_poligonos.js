const { Pool } = require('pg')
const fs = require('fs');
const path = require('path');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'domicilios',
  password: '1234',
  port: 9999,
});

const carpetas = ['./provincias','./departamentos','./asentamientos'];

carpetas.forEach(c=>{

  fs.readdir(c, (err, files) => {
    if (err) throw err;
  
    for (const file of files) {
      fs.unlink(path.join(c, file), err => {
        if (err) throw err;
      });
    }
  });

})

;(async () => {

  const client = await pool.connect();
  try {
const provincias = await client.query('select p.id_provincia, ST_AsGeoJSON(p.poligono) as pol from provincias p');

provincias.rows.forEach(p=>{
  fs.writeFile('./provincias/'+p.id_provincia+'.json', p.pol,function (err) {
    if (err) return console.log(err);
    console.log('ok prov');
  })
});

const departamentos = await client.query('select d.id_departamento, ST_AsGeoJSON(d.poligono) as pol from departamentos d');

departamentos.rows.forEach(d=>{
  fs.writeFile('./departamentos/'+d.id_departamento+'.json', d.pol,function (err) {
    if (err) return console.log(err);
    console.log('ok dep');
  })
});

const asentamientos = await client.query('SELECT a.id_asentamiento, ST_AsGeoJSON(a.poligono) as pol from asentamientos a where poligono is not null');

asentamientos.rows.forEach(a=>{
  const pol = JSON.parse(a.pol);
  pol.crs = {"type":"name","properties":{"name":"EPSG:4326"}}
  fs.writeFile('./asentamientos/'+a.id_asentamiento+'.json', JSON.stringify(pol),function (err) {
    if (err) return console.log(err);
    console.log('ok ase');
  })
});


} finally {
  client.release()
}
})().catch(err => console.log(err.stack))