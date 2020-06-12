const queryString = require('query-string');
const http = require('http');
const https = require('https');

const nominatim = {hostname:'nominatim.openstreetmap.org',
                    port:443} 

const local =  {hostname:'127.0.0.1',
                port:7070}                    

async function get(direccion){

    const parsed = queryString.stringify(direccion)
    const q = "q="+direccion.city+","+direccion.county+","+direccion.state+","+direccion.country+"&polygon_geojson=1&format=json";
    const parsed_q = encodeURI(q);

    return new Promise((resolve, reject) => {

        let output = '';

        http.get({            
            hostname: local.hostname,
            port: local.port,
            path: '/search.php?'+parsed,
            headers: { 'User-Agent': 'DOM-2020' }
          }, (res) => {
            res.on('data', (chunk) => {
                output += chunk;
              }); 
    
            res.on('end', () => {
              console.log(output);
              let obj ={}
              try {
                obj = JSON.parse(output);
            } catch(e) {
              obj ={}
            }                
                resolve(obj); 
              });

              res.on('error',(e)=>{
console.log(e);
              })
    
          });


    });

   

}

     
module.exports = {get};
    