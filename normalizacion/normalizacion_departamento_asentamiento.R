require("RPostgreSQL")
require("here")

source(here("normalizacion_general_function.R"))

completo <- TRUE

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'pgsint', host='localhost', port=9999, user='postgres', password=1234)

if(dbExistsTable(con, "smap.rnpr_reporte_normalizacion")){
   dbRemoveTable(con, "smap.rnpr_reporte_normalizacion")
}

if(dbExistsTable(con, "smap.rnpr_departamentos_inexistentes_en_origen")){
   dbRemoveTable(con, "smap.rnpr_departamentos_inexistentes_en_origen")
}

if(dbExistsTable(con, "smap.rnpr_departamentos_normalizados")){
   dbRemoveTable(con, "smap.rnpr_departamentos_normalizados")
}

if(dbExistsTable(con, "smap.rnpr_asentamientos_normalizados")){
   dbRemoveTable(con, "smap.rnpr_asentamientos_normalizados")
}

if(dbExistsTable(con, "smap.rnpr_departamentos_excluidos")){
      dbRemoveTable(con,"smap.rnpr_departamentos_excluidos")
}

if(dbExistsTable(con, "smap.rnpr_asentamientos_excluidos")){
   dbRemoveTable(con,"smap.rnpr_asentamientos_excluidos")
}

norma_provincias <- dbGetQuery(con, "select id_provincia,
                                     nombre
                                      from provincias p 
                                      where id_pais = 12;")

#revisar if completo is false
condicion_departamentos <- "and d.id_departamento is null"
condicion_asentamientos <- "and rd.id_asentamiento is null"

#revisar if completo is false
if(completo){
   dbGetQuery(con, "update smap.rnpr_distincts rd set id_departamento = null where id_pais = 12;")
   condicion_departamentos <- ""
   condicion_asentamientos <- ""
}

 by(norma_provincias, 1:nrow(norma_provincias), function(row){
    
    print(paste("---> Buscando provincia: ",row$nombre))
    
   origen_departamentos <- dbGetQuery(con, paste("select distinct municipio as nombre
                                            from smap.rnpr_distincts rd
                                            where id_pais = 12
                                           and id_provincia = ",row$id_provincia))
   
   norma_departamentos <- dbGetQuery(con, paste("select id_departamento as id, 
                                            		nombre 
                                            		from departamentos d 
                                            		where id_provincia = ",row$id_provincia,
                                            		" ",condicion_departamentos," union 
                                                select id_departamento as id,
                                            		sinonimo as nombre
                                            		from sinonimos_departamentos sd 
                                            		where id_departamento 
                                            		in (select id_departamento
                                            		from departamentos d 
                                            		where id_provincia = ",row$id_provincia
                                                ," ",condicion_departamentos,");"))
   
   # if(nrow(origen_departamentos)>0 || nrow(departamentos)>0 ){
   #       print(nrow(origen_departamentos))
   #       print(nrow(norma_departamentos))
   #       next
   # }
   
   departamentos <- normalizacion(o = origen_departamentos,
                                   n = norma_departamentos,
                                   nivel = "departamentos",
                                   id_padre = row$id_provincia)
   
   
   
  dbWriteTable(con, "smap.rnpr_departamentos_normalizados", departamentos, row.names=TRUE, append=FALSE)
   
   
   print(paste("---> Actualizando departamentos de: ",row$nombre))
   
   dbGetQuery(con, paste("UPDATE smap.rnpr_distincts rd
                  SET id_departamento = n.id
                  FROM smap.rnpr_departamentos_normalizados n
                  WHERE rd.municipio = n.nombre
                  AND rd.id_pais = 12
                  AND rd.id_provincia = ",row$id_provincia))
   
   dbRemoveTable(con, "smap.rnpr_departamentos_normalizados")
   
   print("--------------------------------------------- ")
   print(paste("--- Finalizado departamentos de provincia de ",row$nombre))
   print("--------------------------------------------- ")
   print("--------------------------------------------- ")
   print(paste("--- Inicio asentamientos de provincia de ",row$nombre))
   print("--------------------------------------------- ")
   
   
   by(norma_departamentos, 1:nrow(norma_departamentos), function(departamento){
      
      #ver el tema de competo
      if(completo){
         dbGetQuery(con, paste("update smap.rnpr_distincts rd set id_asentamiento = null where id_departamento =",departamento$id,";"))
      }
      
   print(paste("--- Buscando asentamientos de departamento: ",departamento$nombre,". Provincia de ",row$nombre," id_provincia:",row$id_provincia))
      
      origen_asentamientos <- dbGetQuery(con, paste("select ciudad as nombre
                                                    from smap.rnpr_distincts rd 
                                                    where id_departamento = ",departamento$id,
                                                    " ",condicion_asentamientos))
      
   # print(paste("--- --- Asentamientos de departamento: ",departamento$nombre," ORIGEN --> ",nrow(origen_asentamientos)))   
      
      norma_asentamientos <- dbGetQuery(con, paste("select id_asentamiento as id, 
                                                         nombre 
                                                         from asentamientos a 
                                                         where id_departamento = ",departamento$id,
                                                         "union
                                                         select id_asentamiento as id,
                                                         sinonimo as nombre 
                                                         from sinonimos_asentamientos sa 
                                                         where id_asentamiento 
                                                         in (select id_asentamiento 
                                                         from asentamientos a 
                                                         where id_departamento = ",departamento$id,")"))
      
   # print(paste("--- --- Asentamientos de departamento: ",departamento$nombre," NORMA --> ",nrow(norma_asentamientos)))   
      
     if(nrow(origen_asentamientos)<1){
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print(paste("NO HAY REGISTROS ORIGEN EN ",departamento$nombre," Provincia de ",row$nombre," id_provincia:",row$id_provincia))
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        
        dep_inex <- data.frame(id_provincia = c(row$id_provincia), id_departamento = c(departamento$id),nombre = c(departamento$nombre))
        
        dbWriteTable(con, "smap.rnpr_departamentos_inexistentes_en_origen", dep_inex, row.names=TRUE, append=TRUE)
        
     }
   else{
      
      asentamientos <- normalizacion(o = origen_asentamientos,
                                     n = norma_asentamientos,
                                     nivel = "asentamientos",
                                     id_padre = departamento$id)
      
      dbWriteTable(con, "smap.rnpr_asentamientos_normalizados", asentamientos, row.names=TRUE, append=FALSE)
      
      
      dbGetQuery(con, paste("UPDATE smap.rnpr_distincts rd
                  SET id_asentamiento = n.id
                  FROM smap.rnpr_asentamientos_normalizados n
                  WHERE rd.ciudad = n.nombre
                  AND rd.id_pais = 12
                  AND rd.id_provincia = ",row$id_provincia,
                            "AND rd.id_departamento = ",departamento$id))
      
      dbRemoveTable(con, "smap.rnpr_asentamientos_normalizados")
      
   }
   
   
      
      
   })
   
   print("--------------------------------------------- ")
   print(paste("--- Finalizamos asentamientos de provincia de ",row$nombre))
   print("--------------------------------------------- ")   

 })
 
 
 print("--------------------------------------------- ")
 print("------------------ FIN ----------------------")
 print("--------------------------------------------- ") 
 
dbDisconnect(con)
