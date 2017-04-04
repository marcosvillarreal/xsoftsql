PARAMETERS ldfecha,lcpath,lcbase,lnlimite
lcfecha = IIF(PCOUNT()< 1,"01-01-2011",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)
lnlimite = IIF(PCOUNT()<4,"",lnlimite)
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
*llok = CargarTabla(lcData,'CabeAsi')
llok = CargarTabla(lcData,'MovStock')
*llok = CargarTabla(lcData,'TablaAsi')
llok = CargarTabla(lcData,'TablaImp')
llok = CargarTabla(lcData,'MovCtacte')
llok = CargarTabla(lcData,'PlanPago')
llok = CargarTabla(lcData,'Rubro')


IF !llok
	RETURN .f.
ENDIF

USE ALLTRIM(lcpath )+"\cabefac" IN 0 ALIAS CsrcabeGestion  EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\cuerfac" in 0 alias CsrcuerGestion  EXCLUSIVE

USE  ALLTRIM(lcpath )+"\movimien" in 0 alias Csrmovimien EXCLUSIVE

USE  ALLTRIM(lcpath )+"\movisto" in 0 alias Csrmovisto EXCLUSIVE	

*USE  ALLTRIM(lcpath )+"\anuladas" in 0 alias CsrAnuGestion EXCLUSIVE	
*ldfechaant=DATE(2010,08,01)
ldfechaant=CTOD(lcfecha)

oavisar.proceso("S","Reindexando Cuerfac por orden...")
SELECT CsrCuerGestion.*,SPACE(15)as orden FROM CsrCuerGestion WHERE ldfechaant <= fecha ;
ORDER BY articulo INTO CURSOR CsrCuerpo READWRITE 
SELECT CsrCuerpo
replace ALL orden WITH strzero(tipocomp,2)+left(letra,1)+strzero(talonario,4)+strzero(numcomp,8) IN CsrCuerpo
INDEX on orden TO Csrcuerpo

USE IN CsrcuerGestion

oavisar.proceso("S","Filtrando Cabefac por orden...")

SELECT CsrCabeGestion.*,SPACE(15)as orden FROM CsrCabeGestion WHERE ldfechaant <= fecha  ;
ORDER BY fecha INTO CURSOR CsrCabeza READWRITE 
SELECT CsrCabeza
replace ALL orden WITH strzero(tipocomp,2)+left(letra,1)+strzero(talonario,4)+strzero(numcomp,8) IN CsrCabeza
INDEX on fecha TO Csrcabeza

USE IN CsrcabeGestion

*!*	SELECT CsrAnuGestion.*,SPACE(15) as orden  FROM CsrAnuGestion;
*!*	order BY fecha INTO CURSOR CsrAnulados READWRITE 
*!*	SELECT CsrAnulados
*!*	replace ALL orden WITH strzero(tipocomp,2)+left(letra,1)+strzero(talonario,4)+strzero(numcomp,8) IN CsrAnulados
*!*	INDEX on orden TO CsrAnulados


SET SAFETY ON


oavisar.proceso("Procesando tablas...")
LOCAL lnid,lnidcabeza,lnidmovcte,lnidcuerpo,lnidmstk,lnidtablaasi,lnidtablaimp,lnidcabeasi,lnidcuervari
LOCAL lnidanmaiopera,lnidsub,lnidproducto

lHayEdicion = .f.
SELECT CsrProducto
LOCATE FOR idrubro = CsrRubro.id
IF idrubro = CsrRubro.id
	lHayEdicion = .t.
ENDIF 

