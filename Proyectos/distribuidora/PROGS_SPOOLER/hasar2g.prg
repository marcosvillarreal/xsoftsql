PUBLIC oHasar2G,estilo

oHasar2G	= CREATEOBJECT("HasarArgentina.ImpresoraFiscalRG3561")
estilo	 	= CREATEOBJECT('custom')
estilo.AddProperty('Centrado',.t.)
estilo.AddProperty('DobleAncho',.f.)
estilo.AddProperty('Negrita',.f.)
estilo.AddProperty('Borrado',.f.)

WITH oHasar2G
	TRY 
		
		IF FILE(SYS(5)+CURDIR()+"\OCX2G.log")
			DELETE FILE (SYS(5)+CURDIR()+"\OCX2G.log")
		ENDIF 
		.ArchivoRegistro(SYS(5)+CURDIR()+"\OCX2G.log")
		=ConectarHasar()
		
		stop()
		*=CerrarZ()
		*
		*.Cancelar()
		=ImprimirTique()
		
	CATCH TO Err
		? Err.Message
	ENDTRY 
ENDWITH 


FUNCTION ConectarHasar()
	WITH oHasar2G	
		.Conectar("192.168.1.112")
		? "*** CONEXIÓN EXITOSA ! ... ***"
	    *?
	    *? "OCX 2G Protocolo = [" + strtrim(.ObtenerVersionProtocolo()) + "]"
	    *? "OCX 2G Revisión  = [" + strtrim(.ObtenerRevision()) + "]"
	    *? "Timeout envío respuesta en espera = 2 seg..."
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
		=.ConsultarEstado(83)
		*cResp = .ObtenerCampoRespuesta("")
		?"Tipo Comprobante = [" + .ObtenerCampoRespuesta("CodigoComprobante")+ "]"
		?"Ultimo Nro. = [" + .ObtenerCampoRespuesta("NumeroUltimoComprobante")+ "]"
		?"Cancelados = [" + .ObtenerCampoRespuesta("CantidadCancelados")+ "]"
		?"Emitidos = [" + .ObtenerCampoRespuesta("CantidadEmitidos")+ "]"
		*?"Código de barras = [" & respest.EstadoAuxiliar.CodigoBarrasAlmacenado & "]"
		*?"Datos del cliente = [" & respest.EstadoAuxiliar.DatosClienteAlmacenados & "]"
		*?"Casi llena = [" & respest.EstadoAuxiliar.MemoriaAuditoriaCasiLlena & "]"
		*?"Llena = [" & respest.EstadoAuxiliar.MemoriaAuditoriaLlena & "]"
		*?"Modo entrenamiento = [" & respest.EstadoAuxiliar.ModoEntrenamiento & "]"
		*?"Ult. comprob. cancel. = [" & respest.EstadoAuxiliar.UltimoComprobanteFueCancelado & "]"
	ENDWITH 
ENDFUNC 