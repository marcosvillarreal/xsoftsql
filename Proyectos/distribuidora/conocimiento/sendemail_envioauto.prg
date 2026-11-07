*-- Clase sendemail de Desarrollo\clases\onegocio.vcx. Metodos envioauto y jsontexto (06/11/2026).
*-- Copia de referencia del texto instalado.
*-- Solo deja el pedido en C:\GmEmailLocal\inbox. El envio lo hace GmEmailLocal (Python).
*-- Devuelve .T. si dejo el pedido; eso no significa que el email ya se haya enviado.
*-- Si la terminal no usa EmailSender, el comprobante no tiene maopera.numcomp, o el cliente
*-- no tiene tilde o email, no hace nada ni avisa. Requiere el campo ctacte.envioemailauto.

PROCEDURE envioauto
	LPARAMETERS tnIdCtacte, tnIdMaopera, tcArchivo, tcDetalle

	LOCAL lcAlias, lcCmd, lcEmail, llTilde, llConNumero, lcMotivo, lcId, lcEmpresa, lcDetalle
	LOCAL lcBase, lcInbox, lcVivo, lcExe, lcNombre, lcJson, loShell, loErr

	IF TYPE('oConfigTermi.emailsender')#'C' OR oConfigTermi.emailsender#'TRUE'
		RETURN .F.
	ENDIF

	lcAlias = ALIAS()
	lcId = LTRIM(STR(tnIdMaopera,15))

	TEXT TO lcCmd TEXTMERGE NOSHOW
	SELECT CsrEnvioOpera.numcomp FROM maopera AS CsrEnvioOpera WHERE id = <<lcId>>
	ENDTEXT
	IF NOT CrearCursorAdapter('CsrEnvioOpera',lcCmd)
		RETURN .F.
	ENDIF
	SELECT CsrEnvioOpera
	GO TOP
	llConNumero = NOT EOF() AND NOT EMPTY(NVL(CsrEnvioOpera.numcomp,""))
	USE IN CsrEnvioOpera

	llTilde = .F.
	lcEmail = ""
	IF llConNumero
		TEXT TO lcCmd TEXTMERGE NOSHOW
		SELECT CsrEnvioAuto.* FROM ctacte AS CsrEnvioAuto WHERE id = <<tnIdCtacte>>
		ENDTEXT
		IF CrearCursorAdapter('CsrEnvioAuto',lcCmd)
			SELECT CsrEnvioAuto
			GO TOP
			IF NOT EOF() AND TYPE('CsrEnvioAuto.envioemailauto')#'U'
				llTilde = NVL(CsrEnvioAuto.envioemailauto,0)=1
				lcEmail = ALLTRIM(NVL(CsrEnvioAuto.email,""))
			ENDIF
			USE IN CsrEnvioAuto
		ENDIF
	ENDIF
	IF NOT EMPTY(lcAlias)
		SELECT (lcAlias)
	ENDIF

	IF NOT llConNumero OR NOT llTilde OR EMPTY(lcEmail)
		RETURN .F.
	ENDIF

	lcBase = "C:\GmEmailLocal\"
	lcInbox = lcBase + "inbox\"
	lcVivo = lcBase + "lector.vivo"
	lcExe = lcBase + "GmEmailLocal.exe"
	lcMotivo = ""
	DO CASE
		CASE NOT FILE(lcExe)
			lcMotivo = "GmEmailLocal no esta instalado en esta terminal"
		CASE EMPTY(tcArchivo) OR NOT FILE(tcArchivo)
			lcMotivo = "No se encontro el PDF del comprobante"
	ENDCASE

	IF EMPTY(lcMotivo)
		lcDetalle = ALLTRIM(NVL(tcDetalle,""))
		lcEmpresa = ALLTRIM(Goapp.empresanombre)
		lcNombre = lcInbox + lcId + "_" + SYS(2015)
		lcJson = '{"idmaopera":' + lcId ;
			   + ',"email":' + this.jsontexto(lcEmail) ;
			   + ',"archivo":' + this.jsontexto(tcArchivo) ;
			   + ',"comprobante":' + this.jsontexto(lcDetalle) ;
			   + ',"asunto":' + this.jsontexto(lcEmpresa + " - " + lcDetalle) ;
			   + ',"cuerpo":' + this.jsontexto("Estimado: le adjuntamos el comprobante " + lcDetalle + ". Atte. " + lcEmpresa) ;
			   + '}'
		TRY
			IF NOT DIRECTORY(lcInbox)
				MKDIR (lcInbox)
			ENDIF
			&&Primero .tmp: el lector ignora esos archivos y nunca toma uno a medio escribir
			=STRTOFILE(lcJson, lcNombre + ".tmp")
			RENAME (lcNombre + ".tmp") TO (lcNombre + ".json")

			IF NOT FILE(lcVivo) OR DATETIME() - FDATE(lcVivo,1) > 120
				loShell = CREATEOBJECT("Shell.Application")
				loShell.ShellExecute(lcExe, "", lcBase, "open", 0)
			ENDIF
		CATCH TO loErr
			lcMotivo = loErr.Message
		ENDTRY
		loShell = NULL
	ENDIF

	IF NOT EMPTY(lcMotivo)
		=oavisar.usuario("NO SE PUDO ENVIAR EL COMPROBANTE POR EMAIL" + CHR(13) ;
			+ ALLTRIM(NVL(tcDetalle,"")) + " a " + lcEmail + CHR(13) + CHR(13) ;
			+ lcMotivo + CHR(13) + CHR(13) ;
			+ "El comprobante quedo grabado. Puede reenviarlo desde Reimprimir.",0)
		RETURN .F.
	ENDIF

	RETURN .T.
ENDPROC

PROCEDURE jsontexto
	LPARAMETERS tcTexto

	LOCAL lcTexto
	lcTexto = ALLTRIM(NVL(tcTexto,""))
	lcTexto = CHRTRAN(lcTexto, CHR(13)+CHR(10)+CHR(9), "   ")
	lcTexto = STRTRAN(lcTexto, "\", "\\")
	lcTexto = STRTRAN(lcTexto, '"', '\"')
	RETURN '"' + lcTexto + '"'
ENDPROC
