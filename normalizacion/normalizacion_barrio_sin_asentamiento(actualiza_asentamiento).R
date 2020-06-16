require("RPostgreSQL")
require("stringdist")
require("here")
source(here("estandarizacion_vectores.R"))

con <- dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=9999, user='postgres', password=1234)


oringen_asentamientos_barrios <- dbGetQuery(con, paste("select provincia,
                                  municipio,
                                  ciudad, 
                                  id_asentamiento,
                                  id_departamento,
                                  id_provincia
                                  from rnpr_distincts rd 
                                  where id_pais = 12
                                  and id_provincia is not null 
                                  and id_departamento is not null
                                  and ciudad <> 'SIN_INFORMAR'
                                  and id_asentamiento is null"))

by(oringen_asentamientos_barrios, 1:nrow(oringen_asentamientos_barrios), function(row){
 
  print(paste("buscando...",row$id_departamento))
  
  n <- dbGetQuery(con, paste("select b3.id_barrio, b3.nombre, b3.id_asentamiento from barrios b3
                            inner join asentamientos a on b3.id_asentamiento = a.id_asentamiento 
                            inner join departamentos d on d.id_departamento = a.id_departamento
                            where a.id_departamento = ",row$id_departamento,
                            " and d.id_provincia =  ",row$id_provincia,
                            " union
                            select b2.id_barrio, sb.sinonimo as nombre , b2.id_asentamiento from barrios b2 
                            left join sinonimos_barrios sb on b2.id_barrio = sb.id_barrio 
                            inner join asentamientos a on b2.id_asentamiento = a.id_asentamiento
                            inner join departamentos d on d.id_departamento = a.id_departamento
                            where a.id_departamento = ",row$id_departamento,
                            " and d.id_provincia =  ",row$id_provincia,
                            " and sb.sinonimo is not null"))
  
  row$p_norm <- tolower(row$ciudad)
  row$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", row$p_norm, perl=TRUE)
  row$p_norm <- gsub("á", "a", row$p_norm, perl=TRUE)
  row$p_norm <- gsub("é", "e", row$p_norm, perl=TRUE)
  row$p_norm <- gsub("í", "i", row$p_norm, perl=TRUE)
  row$p_norm <- gsub("ó", "o", row$p_norm, perl=TRUE)
  row$p_norm <- gsub("ú", "u", row$p_norm, perl=TRUE)
  
  
  n$p_norm <- tolower(n$nombre)
  n$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("á", "a", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("é", "e", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("í", "i", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("ó", "o", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("ú", "u", n$p_norm, perl=TRUE)
  
  
  if(nrow(n)>0){
    
  # row <- estandarizacion(row)
  # n <- estandarizacion(n)
  
  n$id_departamento <- row$id_departamento
  
  row[,c("norm_2","id_asentamiento","id_departamento","id_barrio")] <- n[amatch(row$p_norm, n$p_norm, maxDist=2),][,c("nombre","id_asentamiento","id_departamento","id_barrio")]
  row[,c("norm_max","id_asentamiento","id_departamento","id_barrio")] <- n[amatch(row$p_norm, n$p_norm, maxDist=7),][,c("nombre","id_asentamiento","id_departamento","id_barrio")]

  actualizar <- row[!is.na(row$norm_2),c("municipio","ciudad","id_provincia","id_asentamiento","id_departamento","id_barrio")]
  
    if(nrow(actualizar)>0){
      
      print("actualizando...")
      
      dbGetQuery(con, paste("UPDATE rnpr_distincts rd 
                            SET id_asentamiento = ",actualizar$id_asentamiento,",
                            id_barrio = ",actualizar$id_barrio, " 
                            WHERE rd.ciudad = '",actualizar$ciudad,"' 
                            and rd.id_departamento = ",actualizar$id_departamento," 
                            AND rd.id_pais = 12 
                            AND rd.id_provincia = ",actualizar$id_provincia,sep = ''))

    }
    
  }
  

})

print("FIN")

dbDisconnect(con)



