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

update asentamientos 
set poligono = x.geometry
from
(SELECT osm_id, geometry FROM dblink
    ('nomimap',
    'select 
		osm_type,
		osm_id, 
		geometry 
	from public.placex'
    ) 
AS DATA(
	osm_type bpchar,
	osm_id int8, 
	geometry geometry
)
where osm_type = 'R'
and osm_id in (select relation from asentamientos)) as x
where relation = x.osm_id;



SELECT * 		FROM dblink
    ('nomimap',
    'select 
		osm_type,
		osm_id, 
		geometry 
	from public.placex'
    ) 
AS DATA(
	osm_type bpchar,
	osm_id int8, 
	geometry geometry
)
where osm_type = 'R'
and osm_id = 579918400




update departamentos 
set prefijo = ''
where id_provincia = 20;


select rde.nombre, norm_max, p.nombre, p.id_provincia from rnpr_departamentos_excluidos rde 
inner join provincias p
on p.id_provincia = rde.id_padre 


select id_departamento as id, 
	nombre 
	from departamentos d 
	where id_provincia = 2
	union 
select id_departamento as id,
	sinonimo as nombre
	from sinonimos_departamentos sd 
	where id_departamento 
	in (select id_departamento
	from departamentos d 
	where id_provincia = 2);
	
	
select d.nombre, d.poligono, a.nombre, a.point from departamentos d
	inner join asentamientos a on d.id_departamento = a.id_departamento
	where id_provincia = 24; 


select d.id_departamento, d.nombre, poligono, d.relation from departamentos d where id_provincia = 24


