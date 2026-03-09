// modules/iconos-helper.js - Helper para manejo de iconos sin emojis
window.iconosHelper = {
    
    // Mapeo de iconos de texto a HTML
    iconosTexto: {
		'check-circle': '<i class="fas fa-check-circle"></i>',
        'user': '<i class="fas fa-user"></i>',
        'dollar': '<i class="fas fa-dollar-sign"></i>',
        'star': '<i class="fas fa-star"></i>',
        'phone': '<i class="fas fa-phone"></i>',
        'mail': '<i class="fas fa-envelope"></i>',
        'money': '<i class="fas fa-money-bill-wave"></i>',
        'globe': '<i class="fas fa-globe"></i>',
        'credit-card': '<i class="fas fa-credit-card"></i>',
        'building': '<i class="fas fa-building"></i>',
        'home': '<i class="fas fa-home"></i>',
        'map': '<i class="fas fa-map-marker-alt"></i>',
        'default': '<i class="fas fa-circle"></i>'
    },
    
    // Obtener icono HTML desde texto
    obtenerIconoHTML: function(iconoTexto) {
        return this.iconosTexto[iconoTexto] || this.iconosTexto['default'];
    },
    
    // Obtener icono desde configuración de campo
    obtenerIconoCampo: function(config) {
        if (config && config.icono_texto) {
            return this.obtenerIconoHTML(config.icono_texto);
        }
        return this.iconosTexto['default'];
    }
};

console.log('🎨 Iconos-helper cargado');