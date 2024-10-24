PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 

SET SAFETY OFF


TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrProducto.id as idarticulo, CsrProducto.idubicacio as idubicacion FROM Producto as CsrProducto
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
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 

LOCAL lnid
*****
lnid = RecuperarID('CsrSuc_Ubicacion',Goapp.sucursal10)
lnidsucursal = goapp.idsucursal
SELECT CsrProducto
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	STORE 0 TO lnidubicacion,lnidarticulo
	lnidubicacion	= CsrProducto.idubicacion
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
