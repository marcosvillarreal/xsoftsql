/**
 * GM SOLUTIONS - MAP CONTROLS v2.3.6
 * Controles y herramientas del mapa
 * ====================================
 */

(function(window) {
    'use strict';

    const MapControls = {
        // === PROPIEDADES ===
        botonCentrar: null,
        isInitialized: false,
        centroOriginal: { lat: -38.416097, lng: -63.616672 }, // Argentina por defecto
        zoomOriginal: 5,

        // === INICIALIZACIÓN ===
        init() {
            if (this.isInitialized) return;
            
            this.crearBotonCentrarDinamico();
            this.configurarEventListeners();
            this.isInitialized = true;
            
            console.log('✅ MapControls inicializado');
        },

        // === CREAR BOTÓN CENTRAR DINÁMICO ===
        crearBotonCentrarDinamico() {
            // Verificar si ya existe
            if (document.querySelector('.center-map-btn')) {
                this.botonCentrar = document.querySelector('.center-map-btn');
                return;
            }
            
            // Crear botón
            const mapContainer = document.querySelector('.map-container');
            if (!mapContainer) return;
            
            this.botonCentrar = document.createElement('button');
            this.botonCentrar.className = 'center-map-btn';
            this.botonCentrar.innerHTML = '<i class="fas fa-crosshairs"></i>';
            this.botonCentrar.title = 'Centrar Dinámico';
            
            // Estilos del botón - posicionado cerca del zoom (leaflet-control-zoom)
            this.botonCentrar.style.cssText = `
                position: absolute;
                top: 80px;
                left: 10px;
                background: white;
                border: 2px solid #3b82f6;
                color: #3b82f6;
                padding: 12px;
                border-radius: 50%;
                cursor: pointer;
                font-size: 18px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                z-index: 1000;
                transition: all 0.3s ease;
                width: 44px;
                height: 44px;
                display: flex;
                align-items: center;
                justify-content: center;
            `;
            
            // Agregar tooltip
            this.agregarTooltip(this.botonCentrar);
            
            // Agregar al contenedor del mapa
            mapContainer.appendChild(this.botonCentrar);
            
            // Evento click
            this.botonCentrar.addEventListener('click', () => this.centrarMapa());
        },

        // === AGREGAR TOOLTIP ===
        agregarTooltip(elemento) {
            // Crear tooltip
            const tooltip = document.createElement('div');
            tooltip.className = 'map-control-tooltip';
            tooltip.textContent = 'Centrar Dinámico';
            tooltip.style.cssText = `
                position: absolute;
                left: 50px;
                top: 50%;
                transform: translateY(-50%);
                background: rgba(0,0,0,0.8);
                color: white;
                padding: 6px 10px;
                border-radius: 4px;
                font-size: 12px;
                white-space: nowrap;
                opacity: 0;
                visibility: hidden;
                transition: all 0.3s ease;
                pointer-events: none;
            `;
            
            elemento.appendChild(tooltip);
            
            // Mostrar/ocultar en hover
            elemento.addEventListener('mouseenter', () => {
                tooltip.style.opacity = '1';
                tooltip.style.visibility = 'visible';
            });
            
            elemento.addEventListener('mouseleave', () => {
                tooltip.style.opacity = '0';
                tooltip.style.visibility = 'hidden';
            });
        },

        // === CENTRAR MAPA ===
        centrarMapa() {
            if (!window.mapaGMSolutions || !window.mapaGMSolutions.map) {
                console.error('❌ Mapa no disponible');
                this.mostrarError('Mapa no disponible');
                return false;
            }
            
            try {
                // Intentar centrar en clientes visibles
                const exito = this.centrarEnClientesVisibles();
                
                if (exito) {
                    this.mostrarFeedbackVisual('success');
                    console.log('✅ Mapa centrado en clientes visibles');
                } else {
                    // Si no hay clientes, centrar en posición original
                    this.centrarEnPosicionOriginal();
                    this.mostrarFeedbackVisual('warning');
                    console.log('⚠️ Mapa centrado en posición por defecto');
                }
                
                return true;
            } catch (error) {
                console.error('❌ Error al centrar mapa:', error);
                this.mostrarError('Error al centrar el mapa');
                return false;
            }
        },

        // === CENTRAR EN CLIENTES VISIBLES ===
        centrarEnClientesVisibles() {
            if (!window.mapaGMSolutions || !window.mapaGMSolutions.map) return false;
            
            const clientesVisibles = window.mapaGMSolutions.clientesFiltrados || window.clientesData;
            
            if (!clientesVisibles || clientesVisibles.length === 0) {
                return false;
            }
            
            // Obtener bounds de todos los clientes visibles
            const bounds = L.latLngBounds();
            let clientesConCoordenadas = 0;
            
            clientesVisibles.forEach(cliente => {
                if (cliente.latitud && cliente.longitud) {
                    bounds.extend([cliente.latitud, cliente.longitud]);
                    clientesConCoordenadas++;
                }
            });
            
            // Si hay clientes con coordenadas, ajustar vista
            if (clientesConCoordenadas > 0) {
                if (clientesConCoordenadas === 1) {
                    // Si solo hay un cliente, centrar con zoom fijo
                    const centro = bounds.getCenter();
                    window.mapaGMSolutions.map.setView(centro, 15);
                } else {
                    // Si hay múltiples clientes, ajustar bounds
                    window.mapaGMSolutions.map.fitBounds(bounds, {
                        padding: [50, 50],
                        maxZoom: 16
                    });
                }
                
                // Notificar
                if (window.NotificationSystem) {
                    window.NotificationSystem.mostrar(
                        `Centrado en ${clientesConCoordenadas} cliente${clientesConCoordenadas > 1 ? 's' : ''}`,
                        'success'
                    );
                }
                
                return true;
            }
            
            return false;
        },

        // === CENTRAR EN POSICIÓN ORIGINAL ===
        centrarEnPosicionOriginal() {
            if (!window.mapaGMSolutions || !window.mapaGMSolutions.map) return;
            
            // Usar configuración del mapa si existe
            const config = window.mapaConfig || {};
            const lat = config.center?.lat || this.centroOriginal.lat;
            const lng = config.center?.lng || this.centroOriginal.lng;
            const zoom = config.zoom || this.zoomOriginal;
            
            window.mapaGMSolutions.map.setView([lat, lng], zoom);
            
            // Notificar
            if (window.NotificationSystem) {
                window.NotificationSystem.mostrar(
                    'Mapa centrado en posición inicial',
                    'info'
                );
            }
        },

        // === RESETEAR VISTA ===
        resetearVista() {
            this.centrarEnPosicionOriginal();
            
            // Limpiar filtros si existen
            if (window.mapaGMSolutions && window.mapaGMSolutions.resetearFiltros) {
                window.mapaGMSolutions.resetearFiltros();
            }
            
            this.mostrarFeedbackVisual('info');
            console.log('🔄 Vista reseteada');
        },

        // === FEEDBACK VISUAL ===
        mostrarFeedbackVisual(tipo = 'success') {
            if (!this.botonCentrar) return;
            
            const configuraciones = {
                success: {
                    icono: 'fas fa-check',
                    color: '#10b981',
                    borderColor: '#10b981'
                },
                warning: {
                    icono: 'fas fa-exclamation',
                    color: '#f59e0b',
                    borderColor: '#f59e0b'
                },
                error: {
                    icono: 'fas fa-times',
                    color: '#ef4444',
                    borderColor: '#ef4444'
                },
                info: {
                    icono: 'fas fa-info',
                    color: '#3b82f6',
                    borderColor: '#3b82f6'
                }
            };
            
            const config = configuraciones[tipo] || configuraciones.success;
            const iconoOriginal = this.botonCentrar.innerHTML;
            const estilosOriginales = {
                background: this.botonCentrar.style.background,
                color: this.botonCentrar.style.color,
                borderColor: this.botonCentrar.style.borderColor
            };
            
            // Aplicar feedback
            this.botonCentrar.innerHTML = `<i class="${config.icono}"></i>`;
            this.botonCentrar.style.background = config.color;
            this.botonCentrar.style.color = 'white';
            this.botonCentrar.style.borderColor = config.borderColor;
            this.botonCentrar.style.transform = 'scale(1.1)';
            
            // Restaurar después de 1 segundo
            setTimeout(() => {
                this.botonCentrar.innerHTML = iconoOriginal;
                this.botonCentrar.style.background = estilosOriginales.background;
                this.botonCentrar.style.color = estilosOriginales.color;
                this.botonCentrar.style.borderColor = estilosOriginales.borderColor;
                this.botonCentrar.style.transform = '';
            }, 1000);
        },

        // === AJUSTAR ZOOM ===
        ajustarZoom(delta) {
            if (!window.mapaGMSolutions || !window.mapaGMSolutions.map) return;
            
            const zoomActual = window.mapaGMSolutions.map.getZoom();
            const nuevoZoom = Math.max(2, Math.min(18, zoomActual + delta));
            
            window.mapaGMSolutions.map.setZoom(nuevoZoom);
        },

        // === MODO PANTALLA COMPLETA ===
        togglePantallaCompleta() {
            const mapContainer = document.querySelector('.map-container');
            if (!mapContainer) return;
            
            if (!document.fullscreenElement) {
                mapContainer.requestFullscreen().then(() => {
                    console.log('🖥️ Modo pantalla completa activado');
                    if (window.NotificationSystem) {
                        window.NotificationSystem.mostrar(
                            'Pantalla completa activada (ESC para salir)',
                            'info'
                        );
                    }
                });
            } else {
                document.exitFullscreen();
            }
        },

        // === MOSTRAR ERROR ===
        mostrarError(mensaje) {
            if (window.NotificationSystem) {
                window.NotificationSystem.mostrar(mensaje, 'error');
            } else {
                console.error(mensaje);
            }
            
            this.mostrarFeedbackVisual('error');
        },

        // === EVENT LISTENERS ===
        configurarEventListeners() {
            // Atajos de teclado
            document.addEventListener('keydown', (e) => {
                // Home o Ctrl+M = Centrar
                if (e.key === 'Home' || (e.ctrlKey && e.key === 'm')) {
                    e.preventDefault();
                    this.centrarMapa();
                }
                
                // Ctrl+0 = Reset zoom
                if (e.ctrlKey && e.key === '0') {
                    e.preventDefault();
                    this.resetearVista();
                }
                
                // F11 = Pantalla completa
                if (e.key === 'F11') {
                    e.preventDefault();
                    this.togglePantallaCompleta();
                }
                
                // + y - para zoom
                if (e.key === '+' || e.key === '=') {
                    e.preventDefault();
                    this.ajustarZoom(1);
                }
                
                if (e.key === '-' || e.key === '_') {
                    e.preventDefault();
                    this.ajustarZoom(-1);
                }
            });
            
            // Redimensionar mapa en cambio de pantalla completa
            document.addEventListener('fullscreenchange', () => {
                setTimeout(() => {
                    if (window.mapaGMSolutions && window.mapaGMSolutions.map) {
                        window.mapaGMSolutions.map.invalidateSize();
                    }
                }, 100);
            });
        },

        // === API PÚBLICA ===
        getCentroActual() {
            if (!window.mapaGMSolutions || !window.mapaGMSolutions.map) return null;
            return window.mapaGMSolutions.map.getCenter();
        },

        getZoomActual() {
            if (!window.mapaGMSolutions || !window.mapaGMSolutions.map) return null;
            return window.mapaGMSolutions.map.getZoom();
        },

        setBounds(bounds) {
            if (!window.mapaGMSolutions || !window.mapaGMSolutions.map) return false;
            window.mapaGMSolutions.map.fitBounds(bounds);
            return true;
        }
    };

    // === EXPORTAR FUNCIÓN GLOBAL (compatibilidad) ===
    window.centrarMapa = () => MapControls.centrarMapa();
    window.resetearVista = () => MapControls.resetearVista();
    
    // === EXPORTAR MÓDULO ===
    window.MapControls = MapControls;
    
})(window);