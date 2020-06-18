const mymap = L.map('mapid').setView([-33.09, -65.505], 3);

L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
    maxZoom: 18
}).addTo(mymap);

$(document).ready(function () {
    // $('#provincias').DataTable();
    $('#provincias').DataTable({
        ajax: {
            url: 'http://127.0.0.1:3000/provincias',
            dataSrc: "rows"
        },
        "columns": [
            { "data": "id" },
            { "data": "nombre" }
        ]
        ,
        "aoColumnDefs": [
            {
                "aTargets": [2],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_p no" href="#"' + 'id="' + data + '">M</button>';
                }
            },
            {
                "aTargets": [3],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_hijos_p no" href="#"' + 'id="' + data + '">MH</button>';
                }
            }
        ]
    });
});

$(document).ready(function () {
    // $('#provincias').DataTable();
    $('#departamentos').DataTable({
        ajax: {
            url: 'http://127.0.0.1:3000/departamentos',
            dataSrc: "rows"
        },
        "columns": [
            { "data": "id" },
            { "data": "nombre_provincia" },
            { "data": "nombre" }
        ]
        ,
        "aoColumnDefs": [
            {
                "aTargets": [3],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_d no" href="#"' + 'id="' + data + '">M</button>';
                }
            },
            {
                "aTargets": [4],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_hijos_d no" href="#"' + 'id="' + data + '">MH</button>';
                }
            }
        ]
    });
});

$(document).ready(function () {
    // $('#provincias').DataTable();
    $('#asentamientos').DataTable({
        ajax: {
            url: 'http://127.0.0.1:3000/asentamientos',
            dataSrc: "rows"
        },
        "columns": [
            { "data": "id" },
            { "data": "nombre_provincia" },
            { "data": "nombre_departamento" },
            { "data": "nombre" }
        ]
        ,
        "aoColumnDefs": [
            {
                "aTargets": [4],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_a no" href="#"' + 'id="' + data + '">M</button>';
                }
            }
        ]
    });
});

const provinciasLayers = [];
const departamentosLayers = [];
let asentamientosLayers = [];

fetch('http://127.0.0.1:3000/provincias')
    .then(function (response) {
        return response.json();
    })
    .then(function (provincias) {

        provincias.rows.forEach(p => {
            $.getJSON('./poligonos/provincias/' + p.id + '.json', function (data) {

                var estiloProvincias = {
                    "color": "#94c14d",
                    "fillColor": "",
                    "weight": 3,
                    "opacity": 0.30
                };

                provinciasLayers.push(
                    {
                        id: p.id, layer: L.geoJson(data, {
                            style: estiloProvincias,
                            onEachFeature: function (feature, layer) {
                                layer.on('click', function (e) {
                                    console.log("provincia: " + p.nombre);
                                    //    console.log(p.id);
                                    // departamentos(p.id_provincia)
                                })
                            }
                        })
                    });

            });
        })

    });


    fetch('http://127.0.0.1:3000/departamentos')
    .then(function (response) {
        return response.json();
    })
    .then(function (departamentos) {

        departamentos.rows.forEach(p => {
            $.getJSON('./poligonos/departamentos/' + p.id + '.json', function (data) {

                var estiloDepartamentos = {
                    "color": "#5b9ada",
                    "fillColor": "",
                    "weight": 2,
                    "opacity": 0.60
                };

                departamentosLayers.push(
                    {
                        id: p.id, layer: L.geoJson(data, {
                            style: estiloDepartamentos,
                            onEachFeature: function (feature, layer) {
                                layer.on('click', function (e) {
                                    console.log("departamento: " + p.nombre);
                                    //    console.log(p.id);
                                    // departamentos(p.id_provincia)
                                })
                            }
                        })
                    });

            });
        })

    });

// const departamentos = function(id_provincia){
//     fetch('http://127.0.0.1:3000/poligonos_departamentos/'+id_provincia)
//   .then(function(response) {
//     return response.json();
//   })
//   .then(function(filas) {
//     const departamentos = filas.rows;

//         var estiloDepartamentos = {
//             "color": "#cc0000",
//             "fillColor": "#cc0000",
//             "weight": 2,
//             "opacity": 0.60
//         };

//         departamentos.forEach(p => {
//             let pol = L.geoJson(JSON.parse(p.poligono),{
//                 style: estiloDepartamentos,
//                 onEachFeature: function(feature, layer) {
//                     layer.on('click', function(e) {
//                        console.log("departamento: "+p.nombre);
//                     //    console.log(p.id_provincia);
//                     })
//                     }
//             });
//             pol.addTo(mymap); 

//           });

//     });

// }



