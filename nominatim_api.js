const pgp = require('pg-promise')(/* initialization options */);
const http = require('http')


const cn = {
    host: 'localhost', 
    port: 6432,
    database: 'domicilios',
    user: 'postgres',
    password: '1234'
};

const db = pgp(cn);

(async()=>{

    const result  = await db.many("select * from provincias");
    
    const street=null;
    const city=null;
    const county="Morón";
    const state="Buenos Aires";
    const country="Argentina";
    const postalcode=null;

    let output = '';

    http.get({
        hostname: 'localhost',
        port: 7070,
        path: '/search.php?country=Argentina&state=Buenos%20aires&county=Moron&polygon_geojson=1&format=json'
      }, (res) => {          
        res.on('data', (chunk) => {
            output += chunk;
          });  
        res.on('end', () => {
            let obj = JSON.parse(output);
            console.log(obj) 
      
            
            //onResult(res.statusCode, obj);
          });
      });


})();
