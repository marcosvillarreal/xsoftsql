PARAMETERS ldfecha,lcpath,lcbase
lcfecha = IIF(PCOUNT()< 1,"01-01-2011",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcdata = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
oavisar.proceso("Abriendo tablas...")
llok = .t.

TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrParaConta.* FROM ParaConta as CsrParaConta
left join PlanCue as CsrPlanCue on CsrParaConta.idcuenta = CsrPlancue.id
where CsrParaConta.idejercicio = <<goapp.idejercicio>> and ISNULL(CsrPlanCue.id,-1) > -1
ENDTEXT 
IF !CrearCursorAdapter('CsrParaConta',lccmd) OR RECCOUNT('CsrParaConta')=0
	MESSAGEBOX('Nose puede importar, pq no cargado el CsrParaConta')
	RETURN .f.
ENDIF 
TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrProvCtaCon.* FROM ProvCtaCon as CsrProvCtaCon
left join PlanCue as CsrPlanCue on CsrProvCtaCon.idctaperce = CsrPlancue.id
where CsrProvCtaCon.idejercicio = <<goapp.idejercicio>> and ISNULL(CsrPlanCue.id,-1) > -1
ENDTEXT 
IF !CrearCursorAdapter('CsrProvCtaCon',lccmd)
	MESSAGEBOX('Nose puede importar, Se produjo un error al cargar las provincias asociadas')
	RETURN .f.
ENDIF 
TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrParaVario.* FROM ParaVario as CsrParaVario
ENDTEXT 
IF !CrearCursorAdapter('CsrParaVario',lccmd)
	MESSAGEBOX('Nose puede importar, las tablas varias nose cargaron')
	RETURN .f.
ENDIF
&&Tomamos la primera caja
TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT TOP 1 CsrDetaNroCaja.* FROM DetaNroCaja as CsrDetaNroCaja
order by nrocaja
ENDTEXT 
IF !CrearCursorAdapter('CsrDetaNroCaja',lccmd) 
	MESSAGEBOX('Nose puede importar, pq no puede cargar el CsrDetaNroCaja')
	RETURN .f.
ENDIF 
IF RECCOUNT('CsrDetaNroCaja')=0
	MESSAGEBOX('Nose puede importar, pq no hay datos en CsrDetaNroCaja')
	RETURN .f.
ENDIF	
lniddetanrocaja = CsrDetaNroCaja.id

llok = CargarTabla(lcData,'Producto')
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'Fletero')
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Comprobante')
llok = CargarTabla(lcData,'Vendedor')
llok = CargarTabla(lcData,'Deposito')
llok = CargarTabla(lcData,'CuerDeta',.t.)
llok = CargarTabla(lcData,'AfeCtacte',.t.)
llok = CargarTabla(lcData,'AnMaopera',.t.)
llok = CargarTabla(lcData,'TipoFrio')
llok = CargarTabla(lcData,'Localidad')
llok = CargarTabla(lcData,'Provincia')
llok = CargarTabla(lcData,'TipoIva')
llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Variedad')
llok = CargarTabla(lcData,'SubProducto')
llok = CargarTabla(lcData,'Maopera')
llok = CargarTabla(lcData,'Cabefac')
llok = CargarTabla(lcData,'Cuerfac')
llok = CargarTabla(lcData,'CuerVari')
llok = CargarTabla(lcData,'CabeAsi')
llok = CargarTabla(lcData,'MovStock')
llok = CargarTabla(lcData,'TablaAsi')
llok = CargarTabla(lcData,'TablaImp')
llok = CargarTabla(lcData,'MovCtacte')
llok = CargarTabla(lcData,'PlanPago')

IF !llok
	RETURN .f.
ENDIF

USE ALLTRIM(lcpath )+"\gestion\cabefac" IN 0 ALIAS Csrcabeleon  EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\gestion\cuerfac" in 0 alias Csrcuerleon  EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movimien" in 0 alias Csrmovimien EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movisto" in 0 alias Csrmovisto EXCLUSIVE	

USE  ALLTRIM(lcpath )+"\gestion\anuladas" in 0 alias CsrAnulados EXCLUSIVE	
*ldfechaant=DATE(2010,08,01)
ldfechaant=CTOD(lcfecha)

oavisar.proceso("S","Reindexando Cuerfac por orden...")
SELECT CsrCuerleon.* FROM CsrCuerleon WHERE ldfechaant <= fecha ;
ORDER BY orden,articulo INTO CURSOR CsrCuerpo
SELECT CsrCuerpo
INDEX on orden TO Csrcuerpo

oavisar.proceso("S","Filtrando Cabefac por orden...")

SELECT CsrCabeleon.* FROM CsrCabeleon WHERE ldfechaant <= fecha  ;
ORDER BY fecha,orden INTO CURSOR CsrCabeza
SELECT CsrCabeza
INDEX on fecha TO Csrcabeza

SET SAFETY ON
oavisar.proceso("Procesando tablas...")
LOCAL lnid,lnidcabeza,lnidmovcte,lnidcuerpo,lnidmstk,lnidtablaasi,lnidtablaimp,lnidcabeasi,lnidcuervari
LOCAL lnidanmaiopera,lnidsub,lnidproducto


lnid 		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidcabeza 	= RecuperarID('CsrCabefac',Goapp.sucursal10)
lnidcuerpo	= RecuperarID('CsrCuerfac',Goapp.sucursal10)
lnidmstk	= RecuperarID('CsrMovStock',Goapp.sucursal10)
lnidtablaasi= RecuperarID('CsrTablaAsi',Goapp.sucursal10)
lnidtablaimp= RecuperarID('CsrTablaImp',Goapp.sucursal10)
lnidcabeasi = RecuperarID('CsrCabeAsi',Goapp.sucursal10)
lnidcuervari= RecuperarID('CsrCuerVari',Goapp.sucursal10)
lnidanmaiopera = RecuperarID('CsrAnMaopera',Goapp.sucursal10)
lnidsub 	= RecuperarID('CsrSubProducto',Goapp.sucursal10)
lnidproducto= RecuperarID('CsrProducto',Goapp.sucursal10)
lnidanmaopera	= RecuperarID('CsrAnMaopera',Goapp.sucursal10)


