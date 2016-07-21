
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
****
IF USED('CsrCtacte')
	USE IN CsrCtacte
ENDIF 
USE ALARCIA!ctacte IN 0 ALIAS Csrctacte EXCLUSIVE

****
IF USED('CsrChofer')
	USE IN CsrChofer
ENDIF 
USE ALARCIA!chofer IN 0 ALIAS Csrchofer EXCLUSIVE
ZAP IN CsrChofer
****
IF USED('CsrCamion')
	USE IN CsrCamion
ENDIF 
USE ALARCIA!camion IN 0 ALIAS CsrCamion EXCLUSIVE
ZAP IN CsrCamion
****
SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE "\soft\ALARCIA\CEREALES\clientes" in 0 alias CsrTransporte EXCLUSIVE

USE "\soft\ALARCIA\CEREALES\camiones" in 0 alias CsrCamiones EXCLUSIVE

USE "\soft\ALARCIA\CEREALES\chofer" in 0 alias CsrChoferes EXCLUSIVE




Oavisar.proceso('S','Procesando '+alias()) 
SELECT MAX(id) +1  as id FROM CsrCtacte INTO CURSOR CsrMaxId
SELECT CsrCtacte
GO BOTTOM 
lnid = VAL(SUBSTR(STR(CsrMaxId.id),3))
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = INT(VAL(str(Goapp.sucursal10+10,2)+lccadena))

SELECT CsrTransporte
Oavisar.proceso('S','Procesando '+alias()) 
GO top

STORE 0 TO lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia
STORE 0 TO lnctabanco,lnctaotro,lnidplanpago,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2
STORE 0 TO lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc
STORE 1 TO 	lnctadeudor,lnlista, lnidcanalvta

lccnumero		= STRZERO(VAL(SUBSTR(STR(lnid),3)),6)
lccnombre		= 'TRANSPORTE LAGO'
lccdireccion	= ""
lccpostal		= ""
lcctelefono		= ""
lcemail			= ""
lccuit			= ""
ldfechalta		= DATETIME(1900,01,01,0,0,0)
lcobserva		= ""
lcinscri01		= ""
ldfecins01		= DATETIME(1900,01,01,0,0,0)
lcinscri02		= ""
lcinscri03		= ""
lcingbrutos		= ""
ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
ldfecultpago	= DATETIME(1900,01,01,0,0,0)
lcnumdoc		= ""
lnexisteibto	= 0
lnexistegan 	= 0
lctelefono2 	= ""
lndiasvto		= 0
lntipocuit 		= 0
lcLocalidadBuscada = 0
lnidplanpago	= 0

DEBUG
SUSPEND 
lnidcategoria = 0
lntipoiva =0
lncuit=''

*!*	SELECT CsrCtacte
*!*	APPEND BLANK
*!*	REPLACE id with lnid,cnumero with lccnumero,cnombre with lccnombre,cdireccion with lccdireccion,cpostal with lccpostal;	
*!*	,idlocalidad with lnidlocalidad, idprovincia with lnidprovincia,ctelefono with lcctelefono,email with lcemail;
*!*	,tipoiva with lntipoiva,cuit with lccuit,idcategoria with lnidcategoria,ctadeudor with lnctadeudor IN CsrCtacte
*!*	replace ctaacreedor with lnctaacreedor,ctalogistica with lnctalogistica,ctabanco with lnctabanco,ctaotro with lnctaotro;
*!*	,idplanpago	with lnidplanpago,idcanalvta with lnidcanalvta,fechalta with ldfechalta,observa with lcobserva;
*!*	,saldo with lnsaldo,saldoant with lnsaldoant,estadocta with lnestadocta,bonif1 with lnbonif1;
*!*	,bonif2 with lnbonif2,copiatkt with lncopiatkt,inscri01 with lcinscri01,fecins01 with ldfecins01 IN CsrCtacte
*!*	replace inscri02 with lcinscri02,inscri03 with lcinscri03,convenio with lnconvenio,saldoauto with lnsaldoauto;
*!*	,idbarrio with lnidbarrio,lista with lnlista,idcateibrng with lnidcateibrng,ingbrutos with lcingbrutos;
*!*	,comision with lncomision,fecultcompra with ldfecultcompra,fecultpago with ldfecultpago IN CsrCtacte
*!*	replace numdoc with lcnumdoc,idtipodoc	with lnidtipodoc,existeibto	with lnexisteibto,existegan	with lnexistegan;
*!*	,ctelefono2 with lctelefono2,diasvto with lndiasvto IN CsrCtacte

