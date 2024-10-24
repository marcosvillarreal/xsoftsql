PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 

SET SAFETY OFF


SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Producto')


SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 

CREATE CURSOR CsrLista (deta c(50))
		
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
cArhivo = ALLTRIM(lcpath )+"\articulos.csv"
APPEND FROM  &cArhivo SDF


stop()
SELECT CsrLista
GO TOP 
SCAN 
	cRegistro	= ALLTRIM(CsrLista.deta)
	nPos		= AT(';',cRegistro)
	cCodigo		= LEFT(cRegistro,nPos-1)
	cKilos		= SUBSTR(cRegistro,nPos+1)
	IF VAL(cCodigo)<>0 AND VAL(cKilos)<>0
		SELECT CsrProducto
		LOCATE FOR numero = VAL(cCodigo)
		IF numero = VAL(cCodigo)
			replace peso WITH VAL(cKilos)
		ENDIF 
	ENDIF 
	SELECT CsrLista
ENDSCAN 

SELECT CsrProducto
vista()

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')



CLOSE tables
CLOSE INDEXES
CLOSE DATABASES