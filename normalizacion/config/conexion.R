require("RPostgreSQL")

pg_con <- dbConnect(
  dbDriver("PostgreSQL"), 
  dbname = 'pgsint', 
  host='localhost', 
  port=9999, 
  user='postgres', 
  password='pasword')
  
return(pg_con)
