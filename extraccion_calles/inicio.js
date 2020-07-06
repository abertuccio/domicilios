const util = require('util');
const exec = util.promisify(require('child_process').exec);
const { Client } = require('pg');
const client = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'domicilios',
    password: '1234',
    port: 9999,
  });

  client.connect();

async function obtenemosDepartamentos(){

    return await client.query('select id_departamento, relation from smap.departamentos');
}



async function obtenemos_boundary(relation_id) {
  try {
      const { stdout, stderr } = await exec('osmium getid -r -t argentina-latest.osm.pbf r'+relation_id+' -o boundary_'+relation_id+'.osm');
      console.log('Obtenemos boundary');      
      console.log(stderr);
  }catch (err){
     console.error(err);
  };
};

async function extraemos_boundary_completo(relation_id) {
    try {
        const { stdout, stderr } = await exec('osmium extract -p boundary_'+relation_id+'.osm argentina-latest.osm.pbf -o completo_'+relation_id+'.pbf');
        console.log('Obtenemos boundary completo');
        console.log(stderr);
    }catch (err){
       console.error(err);
    };
  };

  async function filtramos_calles(relation_id) {
    try {
        const { stdout, stderr } = await exec('osmium tags-filter completo_'+relation_id+'.pbf w/highway -o calles_'+relation_id+'.osm.pbf');
        console.log('Filtramos calles');
        console.log(stderr);
    }catch (err){
       console.error(err);
    };
  };    

  async function pbf_a_json(relation_id) {
    try {
        const { stdout, stderr } = await exec('osmtogeojson calles_'+relation_id+'.osm.pbf > calles_'+relation_id+'.geojson');
        console.log('convertimos a json');
        console.log(stderr);
    }catch (err){
       console.error(err);
    };
  }; 

  async function eliminamos_archivos(relation_id) {
    try {
        const { stdout, stderr } = await exec('rm boundary_*.osm && rm calles_*.osm.pbf && rm completo_*.pbf');
        console.log('Eliminamos archivos');
        console.log(stderr);
    }catch (err){
       console.error(err);
    };
  }; 

  async function cambiamos_archivos(relation_id) {
    try {
        const { stdout, stderr } = await exec('mv calles_'+relation_id+'.geojson calles_'+relation_id+'.json');
        console.log('Cambiamos nombre');
        console.log(stderr);
    }catch (err){
       console.error(err);
    };
  }; 

(async()=>{

    const relation_id = 1767342;

    await obtenemos_boundary(relation_id);
    await extraemos_boundary_completo(relation_id);
    await filtramos_calles(relation_id);
    await pbf_a_json(relation_id); 
    await eliminamos_archivos(relation_id);
    await cambiamos_archivos(relation_id);

    var relation = require('./calles_'+relation_id+'.json');

    // console.log(relation);

    const calles = relation.features.reduce((p,c)=>{

        if("name" in c.properties && !p.includes(c.properties.name)){
            p.push(c.properties.name);
        }


        return p;
    },[]);

    calles.forEach(e => {
        if(e.includes("Doctor")){
            console.log(e);
        }
    });


})();
