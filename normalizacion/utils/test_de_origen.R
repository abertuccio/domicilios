ruta <- getwd()
FUENTE_ORIGEN_PROVINCIAS <- paste(ruta,"/extractos/distinct_pais_provincia.csv",sep="")
print(FUENTE_ORIGEN_PROVINCIAS)
o <- read.csv(FUENTE_ORIGEN_PROVINCIAS,stringsAsFactors = FALSE)
columna = "PROVINCIA"
o <- o[o[[columna]] != "SIN_INFORMAR",]