lnid 		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidcabeza 	= RecuperarID('CsrCabefac',Goapp.sucursal10)
lnidcuerpo	= RecuperarID('CsrCuerfac',Goapp.sucursal10)
lnidmstk	= RecuperarID('CsrMovStock',Goapp.sucursal10)
*lnidtablaasi= RecuperarID('CsrTablaAsi',Goapp.sucursal10)
lnidtablaimp= RecuperarID('CsrTablaImp',Goapp.sucursal10)
*lnidcabeasi = RecuperarID('CsrCabeAsi',Goapp.sucursal10)
lnidcuervari= RecuperarID('CsrCuerVari',Goapp.sucursal10)
*lnidanmaiopera = RecuperarID('CsrAnMaopera',Goapp.sucursal10)
lnidsub 	= RecuperarID('CsrSubProducto',Goapp.sucursal10)
lnidproducto= RecuperarID('CsrProducto',Goapp.sucursal10)
*lnidanmaopera	= RecuperarID('CsrAnMaopera',Goapp.sucursal10)
lnidctacte			= RecuperarID('CsrCtacte',Goapp.sucursal10) + 1
SELECT CsrCtacte
GO BOTTOM 
nNumeroCtacte = VAL(CsrCtacte.cnumero)
LOCATE FOR ctadeudor = 1
lnidcatedeudor	= CsrCtacte.idcategoria

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
vista()
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
	STORE 0 TO lnrepartidor,lnfrio,lnrendida,lnbonif1,lnbonif2
	
	
	lclocalidad 	= CsrCabeza.localidad
	lntipocuit		= CsrCabeza.tipocuit
	lntipocomp 		= CsrCabeza.tipocomp
	lcorden 		= CsrCabeza.orden
	
	lncliente 		= CsrCabeza.cliente
	*lnrepartidor 	= CsrCabeza.repartidor
	*lnfrio 			= CsrCabeza.frio
	lnvendedor 		= Csrcabeza.vendedor
	lndiferida 		= 0&&IIF(CsrCabeza.diferida,1,0)
	lntasa 			= 0&&IIF(CsrCabeza.tasamuni='S',1,0)
	lnidnotacredito = CsrCabeza.tiponc
	*lnrendida 		= IIF(CsrCabeza.rendida='S',1,0)
	lccuit			= CsrCabeza.cuit
	
	
	lntipovta	= CsrCabeza.plan
	lnimporte	= CsrCabeza.importe
	*lnbonif1 	= CsrCabeza.bonif1
	*lnbonif2 	= CsrCabeza.bonif2
	lcnombre 	= CsrCabeza.nombre
	lcdireccion = CsrCabeza.direccion
	*lnentrega	= CsrCabeza.entrega
	ldfecha     = DATETIME(YEAR(Csrcabeza.fecha),MONTH(Csrcabeza.fecha),DAY(Csrcabeza.fecha),0,0,0)
	ldfecha_vto = DATETIME(YEAR(Csrcabeza.fecha_vto),MONTH(Csrcabeza.fecha_vto),DAY(Csrcabeza.fecha_vto),0,0,0)
	lcestado 	= '0'
	lctelefono	= CsrCabeza.telefono
	
	lcLocalidadBuscada = Ciudades(lcLocalidad)
	
	lnidlocalidad =	1100000006 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
	lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
	lccp = ""
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccp = CsrLocalidad.cpostal
	ENDIF
	
	lntipoiva =lntipocuit
	IF lntipoiva=7
	   lntipoiva =5
	ENDIF 
	
	SELECT CsrPlanPago
	LOCATE FOR 	numero = lntipovta
	IF !numero = lntipovta
		LOCATE FOR numero = "CCT"
	ENDIF 
	lnidplanpago = CsrPlanPago.id
	
	SELECT Csrctacte
    LOCATE FOR ALLTRIM(cnumero)==LTRIM(STR(lncliente))
    lnidctacte = 0 
    lnidcategoria = 0 
    IF ALLTRIM(cnumero)<>LTRIM(STR(lncliente))
    	LOCATE FOR ALLTRIM(cuit) = lccuit
    	IF ALLTRIM(cuit) <> lccuit
    		LOCATE FOR ALLTRIM(cnombre)==lcNombre
    		IF NOT FOUND()
    		    		
		    	STORE 0 TO lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
				,lnctabanco,lnctaotro,lnctaorden,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
			    ,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
			    ,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif,lnidcategoria;
			    ,lndiasvto,lnplanpago
			    
			   	STORE "" TO lctelefono2,lctelefono,lcemail,lccuit;
			    ,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc
			       
			    STORE 1 TO 	lnctadeudor,lnlista, lnidcanalvta
			    &&lcEmail			= FsrDeudor.cliente
			    nNumeroCtacte	= nNumeroCtacte + 1 
			    lncliente		= nNumeroCtacte
			    lcnumero		= strtrim(lncliente,8)
				lnestadocta		= 0
				ldfechalta		= DATE()
				lcobserva		= "IMPORTADOR"
				ldfecins01		= DATETIME(1900,01,01,0,0,0)
				ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
				ldfecultpago	= DATETIME(1900,01,01,0,0,0)
				lnidtablaint	= 0 &&Por defecto es el interes de socio
				&&Buscamos si existen los tipo de documento valido			
					
				lnidcategoria = lnidcatedeudor

				ldfecfac = CsrCabeza.fecha
				
				lcnombre = NombreNi(ALLTRIM(UPPER(lcnombre)))
				lcdireccion = NombreNi(ALLTRIM(UPPER(lcdireccion)))
			      
				INSERT INTO Csrctacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono2;
				,ctelefono,email,tipoiva,cuit,idcategoria,ctadeudor,ctaacreedor,ctalogistica,ctabanco,ctaotro;
				,ctaorden,idplanpago,idcanalvta,fechalta,observa,saldo,saldoant,estadocta,bonif1,bonif2,copiatkt;
				,inscri01,fecins01,inscri02,inscri03,convenio,saldoauto,idbarrio,lista,idcateibrng,ingbrutos;
				,comision,fecultcompra,fecultpago,numdoc,idtipodoc,existeibto,existegan,diasvto,idtablaint,esrecodevol;
				,totalizabonif);
			    VALUES(lnid,lcnumero,lcnombre,lcdireccion,lccp,lnidlocalidad,lnidprovincia,lctelefono2;
			    ,lctelefono,lcemail,lntipoiva,lccuit,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica,lnctabanco;
			    ,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,ldfechalta,lcobserva,lnsaldo,lnsaldoant,lnestadocta;
			    ,lnbonif1,lnbonif2,lncopiatkt,lcinscri01,ldfecins01,lcinscri02,lcinscri03,lnconvenio,lnsaldoauto;
			    ,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,lcnumdoc,lnidtipodoc;
			    ,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif)
			    
				lnidctacte = lnidctacte + 1
			ENDIF 
		ENDIF 
	ENDIF 
    lnidctacte	= Csrctacte.id
    lnidcategoria = CsrCtacte.idcategoria
	
	******Chequeamos que si el comprobante es anulado, recupero la cabeza en anulados.
	IF "ANULA"$UPPER(CsrCabeza.nombre)
		SELECT CsrCabeza
		LOOP 
