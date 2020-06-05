require("RPostgreSQL")
require("stringdist")

id_provincia <- 1  #SOLO CABA POR AHORA

con <- dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)


o <- dbGetQuery(con, paste("select municipio,ciudad, 
                                          id_pais,
                                          id_provincia 
                                          from rnpr_distincts rd 
                                          where id_pais = 12
                                          and id_provincia is not null 
                                          and id_departamento is null
                                          and ciudad <> 'SIN_INFORMAR'
                                          and id_provincia = ",id_provincia))

n <- dbGetQuery(con, paste("select a2.id_asentamiento, 
                            a2.nombre, 
                            a2.id_departamento
                            from asentamientos a2 
                            inner join departamentos dp 
                            on a2.id_departamento = dp.id_departamento
                            where id_provincia = ",id_provincia,
                            " union
                            select sa.id_asentamiento, 
                            sa.sinonimo as nombre,
                            a.id_departamento 
                            from sinonimos_asentamientos sa
                            inner join asentamientos a 
                            on a.id_asentamiento = sa.id_asentamiento                             
                            where sa.id_asentamiento 
                            in (select 
                            a2.id_asentamiento 
                            from asentamientos a2 
                            inner join departamentos dp 
                            on a2.id_departamento = dp.id_departamento
                            where id_provincia = ",id_provincia,
                           ")"))

o$p_norm <- tolower(o$ciudad)
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

o[,c("norm_2","id_asentamiento","id_departamento")] <- n[amatch(o$p_norm, n$p_norm, maxDist=2),][,c("nombre","id_asentamiento","id_departamento")]
o[,c("norm_max","id_asentamiento","id_departamento")] <- n[amatch(o$p_norm, n$p_norm, maxDist=7),][,c("nombre","id_asentamiento","id_departamento")]

actualizar <- o[!is.na(o$norm_2),c("municipio","ciudad","id_pais","id_provincia","id_asentamiento","id_departamento")]

excluidos <- data.frame(o[is.na(o$norm_2),c("ciudad","norm_max")])

 dbWriteTable(con, "rnpr_asentamientos_sin_departamentos", actualizar, row.names=TRUE, append=FALSE)
 
 dbGetQuery(con, paste("UPDATE rnpr_distincts rd
                   SET id_asentamiento = n.id_asentamiento,
                   id_departamento = n.id_departamento
                   FROM rnpr_asentamientos_sin_departamentos n
                   WHERE rd.ciudad = n.ciudad
                   and rd.municipio = n.municipio
                   AND rd.id_pais = 12
                   AND rd.id_provincia = ",id_provincia))
 
 dbRemoveTable(con, "rnpr_asentamientos_sin_departamentos")

dbDisconnect(con)



