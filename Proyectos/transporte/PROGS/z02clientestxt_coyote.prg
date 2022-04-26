PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
SET PROCEDURE TO z00_elcoyote ADDITIVE 

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Ctacte',.t.)
llok = CargarTabla(lcData,'TipoIva')
*llok = CargarTabla(lcData,'CateCtacte',.t.)
llok = CargarTabla(lcData,'Barrio',.t.)
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Sucursal',.t.)
*!*	llok = CargarTabla(lcData,'PadronAfip',.t.)
llok = CargarTabla(lcData,'CateIBRN',.t.)
llok = CargarTabla(lcData,'FleteCtacte',.t.)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCateIbrng.* FROM CateIbrng as CsrCateIbrng
ENDTEXT 
=CrearCursorAdapter('CsrCateIbrng',lcCmd)


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCanalVta.* FROM CanalVta as CsrCanalVta
ENDTEXT 
=CrearCursorAdapter('CsrCanalVta',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCateCtacte.* FROM CateCtacte as CsrCateCtacte
ENDTEXT 
=CrearCursorAdapter('CsrCateCtacte',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrListaPrecio.* FROM ListaPrecio as CsrListaPrecio
ENDTEXT 
=CrearCursorAdapter('CsrListaP',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrZona.* FROM Zona as CsrZona
ENDTEXT 
=CrearCursorAdapter('CsrZona',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrZonaRuta.* ,CsrLocalidad.cpostal FROM ZonaRuta as CsrZonaRuta
inner join Localidad as CsrLocalidad on CsrZonaRuta.idruta = CsrLocalidad.id
ENDTEXT 
=CrearCursorAdapter('CsrZonaRuta',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.*,Provincia.codsicore,Provincia.nombre as provincia FROM Localidad as CsrLocalidad
inner join Provincia on CsrLocalidad.idprovincia = Provincia.id
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)
SELECT CsrLocalidad

cArchivo = ADDBS(ALLTRIM(lcpath ))+"LISCLI03.CSV"
=LeerClientes(cArchivo)

cArchivo = ADDBS(ALLTRIM(lcpath ))+"LISPCL.CSV"
=LeerFletes(cArchivo)

SELECT CsrFlete
replace ALL CodPostal WITH '8503' FOR VAL(CodPostal)=7101
*vista()
*DELETE FROM CsrDeudor WHERE VAL(estado) = 0 &&No importamos los inactivos


SELECT distinct codlocalidad,UPPER(localidad) as nombre,codpostal ,codprovincia,provincia ,SPACE(30) AS Localidad, SPACE(6) as CPostal;
,CAST(0 as numeric(10)) as idlocalidad, 0 as estado;
 FROM CsrDeudor  ;
 ORDER BY PROVINCIA, NOMBRE INTO CURSOR CsrCiudad READWRITE 


SELECT CsrCiudad
*vista()
SCAN 
	IF ALLTRIM(UPPER(CsrCiudad.nombre)) ="GRAL CONESA"
		stop()
	ENDIF 
	lcProvincia = ALLTRIM(UPPER(CsrCiudad.provincia))

	
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrCiudad.nombre)),@lcProvincia)
	
	SELECT CsrLocalidad
	
	LOCATE FOR ALLTRIM(nombre) = lcLocalidadBuscada AND ALLTRIM(provincia) = lcProvincia 
	
	IF CsrLocalidad.id#0
		replace localidad WITH lcLocalidadBuscada,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		IF "CAPITAL FEDERAL"$RTRIM(lcLocalidadBuscada)
			SELECT CsrLocalidad
			LOCATE FOR nombre = lcLocalidadBuscada AND cpostal = VAL(CsrCiudad.codpostal)
			
			replace cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		ENDIF 
		replace idlocalidad WITH CsrLocalidad.id in CsrCiudad
	ELSE
		replace estado WITH 1 IN CsrCiudad
	ENDIF 
	SELECT CsrCiudad
ENDSCAN

SELECT CsrCiudad
SET FILTER TO estado = 1
IF RECCOUNT('CsrCiudad')#0
	vista()
ENDIF 

SET FILTER TO

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

lnidflete = RecuperarID('CsrFleteCtacte',Goapp.sucursal10)

CREATE CURSOR CsrFleteError (detalle c(250))

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
*VISTA()


LOCAL nCodigo,cCadeCtacte 
cCadeCtacte = ''
*nCodigo = 1
stop()
SCAN 

	lnCodigo = VAL(CsrDeudor.codigo)
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
 	STORE "" TO lcCuit,lcDNI,lcingbrutos,lcingbrutosBA,lcdatosfac,lcOtro01,lcObserva,lccp ,lcReferencia
 	STORE DATETIME(1900,01,01,0,0,0) TO ldfechac,ldfecultcompra,ldfecultpago,lcfefin
 	IF lnCodigo = 128
 	*	stop()
 	ENDIF 	
 	nCodigo			= lnCodigo	
 	*lcReferencia	= ALLTRIM(CsrDeudor.codigo)
 	lnctadeudor		= 1
 	lnidplanpago	= 1100000001 &&Por el momento todos de efectivo	
 	*lnidplanpago	= IIF(CsrDeudor.PlanPago<>1,1100000001,1100000002)	
	lnidcanalvta	= 1100000001
	lnlista			= CsrDeudor.codlista
	
	IF lnLista > 2
		SELECT CsrCanalVta
		LOCATE FOR numero = lnLista
		
		lnidcanalvta = CsrCanalVta.id
		lnLista = 0
	ENDIF 
	&&Si el cliente tiene otra lista de precio mayor a 2. Entonces le cambiamos el canal de vta
	SELECT CsrListaP
	LOCATE FOR numero = lnLista
	IF numero <> lnLista
		GO TOP 
		lnLista = CsrListaP.id
	ENDIF 
		
	&&Localidad
	
	lcProvincia = ALLTRIM(UPPER(CsrDeudor.provincia))	
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)),@lcProvincia)
	
	SELECT CsrCiudad
	LOCATE FOR ALLTRIM(nombre) = alltrim(CsrDeudor.localidad) AND ALLTRIM(provincia) = ALLTRIM(CsrDeudor.provincia)
	IF CsrCiudad.idlocalidad # 0 
		lnidlocalidad	= CsrCiudad.idlocalidad
	ENDIF
	SELECT CsrLocalidad
	LOCATE FOR id = lnidlocalidad
	lnidprovincia	= CsrLocalidad.idprovincia
	lccp 			= CsrLocalidad.cpostal
	
	&&TresPImp	
	cTipoiva	= ALLTRIM(CsrDeudor.Codcateiva) &&5 Monotributo
	DO CASE 
	CASE cTipoiva = 'C.F' OR cTipoIVA$'CF'
		lntipoiva = 3		
	CASE cTipoiva = 'EXE'
		lntipoiva = 4	
	CASE cTipoIva = 'RI'
		lnTipoiva = 1
	OTHERWISE 
		lntipoiva = 5
	ENDCASE 
	
	lcNroDoc		= strtrim(VAL(PeloCuit(CsrDeudor.Documento)),15)
	IF lntipoiva<>3
		lcCuit			= Cuit(lcNroDoc)
		lcNroDoc		= ''
	ENDIF
	
	SELECT CsrCateCtacte
	GO TOP 
	IF ALLTRIM(UPPER(CsrDeudor.tipofac))$'S/F'
		LOCATE FOR LEFT(switch,1)='1'		
	ENDIF
	IF  lntipoiva = 3 &&CF
		LOCATE FOR LEFT(switch,1)='1'		
	ENDIF 
	lnidcategoria = CsrCateCtacte.id
	
	lcnumero	= strtrim(nCodigo,8)
	
	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrDeudor.nombre))) 
	
	lcDire_Calle= RTRIM(UPPER(CsrDeudor.direccion))
  	lcDire_Nro	= RTRIM(UPPER(CsrDeudor.direnro))
  	lcDire_Piso	= RTRIM(UPPER(CsrDeudor.direpiso))
  	lcDire_Dpto	= RTRIM(UPPER(CsrDeudor.diredpto))
  	
  	cDireNro	= IIF(ALLTRIM(lcDire_Nro)='0' or LEN(lcDire_Nro)=0,'',lcDire_Nro)
  	cDirePiso	= IIF(LEN(LcDire_Piso)=0,"","P:"+lcDire_Piso)
	cDireDpto	= IIF(LEN(LcDire_Dpto)=0,"","D:"+lcDire_Dpto)
	
  	lcDireccion = ALLTRIM(ALLTRIM(lcDire_Calle) + " " + cDireNro + " "+ cDirePiso + " "+cDireDpto)
 	
  	*lcDireccion = RTRIM(UPPER(CsrDeudor.direccion)) + ' ' + ALLTRIM(CsrDeudor.direnro) + ' ' + ALLTRIM(CsrDeudor.direpiso) + ' ' + ALLTRIM(CsrDeudor.diredpto)
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
  	lcDireDespacho = ALLTRIM(CsrDeudor.DireDespacho)
  	lnFacEmail = VAL(CsrDeudor.FacEmail)
	nFleteImporte = CsrDeudor.flete
	
	INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
	,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
	,bonif1,email,observa,cdatosfac,dni,referencia,bonif1,facemail,cdiredespacho,flete);
	VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
	,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
	,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	,lnconvenio,lndctalogistica,lnBonif1,lcEmail,lcObserva,lcDatosFac,lcDNI,lcReferencia;
	,lnbonif1,lnFacEmail,lcDireDespacho,nFleteImporte)
	
	
	&&Agregamos el flete por zona del cliente
	SELECT CsrFlete
	LOCATE FOR VAL(codigo) = VAL(CsrDeudor.codigo)
	DO WHILE NOT EOF() AND VAL(codigo) = VAL(CsrDeudor.codigo)
