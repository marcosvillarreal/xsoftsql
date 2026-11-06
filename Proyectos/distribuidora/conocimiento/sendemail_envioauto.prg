*-- PROPUESTA 06/11/2026. Para pasar a mano. NO instalado ni probado con un envio real.
*-- Clase: sendemail de Desarrollo\clases\onegocio.vcx. Metodo nuevo: envioauto
*-- Requiere el campo ctacte.envioemailauto (ver envio_comprobantes_email.md). Sin el campo no hace nada.
*-- Devuelve .T. solo si el servidor de correo confirmo el envio.
*-- Si la terminal no usa EmailSender, o el cliente no tiene tilde o email, no hace nada ni avisa.
*-- Solo muestra un aviso si el cliente debia recibirlo y fallo.

PROCEDURE envioauto
	LPARAMETERS tnIdCtacte, tcArchivo, tcDetalle

	LOCAL lcAlias, lcCmd, lcEmail, llTilde, lcExe, lcJson, lcAsunto, lcCuerpo
	LOCAL lcResultado, lcMotivo, llOk, lnInicio, loShell

	IF TYPE('oConfigTermi.emailsender')#'C' OR oConfigTermi.emailsender#'TRUE'
		RETURN .F.
	ENDIF

	lcAlias = ALIAS()

	TEXT TO lcCmd TEXTMERGE NOSHOW
	SELECT CsrEnvioAuto.* FROM ctacte AS CsrEnvioAuto WHERE id = <<tnIdCtacte>>
	ENDTEXT
	IF NOT CrearCursorAdapter('CsrEnvioAuto',lcCmd)
		RETURN .F.
	ENDIF

	llTilde = .F.
	lcEmail = ""
	SELECT CsrEnvioAuto
	GO TOP
	IF NOT EOF() AND TYPE('CsrEnvioAuto.envioemailauto')#'U'
		llTilde = NVL(CsrEnvioAuto.envioemailauto,0)=1
		lcEmail = ALLTRIM(NVL(CsrEnvioAuto.email,""))
	ENDIF
	USE IN CsrEnvioAuto
	IF NOT EMPTY(lcAlias)
		SELECT (lcAlias)
	ENDIF

	IF NOT llTilde OR EMPTY(lcEmail)
		RETURN .F.
	ENDIF

	lcMotivo = ""
	lcExe = ADDBS(SYS(5)+CURDIR())+"EmailSender_OAuth.exe"
	DO CASE
		CASE NOT FILE(lcExe)
			lcMotivo = "No se encontro EmailSender_OAuth.exe"
		CASE EMPTY(tcArchivo) OR NOT FILE(tcArchivo)
			lcMotivo = "No se encontro el PDF del comprobante"
	ENDCASE

	IF EMPTY(lcMotivo)
		lcJson = ADDBS(SYS(2023)) + "email_result_" + SYS(2015) + ".json"
		lcAsunto = CHRTRAN(ALLTRIM(Goapp.empresanombre),'"','') + " - " + CHRTRAN(ALLTRIM(tcDetalle),'"','')
		&&En una sola linea: un salto de linea cortaria el comando
		lcCuerpo = "Estimado: le adjuntamos el comprobante " + CHRTRAN(ALLTRIM(tcDetalle),'"','') ;
				 + ". Atte. " + CHRTRAN(ALLTRIM(Goapp.empresanombre),'"','')

		lcCmd = '"' + lcExe + '"' ;
			  + ' --to "' + CHRTRAN(lcEmail,';',',') + '"' ;
			  + ' --subject "' + lcAsunto + '"' ;
			  + ' --body "' + lcCuerpo + '"' ;
			  + ' --provider gmail' ;
			  + ' --attachments "' + ALLTRIM(tcArchivo) + '"' ;
			  + ' --silent' ;
			  + ' --output "' + lcJson + '"'

		TRY
			loShell = CREATEOBJECT("Shell.Application")
			&&cmd /c saca las comillas externas: por eso van otras alrededor de todo el comando
			loShell.ShellExecute("cmd.exe", '/c "' + lcCmd + '"', "", "open", 0)
		CATCH TO loErr
			lcMotivo = loErr.Message
		ENDTRY
		loShell = NULL

		IF EMPTY(lcMotivo)
			&&Sin DOEVENTS: mientras espera no se deben procesar teclas ni clics en la factura
			lnInicio = SECONDS()
			DO WHILE NOT FILE(lcJson) AND ABS(SECONDS()-lnInicio) < 30
				=INKEY(0.2,'H')
			ENDDO
			&&Unos instantes por si el archivo existe pero sigue abierto
			=INKEY(0.3,'H')

			IF FILE(lcJson)
				lcResultado = FILETOSTR(lcJson)
				llOk = '"success": true' $ lcResultado
				IF NOT llOk
					lcMotivo = STREXTRACT(lcResultado,'"message": "','"')
					lcMotivo = IIF(EMPTY(lcMotivo),"El envio devolvio un error",lcMotivo)
				ENDIF
				DELETE FILE (lcJson)
			ELSE
				lcMotivo = "No hubo respuesta en 30 segundos. El correo pudo haberse enviado: verifique."
			ENDIF
		ENDIF
	ENDIF

	IF NOT EMPTY(lcMotivo)
		=oavisar.usuario("NO SE PUDO ENVIAR EL COMPROBANTE POR EMAIL" + CHR(13) ;
			+ ALLTRIM(tcDetalle) + " a " + lcEmail + CHR(13) + CHR(13) ;
			+ lcMotivo + CHR(13) + CHR(13) ;
			+ "El comprobante quedo grabado. Puede reenviarlo desde Reimprimir.",0)
		RETURN .F.
	ENDIF

	RETURN .T.
ENDPROC
