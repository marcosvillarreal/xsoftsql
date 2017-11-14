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
llok = CargarTabla(lcData,'TipoFrio')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


USE ALLTRIM(lcpath )+"\stock" IN 0 ALIAS CsrArticulo EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\proveedo" in 0 alias CsrAcreedor EXCLUSIVE

USE ALLTRIM(lcpath )+"\familia" in 0 alias CsrmarcaVie EXCLUSIVE

USE ALLTRIM(lcpath )+"\rubros" in 0 alias CsrSeccion EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid
*****
SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

SELECT CsrTipoFrio
GO top
lnidfrio	= CsrTipoFrio.id

lnid = RecuperarID('CsrRubro',Goapp.sucursal10)

SELECT CsrSeccion


Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	lnCodRubro	= VAL(CsrSeccion.codrubro)
	IF lnCodRubro = 0
		LOOP 
	ENDIF 
	      	 
	lntipoprod = 1100000001 && IIF(Csrseccion.pideauto="S",2,1)
	lntipovta   = 1100000001 &&IIF(Csrseccion.clase="L",2,1)
	lnretibruto = 1 &&IIF(CsrSeccion.perceib="S",1,0)
	lnolista = 0 &&IIF(CsrSeccion.estado='I',1,0)
	lnporcecomi = 0&&IIF(!EMPTY(STR(CsrSeccion.comision)),CsrSeccion.comision,0)
	lnporcedev = 0&&IIF(!EMPTY(STR(CsrSeccion.porcedev)),CsrSeccion.porcedev,0)
	lnporcesuge = 0&&IIF(!EMPTY(STR(CsrSeccion.porsuge)),CsrSeccion.porsuge,0) 
	lntasavied = 0&&IIF(!EMPTY(STR(CsrSeccion.tasa)),CsrSeccion.tasa,0)
	lntasapata = 0&&IIF(!EMPTY(STR(CsrSeccion.tasapata)),CsrSeccion.tasapata,0)
	lcnombre=NombreNi(ALLTRIM(UPPER(CsrSeccion.desrubro)))
	INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
		,porcecomi,porcesuge,porcedev,tasavied,tasapata) ;
	VALUES (lnid,lncodrubro,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfuerzavta,lnolista;
		,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata)
	lnid = lnid + 1

ENDSCAN
INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
		,porcecomi,porcesuge,porcedev,tasavied,tasapata) ;
VALUES (lnid,lncodrubro+1,'SIN RUBRO',lntipoprod,lntipovta,lnretibruto,lnidfuerzavta,lnolista;
		,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata)
		
lnid = RecuperarID('CsrMarca',Goapp.sucursal10)

SELECT CsrMarcaVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	lnCodMarca = VAL(CsrMarcaVie.codflia)
    IF lnCodMarca = 0
       LOOP 
    ENDIF 
 	lnporceflete = 0
 	lnporceflete2 = 0
  	lcnombre=NombreNi(ALLTRIM(UPPER(CsrMarcaVie.desflia)))
   
   	INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta);
   	VALUES (lnid,lnCodMarca,lcnombre,lnporceflete,lnporceflete2,lnidfuerzavta)
   	lnid = lnid + 1
ENDSCAN
INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta);
VALUES (lnid,lnCodMarca+1,'SIN MARCA',lnporceflete,lnporceflete2,lnidfuerzavta)

&&&&UBICACIONES
lnid = RecuperarID('CsrUbicacion',Goapp.sucursal10)

INSERT INTO CsrUbicacion (id,numero,nombre)	VALUES (lnid,'1','GENERAL')

lnid = RecuperarID('CsrProducto',Goapp.sucursal10)

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	SELECT CsrProducto
	IF DELETED()
		SELECT CsrArticulo
		LOOP 
	ENDIF 
	LOCATE FOR numero=CsrArticulo.codalias
	IF numero=CsrArticulo.codalias
		SELECT CsrArticulo
		LOOP 
	ENDIF
	
	STORE 0 TO lnFlete,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnFletePorce,lnPrevta1,lnPrevta2,lnPrevta3,lnPreventa4
	STORE 0 TO lnSugerido,lnPrevtaF1,lnPrevtaf2,lnPrevtaf3,lnPrevetaf4, lninterno
	STORE 0 TO lnidctacte, lnidseccion,	lnidmarca,	lnidubicacion,lnidenvase
	STORE 0 TO lnnolista, lnnofactu, lnespromo, lnsireparto,lnidctacpra, lnidctavta
	
