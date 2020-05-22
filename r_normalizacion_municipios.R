require("stringdist")

#string as factor no esta bien agregarlo
barha <- read.csv("/home/andres/Documents/barha.csv",stringsAsFactors = FALSE)

#seleccionamos los valores unicos de provincias  y municipios de barha
provincia_municipio <- unique(barha[,2:5] )
#rm(barha)

rpm <- read.csv("/home/andres/Documents/renaper_provincia_municipio.csv",stringsAsFactors = FALSE)

#provincia vacio no sirve
rpm <-rpm[!rpm$PROVINCIA %in% "", ]

#agregamos algunos ejemplos mal escritos para testear
#renaper_provincias[nrow(renaper_provincias) + 1,] = list("Sánta Fe.","ddasd")

#todo a minusculas
rpm$prov_comp <- tolower(rpm$PROVINCIA)
rpm$muni_comp <- tolower(rpm$MUNICIPIO)

excluir <- c("coronel","presidente","general")
#ver "capitan","libertador","almirante"


#todo lo que no es letra y espacio lo reemplazamos por nada
rpm$prov_comp <- gsub("[^a-záéíóúñ]+", "", rpm$prov_comp, perl=TRUE)
rpm$muni_comp <- gsub("[^a-záéíóúñ]+", "", rpm$muni_comp, perl=TRUE)
rpm$muni_comp <- gsub("(coronel|presidente|general)", "", rpm$muni_comp, perl=TRUE)
provincia_municipio$nom_pcia <- tolower(provincia_municipio$nom_pcia)
provincia_municipio$nom_pcia <- gsub("[^a-záéíóúñ]+", "", provincia_municipio$nom_pcia, perl=TRUE)
provincia_municipio$nom_depto <- tolower(provincia_municipio$nom_depto)
provincia_municipio$nom_depto <- gsub("[^a-záéíóúñ]+", "", provincia_municipio$nom_depto, perl=TRUE)
provincia_municipio$nom_depto <- gsub("(coronel|presidente|general)", "", provincia_municipio$nom_depto, perl=TRUE)
#algoritmo de distancia Levenshtein para provincias
rpm$barha_prov <- provincia_municipio[amatch(rpm$prov_comp,provincia_municipio$nom_pcia,maxDist=3),][,c("nom_pcia","cod_pcia")]

#Chequeamos los valores que no matchearon
#valores_no_encontrados <- rpm[is.na(rpm$barha$nom_pcia),]

#eliminamos los nulos 
rpm <-rpm[!is.na(rpm$barha_prov$nom_pcia),]
rpm$norm_muni <- NA

arr_prov <- unique(provincia_municipio[,1])

comparacion <- function (a) {

  municipios_b <- provincia_municipio[provincia_municipio$cod_pcia == a,4]
  municipios_r <- rpm[rpm$barha_prov$cod_pcia == a,4]
  indexs <-  amatch(municipios_r,municipios_b,maxDist=2)
  nrow(rpm[rpm$barha_prov$cod_pcia == a,])
  nrow(data.frame(municipios_b[indexs]))
  rpm[rpm$barha_prov$cod_pcia == a,]$norm_muni <<- municipios_b[indexs]
    
}

lapply(arr_prov,comparacion)

#View(rpm[,c(4,6)])

excluidos <- rpm[rpm$barha_prov$cod_pcia == 6,c(4,6)]
excluidos <- excluidos[is.na(excluidos$norm_muni),]

View(excluidos)




