require("RPostgreSQL")
con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)

distincts <- dbGetQuery(con, "select distinct pais, provincia, municipio, ciudad from ciudadanos_sintys cs")

if(dbExistsTable(con, "rnpr_distincts")){
 dbGetQuery(con, "TRUNCATE TABLE rnpr_distincts;")
}else{
  
}