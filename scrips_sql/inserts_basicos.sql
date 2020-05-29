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

select distinct 



select * from nominatim.

select * from provincias

select COUNT(*) , 'normalizados' as tipo
from rnpr_normalizacion rn
union
select COUNT(*) , 'excluidos' as tipo
from rnpr_excluidos_normalizacion ren;


select count(*) from rnpr_excluidos_normalizacion ren

select ST_SetSRID(ST_MakePoint(cast (b.longitud_grado_decimal as float),cast(b.latitud_grado_decimal as float)),4326) 
from bahra b 
where codigo_indec_provincia = '06';


select distinct b.codigo_indec_departamento, b.nombre_departamento from bahra b where b.codigo_indec_provincia = '06'



