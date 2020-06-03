require("RPostgreSQL")
require("stringdist")

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)

if(dbExistsTable(con, "rnpr_provincias_excluidas")){
  dbRemoveTable(con,"rnpr_provincias_excluidas")
}

if(dbExistsTable(con, "rnpr_provincias_normalizadas")){
  dbRemoveTable(con,"rnpr_provincias_normalizadas")
}

dbGetQuery(con, "update rnpr_distincts rd set id_provincia = null where id_pais = 12")

o <- dbGetQuery(con, "select distinct provincia as nombre from rnpr_distincts where id_pais = 12")

o$p_norm <- trimws(o$nombre)
o <- o[o$p_norm != '',]

n <- dbGetQuery(con, "select id_provincia as id,
                              nombre
                              from provincias p
                              union 
                              select sp.id_provincia as id, 
                              sp.sinonimo as nombre 
                              from sinonimos_provincias sp")

o$p_norm <- tolower(o$nombre)
o$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", o$p_norm, perl=TRUE)
o$p_norm <- gsub("á", "a", o$p_norm, perl=TRUE)
o$p_norm <- gsub("é", "e", o$p_norm, perl=TRUE)
o$p_norm <- gsub("í", "i", o$p_norm, perl=TRUE)
o$p_norm <- gsub("ó", "o", o$p_norm, perl=TRUE)
o$p_norm <- gsub("ú", "u", o$p_norm, perl=TRUE)
o <- o[o$p_norm != "sininformar",]

n$p_norm <- tolower(n$nombre)
n$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", n$p_norm, perl=TRUE)
n$p_norm <- gsub("á", "a", n$p_norm, perl=TRUE)
n$p_norm <- gsub("é", "e", n$p_norm, perl=TRUE)
n$p_norm <- gsub("í", "i", n$p_norm, perl=TRUE)
n$p_norm <- gsub("ó", "o", n$p_norm, perl=TRUE)
n$p_norm <- gsub("ú", "u", n$p_norm, perl=TRUE)

o[,c("norm_2","codigo_2")] <- n[amatch(o$p_norm, n$p_norm, maxDist=2),][,c("nombre","id")]
o[,c("norm_max","codigo_max")] <- n[amatch(o$p_norm, n$p_norm, maxDist=7),][,c("nombre","id")]

excluidos <- data.frame(o[is.na(o$norm_2),c("nombre","norm_max")])

dbWriteTable(con, "rnpr_provincias_excluidas", excluidos, row.names=TRUE, append=FALSE)

o$id_provincia <- o[,"codigo_2"]
o$provincia <- o[,"nombre"]
o <-o[,c("id_provincia","provincia")]

dbWriteTable(con, "rnpr_provincias_normalizadas", o, row.names=TRUE, append=FALSE)


dbGetQuery(con, "UPDATE rnpr_distincts rd
                  SET id_provincia = o.id_provincia
                  FROM rnpr_provincias_normalizadas o
                  WHERE rd.provincia = o.provincia
                  AND rd.id_pais = 12")

dbRemoveTable(con,"rnpr_paises_normalizados")


dbDisconnect(con)
