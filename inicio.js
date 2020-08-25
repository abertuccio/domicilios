var express = require('express');
var app = express();
app.use(express.static('frontend'));
const { Pool } = require('pg')
const { Client } = require('pg')

const client = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'dbname',
  password: 'password',
  port: 0000,
});

client.connect();

app.get('/', function (req, res) {
  res.send('El servicio anda');
});

app.get('/poligonos_provincias/:id_provincia', async function (req, res) {
  const departamentos = await client.query('select p.id_provincia, p.nombre, ST_AsGeoJSON(p.poligono) as poligono from provincias p');
  // console.log(departamentos)
  res.send(departamentos);
});

app.get('/poligonos_departamentos/:id_provincia', async function (req, res) {
  const id_provincia = req.params.id_provincia
  // const client = await pool.connect();
  const departamentos = await client.query('select d.id_departamento, d.nombre, ST_AsGeoJSON(d.poligono) as poligono from departamentos d where d.id_provincia ='+id_provincia);
  // console.log(departamentos)
  res.send(departamentos);
});

app.get('/provincias', async function (req, res) {  
  // const client = await pool.connect();
  const provincias = await client.query('select id_provincia as id, nombre from provincias');
  // console.log(departamentos)
  res.send(JSON.stringify(provincias));
});

app.get('/departamentos', async function (req, res) {
  let provincias = req.query.provincias;
  provincias = (provincias)?JSON.parse(provincias):false;
  provincias = (!provincias)?"":"where id_provincia in ("+provincias.map(e=>+e).join(",")+")";
  console.log(provincias);
  // const client = await pool.connect();
  const departamentos = await client.query(`select p.nombre as nombre_provincia, 
                                            d.id_provincia,
                                            d.id_departamento as id, 
                                            d.nombre from departamentos d 
                                            inner join 
                                            provincias p on p.id_provincia = d.id_provincia `+provincias);
  // console.log(departamentos)
  res.send(departamentos);
});

app.get('/asentamientos', async function (req, res) {
  let departamentos = req.query.departamentos;
  departamentos = (departamentos)?JSON.parse(departamentos):false;
  departamentos = (!departamentos)?"":"where id_departamento in ("+departamentos.map(e=>+e).join(",")+")";
  
  // const client = await pool.connect();
  const asentamientos = await client.query(`select p.nombre as nombre_provincia,
  d.id_departamento, 
  d.nombre as nombre_departamento, 
  a.id_asentamiento as id, a.nombre 
  from asentamientos a 
  inner join departamentos d on a.id_departamento = d.id_departamento 
  inner join provincias p on d.id_provincia = p.id_provincia `+departamentos);
  // console.log(departamentos)
  res.send(asentamientos);
});



app.listen(3000, function () {
  console.log('funcionando en el puerto 3000!');
});
