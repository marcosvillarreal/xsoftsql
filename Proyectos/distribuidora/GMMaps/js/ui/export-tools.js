/**
 * GM SOLUTIONS - EXPORT TOOLS v2.3.6
 * Herramientas de exportación e intercambio de datos
 * ===================================================
 */

(function(window) {
    'use strict';

    const ExportTools = {
        // === PROPIEDADES ===
        formatosDisponibles: ['CSV', 'JSON', 'Excel', 'PDF'],
        isInitialized: false,

        // === INICIALIZACIÓN ===
        init() {
            if (this.isInitialized) return;
            
            this.configurarEventListeners();
            this.isInitialized = true;
            
            console.log('✅ ExportTools inicializado');
        },

        // === EXPORTAR DATOS ===
        exportarDatos(formato = 'CSV') {
            const datos = this.obtenerDatosParaExportar();
            
            if (!datos || datos.length === 0) {
                this.mostrarMensaje('No hay datos para exportar', 'warning');
                return;
            }
            
            switch(formato.toUpperCase()) {
                case 'CSV':
                    this.exportarCSV(datos);
                    break;
                case 'JSON':
                    this.exportarJSON(datos);
                    break;
                case 'EXCEL':
                    this.exportarExcel(datos);
                    break;
                case 'PDF':
                    this.exportarPDF(datos);
                    break;
                default:
                    this.mostrarMensaje(`Formato no soportado: ${formato}`, 'error');
            }
        },

        // === OBTENER DATOS PARA EXPORTAR ===
        obtenerDatosParaExportar() {
            // Usar clientes filtrados si existen, si no todos los clientes
            const clientes = window.mapaGMSolutions?.clientesFiltrados || window.clientesData;
            
            if (!clientes) return [];
            
            // Limpiar y formatear datos
            return clientes.map(cliente => {
                const datosLimpios = {};
                
                // Obtener campos configurados
                const camposConfig = window.camposConfig?.dinamicos || {};
                
                // Exportar solo campos relevantes
                Object.keys(camposConfig).forEach(campo => {
                    if (cliente[campo] !== undefined) {
                        datosLimpios[camposConfig[campo].nombre || campo] = cliente[campo];
                    }
                });
                
                // Agregar campos básicos
                datosLimpios['Latitud'] = cliente.latitud || '';
                datosLimpios['Longitud'] = cliente.longitud || '';
                
                return datosLimpios;
            });
        },

        // === EXPORTAR CSV ===
        exportarCSV(datos) {
            if (!datos || datos.length === 0) {
                this.mostrarMensaje('No hay datos para exportar', 'warning');
                return;
            }
            
            // Obtener headers
            const headers = Object.keys(datos[0]);
            
            // Crear contenido CSV
            let csvContent = headers.join(',') + '\n';
            
            // Agregar filas
            datos.forEach(fila => {
                const valores = headers.map(header => {
                    const valor = fila[header] || '';
                    // Escapar valores con comas o comillas
                    if (valor.toString().includes(',') || valor.toString().includes('"')) {
                        return `"${valor.toString().replace(/"/g, '""')}"`;
                    }
                    return valor;
                });
                csvContent += valores.join(',') + '\n';
            });
            
            // Crear y descargar archivo
            const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const fecha = new Date().toISOString().slice(0, 10);
            const nombreArchivo = `clientes_export_${fecha}.csv`;
            
            this.descargarArchivo(url, nombreArchivo);
            
            this.mostrarMensaje(`✅ Exportado: ${datos.length} registros en CSV`, 'success');
            
            // Log para debugging
            console.log(`📊 CSV exportado: ${datos.length} registros`);
        },

        // === EXPORTAR JSON ===
        exportarJSON(datos) {
            if (!datos || datos.length === 0) {
                this.mostrarMensaje('No hay datos para exportar', 'warning');
                return;
            }
            
            // Crear objeto JSON con metadata
            const exportData = {
                metadata: {
                    fecha: new Date().toISOString(),
                    totalRegistros: datos.length,
                    version: 'v2.3.6',
                    origen: 'GM Solutions - Mapa de Clientes'
                },
                clientes: datos
            };
            
            // Crear y descargar archivo
            const jsonStr = JSON.stringify(exportData, null, 2);
            const blob = new Blob([jsonStr], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const fecha = new Date().toISOString().slice(0, 10);
            const nombreArchivo = `clientes_export_${fecha}.json`;
            
            this.descargarArchivo(url, nombreArchivo);
            
            this.mostrarMensaje(`✅ Exportado: ${datos.length} registros en JSON`, 'success');
            
            console.log(`📊 JSON exportado: ${datos.length} registros`);
        },

        // === EXPORTAR EXCEL (BÁSICO) ===
        exportarExcel(datos) {
            // Crear tabla HTML para Excel
            if (!datos || datos.length === 0) {
                this.mostrarMensaje('No hay datos para exportar', 'warning');
                return;
            }
            
            const headers = Object.keys(datos[0]);
            
            let html = '<html xmlns:o="urn:schemas-microsoft-com:office:office" ';
            html += 'xmlns:x="urn:schemas-microsoft-com:office:excel" ';
            html += 'xmlns="http://www.w3.org/TR/REC-html40">';
            html += '<head><meta charset="utf-8"></head>';
            html += '<body>';
            html += '<table border="1">';
            
            // Headers
            html += '<thead><tr>';
            headers.forEach(header => {
                html += `<th style="background-color:#4472C4;color:white;font-weight:bold;">${header}</th>`;
            });
            html += '</tr></thead>';
            
            // Datos
            html += '<tbody>';
            datos.forEach((fila, index) => {
                const bgColor = index % 2 === 0 ? '#ffffff' : '#f2f2f2';
                html += `<tr style="background-color:${bgColor}">`;
                headers.forEach(header => {
                    html += `<td>${fila[header] || ''}</td>`;
                });
                html += '</tr>';
            });
            html += '</tbody></table>';
            html += '</body></html>';
            
            // Crear y descargar archivo
            const blob = new Blob([html], { type: 'application/vnd.ms-excel' });
            const url = URL.createObjectURL(blob);
            const fecha = new Date().toISOString().slice(0, 10);
            const nombreArchivo = `clientes_export_${fecha}.xls`;
            
            this.descargarArchivo(url, nombreArchivo);
            
            this.mostrarMensaje(`✅ Exportado: ${datos.length} registros en Excel`, 'success');
            
            console.log(`📊 Excel exportado: ${datos.length} registros`);
        },

        // === EXPORTAR PDF (PLACEHOLDER) ===
        exportarPDF(datos) {
            // Esta función requeriría una librería como jsPDF
            this.mostrarMensaje('⚠️ Exportación PDF en desarrollo', 'warning');
            
            console.log('📄 Exportación PDF solicitada para:', datos.length, 'registros');
            
            // Alternativa: Imprimir la página
            if (confirm('La exportación PDF está en desarrollo. ¿Desea imprimir la página en su lugar?')) {
                this.imprimirMapa();
            }
        },

        // === IMPRIMIR MAPA ===
        imprimirMapa() {
            // Preparar estilos de impresión
            const stylesImpresion = `
                @media print {
                    .no-print { display: none !important; }
                    .map-container { 
                        width: 100% !important; 
                        height: 100vh !important; 
                    }
                    #map { 
                        width: 100% !important; 
                        height: 100% !important; 
                    }
                }
            `;
            
            // Agregar estilos temporales
            const styleElement = document.createElement('style');
            styleElement.textContent = stylesImpresion;
            document.head.appendChild(styleElement);
            
            // Agregar clase no-print a elementos que no deben imprimirse
            document.querySelectorAll('.sidebar, .top-bar, .stats-container, .stats-overlay').forEach(el => {
                el.classList.add('no-print');
            });
            
            // Imprimir
            window.print();
            
            // Limpiar después de imprimir
            setTimeout(() => {
                styleElement.remove();
                document.querySelectorAll('.no-print').forEach(el => {
                    el.classList.remove('no-print');
                });
            }, 1000);
            
            console.log('🖨️ Impresión iniciada');
        },

        // === COMPARTIR MAPA ===
        compartirMapa() {
            const urlActual = window.location.href;
            const titulo = 'GM Solutions - Mapa de Clientes';
            const texto = `Mapa interactivo con ${window.clientesData?.length || 0} clientes`;
            
            // Si el navegador soporta Web Share API
            if (navigator.share) {
                navigator.share({
                    title: titulo,
                    text: texto,
                    url: urlActual
                }).then(() => {
                    console.log('✅ Compartido exitosamente');
                    this.mostrarMensaje('✅ Compartido exitosamente', 'success');
                }).catch((error) => {
                    console.error('Error al compartir:', error);
                    this.copiarAlPortapapeles(urlActual);
                });
            } else {
                // Fallback: copiar al portapapeles
                this.copiarAlPortapapeles(urlActual);
            }
        },

        // === COPIAR AL PORTAPAPELES ===
        copiarAlPortapapeles(texto) {
            if (navigator.clipboard && window.isSecureContext) {
                navigator.clipboard.writeText(texto).then(() => {
                    this.mostrarMensaje('📋 URL copiada al portapapeles', 'success');
                    console.log('📋 Copiado al portapapeles');
                }).catch(err => {
                    console.error('Error al copiar:', err);
                    this.copiarConFallback(texto);
                });
            } else {
                // Fallback para navegadores antiguos
                this.copiarConFallback(texto);
            }
        },

        // === COPIAR CON FALLBACK ===
        copiarConFallback(texto) {
            const textArea = document.createElement('textarea');
            textArea.value = texto;
            textArea.style.position = 'fixed';
            textArea.style.left = '-999999px';
            textArea.style.top = '-999999px';
            document.body.appendChild(textArea);
            textArea.focus();
            textArea.select();
            
            try {
                document.execCommand('copy');
                this.mostrarMensaje('📋 URL copiada al portapapeles', 'success');
                console.log('📋 Copiado con fallback');
            } catch (err) {
                this.mostrarMensaje('❌ No se pudo copiar la URL', 'error');
                console.error('Error al copiar con fallback:', err);
            } finally {
                textArea.remove();
            }
        },

        // === DESCARGAR ARCHIVO ===
        descargarArchivo(url, nombreArchivo) {
            const link = document.createElement('a');
            link.href = url;
            link.download = nombreArchivo;
            link.style.display = 'none';
            
            document.body.appendChild(link);
            link.click();
            
            // Limpiar
            setTimeout(() => {
                document.body.removeChild(link);
                URL.revokeObjectURL(url);
            }, 100);
        },

        // === MOSTRAR MENSAJE ===
        mostrarMensaje(mensaje, tipo = 'info') {
            if (window.NotificationSystem) {
                window.NotificationSystem.mostrar(mensaje, tipo);
            } else {
                if (tipo === 'error') {
                    console.error(mensaje);
                } else {
                    console.log(mensaje);
                }
            }
        },

        // === EVENT LISTENERS ===
        configurarEventListeners() {
            // Atajo Ctrl+E para exportar
            document.addEventListener('keydown', (e) => {
                if (e.ctrlKey && e.key === 'e') {
                    e.preventDefault();
                    this.mostrarMenuExportacion();
                }
                
                // Ctrl+P para imprimir
                if (e.ctrlKey && e.key === 'p') {
                    e.preventDefault();
                    this.imprimirMapa();
                }
            });
        },

        // === MOSTRAR MENÚ EXPORTACIÓN ===
        mostrarMenuExportacion() {
            const formato = prompt(
                'Seleccione formato de exportación:\n' +
                '1 - CSV\n' +
                '2 - JSON\n' +
                '3 - Excel\n' +
                '4 - PDF\n\n' +
                'Ingrese el número de opción:'
            );
            
            const formatos = {
                '1': 'CSV',
                '2': 'JSON',
                '3': 'Excel',
                '4': 'PDF'
            };
            
            if (formatos[formato]) {
                this.exportarDatos(formatos[formato]);
            } else if (formato) {
                this.mostrarMensaje('Opción no válida', 'warning');
            }
        },

        // === API PÚBLICA ===
        getFormatosDisponibles() {
            return [...this.formatosDisponibles];
        },

        exportar(formato = 'CSV') {
            this.exportarDatos(formato);
        }
    };

    // === EXPORTAR FUNCIONES GLOBALES (compatibilidad) ===
    window.exportarDatos = () => ExportTools.mostrarMenuExportacion();
    window.imprimirMapa = () => ExportTools.imprimirMapa();
    window.compartirMapa = () => ExportTools.compartirMapa();
    
    // === EXPORTAR MÓDULO ===
    window.ExportTools = ExportTools;
    
})(window);