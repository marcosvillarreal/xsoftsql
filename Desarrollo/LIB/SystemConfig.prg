* =========================================================================
*                           SYSTEM CONFIGURATION MODULE
*                    Módulo de Configuración del Sistema EmailSender
* =========================================================================
*
* DESCRIPCIÓN:
*   Módulo independiente para manejo de configuración, variables de sistema,
*   validación de entorno y gestión de ajustes persistentes.
*
* DEPENDENCIAS:
*   - EmailLogging.prg (para logging)
*
* AUTOR: EmailSender Project
* FECHA: 2025
* =========================================================================

* =========================================================================
* VARIABLES PÚBLICAS DEL MÓDULO DE CONFIGURACIÓN
* =========================================================================

PUBLIC gcConfigModuleVersion, gcConfigFile, goConfig

* =========================================================================
* INICIALIZACIÓN DEL MÓDULO DE CONFIGURACIÓN
* =========================================================================

FUNCTION InitSystemConfig()
    * Información del módulo
    gcConfigModuleVersion = "SystemConfig v2.0"
    gcConfigFile = ADDBS(SYS(5) + CURDIR()) + "emailsender_config.json"
    
    * Crear objeto de configuración
    goConfig = CREATEOBJECT("Empty")
    
    * Cargar configuración por defecto
    LoadDefaultConfiguration()
    
    * Intentar cargar configuración guardada
    LoadSavedConfiguration()
    
    WriteEmailLog("SYSTEM", "Módulo de configuración inicializado: " + gcConfigModuleVersion, "InitSystemConfig")
    
    ? "⚙️ " + gcConfigModuleVersion + " cargado"
    ? "   📄 Archivo config: " + JUSTFNAME(gcConfigFile)
    ? "   🔧 Variables del sistema configuradas"
    
    RETURN .T.
ENDFUNC

* =========================================================================
* CONFIGURACIÓN POR DEFECTO
* =========================================================================

FUNCTION LoadDefaultConfiguration()
    * Configuración del servidor DLL
    ADDPROPERTY(goConfig, "DLLServerURL", "http://localhost:8081")
    ADDPROPERTY(goConfig, "DLLExecutable", "EmailSenderDLL.exe")
    ADDPROPERTY(goConfig, "DLLTimeout", 30)
    ADDPROPERTY(goConfig, "DLLMaxRetries", 3)
    
    * Configuración de logging
    ADDPROPERTY(goConfig, "LogLevel", "INFO")
    ADDPROPERTY(goConfig, "LogToConsole", .T.)
    ADDPROPERTY(goConfig, "LogMaxSizeMB", 10)
    ADDPROPERTY(goConfig, "LogRetentionDays", 30)
    
    * Configuración de email
    ADDPROPERTY(goConfig, "DefaultProvider", "gmail")
    ADDPROPERTY(goConfig, "EmailTimeout", 60)
    ADDPROPERTY(goConfig, "MaxEmailRetries", 2)
    
    * Configuración del sistema
    ADDPROPERTY(goConfig, "SystemVersion", "EmailSender Modular v3.0")
    ADDPROPERTY(goConfig, "DebugMode", .T.)
    ADDPROPERTY(goConfig, "TempDirectory", "C:\TEMP")
    ADDPROPERTY(goConfig, "AutoStartServer", .T.)
    
    * Configuración de directorios
    ADDPROPERTY(goConfig, "ProjectPath", ADDBS(SYS(5) + CURDIR()))
    ADDPROPERTY(goConfig, "LogPath", ADDBS(SYS(5) + CURDIR()) + "Logs\EmailSender")
    ADDPROPERTY(goConfig, "AttachmentsPath", ADDBS(SYS(5) + CURDIR()) + "attachments")
    
    WriteEmailLog("DEBUG", "Configuración por defecto cargada", "LoadDefaultConfiguration")
ENDFUNC

* =========================================================================
* GESTIÓN DE ARCHIVOS DE CONFIGURACIÓN
* =========================================================================

