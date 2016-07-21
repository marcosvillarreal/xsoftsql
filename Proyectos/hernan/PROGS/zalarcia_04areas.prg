
DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

CLOSE DATABASES
CLOSE TABLES
OPEN DATABASE ? EXCLUSIVE

SET SAFETY OFF

Oavisar.proceso('S','Vaciando archivos') 

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

SET DATABASE TO ALARCIA
USE ALARCIA!AreaNeg IN 0 ALIAS CsrAreaNeg EXCLUSIVE
ZAP IN CsrAreaNeg

USE ALARCIA!AreaNegCtacte IN 0 ALIAS CsrAreaNegctacte EXCLUSIVE
ZAP IN CsrAreaNegCtacte

USE ALARCIA!AreaNegRubro IN 0 ALIAS CsrAreaNegrubro EXCLUSIVE
ZAP IN CsrAreaNegRubro

USE ALARCIA!ctacte IN 0 ALIAS Csrctacte EXCLUSIVE

USE ALARCIA!rubro IN 0 ALIAS Csrrubro EXCLUSIVE


SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE  "\soft\ALARCIA\gestion\clientes" in 0 alias CsrDeudorViejo EXCLUSIVE

USE "\soft\ALARCIA\gestion\negocios" IN 0 ALIAS CsrNegocios EXCLUSIVE

USE "\soft\ALARCIA\gestion\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE



Oavisar.proceso('S','Procesando '+alias()) 
SELECT * FROM CsrDeudorViejo ORDER BY numero INTO CURSOR CsrDeudor

SELECT CsrAreaNeg
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid= VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrNegocios
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()    
	&&&comprobar Ñ
	lcnombre=alltrim(UPPER(CsrNegocios.nombre))
	IF '¤'$lcnombre OR '¥'$lcnombre
	 	FOR lni=1 to LEN(lcnombre)
	 		lc=SUBSTR(lcnombre,lni,1)
	 		IF '¤'=lc OR '¥'$lc
	 			lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('Ñ')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
	 		ENDIF 
	 	ENDFOR  
	ENDIF 
	&&&&&&        
   INSERT INTO CsrAreaNeg (id,numero,nombre);
   VALUES (lnid,CsrNegocios.numero,lcnombre)
   lnid = lnid +1 

ENDSCAN
*******************
*******aread de ctacte
*******************
SELECT CsrAreaNegCtacte
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid= VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN    
	SELECT CsrCtacte
	LOCATE FOR VAL(cnumero) = CsrDeudor.numero 
	IF !EMPTY(CsrDeudor.qareas) AND VAL(cnumero) = CsrDeudor.numero
		 IF recno('CsrDeudor')/100=INT(RECNO('CsrDeudor')/100)
	    	*Oavisar.proceso('N')
	    	lcTitulo = "Clientes/Proveedor "+STR(RECNO(),10)   
	    	*?(lctitulo)  
	    	Oavisar.proceso('S',lcTitulo,.t.,recno())
	 	ENDIF
		i=1
		lnarea = 0
		DO WHILE    i<LEN(ALLTRIM(CsrDeudor.qareas))
			lnarea = VAL(SUBSTR(CsrDeudor.qareas,i,4))
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
	SELECT CsrDeudor
ENDSCAN
********************
*****Areas de los rubros
********************
SELECT CsrAreaNegRubro
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid= VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrSeccion
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN 
   
	SELECT CsrRubro
	LOCATE FOR numero = CsrSeccion.numero 
	IF !EMPTY(CsrSeccion.qareas) AND numero = CsrSeccion.numero
		i=1
		lnarea = 0
		DO WHILE    i<LEN(ALLTRIM(CsrSeccion.qareas))
			lnarea = VAL(SUBSTR(CsrSeccion.qareas,i,4))
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
	SELECT CsrSeccion
ENDSCAN
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	