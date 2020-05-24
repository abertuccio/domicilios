require("stringdist")

normalizacion <- function(FUENTE_ORIGEN,
                          COLUMNA_ORIGEN,
                          DATA_FRAME_NORMA,
                          PAIS=NA,
                          PROVINCIA=NA,
                          MUNICIPIO=NA){

  o <- read.csv(FUENTE_ORIGEN,stringsAsFactors = FALSE)
  
  
  if(!is.na(PAIS)){
  o <- o[o$PAIS == PAIS,]
  }
  if(!is.na(PROVINCIA)){
    o <- o[o$PROVINCIA == PROVINCIA,]
  }
  
  if(!is.na(MUNICIPIO)){
    o <- o[o$MUNICIPIO == MUNICIPIO,]
  }
  
  
  ORIGENES_DISTINTOS = nrow(o)
  
  o$pre_norm <- tolower(o[[COLUMNA_ORIGEN]])
  
  o$pre_norm <- gsub("[^a-záéíóúñ ]+", "", o$pre_norm, perl=TRUE)
  
  n <- DATA_FRAME_NORMA
  
  NORMA_DISTINTOS = nrow(n)
  
  n$pre_norm <- tolower(n$nombre)
  
  n$pre_norm <- gsub("[^a-záéíóúñ0-9]+", "", n$pre_norm, perl=TRUE)
  
  o[,c("norm_2","codigo_2")] <- n[amatch(o$pre_norm, n$pre_norm,maxDist=2),][,c("nombre","codigo")]
  o[,c("norm_3","codigo_3")] <- n[amatch(o$pre_norm, n$pre_norm,maxDist=3),][,c("nombre","codigo")]
  o[,c("norm_4","codigo_4")] <- n[amatch(o$pre_norm, n$pre_norm,maxDist=4),][,c("nombre","codigo")]
  
  
  #DATOS PARA ANALIZAR SI DEJAMOS ALGO IMPORTANTE AFUERA
  #A MEDIDA QUE AUMENTA EL NUMERO SE ALEJA MAS DE LA NORMA PERO INCLUYE MAS VALORES
  excluidos_2 <- o[is.na(o$norm_2),c("pre_norm","norm_2")]
  excluidos_3 <- o[is.na(o$norm_3),c("pre_norm","norm_2","norm_3")]
  excluidos_4 <- o[is.na(o$norm_4),c("pre_norm","norm_2","norm_3","norm_4")]
  
  #DATOS PARA ANALIZAR CUAL ESCOJEMOS
  o_test <- o[!is.na(o$norm_4),c(COLUMNA_ORIGEN,"norm_2","norm_3","norm_4")]
  
  #EN EL CASO TESTEADO DEJAMOS LOS VALORES NORM 2 NO VACIOS
  o <- o[!is.na(o$norm_2),c(COLUMNA_ORIGEN,"codigo_2")] 
  
  colnames(o) <- c(COLUMNA_ORIGEN, "CODIGO")
  
  NORMALIZADOS <- nrow(o)
  NO_NORMALIZADOS <- ORIGENES_DISTINTOS - NORMALIZADOS
  PORCENTAJE_NO_NORMALIZADO <- NO_NORMALIZADOS/ORIGENES_DISTINTOS*100

return(o)

}
