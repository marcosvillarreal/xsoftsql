// js/filtros.js - Generación automática de filtros CORREGIDA
window.filtrosManager = {
    
    // Generar filtros automáticamente
    generarFiltros: function() {
        const filtersContainer = document.querySelector('.sidebar-content .filters');
        if (!filtersContainer) return;
        
        console.log('🔧 Generando filtros dinámicos...');
        
        // Limpiar filtros existentes dinámicos
        const filtrosDinamicos = filtersContainer.querySelectorAll('.filtro-dinamico');
        filtrosDinamicos.forEach(filtro => filtro.remove());
        
        // Generar filtros por cada campo configurable
        Object.entries(window.camposConfig.dinamicos).forEach(([campo, config]) => {
            if (config.filtrable) {
                this.crearGrupoFiltro(campo, config, filtersContainer);
            }
        });
    },
    
    // Crear un grupo de filtros
    crearGrupoFiltro: function(campo, config, container) {
        const grupoDiv = document.createElement('div');
        grupoDiv.className = 'filter-group filtro-dinamico';
        
        if (config.tipo === 'select') {
            // Filtros por opciones predefinidas
            grupoDiv.innerHTML = `
                <label>${window.iconosHelper.obtenerIconoCampo(config)} Por ${config.nombre}:</label>
                <div class="filter-buttons">
                    ${config.opciones.map(opcion => 
                        `<button class="filter-btn" onclick="filtrosManager.aplicarFiltroEspecifico('${campo}', '${opcion}', this)">${this.formatearOpcion(opcion)}</button>`
                    ).join('')}
                </div>
            `;
        } else if (config.tipo === 'texto') {
            // Filtros dinámicos por valores únicos en los datos
            const valoresUnicos = this.obtenerValoresUnicos(campo);
            if (valoresUnicos.length > 0) {
                grupoDiv.innerHTML = `
                    <label>${window.iconosHelper.obtenerIconoCampo(config)} Por ${config.nombre}:</label>
                    <div class="filter-buttons" id="${campo}-filters">
                        ${valoresUnicos.map(valor => 
                            `<button class="filter-btn" onclick="filtrosManager.aplicarFiltroEspecifico('${campo}', '${valor}', this)">${valor}</button>`
                        ).join('')}
                    </div>
                `;
            }
        }
        
        container.appendChild(grupoDiv);
    },
    
    // Aplicar filtro específico (función corregida)
    aplicarFiltroEspecifico: function(campo, valor, boton) {
        console.log(`🔍 Aplicando filtro: ${campo} = ${valor}`);
        
        // Limpiar otros botones activos
        document.querySelectorAll('.filter-btn.active').forEach(btn => {
            if (btn !== boton) btn.classList.remove('active');
        });
        
        // Marcar botón como activo
        boton.classList.toggle('active');
        
        let clientesFiltrados;
        
        if (boton.classList.contains('active')) {
            // Aplicar filtro
            clientesFiltrados = window.clientesData.filter(cliente => {
                const valorCliente = cliente[campo];
                if (!valorCliente) return false;
                
                // Comparación directa sin sanitizar
                return valorCliente.toString().toLowerCase() === valor.toString().toLowerCase();
            });
        } else {
            // Mostrar todos si se desactiva el filtro
            clientesFiltrados = [...window.clientesData];
        }
        
        console.log(`📊 Resultados filtro ${campo}:`, clientesFiltrados.length);
        
        // Actualizar vista
        if (window.mapaGMSolutions) {
            window.mapaGMSolutions.mostrarResultados(clientesFiltrados);
        }
    },
    
    // Obtener valores únicos de un campo
    obtenerValoresUnicos: function(campo) {
        if (!window.clientesData) return [];
        
        return [...new Set(window.clientesData
            .map(cliente => cliente[campo])
            .filter(valor => valor && valor.toString().trim() !== '')
        )];
    },
    
    // Formatear opción para mostrar
    formatearOpcion: function(opcion) {
        return opcion.charAt(0).toUpperCase() + opcion.slice(1).replace(/_/g, ' ');
    },
    
    // Sanitizar valor para usar como ID (ya no se usa para comparaciones)
    sanitizarValor: function(valor) {
        return valor.toString().replace(/\s+/g, '_').replace(/[^\w-]/g, '');
    },
    
    // Aplicar filtro dinámico (función legacy mantenida para compatibilidad)
    aplicarFiltro: function(tipoFiltro, valorFiltro) {
        console.log(`🔍 Aplicando filtro legacy: ${tipoFiltro} = ${valorFiltro}`);
        
        // Si es un filtro de campo dinámico
        if (tipoFiltro.includes('_')) {
            const [campo, valor] = tipoFiltro.split('_', 2);
            
            if (window.camposConfig.dinamicos[campo]) {
                return window.clientesData.filter(cliente => {
                    const valorCliente = cliente[campo];
                    if (!valorCliente) return false;
                    
                    // Comparación mejorada
                    return valorCliente.toString().toLowerCase() === valor.toString().toLowerCase();
                });
            }
        }
        
        // Si no es filtro dinámico, devolver null para que lo maneje la lógica original
        return null;
    }
};