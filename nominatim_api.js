const queryString = require('query-string');
const http = require('http');
const https = require('https');

async function get(direccion){

    // if(direccion.city == 'Villa Lynch'){

    //   console.log(queryString.stringify(direccion));
    // }

    const parsed = queryString.stringify(direccion)


    return new Promise((resolve, reject) => {

        let output = '';

        https.get({            
            hostname: 'nominatim.openstreetmap.org',
            port: 443,
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
    