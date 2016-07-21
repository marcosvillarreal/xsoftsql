PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF 
Oavisar.proceso('S','Vaciando archivos') 
SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
llok = .t.
llok = CargarTabla(lcData,'AreaNeg',.t.)
llok = CargarTabla(lcData,'AreaNegCtacte',.t.)
llok = CargarTabla(lcData,'AreaNegRubro',.t.)
llok = CargarTabla(lcData,'Ctacte',)
llok = CargarTabla(lcData,'Rubro',)
SET SAFETY ON
IF !llok
	RETURN .f.
ENDIF


Oavisar.proceso('S','Abriendo archivos') 
USE ALLTRIM(lcpath )+"\gestion\seccion" IN 0 ALIAS FsrRubro EXCLUSIVE 
USE ALLTRIM(lcpath )+"\gestion\negocios" IN 0 ALIAS FsrAreaNeg EXCLUSIVE 
USE ALLTRIM(lcpath )+"\gestion\clientes" IN 0 ALIAS FsrCliente EXCLUSIVE 

Oavisar.proceso('S','Procesando '+alias()) 
SELECT * FROM FsrCliente ORDER BY numero INTO CURSOR FsrCtacte

lnid = RecuperarID('CsrAreaNeg',goapp.sucursal10)

SELECT FsrAreaNeg
Oavisar.proceso('S','Procesando NEGOCIOS') 
GO top

SCAN FOR !EOF()    
	
	lcnombre	= NombreNi(FsrAreaNeg.nombre)
    lnnumero	= FsrAreaNeg.numero
   	INSERT INTO CsrAreaNeg (id,numero,nombre,molino) VALUES (lnid,lnnumero,lcnombre,1)
   	lnid = lnid +1 

ENDSCAN


SELECT CsrAreaNegCtacte
lnid = RecuperarID('CsrAreaNegCtacte',goapp.sucursal10)

SELECT FsrCtacte
Oavisar.proceso('S','Procesando Relacion Area - Cliente ') 
GO top
SCAN    
	SELECT CsrCtacte
	LOCATE FOR VAL(cnumero) = FsrCtacte.numero 
	IF !EMPTY(FsrCtacte.qareas) AND VAL(cnumero) = FsrCtacte.numero
		 IF recno('FsrCtacte')/100=INT(RECNO('FsrCtacte')/100)
	    	*Oavisar.proceso('N')
	    	lcTitulo = "Clientes/Proveedor "+STR(RECNO(),10)   
	    	*?(lctitulo)  
	    	Oavisar.proceso('S',lcTitulo,.t.,recno())
	 	ENDIF
		i=1
		lnarea = 0
		DO WHILE    i<LEN(ALLTRIM(FsrCtacte.qareas))
			lnarea = VAL(SUBSTR(FsrCtacte.qareas,i,4))
			i = i+4
			SELECT CsrAreaNeg
			LOCATE FOR numero = lnarea
			IF numero = lnarea
				INSERT INTO CsrAreaNegCtacte(id,idctacte,idarea,estado);
				VALUES (lnid,CsrCtacte.id,CsrAreaNeg.id,0)
				lnid = lnid +1 
			ENDIF 
		ENDDO 
	ENDIF 
	SELECT FsrCtacte
ENDSCAN
********************
*****Areas de los rubros
********************
SELECT CsrAreaNegRubro
lnid = RecuperarID('CsrAreaNegRubro',goapp.sucursal10)

SELECT FsrRubro
Oavisar.proceso('S','Procesando Relacion AREAS-RUBROS') 
GO top
SCAN 
   
	SELECT CsrRubro
	LOCATE FOR numero = FsrRubro.numero 
	IF !EMPTY(FsrRubro.qareas) AND numero = FsrRubro.numero
		i=1
		lnarea = 0
		DO WHILE    i<LEN(ALLTRIM(FsrRubro.qareas))
			lnarea = VAL(SUBSTR(FsrRubro.qareas,i,4))
			i = i+4
			SELECT CsrAreaNeg
			LOCATE FOR numero = lnarea
			IF numero = lnarea
				INSERT INTO CsrAreaNegRubro(id,idrubro,idarea,estado);
				VALUES (lnid,CsrRubro.id,CsrAreaNeg.id,0)
				lnid = lnid +1 

			ENDIF 
		ENDDO 
	ENDIF 
	SELECT FsrRubro
ENDSCAN
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

USE in FsrCtacte 
USE IN FsrAreaNeg
USE IN FsrRubro 
USE IN FsrCliente
	