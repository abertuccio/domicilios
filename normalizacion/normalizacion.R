require("here")

#DISTINCT DE TABLA ORIGEN
#DEFINIR PREFIJO DE ORIGEN ACA
#DEFINIR LAS EQUIVALENCIAS DE LOS NOMBRES DE LOS CAMPOS ACA 

#HAY QUE PONER TODO EN NULL ANTES DE ARARNCAR??

source(here("normalizacion_paises.R"))
source(here("normalizacion_provincia_sin_pais.R"))
source(here("normalizacion_provincias.R"))
source(here("normalizacion_departamento_asentamiento.R"))
source(here("normalizacion_asentamientos_sin_departamento.R"))
source(here("normalizacion_barrio_sin_asentamiento(actualiza_asentamiento).R"))