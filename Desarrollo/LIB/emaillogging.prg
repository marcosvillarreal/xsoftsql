* =========================================================================
*                           EMAILSENDER LOGGING MODULE
*                    Sistema de Logging Avanzado para EmailSender
* =========================================================================
*
* DESCRIPCIÓN:
*   Módulo independiente para manejo de logs con múltiples niveles,
*   rotación automática, estadísticas y gestión avanzada.
*
* UBICACIÓN DE LOGS:
*   addbs(Sys(5)+curdir())+'\Logs\EmailSender'
*
* AUTOR: EmailSender Project
* FECHA: 2025
* =========================================================================

* =========================================================================
* VARIABLES PÚBLICAS DEL MÓDULO DE LOGGING
* =========================================================================

PUBLIC gcLogBasePath, gcLogPath, gcLogFile, glLogEnabled, gcLogLevel
PUBLIC gcSessionId, glLogToConsole, gnMaxLogSizeMB, gcLogModuleVersion

* =========================================================================
* INICIALIZACIÓN DEL SISTEMA DE LOGGING
* =========================================================================

FUNCTION InitEmailLogging()
    * Información del módulo

    STOP()

    
    gcLogModuleVersion = "EmailLogging v2.0"
    
    * Configuración de logging
    gcLogBasePath = ADDBS(SYS(5) + CURDIR()) + "Logs\EmailSender"
    gcLogPath = gcLogBasePath
    gcSessionId = "EmailSender_" + DTOS(DATE()) + "_" + STRTRAN(TIME(), ":", "")
    gcLogFile = gcLogPath + "\" + gcSessionId + ".log"
    glLogEnabled = .T.
    gcLogLevel = "INFO"  && TRACE, DEBUG, INFO, WARN, ERROR, FATAL
    glLogToConsole = .T.
    gnMaxLogSizeMB = 10  && Tamaño máximo por archivo de log
    
    * Crear estructura de directorios
    IF !DIRECTORY(gcLogBasePath)
        CreateLogDirectories()
    ENDIF
    
    * Inicializar archivo de log
    WriteEmailLog("SYSTEM", "=== EmailSender Logging Module Started ===")
    WriteEmailLog("SYSTEM", "Module Version: " + gcLogModuleVersion)
    WriteEmailLog("SYSTEM", "Session ID: " + gcSessionId)
    WriteEmailLog("SYSTEM", "Log File: " + gcLogFile)
    WriteEmailLog("SYSTEM", "Timestamp: " + TTOC(DATETIME()))
    WriteEmailLog("SYSTEM", "Log Directory: " + gcLogPath)
    
    IF glLogToConsole
        ? "📄 " + gcLogModuleVersion + " inicializado:"
        ? "   📁 Directorio: " + gcLogPath
        ? "   📄 Archivo: " + JUSTFNAME(gcLogFile)
        ? "   🔧 Nivel: " + gcLogLevel
    ENDIF
    
    RETURN .T.
ENDFUNC

* =========================================================================
* CREACIÓN DE DIRECTORIOS DE LOG
* =========================================================================

