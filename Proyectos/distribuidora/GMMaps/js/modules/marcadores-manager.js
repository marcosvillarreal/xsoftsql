// modules/marcadores-manager.js - Solo lógica de marcadores visuales
window.marcadoresManager = {
    
    // Crear marcador personalizado para un cliente
    crearMarcador: function(cliente) {
        if (!window.estadosManager || !window.popupManager) {
            console.error('❌ Dependencias no disponibles para crear marcador');
            return null;
        }
        
        const estilo = window.estadosManager.obtenerEstilo(cliente);
        const coords = cliente.coords;
        
        // Crear icono HTML personalizado
        const iconoHtml = this.generarIconoHTML(estilo);
        
        // Configurar icono de Leaflet usando configuración
        const config = window.mapaConfig?.marcadores || {
            tamaño: [30, 30],
            anchor: [15, 15],
            popupAnchor: [0, -15],
            className: 'custom-marker'
        };
        
        const customIcon = L.divIcon({
            html: iconoHtml,
            className: config.className,
            iconSize: config.tamaño,
            iconAnchor: config.anchor,
            popupAnchor: config.popupAnchor
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
    actualizarMarcadores: function(nuevoCampo = null) {
        if (!window.estadosManager || !window.map || !window.markersLayer) {
            console.error('❌ Dependencias no disponibles para actualizar marcadores');
            return;
        }
        
        if (nuevoCampo) {
            window.estadosManager.setCampoPrioritario(nuevoCampo);
        }
        
        console.log('🔄 Actualizando marcadores...');
        
        // Limpiar marcadores existentes
        window.markersLayer.clearLayers();
        
        // Recrear marcadores con nuevo estilo
        if (window.clientesData) {
            window.clientesData.forEach(cliente => {
                const marcador = this.crearMarcador(cliente);
                if (marcador) {
                    window.markersLayer.addLayer(marcador);
                }
            });
        }
        
        console.log(`✅ ${window.clientesData?.length || 0} marcadores actualizados`);
    },
    
    // Crear leyenda de colores
    crearLeyenda: function() {
        if (!window.estadosManager || !window.camposConfig || !window.iconosConfig) {
            return '<div>Error: Configuración no disponible</div>';
        }
        
        const campo = window.estadosManager.campoPrioritario;
        const configuraciones = window.estadosConfig?.[campo];
        
        if (!configuraciones) {
            return '<div>No hay configuración para el campo actual</div>';
        }
        
        let leyendaHTML = `<div class="map-legend">
            <h4>🎨 ${window.camposConfig.dinamicos[campo]?.nombre || campo}</h4>`;
        
        Object.entries(configuraciones).forEach(([valor, config]) => {
            const count = window.clientesData ? 
                window.clientesData.filter(cliente => {
                    const valorCliente = cliente[campo];
                    if (!valorCliente) return false;
                    return valorCliente.toString().toLowerCase() === valor.toLowerCase();
                }).length : 0;
            
            // Obtener icono y color usando el sistema de códigos
            const icono = window.iconosManager ? window.iconosManager.obtenerIcono(config.codigo, 'emoji') : '📍';
            const color = window.iconosManager ? window.iconosManager.obtenerColor(config.codigo) : '#6c757d';
            
            leyendaHTML += `
                <div class="legend-item">
                    <span class="legend-color" style="
                        background-color: ${color};
                        width: 15px;
                        height: 15px;
                        border-radius: 50%;
                        display: inline-block;
                        margin-right: 8px;
                        border: 1px solid #ddd;
                    "></span>
                    ${icono} ${config.descripcion} (${count})
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

console.log('🗺️ Marcadores-manager cargado');