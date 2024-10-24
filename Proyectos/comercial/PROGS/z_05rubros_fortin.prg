PARAMETERS ldvacio,lcpath,lcBase,lnlimite

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
llok = CargarTabla(lcData,'Rubro',.t.)
llok = CargarTabla(lcData,'Familia',.t.)
llok = CargarTabla(lcData,'CategoTipo',.t.)
llok = CargarTabla(lcData,'AfeCateProd',.t.)
llok = CargarTabla(lcData,'Producto')

SET SAFETY ON
IF !llok
	RETURN .f.
ENDIF

USE ALLTRIM(lcpath)+"\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid,lnidFamGral,lnidTipoGral

lnidFam = RecuperarID('CsrFamilia',Goapp.sucursal10)
  
INSERT INTO CsrFamilia (id,numero,nombre,switch);
VALUES (lnidFam,RECNO("CsrFamilia")+1,"GENERAL","00000")
   	
lnidFamGral = lnidFam

lnidFam = lnidFam + 1 

lnid = RecuperarID('CsrCategoTipo',Goapp.sucursal10)
  
INSERT INTO CsrCategoTipo (id,numero,nombre,switch);
VALUES (lnid,RECNO("CsrCategoTipo")+1,"GENERAL","00000")
   	
lnidTipoGral = lnid

lnidAfe = RecuperarID('CsrAfeCateProd',Goapp.sucursal10)

INSERT INTO CsrAfeCateProd (id,idpadre,idhijo,clave,switch,estado);
VALUES (lnidAfe,lnidFamGral,lnidTipoGral,'FT',"00000",0)

lnidAfe = lnidAfe + 1 
&&Generamos la relacion rubro producto
SELECT distinct idrubro as codrubro FROM CsrProducto INTO CURSOR CsrProdRubro READWRITE 

&&& Generar el plancue
SELECT * FROM CsrSeccion WHERE VAL(clave)<>0 ORDER BY clave INTO CURSOR CsrCuentaX READWRITE 

lnidRubro = RecuperarID('CsrRubro',Goapp.sucursal10)

INSERT INTO CsrRubro (id,numero,nombre) VALUES (lnidRubro,0,"GENERICO")

lnidRubro = lnidRubro + 1 

*stop()
 
SELECT CsrProdRubro
SCAN
	
	IF CsrProdRubro.codrubro <> 0
		SELECT CsrCuentaX
		LOCATE FOR numero = CsrProdRubro.codrubro
		IF numero <> CsrProdRubro.codrubro
			SELECT CsrProdRubro
			LOOP 
		ENDIF 
		&&Buscamos el padre del rubro, ya que sera la familia
		SELECT CsrCuentaX
		SCATTER NAME OscRubro
	
		nNivel		= CsrCuentaX.nivel
		lbhallado	= .f.
		DO WHILE !lbhallado AND NOT EOF() AND NOT BOF()
			SKIP -1
			IF nivel = 0 OR nivel < nNivel
				lbhallado = .t.
			ENDIF 
		ENDDO 
		
		&&Sino encontramos nada o el nivel es cero, le damos la familia generica
		IF NOT lbhallado OR nNivel = 0 OR CsrCuentaX.numero <= 0
			lnidFamilia = lnidFamGral
			lbhallado	= .f.
		ENDIF 
		IF lbhallado
	 		SELECT CsrFamilia
	 		LOCATE FOR numero = CsrCuentaX.numero
	 		IF numero <> CsrCuentaX.numero
				INSERT INTO CsrFamilia (id,numero,nombre,switch);
				VALUES (lnidFam,CsrCuentaX.numero,CsrCuentaX.nombre,"00000")
				
				lnidFamilia = lnidFam
				
				INSERT INTO CsrAfeCateProd (id,idpadre,idhijo,clave,switch,estado);
				VALUES (lnidAfe,lnidFam,lnidTipoGral,'FT',"00000",0)
				
				lnidAfe = lnidAfe + 1 
				lnidFam = lnidFam + 1 
			ENDIF 
		ENDIF 
		
		INSERT INTO CsrRubro (id,numero,nombre,switch);
		VALUES (lnidRubro,OscRubro.numero,OscRubro.nombre,"00000")
		
		lnidRubro = lnidRubro + 1
  	ELSE
  		lnidFamilia = lnidFamGral
  		SELECT CsrRubro
  		GO TOP   		
  	ENDIF 
  	
	lnIdSeccion = CsrRubro.id
	
	INSERT INTO CsrAfeCateProd (id,idpadre,idhijo,clave,switch,estado);
	VALUES (lnidAfe,lnIdSeccion,lnidFamilia,'RF',"00000",0)		
	
	lnidAfe = lnidAfe + 1 
	
	SELECT CsrCuentaX
ENDSCAN 

SELECT MAX(CsrProdRubro.codrubro) as proximonro FROM CsrProdRubro INTO CURSOR CsrNextId

&&Producto de importacion
INSERT INTO CsrRubro (id,numero,nombre,switch) VALUES (lnidRubro,CsrNextId.proximonro+1,"IMPORTACION",'00010')


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

USE IN CsrSeccion 
USE IN CsrCuentaX
USE IN CsrNextId
