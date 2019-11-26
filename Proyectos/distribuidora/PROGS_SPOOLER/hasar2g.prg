PUBLIC oHasar2G,estilo

oHasar2G	= CREATEOBJECT("HasarArgentina.ImpresoraFiscalRG3561")
*!*	estilo	 	= CREATEOBJECT('custom')
*!*	estilo.AddProperty('Centrado',.t.)
*!*	estilo.AddProperty('DobleAncho',.f.)
*!*	estilo.AddProperty('Negrita',.f.)
*!*	estilo.AddProperty('Borrado',.f.)
oErrorHasar		= createobject("custom")
oErrorHasar.AddProperty("UltimoError","")
oErrorHasar.AddProperty("NumeroParametro",0)
oErrorHasar.AddProperty("Descripcion","")
oErrorHasar.AddProperty("Contexto","")
oErrorHasar.AddProperty("NombreParametro","")

WITH oHasar2G
	
	cFileLog = SYS(5)+CURDIR()+"\OCX2G_"+STRtrim( MINUTE(DATETIME()) )+".log"
	IF FILE(cFileLog)
		DELETE FILE &cFileLog
	ENDIF 
	TRY 
		.ArchivoRegistro(cFileLog)
		=ConectarHasar()
		
		stop()
		*=CerrarZ()
		*
		=ConsultarEstadoFiscal()
		.Cancelar()
		=ImprimirTique()
		
	CATCH TO Err
		=DeterminarError()
	ENDTRY 
ENDWITH 


FUNCTION ConectarHasar()
	WITH oHasar2G	
		.Conectar("192.168.1.112")
		? "*** CONEXI�N EXITOSA ! ... ***"
	    *?
	    *? "OCX 2G Protocolo = [" + strtrim(.ObtenerVersionProtocolo()) + "]"
	    *? "OCX 2G Revisi�n  = [" + strtrim(.ObtenerRevision()) + "]"
	    *? "Timeout env�o respuesta en espera = 2 seg..."
	ENDWITH 
ENDFUNC 

FUNCTION ImprimirTique()
	WITH oHasar2G
		=ConsultarEstadoFiscal(83)
		TRY 
		*=.AbrirDocumento(83)
		CATCH TO Err
			? Err.Message
			*=.Cancelar()
		ENDTRY 
		
	ENDWITH 
ENDFUNC 

FUNCTION CerrarZ()
	WITH oHasar2G	
		=.CerrarJornadaFiscal(90)	
	ENDWITH 
ENDFUNC 
FUNCTION ConsultarEstadoFiscal(nTipoComp)
	WITH oHasar2G
		TRY 
			.ConsultarEstado(83)
		CATCH TO Err
			=DeterminarError()
		ENDTRY 
		
		
*!*			*cResp = .ObtenerCampoRespuesta("")
		?"Tipo Comprobante = [" + .ObtenerCampoRespuesta("CodigoComprobante")+ "]"
		?"Ultimo Nro. = [" + .ObtenerCampoRespuesta("NumeroUltimoComprobante")+ "]"
		?"Cancelados = [" + .ObtenerCampoRespuesta("CantidadCancelados")+ "]"
		?"Emitidos = [" + .ObtenerCampoRespuesta("CantidadEmitidos")+ "]"
		*?"C�digo de barras = [" & respest.EstadoAuxiliar.CodigoBarrasAlmacenado & "]"
		*?"Datos del cliente = [" & respest.EstadoAuxiliar.DatosClienteAlmacenados & "]"
		*?"Casi llena = [" & respest.EstadoAuxiliar.MemoriaAuditoriaCasiLlena & "]"
		*?"Llena = [" & respest.EstadoAuxiliar.MemoriaAuditoriaLlena & "]"
		*?"Modo entrenamiento = [" & respest.EstadoAuxiliar.ModoEntrenamiento & "]"
		*?"Ult. comprob. cancel. = [" & respest.EstadoAuxiliar.UltimoComprobanteFueCancelado & "]"
	ENDWITH 
ENDFUNC 
FUNCTION DeterminarError()
	TRY 
		.ConsultarUltimoError()
		oErrorHasar.UltimoError	= .ObtenerCampoRespuesta('UltimoError')
		oErrorHasar.NumeroParametro	= VAL(.ObtenerCampoRespuesta('NumeroParametro'))
		oErrorHasar.Descripcion	= .ObtenerCampoRespuesta('Descripcion')
		oErrorHasar.Contexto	= .ObtenerCampoRespuesta('Contexto')
		oErrorHasar.NombreParametro	= .ObtenerCampoRespuesta('NombreParametro')
		oavisar.usuario("Ultimo Error:"+oErrorHasar.UltimoError+CHR(13)+;
			"Numero Parametro:"+strtrim(oErrorHasar.NumeroParametro)+CHR(13)+;
			"Descripcion:"+oErrorHasar.Descripcion+CHR(13)+;
			"Contexto:"+oErrorHasar.Contexto+CHR(13)+;
			"NombreParametro:"+oErrorHasar.NombreParametro)
	CATCH TO Err
		?Err.Message
	ENDTRY 
		
ENDFUNC 