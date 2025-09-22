// js/busqueda.js - Búsqueda dinámica por campos configurados
window.busquedaManager = {
    
    // Realizar búsqueda en campos configurados
    buscar: function(termino) {
        if (!termino || termino.trim() === '') {
            return [...window.clientesData];
        }
        
        const terminoLower = termino.toLowerCase();
        console.log(`🔍 Buscando: "${termino}"`);
        
        return window.clientesData.filter(cliente => {
            // Búsqueda en campos básicos
            if (cliente.nombre && cliente.nombre.toLowerCase().includes(terminoLower)) return true;
            if (cliente.num && cliente.num.toString().includes(terminoLower)) return true;
            if (cliente.direccion && cliente.direccion.toLowerCase().includes(terminoLower)) return true;
            
            // Búsqueda en campos dinámicos configurados como buscables
            return Object.entries(window.camposConfig.dinamicos).some(([campo, config]) => {
                if (!config.buscable) return false;
                
                const valor = cliente[campo];
                if (!valor) return false;
                
                return valor.toString().toLowerCase().includes(terminoLower);
            });
        });
    },
    
    // Actualizar placeholder del input de búsqueda
    actualizarPlaceholder: function() {
        const searchInput = document.getElementById('client-search');
        if (searchInput && window.mapaConfig) {
            searchInput.placeholder = window.mapaConfig.busqueda.placeholder;
        }
        
        // También actualizar el input de la barra superior
        const searchInputTop = document.getElementById('search-client');
        if (searchInputTop) {
            searchInputTop.placeholder = 'Buscar cliente...';
        }
    }
};