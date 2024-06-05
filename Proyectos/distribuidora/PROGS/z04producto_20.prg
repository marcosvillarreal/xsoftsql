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
*llok = CargarTabla(lcData,'Marca',.t.)
llok = CargarTabla(lcData,'SubProducto',.t.)
llok = CargarTabla(lcData,'BloqueoProd',.t.)
llok = CargarTabla(lcData,'GamaBase',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Ctacte')

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


USE  ALLTRIM(lcpath )+"\gestion\articulo" in 0 alias CsrArtOld EXCLUSIVE	

SELECT * FROM CsrArtOld INTO CURSOR CsrArticulo READWRITE 

USE IN CsrArtOld

SELECT distinct UPPER(familia) as nombre  FROM CsrArticulo INTO CURSOR CsrSeccion READWRITE 

*SELECT distinct UPPER(nsubf) as nombre FROM CsrArticulo INTO CURSOR CsrSeccion READWRITE 

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Deposito 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrDeposito',lcCmd)
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Ubicacion 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrUbicacion',lcCmd)
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM TipoFrio 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrTipoFrio',lcCmd)
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM TipoIVA 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrTipoIVA',lcCmd)
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Forma 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrForma',lcCmd)
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Forma 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrMarca',lcCmd)
	RETURN .f.
ENDIF 

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid


SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

lnid = RecuperarID('CsrRubro',Goapp.sucursal10)
lnCodigo = 1
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
        
        IF LEN(LTRIM(lcnombre))=0
	    	lcNombre='SIN ESPECIFICAR'
	    ENDIF 
                         
       	INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
       					,porcecomi,porcesuge,porcedev,tasavied,tasapata) ;
       	VALUES (lnid,lnCodigo ,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfuerzavta,lnolista;
       					,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata)
       	lnid = lnid + 1
		lnCodigo = lnCodigo + 1 
ENDSCAN


*!*	lnid = RecuperarID('CsrMarca',Goapp.sucursal10)

*!*	SELECT CsrMarcaVie
*!*	Oavisar.proceso('S','Procesando '+alias()) 
*!*	GO top
*!*	SCAN FOR !EOF()
*!*	 	lnporceflete = 0
*!*	 	lnporceflete2 = 0
*!*	  	lcnombre=NombreNi(ALLTRIM(UPPER(CsrMarcaVie.nombre)))
*!*	    IF LEN(LTRIM(lcnombre))=0
*!*	    	lcNombre='SIN ESPECIFICAR'
*!*	    ENDIF 
*!*	   	INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta);
*!*	   	VALUES (lnid,lnCodigo ,lcnombre,lnporceflete,lnporceflete2,lnidfuerzavta)
*!*	   	lnid = lnid + 1
*!*	   	lnCodigo = lnCodigo + 1 
*!*	ENDSCAN

SELECT CsrTipoFrio
GO top


lnid = RecuperarID('CsrProducto',Goapp.sucursal10)
lnCodigo = 1

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	
	
	lcnombre = NombreNi(alltrim(CsrArticulo.desart))
	lnidctacte = 0
	lnidseccion = 0
	lnfrio = 0
	lnidmarca = 0
	lnidubicacion = 0
	
    SELECT CsrCtacte
    LOCATE FOR ALLTRIM(referencia)=ALLTRIM(CsrArticulo.cprov) AND ctaacreedor=1
    IF FOUND()
    	lnidctacte = Csrctacte.id
    ENDIF

    SELECT CsrRubro
    LOCATE FOR UPPER(nombre)=ALLTRIM(UPPER(Csrarticulo.familia))
    IF FOUND()
        lnidseccion = CsrRubro.id
    ENDIF
    
    SELECT CsrTipoFrio
    GO TOP 
    lnfrio = CsrTipoFrio.id


    SELECT CsrMarca
   	GO TOP 
      lnidmarca = CsrMarca.id
   

	SELECT CsrUbicacion
	GO TOP 
	lnidubicacion = CsrUbicacion.id
	
	SELECT CsrTipoIVA
	LOCATE FOR tasa = CsrArticulo.tasa
	
	SELECT CsrForma
	GO TOP 
	
    lnfracciona = 0
    lnidestado 	= 1
    lnidiva     = CsrTipoIVA.id
    lnnolista   = 0 && IIF(Csrarticulo.figlista="N",1,0)
    lnnofactu   = 0 &&IIF(Csrarticulo.nofactu,1,0)
    lnespromo 	= 0 &&IF(csrarticulo.escodboni="S",1,0)
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= 0
    lnsireparto	= 0 &&IIF(EMPTY(CsrArticulo.sireparto),0,1)
   	lnidforma 	= CsrForma.id
	lninterno	= 0

	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfechaulcpr 	= ldfecha
	ldfechamodf = Csrarticulo.ult_prc
