require("RPostgreSQL")
require("stringdist")
require("here")
source(here("./config/conexion.R"))

if(dbExistsTable(pg_con, c("smap","rnpr_paises_excluidos"))){
  dbRemoveTable(pg_con, c("smap","rnpr_paises_excluidos"))
}

if(dbExistsTable(pg_con, c("smap","rnpr_paises_normalizados"))){
  dbRemoveTable(pg_con, c("smap","rnpr_paises_normalizados"))
}

dbGetQuery(pg_con, "update smap.rnpr_distincts rd set id_pais = null")

o <- dbGetQuery(pg_con, "select distinct pais as nombre from smap.rnpr_distincts")
o$p_norm <- trimws(o$nombre)
o <- o[o$p_norm != '',]

n <- dbGetQuery(pg_con, "select id_pais as id,
                                  nombre
                                  from paises p
                                  union
                                  select sp.id_pais as id,
                                  sp.sinonimo as nombre
                                  from sinonimos_paises sp")

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

dbWriteTable(pg_con, c("smap","rnpr_paises_excluidos"), value=excluidos, row.names=TRUE, append=FALSE)

o$id_pais <- o[,"codigo_2"]
o$pais <- o[,"nombre"]
o <-o[,c("id_pais","pais")]

dbWriteTable(pg_con, c("smap","rnpr_paises_normalizados"), value=o, row.names=TRUE, append=FALSE)


dbGetQuery(pg_con, "UPDATE smap.rnpr_distincts rd
                  SET id_pais = o.id_pais
                  FROM smap.rnpr_paises_normalizados o
                  WHERE rd.pais = o.pais")

dbRemoveTable(pg_con, c("smap","rnpr_paises_normalizados"))

dbDisconnect(pg_con)
