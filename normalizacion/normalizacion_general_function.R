require("stringdist")
require("here")
source(here("estandarizacion_vectores.R"))

normalizacion <- function(o,n,nivel,id_padre){

  ORIGENES_DISTINTOS = nrow(o)
  
  # o$norm <- tolower(o$nombre)
  # o$norm <- gsub("[^a-záéíóúñ0-9]+", "", o$norm, perl=TRUE)
  # o$norm <- gsub("á", "a", o$norm, perl=TRUE)
  # o$norm <- gsub("é", "e", o$norm, perl=TRUE)
  # o$norm <- gsub("í", "i", o$norm, perl=TRUE)
  # o$norm <- gsub("ó", "o", o$norm, perl=TRUE)
  # o$norm <- gsub("ú", "u", o$norm, perl=TRUE)
  o <- estandarizacion(o)
  o <- o[o$norm != "sininformar",]
  
  NORMA_DISTINTOS = nrow(n)
  
  # n$norm <- tolower(n$nombre)
  # n$norm <- gsub("[^a-záéíóúñ0-9]+", "", n$norm, perl=TRUE)
  # n$norm <- gsub("á", "a", n$norm, perl=TRUE)
  # n$norm <- gsub("é", "e", n$norm, perl=TRUE)
  # n$norm <- gsub("í", "i", n$norm, perl=TRUE)
  # n$norm <- gsub("ó", "o", n$norm, perl=TRUE)
  # n$norm <- gsub("ú", "u", n$norm, perl=TRUE)
  n <- estandarizacion(n)
  
  # if(nivel == "asentamientos" && id_padre == 453){
  #   print(id_padre)
  #   print(o)
  #   print(n)
  # }
  
  o[,c("norm_2","codigo_2")] <- n[amatch(o$norm, n$norm, maxDist=2),][,c("nombre","id")]
  o[,c("norm_max","codigo_max")] <- n[amatch(o$norm, n$norm, maxDist=15),][,c("nombre","id")]
  o$dist <- stringdist(o$norm,o$norm_max)
  
  nombres_matcheados <- o[!is.na(o$norm_2),"nombre"]
  excluidos <- data.frame(o[is.na(o$norm_2),c("nombre","norm_max","dist")])
  excluidos <- subset(excluidos, !(nombre %in% nombres_matcheados$nombre))

  if(nrow(excluidos)>0){#ver si esto va
   excluidos$id_padre <- id_padre
   dbWriteTable(con, paste("smap.rnpr_",nivel,"_excluidos",sep = ""), excluidos, row.names=TRUE, append=TRUE)
  }
  
  
  
  #EN EL CASO TESTEADO DEJAMOS LOS VALORES NORM 2 NO VACIOS
  o <- o[!is.na(o$norm_2),c("nombre","codigo_2")] 
  colnames(o) <- c("nombre", "id")
  
  NORMALIZADOS <- nrow(o)
  
  NO_NORMALIZADOS <- ORIGENES_DISTINTOS - NORMALIZADOS
  
  PORCENTAJE_NO_NORMALIZADO <- floor(NO_NORMALIZADOS*100/ORIGENES_DISTINTOS)
  
  reporte <- data.frame(nivel = c(nivel),
                        id_padre=c(id_padre),
                        total_origenes_distintos=c(ORIGENES_DISTINTOS),
                        total_norma_distintos=c(NORMA_DISTINTOS),
                        total_normalizados=c(NORMALIZADOS),
                        porcentaje_no_normalizado=c(PORCENTAJE_NO_NORMALIZADO)) 
  
  dbWriteTable(con, "smap.rnpr_reporte_normalizacion", reporte, row.names=TRUE, append=TRUE)

return(o)

}
