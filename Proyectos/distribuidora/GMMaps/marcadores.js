// marcadores.js - Archivo con todos los datos de marcadores
// Configuración de iconos (podría también estar en un objeto para mejor organización)
const iconConfig = {    
	iconSize: [25, 41],    
	iconAnchor: [12, 41],    
	popupAnchor: [1, -34],    
	shadowSize: [41, 41],    
	shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png'
};
	
// Función para crear iconos de colores
function createColorIcon(color) {    
	return new L.Icon({        
		iconUrl: `https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-${color}.png`,        
		...iconConfig    
	});
}

// Definición de todos los iconosconst 
icons = {    
	green: createColorIcon('green'),    
	blue: createColorIcon('blue'),    
	gold: createColorIcon('gold'),    
	red: createColorIcon('red'),    
	orange: createColorIcon('orange'),    
	yellow: createColorIcon('yellow'),    
	violet: createColorIcon('violet'),    
	grey: createColorIcon('grey'),    
	black: createColorIcon('black')
};

const marcadores = [																
	
	{
		lat: -39.250789,
		lng: -62.611782,
		icon: 'green',
		popup: 'CALLE 6 1576',
		alt: '195',
		nombre: 'RESCHKE OSCAR DANIEL'
	}
	,
	{
		lat: -39.259055,
		lng: -62.615444,
		icon: 'green',
		popup: 'JULIO A COUSTE 745',
		alt: '227',
		nombre: 'FANG KAI'
	}
	,
	{
		lat: -39.495092,
		lng: -62.692337,
		icon: 'green',
		popup: '16   422',
		alt: '311',
		nombre: 'VERON SERGIO ALEJANDRO'
	}
	,
	{
		lat: -39.49517,
		lng: -62.68425,
		icon: 'green',
		popup: '19 Y 30 0',
		alt: '926',
		nombre: 'BAKOS MAXIMILIANO'
	}
	,
	{
		lat: -39.260379,
		lng: -62.614460,
		icon: 'green',
		popup: 'SARMIENTO 1410',
		alt: '992',
		nombre: 'RESIDENCIA EL PINAR DE BURATO SRL'
	}
	,
	{
		lat: -39.502910,
		lng: -62.683985,
		icon: 'green',
		popup: 'CALLE 26  1162',
		alt: '1019',
		nombre: 'LARZABAL DELIA HAYDEE'
	}
	,
	{
		lat: -39.499949,
		lng: -62.680723,
		icon: 'green',
		popup: 'CALLE 32  244',
		alt: '1268',
		nombre: 'TITO JESICA PAMELA'
	}
	,
	{
		lat: -39.37703,
		lng: -62.6486,
		icon: 'green',
		popup: 'AMEDIA DEHENEN Y CALLE 12',
		alt: '1280',
		nombre: 'LIN JIANHONG'
	}
	,
	{
		lat: -39.261653,
		lng: -62.619503,
		icon: 'green',
		popup: 'SANTIAGO BURATOVICH 1756',
		alt: '1321',
		nombre: 'ALZORRIZ ANDRES ANTONIO'
	}
	,
	{
		lat: -39.262633,
		lng: -62.620249,
		icon: 'green',
		popup: 'SAN MARTIN 766',
		alt: '1327',
		nombre: 'HERRADA GIL ADRIAN NICOLAS'
	}
	,
	{
		lat: -39.260803,
		lng: -62.607636,
		icon: 'green',
		popup: 'RENE FAVALORO 756',
		alt: '1329',
		nombre: 'FUNES ANA MARIA'
	}
	,
	{
		lat: -39.50464,
		lng: -62.68194,
		icon: 'green',
		popup: 'CALLE 28 N 103',
		alt: '2081',
		nombre: 'CHEN QUIN'
	}
	,
	{
		lat: -39.264692,
		lng: -62.615710,
		icon: 'green',
		popup: 'REPUBLICA ARGENTINA 562',
		alt: '2121',
		nombre: 'CONDORI ABIGAIL'
	}
	,
	{
		lat: -39.494713,
		lng: -62.690331,
		icon: 'green',
		popup: 'CALLE 22 N163',
		alt: '2161',
		nombre: 'PRODUCTOS Y SERVICIOS MISKY MAYO SRL EN'
	}
	,
	{
		lat: -39.50381,
		lng: -62.68234,
		icon: 'green',
		popup: 'CALLE 28 Y 3',
		alt: '2253',
		nombre: 'SARTISON NICOLAS MARTIN'
	}
	,
	{
		lat: -39.376025,
		lng: -62.648389,
		icon: 'green',
		popup: 'CALLE 5   399',
		alt: '1335',
		nombre: 'GARAT MATIAS URIEL'
	}]


