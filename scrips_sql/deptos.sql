select id_departamento, (case 
			when p.prefijo_departamento_municipio is null 
			then '' 
			else p.prefijo_departamento_municipio END)||' '||nombre as nombre  
			from prefijos p 
CROSS JOIN
(select d.id_departamento, d.nombre from departamentos d 
where d.id_provincia = 2
union 
select sd.id_departamento, sd.sinonimo as nombre 
from sinonimos_departamentos sd
where id_departamento 
in (select d.id_departamento from departamentos d 
where d.id_provincia = 2)) as nom
where p.id_provincia = 2