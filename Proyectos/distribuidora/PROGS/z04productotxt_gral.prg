PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
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
llok = CargarTabla(lcData,'Deposito')
llok = CargarTabla(lcData,'Ubicacion',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Ctacte')


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

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrArticulo (Codigo c(8),Rubro c(20),Nombre c(100),Proveedor c(8),Costosiva c(15),CostoCiva c(15),PreVta1 c(15),PreVtaf1 c(15);
		,PreVta2 c(15),PreVtaf2 c(15),PreVta3 c(15),PreVtaf3 c(15),Stock c(8),Alicuota c(8),fecModf c(15) ,Observa c(100);
		,Util c(15),Util2 c(15), Util3 c(15), Tasa c(6))


SELECT CsrLista
cArchivo = ALLTRIM(lcpath )+"\productos.txt"
APPEND FROM  &cArchivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

Oavisar.proceso('S','Procesando '+alias()) 



cCadeCtacte = "" 


SELECT CsrLista
GO TOP 
*vista()
lnPrimeraOcurrencia = 1
leiunarticulo = .f.

*STOP()
SCAN 
	lnCantCampo = 28 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcRubro,lcNombre,lcProveedor,lcStock,lcAlicuota,lcfecModf,lcObserva
		STORE "" TO LcCostoSiva,LcCostoCiva,lcPreVta1,lcPreVtaF1,lcPreVta2,lcPreVtaF2,lcPreVta3,lcPreVtaF3
		STORE "" TO lcUtil,lcUtil2,lcUtil3
		j = 0
	ELSE
		IF !leiunarticulo
			LOOP 
		ENDIF 
	ENDIF 
	
	DO WHILE lnCamposLeidos<4
		i = 1
		DO WHILE i + j <= lnCantCampo &&Campos de CsrArti + 1
			lnpos = AT(lcDelimitador,&lcNomCampo,i)
			IF lnPos#0 &&No es fin de linea
				lccadena = ALLTRIM(lcAcarreo) + SUBSTR(&lcNomCampo,lnSiguienteOcurrencia,lnpos-(lnSiguienteOcurrencia))
				lcAcarreo = ""
			ELSE 
				lcAcarreo = ALLTRIM(lcAcarreo) + ALLTRIM(SUBSTR(&lcNomCampo,lnSiguienteOcurrencia))
				EXIT 
			ENDIF
			lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcCodigo)))
			lcRubro			= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcRubro)))
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=4,lcCadena,lcNombre)))
			lcProveedor		= UPPER(LimpiarCadena(IIF(j + i=5,lcCadena,lcProveedor)))
			LcCostoSiva		= IIF(j + i=7,lcCadena,LcCostoSiva)
			LcCostoCiva		= IIF(j + i=8,lcCadena,LcCostoCiva)
			lcPreVta1		= IIF(j + i=10,lcCadena,lcPreVta1)
			lcPreVtaF1		= IIF(j + i=11,lcCadena,lcPreVtaf1)
			lcUtil			= IIF(j + i=12,lcCadena,lcUtil)
			lcPreVta2		= IIF(j + i=14,lcCadena,lcPreVta2)
			lcPreVtaf2		= IIF(j + i=15,lcCadena,lcPreVtaf2)
			lcUtil2			= IIF(j + i=16,lcCadena,lcUtil2)
			lcPreVta3		= IIF(j + i=18,lcCadena,lcPreVta3)
			lcPreVtaf3		= IIF(j + i=19,lcCadena,lcPreVtaf3)
			lcUtil3			= IIF(j + i=20,lcCadena,lcUtil3)
			lcStock			= IIF(j + i=21,lcCadena,lcStock)
			lcAlicuota		= IIF(j + i=24,lcCadena,lcalicuota)
			lcfecModf		= IIF(j + i=26,lcCadena,lcfecModf)
			lcObserva		= UPPER(LimpiarCadena(IIF(j + i=28,lcCadena,lcObserva)))
							
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
		ENDDO 
		lnSiguienteOcurrencia = 1
		lnCamposLeidos = lnCamposLeidos + 1
		lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
		IF lnPos = 0 AND i <= lnCantCampo &&Si no termino, y no es un campo csrati q nop existe
			 j = j + (i - 1)
		ENDIF 
		IF lnpos#0 AND i+j >= lnCantCampo
			EXIT 
		ENDIF 
	ENDDO 

	IF lnpos#0 AND i+j >= lnCantCampo
		&&Insertamos si se encontro una ultima ocurrencia con respecto a la cantidad de registros
		&&Que se grabaran en csrarti.
		&&Esta diseñado para leer hasta los precios.
		&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.
		
		IF ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---'
			LOOP 
		ENDIF 
		
		INSERT INTO CsrArticulo (Codigo,Rubro,Nombre,Proveedor,Costosiva,CostoCiva,PreVta1,PreVtaf1;
			,PreVta2,PreVtaf2,PreVta3,PreVtaf3,Stock,Alicuota,fecModf,Observa,Util,Util2,Util3);
		values (lcCodigo,lcRubro,lcNombre,lcProveedor,lcCostosiva,lcCostoCiva,lcPreVta1,lcPreVtaf1;
			,lcPreVta2,lcPreVtaf2,lcPreVta3,lcPreVtaf3,lcStock,lcAlicuota,lcfecModf,lcObserva;
			,lcUtil,lcUtil2,lcUtil3)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 


