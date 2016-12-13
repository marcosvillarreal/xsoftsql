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
llok = CargarTabla(lcData,'Rubro')
llok = CargarTabla(lcData,'Marca',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Ubicacion')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


*USE ALLTRIM(lcpath )+"\gestion\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\gestion\articulo" in 0 alias CsrArticulo EXCLUSIVE	

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid
*****
SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

lnid = RecuperarID('CsrRubro',Goapp.sucursal10)

*!*	SELECT CsrSeccion
*!*	Oavisar.proceso('S','Procesando '+alias()) 
*!*	GO top
*!*	SCAN FOR !EOF()
*!*	      	STORE 
*!*	        lntipoprod = 1100000001 && IIF(Csrseccion.pideauto="S",2,1)
*!*	        lntipovta   = 1100000001 &&IIF(Csrseccion.clase="L",2,1)
*!*	        lnretibruto = 1 &&IIF(CsrSeccion.perceib="S",1,0)
*!*	        lnolista = 0 &&IIF(CsrSeccion.estado='I',1,0)
*!*	        lnporcecomi = 0&&IIF(!EMPTY(STR(CsrSeccion.comision)),CsrSeccion.comision,0)
*!*	        lnporcedev = 0&&IIF(!EMPTY(STR(CsrSeccion.porcedev)),CsrSeccion.porcedev,0)
*!*	        lnporcesuge = 0&&IIF(!EMPTY(STR(CsrSeccion.porsuge)),CsrSeccion.porsuge,0) 
*!*	        lntasavied = 0&&IIF(!EMPTY(STR(CsrSeccion.tasa)),CsrSeccion.tasa,0)
*!*	        lntasapata = 0&&IIF(!EMPTY(STR(CsrSeccion.tasapata)),CsrSeccion.tasapata,0)
*!*		   	lcnombre=NombreNi(ALLTRIM(UPPER(CsrSeccion.nombre)))
*!*	                             
*!*	       	INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
*!*	       					,porcecomi,porcesuge,porcedev,tasavied,tasapata) ;
*!*	       	VALUES (lnid,CsrSeccion.numero,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfuerzavta,lnolista;
*!*	       					,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata)
*!*	       	lnid = lnid + 1

*!*	ENDSCAN

lnid = RecuperarID('CsrMarca',Goapp.sucursal10)

SELECT distinct UPPER(marca) FROM CsrArticulo ORDER BY UPPER(marca) INTO CURSOR CsrMarcaVie READWRITE 

SELECT CsrMarcaVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
  	lcnombre=NombreNi(ALLTRIM(UPPER(CsrMarcaVie.nombre)))
	lcnombre	= TablaMarcas(lcNombre)
	   
   	INSERT INTO Csrmarca (id,numero,nombre,idfuerzavta);
   	VALUES (lnid,CsrMarcaVie.numero,lcnombre,lnidfuerzavta)
   	
   	lnid = lnid + 1
ENDSCAN


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
	
	*Almacenamos el codigo anterior para luego importar las secciones con productos
*!*	    SELECT CsrRubro
*!*	    LOCATE FOR numero=Csrarticulo.seccion
*!*	    IF FOUND()
        lnidseccion = Csrarticulo.seccion
