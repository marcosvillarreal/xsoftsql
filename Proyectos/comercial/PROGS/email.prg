LOCAL loCfg, loMsg, lcFile, loErr
TRY
  loCfg = CREATEOBJECT("CDO.Configuration")
  WITH loCfg.Fields
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "smtp.gmail.com"
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") =  465
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    .Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "marcosevillarreal"
    .Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "la603atalaya"
    .Update
  ENDWITH
   WITH loCfg.Fields
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = .T.
    .Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = .T.
    .Update
  ENDWITH
  loMsg = CREATEOBJECT ("CDO.Message")
  WITH loMsg
    .Configuration = loCfg
    *-- Remitenete y destinatarios
    .From = "marcoevillarreal@gmail.com"
    .To = "m.villarreal.8310@gmail.com"
    .Cc = "Usuario Dos <user2@gmail.com>"
    *- Notificación de lectura
    .Fields("urn:schemas:mailheader:disposition-notification-to") = .From
    .Fields("urn:schemas:mailheader:return-receipt-to") = .From
    .Fields.Update
    *-- Tema
    .Subject = "Ejemplo del " + TTOC(DATETIME())
    *-- Formato HTML desde la Web
    *.CreateMHTMLBody("http://comunidadvfp.blogspot.com/p/acerca-de.html", 0)
    .TextBody = "Hola Mundo"
    lcFile = "J:\remito_troque2.pdf"
    *-- Archivo adjunto
*!*	    lcFile = GETFILE()
*!*	    IF NOT EMPTY(lcFile)
      .AddAttachment(lcFile)
*!*	    ENDIF
    *-- Envio el mensaje
    .Send()
  ENDWITH
CATCH TO loErr 
  MESSAGEBOX("No se pudo enviar el mensaje" + CHR(13) + ;
    "Error: " + TRANSFORM(loErr.ErrorNo) + CHR(13) + ;
    "Mensaje: " + loErr.Message , 16, "Error")
FINALLY
  loMsg = NULL
  loCfg = NULL
ENDTRY