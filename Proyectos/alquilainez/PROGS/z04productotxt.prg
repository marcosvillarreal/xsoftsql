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
llok = CargarTabla(lcData,'FuerzaVta')

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
CREATE CURSOR CsrArticulo (Nombre c(100),Lista1 c(15),Lista2 c(15),Lista3 c(15),Lista4 c(15),Lista5 c(15))
		
*CREATE CURSOR CsrPrecio (Codigo c(8),Lista c(8), Costo c(15))


SELECT CsrLista
cArchivo = ALLTRIM(lcpath )+"\articulos.csv"
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

SKIP 
*STOP()
SCAN 
	lnCantCampo = 8 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
*!*		IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcNombre
		STORE "" TO lcLista1, lcLista2,lcLista3, lcLista4,lcLista5
		j = 0
*!*		ELSE
*!*			IF !leiunarticulo
*!*				LOOP 
*!*			ENDIF 
*!*		ENDIF 
	
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
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=1,lcCadena,lcNombre)))
			lcLista1		= IIF(j + i=4,lcCadena,lcLista1)
			lcLista2		= IIF(j + i=5,lcCadena,lcLista2)
			lcLista3		= IIF(j + i=6,lcCadena,lcLista3)
			lcLista4		= IIF(j + i=7,lcCadena,lcLista4)
			lcLista5		= IIF(j + i=8,lcCadena,lcLista5)
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
		ENDDO 
		lnSiguienteOcurrencia = 13
		lnCamposLeidos = lnCamposLeidos + 1
		lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
		IF lnPos = 0 AND i <= lnCantCampo &&Si no termino, y no es un campo csrati q nop existe
			 j = j + (i - 1)
		ENDIF 
		*IF lnpos#0 AND i+j >= lnCantCampo
		IF lnCamposLeidos<4 AND i+j >= lnCantCampo
			EXIT 
		ENDIF 
	ENDDO 

	IF lnCamposLeidos>=1 AND i+j >= lnCantCampo
		&&Insertamos si se encontro una ultima ocurrencia con respecto a la cantidad de registros
		&&Que se grabaran en csrarti.
		&&Esta diseñado para leer hasta los precios.
		&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.

		INSERT INTO CsrArticulo (Nombre,Lista1,Lista2,Lista3,Lista4,Lista5);
		values (lcNombre,lcLista1,lcLista2,lcLista3,lcLista4,lcLista5)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 

SELECT CsrArticulo
*vista()


lnid = RecuperarID('CsrRubro',Goapp.sucursal10)
INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta) ;
VALUES (lnid,1,'GENERAL',1,1,0,lnidfuerzavta)

lnid = RecuperarID('CsrMarca',Goapp.sucursal10)
INSERT INTO Csrmarca (id,numero,nombre,idfuerzavta);
VALUES (lnid,1,"GENERAL",lnidfuerzavta)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCtacte.* FROM Ctacte as CsrCtacte WHERE ctaacreedor = 1
ENDTEXT 
=CrearCursorAdapter('CsrCtacte',lcCmd)

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
lnCodigo = 1
GO top
SCAN FOR !EOF()
	SELECT CsrProducto
	
	
	STORE "" TO lccodarti
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
    GO TOP 
    lnidseccion = CsrRubro.id
    	
    SELECT CsrMarca
    GO TOP 
    Lnidmarca = CsrMarca.id
    	
	lcnombre	= NombreNi(alltrim(CsrArticulo.nombre))
    lnidestado 	= 1 
    lnTasa		= 21
    lnidiva     = 1100000002
    lnunibulto	= 1 
    lnidtipovta = 1 &&UNIDADES=1 ,	BULTOS = 2.
    
	ldfecha          = DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)
	ldfechaulcpr 	= ldfecha
	ldfechamodf 	= DATE() &&CTOD(CsrArticulo.fecModf)
			
	lnprevta1	= VAL(Csrarticulo.lista1)
	lnprevtaf1	= red(lnprevta1 * (1 + (lnTasa)/100),2)
	lnprevta2	= VAL(Csrarticulo.lista2)
	lnprevtaf2	= red(lnprevta2 * (1 + (lnTasa)/100),2)
	lnprevta3	= VAL(Csrarticulo.lista3)
	lnprevtaf3	= red(lnprevta3 * (1 + (lnTasa)/100),2)
	lnprevta4	= VAL(Csrarticulo.lista4)
	lnprevtaf4	= red(lnprevta4 * (1 + (lnTasa)/100),2)
	lnprevta5	= VAL(Csrarticulo.lista5)
	lnprevtaf5	= red(lnprevta5 * (1 + (lnTasa)/100),2)
	
	INSERT INTO Csrproducto (id,numero,nombre,codalfa,idiva,costoulcpra,prevta1,; 
	prevta2,switch,idcatego,idctacte,idrubro,;
	prevta3,prevta4,prevta5,idtipovta,;
	idmoneda,feculcpra,fecalta,fecmodi,idmarca,idestado,;
	nolista,nofactura,prevtaf1,prevtaf2,prevtaf3,prevtaf4,prevtaf5,;
	codartprod,fecoferta,insumo); 	
	values (lnid, lncodigo, lcnombre, lccodarti, lnidiva, lncosto,	;
	lnprevta1, lnprevta2, '00000', 1,lnidctacte, lnidseccion, ;
	lnprevta3, lnprevta4,lnprevta5, lnidtipovta,0,;
	ldfechaulcpr, ldfecha, ldfechamodf,;
	lnidmarca, lnidestado	,lnnolista, lnnofactu,;
	lnprevtaf1,lnprevtaf2,lnprevtaf3,lnprevtaf4,lnprevtaf5,;
	"",ldfecha ,0)
	
	lnid = lnid + 1
	lnCodigo = lnCodigo + 1 
	
	SELECT CsrArticulo   				
ENDSCAN

SELECT CsrProducto
GO TOP 
vista()

   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')


USE IN CsrCtacte

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES