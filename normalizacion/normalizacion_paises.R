require("RPostgreSQL")
require("stringdist")

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'pgsint', host='localhost', port=9999, user='postgres', password=1234)

if(dbExistsTable(con, "smap.rnpr_paises_excluidos")){
  dbRemoveTable(con,"smap.rnpr_paises_excluidos")
}

if(dbExistsTable(con, "smap.rnpr_paises_normalizados")){
  dbRemoveTable(con,"smap.rnpr_paises_normalizados")
}

dbGetQuery(con, "update smap.rnpr_distincts rd set id_pais = null")

o <- dbGetQuery(con, "select distinct pais as nombre from smap.rnpr_distincts")
o$p_norm <- trimws(o$nombre)
o <- o[o$p_norm != '',]

n <- dbGetQuery(con, "select id_pais as id,
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

dbWriteTable(con, "smap.rnpr_paises_excluidos", excluidos, row.names=TRUE, append=FALSE)

o$id_pais <- o[,"codigo_2"]
o$pais <- o[,"nombre"]
o <-o[,c("id_pais","pais")]

dbWriteTable(con, "smap.rnpr_paises_normalizados", o, row.names=TRUE, append=FALSE)


dbGetQuery(con, "UPDATE smap.rnpr_distincts rd
                  SET id_pais = o.id_pais
                  FROM smap.rnpr_paises_normalizados o
                  WHERE rd.pais = o.pais")

dbRemoveTable(con,"smap.rnpr_paises_normalizados")


dbDisconnect(con)