*!*		IF EMPTY(Csrarticulo.ultprc)
*!*			ldfechamodf 	= ldfecha
*!*		ELSE       
*!*			ldfechamodf = DATETIME(YEAR(Csrarticulo.fechapre),MONTH(Csrarticulo.fechapre),DAY(Csrarticulo.fechapre),0,0,0)
*!*		ENDIF 		
	ldfechabonif = ldfecha
	
	lnTasa = CsrTipoIVA.tasa
	lnCosto	  = CsrArticulo.pventa_1	
	lnFelte   = 0
	lnBonif1  = 0
	lnBonif2  = 0
	lnBonif3  = 0
	lnBonif4  = 0
	
	lnCostoBon	= lnCosto * (100 - lnBonif1)/100
	lnCostoBon	= lnCostoBon * (100 - lnBonif2)/100
	lnCostoBon	= lnCostoBon * (100 - lnBonif3)/100
	lnCostoBon	= lnCostoBon * (100 - lnBonif4)/100
	
	lnFlete	  = 0
	nFletePorce = 0
	
	lnprevta1 = CsrArticulo.pventa_1
	lnprevta2 = CsrArticulo.pventa_2
	lnprevta3 = CsrArticulo.pventa_3
	lnsugerido= lnprevta1 

	lnprevtaf1 = red(lnprevta1 * (1 + (IIF(lnTasa=0,21,lnTasa)/100)),2)
	lnprevtaf2 = red(lnprevta2 * (1 + (IIF(lnTasa=0,21,lnTasa)/100)),2)
	lnprevtaf3 = red(lnprevta2 * (1 + (IIF(lnTasa=0,21,lnTasa)/100)),2)
	
	lnidctacpra = 0
	lnidctavta = 0
	lnidenvase = 0
						
	INSERT INTO Csrproducto (id,NUMERO,NOMBRE,IDIVA,COSTO,MARGEN1,PREVTA1,MARGEN2,; 
	PREVTA2,SWITCH,idunidad,idtprod,idtamano,idcatego,idubicacio,idorigen,incluirped,idctacte,idrubro,MARGEN3,;
	PREVTA3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,nomodifica,nombulto,puntope,;
	idmoneda,incluirped,flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,desc1,min1,desc2,min2,desc3,min3,vtakilos,cprakilos,fecoferta,internoporce,idctacpra,idctaVTA,idenvase,fleteporce;
	,codbarra13); 	
	VALUES (lnid, lnCodigo , lcnombre,  lnidiva, lnCosto,	;
	0, lnPREVta1, 0, lnPREVta2, '00000', 1,1,1,1,lnidubicacion,1,1,lnidctacte, lnidseccion, 0, ;
	lnPREVta3, 0,0,lninterno, 1,Csrarticulo.kilos, lnidtipovta,lnidforma,lnfracciona,0,'',0,;
	1,1,lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnBonif1,lnbonif2, lnbonif3,;
	lnbonif4 ,lnidmarca,0, lnidestado	,lnnolista, lnnofactu,0,	lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,0,lnfrio,;
	lnsugerido,1,lnsireparto	,CsrArticulo.codart,0, 0,;
	0, 0, 0, 0,0,0,ldfechabonif,0,0,0;
	,lnidenvase,nfletePorce,CsrArticulo.cbarra)		

	lnid = lnid + 1
	lnCodigo = lnCodigo + 1 
	 SELECT CsrArticulo   				
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	

