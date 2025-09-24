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
            opciones: ['almacen','almacen_y_desp','carnic_y_desp','cine','cotillon','est_servicio','kiosco','otros','panaderia','polleria','restaurant','terminal_omnibus','universidad','verd_y_desp','verduleria'],
            filtrable: true,
            buscable: true,
            mostrar_popup: true
        },
        categoria_cliente: {
            nombre: 'Categoría Cliente',
            tipo: 'select',
            icono_texto: 'star',
            opciones: ['categoria_a','categoria_b','categoria_d','categoria_e','categoria_f','categoria_g','kiosco_b','morosos','proximidad','sin_presupuesto'],
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
            opciones: ['a1__milpaterno','a2__indflrjarca','v1__hospcagl','v2__guiinapielb','v3__riosst_clara','v4__belgrano','v5__amr20centro','v6__ippvterminal'],
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
        },
        estado: {
            nombre: 'Estado',
            tipo: 'select',
            icono_texto: 'credit-card',
            opciones: ['ninguno','venta', 'no_venta','cerrado','negocio_no_encontrado','no_estaba_el_comprador','no_ternia_dinero'],
            filtrable: true,
            buscable: false,
            mostrar_popup: true
        }
    }
};

console.log('Campos-config cargado desde VFP:', Object.keys(window.camposConfig.dinamicos).length, 'campos');