FUNCTION LoadSavedConfiguration()
    IF FILE(gcConfigFile)
        TRY
            LOCAL lnHandle, lcConfigData
            lnHandle = FOPEN(gcConfigFile)
            IF lnHandle > 0
                lcConfigData = FREAD(lnHandle, FSIZE(gcConfigFile))
                FCLOSE(lnHandle)
                
                ParseConfigFromJSON(lcConfigData)
                
                WriteEmailLog("INFO", "Configuración cargada desde archivo", "LoadSavedConfiguration")
                ? "✅ Configuración cargada desde: " + JUSTFNAME(gcConfigFile)
            ENDIF
            
        CATCH TO loError
            WriteEmailLog("WARN", "Error cargando configuración: " + loError.Message, "LoadSavedConfiguration")
            ? "⚠️ Error cargando config, usando valores por defecto"
        ENDTRY
    ELSE
        WriteEmailLog("DEBUG", "Archivo de configuración no existe, usando valores por defecto", "LoadSavedConfiguration")
    ENDIF
ENDFUNC

FUNCTION SaveConfiguration()
    LOCAL lcConfigJSON, lnHandle, llSuccess
    
    TRY
        lcConfigJSON = GenerateConfigJSON()
        
        lnHandle = FCREATE(gcConfigFile)
        IF lnHandle > 0
            FWRITE(lnHandle, lcConfigJSON)
            FCLOSE(lnHandle)
            llSuccess = .T.
            WriteEmailLog("INFO", "Configuración guardada en archivo", "SaveConfiguration")
            ? "✅ Configuración guardada"
        ELSE
            llSuccess = .F.
            WriteEmailLog("ERROR", "No se pudo crear archivo de configuración", "SaveConfiguration")
        ENDIF
        
    CATCH TO loError
        llSuccess = .F.
        WriteEmailLog("ERROR", "Error guardando configuración: " + loError.Message, "SaveConfiguration")
    ENDTRY
    
    RETURN llSuccess
ENDFUNC

* =========================================================================
* VALIDACIÓN DEL ENTORNO
* =========================================================================

FUNCTION ValidateEnvironment()
    LOCAL lnTests, lnPassed, llResult, lnPercentage
    
    WriteEmailLog("INFO", "Iniciando validación del entorno", "ValidateEnvironment")
    
    lnTests = 0
    lnPassed = 0
    
    ? "🔍 VALIDACIÓN DEL ENTORNO"
    ? "========================"
    
    * Test 1: Directorio del proyecto
    lnTests = lnTests + 1
    IF DIRECTORY(goConfig.ProjectPath)
        ? "✅ Directorio del proyecto: " + goConfig.ProjectPath
        lnPassed = lnPassed + 1
    ELSE
        ? "❌ Directorio del proyecto no existe: " + goConfig.ProjectPath
    ENDIF
    
    * Test 2: Ejecutable DLL
    lnTests = lnTests + 1
    IF FILE(goConfig.DLLExecutable)
        ? "✅ Ejecutable DLL encontrado: " + goConfig.DLLExecutable
        lnPassed = lnPassed + 1
    ELSE
        ? "❌ Ejecutable DLL no encontrado: " + goConfig.DLLExecutable
    ENDIF
    
    * Test 3: Directorio temporal
    lnTests = lnTests + 1
    IF DIRECTORY(goConfig.TempDirectory)
        ? "✅ Directorio temporal: " + goConfig.TempDirectory
        lnPassed = lnPassed + 1
    ELSE
        ? "❌ Directorio temporal no existe: " + goConfig.TempDirectory
        TRY
            MD (goConfig.TempDirectory)
            IF DIRECTORY(goConfig.TempDirectory)
                ? "✅ Directorio temporal creado"
                lnPassed = lnPassed + 1
            ENDIF
        CATCH
            ? "❌ No se pudo crear directorio temporal"
        ENDTRY
    ENDIF
    
    * Test 4: Directorio de logs
    lnTests = lnTests + 1
    IF DIRECTORY(goConfig.LogPath)
        ? "✅ Directorio de logs: " + goConfig.LogPath
        lnPassed = lnPassed + 1
    ELSE
        ? "⚠️ Directorio de logs no existe, se creará automáticamente"
        lnPassed = lnPassed + 0.5
    ENDIF
    
    * Test 5: Permisos de escritura
    lnTests = lnTests + 1
    LOCAL lcTestFile
    lcTestFile = goConfig.ProjectPath + "test_write.tmp"
    TRY
        LOCAL lnHandle
        lnHandle = FCREATE(lcTestFile)
        IF lnHandle > 0
            FCLOSE(lnHandle)
            DELETE FILE (lcTestFile)
            ? "✅ Permisos de escritura OK"
            lnPassed = lnPassed + 1
        ELSE
            ? "❌ Sin permisos de escritura en directorio del proyecto"
        ENDIF
    CATCH
        ? "❌ Error verificando permisos de escritura"
    ENDTRY
    
    * Calcular resultado
    lnPercentage = (lnPassed / lnTests) * 100
    
    ? ""
    ? "📊 RESULTADO DE VALIDACIÓN:"
    ? "Tests pasados: " + TRANSFORM(lnPassed) + "/" + TRANSFORM(lnTests)
    ? "Porcentaje: " + TRANSFORM(lnPercentage, "999.9") + "%"
    
    llResult = lnPercentage >= 80
    
    IF llResult
        ? "✅ Entorno válido para operar"
        WriteEmailLog("INFO", "Validación del entorno exitosa (" + TRANSFORM(lnPercentage, "999.9") + "%)", "ValidateEnvironment")
    ELSE
        ? "⚠️ Entorno requiere correcciones"
        WriteEmailLog("WARN", "Validación del entorno con problemas (" + TRANSFORM(lnPercentage, "999.9") + "%)", "ValidateEnvironment")
    ENDIF
    
    RETURN llResult
