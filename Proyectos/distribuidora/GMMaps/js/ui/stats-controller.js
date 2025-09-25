/**
 * GM SOLUTIONS - STATS CONTROLLER v2.3.6
 * Sistema de estadísticas dinámicas y visualización
 * =================================================
 */

(function(window) {
    'use strict';

    const StatsController = {
        // === PROPIEDADES ===
        contenedor: null,
        campoActivo: null,
        datosEstadisticas: {},
        isInitialized: false,
        
        // === INICIALIZACIÓN ===
        init() {
            if (this.isInitialized) return;
            
            this.contenedor = document.querySelector('.stats-overlay') || 
                             document.querySelector('.stats-container');
            
            if (this.contenedor) {
                this.configurarEventListeners();
                this.isInitialized = true;
                console.log('✅ StatsController inicializado');
                
                // Actualizar estadísticas iniciales
                setTimeout(() => this.actualizar(), 500);
            }
        },

        // === ACTUALIZAR ESTADÍSTICAS ===
        actualizar(campoPersonalizado = null) {
            if (!window.mapaGMSolutions || !window.clientesData) {
                console.warn('⚠️ Datos no disponibles para estadísticas');
                return;
            }
            
            // Determinar campo activo
            const selectorCampo = document.getElementById('campo-prioritario');
            const campo = campoPersonalizado || 
                         (selectorCampo ? selectorCampo.value : null) || 
                         this.campoActivo || 
                         'categoria_cliente';
            
            this.campoActivo = campo;
            
            // Actualizar título
            this.actualizarTitulo(campo);
            
            // Calcular estadísticas
            const estadisticas = this.calcularEstadisticas(campo);
            
            // Renderizar estadísticas
            this.renderizarEstadisticas(estadisticas);
            
            // Actualizar contadores globales
            this.actualizarContadores();
            
            console.log(`📊 Estadísticas actualizadas para: ${campo}`, estadisticas);
        },

        // === CALCULAR ESTADÍSTICAS ===
        calcularEstadisticas(campo) {
            const totalesPorValor = {};
            const clientesVisibles = window.mapaGMSolutions.clientesFiltrados || window.clientesData;
            
            // Contar por cada valor único
            clientesVisibles.forEach(cliente => {
                const valor = cliente[campo];
                if (valor !== null && valor !== undefined) {
                    const valorFormateado = this.formatearValor(valor);
                    totalesPorValor[valorFormateado] = (totalesPorValor[valorFormateado] || 0) + 1;
                }
            });
            
            // Ordenar por cantidad (mayor a menor)
            const estadisticasOrdenadas = Object.entries(totalesPorValor)
                .sort(([,a], [,b]) => b - a)
                .map(([valor, cantidad]) => ({
                    valor,
                    cantidad,
                    porcentaje: ((cantidad / clientesVisibles.length) * 100).toFixed(1),
                    color: this.obtenerColor(campo, valor)
                }));
            
            this.datosEstadisticas = {
                campo,
                total: clientesVisibles.length,
                totalOriginal: window.clientesData.length,
                valores: estadisticasOrdenadas
            };
            
            return this.datosEstadisticas;
        },

        // === FORMATEAR VALOR ===
        formatearValor(valor) {
            if (!valor) return 'Sin definir';
            
            return valor.toString()
                .replace(/_/g, ' ')
                .split(' ')
                .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
                .join(' ');
        },

        // === OBTENER COLOR ===
        obtenerColor(campo, valor) {
            // Intentar obtener color de configuración existente
            if (window.estadosConfig && window.estadosConfig[campo]) {
                const estados = window.estadosConfig[campo];
                const valorOriginal = valor.toLowerCase().replace(/\s+/g, '_');
                
                if (estados[valorOriginal] && estados[valorOriginal].color) {
                    return estados[valorOriginal].color;
                }
            }
            
            // Paleta de colores por defecto mejorada
            const paletaColores = [
                '#3b82f6', // Azul
                '#10b981', // Verde
                '#f59e0b', // Amarillo
                '#ef4444', // Rojo
                '#8b5cf6', // Púrpura
                '#06b6d4', // Cyan
                '#84cc16', // Lima
                '#f97316', // Naranja
                '#ec4899', // Rosa
                '#6366f1', // Índigo
                '#14b8a6', // Teal
                '#a855f7'  // Violeta
            ];
            
            // Generar índice basado en el hash del valor
            const hash = valor.split('').reduce((a, b) => {
                return ((a << 5) - a) + b.charCodeAt(0);
            }, 0);
            
            return paletaColores[Math.abs(hash) % paletaColores.length];
        },

        // === ACTUALIZAR TÍTULO ===
        actualizarTitulo(campo) {
            const tituloElement = document.getElementById('stats-field-name') || 
                                 document.querySelector('.stats-title span');
            
            if (!tituloElement) return;
            
            const configCampo = window.camposConfig?.dinamicos[campo];
            const nombreCampo = configCampo ? configCampo.nombre : this.formatearValor(campo);
            
            tituloElement.textContent = `Totales por ${nombreCampo}`;
        },

        // === RENDERIZAR ESTADÍSTICAS ===
        renderizarEstadisticas(estadisticas) {
            const contenedorStats = document.getElementById('stats-breakdown') || 
                                   document.querySelector('.stats-breakdown');
            
            if (!contenedorStats) return;
            
            // Limpiar contenedor
            contenedorStats.innerHTML = '';
            
            // Si no hay valores, mostrar mensaje
            if (!estadisticas.valores || estadisticas.valores.length === 0) {
                contenedorStats.innerHTML = `
                    <div class="stat-empty">
                        <i class="fas fa-chart-bar"></i>
                        <span>Sin datos disponibles</span>
                    </div>
                `;
                return;
            }
            
            // Crear elementos para cada valor
            estadisticas.valores.forEach((stat, index) => {
                const elemento = this.crearElementoEstadistica(stat, index);
                contenedorStats.appendChild(elemento);
            });
            
            // Agregar resumen si hay más de 5 valores
            if (estadisticas.valores.length > 5) {
                const resumen = document.createElement('div');
                resumen.className = 'stat-summary';
                resumen.innerHTML = `
                    <small>Mostrando ${estadisticas.valores.length} categorías</small>
                `;
                contenedorStats.appendChild(resumen);
            }
        },

        // === CREAR ELEMENTO ESTADÍSTICA ===
        crearElementoEstadistica(stat, index) {
            const div = document.createElement('div');
            div.className = 'stat-breakdown-item';
            div.style.animationDelay = `${index * 50}ms`;
            
            // Crear barra de progreso visual
            const porcentajeVisual = Math.min(stat.porcentaje, 100);
            
            div.innerHTML = `
                <div class="stat-breakdown-header">
                    <div class="stat-breakdown-indicator" style="background: ${stat.color}"></div>
                    <span class="stat-breakdown-label">${stat.valor}</span>
                    <span class="stat-breakdown-count">${stat.cantidad}</span>
                </div>
                <div class="stat-breakdown-bar">
                    <div class="stat-breakdown-progress" 
                         style="width: ${porcentajeVisual}%; background: ${stat.color}; opacity: 0.3">
                    </div>
                    <span class="stat-breakdown-percentage">${stat.porcentaje}%</span>
                </div>
            `;
            
            // Agregar interactividad
            div.addEventListener('click', () => {
                this.filtrarPorValor(this.campoActivo, stat.valor);
            });
            
            div.addEventListener('mouseenter', () => {
                div.style.transform = 'translateX(5px)';
            });
            
            div.addEventListener('mouseleave', () => {
                div.style.transform = 'translateX(0)';
            });
            
            return div;
        },

        // === FILTRAR POR VALOR ===
        filtrarPorValor(campo, valor) {
            console.log(`🔍 Filtrando por ${campo}: ${valor}`);
            
            // Buscar y activar el filtro correspondiente
            const valorNormalizado = valor.toLowerCase().replace(/\s+/g, '_');
            
            // Intentar encontrar el botón de filtro
            const botonesFiltro = document.querySelectorAll('.filter-btn');
            botonesFiltro.forEach(btn => {
                const btnTexto = btn.textContent.toLowerCase().replace(/\s+/g, '_');
                if (btnTexto === valorNormalizado) {
                    btn.click();
                }
            });
            
            // Notificar el filtrado
            if (window.NotificationSystem) {
                window.NotificationSystem.mostrar(
                    `Filtrado por: ${valor}`,
                    'info'
                );
            }
        },

        // === ACTUALIZAR CONTADORES ===
        actualizarContadores() {
            const clientesVisibles = window.mapaGMSolutions?.clientesFiltrados?.length || 0;
            const totalClientes = window.clientesData?.length || 0;
            
            // Actualizar todos los contadores en la página
            document.querySelectorAll('.client-count').forEach(el => {
                el.textContent = clientesVisibles;
            });
            
            document.querySelectorAll('.total-count').forEach(el => {
                el.textContent = totalClientes;
            });
            
            // Actualizar título si están mostrando filtrados
            if (clientesVisibles < totalClientes) {
                this.mostrarIndicadorFiltrado(clientesVisibles, totalClientes);
            }
        },

        // === MOSTRAR INDICADOR FILTRADO ===
        mostrarIndicadorFiltrado(mostrando, total) {
            const porcentaje = ((mostrando / total) * 100).toFixed(0);
            
            // Actualizar badge si existe
            let badge = document.querySelector('.filter-indicator');
            if (!badge && this.contenedor) {
                badge = document.createElement('div');
                badge.className = 'filter-indicator';
                badge.style.cssText = `
                    background: #f59e0b;
                    color: white;
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 11px;
                    font-weight: 600;
                    margin-top: 10px;
                    text-align: center;
                `;
                this.contenedor.appendChild(badge);
            }
            
            if (badge) {
                badge.textContent = `Mostrando ${porcentaje}% del total`;
            }
        },

        // === EVENT LISTENERS ===
        configurarEventListeners() {
            // Escuchar cambios en el campo prioritario
            document.addEventListener('change', (e) => {
                if (e.target.id === 'campo-prioritario') {
                    setTimeout(() => this.actualizar(e.target.value), 100);
                }
            });
            
            // Escuchar clicks en filtros
            document.addEventListener('click', (e) => {
                if (e.target.classList.contains('filter-btn')) {
                    setTimeout(() => this.actualizar(), 100);
                }
            });
            
            // Escuchar eventos personalizados
            window.addEventListener('clientesFiltrados', () => {
                this.actualizar();
            });
            
            window.addEventListener('filtrosReset', () => {
                this.actualizar();
            });
        },

        // === EXPORTAR ESTADÍSTICAS ===
        exportarEstadisticas() {
            if (!this.datosEstadisticas.valores) return null;
            
            const csv = [
                ['Valor', 'Cantidad', 'Porcentaje'],
                ...this.datosEstadisticas.valores.map(v => [
                    v.valor,
                    v.cantidad,
                    v.porcentaje + '%'
                ])
            ].map(row => row.join(',')).join('\n');
            
            return {
                csv,
                json: JSON.stringify(this.datosEstadisticas, null, 2),
                datos: this.datosEstadisticas
            };
        },

        // === API PÚBLICA ===
        getDatosEstadisticas() {
            return this.datosEstadisticas;
        },

        getCampoActivo() {
            return this.campoActivo;
        },

        setCampoActivo(campo) {
            this.campoActivo = campo;
            this.actualizar(campo);
        }
    };

    // === EXPORTAR FUNCIONES GLOBALES (compatibilidad) ===
    window.actualizarEstadisticasPorFiltro = (campo) => StatsController.actualizar(campo);
    window.formatearValorEstadistica = (valor) => StatsController.formatearValor(valor);
    window.obtenerColorPorValor = (campo, valor) => StatsController.obtenerColor(campo, valor);
    
    // === EXPORTAR MÓDULO ===
    window.StatsController = StatsController;
    
})(window);