estandarizacion <- function (o){
  
  o$norm <- tolower(o$nombre)
  
  # o$norm <- tolower(o$norm)
  o$norm <- gsub("_", " ", o$norm, perl=TRUE)
  o$norm <- gsub("á", "a", o$norm, perl=TRUE)
  o$norm <- gsub("é", "e", o$norm, perl=TRUE)
  o$norm <- gsub("í", "i", o$norm, perl=TRUE)
  o$norm <- gsub("ó", "o", o$norm, perl=TRUE)
  o$norm <- gsub("ú", "u", o$norm, perl=TRUE)
  
  # GENERAMOS DOS VALORES A UN LADO DE O, tambien denominado y ()
  

  library(tidyr)
  
  o <- o %>% separate_rows(norm, sep="\\so\\s")
  o <- o %>% separate_rows(norm, sep="\\stambien denominado\\s")
  o <- o %>% separate_rows(norm, sep="\\stambien denominada\\s")
  o <- o %>% separate_rows(norm, sep="\\(")
  
  #DEJAR VERSION SIN LOS PARENTESIS
 
  # EXCLUSIONES DE PALABRAS COMUNES
  o$norm <- gsub("villa ", "", o$norm, perl=TRUE)
  o$norm <- gsub("y aledañas", "", o$norm, perl=TRUE)
  o$norm <- gsub("bo\\.", "", o$norm, perl=TRUE)
  o$norm <- gsub("barrio", "", o$norm, perl=TRUE)
  o$norm <- gsub("pje", "", o$norm, perl=TRUE)
  o$norm <- gsub("est ", "", o$norm, perl=TRUE)
  o$norm <- gsub("est\\.", "", o$norm, perl=TRUE)
  o$norm <- gsub("estacion", "", o$norm, perl=TRUE)
  o$norm <- gsub("parada", "", o$norm, perl=TRUE)
  o$norm <- gsub("colonia", "", o$norm, perl=TRUE)
  o$norm <- gsub("Isla", "", o$norm, perl=TRUE)
  # o$norm <- gsub("kilómetro", "", o$norm, perl=TRUE)
  # o$norm <- gsub("km", "", o$norm, perl=TRUE)
  # o$norm <- gsub("km.", "", o$norm, perl=TRUE)
  o$norm <- gsub("paraje", "", o$norm, perl=TRUE)
  o$norm <- gsub("ingeniero", "", o$norm, perl=TRUE)
  o$norm <- gsub("paraje", "", o$norm, perl=TRUE)
  o$norm <- gsub("distrito de", "", o$norm, perl=TRUE)
  o$norm <- gsub("distrito", "", o$norm, perl=TRUE)
  o$norm <- gsub("establecimiento", "", o$norm, perl=TRUE)
  o$norm <- gsub("paraje", "", o$norm, perl=TRUE)
  o$norm <- gsub("general", "", o$norm, perl=TRUE)
  o$norm <- gsub("gral ", "", o$norm, perl=TRUE)
  o$norm <- gsub("gral\\.", "", o$norm, perl=TRUE)
  o$norm <- gsub("paraje", "", o$norm, perl=TRUE)
  o$norm <- gsub("libertador", "", o$norm, perl=TRUE)
  o$norm <- gsub("ldor ", "", o$norm, perl=TRUE)
  o$norm <- gsub("ldor\\.", "", o$norm, perl=TRUE)
  o$norm <- gsub("balneario", "", o$norm, perl=TRUE)
  o$norm <- gsub("ciudad de", "", o$norm, perl=TRUE)
  o$norm <- gsub("gobernador", "", o$norm, perl=TRUE)
  o$norm <- gsub("puerto", "", o$norm, perl=TRUE)
  o$norm <- gsub("igr ", "", o$norm, perl=TRUE)
  o$norm <- gsub("igr\\.", "", o$norm, perl=TRUE)
  o$norm <- gsub("profesor", "", o$norm, perl=TRUE)
  o$norm <- gsub("cabecera", "", o$norm, perl=TRUE)
  o$norm <- gsub("cuartel ?[0-9ivx]+", "", o$norm, perl=TRUE)
  
  
  # REEMPLAZOS COMUNES
  ve <- o[grepl(" j ", o$norm),]
  ve$norm <- gsub(" j ", "jose", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("jose", o$norm),]
  ve2$norm <- gsub("jose", "j", ve2$norm, perl=TRUE)
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl(" j ", o$norm),]
  ve$norm <- gsub(" j ", "juan", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("juan", o$norm),]
  ve2$norm <- gsub("juan", "j", ve2$norm, perl=TRUE)
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl(" j ", o$norm),]
  ve$norm <- gsub(" j ", "julia", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("julia", o$norm),]
  ve2$norm <- gsub("julia", "j", ve2$norm, perl=TRUE)
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("1ro", o$norm),]
  ve$norm <- gsub("1ro", "primero", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("primero", o$norm),]
  ve2$norm <- gsub("primero", "1ro", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("nueve", o$norm),]
  ve$norm <- gsub("nueve", "9", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("9", o$norm),]
  ve2$norm <- gsub("9", "nueve", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("eduardo", o$norm),]
  ve$norm <- gsub("eduardo", "e", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl(" e ", o$norm),]
  ve2$norm <- gsub(" e ", "eduardo", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("eulogio", o$norm),]
  ve$norm <- gsub("eulogio", "e", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl(" e ", o$norm),]
  ve2$norm <- gsub(" e ", "eulogio", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("4", o$norm),]
  ve$norm <- gsub("4", "cuatro", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("cuatro", o$norm),]
  ve2$norm <- gsub("cuatro", "4", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("28", o$norm),]
  ve$norm <- gsub("28", "veintiocho", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("veintiocho", o$norm),]
  ve2$norm <- gsub("veintiocho", "28", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("25", o$norm),]
  ve$norm <- gsub("25", "veinticinco", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("veinticinco", o$norm),]
  ve2$norm <- gsub("veinticinco", "25", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("213", o$norm),]
  ve$norm <- gsub("213", "dostrece", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("dostrece", o$norm),]
  ve2$norm <- gsub("dostrece", "213", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl(" n ", o$norm),]
  ve$norm <- gsub(" n ", "nicolas", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("nicolas", o$norm),]
  ve2$norm <- gsub("nicolas", "n", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("12", o$norm),]
  ve$norm <- gsub("12", "doce", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("doce", o$norm),]
  ve2$norm <- gsub("doce", "12", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("1º", o$norm),]
  ve$norm <- gsub("1º", "primero", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("primero", o$norm),]
  ve2$norm <- gsub("primero", "1º", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("1º", o$norm),]
  ve$norm <- gsub("1º", "primera", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("primera", o$norm),]
  ve2$norm <- gsub("primera", "1º", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("16", o$norm),]
  ve$norm <- gsub("16", "dieciseis", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("dieciseis", o$norm),]
  ve2$norm <- gsub("dieciseis", "16", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("11", o$norm),]
  ve$norm <- gsub("11", "once", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("once", o$norm),]
  ve2$norm <- gsub("once", "11", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("^b ", o$norm),]
  ve$norm <- gsub("^b ", "", ve$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  #
  ve <- o[grepl("3", o$norm),]
  ve$norm <- gsub("3", "tres", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("tres", o$norm),]
  ve2$norm <- gsub("tres", "3", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl(" m ", o$norm),]
  ve$norm <- gsub(" m ", "martin", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("martin", o$norm),]
  ve2$norm <- gsub("martin", " m ", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("xx", o$norm),]
  ve$norm <- gsub("xx", "veinte", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("veinte", o$norm),]
  ve2$norm <- gsub("veinte", "xx", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("20", o$norm),]
  ve$norm <- gsub("20", "veinte", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("veinte", o$norm),]
  ve2$norm <- gsub("veinte", "20", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("2do", o$norm),]
  ve$norm <- gsub("2do", "segundo", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("segundo", o$norm),]
  ve2$norm <- gsub("segundo", "2do", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("30", o$norm),]
  ve$norm <- gsub("30", "treinta", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("treinta", o$norm),]
  ve2$norm <- gsub("treinta", "30", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("7", o$norm),]
  ve$norm <- gsub("7", "siete", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("siete", o$norm),]
  ve2$norm <- gsub("siete", "7", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("1ra seccion", o$norm),]
  ve$norm <- gsub("1ra seccion", "seccion 1ª", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("seccion 1ª", o$norm),]
  ve2$norm <- gsub("seccion 1ª", "1ra seccion", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("2da seccion", o$norm),]
  ve$norm <- gsub("2da seccion", "seccion 2ª", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("seccion 2ª", o$norm),]
  ve2$norm <- gsub("seccion 2ª", "2da seccion", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  #
  ve <- o[grepl("kilometro", o$norm),]
  ve$norm <- gsub("kilometro", "km", ve$norm, perl=TRUE)
  
  ve2 <- o[grepl("km", o$norm),]
  ve2$norm <- gsub("km", "kilometro", ve2$norm, perl=TRUE)
  
  o <- rbind(o,ve)
  o <- rbind(o,ve2)
  
  o$norm <- gsub("[^a-zñ0-9]+", "", o$norm, perl=TRUE)
  
  # Chequear string dentro de string
  
  #Split en Km (numero) y hacer un registro de cada lado
  #Split en Kilometro (numero) y hacer un registro de cada lado
  
  #De reemplazar en origen
  
  
  return(o)
  
} 