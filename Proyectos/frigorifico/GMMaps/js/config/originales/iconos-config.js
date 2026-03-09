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
		'MINIMERCADO': { visual: 'store', color: '#28a745', css: 'fa-store' },
		
        
        // Zonas geográficas
        'NORTE': { visual: 'arrow-up', color: '#ff6b6b', css: 'fa-arrow-up' },
        'SUR': { visual: 'arrow-down', color: '#4ecdc4', css: 'fa-arrow-down' },
        'ESTE': { visual: 'arrow-right', color: '#45b7d1', css: 'fa-arrow-right' },
        'OESTE': { visual: 'arrow-left', color: '#f9ca24', css: 'fa-arrow-left' },
        'CENTRO': { visual: 'bullseye', color: '#6c5ce7', css: 'fa-bullseye' },
        
        // Tipos de negocio
        'COMERCIAL': { visual: 'building', color: '#2196f3', css: 'fa-building' },
        'PARTICULAR': { visual: 'user', color: '#4caf50', css: 'fa-user' },
        'EMPRESA': { visual: 'industry', color: '#ff9800', css: 'fa-industry' },
        
        // Prioridades
        'ALTA': { visual: 'bolt', color: '#e74c3c', css: 'fa-bolt' },
        'MEDIA': { visual: 'circle', color: '#f39c12', css: 'fa-circle' },
        'BAJA': { visual: 'circle', color: '#27ae60', css: 'fa-circle' },
        
        // Default/fallback
        'DEFAULT': { visual: 'map-marker-alt', color: '#6c757d', css: 'fa-map-marker-alt' }
		
		'DOLLAR': { visual: 'dollar', color: '#6c757d', css: 'fa-dollar' }
		
    }
};

console.log('Iconos-config cargado (solo configuraciones):', Object.keys(window.iconosConfig.codigos).length, 'códigos');