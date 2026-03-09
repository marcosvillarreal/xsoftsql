// config/campos-config-vfp.js - CONFIGURACIONES EDITABLES DESDE VFP
// Este archivo puede ser regenerado desde Visual FoxPro

window.camposConfigVFP = {
    // === FILTROS HABILITADOS ===
    // Cambiar true/false para mostrar/ocultar filtros
    filtros_habilitados: {
        vendedor: true,              // ← VFP puede cambiar a false
        canal_venta: true,           // ← VFP puede cambiar a false  
        categoria_cliente: true,     // ← VFP puede cambiar a false
        zona_geografica: true,       // ← VFP puede cambiar a false
        estado_cuenta: false,        // ← VFP puede cambiar a true
        telefono: false,             // ← VFP puede cambiar a true
        email: false                 // ← VFP puede cambiar a true
    },
    
    // === CAMPOS EN BÚSQUEDA ===
    // Cambiar true/false para incluir/excluir de búsqueda
    busqueda_habilitada: {
        vendedor: true,              // ← VFP puede cambiar
        canal_venta: true,           // ← VFP puede cambiar
        categoria_cliente: false,    // ← VFP puede cambiar
        zona_geografica: false,      // ← VFP puede cambiar
        estado_cuenta: false,        // ← VFP puede cambiar
        telefono: true,              // ← VFP puede cambiar
        email: true                  // ← VFP puede cambiar
    },
    
    // === CAMPOS EN POPUP ===
    // Cambiar true/false para mostrar/ocultar en popup de marcador
    popup_habilitado: {
        vendedor: true,              // ← VFP puede cambiar
        canal_venta: true,           // ← VFP puede cambiar
        categoria_cliente: true,     // ← VFP puede cambiar
        zona_geografica: true,       // ← VFP puede cambiar
        estado_cuenta: true,         // ← VFP puede cambiar
        telefono: true,              // ← VFP puede cambiar
        email: true,                 // ← VFP puede cambiar
        facturacion_anual: true      // ← VFP puede cambiar
    },
    
    // === CONFIGURACIÓN ESPECIAL ===
    configuracion: {
        campo_prioritario_inicial: 'categoria_cliente',  // ← VFP puede cambiar
        mostrar_leyenda: true,                           // ← VFP puede cambiar
        centrar_automatico: true,                        // ← VFP puede cambiar
        zoom_inicial: 13                                 // ← VFP puede cambiar
    }
};

// Aplicar configuraciones VFP automáticamente
if (window.camposConfig && window.camposConfigVFP) {
    // Aplicar filtros habilitados
    Object.entries(window.camposConfigVFP.filtros_habilitados).forEach(([campo, habilitado]) => {
        if (window.camposConfig.dinamicos[campo]) {
            window.camposConfig.dinamicos[campo].filtrable = habilitado;
        }
    });
    
    // Aplicar búsqueda habilitada
    Object.entries(window.camposConfigVFP.busqueda_habilitada).forEach(([campo, habilitado]) => {
        if (window.camposConfig.dinamicos[campo]) {
            window.camposConfig.dinamicos[campo].buscable = habilitado;
        }
    });
    
    // Aplicar popup habilitado
    Object.entries(window.camposConfigVFP.popup_habilitado).forEach(([campo, habilitado]) => {
        if (window.camposConfig.dinamicos[campo]) {
            window.camposConfig.dinamicos[campo].mostrar_popup = habilitado;
        }
    });
    
    console.log('⚙️ Configuraciones VFP aplicadas automáticamente');
} else {
    console.warn('⚠️ camposConfig no disponible, configuraciones VFP no aplicadas');
}

console.log('🎛️ Campos-config-VFP cargado');