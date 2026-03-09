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
llok = CargarTabla(lcData,'TipoIVA')
*!*	llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Ctacte')
*!*	llok = CargarTabla(lcData,'PlanCue')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 

*stop()

USE ALLTRIM(lcpath )+"\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\proveed" in 0 alias CsrAcreedor EXCLUSIVE

USE  ALLTRIM(lcpath )+"\articulo" in 0 alias CsrArticulo EXCLUSIVE	

USE ALLTRIM(lcpath )+"\marcas" in 0 alias CsrmarcaVie EXCLUSIVE

USE ALLTRIM(lcpath )+"\deposito" IN 0 ALIAS CsrdepositoVie EXCLUSIVE

USE ALLTRIM(lcpath )+"\codbarra" IN 0 ALIAS CsrCodBarra EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid

SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

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
*!*	    IF delogico
*!*	       LOOP 
*!*	    ENDIF 
 	lnporceflete = 0
 	lnporceflete2 = 0
  	lcnombre=NombreNi(ALLTRIM(UPPER(CsrMarcaVie.nombre)))
   
   	INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta);
   	VALUES (lnid,CsrMarcaVie.numero,lcnombre,lnporceflete,lnporceflete2,lnidfuerzavta)
   	lnid = lnid + 1
ENDSCAN


&&&&UBICACIONES
lnid = RecuperarID('CsrUbicacion',Goapp.sucursal10)

lcnumero = "1"
lcnombre= "UBICACIÓN GENERAL"
INSERT INTO CsrUbicacion (id,numero,nombre)	VALUES (lnid,lcnumero,lcnombre)

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
	LOCATE FOR numero=CsrArticulo.numero 
	IF numero=CsrArticulo.numero
		SELECT CsrArticulo
		LOOP 
	ENDIF
	lcnombre = NombreNi(alltrim(CsrArticulo.nombre))
	lnidctacte = 0
	lnidseccion = 0
	lnfrio = 0
	lnidmarca = 0
	lnidubicacion = 0
	lcCodBarra = ""
	
    SELECT CsrCtacte
    LOCATE FOR cnumero=LTRIM(STR(1000+Csrarticulo.proveedor))
    IF FOUND()
    	lnidctacte = Csrctacte.id
    ENDIF

    SELECT CsrRubro
    LOCATE FOR numero=Csrarticulo.seccion
    IF FOUND()
        lnidseccion = CsrRubro.id
    ENDIF
    
*!*	    SELECT CsrTipoFrio
*!*	    LOCATE FOR numero=Csrarticulo.frio
*!*	    IF FOUND()
*!*	        lnfrio = CsrTipoFrio.id
*!*	    ENDIF

    SELECT CsrMarca
    LOCATE FOR numero=Csrarticulo.marca
    IF FOUND()
       lnidmarca = CsrMarca.id
    ENDIF
	
*!*		SELECT CsrCodBarra
*!*		LOCATE FOR numero = CsrArticulo.numero
*!*		IF FOUND()
*!*			lcCodBarra = strtrim(CsrCodBarra.codbarra,13)
*!*		ENDIF 
	
	SELECT CsrUbicacion
	GO TOP 
	lnidubicacion = CsrUbicacion.id
*!*		LOCATE FOR numero = ALLTRIM(STR(VAL(CsrArticulo.codigo_emb),5))
*!*		IF FOUND()
*!*			lnidubicacion = CsrUbicacion.id
*!*		ENDIF 	
	
    lnfracciona = IIF(Csrarticulo.fraccion='S',1,0)
    lnidestado 	= 1 &&IIF(empty(Csrarticulo.debaja),1,2)
    lnidiva     = VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,IIF(Csrarticulo.tablaiva=2,1,3)),8)) &&strzero(IIF(Csrarticulo.tipoiva=1,2,1),8))
    lnnolista   = 0 && IIF(Csrarticulo.figlista="N",1,0)
    lnnofactu   = 0 &&IIF(Csrarticulo.nofactu,1,0)
    lnespromo 	= 0 &&IF(csrarticulo.escodboni="S",1,0)
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= 0 &&IIF(CsrArticulo.kilos="S",1,0)
    lnsireparto	= 0 &&IIF(EMPTY(CsrArticulo.sireparto),0,1)
   	lnidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
	lninterno	= 0 && IIF(ISNULL(CsrArticulo.interno),0.00,CsrArticulo.interno)
	lnpeso		= 0 &&Csrarticulo.peso
	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfechaulcpr 	= ldfecha
	ldfechamodf 	= ldfecha
	ldfechabonif	= ldfecha
	
	IF NOT EMPTY(Csrarticulo.fechaulcpr)     
		ldfechaulcpr = DATETIME(YEAR(Csrarticulo.fechaulcpr),MONTH(Csrarticulo.fechaulcpr),DAY(Csrarticulo.fechaulcpr),0,0,0)
	ENDIF 		
