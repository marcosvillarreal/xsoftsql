PARAMETERS ldfecha,lcpath,lcBase
ldfecha = IIF(PCOUNT()<1,"",ldfecha)
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
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'TipoIva')
*llok = CargarTabla(lcData,'CateCtacte',.t.)
llok = CargarTabla(lcData,'Barrio',.t.)
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Sucursal',.t.)
llok = CargarTabla(lcData,'PadronAfip',.t.)
llok = CargarTabla(lcData,'MovCtacte')
llok = CargarTabla(lcData,'Maopera')

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.* FROM Localidad as CsrLocalidad
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrConceptoGan.* FROM ConceptoGan as CsrConceptoGan
ENDTEXT
=CrearCursorAdapter('CsrConceptoGan',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCateGan.* FROM CateGan as CsrCateGan
ENDTEXT
=CrearCursorAdapter('CsrCateGan',lcCmd)

TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrParaConta.* FROM ParaConta as CsrParaConta
where idejercicio = <<goapp.idejercicio>>
ENDTEXT 
IF !CrearCursorAdapter('CsrParaConta',lccmd)
	MESSAGEBOX('Nose puede importar, pq no cargado el CsrParaConta')
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

SET SAFETY ON
CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrDeudor (Codigo c(8),Categoria c(20),Nombre c(70),Direccion c(100),Localidad c(50),CodPostal c(10),Provincia c(50);
		,Telefono c(20),Telefono2 c(20),Fax c(20),Celular c(20),Email c(50),fecAlta c(15),TipoDoc c(50),Documento c(20);
		,TipoIVA c(50),Vendedor c(30),Zona c(3),obsercli c(100),ctadeudor n(1),IngBrutos c(20);
		,DireNro c(5),DirePiso c(5),DireDpto c(5),Lista c(30),CodLista n(2),Estado c(1);
		,CodCateIVA n(2),CodGan n(3),PlanPago n(1),DiasVto n(3),Ganancia n(1))

CREATE CURSOR CsrSaldos (Codigo c(8),Saldo c(20))
		
Oavisar.proceso('S','Abriendo archivos') 


SET SAFETY OFF 
SELECT CsrLista
ZAP 
SET SAFETY ON 
cArchivo = ALLTRIM(lcpath )+"\proveedores.csv"
APPEND FROM  &cArchivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

cRutaTemp  =SYS(5)+CURDIR()+'Temporal'
IF !DIRECTORY(cRutaTemp)
	MKDIR SYS(5)+CURDIR()+'Temporal'
ENDIF 


SELECT CsrLista
GO TOP 
*vista()
lnPrimeraOcurrencia = 1
leiunarticulo = .f.
*STOP()
*SKIP 

DO WHILE NOT EOF() 
	lnCantCampo = 25 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		SKIP 
		LOOP 
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia
		STORE "" TO lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento
		STORE "" TO lcobservacion,lcIngBrutos,lcGanancia
		STORE "" TO lcTipoIVA,lcVendedor,lcZona,lcCodVendedor,lcDireNro,lcDirePiso,lcDireDpto,lcLista
		STORE "" TO lcEstado,lcCodLista,lcCodCateIVA,lcCodGan,lcPlanPago,lcDiasVto,lcCBU
		
		j = 0
	ELSE
		IF !leiunarticulo
			SKIP 
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
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcNombre)))	
			lcDireccion		= UPPER(LimpiarCadena(IIF(j + i=4,lcCadena,lcDireccion)))
			lcDireNro		= UPPER(LimpiarCadena(IIF(j + i=5,lcCadena,lcDireNro)))
			lcDirePiso		= UPPER(LimpiarCadena(IIF(j + i=6,lcCadena,lcDirePiso)))
			lcDireDpto		= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcDireDpto)))
			LcLocalidad		= UPPER(LimpiarCadena(IIF(j + i=09,lcCadena,lcLocalidad)))
			lcProvincia		= UPPER(LimpiarCadena(IIF(j + i=10,lcCadena,lcProvincia)))
			lcTelefono		= UPPER(LimpiarCadena(IIF(j + i=11,lcCadena,lcTelefono)))			
			lcCodCateIVA	= UPPER(LimpiarCadena(IIF(j + i=12,lcCadena,lcCodCateIVA)))
			lcTipoIVA		= UPPER(LimpiarCadena(IIF(j + i=13,lcCadena,lcTipoIVA)))
			lcIngBrutos		= UPPER(LimpiarCadena(IIF(j + i=14,lcCadena,lcIngBrutos)))
			lcDocumento		= UPPER(LimpiarCadena(IIF(j + i=15,lcCadena,lcDocumento)))
			lcTipoDoc		= 'CUIT'
			
			lcCBU			= UPPER(LimpiarCadena(IIF(j + i=20,lcCadena,lcCBU)))
			lcTelefono2		= UPPER(LimpiarCadena(IIF(j + i=21,lcCadena,lcTelefono2)))
			lcGanancia		= UPPER(LimpiarCadena(IIF(j + i=22,lcCadena,lcGanancia)))
			lcCodGan		= UPPER(LimpiarCadena(IIF(j + i=23,lcCadena,lcCodGan)))
			lcPlanPago		= UPPER(LimpiarCadena(IIF(j + i=24,lcCadena,lcPlanPago)))
			lcDiasVto		= UPPER(LimpiarCadena(IIF(j + i=25,lcCadena,lcDiasVto)))
										
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
		
		
		INSERT INTO CsrDeudor (Codigo,Categoria,Nombre,Direccion,Localidad,CodPostal,Provincia;
		,Telefono,Telefono2,Fax,Celular,Email,fecAlta,TipoDoc,Documento;
		,TipoIVA,Vendedor,Zona,ctadeudor,DireNro,DirePiso,DireDpto,Lista,Estado,CodLista;
		,CodCateIVA,CodGan,PlanPago,DiasVto,Ganancia) ;
		values (lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia ;
		,lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento ;
		,lcTipoIVA,"","",0,lcDireNro,lcDirePiso,lcDireDpto,"",lcEstado;
		,0,VAL(lcCodCateIVA),VAL(lcCodGan),VAL(lcPlanPago),VAL(lcDiasVto),VAL(lcGanancia))
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
		
		
*!*			cRuta = ADDBS(cRutaTemp)+"Temporal.XML"

