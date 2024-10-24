PARAMETERS ldfecha,lcpath,lcbase
lcfecha = IIF(PCOUNT()< 1,"01-01-2011",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcdata = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
oavisar.proceso("Abriendo tablas...")
llok = .t.


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrProducto.* FROM Producto as CsrProducto WHERE id in (1100000677,1100000782,1100000792)
ENDTEXT 
IF NOT CrearCursorAdapter('CsrProducto',lccmd)
	MESSAGEBOX('Nose puede importar, pq no puede cargar los productos')
	RETURN .f.
ENDIF 

llok = CargarTabla(lcData,'Maopera')
llok = CargarTabla(lcData,'Cuerfac')
llok = CargarTabla(lcData,'TablaOpe')

IF !llok
	RETURN .f.
ENDIF

USE  ALLTRIM(lcpath )+"\gestion\cuerfac" in 0 alias Csrcuerleon  EXCLUSIVE

ldfechaant=CTOD(lcfecha)
	
oavisar.proceso("S","Reindexando Cuerfac por orden...")

SELECT CsrCuerleon.* FROM CsrCuerleon ;
WHERE articulo in (47301,47293,91154) AND ldfechaant <= fecha;
ORDER BY orden,articulo INTO CURSOR CsrCuerpo
SELECT CsrCuerpo
INDEX on orden TO Csrcuerpo

oavisar.proceso("S","Reindexando Cuerfac por comprobante...")
SELECT CsrCuerfac.*,CsrMaopera.numcomp,0 as estado, kilos as kilosant ;
FROM CsrMaopera INNER JOIN CsrCuerfac ON CsrMaopera.id = CsrCuerfac.idmaopera ;
ORDER BY numcomp,codigo INTO CURSOR CsrLista READWRITE 


SET SAFETY ON
oavisar.proceso("Procesando tablas...")

*stop()

SELECT CsrCuerpo
COUNT ALL TO lnCountCuerpo
GO TOP 
lcTitulo = "Cabefac "+STR(RECNO(),10)+"/"+STR(lnCountCuerpo,10) 
Oavisar.proceso('S',lcTitulo)
lbSalir = .f.
lbIniciando = .f.
lnIdMaopera = 0
lnCodArticulo = 0
cNumComp = ""
lcNumComp = ""

SCAN FOR !EOF()
	SELECT CsrCuerpo
	
 	*IF recno('CsrCuerpo')/1=INT(RECNO('CsrCuerpo')/1)
    	lcTitulo = "Cuerfac "+STR(RECNO(),10)+"/"+STR(lnCountCuerpo,10) 
    	Oavisar.proceso('S',lcTitulo)
 	*ENDIF
	SELECT CsrLista
	cNumComp = LEFT(CsrCuerpo.letra,1)+strzero(CsrCuerpo.talonario,4)+strzero(CsrCuerpo.numcomp,8)
	IF cNumComp = lcNumComp AND CsrCuerpo.articulo = lnCodArticulo
		&&Ya habia empezado a recorrer este cuerpo
		lbIniciando = .t.
		SKIP IN CsrLista
		IF CsrCuerpo.articulo != VAL(RIGHT(CsrCuerfac.codigo,6))
			&&Sino encuentro redefino el recorrido
			SET FILTER TO 
			SET FILTER TO numcomp  = cNumComp AND VAL(RIGHT(codigo,6)) = CsrCuerpo.articulo 
			SELECT CsrLista
			LOCATE FOR VAL(RIGHT(codigo,6)) = CsrCuerpo.articulo
		ENDIF 
	ELSE
		&&Si cambio de cuerpo. redefino el recorrdio
		SET FILTER TO 
		SET FILTER TO numcomp  = cNumComp AND VAL(RIGHT(codigo,6)) = CsrCuerpo.articulo 
		SELECT CsrLista
		LOCATE FOR VAL(RIGHT(codigo,6)) = CsrCuerpo.articulo
	ENDIF 
	SELECT CsrLista
	*vista()
	
	&&Si no encuentra el cuerpo, seguimos al siguiente
	IF CsrCuerpo.articulo != VAL(RIGHT(codigo,6))
		SELECT CsrCuerpo
		LOOP 
	ENDIF 
	lcNumComp = CsrLista.numcomp
	lnCodArticulo = CsrCuerpo.articulo
	
	SELECT CsrCuerfac
	LOCATE FOR id = CsrLista.id		
	IF id = CsrLista.id
		replace kilos WITH CsrCuerpo.kilos, pesable WITH 1,codigo WITH strtrim(lncodArticulo) IN CsrCuerfac
		*replace kilos WITH CsrCuerpo.kilos, pesable WITH 1,codigo WITH '*'+strtrim(lncodArticulo),estado WITH 1 IN CsrLista
	ENDIF 
	
	SELECT CsrCuerpo     				
ENDSCAN

oavisar.proceso('N')
*!*	SELECT CsrLista
*!*	SET FILTER TO
*!*	SET FILTER TO estado = 1
*!*	SELECT nombre,COUNT(*) FROM CsrLista GROUP BY nombre INTO CURSOR CsrAuxLista READWRITE 

*!*	SELECT CsrAuxLista
*!*	vista()

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE IN Csrcuerleon  
USE IN CsrCuerpo
USE IN CsrLista