*!*			
*!*			SELECT CsrAnulados
*!*			LOCATE FOR VAL(orden) = VAL(lcorden)
*!*			IF !FOUND() AND VAL(orden) <> VAL(CsrCabeza.orden)
*!*				LOOP &&sino existe la cabeza guardada, no lo grabo.
*!*			ENDIF 
*!*			lclocalidad = CsrAnulados.localidad
*!*			lntipocuit 	= CsrAnulados.tipocuit
*!*			lntipocomp 	= CsrAnulados.tipocomp
*!*			lcnumcomp 	= CsrAnulados.letra+RIGHT(STR(10000+CsrAnulados.talonario),4)+RIGHT(STR(1000000000+CsrAnulados.numcomp),8)
*!*			lncliente 	= CsrAnulados.cliente	
*!*			lnrepartidor= CsrAnulados.repartidor
*!*			lnfrio 		= 0&&CsrAnulados.frio
*!*			lnvendedor 	= CsrCabeza.vendedor
*!*			lndiferida 	= 0 &&IIF(CsrAnulados.esdiferido,1,0)
*!*			lnidnotacredito = 0&&CsrAnulados.tiponc
*!*			lnrendida 	= IIF(CsrAnulados.rendida='S',1,0)
*!*			ldfecha     = DATETIME(YEAR(CsrAnulados.fecha),MONTH(CsrAnulados.fecha),DAY(CsrAnulados.fecha),0,0,0)
*!*			lccuit		= CsrAnulados.cuit
*!*			lntipovta	= CsrAnulados.plan
*!*			lnimporte	= CsrAnulados.importe
*!*			lnbonif1 	= CsrAnulados.bonif1
*!*			lnbonif2 	= CsrAnulados.bonif2
*!*			lcnombre 	= CsrAnulados.nombre
*!*			lcdireccion = CsrAnulados.direccion
*!*			lnentrega	= CsrAnulados.entrega
*!*			ldfecha_vto = DATETIME(YEAR(CsrAnulados.fecha_vto),MONTH(CsrAnulados.fecha_vto),DAY(CsrAnulados.fecha_vto),0,0,0)
*!*			lcestado	= '1'
	ENDIF 
	
	ldfechaserver 	= ldfecha &&DATETIME()
	ldfechasis 		= FechaHoraCero(ldfechaserver)
	
	
	lcswitch = "00090"
	lcDebeHaber	= "D"
	lnsigno = 1
	IF !"ANULA"$UPPER(CsrCabeza.nombre)
		lcLetra = CsrCabeza.letra
	ENDIF 
	DO case
		CASE lntipocomp=2	&& factura
			lntipocomp = 1
		CASE lntipocomp=3	&& n.deb
			lntipocomp = 2
		CASE lntipocomp=4	&& n.cre
			lntipocomp = 3
			lnsigno = -1
			lcDebeHaber	="H"
		CASE lntipocomp = 5  &&presupuesto
			lntipocomp = 6
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
	
   
	
	STORE 0 TO lnidfletero,lnidfrio
	