*!*		SELECT CsrCtacte
*!*	    LOCATE FOR cnumero=LTRIM(STR(10000+Csrarticulo.proveedor))
*!*	    IF FOUND()
*!*	    	lnidctacte = Csrctacte.id
*!*	    ENDIF

    SELECT CsrRubro
    LOCATE FOR numero=VAL(Csrarticulo.codrubro)
    IF NOT FOUND()
    	GO BOTTOM
    ENDIF 
    lnidseccion = CsrRubro.id
    
    SELECT CsrMarca
    LOCATE FOR numero=VAL(Csrarticulo.codflia)
    IF NOT FOUND()
    	GO BOTTOM 
    ENDIF 
    
    Lnidmarca = CsrMarca.id
    	
	SELECT CsrUbicacion
	GO TOP 
	lnidubicacion = CsrUbicacion.id

	lcnombre	= NombreNi(alltrim(CsrArticulo.desarti))
	lnCodigo	= CsrArticulo.codalias
	lcCodArti	= CsrArticulo.codArti
	lnfracciona = 1 &&IIF(Csrarticulo.fraccion='S',1,0)
    lnidestado 	= IIF(Csrarticulo.activo,1,2)
    lnidiva     = 1100000001 &&VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,1),8))
   	lnunibulto	= CsrArticulo.cantxum
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= IIF(UPPER(CsrArticulo.u_medida)$"KILOS-KG",1,0)
   	lnidforma 	= 1100000001

	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfechaulcpr 	= ldfecha
	ldfechamodf 	= ldfecha
	ldfechabonif	= GOMONTH(ldfecha,360*20)
	
	lnCosto		= CsrArticulo.p_compra
	lnCostoBon	= lnCosto

	lnprevta1 = Csrarticulo.p_lisiva

	lnprevtaf1 = lnprevta1 * 1.21

	lnUtil1		= CsrArticulo.utilidad
	lnUtil2		= 0
	lnUtil3		= 0
	lnUtil4		= 0
	lnPeso		= 0					
	
	INSERT INTO Csrproducto (id,NUMERO,NOMBRE,CODALFA,IDIVA,COSTO,MARGEN1,PREVTA1,MARGEN2,; 
	PREVTA2,SWITCH,idunidad,idtprod,idtamano,idcatego,idubicacio,idorigen,incluirped,idctacte,idrubro,MARGEN3,;
	PREVTA3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,nomodifica,nombulto,puntope,;
	idmoneda,incluirped,flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,desc1,min1,desc2,min2,desc3,min3,vtakilos,cprakilos,fecoferta,internoporce,idctacpra,idctaVTA,idenvase,fleteporce); 	
	VALUES (lnid, lnCodigo, lcnombre, lcCodArti, lnidiva, lnCosto,	;
	lnUtil1, lnPREVta1, lnutil2, lnPREVta2, '00000', 1,1,1,1,lnidubicacion,1,1,lnidctacte, lnidseccion, lnutil3, ;
	lnPREVta3, 0,0,lninterno, lnUniBulto,lnPeso, lnidtipovta,lnidforma,lnfracciona,0,'',0,;
	1,1,lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnBonif1,lnbonif2, lnbonif3,;
	lnbonif4 ,lnidmarca,0, lnidestado	,lnnolista, lnnofactu,0,	lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,0,lnidfrio,;
	lnsugerido,1,lnsireparto,"",0, 0,;
	0, 0, 0, 0,LNVTAKILOS,LNVTAKILOS,ldfechabonif,0;
	,lnidctacpra,lnidctavta;
	,lnidenvase,lnfletePorce)		

	lnid = lnid + 1

	 SELECT CsrArticulo   				
ENDSCAN

