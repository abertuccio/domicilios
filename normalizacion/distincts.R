if(!require("PostgreSQL")){
  install.packages("PostgreSQL")
  library("PostgreSQL")
}
require("here")
source(here("./config/conexion.R"))

distincts <- dbGetQuery(pg_con, "select distinct pais, provincia, municipio, ciudad from ciudadanos_sintys cs")

if(dbExistsTable(pg_con,  "smap.rnpr_distincts")){
 dbGetQuery(pg_con, "TRUNCATE TABLE smap.rnpr_distincts;")
}

dbWriteTable(pg_con, "smap.rnpr_distincts", distincts, row.names=FALSE, append=FALSE)