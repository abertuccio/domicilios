require("stringdist")
require("RPostgreSQL")

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=5432, user='postgres', password=1234)

provincias_b <- dbGetQuery(con, "select distinct codigo_indec_provincia, nombre_provincia from bahra")

provincias_o <- read.csv("/home/andres/Documents/domicilios/extractos/distinct_pais_provincia.csv",stringsAsFactors = FALSE)

