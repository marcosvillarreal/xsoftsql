PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 
SET PROCEDURE TO z00_elsureño ADDITIVE 

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
llok = CargarTabla(lcData,'Deposito')
llok = CargarTabla(lcData,'Ubicacion',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'CanalVtaNeg',.t.)

*llok = CargarTabla(lcData,'Ctacte')
*llok = CargarTabla(lcData,'MapeoCarnico')

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 

SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

Oavisar.proceso('S','Abriendo archivos') 

local lnidrubro, lnidmarca, lncodrubro
store 0 to lnidrubro, lnidmarca ,lncodrubro


cArchivo = ALLTRIM(lcpath )+"\articulos.csv"
=LeerArticulos()
SELECT CsrArticulo
*vista()

cArchivo = ALLTRIM(lcpath )+"\precio.csv"
=LeerPrecios(cArchivo)
SELECT CsrPrecio
*vista()

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCanalVta.* FROM CanalVta as CsrCanalVta
ENDTEXT 
=CrearCursorAdapter('CsrCanalVta',lcCmd)


lnid = RecuperarID('CsrRubro',Goapp.sucursal10)
lncodrubro = 1
SELECT distinct UPPER(rubro) as nombre,VAL(codrubro) as codigo FROM CsrArticulo  WHERE VAL(codrubro)> 0 INTO CURSOR FsrRubro2 READWRITE 

SELECT nombre,codigo as codrubro FROM FsrRubro2 ORDER BY codigo INTO CURSOR FsrRubro READWRITE 
USE IN FsrRubro2

GO top
SCAN 
	STORE 1100000001 TO lntipoprod,lntipovta 
	lnretibruto	= 0 &&IIF(CsrSeccion.perceib="S",1,0)

	lcnombre	= NombreNi(ALLTRIM(UPPER(FsrRubro.nombre)))
	lncodrubro = (FsrRubro.codrubro)
	INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta) ;
	VALUES (lnid,lncodrubro,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfuerzavta)
	lnid = lnid +1 
	*lncodrubro = lncodrubro + 1 
ENDSCAN 

INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta) ;
VALUES (lnid,lncodrubro+1,"General",lntipoprod,lntipovta,lnretibruto,lnidfuerzavta)

	
lnid = RecuperarID('CsrMarca',Goapp.sucursal10)
INSERT INTO Csrmarca (id,numero,nombre,idfuerzavta);
VALUES (lnid,1,"GENERAL",lnidfuerzavta)

lnidcanalvtaneg = RecuperarID('CsrCanalVtaNeg',Goapp.sucursal10)

lnidcanalvta = 1100000003