update asentamientos 
set poligono = ST_TRANSFORM(ST_GeomFromGeoJSON('{
        "type": "Polygon",
        "coordinates": [
                [
                    [-58.777435, -34.404936],
                    [-58.777917, -34.40475],
                    [-58.777821, -34.404546],
                    [-58.779076, -34.404024],
                    [-58.780364, -34.403475],
                    [-58.781877, -34.402864],
                    [-58.785181, -34.401466],
                    [-58.788496, -34.400045],
                    [-58.788555, -34.400182],
                    [-58.788765, -34.400262],
                    [-58.788877, -34.400306],
                    [-58.788979, -34.400355],
                    [-58.789108, -34.400527],
                    [-58.789199, -34.400704],
                    [-58.789483, -34.400939],
                    [-58.789827, -34.401107],
                    [-58.789998, -34.401235],
                    [-58.790111, -34.401364],
                    [-58.790272, -34.401408],
                    [-58.790395, -34.40143],
                    [-58.79053, -34.401439],
                    [-58.790883, -34.401452],
                    [-58.791018, -34.40147],
                    [-58.791158, -34.401519],
                    [-58.791366, -34.40224],
                    [-58.791506, -34.402581],
                    [-58.791602, -34.402767],
                    [-58.79157, -34.403002],
                    [-58.791865, -34.403705],
                    [-58.791908, -34.404024],
                    [-58.792048, -34.404281],
                    [-58.792144, -34.40459],
                    [-58.792348, -34.40475],
                    [-58.792734, -34.404971],
                    [-58.792874, -34.405201],
                    [-58.792852, -34.405431],
                    [-58.792702, -34.405564],
                    [-58.792723, -34.405688],
                    [-58.792831, -34.405901],
                    [-58.793228, -34.406255],
                    [-58.794183, -34.407228],
                    [-58.794569, -34.407281],
                    [-58.794934, -34.4076],
                    [-58.795942, -34.408273],
                    [-58.796886, -34.409025],
                    [-58.797143, -34.409441],
                    [-58.797948, -34.410211],
                    [-58.798592, -34.410521],
                    [-58.799139, -34.41045],
                    [-58.799729, -34.410362],
                    [-58.799955, -34.410388],
                    [-58.800148, -34.410459],
                    [-58.800352, -34.410618],
                    [-58.800598, -34.410716],
                    [-58.801017, -34.41068],
                    [-58.801231, -34.410787],
                    [-58.801392, -34.410981],
                    [-58.801789, -34.411088],
                    [-58.802261, -34.41115],
                    [-58.802787, -34.41115],
                    [-58.80312, -34.411273],
                    [-58.803205, -34.411442],
                    [-58.803227, -34.41149],
                    [-58.803281, -34.411539],
                    [-58.80357, -34.411597],
                    [-58.80372, -34.411583],
                    [-58.804053, -34.411566],
                    [-58.804257, -34.41153],
                    [-58.804311, -34.411552],
                    [-58.804343, -34.411654],
                    [-58.804402, -34.411729],
                    [-58.804627, -34.411809],
                    [-58.804842, -34.411889],
                    [-58.805636, -34.41214],
                    [-58.806145, -34.41238],
                    [-58.806778, -34.412548],
                    [-58.806928, -34.412769],
                    [-58.807722, -34.4133],
                    [-58.808591, -34.413654],
                    [-58.809063, -34.41384],
                    [-58.809385, -34.413947],
                    [-58.809611, -34.413911],
                    [-58.80974, -34.413787],
                    [-58.810233, -34.413725],
                    [-58.811499, -34.413619],
                    [-58.81224, -34.413433],
                    [-58.812486, -34.413544],
                    [-58.812604, -34.413787],
                    [-58.812625, -34.413929],
                    [-58.813731, -34.41435],
                    [-58.814235, -34.414646],
                    [-58.814803, -34.414832],
                    [-58.815147, -34.414973],
                    [-58.816059, -34.414973],
                    [-58.816499, -34.415079],
                    [-58.816692, -34.415221],
                    [-58.816874, -34.415407],
                    [-58.81726, -34.415602],
                    [-58.81754, -34.415903],
                    [-58.817636, -34.416018],
                    [-58.817829, -34.41608],
                    [-58.817078, -34.417044],
                    [-58.816059, -34.418283],
                    [-58.814321, -34.420576],
                    [-58.810501, -34.42539],
                    [-58.80688, -34.429974],
                    [-58.803187, -34.43447],
                    [-58.79606, -34.443805],
                    [-58.790862, -34.450507],
                    [-58.785637, -34.457168],
                    [-58.775166, -34.470485],
                    [-58.771196, -34.46831],
                    [-58.770327, -34.46712],
                    [-58.76941, -34.465638],
                    [-58.764936, -34.467624],
                    [-58.764694, -34.467182],
                    [-58.76441, -34.466762],
                    [-58.762672, -34.465851],
                    [-58.761374, -34.465134],
                    [-58.760017, -34.464404],
                    [-58.75815, -34.463418],
                    [-58.756278, -34.462401],
                    [-58.754336, -34.464798],
                    [-58.753284, -34.466072],
                    [-58.75241, -34.467288],
                    [-58.752089, -34.467257],
                    [-58.751702, -34.467244],
                    [-58.751348, -34.467235],
                    [-58.751219, -34.467213],
                    [-58.751075, -34.467169],
                    [-58.749019, -34.466085],
                    [-58.747512, -34.465249],
                    [-58.745967, -34.464426],
                    [-58.744293, -34.463542],
                    [-58.74365, -34.459601],
                    [-58.740538, -34.458],
                    [-58.737384, -34.456443],
                    [-58.751446, -34.438487],
                    [-58.777435, -34.404936]
                ]
            ],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}
      }
    }'),3857)
where id_asentamiento = 15500;


update asentamientos 
set point = ST_AsText(ST_GeomFromGeoJSON('{"type":"Point","coordinates":[-56.797789178072,-37.0183781],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}'))
where id_asentamiento = 15477


select * from sinonimos_asentamientos sa 
inner join asentamientos d on sa.id_asentamiento = d.id_asentamiento 
where d.id_departamento in (500)

select * from asentamientos_sin_identificar asi order by cast(cant_ciudad as int) desc





