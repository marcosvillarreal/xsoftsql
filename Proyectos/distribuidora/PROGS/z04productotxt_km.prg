PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 
SET PROCEDURE TO z00_km ADDITIVE 

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
llok = CargarTabla(lcData,'Deposito')
*llok = CargarTabla(lcData,'Ubicacion',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
*llok = CargarTabla(lcData,'CanalVtaNeg',.t.)

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

*stop()
cArchivo = ALLTRIM(lcpath )+"\productosExp.csv"
=LeerArticulosKM()
SELECT CsrArticulo
vista()


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCanalVta.* FROM CanalVta as CsrCanalVta
ENDTEXT 
=CrearCursorAdapter('CsrCanalVta',lcCmd)


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrUbicacion.* FROM Ubicacion as CsrUbicacion
ENDTEXT 
=CrearCursorAdapter('CsrUbicacion',lcCmd)


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrMarca.* FROM Marca  as CsrMarca WHERE NUMERO = 1
ENDTEXT 
=CrearCursorAdapter('CsrMarca',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrTipoFrio.* FROM TipoFrio  as CsrTipoFrio
ENDTEXT 
=CrearCursorAdapter('CsrTipoFrio',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCtacte.* FROM Ctacte as CsrCtacte WHERE ctaacreedor = 1
ENDTEXT 
=CrearCursorAdapter('CsrCtacte',lcCmd)


SELECT distinct STRTRAN(STRTRAN(referencia,'/\',''),'$','') as nombre FROM CsrCtacte INTO CURSOR CsrSeccion READWRITE 

lnid = RecuperarID('CsrRubro',Goapp.sucursal10)
lnCodigo = 1

INSERT INTO CsrRubro(id,numero,nombre,idtipovta,idtipoprod,idfuerzavta);
   			 VALUES (lnid,lnCodigo,'GENERAL',1,1100000001,1100000001)
   			 
lnid = lnid + 1
lnCodigo = lnCodigo + 1 

   			 
SELECT CsrSeccion 
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
   IF LEN(ltrim(nombre))=0
       loop
   ENDIF
   lnprevta = 1
   lnestado = 1
   lnnumero	= lnCodigo 
   lcnombre	= NombreNi(alltrim(UPPER(CsrSeccion .nombre)))
   INSERT INTO CsrRubro(id,numero,nombre,idtipovta,idtipoprod,idfuerzavta);
   			 VALUES (lnid,lnnumero,lcnombre,1,1100000001,1100000001)
   lnid = lnid + 1
	lnCodigo = lnCodigo + 1 
ENDSCAN

SELECT CsrRubro
*vista()

lnid = RecuperarID('CsrProducto',Goapp.sucursal10)

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 

SCAN FOR !EOF()
	
	
	IF VAL(CsrArticulo.codigo) = 471
	*	stop()
	ENDIF 
	
	SELECT CsrProducto
	LOCATE FOR numero=VAL(CsrArticulo.codigo)
	IF numero=VAL(CsrArticulo.codigo)
		SELECT CsrArticulo
		LOOP 
	ENDIF
	IF LEN(RTRIM(CsrArticulo.nombre))<3
		SELECT CsrArticulo
		LOOP 
	ENDIF 
		
	STORE 0 TO lnFlete,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnFletePorce,lnPrevta1,lnPrevta2,lnPrevta3,lnprevta4
	STORE 0 TO lnSugerido,lnPrevtaF1,lnPrevtaf2,lnPrevtaf3,lnprevtaf4, lninterno
	STORE 0 TO lnidctacte, lnidseccion,	lnidmarca,	lnidubicacion,lnidenvase
	STORE 0 TO lnnolista, lnnofactu, lnespromo, lnsireparto,lnidctacpra, lnidctavta , lnidfrio
	STORE 0 TO lnCosto,lnCostoBon,lnUtil1,lnUtil2,lnUtil3,lnUtil4,lnPeso,lnidtipocarnico
	
	IF 'MERME'$ALLTRIM(cSRaRTICULO.NOMBRE)
	*	STOP()
	ENDIF 
	
	SELECT CsrCtacte
    	LOCATE FOR VAL(cnumero)=VAL(CsrArticulo.proveedor)
    	IF FOUND()
    		lnidctacte = Csrctacte.id
    	ENDIF

	cRubro = alltrim(STRTRAN(STRTRAN(CsrCtacte.referencia,'/\',''),'$',''))
	
    SELECT CsrRubro
    LOCATE FOR ALLTRIM(nombre)=cRubro 
    IF NOT FOUND()
    	GO top
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
    lnvtakilos	= IIF('/\'$CsrCtacte.referencia,1,0)
      lnvtakilos	= val(CsrArticulo.CodRubro)
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
					
		*Lista1 Tiene el prescio c/iva, debo componer para atras con un margen del 30%
		lnPrevtaf1		= VAL(CsrArticulo.lista1)
		IF lnPrevtaf1> 0
			lnprevta1	= red(lnprevtaf1 * 100 / (100 + (IIF(lnTasa=0,21,lnTasa))),2)			
			lnCosto		= red((lnprevta1 * 100) /  130,2) 
			lnCostoBon	= lnCosto
			lnprevta1	= lnPrevta1	
			lnUtil1		= 30
			lnprevtaf1	= red(lnprevta1 * (1 + (IIF(lnTasa=0,21,lnTasa)/100)),2)
			
			lnprevtaf2	= VAL(CsrArticulo.lista2)
			lnprevta2	= red(lnprevtaf2 * 100 / (100 + (IIF(lnTasa=0,21,lnTasa))),2)
			lnUtil2		= red((lnprevta2 * 100) /  lnCosto,2) - 100

			lnprevtaf3	= VAL(CsrArticulo.lista3)
			lnprevta3	= red(lnprevtaf3 * 100 / (100 + (IIF(lnTasa=0,21,lnTasa))),2)
			lnUtil3		= red((lnprevta3 * 100) /  lnCosto,2) - 100
			
			lnprevtaf4	= VAL(CsrArticulo.lista4)
			lnprevta4	= red(lnprevtaf4 * 100 / (100 + (IIF(lnTasa=0,21,lnTasa))),2)
			lnUtil4		= red((lnprevta4 * 100) /  lnCosto,2) - 100
			
			
*!*				lnprevta4	= VAL(CsrPrecio.lista4)		
*!*				lnUtil4		= red((lnprevta4 * 100) /  lnCosto,2) - 100
*!*				lnprevtaf4	= red(lnprevta4 * (1 + (IIF(lnTasa=0,21,10.5)/100)),2)
		ENDIF 
	

	IF lnPrevtaf1 = 0
		lnnofactu= 1
		lnnolista = 1
	ENDIF 
	
	SELECT CsrTipoFrio
	GO TOP 	
	IF '$'$CsrCtacte.referencia
	*	LOCATE FOR numero = 2		
	ENDIF 
	lnidfrio = CsrTipoFrio.id
	
	*stop()
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
	

	lnid = lnid + 1
	
	SELECT CsrArticulo   				
ENDSCAN

SELECT CsrProducto
GO TOP 
vista()

   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')


CLOSE tables
CLOSE INDEXES
CLOSE DATABASES