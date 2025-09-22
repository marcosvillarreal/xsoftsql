// js/configuracion.js - Configuración general del mapa
window.mapaConfig = {
    // Configuración del mapa
    centro: [-38.7391916866693, -62.2135663202395],
    zoom: 13,
    maxZoom: 18,
    
    // Configuración de popups
    popup: {
        maxWidth: 300,
        className: 'custom-popup'
    },
    
    // Configuración de búsqueda
    busqueda: {
        placeholder: 'Buscar por nombre, teléfono, email...',
        campos_busqueda: [] // Se llena automáticamente
    },
    
    // Versión
    version: '2.4 - Dinámico',
    
    // Inicializar configuración
    init: function() {
        // Generar campos de búsqueda automáticamente
        if (window.camposConfig) {
            this.busqueda.campos_busqueda = Object.entries(window.camposConfig.dinamicos)
                .filter(([campo, config]) => config.buscable)
                .map(([campo, config]) => campo);
        }
            
        console.log(`📊 GM Solutions v${this.version} - Configuración inicializada`);
    }
};