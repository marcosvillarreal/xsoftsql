PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 
SET PROCEDURE TO z00_01.prg ADDITIVE 
SET SAFETY OFF


SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Producto',.t.)
llok = CargarTabla(lcData,'Variedad',.t.)
llok = CargarTabla(lcData,'Rubro',.t.)
llok = CargarTabla(lcData,'SubProducto',.t.)
llok = CargarTabla(lcData,'BloqueoProd',.t.)
llok = CargarTabla(lcData,'GamaBase',.t.)
llok = CargarTabla(lcData,'Deposito')
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'MapeoCarnico',.t.)
llok = CargarTabla(lcData,'ProdPrecio',.t.)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrTipoCarnico.* FROM Carnico_TipoCarne as CsrTipoCarnico
ENDTEXT 
=CrearCursorAdapter('CsrTipoCarnico',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM ListaPrecio 
ENDTEXT 
=CrearCursorAdapter('CsrListaPrecio',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Marca 
ENDTEXT 
=CrearCursorAdapter('CsrMarca',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Ubicacion 
ENDTEXT 
=CrearCursorAdapter('CsrUbicacion',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Tipoiva 
ENDTEXT 
=CrearCursorAdapter('CsrTipoiva',lcCmd)

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 

SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

*stop()
cArchivo = ADDBS(ALLTRIM(lcpath ))+"articulos.csv"
=LeerArticulos_01(cArchivo)
SELECT CsrArticulo 

cArchivo = ADDBS(ALLTRIM(lcpath ))+"precios.csv"
=LeerPrecios_01(cArchivo)
SELECT CsrPrecio 

Oavisar.proceso('S','Abriendo archivos') 

local lnidrubro, lnidmarca, lncodrubro
store 0 to lnidrubro, lnidmarca ,lncodrubro

SELECT CsrPrecio
*vista()

lnid = RecuperarID('CsrRubro',Goapp.sucursal10)
lncodrubro = 1
SELECT distinct UPPER(rubro) as nombre FROM CsrArticulo  INTO CURSOR FsrRubro

SELECT FsrRubro
GO top
SCAN 
	STORE 1100000001 TO lntipoprod,lntipovta 
	lnretibruto	= 1 &&IIF(CsrSeccion.perceib="S",1,0)

	lcnombre	= NombreNi(ALLTRIM(UPPER(FsrRubro.nombre)))
	INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta) ;
	VALUES (lnid,lncodrubro,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfuerzavta)
	lnid = lnid +1 
	lncodrubro = lncodrubro + 1 
ENDSCAN 


lnidlista = RecuperarID('CsrProdPrecio',Goapp.sucursal10)
lnid = RecuperarID('CsrProducto',Goapp.sucursal10)

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
	
	STORE 0 TO lnFlete,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnFletePorce,lnPrevta1,lnPrevta2,lnPrevta3,lnPreventa4
	STORE 0 TO lnSugerido,lnPrevtaF1,lnPrevtaf2,lnPrevtaf3,lnPrevetaf4, lninterno
	STORE 0 TO lnidctacte, lnidseccion,	lnidmarca,	lnidubicacion,lnidenvase
	STORE 0 TO lnnolista, lnnofactu, lnespromo, lnsireparto,lnidctacpra, lnidctavta , lnidfrio
	STORE 0 TO lnCosto,lnCostoBon,lnUtil1,lnUtil2,lnUtil3,lnUtil4,lnPeso,lnidtipocarnico
	
	SELECT CsrCtacte
    LOCATE FOR VAL(refotro)=VAL(Csrarticulo.proveedor)
    IF FOUND()
    	lnidctacte = Csrctacte.id
    ENDIF

    SELECT CsrRubro
    LOCATE FOR nombre=Csrarticulo.rubro
    IF NOT FOUND()
    	GO BOTTOM
    ENDIF 
    lnidseccion = CsrRubro.id
    
    SELECT CsrMapeoCarnico
    LOCATE FOR codigo = VAL(CsrArticulo.codigo)
    IF codigo = VAL(CsrArticulo.codigo)
    	lcClase = ALLTRIM(CsrMapeoCarnico.clase)
    	SELECT CsrTipoCarnico
    	LOCATE FOR ALLTRIM(clase) = lcClase
    	IF ALLTRIM(clase)=lcClase
    		lnidtipocarnico = CsrTipoCarnico.id
    	ENDIF 
    ENDIF 
    	
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
    lnTasa		= VAL(CsrArticulo.Alicuota)
    lnidiva     = IIF(lnTasa=1,1100000003,1100000002) &&VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,1),8))
   	lnunibulto	= 1 
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= 1 &&IIF(UPPER(CsrArticulo.u_medida)$"KILOS-KG",1,0)
   	lnidforma 	= 1100000001
	lnpeso		= 1
	
	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfechaulcpr 	= ldfecha
	ldfechamodf 	= CTOD('01-01-1900') &&CTOD(CsrArticulo.fecModf)
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
					
	SELECT CsrTipoiva
	LOCATE FOR id = lnidiva     
	lnTasa = CsrTipoiva.tasa
	
	INSERT INTO Csrproducto (id,numero,nombre,codalfa,idiva,costo,margen1,prevta1,margen2,; 
	prevta2,switch,idunidad,idtprod,idtamano,idcatego,idubicacio,idorigen,incluirped,idctacte,idrubro,margen3,;
	prevta3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,nomodifica,nombulto,puntope,;
	idmoneda,incluirped,flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,desc1,min1,desc2,min2,desc3,min3,vtakilos,cprakilos,fecoferta,internoporce,idctacpra,idctavta;
	,idenvase,fleteporce,idtipocarnico,excluido5329,nobonificar); 	
	values (lnid, lncodigo, lcnombre, lccodarti, lnidiva, lncosto,	;
	lnutil1, lnprevta1, lnutil2, lnprevta2, '00000', 1,1,1,1,lnidubicacion,1,1,lnidctacte, lnidseccion, lnutil3, ;
	lnprevta3, 0,0,lninterno, lnunibulto,lnpeso, lnidtipovta,lnidforma,lnfracciona,0,'',0,;
	1,1,lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnbonif1,lnbonif2, lnbonif3,;
	lnbonif4 ,lnidmarca,0, lnidestado	,lnnolista, lnnofactu,0,	lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,0,lnidfrio,;
	lnsugerido,1,lnsireparto,"",0, 0,;
	0, 0, 0, 0,lnvtakilos,lnvtakilos,ldfechabonif,0;
	,lnidctacpra,lnidctavta;
	,lnidenvase,lnfleteporce,lnidtipocarnico,0,0)		
	
	
	SELECT CsrPrecio
	LOCATE FOR VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo) 
	IF VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo) 
		SET FILTER TO VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo) 
		DO WHILE VAL(CsrPrecio.codigo) = VAL(CsrArticulo.codigo)  AND NOT EOF()
			SELECT CsrListaPrecio
			LOCATE FOR numero = VAL(CsrPrecio.lista)
			IF CsrListaPrecio.id <> 0
			
				IF lnidlista = 1100000001
				*	stop()
				ENDIF 
				
				lnCosto		= VAL(CsrPrecio.costo)
				
				lnFactor = 1 + (lnTasa / 100)
				
				lnCostoSiva	= lnCosto / lnFactor 
				
				lnUtil1		= 0
				lnprevta1	= lnCostoSiva
				lnprevtaf1	= lnprevta1 * lnFactor 
				*lnCosto		= lnCostoSiva*(1 +  IIF(lnTasa=0,21,10.5)/100)
				
				
				
				IF lnCosto < 1000000
					INSERT INTO CsrProdPrecio (id,idlista,idarticulo,costo,costosiva,margen,prevta,prevtaf);
					VALUES (lnidlista,CsrListaPrecio.id,lnid,lnCosto,lnCostoSiva,lnUtil1,lnprevta1,lnprevtaf1)
				
					lnidlista = lnidlista + 1 
				ENDIF 
			ENDIF 
			SELECT CsrPrecio
			SKIP 
		ENDDO 
	ENDIF 
	
	lnid = lnid + 1

	SELECT CsrArticulo   				
ENDSCAN

SELECT CsrProducto
GO TOP 
*vista()
SELECT CsrProdPrecio 
*vista()
   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')



CLOSE tables
CLOSE INDEXES
CLOSE DATABASES