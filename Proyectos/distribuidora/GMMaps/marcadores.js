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
		lat: -38.7446507551018,
		lng: -62.1894231779108,
		icon: 'green',
		popup: 'INGENIERO LUNA 2361  BARRIO',
		alt: '2797',
		nombre: 'GONZALEZ SARA'
	}
	,
	{
		lat: -38.7199204870122,
		lng: -62.2007585220892,
		icon: 'green',
		popup: 'LUIS AGOTE 3171',
		alt: '1175',
		nombre: 'MARDONES NOEMI GRACIELA'
	}
	,
	{
		lat: -38.729701635509,
		lng: -62.2219596423237,
		icon: 'green',
		popup: 'DORBIGNY 2718',
		alt: '2146',
		nombre: 'STELE CLAUDIA PATRICIA'
	}
	,
	{
		lat: -38.7146180874,
		lng: -62.1887942017722,
		icon: 'green',
		popup: 'QUINQUELA MARTIN 4144HARDEEN',
		alt: '49',
		nombre: 'SAVOF NATALIA'
	}
	,
	{
		lat: -38.72319,
		lng: -62.19881,
		icon: 'green',
		popup: 'ROBERTO CLEGG 3338',
		alt: '226',
		nombre: 'PERFECTIVA SANTOS'
	}
	,
	{
		lat: -38.7295586046741,
		lng: -62.2180488067465,
		icon: 'green',
		popup: 'GUARDIA VIEJA Y ROJAS',
		alt: '36',
		nombre: 'MARTINEZ MARISOL'
	}
	,
	{
		lat: -38.730232,
		lng: -62.218521,
		icon: 'green',
		popup: 'GUARDIA VIEJA 1821',
		alt: '1665',
		nombre: 'FANTAGUSI PATRICIA'
	}
	,
	{
		lat: -38.7518419429706,
		lng: -62.1772842067465,
		icon: 'green',
		popup: 'CONSTANCIO VIGIL 1445',
		alt: '2757',
		nombre: 'DURAN MARCOS DANIEL'
	}
	,
	{
		lat: -38.74331,
		lng: -62.16455,
		icon: 'green',
		popup: 'TTE MAYO 3625',
		alt: '2771',
		nombre: 'SAGRIPANTI GABRIELA EDITH'
	}
	,
	{
		lat: -38.7462102270709,
		lng: -62.1898763509248,
		icon: 'green',
		popup: 'LUCIO MANSILLA 2235',
		alt: '2775',
		nombre: 'MONTENEGRO MARIANA SOLEDAD'
	}
	,
	{
		lat: -38.7490517672229,
		lng: -62.1931233797605,
		icon: 'green',
		popup: 'MANSILLA 1867',
		alt: '1079',
		nombre: 'MATEO JORGE DANIE'
	}
	,
	{
		lat: -38.7366654706984,
		lng: -62.2269195644178,
		icon: 'green',
		popup: 'GUARDIA VIEJA Y NEWTON',
		alt: '1085',
		nombre: 'MERCADITO LA CHOLA'
	}
	,
	{
		lat: -38.717112066038,
		lng: -62.1940632779108,
		icon: 'green',
		popup: 'MARTIN A MALHARRO 3328',
		alt: '133',
		nombre: 'ECHARRI SEBASTIAN HORACIO'
	}
	,
	{
		lat: -38.7124309162762,
		lng: -62.1940299435559,
		icon: 'green',
		popup: 'SALINAS 3814',
		alt: '823',
		nombre: 'SAVOFF MAURO DEMETRIO'
	}
	,
	{
		lat: -38.7392921088297,
		lng: -62.2136199644178,
		icon: 'green',
		popup: 'SAN JOSE 1260',
		alt: '2594',
		nombre: 'ZHENG XUEQIN'
	}
	,
	{
		lat: -38.7384382008263,
		lng: -62.2293984220892,
		icon: 'green',
		popup: 'GUARDIA VIEJA 554',
		alt: '141',
		nombre: 'GARRIDO HIDALGO EDUARDO ENRIQUE'
	}
	,
	{
		lat: -38.7383510377534,
		lng: -62.2177226067465,
		icon: 'green',
		popup: 'RINCON 3435',
		alt: '2766',
		nombre: 'SALGADO PEREZ ALEXANDER JESUS'
	}
	,
	{
		lat: -38.7484528003969,
		lng: -62.1814511644178,
		icon: 'green',
		popup: 'MARTIN CORONADO 5433',
		alt: '2798',
		nombre: 'SEPULVEDA MABEL'
	}
	,
	{
		lat: -38.7134043529495,
		lng: -62.1946649220892,
		icon: 'green',
		popup: 'INDIADA 4035',
		alt: '1505',
		nombre: 'FUENTES BERTA SILVANA (SUCURSAL)'
	}
	,
	{
		lat: -38.7324793294383,
		lng: -62.2231330932535,
		icon: 'green',
		popup: 'LAINEZ 2840',
		alt: '981',
		nombre: 'CHEN JIANFA'
	}
	,
	{
		lat: -38.7387003769744,
		lng: -62.2241723139313,
		icon: 'green',
		popup: 'INDIADA 700',
		alt: '929',
		nombre: 'LI HAIXIA'
	}
	,
	{
		lat: -38.74901,
		lng: -62.19397,
		icon: 'green',
		popup: 'BAIGORRIA 4638',
		alt: '1759',
		nombre: 'FUENTES VERONICA ANDREA'
	}
	,
	{
		lat: -38.749930,
		lng: -62.194112,
		icon: 'green',
		popup: 'LUCIO MANSILLA 2193',
		alt: '2776',
		nombre: 'VEDOVALDI SILVINA ALEJANDRA'
	}
	,
	{
		lat: -38.683669,
		lng: -62.293461,
		icon: 'green',
		popup: 'REPUBLICA SIRIA 3301',
		alt: '2355',
		nombre: 'SACOMANI MARIANO NICOLAS'
	}
	,
	{
		lat: -38.666957,
		lng: -62.266102,
		icon: 'green',
		popup: 'VERA 3025',
		alt: '212',
		nombre: 'LLEIFUL CARLOS DARIO'
	}
	,
	{
		lat: -38.206600,
		lng: -61.771590,
		icon: 'green',
		popup: 'BELGRANO 202',
		alt: '2803',
		nombre: 'DUBE ARIEL ALEJANDRO'
	}
	,
	{
		lat: -38.781871,
		lng: -62.267963,
		icon: 'green',
		popup: 'AV SAN MARTIN 3489',
		alt: '1667',
		nombre: 'VEGA MARCELO MARTIN'
	}
	,
	{
		lat: -38.768586,
		lng: -62.275307,
		icon: 'green',
		popup: 'MAESTRO PICCIOLI 3391',
		alt: '1607',
		nombre: 'BOBADILLA DANIEL'
	}
	,
	{
		lat: -38.783548,
		lng: -62.265757,
		icon: 'green',
		popup: 'SAN MARTIN 3671',
		alt: '892',
		nombre: 'KE WUJIN'
	}]


