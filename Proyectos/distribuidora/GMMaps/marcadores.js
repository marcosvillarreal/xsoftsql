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
		lat: -38.7058520930991,
		lng: -62.2783245067465,
		icon: 'green',
		popup: 'ZELARRAYAN 1241',
		alt: '2761',
		nombre: 'MOYANO JUAN PABLO (SUCURSAL)'
	}
	,
	{
		lat: -38.706615,
		lng: -62.273103,
		icon: 'green',
		popup: 'ALVARADO 985',
		alt: '2210',
		nombre: 'BACCINI ALEJANDRA ANGELA'
	}
	,
	{
		lat: -38.7117987495476,
		lng: -62.2899623288352,
		icon: 'green',
		popup: 'BRASIL 595',
		alt: '1668',
		nombre: 'FERNANDEZ ZABALY LUCAS'
	}
	,
	{
		lat: -38.7031876136764,
		lng: -62.2779403576705,
		icon: 'green',
		popup: 'ALVARADO 1356',
		alt: '1156',
		nombre: 'BENEITES PATRICIA MONICA'
	}
	,
	{
		lat: -38.7115050495797,
		lng: -62.2752050991464,
		icon: 'green',
		popup: 'ESTOMBA 798',
		alt: '134',
		nombre: 'MACCARI ORLANDO'
	}
	,
	{
		lat: -38.6978200395894,
		lng: -62.2733644558236,
		icon: 'green',
		popup: 'AV ALEM 1540',
		alt: '1571',
		nombre: 'NARETTO SERGIO NICOLAS'
	}
	,
	{
		lat: -38.706758,
		lng: -62.280712,
		icon: 'green',
		popup: 'URUGUAY 15',
		alt: '1711',
		nombre: 'RUPEL ANDREA MABEL'
	}
	,
	{
		lat: -38.702580,
		lng: -62.275078,
		icon: 'green',
		popup: 'HUMBERTO PRIMO 398',
		alt: '2812',
		nombre: 'BELLONE ALBANO'
	}
	,
	{
		lat: -38.719006,
		lng: -62.285124,
		icon: 'green',
		popup: 'ALMAFUERTE 821',
		alt: '1155',
		nombre: 'ESPINAZO MIGUEL ANGEL'
	}
	,
	{
		lat: -38.7104222734131,
		lng: -62.3031717644179,
		icon: 'green',
		popup: 'ENRIQUE JULIO 1121',
		alt: '117',
		nombre: 'DIETRICH JOSE LUIS'
	}
	,
	{
		lat: -38.7211365728133,
		lng: -62.2690049153411,
		icon: 'green',
		popup: 'SAAVEDRA  41 (SE ENTREGA POR E',
		alt: '1295',
		nombre: 'DON CORNELIO SA'
	}
	,
	{
		lat: -38.7051690913797,
		lng: -62.287391,
		icon: 'green',
		popup: 'VIEYTES 1701',
		alt: '1790',
		nombre: 'PACHECO RAMOS MYRIAM'
	}
	,
	{
		lat: -38.7167229049993,
		lng: -62.2954226288353,
		icon: 'green',
		popup: 'BRASIL 1124',
		alt: '550',
		nombre: 'TRUJILLO NORMA'
	}
	,
	{
		lat: -38.7031903298223,
		lng: -62.2861413186436,
		icon: 'green',
		popup: 'ESTOMBA 1778',
		alt: '152',
		nombre: 'SABATTINI SERGIO'
	}
	,
	{
		lat: -38.7263168546087,
		lng: -62.3006909711639,
		icon: 'green',
		popup: 'MENDOZA 1980',
		alt: '1097',
		nombre: 'INALAF BERNARDO'
	}
	,
	{
		lat: -38.705053,
		lng: -62.312286,
		icon: 'green',
		popup: 'BIGGIO 1181',
		alt: '1868',
		nombre: 'MANSILLA GIULIANA ANABELLA'
	}
	,
	{
		lat: -38.7272690868215,
		lng: -62.2996100711647,
		icon: 'green',
		popup: 'CHARLONE 1980',
		alt: '1852',
		nombre: 'AIMES RUBEN ALBERTO'
	}]


const recorridos = {		
		ruta1:{
			nombre: "MARTIN                                            ",
			color: "#e74c3c",
			peso:4,
			puntos: [
				
[-38.7058520930991,-62.2783245067465],
[-38.706615,-62.273103],
[-38.7117987495476,-62.2899623288352],
[-38.7031876136764,-62.2779403576705],
[-38.7115050495797,-62.2752050991464],
[-38.6978200395894,-62.2733644558236],
[-38.706758,-62.280712],
[-38.702580,-62.275078],
[-38.719006,-62.285124],
[-38.7104222734131,-62.3031717644179],
[-38.7211365728133,-62.2690049153411],
[-38.7051690913797,-62.287391],
[-38.7167229049993,-62.2954226288353],
[-38.7031903298223,-62.2861413186436],
[-38.7263168546087,-62.3006909711639],
[-38.705053,-62.312286],
[-38.7272690868215,-62.2996100711647]
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