ENDFUNC

* =========================================================================
* FUNCIONES DE ACCESO A CONFIGURACIÓN
* =========================================================================

FUNCTION GetConfigValue(tcKey, tcDefault)
    LOCAL lcValue
    
    TRY
        lcValue = EVALUATE("goConfig." + tcKey)
        IF TYPE("lcValue") = "U" OR EMPTY(lcValue)
            lcValue = tcDefault
        ENDIF
    CATCH
        lcValue = tcDefault
        WriteEmailLog("DEBUG", "Clave de configuración no encontrada: " + tcKey, "GetConfigValue")
    ENDTRY
    
    RETURN lcValue
ENDFUNC

FUNCTION SetConfigValue(tcKey, tcValue)
    LOCAL llSuccess
    
    TRY
        IF TYPE("goConfig." + tcKey) != "U"
            goConfig.&tcKey = tcValue
        ELSE
            ADDPROPERTY(goConfig, tcKey, tcValue)
        ENDIF
        
        llSuccess = .T.
        WriteEmailLog("DEBUG", "Configuración actualizada: " + tcKey + " = " + TRANSFORM(tcValue), "SetConfigValue")
        
    CATCH TO loError
        llSuccess = .F.
        WriteEmailLog("ERROR", "Error actualizando configuración: " + loError.Message, "SetConfigValue")
    ENDTRY
    
    RETURN llSuccess
ENDFUNC

* =========================================================================
* PARSEO SIMPLE DE JSON
* =========================================================================

FUNCTION ParseConfigFromJSON(tcJSON)
    TRY
        LOCAL lcValue
        
        lcValue = ExtractJSONValue(tcJSON, "DLLServerURL")
        IF !EMPTY(lcValue)
            goConfig.DLLServerURL = lcValue
        ENDIF
        
        lcValue = ExtractJSONValue(tcJSON, "LogLevel")
        IF !EMPTY(lcValue)
            goConfig.LogLevel = lcValue
        ENDIF
        
        lcValue = ExtractJSONValue(tcJSON, "DebugMode")
        IF !EMPTY(lcValue)
            goConfig.DebugMode = (UPPER(lcValue) = "TRUE")
        ENDIF
        
        lcValue = ExtractJSONValue(tcJSON, "LogToConsole")
        IF !EMPTY(lcValue)
            goConfig.LogToConsole = (UPPER(lcValue) = "TRUE")
        ENDIF
        
        WriteEmailLog("DEBUG", "Configuración parseada desde JSON", "ParseConfigFromJSON")
        
    CATCH TO loError
        WriteEmailLog("WARN", "Error parseando JSON: " + loError.Message, "ParseConfigFromJSON")
    ENDTRY
ENDFUNC

FUNCTION ExtractJSONValue(tcJSON, tcKey)
    LOCAL lnStart, lnEnd, lcValue
    
    lnStart = AT('"' + tcKey + '":', tcJSON)
    IF lnStart > 0
        lnStart = AT(':', tcJSON, lnStart) + 1
        
        DO WHILE SUBSTR(tcJSON, lnStart, 1) = ' '
            lnStart = lnStart + 1
        ENDDO
        
        IF SUBSTR(tcJSON, lnStart, 1) = '"'
            lnStart = lnStart + 1
            lnEnd = AT('"', tcJSON, lnStart)
            lcValue = SUBSTR(tcJSON, lnStart, lnEnd - lnStart)
        ELSE
            lnEnd = MIN(AT(',', tcJSON, lnStart), AT('}', tcJSON, lnStart))
            IF lnEnd = 0
                lnEnd = LEN(tcJSON) + 1
            ENDIF
            lcValue = ALLTRIM(SUBSTR(tcJSON, lnStart, lnEnd - lnStart))
            lcValue = STRTRAN(lcValue, ',', '')
        ENDIF
    ELSE
        lcValue = ""
    ENDIF
    
    RETURN lcValue
