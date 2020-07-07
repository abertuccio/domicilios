require("RPostgreSQL")
con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'pgsint', host='localhost', port=9999, user='postgres', password=1234)

print("calculando ciclos y rangos...")

ciclos <- 350
registros_totales <- dbGetQuery(con, "select count(id_ciudadano_renaper) from inicial.ciudadanos_renaper where estado = 0 or estado is null;")
rangos <-  ceiling(registros_totales/ciclos)

if(registros_totales<=ciclos){
  ciclos <- 1
  rangos <- registros_totales   
}

norma_distincts <- dbGetQuery(con, "select distinct pais, provincia, municipio, ciudad, id_pais, id_provincia, id_departamento, id_asentamiento from smap.rnpr_distincts rd")


for(i in 1:ciclos){
  
  ciudadanos <- dbGetQuery(con, paste("select id_ciudadano_renaper, pais, provincia, municipio, ciudad
                        from inicial.ciudadanos_renaper
                        where estado = 0 
                        or estado is null
                        limit ",rangos,";"))


  # ant_mer <- nrow(ciudadanos)
  ciudadanos_normalizados <- merge(x = ciudadanos, y = norma_distincts, by = c("pais","provincia", "municipio", "ciudad"), all.x = TRUE)
  # mer <- nrow(ciudadanos_normalizados)
  # print(paste("anterior: ",ant_mer," posterior: ",mer))

  ciudadanos_normalizados <- ciudadanos_normalizados[,c("id_ciudadano_renaper","id_pais","id_provincia","id_departamento","id_asentamiento")]
  
  dbWriteTable(con, "public.segmento_actualizacion", ciudadanos_normalizados, row.names=TRUE, append=FALSE, overwrite=TRUE)

  dbGetQuery(con, "insert into detergido.ciudadanos_domicilios
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
          from segmento_actualizacion")
  
  dbGetQuery(con, "update inicial.ciudadanos_renaper set estado = 1 
                    where id_ciudadano_renaper in (select id_ciudadano_renaper from public.segmento_actualizacion)")

  print(paste(floor(i*100/ciclos),"% competado"))

}

if(dbExistsTable(con, "segmento_actualizacion")){
  dbRemoveTable(con, "segmento_actualizacion")
}

print("100% competado")

dbDisconnect(con)