*!*	***Buscamos los productos que son envases
*!*	SELECT CsrEnvase.* FROM CsrProducto as CsrEnvase WHERE CsrEnvase.numero in (SELECT CsrProducto.idenvase FROM CsrProducto WHERE idenvase#0 );
*!*	INTO CURSOR CsrEnvase READWRITE 

*!*	SELECT CsrProducto
*!*	GO TOP 
*!*	SCAN 
*!*		IF idenvase=0
*!*			LOOP 
*!*		ENDIF 
*!*		SELECT CsrEnvase
*!*		LOCATE FOR numero = CsrProducto.idenvase
*!*		lnidenvase = 0
*!*		IF numero = CsrProducto.idenvase
*!*			lnidenvase = CsrEnvase.id
*!*		ENDIF 
*!*		replace idenvase WITH lnidenvase IN CsrProducto
*!*	ENDSCAN  

*!*	lnid = RecuperarID('CsrDeposito',Goapp.sucursal10)

*!*	SELECT CsrDepositoVie
*!*	Oavisar.proceso('S','Procesando '+alias()) 
*!*	GO top
*!*	SCAN FOR !EOF()
*!*	   	lcnombre=NombreNi(ALLTRIM(UPPER(CsrDepositovie.nombre)))
*!*		INSERT INTO Csrdeposito (id,numero,nombre,llevastock);
*!*		VALUES (lnid,Csrdepositovie.numero,lcnombre,1)
*!*		lnid = lnid + 1

*!*	ENDSCAN

*!*	LOCAL lnidsub,lnidblo
*!*	lnidsub = RecuperarID('CsrSubProducto',Goapp.sucursal10)
*!*	lnidblo = RecuperarID('CsrBloqueoProd',Goapp.sucursal10)

*!*			
*!*	SELECT distinct numero,sabor FROM CsrSubArticulo WHERE sabor<>0 INTO CURSOR 'CsrAux2' ORDER BY numero, sabor
*!*	SELECT CsrSubproducto
*!*	Oavisar.proceso('S','Procesando '+alias())
*!*	SELECT CsrAux2
*!*	SCAN
*!*		SELECT CsrProducto
*!*		LOCATE FOR numero = CsrAux2.numero
*!*		IF FOUND() AND numero = CsrAux2.numero
*!*			lnidart=CsrProducto.id
*!*			lnnum=CsrProducto.numero
*!*			SELECT CsrVariedad
*!*			LOCATE FOR numero = CsrAux2.sabor
*!*			IF FOUND()
*!*				lnidvari=CsrVariedad.id
*!*				lnsubnum=CsrVariedad.numero
*!*				lcnom=CsrVariedad.nombre
*!*				
*!*				INSERT INTO SubProducto (id,idarticulo,numero,subnumero,idvariedad,nombre,codigo,troquel,nofactura,estado);
*!*				VALUES (lnidsub,lnidart,lnnum,lnsubnum,lnidvari,lcnom,"0","00000000",0,0)
*!*				
*!*				lnidsub=lnidsub+1
*!*				*lnidsubs = VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(STR(lnidsub)))
*!*			ENDIF
*!*			
*!*		ENDIF
*!*		SELECT Csraux2
*!*		
*!*	ENDSCAN
*!*	SELECT CsrNoventa
*!*	Oavisar.proceso('S','Procesando '+alias())
*!*	SCAN
*!*		&& busco la ctacte y el articulo
*!*		SELECT CsrCtacte 
*!*		LOCATE FOR VAL(cnumero) = CsrNoventa.Cliente
*!*		IF FOUND()
*!*			lnidctacte = CsrCtacte.id
*!*			SELECT CsrProducto
*!*			LOCATE FOR numero = CsrNoventa.articulo
*!*			IF FOUND()
*!*				lnidarticulo = CsrProducto.id
*!*				IF CsrNoventa.sabor#0
*!*					SELECT csrVariedad
*!*					LOCATE FOR numero = CsrNoventa.sabor
*!*					IF FOUND()
*!*						SELECT CsrSubproducto
*!*						LOCATE FOR idarticulo = csrProducto.id AND idvariedad = CsrVariedad.id
*!*						IF FOUND()
*!*							lnidsubarti = CsrSubproducto.id
*!*						ELSE
*!*							lnidsubarti = 0
*!*						ENDIF 
*!*					ENDIF 
*!*				ELSE
*!*					lnidsubarti = 0
*!*				ENDIF 
*!*				&& guardo el dato
*!*				INSERT INTO CsrBloqueoProd (id,idarticulo,idsubarti,idctacte);
*!*				VALUES (lnidblo,lnidarticulo,lnidsubarti,lnidctacte)
*!*				lnidblo=lnidblo+1
*!*			ENDIF 
*!*		ENDIF 
*!*		SELECT CsrNoVenta
*!*	ENDSCAN

*!*	SELECT CsrCateCtacte

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE IN  CsrSeccion 
USE  IN  CsrAcreedor 
USE IN  CsrArticulo 
USE in CsrmarcaVie 