SELECT CsrLocalidad
IF FSIZE('id')>4
   lntamloc = 10
ELSE 
   lntamloc = 8
ENDIF 

SELECT CsrProvincia
IF FSIZE('id')>4
   lntamprov = 10
ELSE 
   lntamprov = 8
ENDIF 

SELECT CsrTipoIva
IF FSIZE('id')>4
   lntamiva = 10
ELSE 
   lntamiva = 8
ENDIF 

SELECT CsrCateCtacte
IF FSIZE('id')>4
   lntamcate = 10
ELSE 
   lntamcate = 8
ENDIF

lnnumcabe = 1

SELECT CsrCuerpo
GO BOTTOM 
lnRecnoFin = RECNO()

SELECT Csrcabeza
COUNT ALL TO lnCountCabeza
*Oavisar.proceso('S','Procesando '+alias()) 
ldfecha=CsrCabeza.fecha
GO TOP 
lcTitulo = "Cabefac "+STR(RECNO(),10)+"/"+STR(lnCountCabeza,10) 
Oavisar.proceso('S',lcTitulo,.t.,lnCountCabeza)
lbSalir = .f.

SCAN FOR !EOF()
	SELECT Csrcabeza
	
	IF LEN(LTRIM(STR(VAL(orden))))=0
		LOOP 
	ENDIF 
	
 	IF recno('CsrCabeza')/100=INT(RECNO('CsrCabeza')/100)
    	lcTitulo = "Cabefac "+STR(RECNO(),10)+"/"+STR(lnCountCabeza,10) 
    	Oavisar.proceso('I',lcTitulo,.t.,lnCountCabeza,RECNO())
 	ENDIF
	
	IF (ldfecha)<>(ldfechaant)
	 	ldfechaant = ldfecha
	 	*?(ldfechaant)
	ENDIF 
	IF (EMPTY(CsrCabeza.fecha) OR (CsrCabeza.importe=0 AND !("ANULA"$UPPER(CsrCabeza.nombre))))
		LOOP 
	ENDIF
	
	lclocalidad 	= CsrCabeza.localidad
	lntipocuit		= CsrCabeza.tipocuit
	lntipocomp 		= CsrCabeza.tipocomp
	lcorden 		= CsrCabeza.orden
	
	lncliente 		= CsrCabeza.cliente
	lnrepartidor 	= CsrCabeza.repartidor
	lnfrio 			= CsrCabeza.frio
	lnvendedor 		= Csrcabeza.vendedor
	lndiferida 		= IIF(CsrCabeza.diferida,1,0)
	lntasa 			= IIF(CsrCabeza.tasamuni='S',1,0)
	lnidnotacredito = CsrCabeza.tiponc
	lnrendida 		= IIF(CsrCabeza.rendida='S',1,0)
	lccuit			= CsrCabeza.cuit
	
	
	lntipovta	= CsrCabeza.plan
	lnimporte	= CsrCabeza.importe
	lnbonif1 	= CsrCabeza.bonif1
	lnbonif2 	= CsrCabeza.bonif2
	lcnombre 	= CsrCabeza.nombre
	lcdireccion = CsrCabeza.direccion
	lnentrega	= CsrCabeza.entrega
	ldfecha     = DATETIME(YEAR(Csrcabeza.fecha),MONTH(Csrcabeza.fecha),DAY(Csrcabeza.fecha),0,0,0)
	ldfecha_vto = DATETIME(YEAR(Csrcabeza.fecha_vto),MONTH(Csrcabeza.fecha_vto),DAY(Csrcabeza.fecha_vto),0,0,0)
	lcestado 	= '0'
	
	
	******Chequeamos que si el comprobante es anulado, recupero la cabeza en anulados.
	IF "ANULA"$UPPER(CsrCabeza.nombre)
		SELECT CsrAnulados
		LOCATE FOR VAL(orden) = VAL(lcorden)
		IF !FOUND() AND VAL(orden) <> VAL(CsrCabeza.orden)
			LOOP &&sino existe la cabeza guardada, no lo grabo.
		ENDIF 
		lclocalidad = CsrAnulados.localidad
		lntipocuit 	= CsrAnulados.tipocuit
		lntipocomp 	= CsrAnulados.tipocomp
		lcnumcomp 	= CsrAnulados.letra+RIGHT(STR(10000+CsrAnulados.talonario),4)+RIGHT(STR(1000000000+CsrAnulados.numcomp),8)
		lncliente 	= CsrAnulados.cliente	
		lnrepartidor= CsrAnulados.repartidor
		lnfrio 		= CsrAnulados.frio
		lnvendedor 	= CsrCabeza.vendedor
		lndiferida 	= 0 &&IIF(CsrAnulados.esdiferido,1,0)
		lnidnotacredito = CsrAnulados.tiponc
		lnrendida 	= IIF(CsrAnulados.rendida='S',1,0)
		ldfecha     = DATETIME(YEAR(CsrAnulados.fecha),MONTH(CsrAnulados.fecha),DAY(CsrAnulados.fecha),0,0,0)
		lccuit		= CsrAnulados.cuit
		lntipovta	= CsrAnulados.plan
		lnimporte	= CsrAnulados.importe
		lnbonif1 	= CsrAnulados.bonif1
		lnbonif2 	= CsrAnulados.bonif2
		lcnombre 	= CsrAnulados.nombre
		lcdireccion = CsrAnulados.direccion
		lnentrega	= CsrAnulados.entrega
		ldfecha_vto = DATETIME(YEAR(CsrAnulados.fecha_vto),MONTH(CsrAnulados.fecha_vto),DAY(CsrAnulados.fecha_vto),0,0,0)
		lcestado	= '1'
	ENDIF 
	
	ldfechaserver 	= ldfecha &&DATETIME()
	ldfechasis 		= FechaHoraCero(ldfechaserver)
	
	lntipoiva =lntipocuit
	IF lntipoiva=7
	   lntipoiva =5
	ENDIF 
	
	lcLocalidadBuscada = lcLocalidad
	DO CASE
	CASE ALLTRIM( UPPER(lcLocalidadBuscada) )= "PARERA LP"
		lcnombre = "PARERA"
	CASE  ALLTRIM( UPPER(lcLocalidadBuscada)) = "LANUS OESTE"
		lcnombre = "LANUS"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada)) = "LA PAMPA"
		lcnombre = "SANTA ROSA"
	CASE  ALLTRIM( UPPER(lcLocalidadBuscada) )= "LA MERCED"
		lcnombre = "COLONIA LA MERCED"
	CASE  ALLTRIM( UPPER(lcLocalidadBuscada)) = "GRAL. DANIEL CERRI"
		lcnombre = "GENERAL DANIEL CERRI"
	CASE  ALLTRIM( UPPER(lcLocalidadBuscada)) = "GRAL. CERRI"
		lcnombre = "GENERAL CERRI"
	CASE ALLTRIM(UPPER(lcLocalidadBuscada)) = "GRAL. CONESA" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  = "GRAL. CONESAA" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  = "GRAL.CONESA"
		lcnombre = "GENERAL CONESA"
	CASE ALLTRIM(UPPER(lcLocalidadBuscada))  = "G.CHAVEZ"
		lcnombre = "GONALEZ CHAVES"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  = "FERREIRA"
		lcnombre = "FERREYRA"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  = "E. ECHEVERRIA"
		lcnombre = "BARRIO ESTEBAN ECHEVERRIA"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  = "CNEL. DORREGO"
		lcnombre = "CORONEL DORREGO"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  = "CATRILLO"
		lcnombre = "CATRILO"
	CASE ALLTRIM(UPPER(lcLocalidadBuscada))  = "CAP" .or. ALLTRIM(UPPER(lcLocalidadBuscada)) = "CIUDAD BS"
		lcnombre = "CIUDAD DE BUENOS AIRES"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  = "BERNAL OESTE"
		lcnombre = "BERNAL"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  = "BAL. LAS GRUTAS"
		lcnombre = "BALNEARIO LAS GRUTAS"
	CASE ALLTRIM(UPPER(lcLocalidadBuscada))  = "ARROYITO DULCE"
		lcnombre = "ARROYO DULCE"
	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="B. BLANCA" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="BAHjA BLANCA"
		lcnombre = "BAHIA BLANCA"

	CASE ALLTRIM(UPPER(lcLocalidadBuscada))  = "SAN BLAS"
		lcnombre = "BAHIA SAN BLAS"

	CASE ALLTRIM(UPPER(lcLocalidadBuscada))  ="BALN. EL CONDOR" .OR.ALLTRIM(UPPER(lcLocalidadBuscada)) ="BRIO. EL CONDOR"
		lcnombre = "BALNEARIO EL CONDOR"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="B.EL CONDOR"  .OR. ALLTRIM(UPPER(lcLocalidadBuscada)) ="B. EL CONDOR"
		lcnombre = "BALNEARIO EL CONDOR"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada)) ="BUENOS AIRES" .OR.ALLTRIM(UPPER(lcLocalidadBuscada))  ="BS"
		lcnombre = "CIUDAD DE BUENOS AIRES"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="C. PATAGONES" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="C.PATAGONES"
		lcnombre = "CARMEN DE PATAGONES"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="CAPITAL FEDERALPATAGONES"
		lcnombre = "CARMEN DE PATAGONES"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="EL CONDOR"
		lcnombre = "BALNEARIO EL CONDOR"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="GDOR. GALVEZ"
		lcnombre = "GALVEZ"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="GUADIA MITRE"
		lcnombre = "GUARDIA MITRE"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="JOSE CASAS"
		lcnombre = "JOSE B. CASAS"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="PATAGONES" .OR.ALLTRIM(UPPER(lcLocalidadBuscada))  ="C. DE PATAGONES" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="C.  PATAGONES"
		lcnombre = "CARMEN DE PATAGONES"

	CASE ALLTRIM(UPPER(lcLocalidadBuscada))  ="SAN ANTONIO" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="SAN A " .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="SAN A." .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="S. A. O" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="SANANTONIO" 
		lcnombre = "SAN ANTONIO OESTE"

	CASE  ALLTRIM(UPPER(lcLocalidadBuscada))  ="STROEDER" .or. ALLTRIM(UPPER(lcLocalidadBuscada))  ="STREDER".OR.ALLTRIM(UPPER(lcLocalidadBuscada))  ="ESTROEDER"
		lcnombre = "EMPORIO STROEDER"

	CASE ALLTRIM(UPPER(lcLocalidadBuscada))  ="VIEMA" .OR. ALLTRIM(UPPER(lcLocalidadBuscada))  ="VEDMA"
		lcnombre = "VIEDMA"

	OTHERWISE
		lcnombre=ALLTRIM(UPPER(lcLocalidadBuscada)) 
	ENDCASE
	IF ASC(SUBSTR(lcLocalidadBuscada,4,1))=161
		lcnombre='BAHIA BLANCA'
	ENDIF 

	lnidlocalidad =	1100000006 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
	lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
	lccp = ""
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcnombre)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccp = CsrLocalidad.cpostal
	ENDIF
	lcswitch = "00090"
	lcDebeHaber	= "D"
	lnsigno = 1
	 IF !"ANULA"$UPPER(CsrCabeza.nombre)
		lcLetra = CsrCabeza.letra
	ENDIF 
	DO case
		CASE lntipocomp=1      && remito
			lntipocomp = 6
		CASE lntipocomp=2	&& factura
			lntipocomp = 1
		CASE lntipocomp=3	&& n.deb
			lntipocomp = 2
		CASE lntipocomp=4	&& n.cre
			lntipocomp = 3
			lnsigno = -1
			lcDebeHaber	="H"
		CASE lntipocomp=13	&& n.deb
			lntipocomp = 5
		CASE lntipocomp = 6  &&remito de logistica
			lntipocomp = 38
			lcletra = 'R'
	ENDCASE 
	IF !"ANULA"$UPPER(CsrCabeza.nombre)
		lcnumcomp 		= lcLetra+RIGHT(STR(10000+CsrCabeza.talonario),4)+RIGHT(STR(1000000000+Csrcabeza.numcomp),8)
	ENDIF 
	lnidcomproba = 0
	lcclasecomp = ""
	
	SELECT CsrComprobante	
	LOCATE FOR numero=lntipocomp	
	IF numero=lntipocomp
		lnidcomproba = id
		lcclasecomp = clase
	ENDIF
	
    SELECT Csrctacte
    LOCATE FOR ALLTRIM(cnumero)==LTRIM(STR(lncliente))
    lnidctacte = 0 
    lnidcategoria = 0 
    IF FOUND()
    	lnidctacte = Csrctacte.id
        lntipoiva   = CsrCtacte.tipoiva
        lcnombre  = CsrCtacte.cnombre
        lcdireccion = CsrCtacte.cdireccion
        lnidcategoria = CsrCtacte.idcategoria
    ENDIF

    SELECT Csrfletero
    LOCATE FOR numero=lnrepartidor
    lnidfletero = 0      
    IF numero=Csrcabeza.repartidor
    	lnidfletero = Csrfletero.id
    ENDIF
      
    SELECT Csrtipofrio
    LOCATE FOR numero=lnfrio
    lnidfrio = 0      
    IF numero=Csrcabeza.frio
        lnidfrio = Csrtipofrio.id
    ENDIF

    SELECT Csrfuerzavta
    LOCATE FOR numero = 1
    lnidfuerzavta = Csrfuerzavta.id
      
    SELECT Csrvendedor
    LOCATE FOR numero=lnvendedor
    lnidvendedor = 0      
    IF numero=Csrcabeza.vendedor
       lnidvendedor = Csrvendedor.id
    ENDIF
	
	SELECT CsrPlanPago
	LOCATE FOR 	numero = lntipovta
	IF !numero = lntipovta
		LOCATE FOR numero = "CCT"
	ENDIF 
	lnidplanpago = CsrPlanPago.id
	
	INSERT INTO Csrmaopera (id,origen,programa,terminal,fechasis,idoperador,idvendedor,idcomproba,numcomp;
	,clasecomp,iddetanrocaja,turno,switch,sucursal,sector,puestocaja,idcotizadolar,estado,fechaserver);
	VALUES (lnid,'FAC',"IMPORTACION FACTURAS",goapp.terminal,ldfechasis,1,lnidvendedor,lnidcomproba;
	,lcnumcomp,lcclasecomp,lniddetanrocaja,1,"00000",goapp.sucursal,1,1,1,lcestado,ldfechaserver)

	Insert into Csrcabefac (ID, IDMAOPERA, IDCTACTE, CTACTE, CNOMBRE, CDIRECCION, CTELEFONO, CPOSTAL;
	, IDLOCALIDAD, IDPROVINCIA,IDFRIO, IDTIPOIVA, CUIT, IDSUBCTA, FECHA, IDPLANPAGO, TOTAL, BONIF1, BONIF2;
	, SWITCH, LISTAPRECIO, IDFLETERO, IDFUERZAVTA, IDRUTAVDOR,SIGNO,TASAMUNI,DIFERIDA,IDTIPONCREDITO,RENDIDA;
	,NROPATRON,IDCATEGORIA);
	value (lnidcabeza,lnid,lnidctacte,LTRIM(STR(lncliente)),lcnombre,lcdireccion,"";
	,"",lnidlocalidad,lnidprovincia,lnidfrio,lntipoiva,lccuit,0,ldfecha,lnidplanpago,lnimporte,lnbonif1;
	,lnbonif2,"F0000",1,lnidfletero,lnidfuerzavta,0,lnsigno,lntasa,lndiferida,lnidnotacredito,lnrendida,"";
	,lnidcategoria)
	
		
	lctablaori  = 'CAFA'
	lctipoconce = ""
	lnidorigen  = lnidCabeza
	lnnumcabe	= lnnumcabe + 1	
	lnimporte = CsrCabeza.importe
	*lnidprovincia = 0
	lntasa = 0
	lnbase = 0
	
	lnidcuenta  = 114 
	lcdetalle = "IMP-"+lcnumcomp
	lnidasiento = 0
							
