PARAMETERS ldvacio,lcpath,lcBase
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
llok = CargarTabla(lcData,'Producto',.t.)
llok = CargarTabla(lcData,'Variedad',.t.)
llok = CargarTabla(lcData,'TipoFrio',.t.)
llok = CargarTabla(lcData,'Rubro',.t.)
llok = CargarTabla(lcData,'Marca',.t.)
llok = CargarTabla(lcData,'SubProducto',.t.)
llok = CargarTabla(lcData,'BloqueoProd',.t.)
llok = CargarTabla(lcData,'GamaBase',.t.)
llok = CargarTabla(lcData,'Deposito',.t.)
llok = CargarTabla(lcData,'Ubicacion',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'PlanCue')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


USE ALLTRIM(lcpath )+"\gestion\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\gestion\proveed" in 0 alias CsrAcreedor EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\articulo" in 0 alias CsrArticulo EXCLUSIVE	

USE ALLTRIM(lcpath )+"\gestion\marcas" in 0 alias CsrmarcaVie EXCLUSIVE

USE ALLTRIM(lcpath )+"\gestion\frios" in 0 alias CsrFrio EXCLUSIVE

USE ALLTRIM(lcpath )+"\gestion\noventa" IN 0 ALIAS CsrNoventa EXCLUSIVE

USE ALLTRIM(lcpath )+"\gestion\deposito" IN 0 ALIAS CsrdepositoVie EXCLUSIVE

USE ALLTRIM(lcpath )+"\gestion\sabor" IN 0 ALIAS CsrSabores EXCLUSIVE

USE ALLTRIM(lcpath )+"\gestion\codbarra" in 0 alias CsrSubArticulo EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid
*****

SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

lnid = RecuperarID('CsrVariedad',Goapp.sucursal10)
SELECT CsrSabores
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	lcnombre=NombreNi(alltrim(UPPER(CsrSabores.nombre)))
   	INSERT INTO CsrVariedad (id,numero,nombre,tag);
   	VALUES (lnid,CsrSabores.numero,lcnombre,"00000000")
   	lnid = lnid + 1

ENDSCAN

lnid = RecuperarID('CsrTipoFrio',Goapp.sucursal10)

SELECT CsrFrio
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	IF delogico
    	LOOP 
    ENDIF 
	lcnombre=NombreNi(ALLTRIM(UPPER(CsrFrio.nombre)))

   INSERT INTO CsrTipoFrio (id,numero,nombre)  VALUES (lnid,CsrFrio.numero,lcnombre)
   lnid = lnid + 1
          
ENDSCAN

lnid = RecuperarID('CsrRubro',Goapp.sucursal10)

SELECT CsrSeccion
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
      
        lntipoprod = 1100000001 && IIF(Csrseccion.pideauto="S",2,1)
        lntipovta   = 1100000001 &&IIF(Csrseccion.clase="L",2,1)
        lnretibruto = 1 &&IIF(CsrSeccion.perceib="S",1,0)
        lnolista = 0 &&IIF(CsrSeccion.estado='I',1,0)
        lnporcecomi = 0&&IIF(!EMPTY(STR(CsrSeccion.comision)),CsrSeccion.comision,0)
        lnporcedev = 0&&IIF(!EMPTY(STR(CsrSeccion.porcedev)),CsrSeccion.porcedev,0)
        lnporcesuge = 0&&IIF(!EMPTY(STR(CsrSeccion.porsuge)),CsrSeccion.porsuge,0) 
        lntasavied = 0&&IIF(!EMPTY(STR(CsrSeccion.tasa)),CsrSeccion.tasa,0)
        lntasapata = 0&&IIF(!EMPTY(STR(CsrSeccion.tasapata)),CsrSeccion.tasapata,0)
	   	lcnombre=NombreNi(ALLTRIM(UPPER(CsrSeccion.nombre)))
                             
       	INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
       					,porcecomi,porcesuge,porcedev,tasavied,tasapata) ;
       	VALUES (lnid,CsrSeccion.numero,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfuerzavta,lnolista;
       					,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata)
       	lnid = lnid + 1

ENDSCAN


lnid = RecuperarID('CsrMarca',Goapp.sucursal10)

SELECT CsrMarcaVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF delogico
       LOOP 
    ENDIF 
 	lnporceflete = 0
 	lnporceflete2 = 0
  	lcnombre=NombreNi(ALLTRIM(UPPER(CsrMarcaVie.nombre)))
   
   	INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta);
   	VALUES (lnid,CsrMarcaVie.numero,lcnombre,lnporceflete,lnporceflete2,lnidfuerzavta)
   	lnid = lnid + 1
