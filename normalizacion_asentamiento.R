require("stringdist")
require("RPostgreSQL")

FUENTE_ORIGEN <- "/home/andres/Documents/domicilios/extractos/distinct_pais_provincia_municipio_ciudad.csv"
COLUMNA_ORIGEN <- "CIUDAD"
PROVINCIA <- "BUENOS_AIRES"
MUNICIPIO <- "MORóN"
CODIGO_PROVINCIA <- '06'
CODIGO_DEPARTAMENTO <- '06568'

o <- read.csv(FUENTE_ORIGEN,stringsAsFactors = FALSE)

o <- o[o$PAIS == "ARGENTINA",]
o <- o[o$PROVINCIA == PROVINCIA,]
o <- o[o$MUNICIPIO == MUNICIPIO,]
ORIGENES_DISTINTOS = nrow(o)

o$pre_norm <- tolower(o[[COLUMNA_ORIGEN]])

o$pre_norm <- gsub("[^a-záéíóúñ ]+", "", o$pre_norm, perl=TRUE)

con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=6432, user='postgres', password=1234)

query <- paste("select codigo_asentamiento as codigo,
                nombre_geografico as nombre
                from bahra b
                where codigo_indec_provincia = '" ,CODIGO_PROVINCIA,"'",
                "and codigo_indec_departamento = '",CODIGO_DEPARTAMENTO,"'", sep = "")

n <- dbGetQuery(con, query)
dbDisconnect(con)

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


