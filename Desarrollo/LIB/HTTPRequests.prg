* =========================================================================
*                           HTTP REQUESTS MODULE
*                    Módulo de Comunicación HTTP para EmailSender
* =========================================================================
*
* DESCRIPCIÓN:
*   Módulo independiente para manejo de peticiones HTTP con múltiples
*   métodos (COM, CURL), retry automático y logging integrado.
*
* DEPENDENCIAS:
*   - EmailLogging.prg (para logging)
*
* AUTOR: EmailSender Project
* FECHA: 2025
* =========================================================================

* =========================================================================
* VARIABLES PÚBLICAS DEL MÓDULO HTTP
* =========================================================================

PUBLIC gcHTTPModuleVersion, gnHTTPTimeout, gnMaxRetries, glHTTPDebug

* =========================================================================
* INICIALIZACIÓN DEL MÓDULO HTTP
* =========================================================================

FUNCTION InitHTTPModule()
    * Información del módulo
    gcHTTPModuleVersion = "HTTPRequests v2.0"
    gnHTTPTimeout = 30        && Timeout en segundos
    gnMaxRetries = 3          && Reintentos automáticos
    glHTTPDebug = .T.         && Debug habilitado
    
    WriteEmailLog("SYSTEM", "Módulo HTTP inicializado: " + gcHTTPModuleVersion, "InitHTTPModule")
    
    IF glHTTPDebug
        ? "🌐 " + gcHTTPModuleVersion + " cargado"
        ? "   ⏱️ Timeout: " + TRANSFORM(gnHTTPTimeout) + "s"
        ? "   🔄 Reintentos: " + TRANSFORM(gnMaxRetries)
    ENDIF
    
    RETURN .T.
ENDFUNC

* =========================================================================
* FUNCIÓN PRINCIPAL DE HTTP REQUESTS
* =========================================================================

FUNCTION SendHTTPRequest(tcMethod, tcURL, tcData, tcContentType)
    LOCAL lcResult, lnAttempt, llSuccess
    
    WriteEmailLog("INFO", "Iniciando HTTP Request: " + tcMethod + " " + tcURL, "SendHTTPRequest")
    
    * Validar parámetros
    IF EMPTY(tcMethod) OR EMPTY(tcURL)
        WriteEmailLog("ERROR", "Parámetros HTTP inválidos", "SendHTTPRequest")
        RETURN '{"success": false, "error": "Parámetros inválidos"}'
    ENDIF
    
    * Configurar content type por defecto
    IF EMPTY(tcContentType)
        tcContentType = "application/json"
    ENDIF
    
    * Preparar datos si no se proporcionan
    IF EMPTY(tcData)
        tcData = ""
    ENDIF
    
    * Intentar envío con reintentos
    llSuccess = .F.
    FOR lnAttempt = 1 TO gnMaxRetries
        WriteEmailLog("DEBUG", "Intento HTTP " + TRANSFORM(lnAttempt) + "/" + TRANSFORM(gnMaxRetries), "SendHTTPRequest")
        
        * Intentar COM primero
        lcResult = SendHTTPRequest_COM(tcMethod, tcURL, tcData, tcContentType)
        
        * Si COM falla, intentar CURL
        IF !IsHTTPSuccess(lcResult)
            WriteEmailLog("WARN", "COM falló, intentando CURL", "SendHTTPRequest")
            lcResult = SendHTTPRequest_CURL(tcMethod, tcURL, tcData, tcContentType)
        ENDIF
        
        * Verificar si fue exitoso
        IF IsHTTPSuccess(lcResult)
            llSuccess = .T.
            WriteEmailLog("INFO", "HTTP Request exitoso en intento " + TRANSFORM(lnAttempt), "SendHTTPRequest")
            EXIT
        ELSE
            WriteEmailLog("WARN", "HTTP Request falló, intento " + TRANSFORM(lnAttempt), "SendHTTPRequest")
            IF lnAttempt < gnMaxRetries
                WAIT "" TIMEOUT 2  && Esperar antes del siguiente intento
            ENDIF
        ENDIF
    ENDFOR
    
    IF !llSuccess
        WriteEmailLog("ERROR", "HTTP Request falló después de " + TRANSFORM(gnMaxRetries) + " intentos", "SendHTTPRequest")
    ENDIF
    
    RETURN lcResult
ENDFUNC

* =========================================================================
* IMPLEMENTACIÓN COM
* =========================================================================

