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
                    return '<button class="mostrar_p no" href="#"' + 'id="' + data + '"><i class="material-icons">keyboard_arrow_up</i></button>';
                }
            },
            {
                "aTargets": [3],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_hijos_p no" href="#"' + 'id="' + data + '"><i class="material-icons">keyboard_arrow_right</i></button>';
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
            { "data": "id_provincia" },
            { "data": "nombre_provincia" },
            { "data": "nombre" }
        ],
        "aoColumnDefs": [
            { "bVisible": false, "aTargets": [1] },
            {
                "aTargets": [4],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_d no" href="#"' + 'id="' + data + '"><i class="material-icons">keyboard_arrow_up</i></button>';
                }
            },
            {
                "aTargets": [5],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_hijos_d no" href="#"' + 'id="' + data + '"><i class="material-icons">keyboard_arrow_right</i></button>';
                }
            }
        ],
        "search": { regex: true }
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
            { "data": "id_departamento" },
            { "data": "nombre_departamento" },
            { "data": "nombre" }
        ]
        ,
        "aoColumnDefs": [
            { "bVisible": false, "aTargets": [2] },
            {
                "aTargets": [5],
                "mData": "id",
                "mRender": function (data, type, full) {
                    return '<button class="mostrar_a no" href="#"' + 'id="' + data + '"><i class="material-icons">keyboard_arrow_up</i></button>';
                }
            }
        ],
        "search": { regex: true }
    });
});

let provinciasLayers = [];
let departamentosLayers = [];
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
                    "opacity": 0.50
                };

                provinciasLayers.push(
                    {
                        id: p.id, layer: L.geoJson(data, {
                            style: estiloProvincias,
                            onEachFeature: function (feature, layer) {
                                layer.on('click', function (e) {
                                    layer.bindPopup(popupProvincias(p.id)).openPopup();
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
                    "opacity": 0.70
                };

                departamentosLayers.push(
                    {
                        id: p.id, layer: L.geoJson(data, {
                            style: estiloDepartamentos,
                            onEachFeature: function (feature, layer) {
                                layer.on('click', function (e) {
                                    layer.bindPopup(popupDepartamentos(p.id)).openPopup();
                                })
                            }
                        })
                    });

            });
        })

    });

$('#provincias').on('click', '.mostrar_p', function (e) {

    const id = $(this).attr("id");

    if ($(this).hasClass("no")) {

        $(this).find('i').text('keyboard_arrow_down')

        $(this).removeClass("no").addClass("si");

        provinciasLayers.forEach(p => {
            if (p.id == id) {
                p.layer.addTo(mymap);
                mymap.fitBounds(p.layer.getBounds());
            }
        });

    }
    else {

        $(this).find('i').text('keyboard_arrow_up')

        provinciasLayers.forEach(p => {
            if (p.id == id) {
                mymap.removeLayer(p.layer);                
            }
        }, []);

        $(this).removeClass("si").addClass("no");

    }

});

$('#departamentos').on('click', '.mostrar_d', function (e) {

    const id = $(this).attr("id");

    if ($(this).hasClass("no")) {

        $(this).find('i').text('keyboard_arrow_down')

        $(this).removeClass("no").addClass("si");

        departamentosLayers.forEach(p => {
            if (p.id == id) {
                p.layer.addTo(mymap); 
                mymap.fitBounds(p.layer.getBounds(), {padding: [70,70]});
            }
        });

    }
    else {

        $(this).find('i').text('keyboard_arrow_up')

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

    if ($(this).hasClass("no")) {


        $(this).find('i').text('keyboard_arrow_down')

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
                                layer.bindPopup(popupAsentamientos(id)).openPopup();
                            })
                        }
                    })
                });

            // console.log(asentamientosLayers);
            asentamientosLayers.forEach(p => {
                if (p.id == +id) {
                    p.layer.addTo(mymap);    
                }
            });

            const bounds = asentamientosLayers.map(a => a.layer.getBounds());
            mymap.fitBounds(bounds, {padding: [50,50]});
            // mymap.setZoom(mymap.getZoom() - 2);

        });

    }
    else {

        $(this).find('i').text('keyboard_arrow_up')

        asentamientosLayers.forEach(p => {
            if (p.id == id) {
                mymap.removeLayer(p.layer);
            }
        });

        asentamientosLayers = asentamientosLayers.reduce((p, c) => {
            if (c.id !== id) {
                p.push(c);
            }
            return p;
        }, [])

        $(this).removeClass("si").addClass("no");

        const bounds = asentamientosLayers.map(a => a.layer.getBounds());
        mymap.fitBounds(bounds, {padding: [70,70]});
        // mymap.setZoom(mymap.getZoom() - 2);

    }

    

});


