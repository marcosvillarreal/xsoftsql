// config/campos-config-vfp.js - GENERADO DESDE VFP
window.camposConfigVFP = {
    // === FILTROS HABILITADOS ===
    filtros_habilitados: {
        vendedor: true,
        canal_venta: true,
        categoria_cliente: true,
        zona_geografica: true,
        estado_cuenta: false,
        telefono: false,
        email: false,
        activo: true
    },
    
    // === CAMPOS EN BÚSQUEDA ===
    busqueda_habilitada: {
        vendedor: true,
        canal_venta: true,
        categoria_cliente: false,
        zona_geografica: false,
        estado_cuenta: false,
        telefono: true,
        email: true,
        activo: true
    },
    
    // === CAMPOS EN POPUP ===
    popup_habilitado: {
        vendedor: true,
        canal_venta: true,
        categoria_cliente: true,
        zona_geografica: true,
        estado_cuenta: true,
        telefono: true,
        email: true,
        facturacion_anual: true
    },
    
    // === CONFIGURACIÓN ESPECIAL ===
    configuracion: {
        campo_prioritario_inicial: 'categoria_cliente',
        mostrar_leyenda: true,
        centrar_automatico: true,
        zoom_inicial: 13
    }
};

// Aplicar configuraciones automáticamente
if (window.camposConfig && window.camposConfigVFP) {
    Object.entries(window.camposConfigVFP.filtros_habilitados).forEach(([campo, habilitado]) => {
        if (window.camposConfig.dinamicos[campo]) {
            window.camposConfig.dinamicos[campo].filtrable = habilitado;
        }
    });
    
    Object.entries(window.camposConfigVFP.busqueda_habilitada).forEach(([campo, habilitado]) => {
        if (window.camposConfig.dinamicos[campo]) {
            window.camposConfig.dinamicos[campo].buscable = habilitado;
        }
    });
    
    Object.entries(window.camposConfigVFP.popup_habilitado).forEach(([campo, habilitado]) => {
        if (window.camposConfig.dinamicos[campo]) {
            window.camposConfig.dinamicos[campo].mostrar_popup = habilitado;
        }
    });
    
    console.log('⚙️ Configuraciones VFP aplicadas:', new Date().toLocaleString());
}

console.log('🎛️ Campos-config-VFP cargado desde VFP');