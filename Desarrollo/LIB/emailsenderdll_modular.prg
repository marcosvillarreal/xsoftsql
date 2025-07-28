* =========================================================================
*                EMAILSENDER DLL - FOXPRO INTERFACE MODULAR
*                   Compatible con Ejecutable Compilado + Módulos
* =========================================================================
*
* ARQUITECTURA MODULAR:
*   - EmailLogging.prg    : Sistema de logging avanzado
*   - EmailSender.prg     : Funciones de envío de emails
*   - HTTPRequests.prg    : Métodos de comunicación HTTP
*   - SystemInit.prg      : Inicialización del sistema
*
* AUTOR: EmailSender Project
* FECHA: 2025
* =========================================================================

* =========================================================================
* CARGA DE MÓDULOS
* =========================================================================

* Cargar módulo de logging
DO EmailLogging.prg

* =========================================================================
* INICIALIZACIÓN DEL SISTEMA PRINCIPAL
* =========================================================================

FUNCTION InitEmailSystemModular()
    * Inicializar logging primero
    InitEmailLogging()
    
    WriteEmailLog("SYSTEM", "Iniciando EmailSender con arquitectura modular", "InitEmailSystemModular")
    
    * Declarar variables del sistema principal
    PUBLIC gcDLLServerURL, gcPythonPath, gcProjectPath, glDLLServerRunning
    PUBLIC gcLastError, gcDebugMode, gcDLLExecutable, gcSystemVersion
    
    * Configuración del sistema
    gcSystemVersion = "EmailSender Modular v3.0"
    gcDLLServerURL = "http://localhost:8081"
    gcPythonPath = "python.exe"
    gcProjectPath = ADDBS(SYS(5) + SYS(2003))
    glDLLServerRunning = .F.
    gcLastError = ""
    gcDebugMode = .T.
    gcDLLExecutable = "EmailSenderDLL.exe"
    
    WriteEmailLog("INFO", "Variables del sistema configuradas", "InitEmailSystemModular")
    WriteEmailLog("DEBUG", "System Version: " + gcSystemVersion, "InitEmailSystemModular")
    WriteEmailLog("DEBUG", "DLL Server URL: " + gcDLLServerURL, "InitEmailSystemModular")
    WriteEmailLog("DEBUG", "Project Path: " + gcProjectPath, "InitEmailSystemModular")
    WriteEmailLog("DEBUG", "DLL Executable: " + gcDLLExecutable, "InitEmailSystemModular")
    
    * Crear directorio temporal
    IF !DIRECTORY("C:\TEMP")
        MD C:\TEMP
        WriteEmailLog("INFO", "Directorio temporal creado: C:\TEMP", "InitEmailSystemModular")
    ENDIF
    
    WriteEmailLog("SYSTEM", "Sistema modular inicializado correctamente", "InitEmailSystemModular")
    
    ? "✅ " + gcSystemVersion + " inicializado"
    ? "   Servidor DLL: " + gcDLLServerURL
    ? "   Ejecutable: " + gcDLLExecutable
    ? "   Directorio: " + gcProjectPath
    ? "   📄 " + GetLogModuleInfo()
    
    RETURN .T.
ENDFUNC

* =========================================================================
* FUNCIONES PRINCIPALES DE EMAIL (SIMPLIFICADAS)
* =========================================================================

FUNCTION EnviarEmailSimpleModular(tcEmail, tcAsunto, tcMensaje, tcProvider)
    LOCAL lcData, lcResult
    
    WriteEmailLog("INFO", "Iniciando envío de email", "EnviarEmailSimpleModular")
    LogEmailEvent("SEND_START", "Iniciando proceso de envío", "START", tcEmail)
    
    * Validar parámetros
    IF EMPTY(tcEmail) OR EMPTY(tcAsunto) OR EMPTY(tcMensaje)
        WriteEmailLog("ERROR", "Parámetros obligatorios faltantes", "EnviarEmailSimpleModular")
        LogEmailEvent("SEND_FAILED", "Parámetros obligatorios faltantes", "ERROR", tcEmail)
        ? "❌ Faltan parámetros obligatorios"
        RETURN '{"success": false, "message": "Parametros obligatorios faltantes"}'
    ENDIF
    
    WriteEmailLog("DEBUG", "Parámetros validados: Email=" + tcEmail + ", Asunto=" + LEFT(tcAsunto, 30), "EnviarEmailSimpleModular")
    
    * Configurar provider por defecto
    IF EMPTY(tcProvider)
        tcProvider = "gmail"
    ENDIF
    
    * Preparar datos JSON
    lcData = BuildJsonData(tcEmail, tcAsunto, tcMensaje, tcProvider)
    WriteEmailLog("DEBUG", "Datos JSON preparados para envío", "EnviarEmailSimpleModular")
    WriteEmailLog("TRACE", "JSON Data: " + LEFT(lcData, 200), "EnviarEmailSimpleModular")
    
    LogEmailEvent("SEND_REQUEST", "Enviando petición al servidor", "PROCESSING", tcEmail)
    ? "📧 Enviando email a: " + tcEmail
    
    * Simular envío (en implementación real se haría HTTP request)
    lcResult = SimulateEmailSend(tcEmail, tcAsunto)
    
    * Verificar y registrar resultado
    ProcessEmailResult(lcResult, tcEmail)
    
    RETURN lcResult
ENDFUNC