INSERT INTO CsrCtacte (id ,cnumero ,cnombre ,cdireccion ,cpostal,idlocalidad, idprovincia ,ctelefono,email ;
,tipoiva,cuit ,idcategoria ,ctadeudor , ctaacreedor ,ctalogistica ,ctabanco,ctaotro;
,idplanpago,idcanalvta ,fechalta ,observa ,saldo ,saldoant ,estadocta ,bonif1 ;
,bonif2 ,copiatkt ,inscri01 ,fecins01, inscri02,inscri03 ,convenio ,saldoauto;
,idbarrio ,lista ,idcateibrng,ingbrutos,comision ,fecultcompra ,fecultpago;
, numdoc ,idtipodoc	,existeibto	,existegan,ctelefono2 ,diasvto );
values (lnid,lccnumero, lccnombre,lccdireccion,lccpostal, lnidlocalidad,  lnidprovincia,lcctelefono, lcemail;
, lntipoiva,lccuit, lnidcategoria, lnctadeudor , lnctaacreedor,lnctalogistica, lnctabanco, lnctaotro;
, lnidplanpago, lnidcanalvta, ldfechalta, lcobserva, lnsaldo, lnsaldoant, lnestadocta, lnbonif1;
, lnbonif2, lncopiatkt, lcinscri01, ldfecins01, lcinscri02, lcinscri03, lnconvenio, lnsaldoauto;
, lnidbarrio, lnlista,lnidcateibrng, lcingbrutos, lncomision, ldfecultcompra, ldfecultpago;
, lcnumdoc, lnidtipodoc,lnexisteibto, lnexistegan, lctelefono2, lndiasvto )

*!*			INSERT INTO cSRcTACTE (id,cnumero,cnombre,ctaotro) VALUES (lnid,lccnumero,'TRANSPORTE LAGO',1)
*!*	           lnid = lnid +1 
*ENDSCAN
*** filtramos solo los transportes
SELECT CsrCtacte
SET FILTER TO ctaotro = 1

SELECT CsrChofer
lnid = 1
IF FSIZE('id')>4
   lntam = 10
ELSE 
   lntam = 8
ENDIF  
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrChoferes
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
		IF numero=0
        	LOOP 
        ENDIF
        lcnombre = mayStr(CsrChoferes.nombre)
        lccuit = STRTRAN(CsrChoferes.carnet,'-','')
        lccuit = STRTRAN(lccuit,'/','')
        lnnumero = CsrChoferes.numero
        lnnumdoc = VAL(CsrChoferes.documento)
        lnidctacte = CsrCtacte.id
        SELECT CsrCtacte
        LOCATE FOR cnumero=LTRIM(STR(CsrChoferes.empresa))
        IF cnumero=LTRIM(STR(CsrChoferes.empresa))
        	lnidctacte = CsrCtacte.id
        ENDIF 
        
		INSERT INTO CsrChofer (id,numero,nombre,cuit,numdoc,idctatransp);
		VALUES (lnid,lnnumero,lcnombre,lccuit,lnnumdoc,lnidctacte)
      	lnid = lnid + 1
		SELECT CsrChoferes
ENDSCAN
SELECT CsrCtacte
SET FILTER TO

SELECT CsrCamion
lnid = 1
IF FSIZE('id')>4
   lntam = 10
ELSE 
   lntam = 8
ENDIF  
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
lnnumero = 0
SELECT CsrCamiones
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
		IF EMPTY(numero)
        	LOOP 
        ENDIF
        lcnombre = mayStr(CsrCamiones.nombre)
        lcpatente = LTRIM(CsrCamiones.numero)
        lnnumero = lnnumero+1
        lcmarca  = mayStr(CsrCamiones.marca)
        lccolor	 = mayStr(CsrCamiones.color)
        lntara 	 = CsrCamiones.tara
        lcswitch = '00001'
        lnidctacte = 0
        SELECT CsrCtacte
        LOCATE FOR cnumero=LTRIM(STR(CsrCamiones.empresa))
        IF cnumero=LTRIM(STR(CsrCamiones.empresa))
        	lnidctacte = CsrCtacte.id
        ENDIF 
        lnidchofer = 0
        SELECT CsrChofer
        LOCATE FOR numero = CsrCamiones.chofer
        IF numero = CsrCamiones.chofer
        	lnidchofer = CsrChofer.id
        ENDIF 
		INSERT INTO CsrCamion (id,numero,nombre,switch,idctatransp,idchofer,patente,marca,color,tara);
		VALUES (lnid,lnnumero,lcnombre,lcswitch,lnidctacte,lnidchofer,lcpatente,lcmarca,lccolor,lntara)
      	lnid = lnid + 1
		SELECT CsrCamiones
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	