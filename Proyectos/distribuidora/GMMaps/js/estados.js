// js/estados.js - Manejo dinámico de estados de cliente
window.estadosManager = {
    
    // Configuración de estados por campo dinámico
    configuraciones: {
        activo: {
            true: { color: '#28a745', icon: '✅', descripcion: 'Activo' },
            false: { color: '#dc3545', icon: '❌', descripcion: 'Inactivo' }
        },
        estado_cuenta: {
            al_dia: { color: '#28a745', icon: '💚', descripcion: 'Al día' },
            con_deuda: { color: '#ffc107', icon: '⚠️', descripcion: 'Con deuda' },
            moroso: { color: '#fd7e14', icon: '⏰', descripcion: 'Moroso' },
            bloqueado: { color: '#dc3545', icon: '🚫', descripcion: 'Bloqueado' }
        },
        categoria_cliente: {
            bronze: { color: '#cd7f32', icon: '🥉', descripcion: 'Bronze' },
            silver: { color: '#c0c0c0', icon: '🥈', descripcion: 'Silver' },
            gold: { color: '#ffd700', icon: '🥇', descripcion: 'Gold' },
            premium: { color: '#9932cc', icon: '💎', descripcion: 'Premium' },
            vip: { color: '#ff1493', icon: '👑', descripcion: 'VIP' }
        },
        canal_venta: {
            online: { color: '#007bff', icon: '💻', descripcion: 'Online' },
            presencial: { color: '#17a2b8', icon: '🏪', descripcion: 'Presencial' },
            telefono: { color: '#6c757d', icon: '📞', descripcion: 'Teléfono' },
            mixto: { color: '#6f42c1', icon: '🔄', descripcion: 'Mixto' }
        },
        zona_geografica: {
            norte: { color: '#ff6b6b', icon: '⬆️', descripcion: 'Norte' },
            sur: { color: '#4ecdc4', icon: '⬇️', descripcion: 'Sur' },
            este: { color: '#45b7d1', icon: '➡️', descripcion: 'Este' },
            oeste: { color: '#f9ca24', icon: '⬅️', descripcion: 'Oeste' },
            centro: { color: '#6c5ce7', icon: '🎯', descripcion: 'Centro' }
        }
    },
    
    // Campo prioritario para determinar el estilo del marcador
    campoPrioritario: 'categoria_cliente',
    
    // Obtener configuración de estilo para un cliente
    obtenerEstilo: function(cliente) {
        // Intentar por campo prioritario primero
        let campo = this.campoPrioritario;
        let valor = cliente[campo];
        
        if (valor && this.configuraciones[campo] && this.configuraciones[campo][valor]) {
            return {
                ...this.configuraciones[campo][valor],
                campo: campo,
                valor: valor
            };
        }
        
        // Si no tiene el campo prioritario, buscar en otros campos
        for (const [nombreCampo, opciones] of Object.entries(this.configuraciones)) {
            const valorCampo = cliente[nombreCampo];
            if (valorCampo && opciones[valorCampo]) {
                return {
                    ...opciones[valorCampo],
                    campo: nombreCampo,
                    valor: valorCampo
                };
            }
        }
        
        // Estilo por defecto
        return {
            color: '#6c757d',
            icon: '📍',
            descripcion: 'Sin categoría',
            campo: 'default',
            valor: 'default'
        };
    },
    
    // Cambiar campo prioritario
    setCampoPrioritario: function(campo) {
        if (this.configuraciones[campo]) {
            this.campoPrioritario = campo;
            console.log(`🎨 Campo prioritario cambiado a: ${campo}`);
        }
    },
    
    // Obtener todos los valores únicos de un campo
    obtenerValoresCampo: function(campo) {
        return Object.keys(this.configuraciones[campo] || {});
    },
    
    // Obtener estadísticas de estados
    obtenerEstadisticas: function() {
        if (!window.clientesData) return {};
        
        const stats = {};
        
        Object.keys(this.configuraciones).forEach(campo => {
            stats[campo] = {};
            this.obtenerValoresCampo(campo).forEach(valor => {
                const count = window.clientesData.filter(cliente => cliente[campo] === valor).length;
                stats[campo][valor] = count;
            });
        });
        
        return stats;
    }
};