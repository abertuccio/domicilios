require("stringdist")

normalizacion <- function(o,n){
  
  
  o$p_norm <- tolower(o$nombre)
  o$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("á", "a", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("é", "e", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("í", "i", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("ó", "o", o$p_norm, perl=TRUE)
  o$p_norm <- gsub("ú", "u", o$p_norm, perl=TRUE)
  o <- o[o$p_norm != "sininformar",]
  
  n$p_norm <- tolower(n$nombre)
  n$p_norm <- gsub("[^a-záéíóúñ0-9]+", "", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("á", "a", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("é", "e", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("í", "i", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("ó", "o", n$p_norm, perl=TRUE)
  n$p_norm <- gsub("ú", "u", n$p_norm, perl=TRUE)
  
  View(n)
  
  o[,c("norm_2","codigo_2")] <- n[amatch(o$p_norm, n$p_norm, maxDist=2),][,c("nombre","id")]
  o[,c("norm_max","codigo_max")] <- n[amatch(o$p_norm, n$p_norm, maxDist=7),][,c("nombre","id")]
  
  return(o)
  
}