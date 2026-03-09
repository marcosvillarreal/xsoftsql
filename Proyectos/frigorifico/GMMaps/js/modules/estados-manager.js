// modules/estados-manager.js - Manejo de estados con códigos VFP
window.estadosManager = {
    
    // Campo prioritario para determinar el estilo del marcador
    campoPrioritario: 'categoria_cliente',
    
    // Obtener configuración de estilo para un cliente usando códigos
    obtenerEstilo: function(cliente) {
        if (!window.estadosConfig || !window.iconosConfig) {
            console.error('❌ estadosConfig o iconosConfig no disponible');
            return this.getEstiloPorDefecto();
        }
        
        // Intentar por campo prioritario primero
        let campo = this.campoPrioritario;
        let valor = cliente[campo];
        
        if (valor && window.estadosConfig[campo]) {
            // Buscar coincidencia case-insensitive
            const valorNormalizado = valor.toString().toLowerCase();
            const configuracionValor = window.estadosConfig[campo][valorNormalizado];
            
            if (configuracionValor) {
                const configuracion = configuracionValor;
                const iconoInfo = window.iconosManager ? window.iconosManager.obtenerIcono(configuracion.codigo, 'emoji') : '📍';
                const color = window.iconosManager ? window.iconosManager.obtenerColor(configuracion.codigo) : '#6c757d';
                
                return {
                    color: color,
                    icon: iconoInfo,
                    descripcion: configuracion.descripcion,
                    codigo: configuracion.codigo,
                    campo: campo,
                    valor: valor
                };
            }
        }
        
        // Si no tiene el campo prioritario, buscar en otros campos
        for (const [nombreCampo, opciones] of Object.entries(window.estadosConfig)) {
            const valorCampo = cliente[nombreCampo];
            if (valorCampo) {
                // Buscar coincidencia case-insensitive
                const valorNormalizado = valorCampo.toString().toLowerCase();
                const configuracion = opciones[valorNormalizado];
                
                if (configuracion) {
                    const iconoInfo = window.iconosManager ? window.iconosManager.obtenerIcono(configuracion.codigo, 'emoji') : '📍';
                    const color = window.iconosManager ? window.iconosManager.obtenerColor(configuracion.codigo) : '#6c757d';
                    
                    return {
                        color: color,
                        icon: iconoInfo,
                        descripcion: configuracion.descripcion,
                        codigo: configuracion.codigo,
                        campo: nombreCampo,
                        valor: valorCampo
                    };
                }
            }
        }
        
        // Estilo por defecto
        return this.getEstiloPorDefecto();
    },
    
    // Estilo por defecto usando código
    getEstiloPorDefecto: function() {
        const defaultInfo = window.iconosManager ? window.iconosManager.obtenerIcono('DEFAULT', 'emoji') : '📍';
        const defaultColor = window.iconosManager ? window.iconosManager.obtenerColor('DEFAULT') : '#6c757d';
        
        return {
            color: defaultColor,
            icon: defaultInfo,
            descripcion: 'Sin categoría',
            codigo: 'DEFAULT',
            campo: 'default',
            valor: 'default'
        };
    },
    
    // Cambiar campo prioritario
    setCampoPrioritario: function(campo) {
        if (window.estadosConfig && window.estadosConfig[campo]) {
            this.campoPrioritario = campo;
            console.log(`🎨 Campo prioritario cambiado a: ${campo}`);
            return true;
        }
        console.warn(`⚠️ Campo ${campo} no encontrado en configuración de estados`);
        return false;
    },
    
    // Obtener todos los valores únicos de un campo
    obtenerValoresCampo: function(campo) {
        if (!window.estadosConfig || !window.estadosConfig[campo]) {
            return [];
        }
        return Object.keys(window.estadosConfig[campo]);
    },
    
    // Obtener estadísticas de estados basadas en datos actuales
    obtenerEstadisticas: function() {
        if (!window.clientesData || !window.estadosConfig) {
            console.warn('⚠️ clientesData o estadosConfig no disponible para estadísticas');
            return {};
        }
        
        console.log('📊 Calculando estadísticas para:', this.campoPrioritario);
        const stats = {};
        
        Object.keys(window.estadosConfig).forEach(campo => {
            stats[campo] = {};
            this.obtenerValoresCampo(campo).forEach(valor => {
                // Contar con comparación case-insensitive
                const count = window.clientesData.filter(cliente => {
                    const valorCliente = cliente[campo];
                    if (!valorCliente) return false;
                    return valorCliente.toString().toLowerCase() === valor.toLowerCase();
                }).length;
                stats[campo][valor] = count;
                console.log(`  ${valor}: ${count} clientes`);
            });
        });
        
        return stats;
    },
    
    // Obtener lista de campos disponibles para priorización
    obtenerCamposDisponibles: function() {
        if (!window.estadosConfig) return [];
        return Object.keys(window.estadosConfig);
    }
};

console.log('🎨 Estados-manager cargado (sistema de códigos)');