FUNCTION MenuPrincipalModular()
    LOCAL lnOpcion, llContinuar
    
    DEBUG 
    SUSPEND 
    
    WriteEmailLog("INFO", "Iniciando menú principal modular", "MenuPrincipalModular")
    
    * Asegurar inicialización
    IF TYPE("gcSystemVersion") = "U"
        InitEmailSystemModular()
    ENDIF
    
    llContinuar = .T.
    
    DO WHILE llContinuar
        TRY
            CLEAR
            ? "=========================================="
            ? "     EmailSender Modular v3.0"
            ? "=========================================="
            ? "1. 📧 Enviar email de prueba"
            ? "2. 📊 Ver resumen de logs"
            ? "3. 📝 Ver últimas líneas del log"
            ? "4. 🔧 Configurar nivel de log"
            ? "5. 🧹 Limpiar logs"
            ? "6. ❌ Salir"
            ? "=========================================="
            ? "📄 " + GetLogModuleInfo()
            ? ""
            
            lnOpcion = VAL(INPUT("Seleccione opción (1-6): "))
            WriteEmailLog("DEBUG", "Opción seleccionada: " + TRANSFORM(lnOpcion), "MenuPrincipalModular")
            
            ? ""
            
            DO CASE
                CASE lnOpcion = 1
                    LOCAL lcEmail, lcAsunto, lcMensaje, lcResult
                    lcEmail = INPUT("Email destinatario: ")
                    lcAsunto = INPUT("Asunto: ")
                    lcMensaje = INPUT("Mensaje: ")
                    
                    IF !EMPTY(lcEmail) AND !EMPTY(lcAsunto) AND !EMPTY(lcMensaje)
                        lcResult = EnviarEmailSimpleModular(lcEmail, lcAsunto, lcMensaje, "gmail")
                        ? ""
                        ? "Resultado: " + lcResult
                    ELSE
                        ? "❌ Todos los campos son obligatorios"
                    ENDIF
                    
                CASE lnOpcion = 2
                    ShowLogSummary()
                    
                CASE lnOpcion = 3
                    LOCAL lnLines
                    lnLines = VAL(INPUT("Número de líneas (default 10): "))
                    IF lnLines <= 0
                        lnLines = 10
                    ENDIF
                    ShowLastLogEntries(lnLines)
                    
                CASE lnOpcion = 4
                    LOCAL lcNewLevel
                    ? "Niveles: TRACE, DEBUG, INFO, WARN, ERROR, FATAL"
                    ? "Actual: " + gcLogLevel
                    lcNewLevel = INPUT("Nuevo nivel: ")
                    IF !EMPTY(lcNewLevel)
                        SetLogLevel(lcNewLevel)
                    ENDIF
                    
                CASE lnOpcion = 5
                    ClearEmailLogs()
                    
                CASE lnOpcion = 6
                    WriteEmailLog("SYSTEM", "=== EmailSender Session Ended ===")
                    llContinuar = .F.
                    
                OTHERWISE
                    ? "❌ Opción no válida (1-6)"
            ENDCASE
            
        CATCH TO loError
            WriteEmailLog("ERROR", "Error en menú: " + loError.Message, "MenuPrincipalModular")
            ? "❌ Error: " + loError.Message
        ENDTRY
        
        IF llContinuar
            ? ""
            ? "Presione Enter..."
            INKEY(0)
        ENDIF
    ENDDO
    
    ? "👋 ¡Hasta luego!"
ENDFUNC

* =========================================================================
* FUNCIONES AUXILIARES
* =========================================================================

FUNCTION BuildJsonData(tcEmail, tcAsunto, tcMensaje, tcProvider)
    LOCAL lcData
    lcData = '{"to_emails": "' + tcEmail + '", "subject": "' + tcAsunto + '", "message": "' + tcMensaje + '", "provider": "' + tcProvider + '"}'
    RETURN lcData
ENDFUNC

FUNCTION SimulateEmailSend(tcEmail, tcAsunto)
    WAIT "" TIMEOUT 1
    RETURN '{"success": true, "message": "Email enviado correctamente (simulado)"}'
ENDFUNC

FUNCTION ProcessEmailResult(tcResult, tcEmail)
    IF '"success": true' $ tcResult
        WriteEmailLog("INFO", "Email enviado a " + tcEmail, "ProcessEmailResult")
        LogEmailEvent("SEND_SUCCESS", "Email enviado", "SUCCESS", tcEmail)
        ? "✅ Email enviado exitosamente"
    ELSE
        WriteEmailLog("ERROR", "Error enviando a " + tcEmail, "ProcessEmailResult")
        LogEmailEvent("SEND_FAILED", "Error en envío", "ERROR", tcEmail)
        ? "❌ Error enviando email"
    ENDIF
ENDFUNC

* =========================================================================
* FUNCIONES DE COMPATIBILIDAD
* =========================================================================

FUNCTION EnviarEmailSimple(tcEmail, tcAsunto, tcMensaje)
    RETURN EnviarEmailSimpleModular(tcEmail, tcAsunto, tcMensaje, "gmail")
ENDFUNC

FUNCTION MenuPruebas()
    RETURN MenuPrincipalModular()
ENDFUNC

* =========================================================================
* INICIALIZACIÓN AUTOMÁTICA
* =========================================================================

IF TYPE("gcSystemVersion") = "U"
    InitEmailSystemModular()
ENDIF

* =========================================================================
* MENSAJE DE CARGA DEL SISTEMA MODULAR
* =========================================================================

? "📧 EmailSender Modular v3.0 - CARGADO"
? "====================================="
? "✅ Sistema modular implementado"
? "✅ Logging avanzado disponible"
? "📦 Módulo: modules\EmailLogging.prg"
? ""
? "🏁 Para empezar: MenuPrincipalModular()"