
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

SET DATABASE TO Alarcia
USE Alarcia!producto IN 0 ALIAS Csrproducto EXCLUSIVE
ZAP IN Csrproducto

USE Alarcia!fuerzavta IN 0 ALIAS CsrFuerzaVta EXCLUSIVE

USE Alarcia!ctacte IN 0 ALIAS Csrctacte EXCLUSIVE

USE Alarcia!Variedad IN 0 ALIAS CsrVariedad EXCLUSIVE
ZAP IN CsrVariedad

USE Alarcia!rubro IN 0 ALIAS Csrrubro EXCLUSIVE 
ZAP IN Csrrubro

USE Alarcia!areanegrubro IN 0 ALIAS CsrAreaNegrubro EXCLUSIVE 
ZAP IN CsrAreaNegrubro

USE Alarcia!marca IN 0 ALIAS Csrmarca EXCLUSIVE
ZAP IN Csrmarca

USE Alarcia!subproducto IN 0 ALIAS Csrsubproducto EXCLUSIVE
ZAP IN Csrsubproducto

USE Alarcia!localidad IN 0 ALIAS Csrlocalidad EXCLUSIVE

USE Alarcia!provincia IN 0 ALIAS Csrprovincia EXCLUSIVE

*!*	USE Alarcia!BLOQUEOPROD IN 0 ALIAS CsrBloqueProd EXCLUSIVE 
*!*	ZAP IN CsrBloqueProd

*USE Alarcia!motanula IN 0 ALIAS Csrmotanula EXCLUSIVE
*ZAP IN Csrmotanula

USE Alarcia!deposito IN 0 ALIAS Csrdeposito EXCLUSIVE
ZAP IN Csrdeposito

*!*	USE Alarcia!tipoctacte IN 0 ALIAS CsrTipoCtacte EXCLUSIVE
*!*	ZAP IN CsrTipoCtacte

USE Alarcia!Plancue IN 0 ALIAS CsrPlanCue EXCLUSIVE
SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE "\soft\ALARCIA\gestion\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE 

USE  "\soft\ALARCIA\gestion\proveed" in 0 alias CsrAcreedor EXCLUSIVE

USE  "\soft\ALARCIA\gestion\articulo" in 0 alias CsrArticulo EXCLUSIVE	
*USE  "\ALMACEN\DATA\articulo" in 0 alias CsrArticulo EXCLUSIVE

USE "\soft\ALARCIA\gestion\marcas" in 0 alias CsrmarcaVie EXCLUSIVE

USE "\soft\ALARCIA\gestion\localida" in 0 alias CsrLocalidadViejo EXCLUSIVE

USE "\soft\ALARCIA\gestion\provinci" in 0 alias CsrProvinciaViejo EXCLUSIVE

USE "\soft\ALARCIA\gestion\deposito" IN 0 ALIAS CsrdepositoVie EXCLUSIVE


SELECT CsrRubro
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)

SELECT CsrSeccion
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN
  	lnnumero		= CsrSeccion.numero
  	lcnombre		= CsrSeccion.nombre
  	lnidfuerzavta	= CsrFuerzaVta.id
	lcnombre 		= NombreNi(alltrim(CsrSeccion.nombre))                              
   INSERT INTO CsrRubro (id,numero,nombre,recargo,idtipovta,idtipoprod,perceibruto,idfuerzavta,nolista;
   ,porcecomi,porcedev,porcesuge,tasavied,tasapata) ;
   VALUES (lnid,lnnumero,lcnombre,0,0,0,0,lnidfuerzavta,1,0,0,0,0,0)
   
   lnid = lnid +1 

ENDSCAN
********************
********************
***HAY Q CARGAR LAS AREAS
********************
********************

SELECT CsrMarca
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)

SELECT CsrMarcaVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN  
    IF delogico
       LOOP 
    ENDIF 
    lnnumero		= CsrMarcaVie.numero
    lcnombre		= CsrMarcaVie.nombre
    lnflete			= 0
    lnflete2		= 0
    lnidfuerzavta	= CsrFuerzaVta.id
	lcnombre 		= NombreNi(alltrim(CsrMarcaVie.nombre))
   INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta);
   VALUES (lnid,lnnumero,lcnombre,lnflete,lnflete2,lnidfuerzavta)
   lnid = lnid +1 

ENDSCAN