const recorridos = {		
		ruta1:{
			nombre: "MARTIN                                            ",
			color: "#e74c3c",
			peso:4,
			puntos: [
				
[-38.7446507551018,-62.1894231779108],
[-38.7199204870122,-62.2007585220892],
[-38.729701635509,-62.2219596423237],
[-38.7146180874,-62.1887942017722],
[-38.72319,-62.19881],
[-38.7295586046741,-62.2180488067465],
[-38.730232,-62.218521],
[-38.7518419429706,-62.1772842067465],
[-38.74331,-62.16455],
[-38.7462102270709,-62.1898763509248],
[-38.7490517672229,-62.1931233797605],
[-38.7366654706984,-62.2269195644178],
[-38.717112066038,-62.1940632779108],
[-38.7124309162762,-62.1940299435559],
[-38.7392921088297,-62.2136199644178],
[-38.7384382008263,-62.2293984220892],
[-38.7383510377534,-62.2177226067465],
[-38.7484528003969,-62.1814511644178],
[-38.7134043529495,-62.1946649220892],
[-38.7324793294383,-62.2231330932535],
[-38.7387003769744,-62.2241723139313],
[-38.74901,-62.19397],
[-38.749930,-62.194112],
[-38.683669,-62.293461],
[-38.666957,-62.266102],
[-38.206600,-61.771590],
[-38.781871,-62.267963],
[-38.768586,-62.275307],
[-38.783548,-62.265757]
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
