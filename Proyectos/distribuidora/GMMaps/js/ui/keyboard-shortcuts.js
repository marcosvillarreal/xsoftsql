/**
 * GM SOLUTIONS - KEYBOARD SHORTCUTS v2.3.6
 * Sistema centralizado de atajos de teclado
 * ==========================================
 */

(function(window) {
    'use strict';

    const KeyboardShortcuts = {
        // === PROPIEDADES ===
        atajos: new Map(),
        atajosActivos: true,
        isInitialized: false,
        modalAyuda: null,

        // === INICIALIZACIÓN ===
        init() {
            if (this.isInitialized) return;
            
            this.registrarAtajosDefecto();
            this.configurarEventListeners();
            this.isInitialized = true;
            
            console.log('✅ KeyboardShortcuts inicializado');
        },

        // === REGISTRAR ATAJOS POR DEFECTO ===
        registrarAtajosDefecto() {
            // === NAVEGACIÓN ===
            this.registrarAtajo('Ctrl+B', 'Mostrar/Ocultar Panel', () => {
                if (window.innerWidth > 768) {
                    window.SidebarController?.toggleSidebarDesktop();
                } else {
                    window.SidebarController?.toggleSidebarMobile();
                }
            });

            this.registrarAtajo('Escape', 'Cerrar panel móvil', () => {
                if (window.innerWidth <= 768) {
                    window.SidebarController?.hide();
                }
            });

            // === MAPA ===
            this.registrarAtajo('Home', 'Centrar mapa', () => {
                window.MapControls?.centrarMapa();
            });

            this.registrarAtajo('Ctrl+M', 'Centrar mapa', () => {
                window.MapControls?.centrarMapa();
            });

            this.registrarAtajo('Ctrl+0', 'Resetear vista', () => {
                window.MapControls?.resetearVista();
            });

            this.registrarAtajo('+', 'Aumentar zoom', () => {
                window.MapControls?.ajustarZoom(1);
            });

            this.registrarAtajo('-', 'Disminuir zoom', () => {
                window.MapControls?.ajustarZoom(-1);
            });

            this.registrarAtajo('F11', 'Pantalla completa', () => {
                window.MapControls?.togglePantallaCompleta();
            });

            // === BÚSQUEDA Y FILTROS ===
            this.registrarAtajo('Ctrl+F', 'Buscar cliente', () => {
                const searchInput = document.getElementById('client-search') || 
                                  document.getElementById('search-client');
                if (searchInput) {
                    searchInput.focus();
                    searchInput.select();
                }
            });

            this.registrarAtajo('Ctrl+R', 'Resetear filtros', () => {
                window.mapaGMSolutions?.resetearFiltros();
            });

            this.registrarAtajo('Ctrl+A', 'Mostrar todos', () => {
                window.mapaGMSolutions?.mostrarTodos();
            });

            // === EXPORTACIÓN ===
            this.registrarAtajo('Ctrl+E', 'Exportar datos', () => {
                window.ExportTools?.mostrarMenuExportacion();
            });

            this.registrarAtajo('Ctrl+P', 'Imprimir mapa', () => {
                window.ExportTools?.imprimirMapa();
            });

            this.registrarAtajo('Ctrl+S', 'Compartir mapa', () => {
                window.ExportTools?.compartirMapa();
            });

            // === TEMA ===
            this.registrarAtajo('Alt+T', 'Cambiar tema', () => {
                window.ThemeController?.toggleTheme();
            });

            // === AYUDA ===
            this.registrarAtajo('F1', 'Mostrar ayuda', () => {
                this.mostrarAyudaAtajos();
            });

            this.registrarAtajo('?', 'Mostrar ayuda', () => {
                this.mostrarAyudaAtajos();
            });

            // === ESTADÍSTICAS ===
            this.registrarAtajo('Ctrl+I', 'Ver estadísticas', () => {
                this.mostrarEstadisticas();
            });

            // === NAVEGACIÓN RÁPIDA ===
            this.registrarAtajo('1', 'Vista por categoría', () => {
                this.cambiarVista('categoria_cliente');
            });

            this.registrarAtajo('2', 'Vista por estado', () => {
                this.cambiarVista('estado_cliente');
            });

            this.registrarAtajo('3', 'Vista por zona', () => {
                this.cambiarVista('zona');
            });
        },

        // === REGISTRAR ATAJO ===
        registrarAtajo(combinacion, descripcion, callback, opciones = {}) {
            const atajo = {
                combinacion: this.normalizarCombinacion(combinacion),
                descripcion,
                callback,
                activo: opciones.activo !== false,
                categoria: opciones.categoria || 'General',
                preventDefault: opciones.preventDefault !== false
            };

            this.atajos.set(atajo.combinacion, atajo);
            
            console.log(`⌨️ Atajo registrado: ${combinacion}`);
            
            return this;
        },

        // === NORMALIZAR COMBINACIÓN ===
        normalizarCombinacion(combinacion) {
            return combinacion
                .toLowerCase()
                .replace(/\s+/g, '')
                .split('+')
                .sort()
                .join('+');
        },

        // === MANEJAR TECLA ===
        manejarTecla(evento) {
            if (!this.atajosActivos) return;
            
            // Ignorar si el foco está en un input (excepto para Escape)
            if (evento.key !== 'Escape') {
                const elementoActivo = document.activeElement;
                if (elementoActivo && (
                    elementoActivo.tagName === 'INPUT' ||
                    elementoActivo.tagName === 'TEXTAREA' ||
                    elementoActivo.tagName === 'SELECT'
                )) {
                    return;
                }
            }

            // Construir combinación actual
            const teclas = [];
            
            if (evento.ctrlKey || evento.metaKey) teclas.push('ctrl');
            if (evento.altKey) teclas.push('alt');
            if (evento.shiftKey) teclas.push('shift');
            
            // Normalizar la tecla
            let tecla = evento.key.toLowerCase();
            
            // Manejar teclas especiales
            const teclasEspeciales = {
                ' ': 'space',
                'escape': 'escape',
                'enter': 'enter',
                'arrowup': 'up',
                'arrowdown': 'down',
                'arrowleft': 'left',
                'arrowright': 'right',
                'home': 'home',
                'end': 'end',
                'pageup': 'pageup',
                'pagedown': 'pagedown',
                'delete': 'delete',
                'backspace': 'backspace',
                'tab': 'tab'
            };
            
            tecla = teclasEspeciales[tecla] || tecla;
            
            // Ignorar modificadores solos
            if (['control', 'alt', 'shift', 'meta'].includes(tecla)) {
                return;
            }
            
            teclas.push(tecla);
            
            const combinacion = teclas.sort().join('+');
            
            // Buscar y ejecutar atajo
            const atajo = this.atajos.get(combinacion);
            
            if (atajo && atajo.activo) {
                if (atajo.preventDefault) {
                    evento.preventDefault();
                    evento.stopPropagation();
                }
                
                try {
                    atajo.callback(evento);
                    console.log(`⌨️ Atajo ejecutado: ${atajo.combinacion}`);
                } catch (error) {
                    console.error(`❌ Error ejecutando atajo ${combinacion}:`, error);
                }
            }
        },

        // === MOSTRAR AYUDA ATAJOS ===
        mostrarAyudaAtajos() {
            // Si ya existe el modal, mostrarlo
            if (this.modalAyuda) {
                this.modalAyuda.style.display = 'flex';
                return;
            }

            // Crear modal
            this.modalAyuda = document.createElement('div');
            this.modalAyuda.className = 'keyboard-shortcuts-modal';
            this.modalAyuda.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.7);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 10000;
                animation: fadeIn 0.3s ease;
            `;

            // Crear contenido
            const contenido = document.createElement('div');
            contenido.style.cssText = `
                background: white;
                border-radius: 12px;
                padding: 30px;
                max-width: 600px;
                max-height: 80vh;
                overflow-y: auto;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            `;

            // Agrupar atajos por categoría
            const categorias = {};
            this.atajos.forEach(atajo => {
                if (!categorias[atajo.categoria]) {
                    categorias[atajo.categoria] = [];
                }
                categorias[atajo.categoria].push(atajo);
            });

            // Generar HTML
            let html = `
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h2 style="margin: 0; color: #1e40af; font-size: 24px;">
                        ⌨️ Atajos de Teclado
                    </h2>
                    <button onclick="window.KeyboardShortcuts.cerrarAyuda()" 
                            style="background: none; border: none; font-size: 24px; cursor: pointer; color: #666;">
                        ×
                    </button>
                </div>
            `;

            // Generar lista de atajos por categoría
            Object.entries(categorias).forEach(([categoria, atajosCat]) => {
                html += `
                    <div style="margin-bottom: 20px;">
                        <h3 style="color: #3b82f6; font-size: 16px; margin-bottom: 10px; 
                                   border-bottom: 2px solid #e5e7eb; padding-bottom: 5px;">
                            ${categoria}
                        </h3>
                        <div style="display: grid; gap: 8px;">
                `;

                atajosCat.forEach(atajo => {
                    const combinacionFormateada = atajo.combinacion
                        .split('+')
                        .map(t => t.charAt(0).toUpperCase() + t.slice(1))
                        .join(' + ');

                    html += `
                        <div style="display: flex; justify-content: space-between; align-items: center;
                                    padding: 8px 12px; background: #f9fafb; border-radius: 6px;">
                            <span style="color: #6b7280; font-size: 14px;">
                                ${atajo.descripcion}
                            </span>
                            <kbd style="background: #1e40af; color: white; padding: 4px 8px; 
                                        border-radius: 4px; font-size: 12px; font-family: monospace;">
                                ${combinacionFormateada}
                            </kbd>
                        </div>
                    `;
                });

                html += `
                        </div>
                    </div>
                `;
            });

            html += `
                <div style="margin-top: 20px; padding-top: 15px; border-top: 1px solid #e5e7eb; 
                            text-align: center; color: #9ca3af; font-size: 12px;">
                    Presiona ESC o haz clic fuera para cerrar
                </div>
            `;

            contenido.innerHTML = html;
            this.modalAyuda.appendChild(contenido);

            // Agregar al DOM
            document.body.appendChild(this.modalAyuda);

            // Cerrar con ESC o click fuera
            this.modalAyuda.addEventListener('click', (e) => {
                if (e.target === this.modalAyuda) {
                    this.cerrarAyuda();
                }
            });
        },

        // === CERRAR AYUDA ===
        cerrarAyuda() {
            if (this.modalAyuda) {
                this.modalAyuda.style.animation = 'fadeOut 0.3s ease';
                setTimeout(() => {
                    this.modalAyuda.remove();
                    this.modalAyuda = null;
                }, 300);
            }
        },

        // === CAMBIAR VISTA ===
        cambiarVista(campo) {
            const selector = document.getElementById('campo-prioritario');
            if (selector && selector.value !== campo) {
                selector.value = campo;
                selector.dispatchEvent(new Event('change'));
                
                if (window.NotificationSystem) {
                    window.NotificationSystem.mostrar(
                        `Vista cambiada a: ${campo.replace('_', ' ')}`,
                        'info'
                    );
                }
            }
        },

        // === MOSTRAR ESTADÍSTICAS ===
        mostrarEstadisticas() {
            const stats = window.StatsController?.getDatosEstadisticas();
            if (!stats || !stats.valores) {
                if (window.NotificationSystem) {
                    window.NotificationSystem.mostrar(
                        'No hay estadísticas disponibles',
                        'warning'
                    );
                }
                return;
            }

            let mensaje = `📊 ESTADÍSTICAS - ${stats.campo.toUpperCase()}\n\n`;
            mensaje += `Total visible: ${stats.total}\n`;
            mensaje += `Total original: ${stats.totalOriginal}\n\n`;
            
            stats.valores.forEach(v => {
                mensaje += `${v.valor}: ${v.cantidad} (${v.porcentaje}%)\n`;
            });

            alert(mensaje);
        },

        // === EVENT LISTENERS ===
        configurarEventListeners() {
            document.addEventListener('keydown', (e) => this.manejarTecla(e));
        },

        // === ACTIVAR/DESACTIVAR ===
        activar() {
            this.atajosActivos = true;
            console.log('✅ Atajos de teclado activados');
        },

        desactivar() {
            this.atajosActivos = false;
            console.log('⏸️ Atajos de teclado desactivados');
        },

        // === API PÚBLICA ===
        getAtajos() {
            return Array.from(this.atajos.values());
        },

        getAtajosPorCategoria(categoria) {
            return this.getAtajos().filter(a => a.categoria === categoria);
        },

        removerAtajo(combinacion) {
            const normalizada = this.normalizarCombinacion(combinacion);
            return this.atajos.delete(normalizada);
        },

        limpiarAtajos() {
            this.atajos.clear();
        }
    };

    // === EXPORTAR MÓDULO ===
    window.KeyboardShortcuts = KeyboardShortcuts;
    
})(window);