*!*			INSERT INTO CsrCabeAsi	(id,idmaopera,idejercicio,numero,fecha,tipoasi,detalle);
*!*			VALUES (lnidCabeasi,lnid,goapp.idejercicio,lnnumcabe,ldfecha,'C',lcdetalle)
*!*			lnidCabeAsi = lnidCabeAsi + 1
*!*		
*!*			
*!*			INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce;
*!*			,detalle);
*!*			VALUES (lnidTablaasi,lnid,lnidcuenta,lcdebehaber,lnimporte,lnidorigen,lctablaori;
*!*			lctipoconce,lcdetalle)
*!*					

*!*			lnidTablaasi = lnidTablaasi + 1
	
	lcDebeHaber = IIF(lcDebeHaber='D','H','D')  && cambio el signo para los impuestos
	
	IF CsrCabeza.neto_iva#0

		* debito fiscal
		SELECT CsrParaConta
		LOCATE FOR numero=13
		IF !FOUND()
			oavisar.usuario('Error. No esta parametrizado los Parametros contables'+CHR(13);
							+"[Cuenta 13]")
			EXIT 
		ENDIF 
		lnidcuenta  = Csrparaconta.idcuenta
		lctipoconce = "IG"		
		lntasa = 21
		lnbase = Csrcabeza.gravado
		lnimporte = CsrCabeza.neto_iva
		lnbaseimp = IIF(lntipocuit>2,CsrCabeza.neto_iva,0)
		