ENDFUNC

FUNCTION GenerateConfigJSON()
    LOCAL lcJSON
    
    lcJSON = '{' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "SystemVersion": "' + goConfig.SystemVersion + '",' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "DLLServerURL": "' + goConfig.DLLServerURL + '",' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "DLLExecutable": "' + goConfig.DLLExecutable + '",' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "DLLTimeout": ' + TRANSFORM(goConfig.DLLTimeout) + ',' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "LogLevel": "' + goConfig.LogLevel + '",' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "LogToConsole": ' + IIF(goConfig.LogToConsole, 'true', 'false') + ',' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "LogMaxSizeMB": ' + TRANSFORM(goConfig.LogMaxSizeMB) + ',' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "DefaultProvider": "' + goConfig.DefaultProvider + '",' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "DebugMode": ' + IIF(goConfig.DebugMode, 'true', 'false') + ',' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "AutoStartServer": ' + IIF(goConfig.AutoStartServer, 'true', 'false') + ',' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "ProjectPath": "' + goConfig.ProjectPath + '",' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '  "LogPath": "' + goConfig.LogPath + '"' + CHR(13) + CHR(10)
    lcJSON = lcJSON + '}' + CHR(13) + CHR(10)
    
    RETURN lcJSON
ENDFUNC

* =========================================================================
* FUNCIONES UTILITARIAS
* =========================================================================

FUNCTION ShowSystemConfiguration()
    ? "⚙️ CONFIGURACIÓN DEL SISTEMA"
    ? "============================="
    ? "Sistema: " + goConfig.SystemVersion
    ? "DLL Server: " + goConfig.DLLServerURL
    ? "Ejecutable: " + goConfig.DLLExecutable
    ? "Timeout: " + TRANSFORM(goConfig.DLLTimeout) + "s"
    ? "Log Level: " + goConfig.LogLevel
    ? "Debug Mode: " + IIF(goConfig.DebugMode, "✅ ON", "❌ OFF")
    ? "Console Log: " + IIF(goConfig.LogToConsole, "✅ ON", "❌ OFF")
    ? "Provider: " + goConfig.DefaultProvider
    ? ""
    ? "📁 DIRECTORIOS:"
    ? "Proyecto: " + goConfig.ProjectPath
    ? "Logs: " + goConfig.LogPath
    ? "Temporal: " + goConfig.TempDirectory
    ? "Adjuntos: " + goConfig.AttachmentsPath
ENDFUNC

FUNCTION GetConfigModuleInfo()
    LOCAL lcInfo
    lcInfo = gcConfigModuleVersion + " | Config: " + JUSTFNAME(gcConfigFile)
    lcInfo = lcInfo + " | Validation: " + IIF(ValidateEnvironment(), "OK", "ISSUES")
    RETURN lcInfo
ENDFUNC

FUNCTION ResetToDefaults()
    LOCAL lcChoice
    
    lcChoice = INPUT("¿Restaurar configuración por defecto? (s/n): ")
    
    IF UPPER(lcChoice) = "S"
        LoadDefaultConfiguration()
        SaveConfiguration()
        WriteEmailLog("INFO", "Configuración restaurada a valores por defecto", "ResetToDefaults")
        ? "✅ Configuración restaurada a valores por defecto"
        RETURN .T.
    ELSE
        ? "ℹ️ Operación cancelada"
        RETURN .F.
    ENDIF
ENDFUNC

* =========================================================================
* INICIALIZACIÓN AUTOMÁTICA
* =========================================================================

IF TYPE("gcConfigModuleVersion") = "U"
    InitSystemConfig()
ENDIF

* =========================================================================
* MENSAJE DE CARGA DEL MÓDULO
* =========================================================================

? "⚙️ " + gcConfigModuleVersion + " cargado"
? "   🔧 Funciones: GetConfigValue(), SetConfigValue(), ValidateEnvironment()"