// config/campos-config.js - GENERADO DESDE VFP
window.camposConfig = {
    // Campos básicos (siempre requeridos)
    basicos: ['num', 'coords', 'nombre', 'direccion', 'activo'],
    
    // Campos dinámicos configurables
    dinamicos: {
        vendedor: {
            nombre: 'Vendedor',
            tipo: 'texto',
            icono_texto: 'user',
            filtrable: true,
            buscable: true,
            mostrar_popup: true
        },
        canal_venta: {
            nombre: 'Canal de Venta',
            tipo: 'select',
            icono_texto: 'dollar',
            opciones: ['Almacen_y_desp','Clubsoc_fomento','Minimercado','Otros'],
            filtrable: true,
            buscable: true,
            mostrar_popup: true
        },
        categoria_cliente: {
            nombre: 'Categoría Cliente',
            tipo: 'select',
            icono_texto: 'star',
            opciones: ['Clientes','Cta_cte_servicio'],
            filtrable: true,
            buscable: false,
            mostrar_popup: true
        },
        telefono: {
            nombre: 'Teléfono',
            tipo: 'texto',
            icono_texto: 'phone',
            filtrable: false,
            buscable: true,
            mostrar_popup: true
        },
        email: {
            nombre: 'Email',
            tipo: 'email',
            icono_texto: 'mail',
            filtrable: false,
            buscable: true,
            mostrar_popup: true
        },
        facturacion_anual: {
            nombre: 'Facturación Anual',
            tipo: 'numero',
            icono_texto: 'money',
            filtrable: false,
            buscable: false,
            mostrar_popup: true,
            formato: 'moneda'
        },
        zona_geografica: {
            nombre: 'Zona Geográfica',
            tipo: 'select',
            icono_texto: 'globe',
            opciones: ['Jueves_1_vrosas_whi','Jueves_2_centro_sude','Martes_1_centro_nort','Martes_2_norte','Martes_3_centro','Miecoles_3_espora','Miercoles_1_vmitre','Miercoles_2_aldea_ro','Sin_sector','Viernes_1_bordeux_ma','Viernes_2','Viernes_4'],
            filtrable: true,
            buscable: false,
            mostrar_popup: true
        },
        estado_cuenta: {
            nombre: 'Estado de Cuenta',
            tipo: 'select',
            icono_texto: 'credit-card',
            opciones: ['al_dia', 'con_deuda', 'moroso', 'bloqueado'],
            filtrable: false,
            buscable: false,
            mostrar_popup: true
        }
    }
};

console.log('Campos-config cargado desde VFP:', Object.keys(window.camposConfig.dinamicos).length, 'campos');