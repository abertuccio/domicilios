DOCUMENTACIÓN DE NORMALIZACIÓN

Definir prefijo de base origen, este se va a utilizar en todas las tablas de normalización
Definir campos equivalentes a pais, provincia, departamento y asentamiento
Distinct de los campos anteriores
Se lanza script normalización.R

    normalizacion_paises.R
        Elimina tablas de excluídos y normalización previa de normalizacion de paises
        Se excluyen valores inidentificables (sin_informar, NULL, '' o '  ')
        Se evalua la distancia de Levenshtein de hasta 2 y hasta 7
        Se insertan automáticamente las distancias de hasta 2
        Se insertan todos los paises con distancia mayor a 2 en una tabla de excluídos
        Se evalúa la tabla de excluídos
        Se hacen sinónimos si fuera necesario
        Se corre nuevamente el script si fuera necesario
    normalizacion_provincia_sin_pais.R
        Se seleccionan las provincias en las que el pais sea inidentificable (NULL,'',' ')
        Se asume que los paises inidentificables corresponden a Argentina
        Se comparan las provincias del origen con la norma 
        Se evalua la distancia de Levenshtein de hasta 2 y hasta 7 de provincias
        En el caso de hasta 2 de diferencia se actualiza pais (no provincia)
        No se generan tablas de excluídos
    normalizacion_provincias.R
        Mismo procedimiento que normalizacion_paises.R pero solo de id_pais = 12 (Argentina)
    normalizacion_departamento_asentamiento.R
        Se elimina reporte de normalización previo
        Se elimina departamentos_inexistentes_en_origen
        Se eliminan tablas temporales de normalización
        Se eliminan tablas de departamentos y asentamientos excluídos
        Se seleccionan todas las provincias del id_pais = 12 (Argentina)
        Se ponen todos los id_departamentos en NULL
        Iteración de provincias (lo siguiente es por cada iteración y restringido a cada provincia)
            Se seleccionan todos los departamentos (o equivalente) de origen
            Se seleccionan todos departamentos con los sinónimos
            Se ejecuta normalizacion_general_function.R de cada grupo
                Se ejecuta estandarizacion_vectores.R de cada grupo
                    Se aplican sustituciones y divisiones de los strings y normalizaciones varias
                Se evalúa la distancia de Levenshtein en 2 y en 15
            Los de distancia de hasta 2 se insertan automáticamente
            Los de distancia de hasta 15 hay que revisarlos manualmente
            Si fuera necesario hay que agregar o bien una regla en estandarizacion_vectores.R o bien sinónimos
            Si hay algún cambio hay que tirar este script nuevamente
        Iteración de departamentos
            Se ejecuta el mismo proceso anterior pero con asentamientos
    normalizacion_asentamientos_sin_departamento.R
        Solo de id_provincia = 1 (CABA)
        Se seleccionan los asentamientos cuando departamento es NULL
        Si coinciden con asentamientos de la provincia se actualiza departamento y asentamiento
    normalizacion_barrio_sin_asentamiento(actualiza_asentamiento).R




