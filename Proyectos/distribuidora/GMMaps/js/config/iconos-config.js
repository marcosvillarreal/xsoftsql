// config/iconos-config.js - SOLO CONFIGURACIONES DE ICONOS (Sin lógica)
window.iconosConfig = {        
	// Mapeo de códigos simples a iconos visuales    
	codigos: {        
		// Estados básicos        
		'ACTIVO': { visual: 'check-circle', color: '#28a745', css: 'fa-check-circle' },        
		'INACTIVO': { visual: 'times-circle', color: '#dc3545', css: 'fa-times-circle' },                
		// Estados de cuenta        
		'AL_DIA': { visual: 'check', color: '#28a745', css: 'fa-check' },        
		'CON_DEUDA': { visual: 'exclamation-triangle', color: '#ffc107', css: 'fa-exclamation-triangle' },        
		'MOROSO': { visual: 'clock', color: '#fd7e14', css: 'fa-clock' },        
		'BLOQUEADO': { visual: 'ban', color: '#dc3545', css: 'fa-ban' },                
		// Categorías de cliente        
		'CLIENTES': { visual: 'user', color: '#4caf50', css: 'fa-user' },        
		'BRONZE': { visual: 'medal', color: '#cd7f32', css: 'fa-medal' },        
		'SILVER': { visual: 'medal', color: '#c0c0c0', css: 'fa-medal' },        
		'GOLD': { visual: 'medal', color: '#ffd700', css: 'fa-medal' },        
		'PREMIUM': { visual: 'gem', color: '#9932cc', css: 'fa-gem' },        
		'VIP': { visual: 'crown', color: '#ff1493', css: 'fa-crown' },                
		// Canales de venta             
		'ONLINE': { visual: 'laptop', color: '#007bff', css: 'fa-laptop' },        
		'PRESENCIAL': { visual: 'store', color: '#17a2b8', css: 'fa-store' },        
		'TELEFONO': { visual: 'phone', color: '#6c757d', css: 'fa-phone' },        
		'MIXTO': { visual: 'sync-alt', color: '#6f42c1', css: 'fa-sync-alt' },        
		'OTROS': { visual: 'file-alt', color: '#28a745', css: 'fa-file-alt' },        	        
		// Zonas geográficas        
		'SIN SECTOR': { visual: 'question-circle', color: '#6c757d', css: 'fa-question-circle' },        
		'NORTE': { visual: 'arrow-up', color: '#ff6b6b', css: 'fa-arrow-up' },        
		'SUR': { visual: 'arrow-down', color: '#4ecdc4', css: 'fa-arrow-down' },        
		'ESTE': { visual: 'arrow-right', color: '#45b7d1', css: 'fa-arrow-right' },        
		'OESTE': { visual: 'arrow-left', color: '#f9ca24', css: 'fa-arrow-left' },        
		'CENTRO': { visual: 'bullseye', color: '#6c5ce7', css: 'fa-bullseye' },                
		// Tipos de negocio        
		'COMERCIAL': { visual: 'building', color: '#2196f3', css: 'fa-building' },        
		'PARTICULAR': { visual: 'user', color: '#4caf50', css: 'fa-user' },        
		'EMPRESA': { visual: 'industry', color: '#ff9800', css: 'fa-industry' },                
		// Prioridades        'ALTA': { visual: 'bolt', color: '#e74c3c', css: 'fa-bolt' },        
		'MEDIA': { visual: 'circle', color: '#f39c12', css: 'fa-circle' },        
		'BAJA': { visual: 'circle', color: '#27ae60', css: 'fa-circle' },
		// Otros Estado   
		'NINGUNO': { visual: 'map-marker-alt', color: '#6c757d', css: 'fa-map-marker-alt' },                
		'VENTA' : { visual: 'dollar-sign', color:'#6c757d' , css: 'fa-dollar-sign' },
		'NO_VENTA' : { visual: 'clock', color:'#ff5722' , css: 'fa-clock' },
		// Default/fallback        
		'DEFAULT': { visual: 'map-marker-alt', color: '#6c757d', css: 'fa-map-marker-alt' },    
		//Otros
		
'DAIANA' : { visual: 'user', color:'#e74c3c' , css: 'fa-user' },
'MARCOS' : { visual: 'user', color:'#3498db' , css: 'fa-user' },
'OSCAR_BAHIA' : { visual: 'user', color:'#2ecc71' , css: 'fa-user' },
'ALMACEN_Y_DESP' : { visual: 'store', color:'#e74c3c' , css: 'fa-store' },
'MINIMERCADO' : { visual: 'store', color:'#3498db' , css: 'fa-store' },
'OTROS' : { visual: 'store', color:'#2ecc71' , css: 'fa-store' },
'CLIENTES' : { visual: 'caret-up', color:'#f39c12' , css: 'fa-caret-up' },
'CTA_CTE_SERVICIO' : { visual: 'caret-up', color:'#9b59b6' , css: 'fa-caret-up' },
'JUEVES_1_VROSAS_WHI' : { visual: 'calendar-day', color:'#1abc9c' , css: 'fa-calendar-day' },
'JUEVES_2_CENTRO_SUDE' : { visual: 'calendar-day', color:'#e67e22' , css: 'fa-calendar-day' },
'JUEVES_3_RESTO' : { visual: 'calendar-day', color:'#34495e' , css: 'fa-calendar-day' },
'MARTES_1_CENTRO_NORT' : { visual: 'calendar-day', color:'#f1c40f' , css: 'fa-calendar-day' },
'MARTES_2_NORTE' : { visual: 'calendar-day', color:'#e91e63' , css: 'fa-calendar-day' },
'MARTES_3_CENTRO' : { visual: 'calendar-day', color:'#00bcd4' , css: 'fa-calendar-day' },
'MIECOLES_3_ESPORA' : { visual: 'calendar-day', color:'#4caf50' , css: 'fa-calendar-day' },
'MIERCOLES_1_VMITRE' : { visual: 'calendar-day', color:'#ff9800' , css: 'fa-calendar-day' },
'MIERCOLES_2_ALDEA_RO' : { visual: 'calendar-day', color:'#673ab7' , css: 'fa-calendar-day' },
'VIERNES_1_BORDEUX_MA' : { visual: 'calendar-day', color:'#607d8b' , css: 'fa-calendar-day' },
'VIERNES_2' : { visual: 'calendar-day', color:'#795548' , css: 'fa-calendar-day' },
'VIERNES_3' : { visual: 'calendar-day', color:'#ff5722' , css: 'fa-calendar-day' },
'VIERNES_4' : { visual: 'calendar-day', color:'#009688' , css: 'fa-calendar-day' }
	}
};
console.log('Iconos-config cargado (solo configuraciones):', Object.keys(window.iconosConfig.codigos).length, 'códigos');