const recorridos = {		
		ruta1:{
			nombre: "PEDRO_LURO                                        ",
			color: "#e74c3c",
			peso:4,
			puntos: [
				
[-39.250789,-62.611782],
[-39.259055,-62.615444],
[-39.495092,-62.692337],
[-39.49517,-62.68425],
[-39.260379,-62.614460],
[-39.502910,-62.683985],
[-39.499949,-62.680723],
[-39.37703,-62.6486],
[-39.261653,-62.619503],
[-39.262633,-62.620249],
[-39.260803,-62.607636],
[-39.50464,-62.68194],
[-39.264692,-62.615710],
[-39.494713,-62.690331],
[-39.50381,-62.68234],
[-39.376025,-62.648389]
			]
		}}


// Variables para el seguimiento
let recorridoActivo = null;
let puntoActual = 0;
let marcadorSeguimiento = null;
let intervalSeguimiento = null;

// Función para agregar todos los marcadores al mapa
function agregarMarcadores(map) {    
	marcadores.forEach(marcador => {
	        
		const infoAdicional = '';
		const popupContent = `
			<div class="popup-content">
				<div class="popup-title">${marcador.nombre || 'Cliente sin nombre'}</div>
				<div class="popup-info">
					${marcador.popup || 'Dirección no especificada'}<br>
					Cliente: ${marcador.alt || 'Sin ID'}<br>
					${infoAdicional}
				</div>
			</div>`
	
		L.marker([marcador.lat, marcador.lng], {            
			icon: icons[marcador.icon],            
			draggable: true,            
			alt: marcador.alt        
		}).bindPopup(popupContent).addTo(map);    
		
	});
}

// Función para dibujar un recorrido
function dibujarRecorrido(map, nombreRuta) {    
	if (!recorridos[nombreRuta]) {        
		console.error('Recorrido no encontrado:', nombreRuta);        
		return null;    
	}        
	const ruta = recorridos[nombreRuta];        
	const polyline = L.polyline(ruta.puntos, {        
		color: ruta.color,        
		weight: ruta.peso,        
		opacity: 0.8,        
		smoothFactor: 1    
	}).addTo(map);        
	// Agregar popup con el nombre de la ruta    
	polyline.bindPopup(`<b>${ruta.nombre}</b><br>Puntos: ${ruta.puntos.length}`);        
	
	// Agregar marcadores de inicio y fin    
	const iconInicio = L.divIcon({        
		html: '??',        
		iconSize: [30, 30],        
		className: 'emoji-icon'    
	});        
	const iconFin = L.divIcon({        
		html: '??',        
		iconSize: [30, 30],        
		className: 'emoji-icon'    
	});        
	L.marker(ruta.puntos[0], {icon: iconInicio})        
		.bindPopup(`<b>Inicio:</b> ${ruta.nombre}`)        
		.addTo(map);        
	
	L.marker(ruta.puntos[ruta.puntos.length - 1], {icon: iconFin})        
		.bindPopup(`<b>Fin:</b> ${ruta.nombre}`)        
		.addTo(map);        
	return polyline;
}

