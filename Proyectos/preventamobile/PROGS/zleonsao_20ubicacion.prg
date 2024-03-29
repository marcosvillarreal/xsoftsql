PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 

SET SAFETY OFF


TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrProducto.id as idarticulo,CsrProducto.numero FROM Producto as CsrProducto
ENDTEXT 
IF !CrearCursorAdapter('CsrProducto',lccmd) OR RECCOUNT('CsrProducto')=0
	MESSAGEBOX('Nose puede importar, pq no cargado los productos')
	RETURN .f.
ENDIF 

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'ProdUbicacion',.t.)
llok = CargarTabla(lcData,'Ubicacion')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 

USE  ALLTRIM(lcpath )+"\gestion\articulo" in 0 alias CsrArticulo EXCLUSIVE	

LOCAL lnid

&&&&UBICACIONES
*!*	lnid = ObtenerID('Ubicacion')

*!*	SELECT distinct VAL(Codigo_emb) as numero FROM CsrArticulo INTO CURSOR CsrUbicacionVie

lnidsucursal = goapp.idsucursal

*!*	*!*	SELECT CsrUbicacionVie
*!*	*!*	Oavisar.proceso('S','Procesando Ubicaciones') 
*!*	*!*	GO top
*!*	*!*	SCAN FOR !EOF()
*!*	*!*		lcnumero = ALLTRIM(STR(10 + CsrUbicacionVie.numero,5))
*!*	*!*	  	lcnombre= "UBICACIÓN SAO "+RTRIM(STRzero(VAL(lcnumero),5,0))
*!*	*!*	   	INSERT INTO CsrUbicacion (id,numero,nombre,idsucursal)	VALUES (lnid,lcnumero,lcnombre,lnidsucursal)
*!*	*!*	   	lnid = lnid + 1
*!*	*!*	ENDSCAN
*!*	*!*	USE IN CsrUbicacionVie

*****
lnid = ObtenerID('ProdUbicacion')

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	STORE 0 TO lnidubicacion,lnidarticulo
	SELECT CsrProducto
	LOCATE FOR numero = CsrArticulo.numero 
	IF numero != CsrArticulo.numero 
		SELECT CsrArticulo
		LOOP 
	ENDIF 
	nUbicacion	 = 10 + VAL(CsrArticulo.Codigo_emb)
	SELECT CsrUbicacion
	LOCATE FOR VAL(numero) = nUbicacion
	
	lnidubicacion	= CsrUbicacion.id
	lnidarticulo	= CsrProducto.idarticulo
	INSERT INTO CsrProdUbicacion (id,idarticulo,idubicacion) VALUES (lnid,lnidarticulo,lnidubicacion)
	lnid = lnid + 1 
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

USE IN CsrProducto
USE IN CsrArticulo