*!*			SET SAFETY OFF 
*!*			CursorAdapterToXML('CsrDeudor',cRuta)
*!*			SET SAFETY ON 

	ENDIF 
	SKIP 
ENDDO 

cCadeCtacte = "" 

SELECT CsrLista
cArchivo = ADDBS(ALLTRIM(lcpath ))+"saldo_proveedores.csv"
IF FILE(cArchivo)
	APPEND FROM  &cArchivo SDF

	lcDelimitador = ";"
	replace ALL deta01 WITH ALLTRIM(STRTRAN(deta01,"	",lcDelimitador))
	replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
	replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

	Oavisar.proceso('S','Procesando '+alias()) 

	cCadeCtacte = "" 


	SELECT CsrLista
	GO TOP 
	*vista()
	lnPrimeraOcurrencia = 1
	leiunarticulo = .f.

	ldebug = .t.

	*SKIP 
	*stop()
	DO WHILE NOT EOF()
		lnCantCampo = 3 &&Hay un campo vacio
		lnSiguienteOcurrencia = 1
		lnCamposLeidos = 1 &&Campos de CsrLista
		lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

		IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
			SKIP 
			LOOP 
		ENDIF 
		
		IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
			leiunarticulo = .t.
			STORE "" TO lcAcarreo
			STORE "" TO lcCodigo,lcSaldo
			
			j = 0
		ELSE
			IF !leiunarticulo
				SKIP 
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
				*lcSaldo		= UPPER(LimpiarCadena(IIF(j + i=3,STRTRAN(STRTRAN(lcCadena,'.',''),',','.'),lcSaldo)))
				lcSaldo			= UPPER(LimpiarCadena(IIF(j + i=3,strtran(lcCadena,'.',''),lcSaldo)))
								
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
			lcSaldo = STRTRAN(lcSaldo,',','.')
			INSERT INTO CsrSaldos (Codigo,Saldo) ;
			values (lcCodigo,lcSaldo)
					
			*replace descripcion WITH lmDescripcion IN FsrArticulo
			leiunarticulo = .f.
		ENDIF 
		SKIP IN CsrLista
	ENDDO 