// Función para iniciar el seguimiento animado
function iniciarSeguimiento(map, nombreRuta, velocidad = 1000) {    
	if (!recorridos[nombreRuta]) {        
		console.error('Recorrido no encontrado:', nombreRuta);        
		return;    
	}        
	detenerSeguimiento(); 
	// Detener cualquier seguimiento previo        
	const ruta = recorridos[nombreRuta];    
	recorridoActivo = ruta;    
	puntoActual = 0;        
	
	// Crear marcador de seguimiento    
	const iconSeguimiento = L.divIcon({        
		html: '??',        
		iconSize: [30, 30],        
		className: 'emoji-icon seguimiento'    
	});        
	
	marcadorSeguimiento = L.marker(ruta.puntos[0], {icon: iconSeguimiento})        
		.bindPopup('Siguiendo ruta...')        
		.addTo(map);        
		
	// Animar el movimiento    
	intervalSeguimiento = setInterval(() => {        
		if (puntoActual < ruta.puntos.length - 1) {            
			puntoActual++;            
	
			const nuevaPosicion = ruta.puntos[puntoActual];                        
			marcadorSeguimiento.setLatLng(nuevaPosicion);            
			marcadorSeguimiento.setPopupContent(                
				`<b>${ruta.nombre}</b><br>Punto ${puntoActual + 1} de ${ruta.puntos.length}<br>                 
				Coordenadas: ${nuevaPosicion[0].toFixed(6)}, ${nuevaPosicion[1].toFixed(6)}`            
			);                        
			
			// Centrar mapa en la nueva posición            
			map.setView(nuevaPosicion, map.getZoom());                        
			
			// Actualizar display de coordenadas            
			if (typeof actualizarCoordenadas === 'function') {                
				actualizarCoordenadas(nuevaPosicion);            
			}        
		} else {            
			// Recorrido completado            
			detenerSeguimiento();            
			marcadorSeguimiento.setPopupContent(`<b>¡Recorrido completado!</b><br>${ruta.nombre}`);            
			marcadorSeguimiento.openPopup();        
		}    
	},velocidad);
}

// Función para detener el seguimiento
function detenerSeguimiento() {    
	if (intervalSeguimiento) {        
		clearInterval(intervalSeguimiento);        
		intervalSeguimiento = null;    
	}    
	if (marcadorSeguimiento) {        
		marcadorSeguimiento.remove();        
		marcadorSeguimiento = null;    
	}    
	recorridoActivo = null;    
	puntoActual = 0;
}
// Función para pausar/reanudar seguimiento
function pausarReanudarSeguimiento() {    
	if (intervalSeguimiento) {        
		detenerSeguimiento();        
		return false; // Pausado    
	} else if (recorridoActivo) {        
		// Reanudar desde el punto actual        
		iniciarSeguimiento(map, 'ruta1', 1000); // Ajustar según necesidad        
			return true; // Reanudado    
	}
}
// Función para obtener todos los recorridos disponibles
function obtenerRecorridos() {    
	return Object.keys(recorridos);
}

// Función para obtener un recorrido específico
function obtenerRecorrido(claveRecorrido) {
    return recorridos[claveRecorrido];
}

// Función para obtener todos los marcadores
function obtenerMarcadores() {
    return marcadores;
}

// Función para obtener un marcador por su alt
function obtenerMarcadorPorAlt(alt) {
    return marcadores.find(marcador => marcador.alt === alt);
}

// Función para obtener información de los puntos de un recorrido
function obtenerPuntosRecorrido(nombreRuta) {    
	if (!recorridos[nombreRuta]) return [];        
	
	const ruta = recorridos[nombreRuta];    
	return ruta.puntos.map((punto, index) => {        
		// Buscar si hay un marcador exacto en esta coordenada        
		const marcadorExacto = marcadores.find(m =>             
			Math.abs(m.lat - punto[0]) < 0.0001 &&             
			Math.abs(m.lng - punto[1]) < 0.0001        
		);
		                
		return {            
			paso: index + 1,            
			lat: punto[0],            
			lng: punto[1],            
			nombre: marcadorExacto ? marcadorExacto.nombre : `Punto ${index + 1}`,            
			direccion: marcadorExacto ? marcadorExacto.popup : `Coordenadas: ${punto[0].toFixed(6)}, ${punto[1].toFixed(6)}`,            
			alt: marcadorExacto ? marcadorExacto.alt : `paso-${index}`,            
			esInicio: index === 0,            
			esFin: index === ruta.puntos.length - 1        
		};    
	});
}
