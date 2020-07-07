if(!require("PostgreSQL")){
  install.packages("PostgreSQL")
  library("PostgreSQL")
}

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'pgsint', host='localhost', port=9999, user='postgres', password=1234)

distincts <- dbGetQuery(con, "select distinct pais, provincia, municipio, ciudad from ciudadanos_sintys cs")

if(dbExistsTable(con, "smap.rnpr_distincts")){
 dbGetQuery(con, "TRUNCATE TABLE smap.rnpr_distincts;")
}

dbWriteTable(con, "smap.rnpr_distincts", distincts, row.names=FALSE, append=FALSE)