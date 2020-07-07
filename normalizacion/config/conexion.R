require("RPostgreSQL")

pg_conexion <- dbConnect(
  dbDriver("PostgreSQL"), 
  dbname = 'pgsint', 
  host='localhost', 
  port=9999, 
  user='postgres', 
  password=1234)
  
return(pg_conexion)
