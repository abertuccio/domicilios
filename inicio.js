var express = require('express');
var app = express();
app.use(express.static('frontend'));
const { Pool } = require('pg')

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'domicilios',
  password: '1234',
  port: 9999,
});

app.get('/', function (req, res) {
  res.send('El servicio anda');
});

app.get('/poligonos_provincias', async function (req, res) {
  const client = await pool.connect();
  const departamentos = await client.query('select p.id_provincia, p.nombre, ST_AsGeoJSON(p.poligono) as poligono from provincias p');
  // console.log(departamentos)
  res.send(departamentos);
});

app.get('/poligonos_departamentos/:id_provincia', async function (req, res) {
  const id_provincia = req.params.id_provincia
  const client = await pool.connect();
  const departamentos = await client.query('select d.id_departamento, d.nombre, ST_AsGeoJSON(d.poligono) as poligono from departamentos d where d.id_provincia ='+id_provincia);
  // console.log(departamentos)
  res.send(departamentos);
});

app.get('/provincias', async function (req, res) {  
  const client = await pool.connect();
  const provincias = await client.query('select id_provincia as id, nombre as text from provincias');
  // console.log(departamentos)
  res.send(provincias);
});

app.get('/departamentos', async function (req, res) {  
  const client = await pool.connect();
  const provincias = await client.query('select id_departamento as id, nombre from departamentos');
  // console.log(departamentos)
  res.send(provincias);
});

app.get('/asentamientos', async function (req, res) {  
  const client = await pool.connect();
  const provincias = await client.query('select id_asentamiento as id, nombre from asentamientos');
  // console.log(departamentos)
  res.send(provincias);
});



app.listen(3000, function () {
  console.log('funcionando en el puerto 3000!');
});