*!*				INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce;
*!*				,detalle);
*!*				VALUES (lnidTablaasi,lnid,lnidcuenta,lcdebehaber,lnimporte,lnidorigen,lctablaori,lctipoconce;
*!*				,lcdetalle)

*!*				lnidasiento = CsrTablaasi.id
*!*				lnidTablaasi = lnidTablaasi + 1


		INSERT INTO CsrTablaimp(id,idmaopera,idcuenta,tipoconce,importe,idorigen,tablaori,idasiento;
		,tasa,baseimp,nombre,idprovincia,detalle);
		VALUES (lnidTablaimp,lnid,lnidcuenta,lctipoconce,lnimporte,lnidorigen,lctablaori,lnidasiento;
		,lntasa,lnbase,"",lnidprovincia,lcdetalle)
		lnidTablaimp = lnidTablaimp + 1

	ENDIF
	
	lntasa = 0
	lnbase = 0
	IF CsrCabeza.gravado#0
		* neto gravado
		SELECT CsrParaConta
		LOCATE FOR numero = 20
		IF !FOUND()
			oavisar.usuario('Error. No esta parametrizado los Parametros contables'+CHR(13);
							+"[Cuenta 20]")
			EXIT 
		ENDIF 
		lnidcuenta=CsrParaconta.idcuenta
		lctipoconce = "NG"
		lnimporte = CsrCabeza.gravado
		lnbaseimp = lnbaseimp + lnimporte
