select rae.id_padre, d.nombre, count(*) as cantidad from rnpr_asentamientos_excluidos rae   
inner join departamentos d on d.id_departamento = rae.id_padre
group by rae.id_padre, d.nombre 
order by cantidad desc;

select * from rnpr_asentamientos_excluidos rae where rae.id_padre = 158


select a.poligono from asentamientos a 
inner join departamentos d on d.id_departamento = a.id_departamento 
inner join provincias p on d.id_provincia = p.id_provincia 
where p.id_provincia = 2 and ST_GeometryType(a.poligono) <> 'ST_Point'
and a.poligono is not null
union
select d.poligono from departamentos d 
inner join asentamientos a on a.id_departamento = d.id_departamento 
where ST_GeometryType(a.poligono) = 'ST_Point' or ST_GeometryType(a.poligono) is NULL
and d.poligono is not null
and d.id_provincia = 2;



select a.id_asentamiento, a.nombre, d.nombre_nominatim as departamento, p.nombre_nominatim as provincia from asentamientos a
            inner join departamentos d on a.id_departamento = d.id_departamento 
            inner join provincias p on p.id_provincia = d.id_provincia
            where a.id_departamento = 77   
            and ST_GeometryType(a.poligono) = 'ST_Point'
            union 
            select sa.id_asentamiento, sa.sinonimo as nombre, d.nombre_nominatim as departamento, p.nombre_nominatim as provincia from sinonimos_asentamientos sa 
            inner join asentamientos a on a.id_asentamiento = sa.id_asentamiento 
            inner join departamentos d on a.id_departamento = d.id_departamento 
            inner join provincias p on p.id_provincia = d.id_provincia
            where a.id_departamento = 77
            and ST_GeometryType(a.poligono) = 'ST_Point'
            
            
            
            
