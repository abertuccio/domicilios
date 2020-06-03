require("stringdist")

normalizacion <- function(o,n,nivel,id_padre){

  ORIGENES_DISTINTOS = nrow(o)
  
  o$p_norm <- tolower(o$nombre)
  o$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("á", "a", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("é", "e", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("í", "i", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("ó", "o", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("ú", "u", o$p_norm, perl=TRUE)
  o <- o[o$p_norm != "sininformar",]
  
  NORMA_DISTINTOS = nrow(n)
  
  n$p_norm <- tolower(n$nombre)
  n$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("á", "a", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("é", "e", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("í", "i", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("ó", "o", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("ú", "u", n$p_norm, perl=TRUE)
  
  o[,c("norm_2","codigo_2")] <- n[amatch(o$p_norm, n$p_norm, maxDist=2),][,c("nombre","id")]
  o[,c("norm_max","codigo_max")] <- n[amatch(o$p_norm, n$p_norm, maxDist=7),][,c("nombre","id")]
  
  excluidos <- data.frame(o[is.na(o$norm_2),c("nombre","norm_max")])
  
  if(nrow(excluidos)>0){#ver si esto va
   excluidos$id_padre <- id_padre
   dbWriteTable(con, paste("rnpr_",nivel,"_excluidos",sep = ""), excluidos, row.names=TRUE, append=TRUE)
  }
  
  
  
  #EN EL CASO TESTEADO DEJAMOS LOS VALORES NORM 2 NO VACIOS
  o <- o[!is.na(o$norm_2),c("nombre","codigo_2")] 
  o$id <- o[,"codigo_2"]
  o <- o[,c("nombre","id")]
  
  NORMALIZADOS <- nrow(o)
  
  NO_NORMALIZADOS <- ORIGENES_DISTINTOS - NORMALIZADOS
  
  PORCENTAJE_NO_NORMALIZADO <- floor(NO_NORMALIZADOS*100/ORIGENES_DISTINTOS)
  
  reporte <- data.frame(nivel = c(nivel),
                        id_padre=c(id_padre),
                        total_origenes_distintos=c(ORIGENES_DISTINTOS),
                        total_norma_distintos=c(NORMA_DISTINTOS),
                        total_normalizados=c(NORMALIZADOS),
                        porcentaje_no_normalizado=c(PORCENTAJE_NO_NORMALIZADO)) 
  
  dbWriteTable(con, "rnpr_reporte_normalizacion", reporte, row.names=TRUE, append=TRUE)

return(o)

}