SELECT CsrArticulo
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

lnid = RecuperarID('CsrMarca',Goapp.sucursal10)
INSERT INTO Csrmarca (id,numero,nombre,idfuerzavta);
VALUES (lnid,1,"GENERAL",lnidfuerzavta)

lnid = RecuperarID('CsrUbicacion',Goapp.sucursal10)
INSERT INTO CsrUbicacion (id,numero,nombre)	VALUES (lnid,'1','GENERAL')


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
	
	IF LEFT(CsrArticulo.nombre,2)='0-'
		LOOP 
	ENDIF 
	
	STORE 0 TO lnFlete,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnFletePorce,lnPrevta1,lnPrevta2,lnPrevta3,lnPreventa4
	STORE 0 TO lnSugerido,lnPrevtaF1,lnPrevtaf2,lnPrevtaf3,lnPrevetaf4, lninterno
	STORE 0 TO lnidctacte, lnidseccion,	lnidmarca,	lnidubicacion,lnidenvase
	STORE 0 TO lnnolista, lnnofactu, lnespromo, lnsireparto,lnidctacpra, lnidctavta , lnidfrio
	
	SELECT CsrCtacte
    LOCATE FOR otro01=Csrarticulo.proveedor
    IF FOUND()
    	lnidctacte = Csrctacte.id
    ENDIF

    SELECT CsrRubro
    LOCATE FOR nombre=Csrarticulo.rubro
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
    lnTasa		= VAL(CsrArticulo.Alicuota)
    lnidiva     = IIF(lnTasa=21,1100000002,1100000003) &&VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,1),8))
   	lnunibulto	= 1 
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    lnvtakilos	= 0 &&IIF(UPPER(CsrArticulo.u_medida)$"KILOS-KG",1,0)
   	lnidforma 	= 1100000001

	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfechaulcpr 	= ldfecha
	ldfechamodf 	= CTOD(CsrArticulo.fecModf)
	ldfechabonif	= CTOD('01-01-1900') &&GOMONTH(ldfecha,360*20)
	
	lnCosto		= VAL(CsrArticulo.costosiva)
	lnCostoBon	= lnCosto
	
	lnUtil1		= INT(VAL(CsrArticulo.Util))
	lnprevta1	= lnCosto * lnUtil1	&&VAL(Csrarticulo.prevta1)
	lnprevtaf1	= lnprevta1 * (1+lnTasa/100) &&VAL(CsrArticulo.prevtaf1)
	lnUtil2		= INT(VAL(CsrArticulo.Util2))
	lnprevta2	= lnCosto * lnUtil2	&&VAL(Csrarticulo.prevta1)
	lnprevtaf2	= lnprevta2 * (1+lnTasa/100) &&VAL(CsrArticulo.prevtaf1)
	lnUtil3		= INT(VAL(CsrArticulo.Util3))
	lnprevta3	= lnCosto * lnUtil3	&&VAL(Csrarticulo.prevta1)
	lnprevtaf3	= lnprevta3 * (1+lnTasa/100) &&VAL(CsrArticulo.prevtaf1)
	
	lnUtil4		= 0
	lnPeso		= 0			
	
	
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
	
	INSERT INTO Csrproducto (id,numero,nombre,codalfa,idiva,costo,margen1,prevta1,margen2,; 
	prevta2,switch,idunidad,idtprod,idtamano,idcatego,idubicacio,idorigen,incluirped,idctacte,idrubro,margen3,;
	prevta3,margen4,prevta4,interno,unibulto,peso,idtipovta,idforma,fracciona,nomodifica,nombulto,puntope,;
	idmoneda,incluirped,flete,feculcpra,fecalta,fecmodi,feculvta,bonif1,bonif2,bonif3,bonif4,idmarca,segflete,idestado,;
	nolista,nofactura,minimofac,espromocion,prevtaf1,prevtaf2,prevtaf3,prevtaf4,idfrio,sugerido,idingbrutos,divisible,;
	codartprod,desc1,min1,desc2,min2,desc3,min3,vtakilos,cprakilos,fecoferta,internoporce,idctacpra,idctavta,idenvase,fleteporce); 	
	values (lnid, lncodigo, lcnombre, lccodarti, lnidiva, lncosto,	;
	lnutil1, lnprevta1, lnutil2, lnprevta2, '00000', 1,1,1,1,lnidubicacion,1,1,lnidctacte, lnidseccion, lnutil3, ;
	lnprevta3, 0,0,lninterno, lnunibulto,lnpeso, lnidtipovta,lnidforma,lnfracciona,0,'',0,;
	1,1,lnflete,	ldfechaulcpr, ldfecha, ldfechamodf, ldfecha, lnbonif1,lnbonif2, lnbonif3,;
	lnbonif4 ,lnidmarca,0, lnidestado	,lnnolista, lnnofactu,0,	lnespromo,lnprevtaf1,lnprevtaf2,lnprevtaf3,0,lnidfrio,;
	lnsugerido,1,lnsireparto,"",0, 0,;
	0, 0, 0, 0,lnvtakilos,lnvtakilos,ldfechabonif,0;
	,lnidctacpra,lnidctavta;
	,lnidenvase,lnfleteporce)		

	lnid = lnid + 1

	SELECT CsrArticulo   				
ENDSCAN
SELECT CsrProducto
vista()

   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')



CLOSE tables
CLOSE INDEXES
CLOSE DATABASES