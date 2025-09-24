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
		lat: -40.8158675,
		lng: -63.0033763,
		icon: 'green',
		popup: 'WIMTER 418',
		alt: '3135',
		nombre: 'MORALESFREDY ORLANDO'
	}
	,
	{
		lat: -40.8222724,
		lng: -62.9966591,
		icon: 'red',
		popup: 'WINTER 703',
		alt: '1138',
		nombre: 'LINARES GABRIEL ADRIAN'
	}
	,
	{
		lat: -40.8244054,
		lng: -63.0000572,
		icon: 'red',
		popup: 'BERUTTI  389',
		alt: '2190',
		nombre: 'ROMERO MARIO'
	}
	,
	{
		lat: -40.8213590,
		lng: -63.0002412,
		icon: 'red',
		popup: 'MIRANDA 266',
		alt: '2561',
		nombre: 'GUAQUIAN DONATO ELVIO'
	}
	,
	{
		lat: -40.8205014,
		lng: -62.9983147,
		icon: 'red',
		popup: 'MIRANDA  114',
		alt: '1250',
		nombre: 'CARRIQUEO MARTA'
	}
	,
	{
		lat: -40.8268960,
		lng: -62.9890289,
		icon: 'red',
		popup: 'CHACO Y SAN JUAN',
		alt: '2999',
		nombre: 'REYES RAUL MOISES'
	}
	,
	{
		lat: -40.8187358,
		lng: -63.0011611,
		icon: 'red',
		popup: 'GUIDO Y O`HIGGINS',
		alt: '2460',
		nombre: 'CARDOZO FRANCO ARNALDO'
	}
	,
	{
		lat: -40.819661,
		lng: -63.003720,
		icon: 'red',
		popup: 'GUIDO 1635',
		alt: '3340',
		nombre: 'FLORES ABRAHAM'
	}
	,
	{
		lat: -40.819708,
		lng: -63.003831,
		icon: 'red',
		popup: 'JOSE MARIA GUIDO 1645',
		alt: '2815',
		nombre: 'VILCA MIRIAM LILANA (1)'
	}
	,
	{
		lat: -40.8199901,
		lng: -63.0039250,
		icon: 'green',
		popup: 'GUIDO 1650',
		alt: '2070',
		nombre: 'KCO LA TERMINAL'
	}
	,
	{
		lat: -40.8268348,
		lng: -62.9975319,
		icon: 'red',
		popup: 'AVPERON (PARISI) 228',
		alt: '1645',
		nombre: 'IBAÑEZ KARINA FABIANA'
	}
	,
	{
		lat: -40.8161928,
		lng: -63.0026233,
		icon: 'red',
		popup: 'ALVARO BARROS 1374',
		alt: '3047',
		nombre: 'RIOS FRANCO DAYSI'
	}
	,
	{
		lat: -40.8204715,
		lng: -63.0066373,
		icon: 'red',
		popup: 'AGUADA CECILIO 21',
		alt: '3065',
		nombre: 'ANDRADE CAILLAHUA IRIS JHOANA'
	}
	,
	{
		lat: -40.8058418,
		lng: -63.0133976,
		icon: 'red',
		popup: 'CASTELLI 180',
		alt: '3171',
		nombre: 'RETAMAL MARCELA BEATRIZ'
	}
	,
	{
		lat: -40.8205498,
		lng: -63.0079883,
		icon: 'red',
		popup: 'LOS MENUCOS 114',
		alt: '2180',
		nombre: 'RODRIGUEZ JUAN BAUTISTA'
	}
	,
	{
		lat: -40.8118883,
		lng: -62.9961589,
		icon: 'red',
		popup: 'RAMOS MEXIAS 159',
		alt: '1320',
		nombre: 'CONDORI MARTIN'
	}
	,
	{
		lat: -40.8118883,
		lng: -62.9961589,
		icon: 'red',
		popup: 'RAMOS MEXIA Y CASTELLI',
		alt: '2787',
		nombre: 'ABAN CASTRO CARLOS'
	}
	,
	{
		lat: -40.8231325,
		lng: -63.0129092,
		icon: 'red',
		popup: 'CASTELLI 670',
		alt: '2677',
		nombre: 'RAMOS RUEDA LUIS MIGUEL'
	}
	,
	{
		lat: -40.8118883,
		lng: -62.9961589,
		icon: 'green',
		popup: 'CASTELLI 732',
		alt: '2982',
		nombre: 'ABAN NOEL EVARISTO'
	}
	,
	{
		lat: -40.8241372,
		lng: -63.0066876,
		icon: 'red',
		popup: 'RAMOS MEXIA 492',
		alt: '3003',
		nombre: 'AILLAPI LEANDRO RAMIRO'
	}
	,
	{
		lat: -40.8105041,
		lng: -63.0123305,
		icon: 'red',
		popup: 'CASTELLI 648',
		alt: '1374',
		nombre: 'JULIAN SACACALICIAR'
	}
	,
	{
		lat: -40.824711,
		lng: -63.004701,
		icon: 'red',
		popup: 'CARLOS ROMAN 236',
		alt: '4141',
		nombre: 'LARA JULIO'
	}]


const recorridos = {		
		ruta1:{
			nombre: "Miercoles                                         ",
			color: "#e74c3c",
			peso:4,
			puntos: [
				
[-40.8158675,-63.0033763],
[-40.8222724,-62.9966591],
[-40.8244054,-63.0000572],
[-40.8213590,-63.0002412],
[-40.8205014,-62.9983147],
[-40.8268960,-62.9890289],
[-40.8187358,-63.0011611],
[-40.819661,-63.003720],
[-40.819708,-63.003831],
[-40.8199901,-63.0039250],
[-40.8268348,-62.9975319],
[-40.8161928,-63.0026233],
[-40.8204715,-63.0066373],
[-40.8058418,-63.0133976],
[-40.8205498,-63.0079883],
[-40.8118883,-62.9961589],
[-40.8118883,-62.9961589],
[-40.8231325,-63.0129092],
[-40.8118883,-62.9961589],
[-40.8241372,-63.0066876],
[-40.8105041,-63.0123305],
[-40.824711,-63.004701]
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