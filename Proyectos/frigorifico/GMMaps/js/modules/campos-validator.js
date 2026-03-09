// modules/campos-validator.js - Solo lógica de validación de campos
window.camposValidator = {
    
    // Función para validar que un cliente tenga los campos mínimos
    validarCliente: function(cliente) {
        if (!window.camposConfig) {
            console.error('❌ camposConfig no disponible para validación');
            return cliente;
        }
        
        const clienteValidado = {};
        
        // Campos básicos con valores por defecto
        clienteValidado.num = cliente.num || 'SIN_ID';
        clienteValidado.coords = cliente.coords || [0, 0];
        clienteValidado.nombre = cliente.nombre || 'Cliente sin nombre';
        clienteValidado.direccion = cliente.direccion || 'Dirección no especificada';
        clienteValidado.activo = cliente.activo !== undefined ? cliente.activo : true;
        clienteValidado.fecha_alta = cliente.fecha_alta || 'N/A';
        clienteValidado.tipo_negocio = cliente.tipo_negocio || 'no especificado';
        
        // Campos dinámicos (mantener valor original o vacío)
        Object.keys(window.camposConfig.dinamicos).forEach(campo => {
            clienteValidado[campo] = cliente[campo] || '';
        });
        
        return clienteValidado;
    },
    
    // Validar estructura completa de datos
    validarEstructuraDatos: function(clientes) {
        if (!Array.isArray(clientes)) {
            console.error('❌ Los datos de clientes deben ser un array');
            return [];
        }
        
        const clientesValidados = clientes.map(cliente => this.validarCliente(cliente));
        
        console.log(`✅ ${clientesValidados.length} clientes validados correctamente`);
        return clientesValidados;
    },
    
    // Obtener campos configurados como filtrables
    obtenerCamposFiltrables: function() {
        if (!window.camposConfig) return [];
        
        return Object.entries(window.camposConfig.dinamicos)
            .filter(([campo, config]) => config.filtrable)
            .map(([campo, config]) => ({ campo, config }));
    },
    
    // Obtener campos configurados como buscables  
    obtenerCamposBuscables: function() {
        if (!window.camposConfig) return [];
        
        return Object.entries(window.camposConfig.dinamicos)
            .filter(([campo, config]) => config.buscable)
            .map(([campo, config]) => campo);
    },
    
    // Inicializar campos de búsqueda en configuración del mapa
    inicializarCamposBusqueda: function() {
        if (!window.mapaConfig || !window.camposConfig) return;
        
        window.mapaConfig.busqueda.campos_busqueda = this.obtenerCamposBuscables();
        
        console.log('🔍 Campos de búsqueda inicializados:', window.mapaConfig.busqueda.campos_busqueda);
    }
};

console.log('✅ Campos-validator cargado');