FUNCTION CreateLogDirectories()
    LOCAL lcPath, lnPos, lcPartialPath, llSuccess
    
    TRY
        * Crear directorio base paso a paso
        lcPath = gcLogBasePath
        lcPartialPath = ""
        llSuccess = .T.
        
        * Separar por backslashes y crear cada nivel
        FOR lnPos = 1 TO OCCURS("\", lcPath)
            lcPartialPath = LEFT(lcPath, AT("\", lcPath, lnPos))
            IF !DIRECTORY(lcPartialPath) AND LEN(lcPartialPath) > 3
                MD (lcPartialPath)
                IF !DIRECTORY(lcPartialPath)
                    llSuccess = .F.
                    EXIT
                ENDIF
            ENDIF
        ENDFOR
        
        * Crear directorio final si no existe
        IF llSuccess AND !DIRECTORY(gcLogBasePath)
            MD (gcLogBasePath)
            llSuccess = DIRECTORY(gcLogBasePath)
        ENDIF
        
        IF llSuccess
            WriteEmailLog("SYSTEM", "Directorio de logs creado exitosamente: " + gcLogBasePath)
            RETURN .T.
        ELSE
            THROW "No se pudo crear el directorio de logs"
        ENDIF
        
    CATCH TO loError
        * Fallback a directorio temporal
        gcLogPath = "C:\TEMP\EmailSender"
        IF !DIRECTORY("C:\TEMP")
            MD "C:\TEMP"
        ENDIF
        IF !DIRECTORY(gcLogPath)
            MD (gcLogPath)
        ENDIF
        gcLogFile = gcLogPath + "\" + gcSessionId + ".log"
        
        IF glLogToConsole
            ? "⚠️ Error creando directorio principal, usando fallback:"
            ? "   📁 " + gcLogPath
            ? "   ❌ Error: " + loError.Message
        ENDIF
        
        RETURN .F.
    ENDTRY
ENDFUNC

* =========================================================================
* FUNCIÓN PRINCIPAL DE ESCRITURA DE LOGS - WriteEmailLog()
* =========================================================================

FUNCTION WriteEmailLog(tcLevel, tcMessage, tcFunction)
    LOCAL lcLogEntry, lnHandle, lcTimestamp, lcFullMessage, llSuccess
    
    * Verificar si logging está habilitado
    IF TYPE("glLogEnabled") = "U" OR !glLogEnabled
        RETURN .F.
    ENDIF
    
    * Verificar nivel de log
    IF !IsLogLevelEnabled(tcLevel)
        RETURN .F.
    ENDIF
    
    * Preparar timestamp en formato ISO
    lcTimestamp = TTOC(DATETIME(), 1)
    
    * Preparar mensaje completo
    lcFullMessage = tcMessage
    IF !EMPTY(tcFunction)
        lcFullMessage = "[" + tcFunction + "] " + lcFullMessage
    ENDIF
    
    * Formatear entrada de log con estructura estándar
    lcLogEntry = "[" + lcTimestamp + "] [" + PADR(tcLevel, 5) + "] " + lcFullMessage + CHR(13) + CHR(10)
    
    * Escribir a consola si está habilitado
    IF glLogToConsole AND tcLevel != "TRACE"
        DisplayLogToConsole(tcLevel, lcFullMessage)
    ENDIF
    
    * Escribir a archivo
    llSuccess = WriteLogToFile(lcLogEntry)
    
    RETURN llSuccess
ENDFUNC

* =========================================================================
* FUNCIONES AUXILIARES DE LOGGING
* =========================================================================

FUNCTION DisplayLogToConsole(tcLevel, tcMessage)
    LOCAL lcIcon, lcDisplayMessage
    
    * Seleccionar icono según el nivel
    DO CASE
        CASE tcLevel = "ERROR" OR tcLevel = "FATAL"
            lcIcon = "❌"
        CASE tcLevel = "WARN"
            lcIcon = "⚠️"
        CASE tcLevel = "INFO"
            lcIcon = "ℹ️"
        CASE tcLevel = "DEBUG"
            lcIcon = "🔧"
        CASE tcLevel = "SYSTEM"
            lcIcon = "⚙️"
        OTHERWISE
            lcIcon = "📝"
    ENDCASE
    
    * Truncar mensaje si es muy largo
    lcDisplayMessage = LEFT(tcMessage, 120)
    IF LEN(tcMessage) > 120
        lcDisplayMessage = lcDisplayMessage + "..."
    ENDIF
    
    ? lcIcon + " " + lcDisplayMessage
ENDFUNC

FUNCTION WriteLogToFile(tcLogEntry)
    LOCAL lnHandle, llSuccess
    
    TRY
        * Verificar tamaño del archivo antes de escribir
        IF FILE(gcLogFile) AND (FSIZE(gcLogFile) / 1048576) > gnMaxLogSizeMB
            RotateLogFile()
        ENDIF
        
        * Abrir archivo para escritura
        lnHandle = FOPEN(gcLogFile, 2)  && Modo lectura/escritura
        IF lnHandle = -1
            * Crear archivo si no existe
            lnHandle = FCREATE(gcLogFile)
        ELSE
            * Ir al final del archivo
            FSEEK(lnHandle, 0, 2)
        ENDIF
        
        IF lnHandle > 0
            * Escribir entrada de log
            FWRITE(lnHandle, tcLogEntry)
            FCLOSE(lnHandle)
            llSuccess = .T.
        ELSE
            llSuccess = .F.
        ENDIF
        
    CATCH TO loError
        * Error silencioso en logging para evitar loops infinitos
        IF glLogToConsole
            ? "⚠️ Error escribiendo log: " + loError.Message
        ENDIF
        llSuccess = .F.
    ENDTRY
    
    RETURN llSuccess
ENDFUNC

* =========================================================================
* GESTIÓN DE NIVELES DE LOG
* =========================================================================

FUNCTION IsLogLevelEnabled(tcLevel)
    LOCAL ARRAY laLevels[6]
    LOCAL lnCurrentLevel, lnRequestLevel
    
    * Definir niveles de log en orden de prioridad (menor a mayor)
    laLevels[1] = "TRACE"
    laLevels[2] = "DEBUG"
    laLevels[3] = "INFO"
    laLevels[4] = "WARN"
    laLevels[5] = "ERROR"
    laLevels[6] = "FATAL"
    
    * Encontrar posición del nivel actual y solicitado
    lnCurrentLevel = ASCAN(laLevels, gcLogLevel)
    lnRequestLevel = ASCAN(laLevels, tcLevel)
    
    * SYSTEM siempre se registra
    IF tcLevel = "SYSTEM"
        RETURN .T.
    ENDIF
    
    * Si no encuentra el nivel, permitir por defecto
    IF lnCurrentLevel = 0 OR lnRequestLevel = 0
        RETURN .T.
    ENDIF
    
    * Solo registrar si el nivel solicitado es mayor o igual al actual
    RETURN lnRequestLevel >= lnCurrentLevel
ENDFUNC

FUNCTION SetLogLevel(tcNewLevel)
    LOCAL ARRAY laValidLevels[6], lcOldLevel
    
    laValidLevels[1] = "TRACE"
    laValidLevels[2] = "DEBUG"
    laValidLevels[3] = "INFO"
    laValidLevels[4] = "WARN"
    laValidLevels[5] = "ERROR"
    laValidLevels[6] = "FATAL"
    
    IF ASCAN(laValidLevels, UPPER(tcNewLevel)) > 0
        lcOldLevel = gcLogLevel
        gcLogLevel = UPPER(tcNewLevel)
        WriteEmailLog("SYSTEM", "Nivel de log cambiado de " + lcOldLevel + " a " + gcLogLevel, "SetLogLevel")
        IF glLogToConsole
            ? "✅ Nivel de log cambiado a: " + gcLogLevel
        ENDIF
        RETURN .T.
    ELSE
        WriteEmailLog("ERROR", "Nivel de log inválido: " + tcNewLevel, "SetLogLevel")
        IF glLogToConsole
            ? "❌ Nivel inválido. Válidos: TRACE, DEBUG, INFO, WARN, ERROR, FATAL"
        ENDIF
        RETURN .F.
    ENDIF
ENDFUNC

* =========================================================================
* ROTACIÓN DE ARCHIVOS DE LOG
* =========================================================================

FUNCTION RotateLogFile()
    LOCAL lcBackupFile, lnCounter, llSuccess
    
    * Encontrar nombre de archivo backup disponible
    lnCounter = 1
    DO WHILE .T.
        lcBackupFile = STRTRAN(gcLogFile, ".log", "_" + PADL(lnCounter, 3, "0") + ".log")
        IF !FILE(lcBackupFile)
            EXIT
        ENDIF
        lnCounter = lnCounter + 1
        IF lnCounter > 999
            * Usar timestamp si llegamos al límite
            lcBackupFile = STRTRAN(gcLogFile, ".log", "_" + DTOS(DATE()) + "_" + STRTRAN(TIME(), ":", "") + ".log")
            EXIT
        ENDIF
    ENDDO
    
    TRY
        * Copiar archivo actual como backup
        COPY FILE (gcLogFile) TO (lcBackupFile)
        DELETE FILE (gcLogFile)
        
        WriteEmailLog("SYSTEM", "Log rotado exitosamente. Backup: " + JUSTFNAME(lcBackupFile))
        IF glLogToConsole
            ? "🔄 Log rotado: " + JUSTFNAME(lcBackupFile)
        ENDIF
        llSuccess = .T.
        
    CATCH TO loError
        WriteEmailLog("ERROR", "Error rotando log: " + loError.Message)
        llSuccess = .F.
    ENDTRY
    
    RETURN llSuccess
ENDFUNC

* =========================================================================
* LOGGING ESPECIALIZADO PARA EVENTOS DE EMAIL
* =========================================================================

FUNCTION LogEmailEvent(tcEvent, tcDetails, tcStatus, tcRecipient)
    LOCAL lcMessage, lcLevel
    
    * Construir mensaje estructurado
    lcMessage = "EMAIL_EVENT: " + tcEvent
    IF !EMPTY(tcRecipient)
        lcMessage = lcMessage + " | TO: " + tcRecipient
    ENDIF
    IF !EMPTY(tcStatus)
        lcMessage = lcMessage + " | STATUS: " + tcStatus
    ENDIF
    IF !EMPTY(tcDetails)
        lcMessage = lcMessage + " | DETAILS: " + LEFT(tcDetails, 200)
    ENDIF
    
    * Determinar nivel según el status
    DO CASE
        CASE tcStatus = "SUCCESS" OR tcStatus = "SENT"
            lcLevel = "INFO"
        CASE tcStatus = "ERROR" OR tcStatus = "FAILED"
            lcLevel = "ERROR"
        CASE tcStatus = "WARNING" OR tcStatus = "RETRY"
            lcLevel = "WARN"
        OTHERWISE
            lcLevel = "INFO"
    ENDCASE
    
    WriteEmailLog(lcLevel, lcMessage, "EMAIL")
ENDFUNC

FUNCTION LogSystemEvent(tcEvent, tcDetails)
    WriteEmailLog("SYSTEM", "SYSTEM_EVENT: " + tcEvent + " | " + tcDetails, "SYSTEM")
ENDFUNC

FUNCTION LogErrorEvent(tcFunction, tcError, tcDetails)
    LOCAL lcMessage
    lcMessage = "ERROR_EVENT: " + tcFunction + " | ERROR: " + tcError
    IF !EMPTY(tcDetails)
        lcMessage = lcMessage + " | DETAILS: " + tcDetails
    ENDIF
    WriteEmailLog("ERROR", lcMessage, tcFunction)
ENDFUNC

* =========================================================================
* FUNCIONES DE ANÁLISIS Y ESTADÍSTICAS DE LOGS
* =========================================================================

FUNCTION ShowLogSummary()
    WriteEmailLog("INFO", "Generando resumen de logs", "ShowLogSummary")
    
    ? "📊 RESUMEN DE LOGS - " + gcLogModuleVersion
    ? "=================================================="
    ? "📁 Directorio: " + gcLogPath
    ? "📄 Archivo actual: " + JUSTFNAME(gcLogFile)
    ? "🕒 Sesión: " + gcSessionId
    ? "📏 Tamaño: " + IIF(FILE(gcLogFile), TRANSFORM(FSIZE(gcLogFile)) + " bytes", "0 bytes")
    ? "🔧 Nivel: " + gcLogLevel
    ? "✅ Estado: " + IIF(glLogEnabled, "Activo", "Inactivo")
    ? "🖥️ Console: " + IIF(glLogToConsole, "Habilitado", "Deshabilitado")
    ? "📦 Rotación: " + TRANSFORM(gnMaxLogSizeMB) + " MB"
    
    IF FILE(gcLogFile)
        AnalyzeLogFile()
    ELSE
        ? ""
        ? "⚠️ Archivo de log no existe"
    ENDIF
ENDFUNC

FUNCTION AnalyzeLogFile()
    LOCAL lnHandle, lcContent, ARRAY laLines[1], lnLines
    LOCAL lnErrors, lnWarnings, lnInfo, lnDebug, lnSystem, lnEmails
    
    lnHandle = FOPEN(gcLogFile)
    IF lnHandle > 0
        lcContent = FREAD(lnHandle, FSIZE(gcLogFile))
        FCLOSE(lnHandle)
        
        lnLines = ALINES(laLines, lcContent)
        ? ""
        ? "📝 Líneas totales: " + TRANSFORM(lnLines)
        
        * Inicializar contadores
        lnErrors = 0
        lnWarnings = 0
        lnInfo = 0
        lnDebug = 0
        lnSystem = 0
        lnEmails = 0
        
        * Analizar cada línea
        FOR lnI = 1 TO lnLines
            IF "[ERROR]" $ laLines[lnI]
                lnErrors = lnErrors + 1
            ENDIF
            IF "[WARN]" $ laLines[lnI]
                lnWarnings = lnWarnings + 1
            ENDIF
            IF "[INFO]" $ laLines[lnI]
                lnInfo = lnInfo + 1
            ENDIF
            IF "[DEBUG]" $ laLines[lnI]
                lnDebug = lnDebug + 1
            ENDIF
            IF "[SYSTEM]" $ laLines[lnI]
                lnSystem = lnSystem + 1
            ENDIF
            IF "EMAIL_EVENT:" $ laLines[lnI]
                lnEmails = lnEmails + 1
            ENDIF
        ENDFOR
        
        ? ""
        ? "📈 ESTADÍSTICAS POR NIVEL:"
        ? "   🔧 Debug: " + TRANSFORM(lnDebug)
        ? "   ℹ️ Info: " + TRANSFORM(lnInfo)
        ? "   ⚠️ Advertencias: " + TRANSFORM(lnWarnings)
        ? "   ❌ Errores: " + TRANSFORM(lnErrors)
        ? "   ⚙️ Sistema: " + TRANSFORM(lnSystem)
        ? ""
        ? "📧 EVENTOS DE EMAIL: " + TRANSFORM(lnEmails)
        
        * Mostrar estadísticas adicionales
        ShowLogStatistics(laLines, lnLines)
    ENDIF
ENDFUNC

FUNCTION ShowLogStatistics(laLines, lnTotalLines)
    LOCAL lnSent, lnFailed, lnRetries, lcFirstEntry, lcLastEntry
    
    * Contar eventos específicos de email
    lnSent = 0
    lnFailed = 0
    lnRetries = 0
    
    FOR lnI = 1 TO lnTotalLines
        IF "EMAIL_EVENT:" $ laLines[lnI]
            IF "STATUS: SUCCESS" $ laLines[lnI] OR "STATUS: SENT" $ laLines[lnI]
                lnSent = lnSent + 1
            ENDIF
            IF "STATUS: ERROR" $ laLines[lnI] OR "STATUS: FAILED" $ laLines[lnI]
                lnFailed = lnFailed + 1
            ENDIF
            IF "STATUS: RETRY" $ laLines[lnI]
                lnRetries = lnRetries + 1
            ENDIF
        ENDIF
    ENDFOR
    
    * Obtener timestamps de primera y última entrada
    IF lnTotalLines > 0
        lcFirstEntry = SUBSTR(laLines[1], 2, 19)  && Extraer timestamp
        lcLastEntry = SUBSTR(laLines[lnTotalLines], 2, 19)
    ENDIF
    
    ? ""
    ? "📊 ANÁLISIS DE EMAILS:"
    ? "   ✅ Enviados: " + TRANSFORM(lnSent)
    ? "   ❌ Fallidos: " + TRANSFORM(lnFailed)
    ? "   🔄 Reintentos: " + TRANSFORM(lnRetries)
    
    IF !EMPTY(lcFirstEntry) AND !EMPTY(lcLastEntry)
        ? ""
        ? "⏰ PERÍODO:"
        ? "   Inicio: " + lcFirstEntry
        ? "   Fin: " + lcLastEntry
    ENDIF
ENDFUNC

* =========================================================================
* FUNCIONES DE VISUALIZACIÓN DE LOGS
* =========================================================================

FUNCTION ShowLastLogEntries(tnLines)
    LOCAL lnLinesToShow
    
    IF EMPTY(tnLines) OR tnLines <= 0
        lnLinesToShow = 10
    ELSE
        lnLinesToShow = tnLines
    ENDIF
    
    WriteEmailLog("DEBUG", "Mostrando últimas " + TRANSFORM(lnLinesToShow) + " líneas del log", "ShowLastLogEntries")
    
    TRY
        IF FILE(gcLogFile)
            DisplayLogEntries(lnLinesToShow)
        ELSE
            ? "❌ Archivo de log no existe: " + gcLogFile
        ENDIF
        
    CATCH TO loError
        WriteEmailLog("ERROR", "Error leyendo log: " + loError.Message, "ShowLastLogEntries")
        ? "❌ Error leyendo log: " + loError.Message
    ENDTRY
ENDFUNC

FUNCTION DisplayLogEntries(tnLines)
    LOCAL lnHandle, lcContent, ARRAY laLines[1], lnLines, lnStart
    
    ? "📄 ÚLTIMAS " + TRANSFORM(tnLines) + " LÍNEAS DEL LOG"
    ? "============================================"
    
    lnHandle = FOPEN(gcLogFile)
    IF lnHandle > 0
        lcContent = FREAD(lnHandle, FSIZE(gcLogFile))
        FCLOSE(lnHandle)
        
        lnLines = ALINES(laLines, lcContent)
        lnStart = MAX(1, lnLines - tnLines + 1)
        
        FOR lnI = lnStart TO lnLines
            * Colorear líneas según el nivel
            LOCAL lcLine, lcPrefix
            lcLine = laLines[lnI]
            lcPrefix = ""
            
            IF "[ERROR]" $ lcLine
                lcPrefix = "❌ "
            ENDIF
            IF "[WARN]" $ lcLine
                lcPrefix = "⚠️ "
            ENDIF
            IF "[INFO]" $ lcLine
                lcPrefix = "ℹ️ "
            ENDIF
            IF "[DEBUG]" $ lcLine
                lcPrefix = "🔧 "
            ENDIF
            IF "[SYSTEM]" $ lcLine
                lcPrefix = "⚙️ "
            ENDIF
            
            ? lcPrefix + lcLine
        ENDFOR
        
        ? "============================================"
    ENDIF
ENDFUNC

* =========================================================================
* FUNCIONES DE GESTIÓN DE LOGS
* =========================================================================

FUNCTION ClearEmailLogs()
    LOCAL lcChoice, lcBackupFile
    
    WriteEmailLog("WARN", "Solicitud de limpieza de logs", "ClearEmailLogs")
    
    lcChoice = INPUT("¿Limpiar todos los logs? (s/n): ")
    
    IF UPPER(lcChoice) = "S"
        TRY
            * Hacer backup del log actual
            lcBackupFile = STRTRAN(gcLogFile, ".log", "_backup_" + DTOS(DATE()) + "_" + STRTRAN(TIME(), ":", "") + ".log")
            
            IF FILE(gcLogFile)
                COPY FILE (gcLogFile) TO (lcBackupFile)
                WriteEmailLog("SYSTEM", "Backup creado antes de limpiar: " + lcBackupFile, "ClearEmailLogs")
                DELETE FILE (gcLogFile)
            ENDIF
            
            * Reinicializar logging
            InitEmailLogging()
            WriteEmailLog("SYSTEM", "Logs reinicializados por solicitud del usuario", "ClearEmailLogs")
            
            ? "✅ Logs limpiados y reinicializados"
            ? "📄 Backup guardado como: " + JUSTFNAME(lcBackupFile)
            
        CATCH TO loError
            WriteEmailLog("ERROR", "Error limpiando logs: " + loError.Message, "ClearEmailLogs")
            ? "❌ Error limpiando logs: " + loError.Message
        ENDTRY
    ELSE
        WriteEmailLog("INFO", "Limpieza de logs cancelada por usuario", "ClearEmailLogs")
        ? "ℹ️ Operación cancelada"
    ENDIF
ENDFUNC

* =========================================================================
* FUNCIONES DE CONFIGURACIÓN Y UTILIDADES
* =========================================================================

FUNCTION GetLogPath()
    RETURN gcLogPath
ENDFUNC

FUNCTION GetCurrentLogFile()
    RETURN gcLogFile
ENDFUNC

FUNCTION IsLoggingEnabled()
    RETURN glLogEnabled
ENDFUNC

FUNCTION EnableLogging()
    glLogEnabled = .T.
    WriteEmailLog("SYSTEM", "Logging habilitado por usuario")
    ? "✅ Logging habilitado"
ENDFUNC

FUNCTION DisableLogging()
    WriteEmailLog("SYSTEM", "Logging deshabilitado por usuario")
    glLogEnabled = .F.
    ? "⚠️ Logging deshabilitado"
ENDFUNC

FUNCTION ToggleConsoleLogging()
    glLogToConsole = !glLogToConsole
    WriteEmailLog("SYSTEM", "Console logging " + IIF(glLogToConsole, "habilitado", "deshabilitado"))
    ? IIF(glLogToConsole, "✅ Console logging habilitado", "⚠️ Console logging deshabilitado")
ENDFUNC

FUNCTION GetLogModuleInfo()
    LOCAL lcInfo
    lcInfo = gcLogModuleVersion + " | Estado: " + IIF(glLogEnabled, "Activo", "Inactivo")
    lcInfo = lcInfo + " | Nivel: " + gcLogLevel + " | Archivo: " + JUSTFNAME(gcLogFile)
    RETURN lcInfo
ENDFUNC

* =========================================================================
* MENSAJE DE CARGA DEL MÓDULO
* =========================================================================

? "📄 " + gcLogModuleVersion + " cargado"
? "   📁 Ubicación de logs: addbs(Sys(5)+curdir())+'\Logs\EmailSender'"
? "   🔧 Funciones disponibles: WriteEmailLog(), LogEmailEvent(), ShowLogSummary()"