*!*		IF NOT EMPTY(Csrarticulo.fechapre)     
*!*			ldfechamodf = DATETIME(YEAR(Csrarticulo.fechapre),MONTH(Csrarticulo.fechapre),DAY(Csrarticulo.fechapre),0,0,0)
*!*		ENDIF 		
*!*		IF NOT EMPTY(Csrarticulo.fechabon)    
*!*			ldfechabonif = DATETIME(YEAR(Csrarticulo.fechabon),MONTH(Csrarticulo.fechabon),DAY(Csrarticulo.fechabon),0,0,0)
*!*		ENDIF 	
	STORE 0 TO lnBonif2,lnBonif3,lnBonif4,lnsugerido
	
	SELECT CsrTipoiva
	LOCATE FOR id = lnidiva
	lntasa	= 1 + CsrTipoiva.tasa /100
	
	lnCosto	  = CsrArticulo.costo	
	lnFletePorce   = CsrArticulo.flete
	lnBonif1  = CsrArticulo.bonif1 &&CsrArticulo.bonifica
	lnBonif2  = CsrArticulo.bonif2
	lnBonif3  = CsrArticulo.bonif3
	lnBonif4  = CsrArticulo.bonif4
	
	lnCostoBon	= lnCosto * (100 - lnBonif1)/100
	lnCostoBon	= lnCostoBon * (100 - lnBonif2)/100
	lnCostoBon	= lnCostoBon * (100 - lnBonif3)/100
	lnCostoBon	= lnCostoBon * (100 - lnBonif4)/100
	
	lnFlete	  = ROUND(lnCostoBon * (lnfletePorce/100),2)
	
	lnmargen1 = Csrarticulo.utilidad
	lnmargen2 = Csrarticulo.utilidad2
	lnmargen3 = Csrarticulo.utilidad3
	lnmargen4 = Csrarticulo.utilidad4
	
	lnPrecio	= ROUND((lnCostoBon + lnFlete ),2)
	
	lnprevta1	= ROUND(lnPrecio * (1 + (lnmargen1/100)),2) 
	lnprevta2	= ROUND(lnPrecio * (1 + (lnmargen2/100)),2) 
	lnprevta3	= ROUND(lnPrecio * (1 + (lnmargen3/100)),2) 
	lnprevta4	= ROUND(lnPrecio * (1 + (lnmargen4/100)),2) 
	
*!*		lnprevta1 = Csrarticulo.PREVenta1
*!*		lnprevta2 = Csrarticulo.PREVenta2
*!*		lnprevta3 = Csrarticulo.PREVenta3
*!*		lnprevta4= Csrarticulo.PREVenta4
	
	lnprevtaf1 = ROUND(lnprevta1 * lnTasa,2)
	lnprevtaf2 = ROUND(lnprevta2 * lnTasa,2)
	lnprevtaf3 = ROUND(lnprevta3 * lnTasa,2)
	lnprevtaf4 = ROUND(lnprevta4 * lnTasa,2)
	
	
	
	lnidctacpra = 0
	lnidctavta = 0
	