lnid = RecuperarID('CsrUbicacion',Goapp.sucursal10)
INSERT INTO CsrUbicacion (id,numero,nombre)	VALUES (lnid,'1','GENERAL')

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCtacte.* FROM Ctacte as CsrCtacte WHERE ctaacreedor = 1
ENDTEXT 
=CrearCursorAdapter('CsrCtacte',lcCmd)

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
*stop()
SCAN FOR !EOF()
	SELECT CsrProducto
	
	LOCATE FOR numero=VAL(CsrArticulo.codigo)
	IF numero=VAL(CsrArticulo.codigo)
		SELECT CsrArticulo
		LOOP 
	ENDIF
	
	IF VAL(CsrArticulo.codigo) = 11016
		*stop()
	ENDIF 
	
		
	STORE 0 TO lnFlete,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnFletePorce,lnPrevta1,lnPrevta2,lnPrevta3,lnPreventa4
	STORE 0 TO lnSugerido,lnPrevtaF1,lnPrevtaf2,lnPrevtaf3,lnPrevetaf4, lninterno
	STORE 0 TO lnidctacte, lnidseccion,	lnidmarca,	lnidubicacion,lnidenvase
	STORE 0 TO lnnolista, lnnofactu, lnespromo, lnsireparto,lnidctacpra, lnidctavta , lnidfrio
	STORE 0 TO lnCosto,lnCostoBon,lnUtil1,lnUtil2,lnUtil3,lnUtil4,lnPeso,lnidtipocarnico
	
	SELECT CsrCtacte
    LOCATE FOR ctaacreedor=1
    IF FOUND()
    	lnidctacte = Csrctacte.id
    ENDIF

    SELECT CsrRubro
    LOCATE FOR numero=val(Csrarticulo.codrubro)
    IF NOT FOUND()
    	GO BOTTOM
    ENDIF 
    lnidseccion = CsrRubro.id
    	
    SELECT CsrMarca
    GO TOP 
    Lnidmarca = CsrMarca.id
    	
	SELECT CsrUbicacion
	GO TOP 
	lnidubicacion = CsrUbicacion.id

	lcnombre	= NombreNi(alltrim(CsrArticulo.nombre))
	lnCodigo	= VAL(CsrArticulo.codigo)
	lcCodArti	= "" &&CsrArticulo.codArti
	lnfracciona = 1 
    lnidestado 	= 1 
    lnTasa		= 21
    lnidiva     = 1100000002 &&VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,1),8))
   	lnunibulto	= IIF(VAL(CsrArticulo.unibulto)=0,1,VAL(CsrArticulo.unibulto))
    lnidtipovta = IIF(UPPER(CsrArticulo.univenta)$"B",2,1) &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= IIF(UPPER(CsrArticulo.univenta)$"KILOS-KG",1,0)
   	lnidforma 	= 1100000001
	lnpeso		= 1
	lnidfrio	= 1100000001
	
	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfechaulcpr 	= ldfecha
	ldfechamodf 	= DATE() &&CTOD(CsrArticulo.fecModf)
	ldfechabonif	= CTOD('01-01-1900') &&GOMONTH(ldfecha,360*20)
			
*!*		lnprevta1	= VAL(Csrarticulo.prevta1)
*!*		lnprevtaf1	= VAL(CsrArticulo.prevtaf1)
*!*		lnUtil1		= IIF(lnCosto=0,0,round(lnprevta1 * 100 / lnCosto,3) - 100)
*!*		lnprevta2	= VAL(Csrarticulo.prevta2)
*!*		lnprevtaf2	= VAL(CsrArticulo.prevtaf2)
*!*		lnUtil2		= IIF(lnCosto=0,0,round(lnprevta2 * 100 / lnCosto,3) - 100)
*!*		lnprevta3	= VAL(Csrarticulo.prevta3)
*!*		lnprevtaf3	= VAL(CsrArticulo.prevtaf3)
*!*		lnUtil3		= IIF(lnCosto=0,0,round(lnprevta3 * 100 / lnCosto,3) - 100)
*!*		lnUtil4		= 0
*!*		lnPeso		= 0
					
	SELECT CsrPrecio
	LOCATE FOR VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo) 
	IF VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo) 
		lnCosto		= VAL(CsrPrecio.costo)
		IF lnCosto > 0
			lnCostoBon	= lnCosto
			lnprevta1	= VAL(CsrPrecio.lista1)		
			lnUtil1		= red((lnprevta1 * 100) /  lnCosto,2) - 100
			lnprevtaf1	= red(lnprevta1 * (1 + (IIF(lnTasa=0,21,10.5)/100)),2)
			
			lnprevta2	= VAL(CsrPrecio.lista2)		
			lnUtil2		= red((lnprevta2 * 100) /  lnCosto,2) - 100
			lnprevtaf2	= red(lnprevta2 * (1 + (IIF(lnTasa=0,21,10.5)/100)),2)
			
			lnprevta3	= VAL(CsrPrecio.lista3)		
			lnUtil3		= red((lnprevta3 * 100) /  lnCosto,2) - 100
			lnprevtaf3	= red(lnprevta3 * (1 + (IIF(lnTasa=0,21,10.5)/100)),2)
			
			lnprevta4	= VAL(CsrPrecio.lista4)		
			lnUtil4		= red((lnprevta4 * 100) /  lnCosto,2) - 100
			lnprevtaf4	= red(lnprevta4 * (1 + (IIF(lnTasa=0,21,10.5)/100)),2)
		ENDIF 
	ELSE
		lnidestado = 2
		lnnolista = 1	
	ENDIF 

	IF lnPrevtaf1 = 0
		lnnofactu= 1
		lnnolista = 1
	ENDIF 
	
	INSERT INTO Csrproducto (id,numero,nombre,codalfa,idiva,costo,margen1,prevta1,margen2,; 
	prevta2,switch,idunidad,idtprod,idtamano,idcatego,idubicacio,idorigen,incluirped,idctacte,idrubro,margen3,;
	prevta3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,nomodifica,nombulto,puntope,;
	idmoneda,incluirped,flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,costobon,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,desc1,min1,desc2,min2,desc3,min3,vtakilos,cprakilos,fecoferta,internoporce,idctacpra,idctavta;
	,idenvase,fleteporce); 	
	values (lnid, lncodigo, lcnombre, lccodarti, lnidiva, lncosto,	;
	lnutil1, lnprevta1, lnutil2, lnprevta2, '00000', 1,1,1,1,lnidubicacion,1,1,lnidctacte, lnidseccion, lnutil3, ;
	lnprevta3,lnutil4 ,lnprevta4,lninterno, lnunibulto,lnpeso, lnidtipovta,lnidforma,lnfracciona,0,'',0,;
	1,1,lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnbonif1,lnbonif2, lnbonif3,;
	lnbonif4,lnCostoBon ,lnidmarca,0, lnidestado	,lnnolista, lnnofactu,0,	lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,lnprevtaf4,lnidfrio,;
	lnsugerido,1,lnsireparto,"",0, 0,;
	0, 0, 0, 0,lnvtakilos,lnvtakilos,ldfechabonif,0;
	,lnidctacpra,lnidctavta;
	,lnidenvase,lnfleteporce)		
	
