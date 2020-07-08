require("RPostgreSQL")
require("stringdist")
require("here")
source(here("./config/conexion.R"))

if(dbExistsTable((pg_con, c("jlobasso","prueba001"))){
  dbRemoveTable((pg_con, c("jlobasso","prueba001"))
}
pruebamem <- dbGetQuery((pg_con, "select p2.nombre as provincia, id_provincia FROM smap.provincias p2")
dbWriteTable(pg_con, c("jlobasso","prueba001"), value=pruebamem, row.names=TRUE, append=FALSE)

dbDisconnect((pg_con)

