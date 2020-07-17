
FUNCTION ExportarBalanza
LPARAMETERS cFileVenta

IF EMPTY(cFileVenta)
	oavisar.usuario('Error ruta del archivo vacia.')
	RETURN .f.
ENDIF 

IF NOT FILE(cFileVenta)
	oavisar.usuario('Error al ubicar el archivo.'+CHR(13)+cFileVenta)
	RETURN .f.
ENDIF 

IF USED('CsrVentas')
	USE IN CsrVentas
ENDIF 
CREATE CURSOR CsrVentas (Codigo i,Articulo c(40),cantidad n(12,3),pesable n(1),importe n(11,2))

LOCAL cFile,nLineaHeader
nLineaHeader = 6
nLectura = 0

cFile = FOPEN(cFileVenta)
IF cFile=-1
	oavisar.usuario("Error al abrir el archivo " + CHR(13) + cFileVenta)
	FCLOSE(cFile)
	RETURN .f.
ENDIF 

*stop()
DO WHILE NOT FEOF(cFile) AND  nLectura < nLineaHeader
	cLinea = FGETS(cFile)
	nLectura = nLectura + 1 
ENDDO 
IF UPPER(ALLTRIM(cLinea)) <> "REPORTE  DE  VENTAS  POR  PRODUCTOS"
	oavisar.usuario("Error el archivo no es un reporte de la balanza " + CHR(13) + cFileVenta)
	FCLOSE(cFile)
	RETURN .f.
ENDIF 
cLinea = FGETS(cFile)

*Leemos la fecha del reporte
cLinea = UPPER(ALLTRIM(FGETS(cFile)))
nLectura = nLectura + 1 

*!*	LOCAL nSep,cDia,cMes,cAnio
*!*	STORE '' TO cDia,cMes,cAnio

*!*	nSep	= AT(',',cLinea)
*!*	cLinea	= RIGHT(cLinea,LEN(cLinea) - nSep)
*!*	nSep	= AT('PÁGINA',cLinea)
*!*	cLinea	= RTRIM(LEFT(cLinea,nSep-1))
*!*	nSep	= AT('DE',cLinea)
*!*	cDia	= strzero(VAL(LEFT(cLinea,nSep-1)),2)
*!*	cAnio	= RIGHT(cLinea,4)
*!*	cLinea	= LTRIM(SUBSTR(cLinea,nSep+2)) &&Elimina el dia
*!*	nSep	= AT(' ',cLinea)
*!*	cLinea	= LEFT(cLinea,nSep-1)
*!*	cMes	= STRzero(MesANumArg(cLinea),2)
*!*	*Desuso
*!*	dFecha	= CTOD(cDia + '/' + cMes + '/' +cAnio)

&&Nos movemos hasta el primer articulo
nLineaHeader = 3
nLectura = 0
DO WHILE NOT FEOF(cFile) AND  nLectura < nLineaHeader
	cLinea = FGETS(cFile)
	nLectura = nLectura + 1 
ENDDO 

&&Tenemos que leer hasta que se lea TOTALES
nLectura = 0
lTotales = .f.
DO WHILE NOT FEOF(cFile) AND NOT lTotales
	cLinea = FGETS(cFile)
	nLectura = nLectura + 1 
	IF AT('TOTALES',cLinea) <> 0
		lTotales = .t.
		EXIT 
	ENDIF 
	cCodigo = LEFT(cLinea,11)
	IF VAL(cCodigo) <> 0 &&Es un articulo
		cArticulo	= SUBSTR(cLinea,19,19)
		cCantidad	= STRTRAN(SUBSTR(cLinea,45,7),',','.')
		cTipoVta	= UPPER(SUBSTR(cLinea,52,2))
		nTotal		= AT('$',cLinea,6)
		cImporte	= STRTRAN(SUBSTR(cLinea,nTotal+1),',','.')
		*(Codigo i,Articulo c(40),cantidad n(12,3),pesable 1,importe n(11,2))
		APPEND BLANK IN CsrVentas
		replace codigo WITH INT(VAL(cCodigo)),articulo WITH cArticulo,cantidad WITH VAL(cCantidad);
				,pesable WITH IIF("KG"$cTipoVta,1,0),Importe WITH VAL(cImporte) IN CsrVentas
	ENDIF 
