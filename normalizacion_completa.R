require("RPostgreSQL")
source("/home/andres/Documents/domicilios/normalizacion_general_function.R")
con<-dbConnect(dbDriver("PostgreSQL"), dbname = 'domicilios', host='localhost', port=6432, user='postgres', password=1234)

FUENTE_ORIGEN_PAISES <- "/home/andres/Documents/domicilios/extractos/distinct_paises.csv"
COLUMNA_ORIGEN_PAISES <- "PAIS"

FUENTE_ORIGEN_PROVINCIAS <- "/home/andres/Documents/domicilios/extractos/distinct_pais_provincia.csv"
COLUMNA_ORIGEN_PROVINCIAS <- "PROVINCIA"

FUENTE_ORIGEN_DEPARTAMENTO <- "/home/andres/Documents/domicilios/extractos/distinct_pais_provincia_municipio.csv"
COLUMNA_ORIGEN_DEPARTAMENTO <- "MUNICIPIO"


norma_paises <- data.frame(nombre = c("Argentina","Armenia","Palestina","Argelia"), codigo = c(1,2,3,4))

norma_provincias <- dbGetQuery(con, "select codigo, nombre from provincias p")

norma_departamentos <- dbGetQuery(con, "select d.codigo, d.nombre from departamentos d
                            inner join provincias p
                            on d.id_provincia = p.id_provincia 
                            where p.codigo = '06' ")

# FUENTE_ORIGEN, COLUMNA_ORIGEN, DATA_FRAME_NORMA, PAIS, PROVINCIA, DEPARTAMENTO
paises <- normalizacion(FUENTE_ORIGEN_PAISES,
                        COLUMNA_ORIGEN_PAISES,
                        norma_paises)

provincias <- normalizacion(FUENTE_ORIGEN_PROVINCIAS,
                            COLUMNA_ORIGEN_PROVINCIAS,
                            norma_provincias,
                            "ARGENTINA")

departamentos <- normalizacion(FUENTE_ORIGEN_DEPARTAMENTO,
                               COLUMNA_ORIGEN_DEPARTAMENTO,
                               norma_departamentos,
                               "ARGENTINA",
                               "BUENOS_AIRES")

dbDisconnect(con)