*!*		SELECT CsrPlanCue
*!*		LOCATE FOR nombre = "COMPRA DE MERCADERIA VARIA"
*!*		IF FOUND()
*!*			lnidctacpra = CsrPlanCue.id
*!*		ENDIF
*!*		SELECT CsrPlanCue
*!*		LOCATE FOR nombre = "VENTA DE MERCADERIA VARIA"
*!*		IF FOUND()
*!*			lnidctavta = CsrPlanCue.id
*!*		ENDIF 
	*Guardamos el numero de CsrArticulo.envase que es una referencia a CsrAticulo.numero del envase
	*Una vez caragdo todos los productos, recorremos los que idenvase#0 y buscamos el articulo = envase.
	lnidenvase = 0 &&VAL(CsrArticulo.envase)
						
	INSERT INTO Csrproducto (id,NUMERO,NOMBRE,CODALFA,IDIVA,COSTO,MARGEN1,PREVTA1,MARGEN2,; 
	PREVTA2,SWITCH,idunidad,idtprod,idtamano,idcatego,idubicacio,idorigen,incluirped,idctacte,idrubro,MARGEN3,;
	PREVTA3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,nomodifica,nombulto,puntope,;
	idmoneda,incluirped,flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,desc1,min1,desc2,min2,desc3,min3,vtakilos,cprakilos,fecoferta,internoporce,idctacpra,idctaVTA,idenvase,;
	fleteporce,codbarra13); 	
	VALUES (lnid, Csrarticulo.NUMERO, lcnombre, LTRIM(STR(Csrarticulo.numero)), lnidiva, lnCosto,	;
	lnmargen1, lnPREVta1, lnmargen2, lnPREVta2, '00000', 1,1,1,1,lnidubicacion,1,1,lnidctacte, lnidseccion, lnmargen3, ;
	lnPREVta3, lnmargen4,lnprevta4,lninterno, 1,lnPeso, lnidtipovta,lnidforma,lnfracciona,0,'',Csrarticulo.puntope,;
	1,1,lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnBonif1,lnbonif2, lnbonif3,;
	lnbonif4 ,lnidmarca,0, lnidestado	,lnnolista, lnnofactu,0,	lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,lnprevtaf4,lnfrio,;
	lnsugerido,1,lnsireparto,' ',0, 0,;
	0, 0, 0,0,LNVTAKILOS,LNVTAKILOS,ldfechabonif,0,lnidctacpra,lnidctavta,lnidenvase,lnFletePorce,lcCodBarra)		

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
lnidvari = RecuperarID('CsrVariedad',Goapp.sucursal10)
nCodVari = 1
*lnidblo = RecuperarID('CsrBloqueoProd',Goapp.sucursal10)

		
SELECT distinct numero,codbarra FROM CsrCodBarra INTO CURSOR 'CsrAux2' ORDER BY numero
Oavisar.proceso('S','Procesando '+alias())

*stop()

SELECT CsrProducto
GO TOP 
SCAN 
	lnidart = CsrProducto.id
	
	SELECT CsrAux2
	COUNT ALL FOR numero = CsrProducto.numero TO nSabores
	LOCATE FOR numero = CsrProducto.numero 
	
	cCodBarra = strtrim(CsrAux2.codbarra,13)
	
	IF nSabores = 1
		replace codbarra13 WITH cCodBarra IN CsrProducto
	
	ELSE 
		
		DO WHILE NOT EOF() AND numero = CsrProducto.numero
		
			cCodBarra = strtrim(CsrAux2.codbarra,13)
			
			SELECT CsrVariedad
			GO TOP 
			lEncontrado = .f.
			lnidvariedad = 0
			DO WHILE NOT EOF() AND NOT lEncontrado
				lnidvariedad = CsrVariedad.id
				SELECT CsrSubProducto
				LOCATE FOR idvariedad = lnidvariedad AND idarticulo = lnidart
				IF NOT FOUND()
					lEncontrado = .t.
				ENDIF 
				SELECT CsrVariedad
				SKIP				
			ENDDO
			&&Si idvariedad = 0, debemos insertar una nueva 
			IF NOT lEncontrado
				lcnombre	= "SABOR "+STR(nCodVari,3)

				INSERT INTO CsrVariedad (id,numero,nombre,tag);
				VALUES (lnidvari,nCodVari,lcnombre,"00000000")
				lnidvariedad = lnidvari
				
				lnidvari = lnidvari + 1
				nCodVari = nCodVari + 1
			ENDIF 
			SELECT CsrVariedad
			LOCATE FOR id = lnidvariedad
			
			lnsubnum	= CsrVariedad.numero
			lcnom		= CsrVariedad.nombre
			
			INSERT INTO SubProducto (id,idarticulo,numero,subnumero,idvariedad,nombre,codigo,nofactura,estado);
			VALUES (lnidsub,lnidart,CsrProducto.numero,lnsubnum,lnidvariedad,lcnom,cCodbarra,0,0)
			
			lnidsub=lnidsub+1
			
			SELECT CsrAux2
			SKIP 
			
		ENDDO 
		
	ENDIF
	SELECT CsrProducto
	
ENDSCAN
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



Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
*!*	USE IN  CsrSeccion 
*!*	USE  IN  CsrAcreedor 
USE IN  CsrArticulo 
*!*	USE in CsrmarcaVie 
USE IN CsrdepositoVie 
 