ELSE
	oavisar.usuario('El saldo no se importara, no existe el archivo')
ENDIF 

SELECT distinct UPPER(localidad) as nombre ,SPACE(30) AS Localidad FROM CsrDeudor  INTO CURSOR CsrCiudad READWRITE 

SELECT CsrCiudad
SCAN 
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(nombre)))
	SELECT CsrLocalidad
	LOCATE FOR nombre = lcLocalidadBuscada
	IF id#0
		replace localidad WITH lcLocalidadBuscada IN CsrCiudad
	ENDIF 
	SELECT CsrCiudad
ENDSCAN
*vista()

lcfiscal	=ALLTRIM(STR(YEAR(ldfecha)))+ALLTRIM(STRzero(MONTH(ldfecha),2,0))+ALLTRIM(STRzero(DAY(ldfecha),2,0))

lnidmaopera		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidmovctacte	= RecuperarID('CsrMovCtacte',Goapp.sucursal10)

ldfechasis	=DATETIME(YEAR(ldfecha),MONTH(ldfecha),DAY(ldfecha),0,0,0)
ldfechas	=DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)

*!*	lnid = RecuperarID('CsrCatectacte',Goapp.sucursal10)
*!*	lnnumero = 1
*!*	SELECT distinct UPPER(Categoria) as nombre FROM CsrDeudor  INTO CURSOR CsrCategoria

*!*	SELECT CsrCategoria
*!*	GO top
*!*	SCAN 
*!*		INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,lnnumero,CsrCategoria.nombre,0,0,0,'00000')
*!*		lnid = lnid +1 
*!*		lnnumero = lnnumero + 1 
*!*	ENDSCAN 

*!*	lnidmercaderia = lnid
*!*	INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,lnnumero,'PROVEEDOR',0,0,0,'01000')
*!*	lnid = lnid +1 
*!*	lnnumero = lnnumero + 1 
*!*	INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,lnnumero,'SERVICIO',0,0,0,'00000')

lnidpadron = RecuperarID('CsrPadronAfip',Goapp.sucursal10)

SET SAFETY OFF 
&&Limpiamos los antiguos proveedores
DELETE FROM CsrCtacte WHERE ctaacreedor = 1
SELECT CsrCtacte
PACK 
SET SAFETY ON 

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

SELECT distinct UPPER(lista) as nombre FROM CsrDeudor INTO CURSOR CsrListaPrecio
SELECT CsrListaPrecio



SELECT CsrCtacte
GO TOP 
lnNroCta = VAL(CsrCtacte.cnumero)
lnUltNroCta = lnNroCta

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
*VISTA()
cCadeCtacte = ''

