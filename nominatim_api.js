const queryString = require('query-string');
const http = require('http');

async function get(direccion){

    const parsed = queryString.stringify(direccion)

    return new Promise((resolve, reject) => {

        let output = '';

        http.get({            
            hostname: '127.0.0.1',
            port: 7070,
            path: '/search.php?'+parsed
          }, (res) => {
            res.on('data', (chunk) => {
                output += chunk;
              }); 
    
            res.on('end', () => {
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
    