filtroDepartamento = [];
filtroAsentamiento = [];


$('#provincias').on('click', '.mostrar_hijos_p', function (e) {

    const table = $('#departamentos').DataTable();
    const id = $(this).attr("id");

    if ($(this).hasClass("no")) {

        $(this).find('i').text('keyboard_arrow_left');
        $(this).removeClass("no").addClass("si");

        filtroDepartamento.push(id);

        const filtro = (filtroDepartamento.length) ? "^" + filtroDepartamento.join("|") + "$" : "";

        table.column(1).search(filtro, true, false).draw();

    }
    else {

        $(this).find('i').text('keyboard_arrow_right');
        $(this).removeClass("si").addClass("no");

        filtroDepartamento = filtroDepartamento.reduce((p, c) => {
            if (c !== id) {
                p.push(c);
            }
            return p;
        }, []);

        const filtro = (filtroDepartamento.length) ? "^" + filtroDepartamento.join("|") + "$" : "";

        table.column(1).search(filtro, true, false).draw();

    }

});


$('#departamentos').on('click', '.mostrar_hijos_d', function (e) {

    const table = $('#asentamientos').DataTable();
    const id = $(this).attr("id");

    if ($(this).hasClass("no")) {

        $(this).find('i').text('keyboard_arrow_left');
        $(this).removeClass("no").addClass("si");

        filtroAsentamiento.push(id);

        const filtro = (filtroAsentamiento.length) ? "^" + filtroAsentamiento.join("|") + "$" : "";

        table.column(2).search(filtro, true, false).draw();

    }
    else {

        $(this).find('i').text('keyboard_arrow_right');
        $(this).removeClass("si").addClass("no");

        filtroAsentamiento = filtroAsentamiento.reduce((p, c) => {
            if (c !== id) {
                p.push(c);
            }
            return p;
        }, []);

        const filtro = (filtroAsentamiento.length) ? "^" + filtroAsentamiento.join("|") + "$" : "";

        table.column(2).search(filtro, true, false).draw();

    }

});


function popupAsentamientos(id) {
    const table = $('#asentamientos').DataTable();
    var fd = table.data().filter((value, index) => { if (value.id == id) { return true; } })[0];
    const data = `<ul style='padding-left: 27px;'>
                    <li>Asentamiento: ${fd.nombre} (${fd.id}) </li>
                    <li>Departamento: ${fd.nombre_departamento} (${fd.id_departamento}) </li>
                    <li>Provincia: ${fd.nombre_provincia}</li>
                </ul>`;
    return data;
}

function popupDepartamentos(id) {
    const table = $('#departamentos').DataTable();
    var fd = table.data().filter((value, index) => { if (value.id == id) { return true; } })[0];
    const data = `<ul style='padding-left: 27px;'>
                    <li>Departamento: ${fd.nombre} (${fd.id}) </li>
                    <li>Provincia: ${fd.nombre_provincia} (${fd.id_provincia}) </li>
                </ul>`;
    return data;
}

function popupProvincias(id) {
    const table = $('#provincias').DataTable();
    var fd = table.data().filter((value, index) => { if (value.id == id) { return true; } })[0];
    const data = `<ul style='padding-left: 27px;'>                    
                    <li>Provincia: ${fd.nombre} (${fd.id})</li>
                </ul>`;
    return data;
}