require("RPostgreSQL")
ruta <- getwd()
source(paste(ruta,"/normalizacion/normalizacion_general_function.R",sep=""))

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=6432, user='postgres', password=1234)

if(dbExistsTable(con, "rnpr_reporte_normalizacion")){
  dbRemoveTable(con,"rnpr_reporte_normalizacion")
}

if(dbExistsTable(con, "rnpr_excluidos_normalizacion")){
   dbRemoveTable(con,"rnpr_excluidos_normalizacion")
}

FUENTE_ORIGEN_PAISES <- paste(ruta,"/extractos/distinct_paises.csv",sep="")
COLUMNA_ORIGEN_PAISES <- "PAIS"

FUENTE_ORIGEN_PROVINCIAS <- paste(ruta,"/extractos/distinct_pais_provincia.csv",sep="")
COLUMNA_ORIGEN_PROVINCIAS <- "PROVINCIA"

norma_paises <- data.frame(nombre = c("Argentina","Armenia","Palestina","Argelia"), codigo = c(1,2,3,4))

# norma_paises <- dbGetQuery(con, "select id_pais, nombre from paises")

norma_provincias <- dbGetQuery(con, "select p.codigo as codigo, 
                                            p.nombre as nombre 
                                            from provincias p
                                            where p.nombre <> ''
                                      union
                                      select s.codigo as codigo, 
                                              s.sinonimo as nombre 
                                              from rnpr_sinonimos s 
                                      where codigo in (select codigo from provincias p)")

provincias <- normalizacion('1',
                            FUENTE_ORIGEN_PROVINCIAS,
                            COLUMNA_ORIGEN_PROVINCIAS,
                            norma_provincias,
                            'ARGENTINA')

departamentos <- data.frame(CODIGO_PROVINCIA=c(),PROVINCIA=c(),MUNICIPIO=c(),CODIGO=c())

#LIMITAR CASOS PARA TESTEAR
# provincias <- provincias[provincias$CODIGO == "06",]

 by(provincias, 1:nrow(provincias), function(row){
   
   FUENTE_ORIGEN_DEPARTAMENTO <- paste(ruta,"/extractos/distinct_pais_provincia_municipio.csv",sep="")
   COLUMNA_ORIGEN_DEPARTAMENTO <- "MUNICIPIO"

   query <- paste("select d.codigo,
               d.nombre
               from departamentos d
               inner join provincias p
               on d.id_provincia = p.id_provincia
               where p.codigo = '",row$CODIGO,"' 
               and d.nombre <> ''
               union 
               select codigo, sinonimo as nombre from rnpr_sinonimos
               where codigo in (select d.codigo
               from departamentos d
               inner join provincias p
               on d.id_provincia = p.id_provincia
               where p.codigo = '",row$CODIGO,"')", sep = "")

   norma_departamentos <- dbGetQuery(con, query)

   departamentosN <- normalizacion(row$CODIGO,
                                   FUENTE_ORIGEN_DEPARTAMENTO,
                                   COLUMNA_ORIGEN_DEPARTAMENTO,
                                   norma_departamentos,
                                  "ARGENTINA",
                                  row$PROVINCIA)
   
   if(nrow(departamentosN)!=0){
      
      departamentosN$CODIGO_PROVINCIA <- row$CODIGO
      departamentosN$PROVINCIA <- row$PROVINCIA
   
      departamentos <<- rbind(departamentos, departamentosN)
      
   }

 })

 asentamientos <- data.frame(PROVINCIA=c(),
                             CODIGO_PROVINCIA=c(),
                             MUNICIPIO=c(),
                             CODIGO_MUNICIPIO=c(),
                             ASENTAMIENTO=c(),
                             CODIGO_ASENTAMIENTO=c()
                             )
 
 #NO ELIMINAR LIMITAR CASOS PARA TESTEAR
 # departamentos <- departamentos[departamentos$CODIGO == "06568",]
 
 total_departamentos <- nrow(departamentos)
 actual <- 0
 
 by(departamentos, 1:nrow(departamentos), function(row){
    
    actual <<- actual + 1
    print(paste("----->  PROCESADO: ",floor(actual*100/total_departamentos),"%"))

    FUENTE_ORIGEN_ASENTAMIENTO <- paste(ruta,"/extractos/distinct_pais_provincia_municipio_ciudad.csv",sep="")
    COLUMNA_ORIGEN_ASENTAMIENTO <- "CIUDAD"
    
    #OJO CON TIPO DE ENTIDAD!!!!!!
    #SE REPITEN PORQUE SIGNIFICAN COSAS DISTINTAS
    #VER MORON
    #A VECES EL CODIGO ASENTAMIENTO ESTA VACIO
    query <- paste("select codigo_asentamiento as codigo,
                nombre_geografico as nombre
                from bahra b
                where codigo_indec_provincia = '",row$CODIGO_PROVINCIA,
                   "' and codigo_indec_departamento = '",row$CODIGO,
                   "' and codigo_asentamiento <> '' 
                   union 
                   select codigo, sinonimo as nombre 
                   from rnpr_sinonimos rs
                   where codigo in (select codigo_asentamiento 
                from bahra b
                where codigo_indec_provincia = '",row$CODIGO_PROVINCIA,
                   "' and codigo_indec_departamento = '",row$CODIGO,
                   "' and codigo_asentamiento <> '')", sep = "")

    norma_asentamientos <- dbGetQuery(con, query)

    asentamientosN <- normalizacion(row$CODIGO,
                                    FUENTE_ORIGEN_ASENTAMIENTO,
                                    COLUMNA_ORIGEN_ASENTAMIENTO,
                                    norma_asentamientos,
                                    "ARGENTINA",
                                    row$PROVINCIA,
                                    row$MUNICIPIO)

    if(nrow(asentamientosN)!=0){

       asentamientosN$CODIGO_PROVINCIA <- row$CODIGO_PROVINCIA
       asentamientosN$PROVINCIA <- row$PROVINCIA
       asentamientosN$MUNICIPIO <- row$MUNICIPIO
       asentamientosN$CODIGO_MUNICIPIO <- row$CODIGO

       asentamientos <<- rbind(asentamientos, asentamientosN)

    }

 })
 
 asentamientos <- asentamientos[,c(4,3,5,6,1,2)]
 colnames(asentamientos)[6] <- "CODIGO_CIUDAD"
 
 if(dbExistsTable(con, "rnpr_normalizacion")){
     dbRemoveTable(con,"rnpr_normalizacion")
 }
 
 dbWriteTable(con, "rnpr_normalizacion", asentamientos, row.names=TRUE, append=FALSE)
 
 print("----->  FIN ")
 
dbDisconnect(con)
