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
llok = CargarTabla(lcData,'MovStock',.t.)
llok = CargarTabla(lcData,'Maopera',.t.)
llok = CargarTabla(lcData,'CabeOrd',.t.)
llok = CargarTabla(lcData,'CuerOrd',.t.)
llok = CargarTabla(lcData,'Existenc',.t.)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrProducto.* FROM Producto as CsrProducto 
ENDTEXT 
=CrearCursorAdapter('CsrArticulos',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrParaConfig.* FROM Paraconfig as CsrParaConfig
ENDTEXT 
=CrearCursorAdapter('CsrParaConfig',lcCmd)

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 

Oavisar.proceso('S','Abriendo archivos') 

local lnidrubro, lnidmarca, lncodrubro
store 0 to lnidrubro, lnidmarca ,lncodrubro

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrArticulo (Codigo c(8),Stock c(15))


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
		
		INSERT INTO CsrArticulo (Codigo,Stock);
		values (lcCodigo,lcStock)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 

lnidexiste	= RecuperarID('CsrExistenc',Goapp.sucursal10)
lnidmov 	= RecuperarID('CsrMovStock',Goapp.sucursal10) 
lnidmaopera	= RecuperarID('CsrMaopera',Goapp.sucursal10) 
lnidcabeord	= RecuperarID('CsrCabeOrd',Goapp.sucursal10)
lnidcuerord	= RecuperarID('CsrCuerOrd',Goapp.sucursal10)

STORE 0 TO lntotal,lnlistaprecio,lnidfletero
STORE 0 TO lnhojaactual,lnhojatotal,lnidctacte,lnidconcepto
					
lnidDepEntra= CsrParaConfig.iddeposito
lnidcomproba= 9
lcclasecomp = "L"
lnsigno 	= 1

lniddetanrocaja = CsrParaConfig.iddetanrocaja
ldfechaserver	= DATETIME()
ldfechasis		= FechaHoraCero(ldfechaserver)
lniDConcepto		= 3

INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis;
,idoperador,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja;
,idcotizadolar,switch,estado,detalle,fechaserver);
VALUES (lnidmaopera,"EXI","IMPORTACION STOCK",goapp.sucursal,goapp.terminal,1;
,ldfechasis,1,1,lniddetanrocaja,lnidcomproba,"X0000"+strzero(1,8),lcclasecomp;
,1,1,1,"0000","0","Importación Stock",ldfechaserver)

INSERT INTO Csrcabeord(id,idmaopera,total,switch,listaprecio,idfletero,iddepentra;
,iddepsale,signo,hojaactual,hojatotal,idlotemaopera,idctacte,idconcepto);
VALUES(lnidcabeord,CsrMaopera.id,lntotal,"00000",lnlistaprecio,lnidfletero;
,lnidDepEntra,0,lnsigno ,lnhojaactual,lnhojatotal,lnidmaopera,lnidctacte;
,lnidconcepto)


SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
*stop()
SCAN FOR !EOF()
	SELECT CsrArticulos
	
	LOCATE FOR numero=VAL(CsrArticulo.codigo)
	IF numero<>VAL(CsrArticulo.codigo)
		SELECT CsrArticulo
		LOOP 
	ENDIF
	
	IF VAL(CsrArticulo.stock) <= 0
		LOOP 
	ENDIF 
	STORE 0 TO lnuniventa,lnunibulto,lnkilos,lnvolumen,lnlistaprecio,lnprecosto,lnprecostosiva;
		,lnpreunita,lnpreunitasiva,lnprearti,lnpreartisiva,lninterno,lndespor,lntasaiva,lnhojaactual;
		,lnpesable,lnidfrio,lnidsub
	
	lnidArticulo	= CsrArticulos.id
	lcCodigo	= strtrim(CsrArticulos.numero,10)
	lnCantidad	= VAL(STRTRAN(CsrArticulo.stock,",","."))
	lnuniventa	= CsrArticulos.idtipovta
	lnunibulto 	= CsrArticulos.unibulto
	lnPesable 	= CsrArticulos.vtakilos
	*lnKilos		= lnCantidad*IIF(lnPesable=1,CsrArticulos.peso,1)
	IF lnPesable = 1
		lnKilos		= lnCantidad
		lnCantidad	= INT(lnKilos / CsrArticulos.peso)
	ENDIF 
	INSERT INTO CsrCuerord (id,idmaopera,idcabeza,idarticulo,codigo,nombre,cantidad,univenta;
		,unibulto,kilos,volumen,listaprecio,precosto,precostosiva,preunita,preunitasiva,prearti;
		,preartisiva,interno,despor,tasaiva,hojaactual,switch,pesable,idfrio);
	VALUES (lnidcuerord,lnidmaopera,lnidcabeord,lnidArticulo,lcCodigo,CsrArticulos.nombre;
		,lnCantidad,lnuniventa,lnunibulto,lnkilos,0;
		,lnlistaprecio,lnprecosto,lnprecostosiva,lnpreunita,lnpreunitasiva,lnprearti;
		,lnpreartisiva,lninterno,lndespor,lntasaiva,lnhojaactual,"00000",lnpesable,lnidfrio)
	
	INSERT INTO CsrMovStock (id,idmaopera,idorigen,idarticulo,idsubarti,codigo,fecha;
		,iddeposito,cantidad,kilos,volumen,importe,switch,signo);
	VALUES (lnidmov,lnidmaopera,lnidcuerord,lnidArticulo,lnidsub,lccodigo,ldfechasis;
		,lnidDepEntra,lnCantidad,lnKilos,lnKilos,0,"0000",1)
	
	lnidcuerord = lnidcuerord + 1
	lnidmov		= lnidmov + 1
	
*!*		SELECT CsrExistenc
*!*		LOCATE FOR idarticulo = lnidarticulo AND iddeposito = lnidDepEntra
*!*		IF NOT FOUND() &&idarticulo = lnidarticulo AND iddeposito = lnidDepEntra
		INSERT INTO CsrExistenc (id,idarticulo,iddeposito,idsubarti,existe,existeant,existedisp,fecvto;
			,kilos,kilosant,kilosdisp,volumen,volumenant,volumendisp);
		VALUES (lnidexiste,lnidArticulo,lnidDepEntra,lnidsub,lnCantidad,0;
			,lnCantidad,ldfechasis,lnKilos,0,lnKilos,0,0,0)
			
		lnidexiste = lnidexiste + 1 
*!*		ENDIF 
		 				
	SELECT CsrArticulo   				
ENDSCAN
SELECT CsrExistenc

   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')



CLOSE tables
CLOSE INDEXES
CLOSE DATABASES