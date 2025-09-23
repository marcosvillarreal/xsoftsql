// js/popups.js - Generación dinámica de popups
window.popupManager = {
    
    // Generar contenido del popup automáticamente
    generarContenido: function(cliente) {
        // Obtener estilo dinámico en lugar de categoría fija
        const estilo = window.estadosManager ? window.estadosManager.obtenerEstilo(cliente) : {
            color: '#6c757d',
            icon: '📍',
            descripcion: 'Cliente'
        };
        
        let infoAdicional = '';
        
        // Generar información adicional basada en campos configurados
        if (window.camposConfig && window.camposConfig.dinamicos) {
            Object.entries(window.camposConfig.dinamicos).forEach(([campo, fieldConfig]) => {
                if (fieldConfig.mostrar_popup && (cliente[campo] || cliente[campo] === 'false' || cliente[campo] === '0')) {
                    const valor = this.formatearValor(cliente[campo], fieldConfig);
                    const icono = window.iconosHelper ? window.iconosHelper.obtenerIconoCampo(fieldConfig) : '📋';
                    infoAdicional += `${icono} ${fieldConfig.nombre}: ${valor}<br>`;
                }
            });
        }
        
        return `
            <div class="popup-content">
                <div class="popup-title">${cliente.nombre || 'Cliente sin nombre'}</div>
                <div class="popup-info">
                    📍 ${cliente.direccion || 'Dirección no especificada'}<br>
                    🆔 Cliente: ${cliente.num || 'Sin ID'}<br>
                    📅 Alta: ${cliente.fecha_alta || 'N/A'}<br>
                    🏢 Tipo: ${cliente.tipo_negocio || 'No especificado'}<br>
                    ${infoAdicional}
                </div>
                <div class="popup-category" style="background: ${estilo.color}; color: white; padding: 8px; border-radius: 8px; text-align: center; margin-top: 8px;">
                    ${estilo.icon} ${estilo.descripcion.toUpperCase()}
                </div>
            </div>
        `;
    },
    
    // Formatear valor según el tipo de campo
    formatearValor: function(valor, fieldConfig) {
        if (!valor && valor !== 'false' && valor !== '0') return '';
        
        switch (fieldConfig.tipo) {
            case 'numero':
                if (fieldConfig.formato === 'moneda') {
                    return '$' + parseInt(valor).toLocaleString();
                }
                return parseInt(valor).toLocaleString();
            case 'email':
                return `<a href="mailto:${valor}" style="color: #667eea;">${valor}</a>`;
            case 'select':
                return this.formatearOpcion(valor);
            default:
                return valor;
        }
    },
    
    // Formatear opción para mostrar (capitalizar) - Ahora solo maneja strings
    formatearOpcion: function(opcion) {
        if (!opcion && opcion !== 'false' && opcion !== '0') return '';
        
        // Formatear valores booleanos como strings
        if (opcion === 'true') return 'Activo';
        if (opcion === 'false') return 'Inactivo';
        
        // Formatear otros strings normalmente
        return opcion.toString().charAt(0).toUpperCase() + opcion.slice(1).replace(/_/g, ' ');
    }
};