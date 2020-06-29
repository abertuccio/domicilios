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

update provincias 
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
and osm_id in (select relation from provincias)) as x
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
          [
            -58.4984946,
            -34.7036438
          ],
          [
            -58.4982398,
            -34.7037422
          ],
          [
            -58.4979484,
            -34.7039239
          ],
          [
            -58.4977643,
            -34.7040136
          ],
          [
            -58.4976266,
            -34.7040565
          ],
          [
            -58.4974747,
            -34.7040869
          ],
          [
            -58.4972534,
            -34.704106
          ],
          [
            -58.4971578,
            -34.7041103
          ],
          [
            -58.4966363,
            -34.7041335
          ],
          [
            -58.4958847,
            -34.704158
          ],
          [
            -58.4957467,
            -34.7041632
          ],
          [
            -58.4951898,
            -34.7041833
          ],
          [
            -58.4946469,
            -34.7041986
          ],
          [
            -58.4945418,
            -34.7041805
          ],
          [
            -58.4944258,
            -34.7041298
          ],
          [
            -58.4943212,
            -34.7040577
          ],
          [
            -58.4942911,
            -34.7040332
          ],
          [
            -58.4941852,
            -34.7039157
          ],
          [
            -58.4938415,
            -34.7041534
          ],
          [
            -58.4937187,
            -34.7042187
          ],
          [
            -58.4936173,
            -34.7042839
          ],
          [
            -58.4935286,
            -34.7043548
          ],
          [
            -58.4934528,
            -34.7044219
          ],
          [
            -58.4930868,
            -34.7047319
          ],
          [
            -58.4920637,
            -34.7055006
          ],
          [
            -58.4910133,
            -34.7062897
          ],
          [
            -58.4899872,
            -34.7070605
          ],
          [
            -58.4891834,
            -34.7076644
          ],
          [
            -58.4889559,
            -34.70784
          ],
          [
            -58.4872711,
            -34.7091403
          ],
          [
            -58.4862531,
            -34.709926
          ],
          [
            -58.4857577,
            -34.7103083
          ],
          [
            -58.4844198,
            -34.7113408
          ],
          [
            -58.4833529,
            -34.7121611
          ],
          [
            -58.4835501,
            -34.7123384
          ],
          [
            -58.4840081,
            -34.7127439
          ],
          [
            -58.4922778,
            -34.7200688
          ],
          [
            -58.491289,
            -34.7208108
          ],
          [
            -58.4911971,
            -34.720878
          ],
          [
            -58.48696,
            -34.7240609
          ],
          [
            -58.4867902,
            -34.724189
          ],
          [
            -58.4839048,
            -34.7263655
          ],
          [
            -58.4835915,
            -34.7265781
          ],
          [
            -58.4812626,
            -34.7246323
          ],
          [
            -58.4800802,
            -34.7235772
          ],
          [
            -58.4794572,
            -34.7231709
          ],
          [
            -58.4789355,
            -34.7226857
          ],
          [
            -58.4780396,
            -34.7217559
          ],
          [
            -58.4752356,
            -34.7191331
          ],
          [
            -58.4718483,
            -34.7159994
          ],
          [
            -58.4711021,
            -34.7152908
          ],
          [
            -58.4699886,
            -34.7141697
          ],
          [
            -58.4691044,
            -34.7133206
          ],
          [
            -58.4650145,
            -34.7093078
          ],
          [
            -58.4622163,
            -34.7065047
          ],
          [
            -58.4614155,
            -34.705637
          ],
          [
            -58.4625409,
            -34.7049689
          ],
          [
            -58.4634231,
            -34.7044227
          ],
          [
            -58.4639474,
            -34.703717
          ],
          [
            -58.4640886,
            -34.7035126
          ],
          [
            -58.4642126,
            -34.7033623
          ],
          [
            -58.4643371,
            -34.7032303
          ],
          [
            -58.4644711,
            -34.703118
          ],
          [
            -58.4662176,
            -34.7018413
          ],
          [
            -58.4665062,
            -34.7016188
          ],
          [
            -58.4666027,
            -34.7015382
          ],
          [
            -58.4671166,
            -34.7011498
          ],
          [
            -58.4672323,
            -34.7010649
          ],
          [
            -58.4699944,
            -34.6989893
          ],
          [
            -58.4704978,
            -34.6985748
          ],
          [
            -58.4706555,
            -34.6984423
          ],
          [
            -58.4708536,
            -34.6982967
          ],
          [
            -58.4711188,
            -34.6981097
          ],
          [
            -58.471297,
            -34.6979741
          ],
          [
            -58.4719978,
            -34.6974462
          ],
          [
            -58.47341,
            -34.6964006
          ],
          [
            -58.4735317,
            -34.6963087
          ],
          [
            -58.4737611,
            -34.6961237
          ],
          [
            -58.4737987,
            -34.6960955
          ],
          [
            -58.4757807,
            -34.6946113
          ],
          [
            -58.4759249,
            -34.6945022
          ],
          [
            -58.475945,
            -34.6944855
          ],
          [
            -58.4769208,
            -34.6937414
          ],
          [
            -58.4771025,
            -34.6936029
          ],
          [
            -58.4778567,
            -34.6930279
          ],
          [
            -58.4781148,
            -34.692831
          ],
          [
            -58.478833,
            -34.6922834
          ],
          [
            -58.4793021,
            -34.6919257
          ],
          [
            -58.4794299,
            -34.6918147
          ],
          [
            -58.4795348,
            -34.6917222
          ],
          [
            -58.4797743,
            -34.6915411
          ],
          [
            -58.4801745,
            -34.6912442
          ],
          [
            -58.4810599,
            -34.6906107
          ],
          [
            -58.4812964,
            -34.6904288
          ],
          [
            -58.4821124,
            -34.6897858
          ],
          [
            -58.4823421,
            -34.6896358
          ],
          [
            -58.4825651,
            -34.689507
          ],
          [
            -58.4829193,
            -34.6893366
          ],
          [
            -58.4834121,
            -34.6891432
          ],
          [
            -58.483613,
            -34.6890797
          ],
          [
            -58.4838804,
            -34.6890027
          ],
          [
            -58.484015,
            -34.6889668
          ],
          [
            -58.4848984,
            -34.6887853
          ],
          [
            -58.4851058,
            -34.6888657
          ],
          [
            -58.4857954,
            -34.689481
          ],
          [
            -58.4863352,
            -34.6899783
          ],
          [
            -58.4865354,
            -34.6901596
          ],
          [
            -58.4870937,
            -34.6906536
          ],
          [
            -58.4872782,
            -34.6908303
          ],
          [
            -58.487788,
            -34.6912935
          ],
          [
            -58.4880031,
            -34.69148
          ],
          [
            -58.4887452,
            -34.6921615
          ],
          [
            -58.4894989,
            -34.6928278
          ],
          [
            -58.4896049,
            -34.6929226
          ],
          [
            -58.4898416,
            -34.6931592
          ],
          [
            -58.4901678,
            -34.6935441
          ],
          [
            -58.4904703,
            -34.6939044
          ],
          [
            -58.4907822,
            -34.694295
          ],
          [
            -58.4913891,
            -34.6950661
          ],
          [
            -58.4916727,
            -34.69545
          ],
          [
            -58.4924726,
            -34.6964559
          ],
          [
            -58.492926,
            -34.6969979
          ],
          [
            -58.4930341,
            -34.6971271
          ],
          [
            -58.4932448,
            -34.6973725
          ],
          [
            -58.4934865,
            -34.6976668
          ],
          [
            -58.4938891,
            -34.6981623
          ],
          [
            -58.4945827,
            -34.6989791
          ],
          [
            -58.4946287,
            -34.6990633
          ],
          [
            -58.4946583,
            -34.699133
          ],
          [
            -58.4947468,
            -34.699443
          ],
          [
            -58.4948145,
            -34.6996021
          ],
          [
            -58.4949109,
            -34.6997315
          ],
          [
            -58.4950076,
            -34.6998307
          ],
          [
            -58.4950968,
            -34.6999012
          ],
          [
            -58.4952493,
            -34.6999894
          ],
          [
            -58.4953203,
            -34.7000241
          ],
          [
            -58.4954182,
            -34.7000765
          ],
          [
            -58.4955197,
            -34.7001494
          ],
          [
            -58.4956423,
            -34.7002701
          ],
          [
            -58.4970105,
            -34.7018932
          ],
          [
            -58.497356,
            -34.7023085
          ],
          [
            -58.4976619,
            -34.7026772
          ],
          [
            -58.4980207,
            -34.703071
          ],
          [
            -58.4982463,
            -34.7033139
          ],
          [
            -58.4984946,
            -34.7036438
          ]
        ]
      ],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}
      }
    }'),3857)
