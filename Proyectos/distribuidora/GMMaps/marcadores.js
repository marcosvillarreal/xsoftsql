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
		lat: -38.692389,
		lng: -62.219799,
		icon: 'green',
		popup: 'TRES SARGENTOS 3008',
		alt: '1701',
		nombre: 'LA SALMUERIA S CAP I SECC IV'
	}
	,
	{
		lat: -38.692389,
		lng: -62.219799,
		icon: 'green',
		popup: 'TRES SARGENTOS 3008',
		alt: '1701',
		nombre: 'LA SALMUERIA S CAP I SECC IV'
	}
	,
	{
		lat: -38.729681613883,
		lng: -62.2675203779102,
		icon: 'green',
		popup: 'UNDIANO 634',
		alt: '1356',
		nombre: 'SANCHEZ SEBASTIAN DANIEL'
	}
	,
	{
		lat: -38.7339997984646,
		lng: -62.2658631779102,
		icon: 'green',
		popup: 'ANGEL BRUNEL 935',
		alt: '2055',
		nombre: 'CHEN CAIYUN ( ANGEL BRUNEL )'
	}
	,
	{
		lat: -38.7425628131513,
		lng: -62.2668325490743,
		icon: 'green',
		popup: 'ALVAREZ JONTE 1360',
		alt: '808',
		nombre: 'YAN YUXIN'
	}
	,
	{
		lat: -38.744191,
		lng: -62.264318,
		icon: 'green',
		popup: 'TENIENTE FARIAS 1557',
		alt: '1281',
		nombre: 'GUERRERO CLAUDIA CAROLINA'
	}
	,
	{
		lat: -38.7436924126308,
		lng: -62.2627269355821,
		icon: 'green',
		popup: 'PIEDRA BUENA 1226',
		alt: '1981',
		nombre: 'YAÑEZ EMILIANO JOSE'
	}
	,
	{
		lat: -38.737743,
		lng: -62.259936,
		icon: 'green',
		popup: 'RIO NEGRO 747',
		alt: '1676',
		nombre: 'CABION ANGELA TERESA'
	}
	,
	{
		lat: -38.7334196241747,
		lng: -62.2668631644178,
		icon: 'green',
		popup: 'ANGEL BRUNEL 849',
		alt: '1525',
		nombre: 'JODURCHA SANDRA  FABIANA'
	}
	,
	{
		lat: -38.731598,
		lng: -62.259579,
		icon: 'green',
		popup: 'DARREGUEIRA 1064',
		alt: '1679',
		nombre: 'LEGUIZAMON PUCCINELLI GONZALO EZEQU'
	}
	,
	{
		lat: -38.7349845354555,
		lng: -62.2746139932539,
		icon: 'green',
		popup: 'UNDIANO 1259',
		alt: '940',
		nombre: 'CHEN LAN SOCIEDAD ANONIMA'
	}]


const recorridos = {		
		ruta1:{
			nombre: "REPARTO_MARTIN                                    ",
			color: "#e74c3c",
			peso:4,
			puntos: [
				
[-38.692389,-62.219799],
[-38.692389,-62.219799],
[-38.729681613883,-62.2675203779102],
[-38.7339997984646,-62.2658631779102],
[-38.7425628131513,-62.2668325490743],
[-38.744191,-62.264318],
[-38.7436924126308,-62.2627269355821],
[-38.737743,-62.259936],
[-38.7334196241747,-62.2668631644178],
[-38.731598,-62.259579],
[-38.7349845354555,-62.2746139932539]
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
