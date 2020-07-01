require("RPostgreSQL")
con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)

print("Truncamos tabla ciudadanos_domicilios ...")

# dbGetQuery(con, "TRUNCATE TABLE ciudadanos_domicilios RESTART IDENTITY;")

print("calculando ciclos y rangos...")

ciclos <- 350
registros_totales <- dbGetQuery(con, "select count(id_ciudadano_sintys) from ciudadanos_sintys where estado = 0 or estado is null;")
rangos <-  ceiling(registros_totales/ciclos)

if(registros_totales<=ciclos){
  ciclos <- 1
  rangos <- registros_totales   
}

norma_distincts <- dbGetQuery(con, "select distinct pais, provincia, municipio, ciudad, id_pais, id_provincia, id_departamento, id_asentamiento from rnpr_distincts rd")


for(i in 1:ciclos){
  
  ciudadanos <- dbGetQuery(con, paste("select id_ciudadano_sintys, pais, provincia, municipio, ciudad
                        from ciudadanos_sintys
                        where estado = 0 
                        or estado is null
                        limit ",rangos,";"))


  # ant_mer <- nrow(ciudadanos)
  ciudadanos_normalizados <- merge(x = ciudadanos, y = norma_distincts, by = c("pais","provincia", "municipio", "ciudad"), all.x = TRUE)
  # mer <- nrow(ciudadanos_normalizados)
  # print(paste("anterior: ",ant_mer," posterior: ",mer))

  ciudadanos_normalizados <- ciudadanos_normalizados[,c("id_ciudadano_sintys","id_pais","id_provincia","id_departamento","id_asentamiento")]
  
  dbWriteTable(con, "segmento_actualizacion", ciudadanos_normalizados, row.names=TRUE, append=FALSE, overwrite=TRUE)

  dbGetQuery(con, "insert into ciudadanos_domicilios
          select NEXTVAL('id_ciudadano_domicilio'),
          id_ciudadano_sintys,
          id_pais,
          id_provincia,
          id_departamento,
          id_asentamiento,
          'SINTYS',
          1,
          '',
          NOW()
          from segmento_actualizacion")
  
  dbGetQuery(con, "update ciudadanos_sintys set estado = 1 
                    where id_ciudadano_sintys in (select id_ciudadano_sintys from segmento_actualizacion)")

  print(paste(floor(i*100/ciclos),"% competado"))

}

if(dbExistsTable(con, "segmento_actualizacion")){
  dbRemoveTable(con, "segmento_actualizacion")
}

print("100% competado")

dbDisconnect(con)