*!*		SELECT CsrPrecio
*!*		LOCATE FOR VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo)
*!*		DO WHILE VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo) AND NOT EOF()
*!*			IF VAL(CsrPrecio.lista)<=2
*!*				SKIP 
*!*				LOOP 
*!*			ENDIF 
*!*					
*!*			lnprevtaX	= VAL(CsrPrecio.prevta)
*!*			
*!*			IF lnprevtaX = 0
*!*				SKIP 
*!*				LOOP 
*!*			ENDIF 
*!*				
*!*			lnUtilX		= red((lnprevtaX * 100) /  lnCosto,2) - 100
*!*			lnprevtafX	= red(lnprevtaX * (1 + (IIF(lnTasa=0,21,10.5)/100)),2)
*!*			ldfechamodf	= CTOD(CsrPrecio.fecha)
*!*			
*!*			IF ABS(lnUtilX)>900
*!*				SKIP 
*!*				LOOP 
*!*			ENDIF 
*!*			
*!*			SELECT CsrCanalVta
*!*			LOCATE FOR numero = VAL(CsrPrecio.lista)
*!*			IF numero <> VAL(CsrPrecio.lista)
*!*				SELECT CsrPrecio
*!*				SKIP 
*!*				LOOP 
*!*			ENDIF 
*!*			lnidcanalvta = CsrCanalVta.id
*!*			
*!*			INSERT INTO CsrCanalVtaNeg (id, idcanalvta, idproducto, feccostobon, costobon, margen1, prevta1, prevtaf1;
*!*			,feccorte);
*!*			values(lnidcanalvtaneg,lnidcanalvta,lnid,ldfechamodf,lnCostoBon,lnUtilX,lnPrevtaX,lnPrevtafX,DATE()+365)
*!*			lnidcanalvtaneg = lnidcanalvtaneg + 1 
*!*			
*!*			SELECT CsrPrecio
*!*			SKIP 
*!*		ENDDO 
	lnid = lnid + 1
	
	SELECT CsrArticulo   				
ENDSCAN

SELECT CsrProducto
GO TOP 
*vista()

   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')


USE IN CsrCtacte

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES