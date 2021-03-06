require("RPostgreSQL")
require("stringdist")
require("here")
source(here("./config/conexion.R"))

if(dbExistsTable((pg_con, c("smap","rnpr_provincias_excluidas"))){
  dbRemoveTable((pg_con, c("smap","rnpr_provincias_excluidas"))
}

if(dbExistsTable((pg_con, c("smap","rnpr_provincias_normalizadas"))){
  dbRemoveTable((pg_con, c("smap","rnpr_provincias_normalizadas"))
}

dbGetQuery((pg_con, "update smap.rnpr_distincts rd set id_provincia = null where id_pais = 12")

o <- dbGetQuery((pg_con, "select distinct provincia as nombre from smap.rnpr_distincts where id_pais = 12")

o$p_norm <- trimws(o$nombre)
o <- o[o$p_norm != '',]

n <- dbGetQuery((pg_con, "select id_provincia as id,
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
o[,c("norm_max","codigo_max")] <- n[amatch(o$p_norm, n$p_norm, maxDist=15),][,c("nombre","id")]
o$dist <- stringdist(o$p_norm,o$norm_max)

excluidos <- data.frame(o[is.na(o$norm_2),c("nombre","norm_max","dist")])

dbWriteTable((pg_con, c("smap","rnpr_provincias_excluidas"), value=excluidos, row.names=TRUE, append=FALSE)

o$id_provincia <- o[,"codigo_2"]
o$provincia <- o[,"nombre"]
o <-o[,c("id_provincia","provincia")]

dbWriteTable((pg_con, c("smap","rnpr_provincias_normalizadas"), value=o, row.names=TRUE, append=FALSE)


dbGetQuery((pg_con, "UPDATE smap.rnpr_distincts rd
                  SET id_provincia = o.id_provincia
                  FROM smap.rnpr_provincias_normalizadas o
                  WHERE rd.provincia = o.provincia
                  AND rd.id_pais = 12")

dbRemoveTable((pg_con,"smap.rnpr_provincias_normalizadas")


dbDisconnect((pg_con)
