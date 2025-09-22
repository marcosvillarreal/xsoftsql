// js/marcadores.js - Configuración visual de marcadores dinámicos
window.marcadoresManager = {
    
    // Crear marcador personalizado para un cliente
    crearMarcador: function(cliente) {
        const estilo = window.estadosManager.obtenerEstilo(cliente);
        const coords = cliente.coords;
        
        // Crear icono HTML personalizado
        const iconoHtml = this.generarIconoHTML(estilo);
        
        // Configurar icono de Leaflet
        const customIcon = L.divIcon({
            html: iconoHtml,
            className: 'custom-marker',
            iconSize: [30, 30],
            iconAnchor: [15, 15],
            popupAnchor: [0, -15]
        });
        
        // Crear marcador
        const marker = L.marker(coords, { icon: customIcon });
        
        // Configurar popup
        const popupContent = window.popupManager.generarContenido(cliente);
        marker.bindPopup(popupContent);
        
        // Agregar datos del cliente al marcador
        marker.clienteData = cliente;
        marker.estiloActual = estilo;
        
        return marker;
    },
    
    // Generar HTML del icono
    generarIconoHTML: function(estilo) {
        return `
            <div class="marker-container" style="
                background-color: ${estilo.color};
                border: 2px solid white;
                border-radius: 50%;
                width: 30px;
                height: 30px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                cursor: pointer;
                transition: all 0.2s ease;
            " onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'">
                ${estilo.icon}
            </div>
        `;
    },
    
    // Actualizar todos los marcadores según campo prioritario
    actualizarMarcadores: function(nuevosCampo = null) {
        if (nuevosCampo) {
            window.estadosManager.setCampoPrioritario(nuevosCampo);
        }
        
        if (!window.map || !window.markersLayer) return;
        
        console.log('🔄 Actualizando marcadores...');
        
        // Limpiar marcadores existentes
        window.markersLayer.clearLayers();
        
        // Recrear marcadores con nuevo estilo
        window.clientesData.forEach(cliente => {
            const marcador = this.crearMarcador(cliente);
            window.markersLayer.addLayer(marcador);
        });
        
        console.log(`✅ ${window.clientesData.length} marcadores actualizados`);
    },
    
    // Crear leyenda de colores
    crearLeyenda: function() {
        const campo = window.estadosManager.campoPrioritario;
        const configuraciones = window.estadosManager.configuraciones[campo];
        
        if (!configuraciones) return '';
        
        let leyendaHTML = `<div class="map-legend">
            <h4>🎨 ${window.camposConfig.dinamicos[campo]?.nombre || campo}</h4>`;
        
        Object.entries(configuraciones).forEach(([valor, config]) => {
            const count = window.clientesData ? 
                window.clientesData.filter(cliente => cliente[campo] === valor).length : 0;
            
            leyendaHTML += `
                <div class="legend-item">
                    <span class="legend-color" style="
                        background-color: ${config.color};
                        width: 15px;
                        height: 15px;
                        border-radius: 50%;
                        display: inline-block;
                        margin-right: 8px;
                        border: 1px solid #ddd;
                    "></span>
                    ${config.icon} ${config.descripcion} (${count})
                </div>
            `;
        });
        
        leyendaHTML += '</div>';
        return leyendaHTML;
    },
    
    // Actualizar leyenda en el HTML
    actualizarLeyenda: function() {
        const leyendaContainer = document.querySelector('.legend-container');
        if (leyendaContainer) {
            leyendaContainer.innerHTML = this.crearLeyenda();
        }
    }
};