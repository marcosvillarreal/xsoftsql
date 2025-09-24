// js/main.js - Inicialización principal del mapa GM Solutions
window.mapaGMSolutions = {
    
    // Variables globales
    map: null,
    markersLayer: null,
    clientesFiltrados: [],
    centroCalculado: null,
    zoomCalculado: null,
    
    // Inicializar aplicación completa
    init: function() {
        console.log('🚀 Inicializando GM Solutions Mapa v2.3.2 - Arquitectura Modular...');
        
        // 1. Validar datos y configuración
        if (!this.validarDatos()) return;
        
        // 2. Inicializar configuraciones dinámicas
        window.camposValidator.inicializarCamposBusqueda();
        
        // 3. Crear mapa base
        this.crearMapa();
        
        // 4. Cargar clientes
        this.cargarClientes();
        
        // 5. Configurar interfaz
        this.configurarInterfaz();
        
        console.log('✅ Mapa inicializado correctamente con arquitectura modular');
    },
    
    // Validar que todos los datos estén disponibles
    validarDatos: function() {
        const requiredModules = [
            'clientesData', 'camposConfig', 'estadosConfig', 'mapaConfig', 'iconosConfig',
            'estadosManager', 'marcadoresManager', 'filtrosManager', 
            'busquedaManager', 'popupManager', 'camposValidator', 'iconosHelper', 'iconosManager'
        ];
        
        const faltantes = requiredModules.filter(module => !window[module]);
        
        if (faltantes.length > 0) {
            console.error('❌ Módulos faltantes:', faltantes);
            alert('Error: Faltan cargar algunos archivos JS. Revise la consola.');
            return false;
        }
        
        console.log('✅ Todos los módulos cargados correctamente');
        return true;
    },
    
    // Crear mapa base
    crearMapa: function() {
        const config = window.mapaConfig;
        
        // Inicializar mapa
        this.map = L.map('map').setView(config.centro, config.zoom);
        window.map = this.map; // Para compatibilidad global
        
        // Agregar capa base
        L.tileLayer(config.tileLayer.url, {
            maxZoom: config.maxZoom,
            attribution: config.tileLayer.attribution
        }).addTo(this.map);
        
        // Crear capa de marcadores
        this.markersLayer = L.layerGroup().addTo(this.map);
        window.markersLayer = this.markersLayer; // Para compatibilidad global
        
        console.log('🗺️ Mapa base creado');
    },
    
    // Cargar y procesar clientes
    cargarClientes: function() {
        if (!window.clientesData || window.clientesData.length === 0) {
            console.warn('⚠️ No hay datos de clientes disponibles');
            return;
        }
        
        // Validar y limpiar datos de clientes usando el nuevo validador
        this.clientesFiltrados = window.camposValidator.validarEstructuraDatos(window.clientesData);
        
        // Actualizar referencia global
        window.clientesData = this.clientesFiltrados;
        
        // Crear marcadores iniciales
        this.actualizarMarcadores();
        
        // NUEVO: Centrar automáticamente en los clientes cargados
        setTimeout(() => {
            this.centrarEnClientesVisibles(false); // Sin animación al cargar
        }, 500);
        
        console.log(`📍 ${this.clientesFiltrados.length} clientes cargados y centrados`);
    },
    
    // Configurar interfaz de usuario
    configurarInterfaz: function() {
        // Configurar búsqueda
        window.busquedaManager.actualizarPlaceholder();
        this.configurarEventosBusqueda();
        
        // Generar filtros dinámicos
        window.filtrosManager.generarFiltros();
        
        // Crear leyenda
        window.marcadoresManager.actualizarLeyenda();
        
        // Configurar controles de campo prioritario
        this.crearControlCampoPrioritario();
        
        // Actualizar estadísticas
        this.actualizarEstadisticas();
        
        console.log('🎛️ Interfaz configurada');
    },
    
    // Configurar eventos de búsqueda
    configurarEventosBusqueda: function() {
        const searchInput = document.getElementById('client-search');
        const searchInputTop = document.getElementById('search-client');
        
        const manejarBusqueda = (event) => {
            const termino = event.target.value;
            const resultados = window.busquedaManager.buscar(termino);
            this.mostrarResultados(resultados);
        };
        
        if (searchInput) {
            searchInput.addEventListener('input', manejarBusqueda);
        }
        if (searchInputTop) {
            searchInputTop.addEventListener('input', manejarBusqueda);
        }
    },
    
    // Crear control para cambiar campo prioritario
    crearControlCampoPrioritario: function() {
        const controlsContainer = document.querySelector('.controls-container');
        if (!controlsContainer) {
            console.warn('⚠️ No se encontró .controls-container para el selector');
            return;
        }
        
        if (!window.estadosConfig) {
            console.warn('⚠️ estadosConfig no disponible');
            return;
        }
        
        const camposPrioritarios = Object.keys(window.estadosConfig);
        
        let controlHTML = `
            <div class="priority-field-control">
                <label>🎨 Vista por:</label>
                <select id="campo-prioritario" onchange="window.mapaGMSolutions.cambiarCampoPrioritario(this.value)">
        `;
        
        camposPrioritarios.forEach(campo => {
            const config = window.camposConfig?.dinamicos[campo];
            const selected = campo === window.estadosManager.campoPrioritario ? 'selected' : '';
            controlHTML += `
                <option value="${campo}" ${selected}>
                    ${config ? config.nombre : campo}
                </option>
            `;
        });
        
        controlHTML += `
                </select>
            </div>
        `;
        
        // Insertar ANTES del search-box
        const searchBox = controlsContainer.querySelector('.search-box');
        if (searchBox) {
            searchBox.insertAdjacentHTML('beforebegin', controlHTML);
        } else {
            controlsContainer.insertAdjacentHTML('beforeend', controlHTML);
        }
        
        console.log('🎨 Control de campo prioritario creado');
    },
    
    // Cambiar campo prioritario
    cambiarCampoPrioritario: function(nuevoCampo) {
        window.marcadoresManager.actualizarMarcadores(nuevoCampo);
        window.marcadoresManager.actualizarLeyenda();
        this.actualizarEstadisticas();
    },
    
    // Actualizar marcadores en el mapa
    actualizarMarcadores: function() {
        window.marcadoresManager.actualizarMarcadores();
    },
    
    // Mostrar resultados de búsqueda/filtros
    mostrarResultados: function(clientes) {
        this.clientesFiltrados = clientes;
        
        // Limpiar marcadores
        this.markersLayer.clearLayers();
        
        // Agregar marcadores filtrados
        clientes.forEach(cliente => {
            const marcador = window.marcadoresManager.crearMarcador(cliente);
            if (marcador) {
                this.markersLayer.addLayer(marcador);
            }
        });
        
        // Actualizar contador
        this.actualizarContador(clientes.length);
        
        // NUEVO: Actualizar centro dinámico basado en clientes visibles
        this.calcularCentroDinamico(clientes);
        
        console.log(`🔍 Mostrando ${clientes.length} resultados`);
    },
    
    // Actualizar contador de clientes
    actualizarContador: function(cantidad) {
        const contadores = document.querySelectorAll('.client-count, .total-count');
        contadores.forEach(contador => {
            contador.textContent = cantidad;
        });
    },
    
    // Actualizar estadísticas
    actualizarEstadisticas: function() {
        const stats = window.estadosManager.obtenerEstadisticas();
        console.log('📊 Estadísticas actualizadas:', stats);
        
        // Actualizar contadores en la interfaz si existen
        Object.entries(stats).forEach(([campo, valores]) => {
            Object.entries(valores).forEach(([valor, count]) => {
                const elemento = document.getElementById(`stat-${campo}-${valor}`);
                if (elemento) {
                    elemento.textContent = count;
                }
            });
        });
    },
    
    // Resetear filtros
    resetearFiltros: function() {
        this.mostrarResultados([...window.clientesData]);
        
        // Limpiar inputs de búsqueda
        const searchInputs = document.querySelectorAll('#client-search, #search-client');
        searchInputs.forEach(input => input.value = '');
        
        // Desactivar filtros
        const filterBtns = document.querySelectorAll('.filter-btn.active');
        filterBtns.forEach(btn => btn.classList.remove('active'));
        
        console.log('🔄 Filtros reseteados');
    },
    
    // NUEVAS FUNCIONES PARA CENTRO DINÁMICO
    
    // Calcular centro dinámico basado en clientes visibles
    calcularCentroDinamico: function(clientes = null) {
        const clientesParaCalcular = clientes || this.clientesFiltrados || window.clientesData;
        
        if (!clientesParaCalcular || clientesParaCalcular.length === 0) {
            console.warn('⚠️ No hay clientes para calcular centro');
            return {
                centro: window.mapaConfig.centro,
                zoom: window.mapaConfig.zoom
            };
        }
        
        // Extraer todas las coordenadas válidas
        const coordenadas = clientesParaCalcular
            .map(cliente => cliente.coords)
            .filter(coord => coord && coord.length === 2 && 
                           typeof coord[0] === 'number' && typeof coord[1] === 'number');
        
        if (coordenadas.length === 0) {
            console.warn('⚠️ No hay coordenadas válidas para calcular centro');
            return {
                centro: window.mapaConfig.centro,
                zoom: window.mapaConfig.zoom
            };
        }
        
        // Calcular centro geográfico (promedio de lat/lng)
        const latitudes = coordenadas.map(coord => coord[0]);
        const longitudes = coordenadas.map(coord => coord[1]);
        
        const centroLat = latitudes.reduce((sum, lat) => sum + lat, 0) / latitudes.length;
        const centroLng = longitudes.reduce((sum, lng) => sum + lng, 0) / longitudes.length;
        
        // Calcular zoom apropiado basado en la dispersión de puntos
        const zoom = this.calcularZoomOptimo(coordenadas);
        
        const resultado = {
            centro: [centroLat, centroLng],
            zoom: zoom,
            puntos: coordenadas.length
        };
        
        // Guardar para uso posterior
        this.centroCalculado = resultado.centro;
        this.zoomCalculado = resultado.zoom;
        
        console.log('📍 Centro dinámico calculado:', resultado);
        return resultado;
    },
    
    // Calcular zoom óptimo según dispersión de puntos
    calcularZoomOptimo: function(coordenadas) {
        if (coordenadas.length <= 1) {
            return 15; // Zoom alto para un solo punto
        }
        
        // Calcular bounding box
        const latitudes = coordenadas.map(coord => coord[0]);
        const longitudes = coordenadas.map(coord => coord[1]);
        
        const minLat = Math.min(...latitudes);
        const maxLat = Math.max(...latitudes);
        const minLng = Math.min(...longitudes);
        const maxLng = Math.max(...longitudes);
        
        // Calcular distancias
        const deltaLat = maxLat - minLat;
        const deltaLng = maxLng - minLng;
        const maxDelta = Math.max(deltaLat, deltaLng);
        
        // Mapear distancia a zoom (aproximado)
        let zoom;
        if (maxDelta > 0.5) zoom = 10;      // Muy disperso
        else if (maxDelta > 0.2) zoom = 11; // Disperso
        else if (maxDelta > 0.1) zoom = 12; // Medio disperso
        else if (maxDelta > 0.05) zoom = 13; // Poco disperso
        else if (maxDelta > 0.02) zoom = 14; // Concentrado
        else zoom = 15;                     // Muy concentrado
        
        return zoom;
    },
    
    // Centrar mapa en clientes visibles
    centrarEnClientesVisibles: function(animado = true) {
        if (!this.map) {
            console.error('❌ Mapa no disponible');
            return false;
        }
        
        const resultado = this.calcularCentroDinamico();
        
        if (animado) {
            this.map.flyTo(resultado.centro, resultado.zoom, {
                animate: true,
                duration: 1.5
            });
        } else {
            this.map.setView(resultado.centro, resultado.zoom);
        }
        
        console.log(`🎯 Mapa centrado dinámicamente en ${resultado.puntos} clientes`);
        return true;
    }
};

// Funciones globales para compatibilidad
function filterClients(filterType) {
    const clientesFiltrados = window.filtrosManager.aplicarFiltro(filterType) || 
                             [...window.clientesData];
    window.mapaGMSolutions.mostrarResultados(clientesFiltrados);
    
    // Marcar botón como activo
    document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
    if (event && event.target) {
        event.target.classList.add('active');
    }
}

function searchClient() {
    const searchTerm = document.getElementById('search-client').value;
    const resultados = window.busquedaManager.buscar(searchTerm);
    window.mapaGMSolutions.mostrarResultados(resultados);
}

function showAllClients() {
    window.mapaGMSolutions.resetearFiltros();
}

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    // Pequeño delay para asegurar que todos los JS se carguen
    setTimeout(() => {
        window.mapaGMSolutions.init();
    }, 100);
});