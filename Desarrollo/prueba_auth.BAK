* Ejemplo de uso de la clase GmailOAuth
* ===============================================
DEBUG
SUSPEND 

* 1. Crear instancia de la clase OAuth
oGmail = CREATEOBJECT("GmailOAuth")

* 2. Configurar credenciales de Google Cloud Console
* (Necesitas crear un proyecto en Google Cloud Console y obtener estas credenciales)
oGmail.ClientId = "428863134595-931enbonq1f3hcuho23p0jocr9p37jcp.apps.googleusercontent.com"
oGmail.ClientSecret = "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"
oGmail.RedirectUri = "http://localhost:8080"  && O la URI que hayas configurado

* 3. Intentar cargar tokens guardados
IF oGmail.LoadTokens()
    MESSAGEBOX("Tokens cargados correctamente")
ELSE
    * Si no hay tokens guardados, iniciar proceso de autorización
    MESSAGEBOX("Necesitas autorizar la aplicación. Se abrirá el navegador.")
    
    * Generar URL de autorización y abrir browser
    lcAuthUrl = oGmail.GetAuthorizationUrl()
    
    * El usuario debe autorizar en el browser y copiar el código
    lcAuthCode = INPUTBOX("Introduce el código de autorización:", "OAuth Code")
    
    IF !EMPTY(lcAuthCode)
        IF oGmail.ExchangeCodeForTokens(lcAuthCode)
            MESSAGEBOX("Autorización exitosa!")
        ELSE
            MESSAGEBOX("Error en la autorización")
            RETURN
        ENDIF
    ELSE
        MESSAGEBOX("Autorización cancelada")
        RETURN
    ENDIF
ENDIF

* ===============================================
* EJEMPLOS DE USO
* ===============================================

* Ejemplo 1: Obtener lista de mensajes
MESSAGEBOX("Obteniendo mensajes...")
loMessages = oGmail.GetMessages("", 5)  && Últimos 5 mensajes

IF !ISNULL(loMessages) AND !ISNULL(loMessages.messages)
    LOCAL i, lcMessageId, loMessage
    
    FOR i = 0 TO loMessages.messages.length - 1
        lcMessageId = loMessages.messages.item(i).id
        
        * Obtener detalles del mensaje
        loMessage = oGmail.GetMessage(lcMessageId)
        
        IF !ISNULL(loMessage)
            * Mostrar información básica
            ? "ID: " + lcMessageId
            ? "Snippet: " + loMessage.snippet
            ? "-------------------"
        ENDIF
    ENDFOR
ELSE
    MESSAGEBOX("No se pudieron obtener los mensajes")
ENDIF

* Ejemplo 2: Enviar un email
lcTo = INPUTBOX("Enviar email a:", "Destinatario", "ejemplo@gmail.com")
lcSubject = INPUTBOX("Asunto:", "Subject", "Prueba desde VFP")
lcBody = INPUTBOX("Mensaje:", "Body", "Este es un mensaje de prueba desde Visual FoxPro")

IF !EMPTY(lcTo) AND !EMPTY(lcSubject)
    loResult = oGmail.SendEmail(lcTo, lcSubject, lcBody)
    
    IF !ISNULL(loResult)
        MESSAGEBOX("Email enviado correctamente! ID: " + loResult.id)
    ELSE
        MESSAGEBOX("Error al enviar email")
    ENDIF
ENDIF

* Ejemplo 3: Buscar emails específicos
loSearchResult = oGmail.GetMessages("from:ejemplo@gmail.com", 10)

IF !ISNULL(loSearchResult)
    MESSAGEBOX("Encontrados " + TRANSFORM(loSearchResult.resultSizeEstimate) + " mensajes")
ENDIF

* ===============================================
* FUNCIONES AUXILIARES PARA EL EJEMPLO
* ===============================================

* Función para mostrar headers de un mensaje
FUNCTION ShowMessageHeaders(loMessage)
    LOCAL i, loHeader
    
    IF !ISNULL(loMessage.payload.headers)
        ? "=== HEADERS ==="
        FOR i = 0 TO loMessage.payload.headers.length - 1
            loHeader = loMessage.payload.headers.item(i)
            ? loHeader.name + ": " + loHeader.value
        ENDFOR
    ENDIF
ENDFUNC

* Función para extraer texto plano del mensaje
FUNCTION GetMessageText(loMessage)
    LOCAL lcText
    lcText = ""
    
    IF !ISNULL(loMessage.payload.body.data)
        * Decodificar base64
        lcText = DecodeBase64(loMessage.payload.body.data)
    ENDIF
    
    RETURN lcText
ENDFUNC

* Función para decodificar base64
FUNCTION DecodeBase64(lcBase64)
    LOCAL loXML, loElement
    
    TRY
        loXML = CREATEOBJECT("MSXML2.DOMDocument")
        loElement = loXML.createElement("tmp")
        loElement.DataType = "bin.base64"
        loElement.Text = lcBase64
        
        RETURN STRCONV(loElement.NodeTypedValue, 2)
    CATCH
        RETURN ""
    ENDTRY
ENDFUNC