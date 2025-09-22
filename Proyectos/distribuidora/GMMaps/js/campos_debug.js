// js/campos.js - Configuración dinámica de campos - v2.3.1
window.camposConfig = {
    // Campos básicos (siempre requeridos)
    basicos: ['num', 'coords', 'nombre', 'direccion', 'activo'],
    
    // Campos dinámicos configurables
    dinamicos: {
        vendedor: {
            nombre: 'Vendedor',
            tipo: 'texto',
            icono: '👤',
            filtrable: true,
            buscable: true,
            mostrar_popup: true
        },
        canal_venta: {
            nombre: 'Canal de Venta',
            tipo: 'select',
            icono: '💰',
            opciones: ['online', 'presencial', 'telefono', 'mixto'],
            filtrable: true,
            buscable: true,
            mostrar_popup: true
        },
        categoria_cliente: {
            nombre: 'Categoría Cliente',
            tipo: 'select',
            icono: '⭐',
            opciones: ['bronze', 'silver', 'gold', 'premium', 'vip'],
            filtrable: true,
            buscable: false,
            mostrar_popup: true
        },
        telefono: {
            nombre: 'Teléfono',
            tipo: 'texto',
            icono: '📞',
            filtrable: false,
            buscable: true,
            mostrar_popup: true
        },
        email: {
            nombre: 'Email',
            tipo: 'email',
            icono: '✉️',
            filtrable: false,
            buscable: true,
            mostrar_popup: true
        },
        facturacion_anual: {
            nombre: 'Facturación Anual',
            tipo: 'numero',
            icono: '💵',
            filtrable: false,
            buscable: false,
            mostrar_popup: true,
            formato: 'moneda'
        },
        zona_geografica: {
            nombre: 'Zona Geográfica',
            tipo: 'select',
            icono: '🌍',
            opciones: ['norte', 'sur', 'este', 'oeste', 'centro'],
            filtrable: true,
            buscable: false,
            mostrar_popup: true
        },
        estado_cuenta: {
            nombre: 'Estado de Cuenta',
            tipo: 'select',
            icono: '💳',
            opciones: ['al_dia', 'con_deuda', 'moroso', 'bloqueado'],
            filtrable: false,           // ← CONFIRMADO: FALSE
            buscable: false,
            mostrar_popup: true         // Sigue apareciendo en popups
        }
    },
    
    // Función para validar que un cliente tenga los campos mínimos
    validarCliente: function(cliente) {
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
        Object.keys(this.dinamicos).forEach(campo => {
            clienteValidado[campo] = cliente[campo] || '';
        });
        
        return clienteValidado;
    }
};

// Log para debugging
console.log('📋 Campos configurados - v2.3.1:', {
    estado_cuenta_filtrable: window.camposConfig.dinamicos.estado_cuenta.filtrable,
    campos_filtrables: Object.entries(window.camposConfig.dinamicos)
        .filter(([campo, config]) => config.filtrable)
        .map(([campo, config]) => campo)
});