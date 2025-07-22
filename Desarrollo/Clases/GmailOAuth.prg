* Clase para manejar OAuth 2.0 con Gmail desde Visual FoxPro
DEFINE CLASS GmailOAuth AS Custom

    * Propiedades para configuración OAuth
    ClientId = ""
    ClientSecret = ""
    RedirectUri = "http://localhost:8080"
    Scope = "https://www.googleapis.com/auth/gmail.readonly https://www.googleapis.com/auth/gmail.send"
    
    * URLs de Google OAuth
    AuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
    TokenUrl = "https://oauth2.googleapis.com/token"
    
    * Tokens
    AccessToken = ""
    RefreshToken = ""
    ExpiresIn = 0
    TokenType = "Bearer"
    
    * Objeto HTTP para realizar peticiones
    oHTTP = NULL
    
    FUNCTION Init()
        * Crear objeto HTTP
        THIS.oHTTP = CREATEOBJECT("MSXML2.ServerXMLHTTP.6.0")
        IF ISNULL(THIS.oHTTP)
            THIS.oHTTP = CREATEOBJECT("MSXML2.XMLHTTP")
        ENDIF
        RETURN !ISNULL(THIS.oHTTP)
    ENDFUNC
    
    * Paso 1: Generar URL de autorización
    FUNCTION GetAuthorizationUrl(lcState)
        LOCAL lcUrl, lcParams
        
        IF EMPTY(lcState)
            lcState = SYS(2015) && Generar estado aleatorio
        ENDIF
        
        lcParams = "response_type=code" + ;
                   "&client_id=" + THIS.UrlEncode(THIS.ClientId) + ;
                   "&redirect_uri=" + THIS.UrlEncode(THIS.RedirectUri) + ;
                   "&scope=" + THIS.UrlEncode(THIS.Scope) + ;
                   "&state=" + THIS.UrlEncode(lcState) + ;
                   "&access_type=offline" + ;
                   "&prompt=consent"
        
        lcUrl = THIS.AuthUrl + "?" + lcParams
        
        * Abrir browser con la URL de autorización
        THIS.OpenBrowser(lcUrl)
        
        RETURN lcUrl
    ENDFUNC
    
    * Paso 2: Intercambiar código por tokens
    FUNCTION ExchangeCodeForTokens(lcCode)
        LOCAL lcPostData, lcResponse, loJson
        
        IF EMPTY(lcCode)
            RETURN .F.
        ENDIF
        
        * Preparar datos POST
        lcPostData = "grant_type=authorization_code" + ;
                     "&code=" + THIS.UrlEncode(lcCode) + ;
                     "&client_id=" + THIS.UrlEncode(THIS.ClientId) + ;
                     "&client_secret=" + THIS.UrlEncode(THIS.ClientSecret) + ;
                     "&redirect_uri=" + THIS.UrlEncode(THIS.RedirectUri)
        
        * Realizar petición POST
        TRY
            THIS.oHTTP.Open("POST", THIS.TokenUrl, .F.)
            THIS.oHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
            THIS.oHTTP.Send(lcPostData)
            
            IF THIS.oHTTP.Status = 200
                lcResponse = THIS.oHTTP.ResponseText
                
                * Parsear respuesta JSON
                loJson = THIS.ParseJson(lcResponse)
                IF !ISNULL(loJson)
                    THIS.AccessToken = loJson.access_token
                    THIS.RefreshToken = loJson.refresh_token
                    THIS.ExpiresIn = loJson.expires_in
                    THIS.TokenType = loJson.token_type
                    
                    * Guardar tokens para uso futuro
                    THIS.SaveTokens()
                    
                    RETURN .T.
                ENDIF
            ELSE
                MESSAGEBOX("Error al obtener tokens: " + THIS.oHTTP.ResponseText, 16)
            ENDIF
            
        CATCH TO loError
            MESSAGEBOX("Error en petición: " + loError.Message, 16)
        ENDTRY
        
        RETURN .F.
    ENDFUNC
    
    * Refrescar access token usando refresh token
    FUNCTION RefreshAccessToken()
        LOCAL lcPostData, lcResponse, loJson
        
        IF EMPTY(THIS.RefreshToken)
            RETURN .F.
        ENDIF
        
        lcPostData = "grant_type=refresh_token" + ;
                     "&refresh_token=" + THIS.UrlEncode(THIS.RefreshToken) + ;
                     "&client_id=" + THIS.UrlEncode(THIS.ClientId) + ;
                     "&client_secret=" + THIS.UrlEncode(THIS.ClientSecret)
        
        TRY
            THIS.oHTTP.Open("POST", THIS.TokenUrl, .F.)
            THIS.oHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
            THIS.oHTTP.Send(lcPostData)
            
            IF THIS.oHTTP.Status = 200
                lcResponse = THIS.oHTTP.ResponseText
                loJson = THIS.ParseJson(lcResponse)
                
                IF !ISNULL(loJson)
                    THIS.AccessToken = loJson.access_token
                    THIS.ExpiresIn = loJson.expires_in
                    THIS.TokenType = loJson.token_type
                    
                    THIS.SaveTokens()
                    RETURN .T.
                ENDIF
            ENDIF
            
        CATCH TO loError
            MESSAGEBOX("Error al refrescar token: " + loError.Message, 16)
        ENDTRY
        
        RETURN .F.
    ENDFUNC
    
    * Realizar petición autorizada a Gmail API
    FUNCTION MakeAuthorizedRequest(lcUrl, lcMethod, lcData)
        LOCAL lcResponse
        
        IF EMPTY(THIS.AccessToken)
            RETURN NULL
        ENDIF
        
        TRY
            THIS.oHTTP.Open(lcMethod, lcUrl, .F.)
            THIS.oHTTP.setRequestHeader("Authorization", THIS.TokenType + " " + THIS.AccessToken)
            
            IF !EMPTY(lcData)
                THIS.oHTTP.setRequestHeader("Content-Type", "application/json")
                THIS.oHTTP.Send(lcData)
            ELSE
                THIS.oHTTP.Send()
            ENDIF
            
            IF THIS.oHTTP.Status = 200
                lcResponse = THIS.oHTTP.ResponseText
                RETURN THIS.ParseJson(lcResponse)
            ELSE
                * Si el token expiró, intentar refrescarlo
                IF THIS.oHTTP.Status = 401 AND THIS.RefreshAccessToken()
                    RETURN THIS.MakeAuthorizedRequest(lcUrl, lcMethod, lcData)
                ENDIF
                
                MESSAGEBOX("Error en petición: " + THIS.oHTTP.ResponseText, 16)
            ENDIF
            
        CATCH TO loError
            MESSAGEBOX("Error: " + loError.Message, 16)
        ENDTRY
        
        RETURN NULL
    ENDFUNC
    
    * Obtener lista de mensajes
    FUNCTION GetMessages(lcQuery, lnMaxResults)
        LOCAL lcUrl, loResponse
        
        IF EMPTY(lnMaxResults)
            lnMaxResults = 10
        ENDIF
        
        lcUrl = "https://gmail.googleapis.com/gmail/v1/users/me/messages"
        lcUrl = lcUrl + "?maxResults=" + TRANSFORM(lnMaxResults)
        
        IF !EMPTY(lcQuery)
            lcUrl = lcUrl + "&q=" + THIS.UrlEncode(lcQuery)
        ENDIF
        
        loResponse = THIS.MakeAuthorizedRequest(lcUrl, "GET", "")
        RETURN loResponse
    ENDFUNC
    
    * Obtener detalles de un mensaje específico
    FUNCTION GetMessage(lcMessageId)
        LOCAL lcUrl, loResponse
        
        IF EMPTY(lcMessageId)
            RETURN NULL
        ENDIF
        
        lcUrl = "https://gmail.googleapis.com/gmail/v1/users/me/messages/" + lcMessageId
        loResponse = THIS.MakeAuthorizedRequest(lcUrl, "GET", "")
        RETURN loResponse
    ENDFUNC
    
    * Enviar email
    FUNCTION SendEmail(lcTo, lcSubject, lcBody, lcFrom)
        LOCAL lcUrl, lcMessage, lcJsonData, loResponse
        
        * Construir mensaje en formato RFC 2822
        lcMessage = "To: " + lcTo + CHR(13) + CHR(10) + ;
                    "Subject: " + lcSubject + CHR(13) + CHR(10) + ;
                    CHR(13) + CHR(10) + ;
                    lcBody
        
        * Codificar en base64
        lcMessage = THIS.Base64Encode(lcMessage)
        
        * Crear JSON para envío
        lcJsonData = '{"raw":"' + lcMessage + '"}'
        
        lcUrl = "https://gmail.googleapis.com/gmail/v1/users/me/messages/send"
        loResponse = THIS.MakeAuthorizedRequest(lcUrl, "POST", lcJsonData)
        
        RETURN loResponse
    ENDFUNC
    
    * Funciones auxiliares
    FUNCTION UrlEncode(lcString)
        * Implementación básica de URL encoding
        LOCAL lcResult, i, lcChar, lnAsc
        lcResult = ""
        
        FOR i = 1 TO LEN(lcString)
            lcChar = SUBSTR(lcString, i, 1)
            lnAsc = ASC(lcChar)
            
            DO CASE
                CASE ISALPHA(lcChar) OR ISDIGIT(lcChar) OR INLIST(lcChar, "-", "_", ".", "~")
                    lcResult = lcResult + lcChar
                OTHERWISE
                    lcResult = lcResult + "%" + RIGHT("0" + TRANSFORM(lnAsc, "@0"), 2)
            ENDCASE
        ENDFOR
        
        RETURN lcResult
    ENDFUNC
    
    FUNCTION Base64Encode(lcString)
        LOCAL loXML, loElement
        
        loXML = CREATEOBJECT("MSXML2.DOMDocument")
        loElement = loXML.createElement("tmp")
        loElement.DataType = "bin.base64"
        loElement.NodeTypedValue = STRCONV(lcString, 1)
        
        RETURN loElement.Text
    ENDFUNC
    
    FUNCTION ParseJson(lcJsonString)
        * Parser JSON simple para VFP
        LOCAL loScript, loJson
        
        TRY
            loScript = CREATEOBJECT("MSScriptControl.ScriptControl")
            loScript.Language = "JScript"
            loScript.AddCode("function parseJSON(json) { return eval('(' + json + ')'); }")
            
            loJson = loScript.Run("parseJSON", lcJsonString)
            RETURN loJson
            
        CATCH TO loError
            RETURN NULL
        ENDTRY
    ENDFUNC
    
    FUNCTION OpenBrowser(lcUrl)
        * Abrir URL en browser predeterminado
        DECLARE INTEGER ShellExecute IN shell32.dll ;
            INTEGER hWnd, STRING lpOperation, STRING lpFile, ;
            STRING lpParameters, STRING lpDirectory, INTEGER nShowCmd
        
        ShellExecute(0, "open", lcUrl, "", "", 1)
    ENDFUNC
    
    FUNCTION SaveTokens()
        * Guardar tokens en archivo o registro para uso futuro
        LOCAL lcTokenFile
        lcTokenFile = ADDBS(SYS(5) + SYS(2003)) + "gmail_tokens.txt"
        
        STRTOFILE(THIS.AccessToken + CHR(13) + CHR(10) + ;
                  THIS.RefreshToken + CHR(13) + CHR(10) + ;
                  TRANSFORM(THIS.ExpiresIn), lcTokenFile)
    ENDFUNC
    
    FUNCTION LoadTokens()
        * Cargar tokens guardados
        LOCAL lcTokenFile, lcContent, laLines[3]
        lcTokenFile = ADDBS(SYS(5) + SYS(2003)) + "gmail_tokens.txt"
        
        IF FILE(lcTokenFile)
            lcContent = FILETOSTR(lcTokenFile)
            ALINES(laLines, lcContent)
            
            IF ALEN(laLines) >= 3
                THIS.AccessToken = laLines[1]
                THIS.RefreshToken = laLines[2]
                THIS.ExpiresIn = VAL(laLines[3])
                RETURN .T.
            ENDIF
        ENDIF
        
        RETURN .F.
    ENDFUNC

ENDDEFINE