ENDSCAN


&&&&UBICACIONES
lnid = RecuperarID('CsrUbicacion',Goapp.sucursal10)

SELECT distinct VAL(Codigo_emb) as numero FROM CsrArticulo INTO CURSOR CsrUbicacionVie
SELECT CsrUbicacionVie
Oavisar.proceso('S','Procesando Ubicaciones') 
GO top
SCAN FOR !EOF()
	lcnumero = ALLTRIM(STR(CsrUbicacionVie.numero,5))
  	lcnombre= "UBICACIÓN "+RTRIM(STRzero(VAL(lcnumero),5,0))
   	INSERT INTO CsrUbicacion (id,numero,nombre)	VALUES (lnid,lcnumero,lcnombre)
   	lnid = lnid + 1
ENDSCAN

lnid = RecuperarID('CsrProducto',Goapp.sucursal10)

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	STORE 0 TO	lnidctacte,lnidseccion,lnidfrio,lnidmarca,lnidubicacion,lnnolista,lnnofactu,lnespromo,lnidtipovta;
				,lnsireparto,lninterno,lnMinFac	

	
	SELECT CsrProducto
	LOCATE FOR numero=CsrArticulo.numero 
	IF numero=CsrArticulo.numero
		SELECT CsrArticulo
		LOOP 
	ENDIF
	lcnombre = NombreNi(alltrim(CsrArticulo.nombre))
	lnNumero = CsrArticulo.numero
	
    SELECT CsrCtacte
    LOCATE FOR cnumero=LTRIM(STR(30000+Csrarticulo.proveedor))
    IF FOUND()
    	lnidctacte = Csrctacte.id
    ENDIF

    SELECT CsrRubro
    LOCATE FOR numero=Csrarticulo.seccion
    IF FOUND()
        lnidseccion = CsrRubro.id
    ENDIF
    
    SELECT CsrTipoFrio
    LOCATE FOR numero=Csrarticulo.frio
    IF FOUND()
        lnfrio = CsrTipoFrio.id
    ENDIF

    SELECT CsrMarca
    LOCATE FOR numero=Csrarticulo.marca
    IF FOUND()
       lnidmarca = CsrMarca.id
    ENDIF

	SELECT CsrUbicacion
	GO TOP 
	lnidubicacion = CsrUbicacion.id
	LOCATE FOR numero = ALLTRIM(STR(VAL(CsrArticulo.codigo_emb),5))
	IF FOUND()
		lnidubicacion = CsrUbicacion.id
	ENDIF 	
	
    lnfracciona = IIF(Csrarticulo.fraccion='S',1,0)
    lnidestado 	= IIF(empty(Csrarticulo.debaja),1,2)
    lnidiva     = VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,IIF(Csrarticulo.tablaiva=2,3,1)),8))
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= IIF(CsrArticulo.kilos="K",1,0)
   	lnidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
	lninterno	= IIF(ISNULL(CsrArticulo.interno),lninterno,CsrArticulo.interno)
	lcCodAlfa	= LTRIM(STR(Csrarticulo.numero))
	lcSwitch	= "00000"
	lnIdIbto	= 1 &&CsrTipoIngBrutos
	lcCodProvee = IIF(EMPTY(CsrArticulo.codigo_prv),' ',CsrArticulo.codigo_prv)
	
	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	
	IF EMPTY(Csrarticulo.fechaulcpr)
		ldfechaulcpr 	= ldfecha
	ELSE       
		ldfechaulcpr = DATETIME(YEAR(Csrarticulo.fechaulcpr),MONTH(Csrarticulo.fechaulcpr),DAY(Csrarticulo.fechaulcpr),0,0,0)
	ENDIF 		
	ldfechamodf 	= ldfecha
	ldfechabonif	= GOMONTH(ldfecha,360*20)

	STORE 0 TO lnFlete,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnprevta2,lnprevta3,lnprevta4,lnsugerido,lnprevtaf2,lnprevtaf3,lnprevtaf4
	STORE 0 TO lnMargen1,lnMargen2,lnMargen3,lnMargen4,lnsegflete,lnInternoPorce
	
	lnCosto	  = CsrArticulo.preventa1
	
	lnCostoBon	= lnCosto

	lnprevta1 = Csrarticulo.PREVenta1

	lnprevtaf1 = Csrarticulo.PREVENTA1 * 1.21
							
	INSERT INTO Csrproducto (id,NUMERO,NOMBRE,CODALFA,IDIVA,COSTO,MARGEN1,PREVTA1,MARGEN2,; 
	PREVTA2,SWITCH,idubicacio,idctacte,idrubro,MARGEN3,PREVTA3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,puntope,;
	flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,vtakilos,cprakilos,fecoferta,internoporce); 	
	VALUES (lnid, lnNumero, lcnombre, lcCodAlfa, lnidiva, lnCosto,	;
	lnMargen1, lnPREVta1, lnMargen2, lnPREVta2, lcSwitch,lnidubicacion,lnidctacte, lnidseccion, lnMargen3, ;
	lnPREVta3, lnMargen4,lnPreVta4,lninterno, Csrarticulo.unibulto,Csrarticulo.peso, lnidtipovta,lnidforma,lnfracciona,Csrarticulo.puntope,;
	lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnBonif1,lnbonif2, lnbonif3,;
	lnbonif4 ,lnidmarca,lnsegflete, lnidestado	,lnnolista, lnnofactu,lnMinFac,lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,lnprevtaf4,lnfrio,;
	lnsugerido,lnIdIbto,lnsireparto	,lcCodProvee,LNVTAKILOS,LNVTAKILOS,ldfechabonif,lnInternoPorce)		

	lnid = lnid + 1

	 SELECT CsrArticulo   				
