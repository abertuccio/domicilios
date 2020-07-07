require("leaflet")
# require("RPostgreSQL")
require("sp")
require("rgeos")
require("leaflet.extras")
require("rpostgis")

# con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)

conn <- dbConnect(dbDriver("PostgreSQL"), host = "localhost", dbname = "pgsint" , port=9999 ,
                  user = "postgres", password = "1234")

query<-"select point from smap.asentamientos where id_asentamiento = 1114"
# arne <- pgGetGeom(conn, query=query)
ase <- pgGetGeom(conn, query=query, geom = "geom")
plot(arne,axes=TRUE)
# leaflet(ase)