FUNCTION SendHTTPRequest_COM(tcMethod, tcURL, tcData, tcContentType)
    LOCAL loHTTP, lcResult, lnWaitTime
    
    WriteEmailLog("DEBUG", "Enviando HTTP Request via COM", "SendHTTPRequest_COM")
    
    TRY
        loHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
        loHTTP.Open(tcMethod, tcURL, .F.)
        
        * Configurar headers
        IF tcMethod = "POST" OR tcMethod = "PUT" OR tcMethod = "PATCH"
            loHTTP.setRequestHeader("Content-Type", tcContentType)
            loHTTP.setRequestHeader("Accept", "application/json")
        ENDIF
        
        * Configurar timeout si es posible
        TRY
            loHTTP.setRequestHeader("Cache-Control", "no-cache")
        CATCH
            * Ignorar si no soporta este header
        ENDTRY
        
        * Enviar request
        WriteEmailLog("TRACE", "Enviando datos COM: " + LEFT(tcData, 100), "SendHTTPRequest_COM")
        loHTTP.Send(tcData)
        
        * Esperar respuesta con timeout
        lnWaitTime = 0
        DO WHILE loHTTP.readyState != 4 AND lnWaitTime < gnHTTPTimeout
            DOEVENTS
            WAIT "" TIMEOUT 0.5
            lnWaitTime = lnWaitTime + 0.5
        ENDDO
        
        * Procesar respuesta
        IF loHTTP.readyState = 4
            lcResult = ProcessHTTPResponse_COM(loHTTP)
        ELSE
            lcResult = '{"success": false, "error": "Timeout", "timeout": ' + TRANSFORM(gnHTTPTimeout) + '}'
            WriteEmailLog("ERROR", "Timeout COM después de " + TRANSFORM(lnWaitTime) + "s", "SendHTTPRequest_COM")
        ENDIF
        
    CATCH TO loError
        lcResult = '{"success": false, "error": "COM Error: ' + loError.Message + '"}'
        WriteEmailLog("ERROR", "Error COM: " + loError.Message, "SendHTTPRequest_COM")
    ENDTRY
    
    loHTTP = NULL
    RETURN lcResult
ENDFUNC

FUNCTION ProcessHTTPResponse_COM(loHTTP)
    LOCAL lcResult, lnStatus
    
    lnStatus = loHTTP.Status
    
    DO CASE
        CASE lnStatus >= 200 AND lnStatus < 300
            lcResult = BuildSuccessResponse(loHTTP.responseText, lnStatus)
            WriteEmailLog("DEBUG", "COM Response OK: " + TRANSFORM(lnStatus), "ProcessHTTPResponse_COM")
            
        CASE lnStatus >= 400 AND lnStatus < 500
            lcResult = BuildErrorResponse("Client Error", lnStatus, loHTTP.responseText)
            WriteEmailLog("WARN", "COM Client Error: " + TRANSFORM(lnStatus), "ProcessHTTPResponse_COM")
            
        CASE lnStatus >= 500
            lcResult = BuildErrorResponse("Server Error", lnStatus, loHTTP.responseText)
            WriteEmailLog("ERROR", "COM Server Error: " + TRANSFORM(lnStatus), "ProcessHTTPResponse_COM")
            
        OTHERWISE
            lcResult = BuildErrorResponse("Unknown Error", lnStatus, loHTTP.responseText)
            WriteEmailLog("ERROR", "COM Unknown Status: " + TRANSFORM(lnStatus), "ProcessHTTPResponse_COM")
    ENDCASE
    
    RETURN lcResult
ENDFUNC

* =========================================================================
* IMPLEMENTACIÓN CURL
* =========================================================================

FUNCTION SendHTTPRequest_CURL(tcMethod, tcURL, tcData, tcContentType)
    LOCAL lcCommand, lcTempFile, lcResult
    
    WriteEmailLog("DEBUG", "Enviando HTTP Request via CURL", "SendHTTPRequest_CURL")
    
    * Crear archivo temporal único
    lcTempFile = "C:\TEMP\http_" + SYS(3) + "_" + TRANSFORM(INT(RAND() * 1000)) + ".tmp"
    
    * Asegurar directorio temporal
    IF !DIRECTORY("C:\TEMP")
        MD C:\TEMP
    ENDIF
    
    TRY
        * Construir comando CURL
        lcCommand = BuildCURLCommand(tcMethod, tcURL, tcData, tcContentType, lcTempFile)
        
        WriteEmailLog("TRACE", "Comando CURL: " + LEFT(lcCommand, 150), "SendHTTPRequest_CURL")
        
        * Ejecutar comando
        RUN &lcCommand
        WAIT "" TIMEOUT 3
        
        * Leer respuesta
        lcResult = ReadCURLResponse(lcTempFile)
        
    CATCH TO loError
        lcResult = '{"success": false, "error": "CURL Error: ' + loError.Message + '"}'
        WriteEmailLog("ERROR", "Error CURL: " + loError.Message, "SendHTTPRequest_CURL")
    FINALLY
        * Limpiar archivo temporal
        IF FILE(lcTempFile)
            DELETE FILE (lcTempFile)
        ENDIF
    ENDTRY
    
    RETURN lcResult