*stop()
SCAN 
	
	IF VAL(codigo)=44
		*stop()
	ENDIF 
	
	SELECT CsrCtacte
	LOCATE FOR VAL(cnumero) = lnUltNroCta
	IF lnNroCta+1>= lnUltNroCta
		lnNroCta = lnUltNroCta
		lHueco = .f.
		SKIP 
		DO WHILE NOT EOF() AND NOT lHueco
			
			lnNroCta = lnNroCta + 1 
			IF lnNroCta <>VAL(CsrCtacte.cnumero)
				lHueco = .t.
				lnUltNroCta = VAL(CsrCtacte.cnumero)
			ENDIF 
			SKIP 
		ENDDO 
	ELSE
		lnNroCta = lnNroCta + 1 
	ENDIF 
	*lnCodigo = 90000 + VAL(CsrDeudor.codigo)
	lnCodigo = lnNroCta
	
 	SELECT CsrCtacte
 	LOCATE FOR VAL(cnumero) = lnCodigo
 	IF VAL(cnumero) = lnCodigo
 		cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + ltrim(CsrDeudor.codigo)
 		SELECT CsrDeudor
 		LOOP 
 		
 	ENDIF 
 	SELECT CsrDeudor 
 	STORE 0 TO lnidestado, 	lnctadeudor ,	lnctaacreedor, 	lnctabanco,	lnctaotro, 	lndctalogistica;
 			,lnidcateibrng ,lncomision ,lnidlocalidad ,lnidprovincia ,lntipoiva ,lnidcategoria;
			,lnidplanpago ,lnidcanalvta ,lnsaldoAuto ,lnlista ,lncomision ,lnconvenio,lndctalogistica;
			,lnbonif1
	
 	STORE 1100000001 TO lnidbarrio, lnidcategoria, lnlista
 	STORE "" TO lcCuit,lcDNI,lcingbrutos,lcingbrutosBA,lcdatosfac,lcOtro01,lcObserva,lccp
 	STORE DATETIME(1900,01,01,0,0,0) TO ldfechac,ldfecultcompra,ldfecultpago,lcfefin
 		
 	lnidplanpago	= 1100000001 &&Por el momento todos de cuenta corriente	
 	lnidplanpago	= IIF(CsrDeudor.PlanPago=2,1100000002,1100000001)	
	lnidcanalvta	= 1
	lnlista			= CsrDeudor.CodLista
	DO CASE
	CASE lnLista = 0
		lnLista = 1
	OTHERWISE
		&&Falta el resto de listas que nose cuales seran las por defecto
	ENDCASE
		
	lcNroDoc		= strtrim(VAL(PeloCuit(CsrDeudor.Documento)),15)
	
	IF ALLTRIM(CsrDeudor.tipodoc)$'CUIT'
		lcCuit			= Cuit(lcNroDoc)
	ENDIF 
	
	&&Localidad
	lnidlocalidad	= 1100000345  &&Bahia Blanca
	lnidprovincia	= 1100000002
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)))
	SELECT CsrLocalidad
	LOCATE FOR nombre = lcLocalidadBuscada
	IF nombre = lcLocalidadBuscada
		lnidprovincia	= CsrLocalidad.idprovincia
		lccp 			= CsrLocalidad.cpostal
		lnidlocalidad	= CsrLocalidad.id
	ELSE
		lnidestado = 1
	ENDIF
	
	&&TresPImp	
	nTipoiva	= CsrDeudor.Codcateiva
	DO CASE 
	CASE nTipoiva = 6 &&CF
		lntipoiva = 3	
	CASE nTipoiva = 2 &&RNI
		lntipoiva = 9	
	CASE nTipoiva = 11 &&EX sin impuestos?
		lntipoiva = 4	
	OTHERWISE 
		lntipoiva = CsrDeudor.Codcateiva
	ENDCASE 
	IF lntipoiva=3
		*lcCuit=''
	ENDIF

	lcnumero	= strtrim(lnCodigo,8)
	
	SELECT CsrCtacte
	*GO BOTTOM 
	*lcnumero		= strtrim(VAL(CsrCtacte.cnumero)+1,8)
	lcOtro01		= CsrDeudor.codigo &&Almacenamos para relacionar al proveedor + articulo
	lnctadeudor		= 0
	lnctaacreedor	= 1
	lcingbrutosBA	= CsrDeudor.ingbrutos
	lcObserva		= "CONTACTO: " + LTRIM(CsrDeudor.obsercli)+CHR(13)
	lcObserva		= lcObserva + "CODIGO JAQUE: " + LTRIM(CsrDeudor.CODIGO)
	lnidcategoria	= 1100000003
	
	SELECT CsrConceptoGan
	LOCATE FOR numero = CsrDeudor.CodGan
	lnidconcepgan = CsrConceptoGan.id
	
	lnidcategan = 1100000003
	DO CASE 
	CASE CsrDeudor.Ganancia = 0
		lnidcategan = 1100000004
	CASE CsrDeudor.Ganancia = 2
		lnidcategan = 1100000002
	ENDCASE 
	
	INSERT INTO CsrPadronAfip (id,idctacte,cuit,idcategoria,idconcepto,fechaauto,;
					fechamanu,automatico,fecha,excluido,leyenda,fecdesde,fechasta);
	VALUES (lnidpadron,lnid,PeloCuit(lcCuit),lnidcategan,lnidconcepgan,stod('19000101'),;
					stod('19000101'),0,DATE(),0,'',stod('19000101'),stod('19000101'))
					
	lnidpadron = lnidpadron + 1 
	
	
	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrDeudor.nombre)))  	
  	lcDire_Calle= RTRIM(UPPER(CsrDeudor.direccion))
  	lcDire_Nro	= RTRIM(UPPER(CsrDeudor.direnro))
  	lcDire_Piso	= RTRIM(UPPER(CsrDeudor.direpiso))
  	lcDire_Dpto	= RTRIM(UPPER(CsrDeudor.diredpto))
  	lcDireccion = lcDire_Calle + " " + lcDire_Nro + " P:"+ lcDire_Piso + " D:"+lcDire_Dpto
  	*lcCP		= LTRIM(lcCp)
  	
  	lcTelefono	= LTRIM(CsrDeudor.telefono)
  	IF LEN(ALLTRIM(lcTelefono)) = 0
  		lcTelefono	= LTRIM(CsrDeudor.telefono2)
  	ELSE
  		IF LEN(ALLTRIM(CsrDeudor.telefono2)) <> 0
  			lcObserva	= lcObserva + CHR(13) + "TELEFONO: " +LTRIM(CsrDeudor.telefono2)
  		ENDIF 
  	ENDIF 
  	IF LEN(ALLTRIM(CsrDeudor.CELULAR)) <> 0
  		lcObserva	= lcObserva + CHR(13) + "CELULAR: " +LTRIM(CsrDeudor.celular)
  	ENDIF 
  	IF LEN(ALLTRIM(CsrDeudor.fax)) <> 0
  		lcObserva	= lcObserva + CHR(13) + "FAX: " +LTRIM(CsrDeudor.fax)
  	ENDIF 
  
  	lcFax		= LTRIM(CsrDeudor.fax)
  	&&Tenemos que agregar el otro telefono a observaciones
  	ldfechac	= ctod(CsrDeudor.fecAlta)
  	lcEmail		= LTRIM(CsrDeudor.email)
  	
  	
  		
	INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
	,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscriiibb,fecinsiibb,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
	,bonif1,email,observa,cdatosfac,dni,cdirecalle,cdirenro,cdirepiso,cdiredpto,refotro);
	VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
	,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
	,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	,lnconvenio,lndctalogistica,lnBonif1,lcEmail,lcObserva,lcDatosFac,lcDNI;
	,lcDire_Calle,lcDire_Nro,lcDire_Piso,lcDire_Dpto,CsrDeudor.Codigo)
	

	SELECT CsrSaldos
	LOCATE FOR VAL(CsrSaldos.Codigo)=VAL(CsrDeudor.codigo)
	IF VAL(CsrSaldos.Codigo)=VAL(CsrDeudor.codigo)
		stop()
		
		lnSaldo = VAL(CsrSaldos.saldo)

		&&Debemos insertar un movimiento de interno para generar saldos
		lnsigno=1
		replace saldoant WITH 0, saldo WITH lnSaldo IN CsrCtacte
		ldfechas=ldfechasis
		lnidcomproba=36
		lcclasecomp="F"
		IF lnSaldo<0
			lnsigno=-1
			lnidcomproba=37
			lcclasecomp="G"
		ENDIF
		lnimporte		= lnSaldo*lnsigno
		lcletra			= "X"
		lcnum			= strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0')
		lcnumero		= lcletra+"0000"+lcnum
		lcswitch		= "00000"
		lnSaldo			= ABS(lnSaldo)
		lcctacte		= CsrCtacte.cnumero
		lnidctacte		= CsrCtacte.id
		ldfechaserver	= DATETIME()
		ldfechasis		= FechaHoraCero(ldfechaserver)
		
		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor;
		,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,detalle;
		,fechaserver);
		VALUES (lnidmaopera,"MOV","IMPORTACIÓN MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,lcswitch,"0";
		,"Importación. Compactación Mov Cliente.",ldfechaserver)
		
		lcswitch		= "00100"
		INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
		,entrega,vencimien,total,detalle,pefiscal,switch,signo);
		VALUES (lnidmovctacte,lnidmaopera,ldfecha-1,lcctacte,lnidctacte," ",0,1,ABS(lnimporte);
		,lnSaldo,0,ldfecha-1,ABS(lnimporte),"Saldo de Importación",SUBSTR(lcfiscal,1,6),lcswitch,lnsigno)
		
		lnidmovctacte=lnidmovctacte+1
		lnidmaopera=lnidmaopera+1
	ENDIF 
	lnid = lnid + 1
	
	SELECT CsrDeudor           
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("No se grabaron algunas clientes, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
ENDIF 


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

SELECT CsrCtacte
*vista()

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