SELECT CsrProducto
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	
	STORE 0 TO 	lnidctavta,lnidctacpra,lnnomodifica,lnsegflete,lncostobon,lncostorepo,lncostoulcpra;
	,lnmargen4,lnprevta4,lnprevtaf4,lnminimofac,lnpeso,lnvolumen,lnidenvase,lndesc1,lndesc2,lndesc3;
	,lnmin1,lnmin2,lnmin3,lninternoporce,lnctaaorden,lncprakilos,lnsiinforma,lnesinsumo,lnpeso;
	,lnsubsidiado,lnidingbrutoslp,lnfracciona,lnnolista,lnnofactura,lnespromocion,lnvtakilos,lndivisible;
	,lnimportado,lnidmarca,lnidctacte,lnidRubro,lnidFrio
	SELECT CsrProducto
	LOCATE FOR numero=CsrArticulo.numero 
	IF numero=CsrArticulo.numero
		SELECT CsrArticulo
		LOOP 
	ENDIF
	
    SELECT Csrctacte
    LOCATE FOR cnumero=LTRIM(STR(50000+Csrarticulo.proveedor))
    IF FOUND()
    	lnidctacte = Csrctacte.id
    ENDIF

    SELECT CsrRubro
    LOCATE FOR numero=Csrarticulo.seccion
    IF FOUND()
        lnidRubro = CsrRubro.id
    ENDIF

    SELECT CsrMarca
    LOCATE FOR numero=Csrarticulo.marca
    IF FOUND()
       lnidmarca = CsrMarca.id
    ENDIF
	
    lnfracciona = IIF(Csrarticulo.fraccion='S',1,0)
    lnidestado = 1 &&IIF(empty(Csrarticulo.debaja),1,2)
    lnidiva        = IIF(Csrarticulo.tablaiva=1,2,1)
    lnidtipovta = 1 &&IIF(Csrarticulo.quefactura="B",2,1)
   	lnidforma = 1  
	lninterno= IIF(ISNULL(CsrArticulo.interno),0.00,CsrArticulo.interno)

	ldfecha		= DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfeculcpra= ldfecha
	IF !EMPTY(Csrarticulo.fechaulcpr)
		ldfeculcpra = DATETIME(YEAR(Csrarticulo.fechaulcpr),MONTH(Csrarticulo.fechaulcpr),DAY(Csrarticulo.fechaulcpr),0,0,0)
	ENDIF 		
	ldfecmodi	= ldfecha
	IF !EMPTY(Csrarticulo.fecha)
		ldfecmodi = DATETIME(YEAR(Csrarticulo.fecha),MONTH(Csrarticulo.fecha),DAY(Csrarticulo.fecha),0,0,0)
	ENDIF 
	ldfecoferta	= ldfecha		
	
	lnprevta1 = Csrarticulo.PREVenta1
	lnprevta2 = Csrarticulo.PREVenta2
	lnprevta3 = Csrarticulo.PREVenta3
	lnsugerido= Csrarticulo.PREVenta4

	lnprevtaf1 = Csrarticulo.PREVENTA1 * 1.21
	lnprevtaf2 = Csrarticulo.PREVEnta2 * 1.21
	lnprevtaf3 = Csrarticulo.PREVEnta3 * 1.21
	
	lnmargen1 = CsrArticulo.utilidad
	lnmargen2 = CsrArticulo.utilidad2
	lnmargen3 = CsrArticulo.utilidad3
	
	lnidctacpra = 0&&CsrArticulo.cuenta
	lnidctavta = 0 &&CsrArticulo.cuenta

	lnidunidad 		= 1100000001
	lnidtprod		= 1100000001
	lnidtamano		= 1100000001
	lnidcatego		= 1100000001
	lnidubicacio	= 1100000001
	lnidorigen		= 1100000001
	lnidingbrutos	= 1100000001
	lnidmoneda		= 1100000001
	lcnombre 		= NombreNi(alltrim(CsrArticulo.nombre))
	lccontrolador	= CsrArticulo.nombre_plu
	lcnommayorista	= CsrArticulo.nombre_may
	lnppt			= CsrArticulo.itc
	lnitc			= IIF(EMPTY(Csrarticulo.leyenda),0,(IIF(ALLTRIM(CsrArticulo.leyenda)='I',1,2)))
	lnnumero 	 = CsrArticulo.numero
	lcnombulto 	 = ''
	lccodalfa	 = LTRIM(STR(lnNumero))
	lnincluirped = 1
	lncosto	 	 = Csrarticulo.costo
	lnflete		 = Csrarticulo.flete
	lnbonif1     = Csrarticulo.bonif1
	lnbonif2	 = Csrarticulo.bonif2
	lnbonif3	 = Csrarticulo.bonif3
	lnbonif4	 = Csrarticulo.bonif4
	ldfeculvta   = ldfecha
	ldfecalta	 = ldfecha
	lnunibulto	 = Csrarticulo.unibulto
	lnpuntope	 = Csrarticulo.puntope
	lcswitch	 = "00000"
	lccodartprod = ""
	TRY 
	INSERT INTO CsrProducto(id,numero,nombre,nombulto,codalfa,idctacte,idmarca;
	,idctavta,idctacpra,idforma,idunidad,idtprod,idtipovta,idtamano,idcatego,idrubro;
	,idestado,idubicacio,idorigen,nomodifica,incluirped,idiva,idmoneda,costo,flete;
	,segflete,interno,bonif1,bonif2,bonif3,bonif4,costobon,costorepo,costoulcpra,feculcpra;
	,margen1,prevta1,prevtaf1,margen2,prevta2,prevtaf2,margen3,prevta3,prevtaf3;
	,margen4,prevta4,prevtaf4,feculvta,fecalta,fecmodi,unibulto,nofactura,nolista;
	,espromocion,minimofac,peso,volumen,fracciona,puntope,switch,idenvase,sugerido;
	,idfrio,divisible,desc1,desc2,desc3,min1,min2,min3,codartprod,vtakilos,fecoferta;
	,internoporce,controlador,nommayorista,ppt,itc,subsidiado,ctaaorden,cprakilos;
	,siinforma,importado,esinsumo);
	VALUES	(lnid,lnnumero,lcnombre,lcnombulto,lccodalfa,lnidctacte,lnidmarca,lnidctavta,lnidctacpra;
	,lnidforma,lnidunidad,lnidtprod,lnidtipovta,lnidtamano,lnidcatego,lnidrubro,lnidestado,lnidubicacio;
	,lnidorigen,lnnomodifica,lnincluirped,lnidiva,lnidmoneda,lncosto,lnflete,lnsegflete,lninterno;
	,lnbonif1,lnbonif2,lnbonif3,lnbonif4,lncostobon,lncostorepo,lncostoulcpra,ldfeculcpra,lnmargen1;
	,lnprevta1,lnprevtaf1,lnmargen2,lnprevta2,lnprevtaf2,lnmargen3,lnprevta3,lnprevtaf3,lnmargen4;
	,lnprevta4,lnprevtaf4,ldfeculvta,ldfecalta,ldfecmodi,lnunibulto,lnnofactura,lnnolista,lnespromocion;
	,lnminimofac,lnpeso,lnvolumen,lnfracciona,lnpuntope,lcswitch,lnidenvase,lnsugerido,lnidfrio,lndivisible;
	,lndesc1,lndesc2,lndesc3,lnmin1,lnmin2,lnmin3,lccodartprod,lnvtakilos,ldfecoferta,lninternoporce;
	,lccontrolador,lcnommayorista,lnppt,lnitc,lnsubsidiado,lnctaaorden,lncprakilos,lnsiinforma,lnimportado;
	,lnesinsumo)
	CATCH TO oError
		oavisar.usuario(oError.Details+CHR(13);
 					+Oerror.Message+STR(oError.ErrorNo)+CHR(13);
 					+oError.Procedure++CHR(13)+oError.LineContents+CHR(13))
 		DEBUG
 		SUSPEND 
	ENDTRY  
   lnid = lnid +1 

	 SELECT CsrArticulo   				
ENDSCAN


SELECT CsrDeposito
lnid = 1
IF FSIZE('id')>4
   lntama = 10
ELSE 
   lntam = 8
ENDIF 
lccadena = strzero(lnid,lntam)
lnid = VAL(str(Goapp.sucursal10+10,2)+lccadena)
SELECT CsrDepositoVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN
	lnnumero		= CsrDepositoVie.numero
	lcnombre		= CsrDepositoVie.nombre
	lnllevastock	= 1
   	lcnombre		= NombreNi(CsrDepositovie.nombre)
   
	INSERT INTO Csrdeposito (id,numero,nombre,llevastock);
	VALUES (lnid,lnnumero,lcnombre,1)
   lnid = lnid +1 

ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	