*!*				INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce;
*!*				,detalle);
*!*				VALUES (lnidTablaasi,lnid,lnidcuenta,lcdebehaber,lnimporte,lnidorigen,lctablaori,lctipoconce;
*!*				,lcdetalle)

*!*				lnidasiento = CsrTablaasi.id
*!*				lnidTablaasi = lnidTablaasi + 1


		INSERT INTO CsrTablaimp(id,idmaopera,idcuenta,tipoconce,importe,idorigen,tablaori,idasiento;
		,tasa,baseimp,nombre,idprovincia,detalle);
		VALUES (lnidTablaimp,lnid,lnidcuenta,lctipoconce,lnimporte,lnidorigen,lctablaori,lnidasiento;
		,lntasa,lnbase,"",lnidprovincia,lcdetalle)
		lnidTablaimp = lnidTablaimp + 1

	ENDIF

	IF CsrCabeza.neto_exe#0
		* venta exenta
		SELECT CsrParaconta
		LOCATE FOR numero = 23
		IF !FOUND()
			oavisar.usuario('Error. No esta parametrizado los Parametros contables'+CHR(13);
							+"[Cuenta 23]")
			EXIT  
		ENDIF 
		lnidcuenta=CsrParaConta.idcuenta
		lnimporte   = Csrcabeza.neto_exe
		lctipoconce = "EX"
		lnbaseimp = lnbaseimp + lnimporte
*!*				INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce;
*!*				,detalle);
*!*				VALUES (lnidTablaasi,lnid,lnidcuenta,lcdebehaber,lnimporte,lnidorigen,lctablaori,lctipoconce;
*!*				,lcdetalle)

*!*				lnidasiento = CsrTablaasi.id
*!*				lnidTablaasi = lnidTablaasi + 1


		INSERT INTO CsrTablaimp(id,idmaopera,idcuenta,tipoconce,importe,idorigen,tablaori,idasiento;
		,tasa,baseimp,nombre,idprovincia,detalle);
		VALUES (lnidTablaimp,lnid,lnidcuenta,lctipoconce,lnimporte,lnidorigen,lctablaori,lnidasiento;
		,lntasa,lnbase,"",lnidprovincia,lcdetalle)
		lnidTablaimp = lnidTablaimp + 1

	ENDIF
	
	IF  CsrCabeza.pibba #0 
		* ingresos brutos bsas
		SELECT CsrParaVario
		LOCATE FOR nombre = "CATEIBBA" 
		SELECT CsrProvCtaCon
		LOCATE FOR id = CsrParaVario.idorigen
		lnidcuenta = CsrProvctaCon.idctaperce
		IF !id = CsrParaVario.idorigen
			SELECT CsrParaconta
			LOCATE FOR numero = 8
			lnidcuenta = CsrParaConta.idcuenta
		ENDIF 
		IF lnidcuenta = 0 
			oavisar.usuario('Error. No esta parametrizado los Parametros contables'+CHR(13);
							+"[Cuenta 8]")
			EXIT 
		ENDIF 
		lnimporte   =CsrCabeza.pibba
    	lctipoconce = "PB"
    	lnidprovBA = 1100000002
    	lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
		lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
*!*				INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce;
*!*				,detalle);
*!*				VALUES (lnidTablaasi,lnid,lnidcuenta,lcdebehaber,lnimporte,lnidorigen,lctablaori,lctipoconce;
*!*				,lcdetalle)