ENDFUNC

FUNCTION BuildCURLCommand(tcMethod, tcURL, tcData, tcContentType, tcTempFile)
    LOCAL lcCommand
    
    * Comando base con timeout
    lcCommand = 'curl -s --max-time ' + TRANSFORM(gnHTTPTimeout) + ' '
    
    * Método HTTP
    IF tcMethod != "GET"
        lcCommand = lcCommand + '-X ' + tcMethod + ' '
    ENDIF
    
    * Headers
    lcCommand = lcCommand + '-H "Content-Type: ' + tcContentType + '" '
    lcCommand = lcCommand + '-H "Accept: application/json" '
    
    * Datos para POST/PUT/PATCH
    IF !EMPTY(tcData) AND (tcMethod = "POST" OR tcMethod = "PUT" OR tcMethod = "PATCH")
        * Escapar datos JSON
        LOCAL lcDataEscaped
        lcDataEscaped = STRTRAN(tcData, '"', '\"')
        lcDataEscaped = STRTRAN(lcDataEscaped, CHR(13), '')
        lcDataEscaped = STRTRAN(lcDataEscaped, CHR(10), '')
        lcCommand = lcCommand + '-d "' + lcDataEscaped + '" '
    ENDIF
    
    * URL y archivo de salida
    lcCommand = lcCommand + '"' + tcURL + '" > "' + tcTempFile + '"'
    
    RETURN lcCommand
ENDFUNC

FUNCTION ReadCURLResponse(tcTempFile)
    LOCAL lcResult, lnHandle
    
    IF FILE(tcTempFile) AND FSIZE(tcTempFile) > 0
        lnHandle = FOPEN(tcTempFile)
        IF lnHandle > 0
            lcResult = FREAD(lnHandle, FSIZE(tcTempFile))
            FCLOSE(lnHandle)
            
            * Si parece ser JSON válido, construir respuesta de éxito
            IF LEFT(LTRIM(lcResult), 1) = "{" OR LEFT(LTRIM(lcResult), 1) = "["
                lcResult = BuildSuccessResponse(lcResult, 200)
                WriteEmailLog("DEBUG", "CURL Response OK", "ReadCURLResponse")
            ELSE
                lcResult = BuildErrorResponse("Invalid Response", 0, lcResult)
                WriteEmailLog("WARN", "CURL respuesta inválida", "ReadCURLResponse")
            ENDIF
        ELSE
            lcResult = '{"success": false, "error": "No se pudo leer respuesta CURL"}'
            WriteEmailLog("ERROR", "Error leyendo archivo CURL", "ReadCURLResponse")
        ENDIF
    ELSE
        lcResult = '{"success": false, "error": "Respuesta CURL vacía"}'
        WriteEmailLog("WARN", "Respuesta CURL vacía", "ReadCURLResponse")
    ENDIF
    
    RETURN lcResult
ENDFUNC

* =========================================================================
* FUNCIONES UTILITARIAS
* =========================================================================

FUNCTION IsHTTPSuccess(tcResponse)
    RETURN '"success": true' $ tcResponse OR '"status": 200' $ tcResponse OR '"error"' $ tcResponse = .F.
ENDFUNC

FUNCTION BuildSuccessResponse(tcData, tnStatus)
    LOCAL lcResponse
    lcResponse = '{"success": true, "status": ' + TRANSFORM(tnStatus) + ', "data": '
    
    * Si ya es JSON, incluir directamente, sino como string
    IF LEFT(LTRIM(tcData), 1) = "{" OR LEFT(LTRIM(tcData), 1) = "["
        lcResponse = lcResponse + tcData
    ELSE
        lcResponse = lcResponse + '"' + tcData + '"'
    ENDIF
    
    lcResponse = lcResponse + ', "timestamp": "' + TTOC(DATETIME()) + '"}'
    RETURN lcResponse
