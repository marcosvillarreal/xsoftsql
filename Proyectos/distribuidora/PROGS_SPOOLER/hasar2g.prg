stop()
oHasar2G = CREATEOBJECT("HasarArgentina.ImpresoraFiscalRG3561")

WITH oHasar2G
	TRY 
		.ArchivoRegistro("J:\HASAR\OCX2G.log")
		.ConfigurarRed("192.168.1.112","255.255.255.0","192.168.1.112")
		.Conectar("192.168.1.112")
	CATCH TO Err
		? Err.Message
	ENDTRY 
ENDWITH 