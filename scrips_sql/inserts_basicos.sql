/* VER QUE ID PAIS TIENE NOT NULL Y HASTA QUE NO TENGA PAISES HAY QUE SACARLO */
insert into provincias  (codigo, nombre)
select distinct codigo_indec_provincia as codigo,
nombre_provincia as nombre 
from bahra b 
order by codigo_indec_provincia asc;

/* ESTAN LOS PROBLEMAS DE LOS SALTOS DE LINEA Y LOS GID 14705,14753*/
insert into departamentos (id_provincia, codigo , nombre )
select distinct  
p.id_provincia, 
b.codigo_indec_departamento as codigo, 
b.nombre_departamento as nombre 
from bahra b
inner join provincias p 
on p.codigo = b.codigo_indec_provincia
where b.gid not in (14705,14753)
order by p.id_provincia, codigo ASC; 

