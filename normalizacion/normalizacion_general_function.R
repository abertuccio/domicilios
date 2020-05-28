require("stringdist")

normalizacion <- function(CODIGO_NIVEL,
                          FUENTE_ORIGEN,
                          COLUMNA_ORIGEN,
                          DATA_FRAME_NORMA,
                          PAIS=NA,
                          PROVINCIA=NA,
                          MUNICIPIO=NA){

  o <- read.csv(FUENTE_ORIGEN,stringsAsFactors = FALSE)
  
  NIVEL <- "GENERAL"
    
  if(!is.na(PAIS)){
  o <- o[o$PAIS == PAIS,]
  NIVEL <- PAIS
  }
  if(!is.na(PROVINCIA)){
    o <- o[o$PROVINCIA == PROVINCIA,]
    NIVEL <- PROVINCIA
  }
  
  if(!is.na(MUNICIPIO)){
    o <- o[o$MUNICIPIO == MUNICIPIO,]
    NIVEL <- paste(PROVINCIA,MUNICIPIO)
  }
  
  
  ORIGENES_DISTINTOS = nrow(o)
  
  o$pre_norm <- tolower(o[[COLUMNA_ORIGEN]])
  
  o$pre_norm <- gsub("[^a-záéíóúñ0-9]+", "", o$pre_norm, perl=TRUE)
  o$pre_norm <- gsub("á", "a", o$pre_norm, perl=TRUE)
  o$pre_norm <- gsub("é", "e", o$pre_norm, perl=TRUE)
  o$pre_norm <- gsub("í", "i", o$pre_norm, perl=TRUE)
  o$pre_norm <- gsub("ó", "o", o$pre_norm, perl=TRUE)
  o$pre_norm <- gsub("ú", "u", o$pre_norm, perl=TRUE)
  o <- o[o$pre_norm != "sininformar",]
  
  n <- DATA_FRAME_NORMA
  
  NORMA_DISTINTOS = nrow(n)
  
  n$pre_norm <- tolower(n$nombre)
  
  n$pre_norm <- gsub("[^a-záéíóúñ0-9]+", "", n$pre_norm, perl=TRUE)
  n$pre_norm <- gsub("á", "a", n$pre_norm, perl=TRUE)
  n$pre_norm <- gsub("é", "e", n$pre_norm, perl=TRUE)
  n$pre_norm <- gsub("í", "i", n$pre_norm, perl=TRUE)
  n$pre_norm <- gsub("ó", "o", n$pre_norm, perl=TRUE)
  n$pre_norm <- gsub("ú", "u", n$pre_norm, perl=TRUE)
  # 
  o[,c("norm_2","codigo_2")] <- n[amatch(o$pre_norm, n$pre_norm,maxDist=2),][,c("nombre","codigo")]
  o[,c("norm_max","codigo_max")] <- n[amatch(o$pre_norm, n$pre_norm,maxDist=7),][,c("nombre","codigo")]
  
  
  #DATOS PARA ANALIZAR SI DEJAMOS ALGO IMPORTANTE AFUERA
  #A MEDIDA QUE AUMENTA EL NUMERO SE ALEJA MAS DE LA NORMA PERO INCLUYE MAS VALORES
  excluidos_max <- o[is.na(o$norm_2),c(COLUMNA_ORIGEN,"pre_norm","norm_2","norm_max","codigo_max")]
  colnames(excluidos_max)[1] <- "valor_original"
  # excluidos_max <- o[o$valor_original != 'SIN_INFORMAR',]
  
  # excluidos_max <- o[o$valor_original != "SIN_INFORMAR",]
  
  #DATOS PARA ANALIZAR CUAL ESCOJEMOS
  # o_test <- o[!is.na(o$norm_4),c(COLUMNA_ORIGEN,"norm_2","norm_3","norm_4")]
  
  #EN EL CASO TESTEADO DEJAMOS LOS VALORES NORM 2 NO VACIOS
  o <- o[!is.na(o$norm_2),c(COLUMNA_ORIGEN,"codigo_2")] 
  
  colnames(o) <- c(COLUMNA_ORIGEN, "CODIGO")
  
  NORMALIZADOS <- nrow(o)
  NO_NORMALIZADOS <- ORIGENES_DISTINTOS - NORMALIZADOS
  PORCENTAJE_NO_NORMALIZADO <- floor(NO_NORMALIZADOS*100/ORIGENES_DISTINTOS)
  
  reporte <- data.frame(NIVEL = c(NIVEL),
                        CODIGO=c(CODIGO_NIVEL),
                        TOTAL_ORIGENES_DISTINTOS=c(ORIGENES_DISTINTOS),
                        TOTAL_NORMA_DISTINTOS=c(NORMA_DISTINTOS),
                        TOTAL_NORMALIZADOS=c(NORMALIZADOS),
                        PORCENTAJE_NO_NORMALIZADO=c(PORCENTAJE_NO_NORMALIZADO)) 
  
  #DE CADA UNA DE LAS FILAS DE EXCLUIDOS, HAY QUE BUSCAR CUANTOS SON
  
  if(nrow(excluidos_max)>0){
    excluidos_max$campo_original <- COLUMNA_ORIGEN
    excluidos_max$cantidad <- 0
    excluidos_max$ubicacion <- c(NIVEL)
    excluidos_max$codigo <- c(CODIGO_NIVEL)
    dbWriteTable(con, "rnpr_excluidos_normalizacion", excluidos_max, row.names=TRUE, append=TRUE)
  }
  
  dbWriteTable(con, "rnpr_reporte_normalizacion", reporte, row.names=TRUE, append=TRUE)

return(o)

}
