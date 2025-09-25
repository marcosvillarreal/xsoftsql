/**
 * GM SOLUTIONS - THEME CONTROLLER v2.3.6
 * Sistema de gestión de temas de colores
 * =======================================
 */

(function(window) {
    'use strict';

    const ThemeController = {
        // === PROPIEDADES ===
        temaActual: 'base',
        temasDisponibles: ['base', 'oscuro'],
        toggleBtn: null,
        isInitialized: false,

        // === INICIALIZACIÓN ===
        init() {
            if (this.isInitialized) return;
            
            this.toggleBtn = document.querySelector('.theme-toggle-btn');
            this.cargarTemaGuardado();
            this.configurarEventListeners();
            this.isInitialized = true;
            
            console.log('✅ ThemeController inicializado con tema:', this.temaActual);
        },

        // === CAMBIAR TEMA ===
        toggleTheme() {
            const indiceActual = this.temasDisponibles.indexOf(this.temaActual);
            const siguienteIndice = (indiceActual + 1) % this.temasDisponibles.length;
            const nuevoTema = this.temasDisponibles[siguienteIndice];
            
            this.aplicarTema(nuevoTema);
            this.guardarTemaPreferido(nuevoTema);
            this.actualizarBotonTema(nuevoTema);
            this.notificarCambioTema(nuevoTema);
            
            console.log(`🎨 Tema cambiado: ${this.temaActual} → ${nuevoTema}`);
            this.temaActual = nuevoTema;
            
            return nuevoTema;
        },

        // === APLICAR TEMA ===
        aplicarTema(tema) {
            if (!this.temasDisponibles.includes(tema)) {
                console.warn(`⚠️ Tema no válido: ${tema}`);
                return false;
            }
            
            document.body.setAttribute('data-theme', tema);
            
            // Aplicar clases adicionales para compatibilidad
            document.body.classList.remove(...this.temasDisponibles.map(t => `theme-${t}`));
            document.body.classList.add(`theme-${tema}`);
            
            // Actualizar meta theme-color para navegadores móviles
            this.actualizarMetaThemeColor(tema);
            
            return true;
        },

        // === ACTUALIZAR META THEME COLOR ===
        actualizarMetaThemeColor(tema) {
            let metaThemeColor = document.querySelector('meta[name="theme-color"]');
            
            if (!metaThemeColor) {
                metaThemeColor = document.createElement('meta');
                metaThemeColor.name = 'theme-color';
                document.head.appendChild(metaThemeColor);
            }
            
            const colores = {
                'base': '#1e40af',
                'oscuro': '#0f172a'
            };
            
            metaThemeColor.content = colores[tema] || colores['base'];
        },

        // === ACTUALIZAR BOTÓN ===
        actualizarBotonTema(tema) {
            if (!this.toggleBtn) return;
            
            const icon = this.toggleBtn.querySelector('i');
            const text = this.toggleBtn.querySelector('span');
            
            const configuraciones = {
                'base': {
                    icono: 'fas fa-sun',
                    texto: 'Claro',
                    titulo: 'Cambiar a tema oscuro'
                },
                'oscuro': {
                    icono: 'fas fa-moon',
                    texto: 'Oscuro',
                    titulo: 'Cambiar a tema claro'
                }
            };
            
            const config = configuraciones[tema] || configuraciones['base'];
            
            if (icon) icon.className = config.icono;
            if (text) text.textContent = config.texto;
            this.toggleBtn.title = config.titulo;
        },

        // === PERSISTENCIA ===
        guardarTemaPreferido(tema) {
            try {
                localStorage.setItem('gm-theme', tema);
                localStorage.setItem('gm-theme-timestamp', Date.now().toString());
            } catch (e) {
                console.error('❌ Error al guardar tema:', e);
            }
        },

        cargarTemaGuardado() {
            try {
                // Verificar preferencia del sistema primero
                const prefiereTemaOscuro = window.matchMedia && 
                    window.matchMedia('(prefers-color-scheme: dark)').matches;
                
                // Cargar tema guardado o usar preferencia del sistema
                const temaGuardado = localStorage.getItem('gm-theme');
                
                if (temaGuardado && this.temasDisponibles.includes(temaGuardado)) {
                    this.temaActual = temaGuardado;
                } else if (prefiereTemaOscuro) {
                    this.temaActual = 'oscuro';
                } else {
                    this.temaActual = 'base';
                }
                
                this.aplicarTema(this.temaActual);
                this.actualizarBotonTema(this.temaActual);
                
            } catch (e) {
                console.error('❌ Error al cargar tema:', e);
                this.temaActual = 'base';
                this.aplicarTema(this.temaActual);
            }
        },

        // === NOTIFICACIONES ===
        notificarCambioTema(tema) {
            // Mostrar notificación si el módulo existe
            if (window.NotificationSystem && window.NotificationSystem.mostrar) {
                const mensajes = {
                    'base': '☀️ Tema Claro activado',
                    'oscuro': '🌙 Tema Oscuro activado'
                };
                
                window.NotificationSystem.mostrar(
                    mensajes[tema] || `Tema ${tema} activado`,
                    'success'
                );
            }
            
            // Disparar evento personalizado
            window.dispatchEvent(new CustomEvent('themeChanged', {
                detail: { 
                    tema: tema,
                    anterior: this.temaActual
                }
            }));
        },

        // === DETECCIÓN AUTOMÁTICA ===
        detectarPreferenciaSistema() {
            if (!window.matchMedia) return;
            
            const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
            
            // Listener para cambios en la preferencia del sistema
            mediaQuery.addListener((e) => {
                // Solo cambiar si no hay una preferencia guardada
                if (!localStorage.getItem('gm-theme')) {
                    const nuevoTema = e.matches ? 'oscuro' : 'base';
                    this.aplicarTema(nuevoTema);
                    this.actualizarBotonTema(nuevoTema);
                    this.temaActual = nuevoTema;
                    
                    console.log(`🔄 Tema ajustado automáticamente a: ${nuevoTema}`);
                }
            });
        },

        // === EVENT LISTENERS ===
        configurarEventListeners() {
            // Botón de cambio de tema
            if (this.toggleBtn) {
                this.toggleBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.toggleTheme();
                });
            }
            
            // Detectar cambios en preferencia del sistema
            this.detectarPreferenciaSistema();
            
            // Atajo de teclado (Alt + T)
            document.addEventListener('keydown', (e) => {
                if (e.altKey && e.key === 't') {
                    e.preventDefault();
                    this.toggleTheme();
                }
            });
        },

        // === API PÚBLICA ===
        getTemaActual() {
            return this.temaActual;
        },

        setTema(tema) {
            if (this.aplicarTema(tema)) {
                this.guardarTemaPreferido(tema);
                this.actualizarBotonTema(tema);
                this.temaActual = tema;
                return true;
            }
            return false;
        },

        getTemasDisponibles() {
            return [...this.temasDisponibles];
        },

        // === UTILIDADES ===
        esTemaOscuro() {
            return this.temaActual === 'oscuro';
        },

        esTemaClaro() {
            return this.temaActual === 'base';
        }
    };

    // === EXPORTAR FUNCIÓN GLOBAL (compatibilidad) ===
    window.toggleTheme = () => ThemeController.toggleTheme();
    
    // === EXPORTAR MÓDULO ===
    window.ThemeController = ThemeController;
    
})(window);