// fetch('http://127.0.0.1:3000/poligonos_provincias')
//   .then(function(response) {
//     return response.json();
//   })
//   .then(function(filas) {
//       const provincias = filas.rows;  
//     //   console.log(provincias.length)

// // console.log(JSON.parse(provincias[0].st_asgeojson));

// // L.geoJson(JSON.parse(provincias[0].v)).addTo(mymap);

//         var estiloProvincias = {
//             "color": "#7b7100",
//             "fillColor": "#fff79c",
//             "weight": 1,
//             "opacity": 0.40
//         };

//       provincias.forEach(p => {
//         let pol = L.geoJson(JSON.parse(p.poligono),{
//             style: estiloProvincias,
//             onEachFeature: function(feature, layer) {
//                 layer.on('click', function(e) {
//                    console.log("provincia: "+p.nombre);
//                 //    console.log(p.id);
//                    departamentos(p.id_provincia)
//                 })
//                 }
//         });
//         pol.addTo(mymap); 

//       });

//   });

// mymap.on('zoomend',function(e){	
// 	var currZoom = mymap.getZoom();
//     console.log(currZoom);
// });

// L.marker([51.5, -0.09]).addTo(mymap)
// 	.bindPopup("<b>Hello world!</b><br />I am a popup.").openPopup();

// L.circle([51.508, -0.11], 500, {
// 	color: 'red',
// 	fillColor: '#f03',
// 	fillOpacity: 0.5
// }).addTo(mymap).bindPopup("I am a circle.");

// L.polygon([
// 	[51.509, -0.08],
// 	[51.503, -0.06],
// 	[51.51, -0.047]
// ]).addTo(mymap).bindPopup("I am a polygon.");


// var popup = L.popup();

// function onMapClick(e) {
// 	popup
// 		.setLatLng(e.latlng)
// 		.setContent("You clicked the map at " + e.latlng.toString())
// 		.openOn(mymap);
// }

// mymap.on('click', onMapClick);



$('#provincias').on('click', '.mostrar_p', function (e) {

    const id = $(this).attr("id");

    console.log(id);

    if ($(this).hasClass("no")) {

        $(this).removeClass("no").addClass("si");

        provinciasLayers.forEach(p => {
            if (p.id == id) {
                p.layer.addTo(mymap);
            }
        });

    }
    else {

        provinciasLayers.forEach(p => {
            if (p.id == id) {
                mymap.removeLayer(p.layer);
            }
        },[]);

        $(this).removeClass("si").addClass("no");

    }



});

$('#departamentos').on('click', '.mostrar_d', function (e) {

    const id = $(this).attr("id");

    console.log(id);

    if ($(this).hasClass("no")) {

        $(this).removeClass("no").addClass("si");

        departamentosLayers.forEach(p => {
            if (p.id == id) {
                p.layer.addTo(mymap);
            }
        });

    }
    else {

        departamentosLayers.forEach(p => {
            if (p.id == id) {
                mymap.removeLayer(p.layer);
            }
        });

        $(this).removeClass("si").addClass("no");

    }



});


$('#asentamientos').on('click', '.mostrar_a', function (e) {

    const id = $(this).attr("id");

    console.log(id);

    if ($(this).hasClass("no")) {

        $(this).removeClass("no").addClass("si");

        

        $.getJSON('./poligonos/asentamientos/' + id + '.json', function (data) {

            var estiloAsentamientos = {
                "color": "#ff4444",
                "fillColor": "",
                "weight": 1,
                "opacity": 0.90,
                "fillOpacity": 0.50
            };

            // console.log(data);
            // const la = L.geoJson(data);

            // la.addTo(mymap);

            asentamientosLayers.push(
                {
                    id: id, layer: L.geoJson(data, {
                        style: estiloAsentamientos,
                        onEachFeature: function (feature, layer) {
                            layer.on('click', function (e) {
                                // console.log("asentamiento: " + p.nombre);
                                //    console.log(p.id);
                                // departamentos(p.id_provincia)
                            })
                        }
                    })
                });

                // console.log(asentamientosLayers);
            asentamientosLayers.forEach(p => {
                if (p.id == +id) {
                    console.log("obiamento no de agregamos")
                    p.layer.addTo(mymap);
                }
            });



        });




            

    }
    else {

        asentamientosLayers.forEach(p => {
            if (p.id == id) {
                mymap.removeLayer(p.layer);
            }
        });

        asentamientosLayers = asentamientosLayers.reduce((p,c)=>{
            if(c.id!==id){
                p.push(c);
            }
            return p;
        },[])

        $(this).removeClass("si").addClass("no");

    }



});




// $.getJSON('./poligonos/asentamientos/1.json', function (data) {

//     console.log(data);
    
    
// });


