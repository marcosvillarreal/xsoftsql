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
		lat: -38.6967923029844,
		lng: -62.3144030202384,
		icon: 'green',
		popup: 'EDUARDO GUTIERREZ 825',
		alt: '2466',
		nombre: 'MARTINEZ ROSANA EDITH'
	}
	,
	{
		lat: -38.7207578893172,
		lng: -62.3132003509256,
		icon: 'green',
		popup: 'PACIFICO 2020',
		alt: '157',
		nombre: 'MAO YINBING'
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
		lat: -38.7069681616448,
		lng: -62.3101690914025,
		icon: 'green',
		popup: 'AVELLANEDA 2736',
		alt: '256',
		nombre: 'LIN MAOCHUN'
	}
	,
	{
		lat: -38.7168196442165,
		lng: -62.3182139595157,
		icon: 'green',
		popup: 'PACIFICO 2500',
		alt: '2502',
		nombre: 'VILLEGAS JUAN'
	}
	,
	{
		lat: -38.719587986097,
		lng: -62.3100046932538,
		icon: 'green',
		popup: 'SANTA CRUZ 1927',
		alt: '63',
		nombre: 'BAEZA DEL CARMEN PINO NURIA'
	}
	,
	{
		lat: -38.724227147632,
		lng: -62.2995211220898,
		icon: 'green',
		popup: 'PAMPA CENTRAL 1141',
		alt: '807',
		nombre: 'CHEN JINYING'
	}
	,
	{
		lat: -38.7171489474687,
		lng: -62.3107878797605,
		icon: 'green',
		popup: 'MARTIN GIL 2099',
		alt: '272',
		nombre: 'PEREZ JAILLITA FELICIDAD'
	}
	,
	{
		lat: -38.7015540573844,
		lng: -62.3019792747933,
		icon: 'green',
		popup: 'TERRADA 2670  ENTRE LAS CALLE',
		alt: '2592',
		nombre: 'SCARFI LEONEL'
	}
	,
	{
		lat: -38.7020321920878,
		lng: -62.3054132067465,
		icon: 'green',
		popup: 'FABIAN GONZALEZ 683',
		alt: '2650',
		nombre: 'ULLOA BERTA MAGDALENA'
	}
	,
	{
		lat: -38.6843936645244,
		lng: -62.3377268220897,
		icon: 'green',
		popup: 'HARRIGTON 5754  BARRIO  DON',
		alt: '2484',
		nombre: 'LLAMAS GINA DANILA'
	}
	,
	{
		lat: -38.7134708088937,
		lng: -62.3214318730166,
		icon: 'green',
		popup: 'PACIFICO 2755',
		alt: '1272',
		nombre: 'CURUIL DANIEL'
	}
	,
	{
		lat: -38.710584,
		lng: -62.305953,
		icon: 'green',
		popup: 'AVELLANEDA 2298',
		alt: '1276',
		nombre: 'HOLZMAN GUSTAVO'
	}
	,
	{
		lat: -38.712905,
		lng: -62.303681,
		icon: 'green',
		popup: '17 DE MAYO 1259',
		alt: '1350',
		nombre: 'CASTRO ROCIO LUZ CLARA'
	}
	,
	{
		lat: -38.70075,
		lng: -62.33819,
		icon: 'green',
		popup: 'RUTA 35 KM 83 0',
		alt: '692',
		nombre: 'GARCIA ADRIAN HECTOR OMAR'
	}
	,
	{
		lat: -38.7216403592276,
		lng: -62.3082197349483,
		icon: 'green',
		popup: 'MALDONADO 2030',
		alt: '1058',
		nombre: 'MANSILLA ANA'
	}
	,
	{
		lat: -38.6782996650503,
		lng: -62.3343030085975,
		icon: 'green',
		popup: '9 DE JULIO 5277',
		alt: '46',
		nombre: 'ROBERT JUAN'
	}]


const recorridos = {		
		ruta1:{
			nombre: "MARTIN                                            ",
			color: "#e74c3c",
			peso:4,
			puntos: [
				
[-38.6967923029844,-62.3144030202384],
[-38.7207578893172,-62.3132003509256],
[-38.7104222734131,-62.3031717644179],
[-38.7069681616448,-62.3101690914025],
[-38.7168196442165,-62.3182139595157],
[-38.719587986097,-62.3100046932538],
[-38.724227147632,-62.2995211220898],
[-38.7171489474687,-62.3107878797605],
[-38.7015540573844,-62.3019792747933],
[-38.7020321920878,-62.3054132067465],
[-38.6843936645244,-62.3377268220897],
[-38.7134708088937,-62.3214318730166],
[-38.710584,-62.305953],
[-38.712905,-62.303681],
[-38.70075,-62.33819],
[-38.7216403592276,-62.3082197349483],
[-38.6782996650503,-62.3343030085975]
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
