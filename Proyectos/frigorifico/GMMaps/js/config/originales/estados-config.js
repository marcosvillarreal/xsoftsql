// config/estados-config.js - Estados con códigos VFP-compatibles
window.estadosConfig = {
    // Configuraciones de estados por campo dinámico usando CÓDIGOS
    activo: {
        true: { codigo: 'ACTIVO', descripcion: 'Activo' },
        false: { codigo: 'INACTIVO', descripcion: 'Inactivo' }
    },
    estado_cuenta: {
        al_dia: { codigo: 'AL_DIA', descripcion: 'Al día' },
        con_deuda: { codigo: 'CON_DEUDA', descripcion: 'Con deuda' },
        moroso: { codigo: 'MOROSO', descripcion: 'Moroso' },
        bloqueado: { codigo: 'BLOQUEADO', descripcion: 'Bloqueado' }
    },
    categoria_cliente: {
        bronze: { codigo: 'BRONZE', descripcion: 'Bronze' },
        silver: { codigo: 'SILVER', descripcion: 'Silver' },
        gold: { codigo: 'GOLD', descripcion: 'Gold' },
        premium: { codigo: 'PREMIUM', descripcion: 'Premium' },
        vip: { codigo: 'VIP', descripcion: 'VIP' }
    },
    canal_venta: {
        online: { codigo: 'ONLINE', descripcion: 'Online' },
        presencial: { codigo: 'PRESENCIAL', descripcion: 'Presencial' },
        telefono: { codigo: 'TELEFONO', descripcion: 'Teléfono' },
        mixto: { codigo: 'MIXTO', descripcion: 'Mixto' },
        otros: { codigo: 'OTROS', descripcion: 'Otros' },
		minimercado: { codigo: 'MINIMERCADO', descripcion: 'Minimercado' },
    },
    zona_geografica: {
        norte: { codigo: 'NORTE', descripcion: 'Norte' },
        sur: { codigo: 'SUR', descripcion: 'Sur' },
        este: { codigo: 'ESTE', descripcion: 'Este' },
        oeste: { codigo: 'OESTE', descripcion: 'Oeste' },
        centro: { codigo: 'CENTRO', descripcion: 'Centro' }
    },
    tipo_negocio: {
        comercial: { codigo: 'COMERCIAL', descripcion: 'Comercial' },
        particular: { codigo: 'PARTICULAR', descripcion: 'Particular' },
        empresa: { codigo: 'EMPRESA', descripcion: 'Empresa' }
    }
};

console.log('⚙️ Estados-config cargado (códigos VFP-compatibles):', Object.keys(window.estadosConfig));