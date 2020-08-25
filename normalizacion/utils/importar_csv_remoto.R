  require("RPostgreSQL")

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'dbname', host='localhost', port=0000, user='postgres', password='password')

barha <- read.csv("http://www.bahra.gob.ar/descargas/archivos/base_total/base_total.csv")

if(dbExistsTable(con, "barha_test")){
  dbRemoveTable(con,"barha_test")
}

dbWriteTable(con, "barha_test", barha, row.names=TRUE)

dbDisconnect(con)
