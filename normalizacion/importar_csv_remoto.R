require("RPostgreSQL")

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)

barha <- read.csv("http://www.bahra.gob.ar/descargas/archivos/base_total/base_total.csv")

if(dbExistsTable(con, "barha_test")){
  dbRemoveTable(con,"barha_test")
}

dbWriteTable(con, "barha_test", barha, row.names=TRUE)
