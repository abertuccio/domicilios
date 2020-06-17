$(document).ready(function() {
    $('.select-multiple').select2({ width: '100%' });

    // $('.provincias').select2({placeholder: "Buscando provincias"});

    fetch('http://127.0.0.1:3000/provincias')
    .then(function(response) {
        return response.json();
    })
    .then(function(provincias) {

        
        provincias.rows.forEach(p => {
            var newOption = new Option(p.text, p.id, false, false);
            $('.provincias').append(newOption)//.trigger('change');            
        });


        // $('.provincias').select2({
        //     placeholder: "Seleccione una provincia",
        //     data: function() { return provincias.rows; }
        // });

        $('.provincias').trigger('change');
    });

    

});


var mymap = L.map('mapid').setView([-33.09,-65.505], 3);

    L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
maxZoom: 18
}).addTo(mymap);

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