*!*				lnidasiento = CsrTablaasi.id
*!*				lnidTablaasi = lnidTablaasi + 1


		INSERT INTO CsrTablaimp(id,idmaopera,idcuenta,tipoconce,importe,idorigen,tablaori,idasiento;
		,tasa,baseimp,nombre,idprovincia,detalle);
		VALUES (lnidTablaimp,lnid,lnidcuenta,lctipoconce,lnimporte,lnidorigen,lctablaori,lnidasiento;
		,lntasa,lnbaseimp,"IBTO2",lnidprovBA,lcdetalle)
		lnidTablaimp = lnidTablaimp + 1

	ENDIF
	
	IF  CsrCabeza.peribrn #0 
		*ingresos brutos rio negro
		SELECT CsrParaVario
		LOCATE FOR nombre = "CATEIBRN" 
		SELECT CsrProvCtaCon
		LOCATE FOR id = CsrParaVario.idorigen
		lnidcuenta = CsrProvctaCon.idctaperce
		IF !id = CsrParaVario.idorigen
			SELECT CsrParaconta
			LOCATE FOR numero = 8
			lnidcuenta = CsrParaConta.idcuenta
		ENDIF 
		IF lnidcuenta = 0 
			oavisar.usuario('Error. No esta parametrizado los Parametros contables'+CHR(13);
							+"[Cuenta 8]")
			EXIT 
		ENDIF 
		lnimporte   =CsrCabeza.peribrn
    	lctipoconce = "PB"
    	lnidprovRN = 1100000022
    	lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
		lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
		
*!*				INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce;
*!*				,detalle);
*!*				VALUES (lnidTablaasi,lnid,lnidcuenta,lcdebehaber,lnimporte,lnidorigen,lctablaori,lctipoconce;
*!*				,lcdetalle)

*!*				lnidasiento = CsrTablaasi.id
*!*				lnidTablaasi = lnidTablaasi + 1


		INSERT INTO CsrTablaimp(id,idmaopera,idcuenta,tipoconce,importe,idorigen,tablaori,idasiento;
		,tasa,baseimp,nombre,idprovincia,detalle);
		VALUES (lnidTablaimp,lnid,lnidcuenta,lctipoconce,lnimporte,lnidorigen,lctablaori,lnidasiento;
		,lntasa,lnbaseimp,"IBTO2",lnidprovRN,lcdetalle)
		lnidTablaimp = lnidTablaimp + 1

	ENDIF
	

	IF CsrCabeza.interno#0
		* interno
		SELECT CsrParaConta
		LOCATE FOR numero = 21
		IF !FOUND()
			oavisar.usuario('Error. No esta parametrizado los Parametros contables'+CHR(13);
							+"[Cuenta 21]")
			EXIT  
		ENDIF 
		lnidcuenta=CsrParaConta.idcuenta
		lnimporte = CsrCabeza.interno
		lctipoconce = "II"
	
*!*				INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce;
*!*				,detalle);
*!*				VALUES (lnidTablaasi,lnid,lnidcuenta,lcdebehaber,lnimporte,lnidorigen,lctablaori,lctipoconce;
*!*				,lcdetalle)

*!*				lnidasiento = CsrTablaasi.id
*!*				lnidTablaasi = lnidTablaasi + 1 


		INSERT INTO CsrTablaimp(id,idmaopera,idcuenta,tipoconce,importe,idorigen,tablaori,idasiento;
		,tasa,baseimp,nombre,idprovincia,detalle);
		VALUES (lnidTablaimp,lnid,lnidcuenta,lctipoconce,lnimporte,lnidorigen,lctablaori,lnidasiento;
		,lntasa,lnbase,"",lnidprovincia,lcdetalle)
		lnidTablaimp = lnidTablaimp + 1

	ENDIF
	*Generamos la afectacion de anulados
	IF lcestado='1'
		
		lnidafecta = lnid
		lnid = lnid + 1
		
		INSERT INTO Csrmaopera (id,origen,programa,terminal,fechasis,idoperador,idvendedor,idcomproba;
		,numcomp,clasecomp,iddetanrocaja,turno,switch,sucursal,sector,puestocaja,idcotizadolar,estado;
		,fechaserver);
		VALUES (lnid,'FAC',"IMPORTACION FACTURAS",goapp.terminal,ldfechasis,1,lnidvendedor,lnidcomproba;
		,lcnumcomp,'K',1,1,"00000",goapp.sucursal,1,1,1,'0',ldfechaserver)
		
		INSERT INTO anmaopera (id,idmaopera,idafecta,detalle,idmotanula);
		VALUES (lnidanmaopera,lnid,lnidafecta,"COMPROBANTE ANULADO DE IMP.",0)
		
		lnid = lnid + 1
		lnidanmaopera = lnidanmaopera +1 
		lnidcabeza = lnidcabeza + 1
		LOOP 
	ENDIF 
	
	SELECT CsrCuerpo
	SET ORDER TO 1
   	SEEK  lcorden
    	DO WHILE !EOF() AND CsrCuerpo.orden= lcorden
    		lnunivta = 1
		STORE 0 TO lnBoniCiva, lnBoniSiva,lnkilos,lnvolumen,lnespromo,lniddeposito,lnidarticulo
		
	    SELECT Csrdeposito
	    LOCATE FOR numero=Csrcuerpo.deposito
	    IF numero=Csrcuerpo.deposito
	    	lniddeposito = Csrdeposito.id
	    ENDIF
				             
		SELECT CsrProducto
		LOCATE FOR numero=Csrcuerpo.articulo
		lcnumero  =" "
		lcnombre = " "
		IF numero=Csrcuerpo.Articulo
			lnidarticulo = Csrproducto.id
			lcnumero = Csrproducto.codalfa
			lcnombre = Csrproducto.nombre
			lnpesable= CsrProducto.vtakilos
			lnidfrio = CsrProducto.idfrio
			lnPeso		= CsrProducto.peso
		ELSE  &&producto inexistente
			IF csrcuerpo.articulo=999999
				lcnombre	= CsrCuerpo.nombre
				lnPeso		= 0
			ELSE 
				lnidarticulo = 1
				lcnumero 	= "Z"+LTRIM(STRzero(CsrCuerpo.articulo,6))
				lcnombre 	= "INEXISTENTE-"+LTRIM(CsrCuerpo.nombre)
				lnpesable	= 0
				lnidfrio 		= 0
				lnPeso		= 0
				SELECT CsrProducto
				LOCATE FOR numero =99999+CsrCuerpo.articulo
				IF !FOUND() AND numero =99999+CsrCuerpo.articulo
					lnidarticulo = lnidproducto
	 				INSERT INTO producto (id,numero,nombre,nombulto,codalfa,idctacte,idmarca;
           			,idctavta,idctacpra,idforma,idunidad,idtprod,idtipovta,idtamano,idcatego;
          			,idrubro,idestado,idubicacio,idorigen,nomodifica,incluirped,idiva,idmoneda;
           			,costo,flete,segflete,interno,bonif1,bonif2,bonif3,bonif4,costobon,costorepo;
           			,costoulcpra,feculcpra,margen1,prevta1,prevtaf1,margen2,prevta2,prevtaf2;
           			,margen3,prevta3,prevtaf3,margen4,prevta4,prevtaf4,feculvta,fecalta,fecmodi;
           			,unibulto,nofactura,nolista,espromocion,minimofac,peso,volumen,fracciona;
           			,puntope,switch,idenvase,sugerido,idfrio,idingbrutos,divisible,desc1,desc2,desc3;
           			,min1,min2,min3,codartprod,vtakilos,fecoferta,internoporce,cprakilos);
    				VALUES (lnidproducto,CsrCuerpo.articulo+99999,lcnombre,"",lcnumero,0,0,0,0,0,0,0,0,0,0,0,1,0,0;
           			,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,DATETIME(1900,1,1),0,0,0,0,0,0;
           			,0,0,0,0,0,0,DATETIME(1900,1,1),DATETIME(1900,1,1),DATETIME(1900,1,1),0,1,0;
           			,0,0,0,0,0,0,'0000000000',0,0,0,0,0,0,0,0,0,0,0,'',0,DATETIME(1900,1,1),0,0)
           
	 				lnidproducto = lnidproducto+1	
	 			ELSE 
	 				lnidarticulo = CsrProducto.id
				ENDIF 
			ENDIF
		ENDIF 
			
		
		lnunibulto  = 1
		IF !EMPTY(CsrCuerpo.fecha_ofer)
			ldfecha = DATETIME(YEAR(CsrCuerpo.fecha_ofer),MONTH(CsrCuerpo.fecha_ofer),DAY(CsrCuerpo.fecha_ofer),0,0,0)
		ENDIF 
		* en leon los importes NO tienen iva
		
		lnprecostosiva	= Csrcuerpo.costo / lnunibulto 
		lnpreunitasiva  = Csrcuerpo.importe / lnunibulto 
		lnpreartisiva   = Csrcuerpo.precioart / lnunibulto 
		lninterno  		= Csrcuerpo.internos / lnunibulto 
		
		lnprecosto = (lnprecostosiva - lninterno) * (1+Csrcuerpo.iva_ri/100) + lninterno
		lnpreunita = (lnpreunitasiva - lninterno) * (1+Csrcuerpo.iva_ri/100) + lninterno
		lnprearti  = (lnpreartisiva - lninterno) * (1+Csrcuerpo.iva_ri/100) + lninterno
		