ENDDO 

FCLOSE(cFile)

SELECT CsrVentas

RETURN .t.
*MODIFY FILE (cFile) NOWAIT
ENDFUNC 

*--------------------------------------------------------------
*------------ Version 3 ---------------------------------------
*--------------------------------------------------------------

FUNCTION ExportarBalanza
LPARAMETERS cFileVenta

IF EMPTY(cFileVenta)
	oavisar.usuario('Error ruta del archivo vacia.')
	RETURN .f.
ENDIF 

IF NOT FILE(cFileVenta)
	oavisar.usuario('Error al ubicar el archivo.'+CHR(13)+cFileVenta)
	RETURN .f.
ENDIF 

IF USED('CsrVentas')
	USE IN CsrVentas
ENDIF 
CREATE CURSOR CsrVentas (Codigo i,Articulo c(40),cantidad n(12,3),pesable n(1),importe n(11,2))

LOCAL cFile,nLineaHeader
nLineaHeader = 6
nLectura = 0

cFile = FOPEN(cFileVenta)
IF cFile=-1
	oavisar.usuario("Error al abrir el archivo " + CHR(13) + cFileVenta)
	FCLOSE(cFile)
	RETURN .f.
ENDIF 

*stop()
DO WHILE NOT FEOF(cFile) AND  nLectura < nLineaHeader
	cLinea = FGETS(cFile)
	nLectura = nLectura + 1 
ENDDO 
IF UPPER(ALLTRIM(cLinea)) <> "REPORTE  DE  VENTAS  POR  PRODUCTOS"
	oavisar.usuario("Error el archivo no es un reporte de la balanza " + CHR(13) + cFileVenta)
	FCLOSE(cFile)
	RETURN .f.
ENDIF 
cLinea = FGETS(cFile)

*Leemos la fecha del reporte
cLinea = UPPER(ALLTRIM(FGETS(cFile)))
nLectura = nLectura + 1 

&&Nos movemos hasta el primer articulo
nLineaHeader = 3
nLectura = 0
DO WHILE NOT FEOF(cFile) AND  nLectura < nLineaHeader
	cLinea = FGETS(cFile)
	nLectura = nLectura + 1 
ENDDO 

&&Tenemos que leer hasta que se lea TOTALES
nLectura = 0
lTotales = .f.
DO WHILE NOT FEOF(cFile) AND NOT lTotales
	cLinea = FGETS(cFile)
	nLectura = nLectura + 1 
	IF AT('TOTALES',cLinea) <> 0
		lTotales = .t.
		EXIT 
	ENDIF 
	cCodigo = LEFT(cLinea,11)
	IF VAL(cCodigo) <> 0 &&Es un articulo
		cArticulo	= SUBSTR(cLinea,22,26)
		cCantidad	= STRTRAN(SUBSTR(cLinea,45,7),',','.')
		cTipoVta	= UPPER(SUBSTR(cLinea,52,2))
		nTotal		= AT('$',cLinea,6)
		cImporte	= STRTRAN(SUBSTR(cLinea,nTotal+1),',','.')
		*(Codigo i,Articulo c(40),cantidad n(12,3),pesable 1,importe n(11,2))
		APPEND BLANK IN CsrVentas
		replace codigo WITH INT(VAL(cCodigo)),articulo WITH cArticulo,cantidad WITH VAL(cCantidad);
				,pesable WITH IIF("KG"$cTipoVta,1,0),Importe WITH VAL(cImporte) IN CsrVentas
	ENDIF 
ENDDO 

FCLOSE(cFile)

SELECT CsrVentas

RETURN .t.
*MODIFY FILE (cFile) NOWAIT
ENDFUNC 