const pgp = require('pg-promise')(/* initialization options */);

const cn = {
    host: 'localhost', 
    port: 6432,
    database: 'domicilios',
    user: 'postgres',
    password: '1234'
};

const db = pgp(cn);

(async()=>{

    const result  = await db.one("select count(*) from rnpr_normalizacion rn");
    
    console.log(result)

})();
