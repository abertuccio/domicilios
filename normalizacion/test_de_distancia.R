require("stringdist")
valores1 <- c("emiratosarabesunidos")
valores2 <- c("emiratosarabesunidoslos")

valores1 <- tolower(valores1)
valores2 <- tolower(valores2)

valores1 <- gsub("[^a-záéíóúñ0-9]+", "", valores1, perl=TRUE)
valores2 <- gsub("[^a-záéíóúñ0-9]+", "", valores2, perl=TRUE)

valores1 <- gsub("á", "a", valores1, perl=TRUE)
valores1 <- gsub("é", "e", valores1, perl=TRUE)
valores1 <- gsub("í", "i", valores1, perl=TRUE)
valores1 <- gsub("ó", "o", valores1, perl=TRUE)
valores1 <- gsub("ú", "u", valores1, perl=TRUE)
 
valores2 <- gsub("á", "a", valores2, perl=TRUE)
valores2 <- gsub("é", "e", valores2, perl=TRUE)
valores2 <- gsub("í", "i", valores2, perl=TRUE)
valores2 <- gsub("ó", "o", valores2, perl=TRUE)
valores2 <- gsub("ú", "u", valores2, perl=TRUE)


amatch(valores1, valores2, maxDist=7)