*!*	    SELECT Csrfletero
*!*	    LOCATE FOR numero=lnrepartidor
*!*	    lnidfletero = 0      
*!*	    IF numero=Csrcabeza.repartidor
*!*	    	lnidfletero = Csrfletero.id
*!*	    ENDIF
*!*	      
*!*	    SELECT Csrtipofrio
*!*	    LOCATE FOR numero=lnfrio
*!*	    lnidfrio = 0      
*!*	    IF numero=Csrcabeza.frio
*!*	        lnidfrio = Csrtipofrio.id
*!*	    ENDIF

    SELECT Csrfuerzavta
    LOCATE FOR numero = 1
    lnidfuerzavta = Csrfuerzavta.id
      
    SELECT Csrvendedor
    LOCATE FOR numero=lnvendedor
    lnidvendedor = 0      
    IF numero=Csrcabeza.vendedor
       lnidvendedor = Csrvendedor.id
    ENDIF

	
	INSERT INTO Csrmaopera (id,origen,programa,terminal,fechasis,idoperador,idvendedor,idcomproba,numcomp;
	,clasecomp,iddetanrocaja,turno,switch,sucursal,sector,puestocaja,idcotizadolar,estado,fechaserver);
	VALUES (lnid,'FAC',"IMPORTACION FACTURAS",goapp.terminal,ldfechasis,1,lnidvendedor,lnidcomproba;
	,lcnumcomp,lcclasecomp,lniddetanrocaja,1,"00000",goapp.sucursal,1,1,1,lcestado,ldfechaserver)

	Insert into Csrcabefac (ID, IDMAOPERA, IDCTACTE, CTACTE, CNOMBRE, CDIRECCION, CTELEFONO, CPOSTAL;
	, IDLOCALIDAD, IDPROVINCIA,IDFRIO, IDTIPOIVA, CUIT, IDSUBCTA, FECHA, IDPLANPAGO, TOTAL, BONIF1, BONIF2;
	, SWITCH, LISTAPRECIO, IDFLETERO, IDFUERZAVTA, IDRUTAVDOR,SIGNO,TASAMUNI,DIFERIDA,IDTIPONCREDITO,RENDIDA;
	,IDCATEGORIA);
	value (lnidcabeza,lnid,lnidctacte,LTRIM(STR(lncliente)),lcnombre,lcdireccion,lctelefono;
	,lccp,lnidlocalidad,lnidprovincia,lnidfrio,lntipoiva,lccuit,0,ldfecha,lnidplanpago,lnimporte,lnbonif1;
	,lnbonif2,"F0000",1,lnidfletero,lnidfuerzavta,0,lnsigno,lntasa,lndiferida,lnidnotacredito,lnrendida;
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
*!*		*Generamos la afectacion de anulados
*!*		IF lcestado='1'
*!*			
*!*			lnidafecta = lnid
*!*			lnid = lnid + 1
*!*			
*!*			INSERT INTO Csrmaopera (id,origen,programa,terminal,fechasis,idoperador,idvendedor,idcomproba;
*!*			,numcomp,clasecomp,iddetanrocaja,turno,switch,sucursal,sector,puestocaja,idcotizadolar,estado;
*!*			,fechaserver);
*!*			VALUES (lnid,'FAC',"IMPORTACION FACTURAS",goapp.terminal,ldfechasis,1,lnidvendedor,lnidcomproba;
*!*			,lcnumcomp,'K',1,1,"00000",goapp.sucursal,1,1,1,'0',ldfechaserver)
*!*			
*!*			INSERT INTO anmaopera (id,idmaopera,idafecta,detalle,idmotanula);
*!*			VALUES (lnidanmaopera,lnid,lnidafecta,"COMPROBANTE ANULADO DE IMP.",0)
*!*			
*!*			lnid = lnid + 1
*!*			lnidanmaopera = lnidanmaopera +1 
*!*			lnidcabeza = lnidcabeza + 1
*!*			LOOP 
*!*		ENDIF 
	
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
		IF lniddeposito = 0
			SELECT CsrDeposito
			LOCATE FOR 	llevastock = 1
			lnideposito = CsrDeposito.id
		ENDIF 
			             
		SELECT CsrProducto
		LOCATE FOR numero=VAL(Csrcuerpo.articulo)
		lcnumero  =" "
		lcnombre = " "
		IF numero<>VAL(Csrcuerpo.Articulo)
			IF lHayEdicion
				SELECT CsrProducto
				LOCATE FOR idrubro = CsrRubro.id
				IF idrubro = CsrRubro.id
					lnidarticulo = CsrProducto.id
				ENDIF 
			ELSE 
				&&Insertar producto con detalle
				SELECT CsrProducto
				GO BOTTOM 
				
				STORE 0 TO   ncodigo , nidctacte , nidmarca , nidforma , nidunidad , nidtprod , nidtipovta; 
	           , nidtamano , nidcatego , nidrubro , nidestado , nidubicacio , nidorigen ;
	           , nincluirped , nidmoneda , nidiva , nunibulto , nnofactura , nnolista , nespromocion ;
	           , nminimofac , npeso , nvolumen , nfracciona , npuntope, ndivisible ,nnomodifica  ;
	           , nctaaorden, nesinsumo , nidfamilia , nidcategotipo, ncotidolar , nendolar ,nredondeo 
			    STORE "" TO  cnombre , ccodalfa , ccontrolador , cnommayorista , ccodalfaprov , ccodbarra14;
			           , ccodbarra13 
			    STORE DATE() TO  dfeculcpra , dfeculvta , dfecalta , dfecmodi , dfeculpre
	    
				cnombre		= "ARTICULO DE IMPORTACION"
				ncodigo		= CsrProducto.numero + 1
				
				cnommayorista	= cnombre
				ccontrolador	= cnombre
				
				nidrubro	= CsrRubro.id
				nidtipovta	= 1 &&UNIDADES=1 ,	BULTOS = 2.
	    		nidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
	    		cswitch		= "00000"
	    		
				INSERT INTO  producto  ( id , numero  , nombre  , codalfa , idctacte , idmarca ;
		           , idforma , idunidad , idtprod , idtipovta ;
		           , idtamano , idcatego , idrubro , idestado , idubicacio , idorigen ;
		           , nomodifica , incluirped , idmoneda , idiva , feculcpra , feculvta ;
		           , fecalta , fecmodi , unibulto , nofactura , nolista , espromocion ;
		           , minimofac , peso , volumen , fracciona , puntope, switch , divisible ;
		           , controlador , nommayorista , ctaaorden, esinsumo , idfamilia ;
		           , idcategotipo, codalfaprov , cotidolar , endolar , codbarra14;
		           , codbarra13 , feculpre ) ;
			     VALUES  ( lnidproducto , ncodigo , cnombre , ccodalfa , nidctacte , nidmarca ;
			           , nidforma , nidunidad , nidtprod , nidtipovta ;
			           , nidtamano , nidcatego , nidrubro , nidestado , nidubicacio , nidorigen ;
			           , nnomodifica , nincluirped , nidmoneda , nidiva , dfeculcpra , dfeculvta ;
			           , dfecalta , dfecmodi , nunibulto , nnofactura , nnolista , nespromocion ;
			           , nminimofac , npeso , nvolumen , nfracciona , npuntope, cswitch , ndivisible ;
			           , ccontrolador , cnommayorista , nctaaorden, nesinsumo , nidfamilia ;
			           , nidcategotipo, ccodalfaprov , ncotidolar , nendolar , ccodbarra14 ;
			           , ccodbarra13 , dfeculpre) 
				lnidarticulo = lnidproducto
			ENDIF 
			lcNumero	= CsrCuerpo.articulo
	    ELSE
	    	lnidarticulo = CsrProducto.id
	    	lcnumero = strtrim(Csrproducto.numero,8)
		ENDIF
		
		lcNombre = CsrCuerpo.nombre
		lcCodInterno	= CsrCuerpo.codfac
		
		lnunibulto  = 1
		IF !EMPTY(CsrCuerpo.fecha)
			ldfecha = CTOD('01-01-1900')
		ENDIF 
		
		SELECT CsrTipoiva
		LOCATE FOR id = CsrProducto.idiva
		lnivari = CsrTipoiva.tasa
		
		*lnpreunitasiva  = Csrcuerpo.importe / lnunibulto 
		*lnprecostosiva	= lnpreunitasiva
		*lnpreartisiva   = Csrcuerpo.precioart / lnunibulto 
		*lninterno  		= Csrcuerpo.internos / lnunibulto 
		*lnprecosto = (lnprecostosiva - lninterno) * (1+lnivari/100) + lninterno
		*lnpreunita = (lnpreunitasiva - lninterno) * (1+lnivari/100) + lninterno
		*lnprearti  = (lnpreartisiva - lninterno) * (1+lnivari/100) + lninterno
		
		lnpreunita  = Csrcuerpo.importe / lnunibulto 
		lnprecosto	= CsrCuerpo.costo / lnunibulto
		lnprearti   = lnpreunita
		lninterno  	= Csrcuerpo.internos / lnunibulto 
		
		lnprecostosiva = (lnprecosto - lninterno) * (100/lnivari) + lninterno
		lnpreunitasiva = (lnpreunita- lninterno) * (100/lnivari) + lninterno
		lnpreartisiva  = (lnprearti - lninterno) * (100/lnivari) + lninterno
		
		lnbonif1 = Csrcuerpo.bonif
		
		lnboniofer = 0
		lnbonicant = 0
		
		lnCantidad   	= Csrcuerpo.cantidad * IIF(lnunivta=1,1,lnunibulto)
		lnKilos         = 0
		lnvolumen   	= lnKilos
		lnescambio 		= 0
		
		lnBoniSiva = lnpreunitasiva	* (lnBonif1/100) * lnCantidad
		lnBoniCiva = lnpreunita	* (lnBonif1/100) * lnCantidad
		
		nTotalCiva = Csrcuerpo.importe
		nTotalSiva = (nTotalCiva - lninterno) * (100/lnivari) + lninterno
		
		INSERT INTO CsrCuerfac (ID, IDMAOPERA, IDCABEZA, IDARTICULO, CODIGO,CODINTERNO, NOMBRE, CANTIDAD, UNIVENTA, UNIBULTO;
		, ORICOD, SDOCANT, KILOS, LISTAPRECIO, PRECOSTO, PREUNITA, PREARTI, INTERNO, DESPOR, TASAIVA;
		, SWITCH, IDDEPOSITO, PERCEIBRUTO, VOLUMEN, PRECOSTOSIVA, PREUNITASIVA;
		, PREARTISIVA,BONICIVA,BONISIVA;
		, totalciva,totalsiva,endolar);
		VALUES (lnidcuerpo,lnid,lnidcabeza,lnidarticulo,lcnumero,lccodinterno,lcnombre,lncantidad,lnunivta,lnunibulto ,"D",0,lnkilos;
		,1,lnprecosto,lnpreunita,lnprearti,lninterno,lnbonif1,lnivari,"00000",lniddeposito,0;
		,lnvolumen,lnprecostosiva,lnpreunitasiva,lnpreartisiva,lnBoniCiva, lnBoniSiva, nTotalCiva, nTotalSiva,1)
		
		lnidcuerpo = lnidcuerpo + 1
		
		lnidcuerponocambio = lnidcuerpo -1 
		lnCuerpoCantidad   = 0
		lnCuerpoKilos      = 0
					
	
		SELECT CsrCuerpo &&sino tiene variedad recorro el siguiente.
		*IF !EOF()
		SKIP 
		*ENDIF 

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
USE IN CsrCabeza
USE IN CsrCuerpo
USE IN Csrmovimien 
USE IN Csrmovisto 
*!*	USE IN CsrAnulados 
	