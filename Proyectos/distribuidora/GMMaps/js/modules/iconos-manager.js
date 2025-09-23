// modules/iconos-manager.js - Solo lógica de manejo de iconos
window.iconosManager = {
    
    // Función para obtener icono por código
    obtenerIcono: function(codigo, tipoRender = 'visual') {
        if (!window.iconosConfig) {
            console.error('❌ iconosConfig no disponible');
            return this.obtenerIconoDefault();
        }
        
        if (!codigo) return this.obtenerIconoConfig('DEFAULT');
        
        const codigoUpper = codigo.toString().toUpperCase();
        const iconoConfig = window.iconosConfig.codigos[codigoUpper] || window.iconosConfig.codigos['DEFAULT'];
        
        if (tipoRender === 'css') {
            return `<i class="fas ${iconoConfig.css}" style="color: ${iconoConfig.color};"></i>`;
        }
        
        if (tipoRender === 'emoji') {
            // Mapeo a emojis para compatibilidad
            return this.convertirAEmoji(iconoConfig.visual);
        }
        
        return iconoConfig.visual; // Nombre del icono FontAwesome
    },
    
    // Función para obtener color por código
    obtenerColor: function(codigo) {
        if (!window.iconosConfig) return '#6c757d';
        
        if (!codigo) return window.iconosConfig.codigos['DEFAULT'].color;
        
        const codigoUpper = codigo.toString().toUpperCase();
        const iconoConfig = window.iconosConfig.codigos[codigoUpper] || window.iconosConfig.codigos['DEFAULT'];
        
        return iconoConfig.color;
    },
    
    // Obtener configuración completa del icono
    obtenerIconoConfig: function(codigo) {
        if (!window.iconosConfig) return this.obtenerIconoDefault();
        
        const codigoUpper = codigo ? codigo.toString().toUpperCase() : 'DEFAULT';
        return window.iconosConfig.codigos[codigoUpper] || window.iconosConfig.codigos['DEFAULT'];
    },
    
    // Icono por defecto
    obtenerIconoDefault: function() {
        return {
            visual: 'map-marker-alt',
            color: '#6c757d',
            css: 'fa-map-marker-alt'
        };
    },
    
    // Convertir nombre de icono a emoji (para compatibilidad)
    convertirAEmoji: function(nombreIcono) {
        const mapeoEmojis = {
            'check-circle': '✅',
            'times-circle': '❌',
            'check': '💚',
            'exclamation-triangle': '⚠️',
            'clock': '⏰',
            'ban': '🚫',
            'medal': '🏅',
            'gem': '💎',
            'crown': '👑',
            'laptop': '💻',
            'store': '🏪',
            'warehouse': '🏢',
            'phone': '📞',
            'sync-alt': '🔄',
            'file-alt': '📄',
            'question-circle': '❓',
            'calendar-day': '📅',
            'arrow-up': '⬆️',
            'arrow-down': '⬇️',
            'arrow-right': '➡️',
            'arrow-left': '⬅️',
            'bullseye': '🎯',
            'building': '🏢',
            'user': '👤',
            'industry': '🏭',
            'bolt': '⚡',
            'circle': '⚪',
            'map-marker-alt': '📍'
        };
        
        return mapeoEmojis[nombreIcono] || '📍';
    },
    
    // Listar todos los códigos disponibles
    listarCodigos: function() {
        if (!window.iconosConfig) return [];
        return Object.keys(window.iconosConfig.codigos);
    },
    
    // Generar HTML de icono completo
    generarHTMLIcono: function(codigo, tamaño = '16px') {
        const config = this.obtenerIconoConfig(codigo);
        
        // Verificar que config tiene todas las propiedades necesarias
        if (!config || !config.css || !config.color) {
            console.warn(`⚠️ Configuración incompleta para código: ${codigo}`, config);
            const defaultConfig = this.obtenerIconoDefault();
            return `<i class="fas ${defaultConfig.css}" style="color: ${defaultConfig.color}; font-size: ${tamaño};"></i>`;
        }
        
        console.log('🎨 Iconos-manager, generando HTML para:', codigo, config);
        return `<i class="fas ${config.css}" style="color: ${config.color}; font-size: ${tamaño};"></i>`;
    }
};

console.log('🎨 Iconos-manager cargado');