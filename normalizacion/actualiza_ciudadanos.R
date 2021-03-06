require("RPostgreSQL")
require("here")
source(here("./config/conexion.R"))

print("calculando ciclos y rangos...")

if(dbExistsTable(pg_con, c("public","segmento_actualizacion"))){
  dbRemoveTable(pg_con, c("public","segmento_actualizacion"))
}

ciclos <- 350
<<<<<<< HEAD
# registros_totales <- dbGetQuery(con, "select count(id_ciudadano_renaper) from inicial.ciudadanos_renaper where estado = 0 or estado is null;")
registros_totales <- 1
=======
registros_totales <- dbGetQuery(pg_con, "select count(id_ciudadano_renaper) from inicial.ciudadanos_renaper where estado = 0 or estado is null;")
>>>>>>> 2466cf1a63038eea26a478dcbfde3e8ac5ab6a1e
rangos <-  ceiling(registros_totales/ciclos)

if(registros_totales<=ciclos){
  ciclos <- 1
  rangos <- registros_totales   
}

norma_distincts <- dbGetQuery(pg_con, "select distinct pais, provincia, municipio, ciudad, id_pais, id_provincia, id_departamento, id_asentamiento from smap.rnpr_distincts rd")

# norma_distincts$municipio <- tolower(norma_distincts$municipio)

for(i in 1:ciclos){
  
<<<<<<< HEAD
  ciudadanos <- dbGetQuery(con, paste("select id_ciudadano_renaper, pais, provincia, convert_to(municipio,'utf-8') municipio, ciudad
                        from inicial.ciudadanos_renaper where id_ciudadano_renaper = 35625107"))
=======
  ciudadanos <- dbGetQuery(pg_con, paste("select id_ciudadano_renaper, pais, provincia, municipio, ciudad
                        from inicial.ciudadanos_renaper
                        where estado = 0 
                        or estado is null
                        limit ",rangos,";"))

>>>>>>> 2466cf1a63038eea26a478dcbfde3e8ac5ab6a1e

  # ciudadanos$municipio <- tolower(ciudadanos$municipio)
  
  # ant_mer <- nrow(ciudadanos)
  ciudadanos_normalizados <- merge(x = ciudadanos, y = norma_distincts, by = c("pais","provincia","municipio", "ciudad"), all.x = TRUE)
  # mer <- nrow(ciudadanos_normalizados)S
  # print(paste("anterior: ",ant_mer," posterior: ",mer))

  ciudadanos_normalizados <- ciudadanos_normalizados[,c("id_ciudadano_renaper","id_pais","id_provincia","id_departamento","id_asentamiento")]
  
<<<<<<< HEAD
  print(nrow(ciudadanos_normalizados))
  
  dbWriteTable(con, "segmento_actualizacion", ciudadanos_normalizados, row.names=TRUE, append=FALSE)

  # dbGetQuery(con, "insert into detergido.ciudadanos_domicilios
  #         select NEXTVAL('detergido.id_ciudadano_domicilio'),
  #         id_ciudadano_renaper,
  #         id_pais,
  #         id_provincia,
  #         id_departamento,
  #         id_asentamiento,
  #         'SINTYS',
  #         1,
  #         '',
  #         NOW()
  #         from public.segmento_actualizacion")
  # 
  # dbGetQuery(con, "update inicial.ciudadanos_renaper set estado = 1 
  #                   where id_ciudadano_renaper in (select id_ciudadano_renaper from public.segmento_actualizacion)")
=======
  dbWriteTable(pg_con, "segmento_actualizacion", ciudadanos_normalizados, row.names=TRUE, append=FALSE)

  dbGetQuery(pg_con, "insert into detergido.ciudadanos_domicilios
          select NEXTVAL('detergido.id_ciudadano_domicilio'),
          id_ciudadano_renaper,
          id_pais,
          id_provincia,
          id_departamento,
          id_asentamiento,
          'SINTYS',
          1,
          '',
          NOW()
          from public.segmento_actualizacion")
  
  dbGetQuery(pg_con, "update inicial.ciudadanos_renaper set estado = 1 
                    where id_ciudadano_renaper in (select id_ciudadano_renaper from public.segmento_actualizacion)")
>>>>>>> 2466cf1a63038eea26a478dcbfde3e8ac5ab6a1e

  dbRemoveTable(pg_con, c("public","segmento_actualizacion"))
  
  print(paste(floor(i*100/ciclos),"% competado"))

}

if(dbExistsTable(pg_con, c("public","segmento_actualizacion"))){
  dbRemoveTable(pg_con, c("public","segmento_actualizacion"))
}

print("100% competado")

dbDisconnect(pg_con)