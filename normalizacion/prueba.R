require("RPostgreSQL")
require("stringdist")

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'pgsint', host='localhost', port=9999, user='postgres', password=1234)

provpob <- dbGetQuery(con, "select p2.nombre as provincia, count(cs.provincia) as poblacion, p2.poligono as poligono 
	from smap.provincias p2 
	inner join smap.rnpr_distincts rd on rd.id_provincia = p2.id_provincia
	inner join inicial.ciudadanos_renaper cs on rd.provincia = cs.provincia 
	group by p2.nombre,p2.poligono; 
	")

dbDisconnect(con)