where id_asentamiento = 15480;


update asentamientos 
set point = ST_AsText(ST_GeomFromGeoJSON('{"type":"Point","coordinates":[-56.797789178072,-37.0183781],"crs":{"type":"name","properties":{"name":"EPSG:4326"}}}'))
where id_asentamiento = 15477


select * from sinonimos_asentamientos sa 
inner join asentamientos d on sa.id_asentamiento = d.id_asentamiento 
where d.id_departamento in (500)

select * from asentamientos_sin_identificar asi order by cast(cant_ciudad as int) desc

insert into barrios (codigo,nombre,latitud,longitud,relation,fuente_ubicacion,point,nombre_nominatim,nombre_nominatim_long,poligono,estado,estado_descripcion,f_actualizacion,id_asentamiento)
select codigo, nombre, latitud, longitud, relation, 'SINTYS', point, nombre_nominatim, nombre_nominatim_long, poligono,1,'Se movió de Barha a Barrios',now(),15522 from asentamientos a where id_departamento = 420 and id_asentamiento = 10424;


select a.id_asentamiento, a.nombre, d.nombre_nominatim as departamento, p.nombre_nominatim as provincia from asentamientos a
            inner join departamentos d on a.id_departamento = d.id_departamento 
            inner join provincias p on p.id_provincia = d.id_provincia
            where a.relation is null
            and a.id_departamento = 89
            union 
            select sa.id_asentamiento, sa.sinonimo as nombre, d.nombre_nominatim as departamento, p.nombre_nominatim as provincia from sinonimos_asentamientos sa 
            inner join asentamientos a on a.id_asentamiento = sa.id_asentamiento 
            inner join departamentos d on a.id_departamento = d.id_departamento 
            inner join provincias p on p.id_provincia = d.id_provincia
            where a.relation is null
            and a.id_departamento = 89
            
            update asentamientos ast set 
            poligono = (SELECT ST_Transform(ST_SetSRID(a.poligono, 3857),4326) as pol from asentamientos a where a.id_asentamiento = ast.id_asentamiento)
            where ST_SRID(ast.poligono) = 0;
            
            select id_asentamiento, ST_SRID(poligono) from asentamientos a where ST_SRID(poligono) <> 4326
            
           select * from ciudadanos_sintys cs; 
           
          select NEXTVAL('mysequence'), cs.id_ciudadano_sintys, 
          rd1.id_pais, rd2.id_provincia, 
          rd3.id_departamento, 
          rd4.id_asentamiento,
          'SINTYS',
          1,
          '',
          NOW()
          from ciudadanos_sintys cs
          inner join rnpr_distincts rd1 on cs.pais = rd1.pais
          inner join rnpr_distincts rd2 on cs.provincia = rd2.provincia
          inner join rnpr_distincts rd3 on cs.municipio = rd3.municipio
          inner join rnpr_distincts rd4 on cs.ciudad = rd4.ciudad; 
        
          
          select * from ciudadanos_domicilios cd 
          
          ALTER SEQUENCE id_ciudadano_domicilio RESTART WITH 1;
          
          insert into ciudadanos_domicilios (id_ciudadano_sintys,estado,estado_descripcion,f_actualizacion)
          select cs.id_ciudadano_sintys,
          1,          
          'insert id ciudadano',
          NOW()
          from ciudadanos_sintys cs;
         
         
         
   select distinct cs.id_ciudadano_sintys, 
          rd1.id_pais, 
          rd1.id_provincia, 
          rd1.id_departamento, 
          rd1.id_asentamiento
          from ciudadanos_sintys cs
          inner join rnpr_distincts rd1 on cs.pais = rd1.pais
          inner join rnpr_distincts rd2 on cs.provincia = rd2.provincia
          inner join rnpr_distincts rd3 on cs.municipio = rd3.municipio
          inner join rnpr_distincts rd4 on cs.ciudad = rd4.ciudad
          where rd1.id_asentamiento = 31
          limit 100;      
         
         
         
         
         
         select count(id_ciudadano_sintys) from ciudadanos_sintys;
         select count(*) from ciudadanos_sintys cs 
         
         select distinct pais, id_pais from rnpr_distincts rd 
         
         
            
            
            


