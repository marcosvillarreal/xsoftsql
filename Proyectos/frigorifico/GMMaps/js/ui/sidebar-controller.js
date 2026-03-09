/**
 * GM SOLUTIONS - SIDEBAR CONTROLLER v2.3.6
 * Módulo de control del panel lateral responsive
 * ============================================
 */

(function(window) {
    'use strict';

    const SidebarController = {
        // === PROPIEDADES ===
        sidebar: null,
        container: null,
        toggleBtn: null,
        mobileMenuBtn: null,
        isInitialized: false,

        // === INICIALIZACIÓN ===
        init() {
            if (this.isInitialized) return;
            
            this.sidebar = document.getElementById('sidebar');
            this.container = document.getElementById('main-container');
            this.toggleBtn = document.querySelector('.sidebar-toggle-btn');
            this.mobileMenuBtn = document.querySelector('.mobile-menu-btn');
            
            if (this.sidebar && this.container) {
                this.configurarEventListeners();
                this.isInitialized = true;
                console.log('✅ SidebarController inicializado');
            }
        },

        // === CONTROL DESKTOP ===
        toggleSidebarDesktop() {
            if (!this.sidebar || !this.container) return;
            
            this.sidebar.classList.toggle('desktop-hidden');
            this.container.classList.toggle('sidebar-collapsed');
            
            // Actualizar icono y texto del botón
            if (this.toggleBtn) {
                const icon = this.toggleBtn.querySelector('i');
                const text = this.toggleBtn.querySelector('span');
                
                if (this.sidebar.classList.contains('desktop-hidden')) {
                    if (icon) icon.className = 'fas fa-chevron-right';
                    if (text) text.textContent = 'Mostrar';
                    this.toggleBtn.classList.add('collapsed');
                } else {
                    if (icon) icon.className = 'fas fa-chevron-left';
                    if (text) text.textContent = 'Panel';
                    this.toggleBtn.classList.remove('collapsed');
                }
            }
            
            // Redimensionar mapa después de la animación
            this.redimensionarMapa();
            
            // Guardar preferencia
            this.guardarEstadoSidebar();
            
            console.log('🔄 Sidebar desktop toggled');
        },

        // === CONTROL MOBILE ===
        toggleSidebarMobile() {
            if (!this.sidebar) return;
            
            if (window.innerWidth <= 768) {
                this.sidebar.classList.toggle('mobile-hidden');
                
                // Cerrar con overlay en móvil
                if (!this.sidebar.classList.contains('mobile-hidden')) {
                    this.crearOverlay();
                } else {
                    this.removerOverlay();
                }
            } else {
                this.sidebar.classList.toggle('open');
            }
            
            console.log('📱 Sidebar mobile toggled');
        },

        // === OVERLAY MÓVIL ===
        crearOverlay() {
            if (document.getElementById('sidebar-overlay')) return;
            
            const overlay = document.createElement('div');
            overlay.id = 'sidebar-overlay';
            overlay.className = 'sidebar-overlay';
            overlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 998;
                transition: opacity 0.3s ease;
            `;
            
            overlay.addEventListener('click', () => this.toggleSidebarMobile());
            document.body.appendChild(overlay);
            
            // Forzar reflow para animación
            overlay.offsetHeight;
            overlay.style.opacity = '1';
        },

        removerOverlay() {
            const overlay = document.getElementById('sidebar-overlay');
            if (overlay) {
                overlay.style.opacity = '0';
                setTimeout(() => overlay.remove(), 300);
            }
        },

        // === REDIMENSIONAR MAPA ===
        redimensionarMapa() {
            setTimeout(() => {
                if (window.map) {
                    window.map.invalidateSize();
                }
                
                // Notificar a otros módulos
                window.dispatchEvent(new CustomEvent('sidebarToggled', {
                    detail: { isHidden: this.sidebar.classList.contains('desktop-hidden') }
                }));
            }, 300);
        },

        // === PERSISTENCIA ===
        guardarEstadoSidebar() {
            const isHidden = this.sidebar.classList.contains('desktop-hidden');
            localStorage.setItem('gm-sidebar-state', isHidden ? 'hidden' : 'visible');
        },

        cargarEstadoSidebar() {
            const estado = localStorage.getItem('gm-sidebar-state');
            if (estado === 'hidden' && window.innerWidth > 768) {
                this.toggleSidebarDesktop();
            }
        },

        // === RESPONSIVE ===
        ajustarSidebarResponsive() {
            if (window.innerWidth <= 768) {
                // Asegurar que el sidebar esté oculto en móvil por defecto
                if (!this.sidebar.classList.contains('mobile-hidden')) {
                    this.sidebar.classList.add('mobile-hidden');
                }
                
                // Remover clases de desktop
                this.sidebar.classList.remove('desktop-hidden');
                this.container.classList.remove('sidebar-collapsed');
            } else {
                // Remover clases de móvil en desktop
                this.sidebar.classList.remove('mobile-hidden');
                this.removerOverlay();
            }
        },

        // === EVENT LISTENERS ===
        configurarEventListeners() {
            // Botón toggle desktop
            if (this.toggleBtn) {
                this.toggleBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.toggleSidebarDesktop();
                });
            }
            
            // Botón menú móvil
            if (this.mobileMenuBtn) {
                this.mobileMenuBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.toggleSidebarMobile();
                });
            }
            
            // Responsive resize
            let resizeTimer;
            window.addEventListener('resize', () => {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(() => {
                    this.ajustarSidebarResponsive();
                    this.redimensionarMapa();
                }, 250);
            });
            
            // Cargar estado guardado
            this.cargarEstadoSidebar();
            
            // Ajustar al iniciar
            this.ajustarSidebarResponsive();
        },

        // === API PÚBLICA ===
        isHidden() {
            return this.sidebar.classList.contains('desktop-hidden') || 
                   this.sidebar.classList.contains('mobile-hidden');
        },

        show() {
            if (this.isHidden()) {
                if (window.innerWidth <= 768) {
                    this.toggleSidebarMobile();
                } else {
                    this.toggleSidebarDesktop();
                }
            }
        },

        hide() {
            if (!this.isHidden()) {
                if (window.innerWidth <= 768) {
                    this.toggleSidebarMobile();
                } else {
                    this.toggleSidebarDesktop();
                }
            }
        }
    };

    // === EXPORTAR FUNCIONES GLOBALES (compatibilidad) ===
    window.toggleSidebar = () => SidebarController.toggleSidebarMobile();
    window.toggleSidebarDesktop = () => SidebarController.toggleSidebarDesktop();
    
    // === EXPORTAR MÓDULO ===
    window.SidebarController = SidebarController;
    
})(window);