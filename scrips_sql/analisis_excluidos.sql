select rae.id_padre, d.nombre, count(*) as cantidad from rnpr_asentamientos_excluidos rae   
inner join departamentos d on d.id_departamento = rae.id_padre
group by rae.id_padre, d.nombre 
order by cantidad desc;

select * from rnpr_asentamientos_excluidos rae where rae.id_padre = 158

select a.id_asentamiento, a.nombre, a.poligono from asentamientos a
inner join departamentos d on a.id_departamento = d.id_departamento 
inner join provincias p on p.id_provincia = d.id_provincia
where p.id_provincia = 4 and a.poligono is not null

select * from asentamientos where id_asentamiento = 3098

select * from rnpr_asentamientos_excluidos rae
inner join departamentos d on rae.id_padre = d.id_departamento 
inner join provincias p on d.id_provincia = p.id_provincia 
and p.id_provincia = 2


select distinct rd.pais, rd.provincia, rd.municipio, rae.nombre as ciudad from rnpr_asentamientos_excluidos rae 
inner join departamentos d on d.id_departamento = rae.id_padre 
inner join rnpr_distincts rd on rd.id_departamento = d.id_departamento 

select a.id_asentamiento, a.poligono from asentamientos a 
inner join departamentos d on d.id_departamento = a.id_departamento 
where d.id_provincia = 2
and a.poligono is not null
and a.activo not in (20,22)

select * from provincias p 

select * from departamentos d where id_provincia = 17


select * from bahra b where código in ('06252010','0625201001')

select * from bahra b where código in ('06568010', '0656801004')

select tipo, count(*) from bahra b group by tipo 



select a.nombre asentamiento, a.poligono from asentamientos a 
inner join departamentos d on d.id_departamento = a.id_departamento 
inner join provincias p on d.id_provincia = p.id_provincia 
where p.id_provincia = 2
and a.poligono is not null

select distinct a.activo from asentamientos a 

select * from asentamientos_sin_identificar asi order by cast(cant_ciudad as int) desc 

insert into barrios (codigo,nombre,latitud,longitud,relation,fuente_ubicacion,point,nombre_nominatim,nombre_nominatim_long,poligono,estado,estado_descripcion,f_actualizacion,id_asentamiento)
select codigo, nombre, latitud, longitud, relation, 'SINTYS', point, nombre_nominatim, nombre_nominatim_long, poligono,1,'Se movió de Barha a Barrios',now(),1114 from asentamientos a where id_departamento = 84 and id_asentamiento = 1117;


select * from asentamientos a where id_departamento = 123

select codigo, nombre, latitud, longitud, relation, 'SINTYS', now(), id_departamento, point, nombre_nominatim, nombre_nominatim_long, poligono from asentamientos a where id_departamento = 123 and id_asentamiento = 1820

select * from provincias p 
            