*!*			lnprecosto = Csrcuerpo.costo / lnunibulto 
*!*			lnpreunita = Csrcuerpo.importe / lnunibulto 
*!*			lnprearti    = Csrcuerpo.precioart / lnunibulto 


*!*			lnprecostosiva = (lnprecosto - lninterno) / (1+Csrcuerpo.iva_ri/100) + lninterno
*!*			lnpreunitasiva  = (lnpreunita - lninterno) / (1+Csrcuerpo.iva_ri/100) + lninterno
*!*			lnpreartisiva     = (lnprearti - lninterno) / (1+Csrcuerpo.iva_ri/100) + lninterno
*!*			
		lnbonif1 = Csrcuerpo.bonif
		lnivari = Csrcuerpo.iva_ri
		lnboniofer = Csrcuerpo.boni_ofer
		lnbonicant = CsrCuerpo.boni_cat
		
		lnCantidad   	= Csrcuerpo.cantidad * IIF(lnunivta=1,1,lnunibulto)
		lnKilos         = IIF(lnpesable=1,CsrCuerpo.kilos,lnPeso*lnCantidad)
		lnvolumen   	= lnKilos &&* lnCantidad
		lnescambio 		= IIF(CsrCuerpo.escambio='S',1,0)
		
		lnBoniSiva = lnpreunitasiva	* (lnBonif1/100) * IIF(lnpesable=1,CsrCuerpo.kilos,lnCantidad)
		lnBoniCiva = lnpreunita	* (lnBonif1/100) * IIF(lnpesable=1,CsrCuerpo.kilos,lnCantidad)
		
		nTotalSiva = Csrcuerpo.importe
		nTotalCiva = (nTotalSiva - lninterno) * (1+Csrcuerpo.iva_ri/100) + lninterno
		
		INSERT INTO CsrCuerfac (ID, IDMAOPERA, IDARTICULO, CODIGO, NOMBRE, CANTIDAD, UNIVENTA, UNIBULTO;
		, ORICOD, SDOCANT, KILOS, LISTAPRECIO, PRECOSTO, PREUNITA, PREARTI, INTERNO, DESPOR, TASAIVA;
		, SWITCH, IDDEPOSITO, ESPROMOCION, PERCEIBRUTO, IDCABEZA, VOLUMEN, PRECOSTOSIVA, PREUNITASIVA;
		, PREARTISIVA,PESABLE,IDFRIO,OFERFECHA,OFERBONIF,OFERBONIFCANT, ESCAMBIO,BONICIVA,BONISIVA;
		, totalciva,totalsiva);
		VALUES (lnidcuerpo,lnid,lnidarticulo,lcnumero,lcnombre,lncantidad,lnunivta,lnunibulto ,"D",0,lnkilos;
		,1,lnprecosto,lnpreunita,lnprearti,lninterno,lnbonif1,lnivari,"00000",lniddeposito,lnespromo,0;
		,lnidcabeza,lnvolumen,lnprecostosiva,lnpreunitasiva,lnpreartisiva,LNPESABLE,lnidfrio,ldfecha;
		,lnboniofer,lnbonicant,lnescambio,lnBoniCiva, lnBoniSiva, nTotalCiva, nTotalSiva)
		
		lnidcuerpo = lnidcuerpo + 1
		
		lnidcuerponocambio = lnidcuerpo -1 
		lnCuerpoCantidad   = 0
		lnCuerpoKilos      = 0
					
		IF CsrCuerpo.sabor#0 &&HayCuervari
			lnnumarticulo 	= CsrCuerpo.articulo
			lnSabor			= CsrCuerpo.sabor
			DO WHILE  CsrCuerpo.articulo = lnnumarticulo AND CsrCuerpo.orden=lcorden  AND CsrCuerpo.sabor=lnSabor AND !lbSalir
				
				lncuerpograbado = lnidcuerponocambio
				
				lnCantidad   = Csrcuerpo.cantidad * IIF(lnunivta=1,1,lnunibulto)
				lnKilos      = CsrProducto.peso
				lnvolumen    = lnKilos &&* lnCantidad
				lnescambio   = IIF(CsrCuerpo.escambio='S',1,0)
				
				lnidvariedad = 0
				SELECT CsrVariedad
				LOCATE FOR numero = CsrCuerpo.sabor
				IF FOUND() AND numero = CsrCuerpo.sabor
					lnidvariedad = CsrVariedad.id
				ENDIF 
				lnidsubarti = 0
				SELECT CsrSubproducto
				LOCATE FOR idarticulo = lnidarticulo AND idvariedad = lnidvariedad
				IF FOUND() AND idarticulo = lnidarticulo AND idvariedad = lnidvariedad
					lnidsubarti = CsrSubproducto.id
				ELSE 
					IF lnidvariedad#0
						lnidvari		= CsrVariedad.id
						lnsubnum		= CsrVariedad.numero
						lcnom			= CsrVariedad.nombre
						lnidvari		= CsrVariedad.id
						lnsubnum		= CsrVariedad.numero
						lcnom			= CsrVariedad.nombre
						lnnum			= val(lcnumero)
						INSERT INTO SubProducto (id,idarticulo,numero,subnumero,idvariedad,nombre,codigo;
						,troquel,nofactura,estado);
						VALUES (lnidsub,lnidarticulo,lnnum,lnsubnum,lnidvari,lcnom,"0","00000000",1,1)
						lnidsubarti 	= lnidsub
						lnidsub 		= lnidsub +1 
					ENDIF 
				ENDIF 
				IF lnescambio=1	 &&Creamos una linea aparte
					STORE 0 TO lnBoniCiva, lnBoniSiva
					lnidcuerpoescambio = lnidcuerpo
					INSERT INTO csrcuerfac (id, idmaopera, idarticulo, codigo, nombre, cantidad, univenta;
					, unibulto, oricod, sdocant, kilos, listaprecio, precosto, preunita, prearti, interno;
					, despor, tasaiva, switch, iddeposito, espromocion, perceibruto, idcabeza, volumen;
					, precostosiva, preunitasiva, preartisiva,pesable,idfrio,oferfecha,oferbonif;
					,oferbonifcant, escambio,BONICIVA,BONISIVA);
				    VALUES (lnidcuerpo,lnid,lnidarticulo,lcnumero,lcnombre,lncantidad,lnunivta,lnunibulto;
				    ,"D",0,lnkilos,1,lnprecosto,lnpreunita,lnprearti,lninterno,lnbonif1,lnivari,"00000";
				    ,lniddeposito,lnespromo,0,lnidcabeza,lnvolumen,lnprecostosiva,lnpreunitasiva;
				    ,lnpreartisiva,LNPESABLE,lnidfrio,ldfecha,lnboniofer,lnbonicant,lnescambio;
				    ,lnBoniCiva, lnBoniSiva)
					
					lnidcuerpo = lnidcuerpo + 1
					
					lncuerpograbado = lnidcueroescambio
				ELSE 
					lnCuerpoCantidad   = lnCuerpoCantidad + lnCantidad 
					lnCuerpoKilos      = lnCuerpoKilos + lnKilos 
				ENDIF 
				
				INSERT INTO cuervari (id,idmaopera,idcuerfac,idarticulo,idsubarti,idvariedad,cantidad;
						,kilos,volumen,escambio);
				VALUES (lnidcuervari,lnid,lncuerpograbado,lnidarticulo,lnidsubarti,lnidvariedad;
						,lncantidad,lnkilos,lnvolumen,lnescambio)
				lnidcuervari = lnidcuervari + 1
				
				SELECT CsrCuerpo
				SKIP 	
				IF EOF()
					lbSalir = .t.
					EXIT
				ENDIF 
										
			ENDDO 
			*Si salio es pq cambio el articulo o llego al eof
			UPDATE CsrCuerfac SET cantidad = lnCuerpoCantidad, kilos = lnCuerpoCantidad*lnPeso;
			, volumen = lnCuerpoCantidad*lnPeso where id = lnidcuerponocambio	
					
			SELECT CsrCuerpo
			*SKIP 
			IF !EOF() && si salio pq cambio articulo. estoy parado en el siguiente
				*SKIP -1
			ENDIF 
			IF lbSalir &&si salio pq eof. no debo recorrer nada mas
				EXIT 
			ENDIF 
		ELSE 
			SELECT CsrCuerpo &&sino tiene variedad recorro el siguiente.
			*IF !EOF()
				SKIP 
			*ENDIF 
		ENDIF
	ENDDO  
		
	lnid = lnid + 1
	lnidcabeza = lnidcabeza + 1
	SELECT CsrCabeza		     				
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE IN Csrcabeleon  
USE IN Csrcuerleon  
USE IN CsrCabeza
USE IN CsrCuerpo
USE IN Csrmovimien 
USE IN Csrmovisto 
USE IN CsrAnulados 
	