*!*	    ENDIF
    
    lcMarca = CsrArticulo.marca
    lcMarca	= TablaMarcas(lcMarca)
    
    SELECT CsrMarca
    LOCATE FOR nombre=lcMarca
    IF FOUND()
       lnidmarca = CsrMarca.id
    ENDIF

	SELECT CsrUbicacion
	GO TOP 
	lnidubicacion = CsrUbicacion.id
	
    lnfracciona = IIF(Csrarticulo.fraccion='S',1,0)
    lnidestado 	= IIF(empty(Csrarticulo.debaja),1,2)
    lnidiva     = VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,1),8))
    lnnolista   = 0 && IIF(Csrarticulo.figlista="N",1,0)
    lnnofactu   = 0 &&IIF(Csrarticulo.nofactu,1,0)
    lnespromo 	= 0 &&IF(csrarticulo.escodboni="S",1,0)
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= IIF(CsrArticulo.kilos="K",1,0)
    lnsireparto	= 0 &&IIF(EMPTY(CsrArticulo.sireparto),0,1)
   	lnidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
	lninterno	= IIF(ISNULL(CsrArticulo.interno),0.00,CsrArticulo.interno)

	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	IF EMPTY(Csrarticulo.fechaulcpr)
		ldfechaulcpr 	= ldfecha
	ELSE       
		ldfechaulcpr = DATETIME(YEAR(Csrarticulo.fechaulcpr),MONTH(Csrarticulo.fechaulcpr),DAY(Csrarticulo.fechaulcpr),0,0,0)
	ENDIF 		
	IF EMPTY(Csrarticulo.fechapre)
		ldfechamodf 	= ldfecha
	ELSE       
		ldfechamodf = DATETIME(YEAR(Csrarticulo.fechapre),MONTH(Csrarticulo.fechapre),DAY(Csrarticulo.fechapre),0,0,0)
	ENDIF 		
	IF EMPTY(Csrarticulo.fechabon)
		ldfechabonif	= GOMONTH(ldfecha,360*20)
	ELSE       
		ldfechabonif = DATETIME(YEAR(Csrarticulo.fechabon),MONTH(Csrarticulo.fechabon),DAY(Csrarticulo.fechabon),0,0,0)
	ENDIF 
	
	STORE 0 TO lnCosto,	lnFelte, lnBonif1,	lnBonif2,	lnBonif3,	lnBonif4,	lnCostoBon,	lnFlete,	nFletePorce
	STORE 0 TO lnprevta1,	lnprevta2,	lnprevta3,	lnsugerido,	lnprevtaf1,	lnprevtaf2,	lnprevtaf3
	STORE 0 TO 	lnidctacpra, lnidctavta
								
	INSERT INTO Csrproducto (id,NUMERO,NOMBRE,CODALFA,IDIVA,COSTO,MARGEN1,PREVTA1,MARGEN2,; 
	PREVTA2,SWITCH,idunidad,idtprod,idtamano,idcatego,idubicacio,idorigen,incluirped,idctacte,idrubro,MARGEN3,;
	PREVTA3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,nomodifica,nombulto,puntope,;
	idmoneda,incluirped,flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,desc1,min1,desc2,min2,desc3,min3,vtakilos,cprakilos,fecoferta,internoporce,idctacpra,idctaVTA,idenvase,fleteporce); 	
	VALUES (lnid, Csrarticulo.NUMERO, lcnombre, LTRIM(STR(Csrarticulo.numero)), lnidiva, lnCosto,	;
	Csrarticulo.utilidad, lnPREVta1, Csrarticulo.util2, lnPREVta2, '00000', 1,1,1,1,lnidubicacion,1,1,lnidctacte, lnidseccion, Csrarticulo.util3, ;
	lnPREVta3, 0,0,lninterno, Csrarticulo.unibulto,Csrarticulo.peso, lnidtipovta,lnidforma,lnfracciona,0,'',Csrarticulo.puntope,;
	1,1,lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnBonif1,lnbonif2, lnbonif3,;
	lnbonif4 ,lnidmarca,0, lnidestado	,lnnolista, lnnofactu,0,	lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,0,lnfrio,;
	lnsugerido,1,lnsireparto	,IIF(EMPTY(CsrArticulo.codigo_prv),' ',CsrArticulo.codigo_prv),CsrArticulo.bonies, CsrArticulo.minimo,;
	CsrArticulo.bonies2, CsrArticulo.minimo2, CsrArticulo.bonies3, CsrArticulo.minimo3,LNVTAKILOS,LNVTAKILOS,ldfechabonif,0,lnidctacpra,lnidctavta;
	,lnidenvase,nfletePorce)		

	lnid = lnid + 1

	 SELECT CsrArticulo   				
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
*USE IN  CsrSeccion 
USE IN  CsrArticulo 
USE in CsrmarcaVie 

