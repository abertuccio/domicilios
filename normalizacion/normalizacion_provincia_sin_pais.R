require("RPostgreSQL")
require("stringdist")

con <- dbConnect(dbDriver("PostgreSQL"), dbname = 'pgsint', host='localhost', port=9999, user='postgres', password=1234)


o <- dbGetQuery(con, "select distinct(provincia) as nombre from smap.rnpr_distincts rd
                          where regexp_replace(regexp_replace(rd.pais, '^\\s+', ''), '\\s+$', '') = ''
                          or pais = ' '
                          or pais is null")

n <- dbGetQuery(con, "select p.id_provincia, p.nombre from provincias p 
                      where p.id_pais = 12
                      union 
                      select sp.id_provincia, sp.sinonimo as nombre from sinonimos_provincias sp 
                      where id_provincia in (
                      select p.id_provincia from provincias p
                      )")

o$p_norm <- tolower(o$nombre)
o$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", o$p_norm, perl=TRUE)
o$p_norm <- gsub("á", "a", o$p_norm, perl=TRUE)
o$p_norm <- gsub("é", "e", o$p_norm, perl=TRUE)
o$p_norm <- gsub("í", "i", o$p_norm, perl=TRUE)
o$p_norm <- gsub("ó", "o", o$p_norm, perl=TRUE)
o$p_norm <- gsub("ú", "u", o$p_norm, perl=TRUE)

n$p_norm <- tolower(n$nombre)
n$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", n$p_norm, perl=TRUE)
n$p_norm <- gsub("á", "a", n$p_norm, perl=TRUE)
n$p_norm <- gsub("é", "e", n$p_norm, perl=TRUE)
n$p_norm <- gsub("í", "i", n$p_norm, perl=TRUE)
n$p_norm <- gsub("ó", "o", n$p_norm, perl=TRUE)
n$p_norm <- gsub("ú", "u", n$p_norm, perl=TRUE)

o[,c("norm_2","id_provincia")] <- n[amatch(o$p_norm, n$p_norm, maxDist=2),][,c("nombre","id_provincia")]
#o[,c("norm_max","id_provincia")] <- n[amatch(o$p_norm, n$p_norm, maxDist=7),][,c("nombre","id_provincia")]

actualizar <- data.frame(nombre = o[!is.na(o$norm_2),c("nombre")])

#excluidos <- data.frame(o[is.na(o$norm_2),c("nombre","norm_max")])

dbWriteTable(con, "smap.rnpr_provincia_sin_pais", actualizar, row.names=TRUE, append=FALSE)

dbGetQuery(con, "UPDATE smap.rnpr_distincts rd
                  SET id_pais = 12
                  FROM smap.rnpr_provincia_sin_pais n
                  WHERE rd.provincia = n.nombre
                  and regexp_replace(regexp_replace(rd.pais, '^\\s+', ''), '\\s+$', '') = '' 
                  or pais is null")

dbRemoveTable(con, "smap.rnpr_provincia_sin_pais")

dbDisconnect(con)



