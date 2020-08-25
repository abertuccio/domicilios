require("RPostgreSQL")

pg_con <- dbConnect(
  dbDriver("PostgreSQL"), 
  dbname = 'dbname', 
  host='localhost', 
  port=0000, 
  user='postgres', 
  password='pasword')
  
return(pg_con)
