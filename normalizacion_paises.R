require("stringdist")

paises_o <- read.csv("/home/andres/Documents/domicilios/extractos/distinct_paises.csv",stringsAsFactors = FALSE)

paises_o$pais_pre_norm <- tolower(paises_o$PAIS)

paises_o$pais_pre_norm <- gsub("[^a-záéíóúñ ]+", "", paises_o$pais_pre_norm, perl=TRUE)

#paises_n <- data.frame(descripcion = c("Argentina"), codigo_pais = c(1))
paises_n <- data.frame(descripcion = c("Argentina","Armenia","Palestina","Argelia"), codigo_pais = c(1,2,3,4))

paises_n$pais_pre_norm <- tolower(paises_n$descripcion)

paises_n$pais_pre_norm <- gsub("[^a-záéíóúñ]+", "", paises_n$pais_pre_norm, perl=TRUE)

#paises_o$pais_norm_2 <- paises_n[amatch(paises_o$pais_pre_norm,paises_n$pais_pre_norm,maxDist=2),][,c("descripcion")]
#paises_o$pais_norm_3 <- paises_n[amatch(paises_o$pais_pre_norm,paises_n$pais_pre_norm,maxDist=3),][,c("descripcion")]
#paises_o$pais_norm_4 <- paises_n[amatch(paises_o$pais_pre_norm,paises_n$pais_pre_norm,maxDist=4),][,c("descripcion")]

paises_o[,c("pais_norm_2","codigo_pais_2")] <- paises_n[amatch(paises_o$pais_pre_norm,paises_n$pais_pre_norm,maxDist=2),][,c("descripcion","codigo_pais")]
paises_o[,c("pais_norm_3","codigo_pais_3")] <- paises_n[amatch(paises_o$pais_pre_norm,paises_n$pais_pre_norm,maxDist=3),][,c("descripcion","codigo_pais")]
paises_o[,c("pais_norm_4","codigo_pais_4")] <- paises_n[amatch(paises_o$pais_pre_norm,paises_n$pais_pre_norm,maxDist=4),][,c("descripcion","codigo_pais")]


#DATOS PARA ANALIZAR SI DEJAMOS ALGO IMPORTANTE AFUERA
#A MEDIDA QUE AUMENTA EL NUMERO SE ALEJA MAS DE LA NORMA PERO INCLUYE MAS VALORES
excluidos_2 <- paises_o[is.na(paises_o$pais_norm_2),]
excluidos_3 <- paises_o[is.na(paises_o$pais_norm_3),]
excluidos_4 <- paises_o[is.na(paises_o$pais_norm_4),]

#DATOS PARA ANALIZAR CUAL ESCOJEMOS
paises_o_test <- paises_o[!is.na(paises_o$pais_norm_4),c("PAIS","pais_norm_2","pais_norm_3","pais_norm_4")]

#EN EL CASO TESTEADO DEJAMOS LOS VALORES NORM 2 NO VACIOS
paises_o <- paises_o[!is.na(paises_o$pais_norm_2),c("PAIS","codigo_pais_2")] 

colnames(paises_o) <- c("PAIS", "CODIGO")
