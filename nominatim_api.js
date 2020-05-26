const queryString = require('query-string');
const http = require('http');

async function get(direccion){

    const parsed = queryString.stringify(direccion)

    return new Promise((resolve, reject) => {

        let output = '';

        http.get({
            hostname: 'localhost',
            port: 7070,
            path: '/search.php?'+parsed
          }, (res) => {

            res.on('data', (chunk) => {
                output += chunk;
              }); 
    
            res.on('end', () => {
                let obj = JSON.parse(output);
                resolve(obj); 
              });
    
          });


    });

   

}

     
module.exports = {get};
    