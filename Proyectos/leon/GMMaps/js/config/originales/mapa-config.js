// config/mapa-config.js - Configuración pura del mapa
window.mapaConfig = {
    // Configuración del mapa base
    centro: [-38.7391916866693, -62.2135663202395], // Centro por defecto (será dinámico)
    zoom: 13,
    maxZoom: 18,
    minZoom: 8,
    
    // Configuración de tiles
    tileLayer: {
        url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        attribution: '© <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    },
    
    // Configuración de marcadores
    marcadores: {
        tamaño: [30, 30],
        anchor: [15, 15],
        popupAnchor: [0, -15],
        className: 'custom-marker'
    },
    
    // Configuración de popups
    popup: {
        maxWidth: 300,
        className: 'custom-popup',
        closeOnClick: false,
        autoClose: true
    },
    
    // Configuración de búsqueda
    busqueda: {
        placeholder: 'Buscar por nombre, teléfono, email...',
        minCaracteres: 1,
        campos_busqueda: [] // Se llena automáticamente desde campos-config
    },
    
    // Configuración de animaciones
    animaciones: {
        centrar: {
            duration: 1.5,
            easeLinearity: 0.25
        },
        zoom: {
            animate: true,
            duration: 1.0
        }
    },
    
    // Versión del sistema
    version: '2.3.2 - Arquitectura Modular'
};

console.log('🗺️ Mapa-config cargado v', window.mapaConfig.version);