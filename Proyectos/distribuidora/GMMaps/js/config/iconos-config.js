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
		
'CONTRERAS_JULIO_CESAR' : { visual: 'user', color:'#e74c3c' , css: 'fa-user' },
'FREGO_MARINO' : { visual: 'user', color:'#3498db' , css: 'fa-user' },
'GONZALEZ_VALENTINA' : { visual: 'user', color:'#2ecc71' , css: 'fa-user' },
'TRONCOSO_JESSICA' : { visual: 'user', color:'#f39c12' , css: 'fa-user' },
'ZUNIGA_KAREN' : { visual: 'user', color:'#9b59b6' , css: 'fa-user' },
'ALMACEN' : { visual: 'store', color:'#e74c3c' , css: 'fa-store' },
'ALMACEN_Y_DESP' : { visual: 'store', color:'#3498db' , css: 'fa-store' },
'CARNIC_Y_DESP' : { visual: 'store', color:'#2ecc71' , css: 'fa-store' },
'CINE' : { visual: 'store', color:'#f39c12' , css: 'fa-store' },
'COTILLON' : { visual: 'store', color:'#9b59b6' , css: 'fa-store' },
'KIOSCO' : { visual: 'store', color:'#1abc9c' , css: 'fa-store' },
'MINIMERCADO' : { visual: 'store', color:'#e67e22' , css: 'fa-store' },
'OTROS' : { visual: 'store', color:'#34495e' , css: 'fa-store' },
'SUPERCHINO' : { visual: 'store', color:'#f1c40f' , css: 'fa-store' },
'SUPERMERCADO' : { visual: 'store', color:'#e91e63' , css: 'fa-store' },
'VERD_Y_DESP' : { visual: 'store', color:'#00bcd4' , css: 'fa-store' },
'VERDULERIA' : { visual: 'store', color:'#4caf50' , css: 'fa-store' },
'CATEGORIA_A' : { visual: 'caret-up', color:'#ff9800' , css: 'fa-caret-up' },
'CATEGORIA_B' : { visual: 'caret-up', color:'#673ab7' , css: 'fa-caret-up' },
'CATEGORIA_C' : { visual: 'caret-up', color:'#607d8b' , css: 'fa-caret-up' },
'CATEGORIA_D' : { visual: 'caret-up', color:'#795548' , css: 'fa-caret-up' },
'CATEGORIA_E' : { visual: 'caret-up', color:'#ff5722' , css: 'fa-caret-up' },
'CATEGORIA_G' : { visual: 'caret-up', color:'#009688' , css: 'fa-caret-up' },
'VERDULERIA_B' : { visual: 'caret-up', color:'#8bc34a' , css: 'fa-caret-up' },
'A2__INDFLRJARCA' : { visual: 'calendar-day', color:'#ffc107' , css: 'fa-calendar-day' },
'A3__SAN_MARTINNOR' : { visual: 'calendar-day', color:'#9c27b0' , css: 'fa-calendar-day' },
'A6__BANADOBICESJ' : { visual: 'calendar-day', color:'#03a9f4' , css: 'fa-calendar-day' },
'M1__CENTRO_PATAGON' : { visual: 'calendar-day', color:'#cddc39' , css: 'fa-calendar-day' },
'M2__CENTRO_VIEDMA' : { visual: 'calendar-day', color:'#ff6f00' , css: 'fa-calendar-day' },
'M3__RESTO_MABEL' : { visual: 'calendar-day', color:'#6a1b9a' , css: 'fa-calendar-day' },
'T1__SAN_JAVIER' : { visual: 'calendar-day', color:'#0277bd' , css: 'fa-calendar-day' },
'V1__HOSPCAGL' : { visual: 'calendar-day', color:'#689f38' , css: 'fa-calendar-day' },
'V2__GUIINAPIELB' : { visual: 'calendar-day', color:'#f57c00' , css: 'fa-calendar-day' },
'V6__IPPVTERMINAL' : { visual: 'calendar-day', color:'#512da8' , css: 'fa-calendar-day' }
	}
};
console.log('Iconos-config cargado (solo configuraciones):', Object.keys(window.iconosConfig.codigos).length, 'códigos');