*!*			SELECT CsrLocalidad
*!*			LOCATE FOR VAL(cpostal) = VAL(CsrFlete.CodPostal )
*!*			lnidruta = CsrLocalidad.id
		SELECT CsrZonaRuta
		LOCATE FOR VAL(cpostal) = VAL(CsrFlete.CodPostal )
		IF CsrZonaRuta.idzona # 0 
			SELECT CsrFletectacte
			APPEND BLANK
			replace id WITH lnidflete ,idzona WITH CsrZonaRuta.idzona, idctacte WITH lnid, feccorte WITH GOMONTH(DATE(),12*20),;
					flete WITH CsrFlete.flete
			lnidflete = lnidflete + 1 
		ELSE
			cMensaje = ('Cliente ' + ALLTRIM(CsrDeudor.codigo) + ' Localidad ' + ALLTRIM(CsrFlete.CodPostal) + ' Flete ' + strtrim(CsrFlete.flete,12,2))

			APPEND BLANK IN  CsrFleteError 
			replace detalle WITH cMensaje IN  CsrFleteError 
		ENDIF 
	
		SELECT CsrFlete
		SKIP 
	ENDDO 
	lnid = lnid + 1
	*nCodigo = nCodigo + 1 
	
	SELECT CsrDeudor           
ENDSCAN

*!*	SELECT MAX(CAST(cnumero as i)) as codigo FROM CsrCtacte INTO CURSOR CsrMaxNumero READWRITE 

*!*	INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
*!*		,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
*!*		,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
*!*		,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
*!*		,bonif1,email,observa,cdatosfac,dni,referencia);
*!*		VALUES (lnid, strtrim(CsrMaxNumero.codigo+1,8),'EL SUREÑO','','';
*!*		,0,0,'',1,'',0,0,0;
*!*		,0,1100000003,0,0,1,0,0,"",lcfefin,'';
*!*		,"",0,ldfechac,0,0,0,'',0,ldfecultcompra,ldfecultpago;
*!*		,0,0,0,'','','','','';
*!*		)
*!*		

*!*	IF LEN(LTRIM(cCadeCtacte)) != 0
*!*		=oavisar.usuario("No se grabaron algunas clientes, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
*!*	ENDIF 


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

SELECT CsrFleteError 
vista()
SELECT CsrFleteCtacte
vista()

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