ENDSCAN


lnid = RecuperarID('CsrDeposito',Goapp.sucursal10)

SELECT CsrDepositoVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
   	lcnombre=NombreNi(ALLTRIM(UPPER(CsrDepositovie.nombre)))
	INSERT INTO Csrdeposito (id,numero,nombre,llevastock);
	VALUES (lnid,Csrdepositovie.numero,lcnombre,1)
	lnid = lnid + 1

ENDSCAN

LOCAL lnidsub,lnidblo
lnidsub = RecuperarID('CsrSubProducto',Goapp.sucursal10)
lnidblo = RecuperarID('CsrBloqueoProd',Goapp.sucursal10)

		
SELECT distinct numero,sabor FROM CsrSubArticulo WHERE sabor<>0 INTO CURSOR 'CsrAux2' ORDER BY numero, sabor
SELECT CsrSubproducto
Oavisar.proceso('S','Procesando '+alias())
SELECT CsrAux2
SCAN
	SELECT CsrProducto
	LOCATE FOR numero = CsrAux2.numero
	IF FOUND() AND numero = CsrAux2.numero
		lnidart=CsrProducto.id
		lnnum=CsrProducto.numero
		SELECT CsrVariedad
		LOCATE FOR numero = CsrAux2.sabor
		IF FOUND()
			lnidvari=CsrVariedad.id
			lnsubnum=CsrVariedad.numero
			lcnom=CsrVariedad.nombre
			
			INSERT INTO SubProducto (id,idarticulo,numero,subnumero,idvariedad,nombre,codigo,troquel,nofactura,estado);
			VALUES (lnidsub,lnidart,lnnum,lnsubnum,lnidvari,lcnom,"0","00000000",0,0)
			
			lnidsub=lnidsub+1
			*lnidsubs = VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(STR(lnidsub)))
		ENDIF
		
	ENDIF
	SELECT Csraux2
	
ENDSCAN
SELECT CsrNoventa
Oavisar.proceso('S','Procesando '+alias())
SCAN
	&& busco la ctacte y el articulo
	SELECT CsrCtacte 
	LOCATE FOR VAL(cnumero) = CsrNoventa.Cliente
	IF FOUND()
		lnidctacte = CsrCtacte.id
		SELECT CsrProducto
		LOCATE FOR numero = CsrNoventa.articulo
		IF FOUND()
			lnidarticulo = CsrProducto.id
			IF CsrNoventa.sabor#0
				SELECT csrVariedad
				LOCATE FOR numero = CsrNoventa.sabor
				IF FOUND()
					SELECT CsrSubproducto
					LOCATE FOR idarticulo = csrProducto.id AND idvariedad = CsrVariedad.id
					IF FOUND()
						lnidsubarti = CsrSubproducto.id
					ELSE
						lnidsubarti = 0
					ENDIF 
				ENDIF 
			ELSE
				lnidsubarti = 0
			ENDIF 
			&& guardo el dato
			INSERT INTO CsrBloqueoProd (id,idarticulo,idsubarti,idctacte);
			VALUES (lnidblo,lnidarticulo,lnidsubarti,lnidctacte)
			lnidblo=lnidblo+1
		ENDIF 
	ENDIF 
	SELECT CsrNoVenta
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE IN  CsrSeccion 
USE  IN  CsrAcreedor 
USE IN  CsrArticulo 
USE in CsrmarcaVie 
USE in CsrFrio 
USE IN CsrNoventa 
USE IN CsrdepositoVie 
USE in CsrSabores 
USE  IN CsrSubArticulo 