ENDFUNC

FUNCTION BuildErrorResponse(tcError, tnStatus, tcDetails)
    LOCAL lcResponse
    lcResponse = '{"success": false, "error": "' + tcError + '", "status": ' + TRANSFORM(tnStatus)
    
    IF !EMPTY(tcDetails)
        lcResponse = lcResponse + ', "details": "' + LEFT(tcDetails, 200) + '"'
    ENDIF
    
    lcResponse = lcResponse + ', "timestamp": "' + TTOC(DATETIME()) + '"}'
    RETURN lcResponse
ENDFUNC

* =========================================================================
* FUNCIONES DE CONFIGURACIÓN
* =========================================================================

FUNCTION SetHTTPTimeout(tnSeconds)
    LOCAL lnOldTimeout
    lnOldTimeout = gnHTTPTimeout
    gnHTTPTimeout = MAX(5, MIN(300, tnSeconds))  && Entre 5 y 300 segundos
    
    WriteEmailLog("INFO", "HTTP Timeout cambiado de " + TRANSFORM(lnOldTimeout) + "s a " + TRANSFORM(gnHTTPTimeout) + "s", "SetHTTPTimeout")
    RETURN gnHTTPTimeout
ENDFUNC

FUNCTION SetHTTPRetries(tnRetries)
    LOCAL lnOldRetries
    lnOldRetries = gnMaxRetries
    gnMaxRetries = MAX(1, MIN(10, tnRetries))  && Entre 1 y 10 reintentos
    
    WriteEmailLog("INFO", "HTTP Reintentos cambiado de " + TRANSFORM(lnOldRetries) + " a " + TRANSFORM(gnMaxRetries), "SetHTTPRetries")
    RETURN gnMaxRetries
ENDFUNC

FUNCTION GetHTTPModuleInfo()
    LOCAL lcInfo
    lcInfo = gcHTTPModuleVersion + " | Timeout: " + TRANSFORM(gnHTTPTimeout) + "s"
    lcInfo = lcInfo + " | Reintentos: " + TRANSFORM(gnMaxRetries)
    lcInfo = lcInfo + " | Debug: " + IIF(glHTTPDebug, "ON", "OFF")
    RETURN lcInfo
ENDFUNC

* =========================================================================
* FUNCIONES ESPECIALIZADAS PARA EMAILSENDER
* =========================================================================

FUNCTION SendEmailServerRequest(tcEndpoint, tcData, tcBaseURL)
    LOCAL lcURL, lcResult
    
    * URL por defecto del servidor EmailSender
    IF EMPTY(tcBaseURL)
        tcBaseURL = "http://localhost:8081"
    ENDIF
    
    lcURL = tcBaseURL + tcEndpoint
    
    WriteEmailLog("INFO", "Enviando request al servidor EmailSender: " + tcEndpoint, "SendEmailServerRequest")
    
    lcResult = SendHTTPRequest("POST", lcURL, tcData, "application/json")
    
    * Log específico para requests del servidor de email
    IF IsHTTPSuccess(lcResult)
        WriteEmailLog("INFO", "Request EmailSender exitoso", "SendEmailServerRequest")
    ELSE
        WriteEmailLog("ERROR", "Request EmailSender falló", "SendEmailServerRequest")
    ENDIF
    
    RETURN lcResult
ENDFUNC

FUNCTION CheckServerStatus(tcBaseURL)
    LOCAL lcURL, lcResult
    
    IF EMPTY(tcBaseURL)
        tcBaseURL = "http://localhost:8081"
    ENDIF
    
    lcURL = tcBaseURL + "/status"
    
    WriteEmailLog("DEBUG", "Verificando estado del servidor: " + lcURL, "CheckServerStatus")
    
    lcResult = SendHTTPRequest("GET", lcURL, "", "application/json")
    
    RETURN IsHTTPSuccess(lcResult) AND '"running"' $ lcResult
ENDFUNC

* =========================================================================
* INICIALIZACIÓN AUTOMÁTICA
* =========================================================================

IF TYPE("gcHTTPModuleVersion") = "U"
    InitHTTPModule()
ENDIF

* =========================================================================
* MENSAJE DE CARGA DEL MÓDULO HTTP
* =========================================================================

? "🌐 " + gcHTTPModuleVersion + " cargado"
? "   🔧 Funciones: SendHTTPRequest(), SendEmailServerRequest(), CheckServerStatus()"