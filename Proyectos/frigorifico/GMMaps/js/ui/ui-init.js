/**
 * GM SOLUTIONS - UI INITIALIZER v2.3.6
 * Inicializador centralizado de todos los módulos de UI
 * ======================================================
 */

(function(window) {
    'use strict';

    const UIController = {
        // === PROPIEDADES ===
        modulos: {
            SidebarController: null,
            ThemeController: null,
            StatsController: null,
            NotificationSystem: null,
            MapControls: null,
            ExportTools: null,
            KeyboardShortcuts: null
        },
        isInitialized: false,
        initStartTime: null,

        // === INICIALIZACIÓN PRINCIPAL ===
        init() {
            if (this.isInitialized) {
                console.warn('⚠️ UIController ya inicializado');
                return Promise.resolve();
            }

            this.initStartTime = performance.now();
            console.log('🚀 Iniciando UIController v2.3.6...');

            return new Promise((resolve, reject) => {
                try {
                    // Verificar dependencias principales
                    this.verificarDependencias();
                    
                    // Inicializar módulos en orden
                    this.inicializarModulos()
                        .then(() => {
                            this.configurarEventosGlobales();
                            this.mostrarMensajeBienvenida();
                            this.isInitialized = true;
                            
                            const tiempoTotal = (performance.now() - this.initStartTime).toFixed(2);
                            console.log(`✅ UIController inicializado en ${tiempoTotal}ms`);
                            
                            resolve();
                        })
                        .catch(reject);
                        
                } catch (error) {
                    console.error('❌ Error crítico en UIController:', error);
                    reject(error);
                }
            });
        },

        // === VERIFICAR DEPENDENCIAS ===
        verificarDependencias() {
            const dependenciasRequeridas = [
                'mapaGMSolutions',
                'clientesData',
                'camposConfig',
                'estadosConfig'
            ];

            const dependenciasFaltantes = [];

            dependenciasRequeridas.forEach(dep => {
                if (!window[dep]) {
                    dependenciasFaltantes.push(dep);
                }
            });

            if (dependenciasFaltantes.length > 0) {
                console.warn('⚠️ Dependencias faltantes:', dependenciasFaltantes);
                console.log('🔄 Esperando carga de dependencias...');
                
                // Intentar esperar las dependencias
                return this.esperarDependencias(dependenciasFaltantes, 5000);
            }

            console.log('✅ Todas las dependencias verificadas');
            return true;
        },

        // === ESPERAR DEPENDENCIAS ===
        esperarDependencias(dependencias, timeout = 5000) {
            return new Promise((resolve, reject) => {
                const inicio = Date.now();
                
                const verificar = setInterval(() => {
                    const faltantes = dependencias.filter(dep => !window[dep]);
                    
                    if (faltantes.length === 0) {
                        clearInterval(verificar);
                        console.log('✅ Dependencias cargadas');
                        resolve(true);
                    } else if (Date.now() - inicio > timeout) {
                        clearInterval(verificar);
                        console.error('❌ Timeout esperando dependencias:', faltantes);
                        reject(new Error(`Dependencias no cargadas: ${faltantes.join(', ')}`));
                    }
                }, 100);
            });
        },

        // === INICIALIZAR MÓDULOS ===
        async inicializarModulos() {
            const modulosOrdenados = [
                'NotificationSystem',  // Primero para que otros puedan usarlo
                'ThemeController',
                'SidebarController',
                'MapControls',
                'StatsController',
                'ExportTools',
                'KeyboardShortcuts'    // Último para que capture todos los atajos
            ];

            for (const nombreModulo of modulosOrdenados) {
                try {
                    await this.inicializarModulo(nombreModulo);
                } catch (error) {
                    console.error(`❌ Error inicializando ${nombreModulo}:`, error);
                    // Continuar con otros módulos aunque uno falle
                }
            }
        },

        // === INICIALIZAR MÓDULO INDIVIDUAL ===
        async inicializarModulo(nombreModulo) {
            if (!window[nombreModulo]) {
                console.warn(`⚠️ Módulo ${nombreModulo} no encontrado`);
                return false;
            }

            console.log(`📦 Inicializando ${nombreModulo}...`);
            
            try {
                // Guardar referencia
                this.modulos[nombreModulo] = window[nombreModulo];
                
                // Inicializar si tiene método init
                if (typeof window[nombreModulo].init === 'function') {
                    await window[nombreModulo].init();
                }
                
                return true;
            } catch (error) {
                console.error(`❌ Error en ${nombreModulo}:`, error);
                return false;
            }
        },

        // === CONFIGURAR EVENTOS GLOBALES ===
        configurarEventosGlobales() {
            // === Eventos de window ===
            window.addEventListener('resize', this.debounce(() => {
                this.handleResize();
            }, 250));

            // === Eventos de documento ===
            document.addEventListener('DOMContentLoaded', () => {
                this.onDOMReady();
            });

            // === Eventos personalizados ===
            window.addEventListener('clientesFiltrados', () => {
                this.onClientesFiltrados();
            });

            window.addEventListener('themeChanged', (e) => {
                this.onThemeChanged(e.detail);
            });

            window.addEventListener('sidebarToggled', (e) => {
                this.onSidebarToggled(e.detail);
            });

            // === Manejo de errores globales ===
            window.addEventListener('error', (e) => {
                this.handleError(e);
            });

            window.addEventListener('unhandledrejection', (e) => {
                this.handleRejection(e);
            });

            console.log('✅ Eventos globales configurados');
        },

        // === HANDLERS DE EVENTOS ===
        handleResize() {
            // Ajustar sidebar
            if (this.modulos.SidebarController) {
                this.modulos.SidebarController.ajustarSidebarResponsive();
            }
            
            // Redimensionar mapa
            if (window.map) {
                setTimeout(() => {
                    window.map.invalidateSize();
                }, 100);
            }
        },

        onDOMReady() {
            console.log('📄 DOM completamente cargado');
            
            // Re-verificar módulos si es necesario
            if (!this.isInitialized) {
                this.init();
            }
        },

        onClientesFiltrados() {
            console.log('🔍 Clientes filtrados - actualizando UI');
            
            // Actualizar estadísticas
            if (this.modulos.StatsController) {
                this.modulos.StatsController.actualizar();
            }
        },

        onThemeChanged(detail) {
            console.log(`🎨 Tema cambiado a: ${detail.tema}`);
            
            // Actualizar componentes que dependen del tema
            this.actualizarComponentesTema(detail.tema);
        },

        onSidebarToggled(detail) {
            console.log(`📱 Sidebar ${detail.isHidden ? 'oculto' : 'visible'}`);
            
            // Redimensionar mapa
            if (window.map) {
                setTimeout(() => {
                    window.map.invalidateSize();
                }, 300);
            }
        },

        handleError(evento) {
            console.error('❌ Error global:', evento.error);
            
            // Mostrar notificación si es un error crítico
            if (evento.error && this.modulos.NotificationSystem) {
                this.modulos.NotificationSystem.error(
                    'Error inesperado. Por favor, recarga la página.'
                );
            }
        },

        handleRejection(evento) {
            console.error('❌ Promesa rechazada:', evento.reason);
        },

        // === ACTUALIZAR COMPONENTES TEMA ===
        actualizarComponentesTema(tema) {
            // Actualizar meta theme-color
            const metaThemeColor = document.querySelector('meta[name="theme-color"]');
            if (metaThemeColor) {
                const colores = {
                    'base': '#1e40af',
                    'oscuro': '#0f172a'
                };
                metaThemeColor.content = colores[tema] || colores['base'];
            }

            // Actualizar favicon si existe versión oscura
            const favicon = document.querySelector('link[rel="icon"]');
            if (favicon && tema === 'oscuro') {
                // Cambiar a favicon oscuro si existe
                const faviconOscuro = favicon.href.replace('.png', '-dark.png');
                favicon.href = faviconOscuro;
            }
        },

        // === MOSTRAR MENSAJE BIENVENIDA ===
        mostrarMensajeBienvenida() {
            const hora = new Date().getHours();
            let saludo = 'Buenos días';
            
            if (hora >= 12 && hora < 20) {
                saludo = 'Buenas tardes';
            } else if (hora >= 20 || hora < 6) {
                saludo = 'Buenas noches';
            }

            const totalClientes = window.clientesData?.length || 0;
            const mensaje = `${saludo}! Sistema cargado con ${totalClientes} clientes`;

            if (this.modulos.NotificationSystem) {
                this.modulos.NotificationSystem.mostrar(mensaje, 'success', {
                    duracion: 4000
                });
            }

            console.log(`👋 ${mensaje}`);
        },

        // === FUNCIONES DE COMPATIBILIDAD ===
        configurarCompatibilidad() {
            // Mantener funciones globales por compatibilidad
            if (!window.resetearTodo) {
                window.resetearTodo = () => {
                    if (window.mapaGMSolutions) {
                        window.mapaGMSolutions.resetearFiltros();
                    }
                };
            }

            if (!window.showAllClients) {
                window.showAllClients = () => {
                    if (window.mapaGMSolutions) {
                        window.mapaGMSolutions.mostrarResultados([...window.clientesData]);
                    }
                };
            }

            if (!window.searchClient) {
                window.searchClient = () => {
                    console.log('🔍 Función de búsqueda llamada');
                };
            }

            console.log('✅ Funciones de compatibilidad configuradas');
        },

        // === UTILIDADES ===
        debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        },

        // === API PÚBLICA ===
        getModulo(nombre) {
            return this.modulos[nombre];
        },

        getModulos() {
            return { ...this.modulos };
        },

        isModuloActivo(nombre) {
            return this.modulos[nombre] && this.modulos[nombre].isInitialized;
        },

        reiniciar() {
            console.log('🔄 Reiniciando UIController...');
            
            // Limpiar estado
            this.isInitialized = false;
            
            // Reiniciar
            return this.init();
        },

        // === DESTRUIR ===
        destroy() {
            console.log('🗑️ Destruyendo UIController...');
            
            // Destruir cada módulo si tiene método destroy
            Object.values(this.modulos).forEach(modulo => {
                if (modulo && typeof modulo.destroy === 'function') {
                    modulo.destroy();
                }
            });
            
            // Limpiar referencias
            this.modulos = {};
            this.isInitialized = false;
            
            console.log('✅ UIController destruido');
        },

        // === INFORMACIÓN DEL SISTEMA ===
        getInfo() {
            return {
                version: 'v2.3.6',
                modulosActivos: Object.keys(this.modulos).filter(m => this.isModuloActivo(m)),
                tiempoEjecucion: this.initStartTime ? 
                    `${((performance.now() - this.initStartTime) / 1000).toFixed(2)}s` : 'N/A',
                totalClientes: window.clientesData?.length || 0,
                temaActual: this.modulos.ThemeController?.getTemaActual() || 'base'
            };
        }
    };

    // === AUTO-INICIALIZACIÓN ===
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            UIController.init();
        });
    } else {
        // DOM ya está listo
        setTimeout(() => UIController.init(), 100);
    }

    // === EXPORTAR MÓDULO ===
    window.UIController = UIController;
    
})(window);