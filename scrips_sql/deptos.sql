select id_departamento, (case 
			when p.prefijo_departamento_municipio is null 
			then '' 
			else p.prefijo_departamento_municipio END)||' '||nombre as nombre  
			from prefijos p 
CROSS JOIN
(select d.id_departamento, d.nombre from departamentos d 
where d.id_provincia = 13
union 
select sd.id_departamento, sd.sinonimo as nombre 
from sinonimos_departamentos sd
where id_departamento 
in (select d.id_departamento from departamentos d 
where d.id_provincia = 13)) as nom
where p.id_provincia = 13

select count(*) from rnpr_distincts rd -- 11256

select * from rnpr_distincts rd where pais <> ' ' --10798

select count(*) from rnpr_distincts rd where pais = ' ' --458


select distinct(provincia) from rnpr_distincts rd
where regexp_replace(regexp_replace(rd.pais, '^\s+', ''), '\s+$', '') = ''
or pais is null

select p.id_provincia, p.nombre from provincias p 
union 
select sp.id_provincia, sp.sinonimo as nombre from sinonimos_provincias sp 
where id_provincia in (
select p.id_provincia from provincias p
)






