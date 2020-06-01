require("RPostgreSQL")
ruta <- getwd()
source(paste(ruta,"/normalizacion.R",sep=""))

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)

origen_paises <- dbGetQuery(con, "select distinct pais as nombre from rnpr_distincts")
origen_paises$nombre <- trimws(origen_paises$nombre)
origen_paises <- data.frame(nombre = origen_paises[origen_paises$nombre != '',])
norma_paises <- dbGetQuery(con, "select id_pais as id,
                                        nombre_iso as nombre 
                                        from paises p
                                union
                                select id_pais as id, 
                                        sinonimo as nombre 
                                        from rnpr_sinonimos rs 
                                where codigo in (select codigo_numerico from paises p)")

paises <- normalizacion(origen_paises,norma_paises)

dbDisconnect(con)


