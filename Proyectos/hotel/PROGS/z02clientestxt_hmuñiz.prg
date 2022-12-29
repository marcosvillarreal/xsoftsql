PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
SET PROCEDURE TO z00_hotel_mu ADDITIVE 

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.

llok = CargarTabla(lcData,'Deudor')
*llok = CargarTabla(lcData,'Deudor',.t.)
*cArchivo = ADDBS(ALLTRIM(lcpath ))+"pax.CSV"
*=LeerClientes(cArchivo)
cArchivo = ADDBS(ALLTRIM(lcpath ))+"empresas.CSV"
=LeerEmpresas(cArchivo)

SELECT CsrDeudor
*CursorAdapterToXML('CsrDeudor',ADDBS(SYS(5)+CURDIR())+"csrdeudor.XML" )	
*=CargarClientes()
*XMLTOCURSOR(ADDBS(SYS(5)+CURDIR())+"csrdeudor.XML" ,"CsrDeudor",512+8192)

SELECT CsrDeudor
*vista()

llok = CargarTabla(lcData,'Ctacte',.t.)
llok = CargarTabla(lcData,'TipoIva')

*llok = CargarTabla(lcData,'CateCtacte',.t.)
*llok = CargarTabla(lcData,'Barrio',.t.)
*llok = CargarTabla(lcData,'PlanCue')
*llok = CargarTabla(lcData,'Sucursal',.t.)
*!*	llok = CargarTabla(lcData,'PadronAfip',.t.)
*llok = CargarTabla(lcData,'CateIBRN',.t.)
*llok = CargarTabla(lcData,'FleteCtacte',.t.)

*!*	TEXT TO lcCmd TEXTMERGE NOSHOW 
*!*	SELECT CsrCateIbrng.* FROM CateIbrng as CsrCateIbrng
*!*	ENDTEXT 
*!*	=CrearCursorAdapter('CsrCateIbrng',lcCmd)


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCanalVta.* FROM CanalVta as CsrCanalVta
ENDTEXT 
=CrearCursorAdapter('CsrCanalVta',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCateCtacte.* FROM CateCtacte as CsrCateCtacte
ENDTEXT 
=CrearCursorAdapter('CsrCateCtacte',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrSexo.* FROM Sexo as CsrSexo
ENDTEXT 
=CrearCursorAdapter('CsrSexo',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrProvincia.* FROM Provincia as CsrProvincia
ENDTEXT 
=CrearCursorAdapter('CsrProvincia',lcCmd)

*!*	TEXT TO lcCmd TEXTMERGE NOSHOW 
*!*	SELECT CsrListaPrecio.* FROM ListaPrecio as CsrListaPrecio
*!*	ENDTEXT 
*!*	=CrearCursorAdapter('CsrListaP',lcCmd)

*!*	TEXT TO lcCmd TEXTMERGE NOSHOW 
*!*	SELECT CsrZona.* FROM Zona as CsrZona
*!*	ENDTEXT 
*!*	=CrearCursorAdapter('CsrZona',lcCmd)

*!*	TEXT TO lcCmd TEXTMERGE NOSHOW 
*!*	SELECT CsrZonaRuta.* ,CsrLocalidad.cpostal FROM ZonaRuta as CsrZonaRuta
*!*	inner join Localidad as CsrLocalidad on CsrZonaRuta.idruta = CsrLocalidad.id
*!*	ENDTEXT 
*!*	=CrearCursorAdapter('CsrZonaRuta',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.*,Provincia.codsicore,Provincia.nombre as provincia FROM Localidad as CsrLocalidad
inner join Provincia on CsrLocalidad.idprovincia = Provincia.id
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)
SELECT CsrLocalidad




oavisar.proceso('N')


SELECT COUNT(*) as clientes,SPACE(6) as nada, codlocalidad,UPPER(localidad) as nombre,codpostal ,codprovincia,CsrProvincia.nombre as provincia;
 ,SPACE(30) AS Localidad, SPACE(6) as CPostal;
,CAST(0 as numeric(10)) as idlocalidad, 'A' as estado;
 FROM CsrDeudor ;
 LEFT JOIN CsrProvincia ON CsrDeudor.codprovincia = CsrProvincia.letracpostal;
 WHERE LEN(RTRIM(localidad))>0;
 ORDER BY CsrDeudor.localidad,CsrProvincia.nombre;
 group by codlocalidad,localidad,codpostal,codprovincia,Csrprovincia.nombre;
 INTO CURSOR CsrCiudad READWRITE 


SELECT CsrCiudad
*vista()
SCAN 
	IF "UELAS"$ALLTRIM(UPPER(CsrCiudad.nombre))
		*vista()
		*stop()
	ENDIF 
	IF VAL(CsrCiudad.CodPostal) = 7513
	*	stop()
	ENDIF 
	lcProvincia = ALLTRIM(UPPER(CsrCiudad.provincia))

	
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrCiudad.nombre)),@lcProvincia)
	lcLocalidadBuscada = QuitarAcentos(lcLocalidadBuscada)
	SELECT CsrLocalidad
	
	LOCATE FOR QuitarAcentos(ALLTRIM(nombre)) = lcLocalidadBuscada &&AND ALLTRIM(provincia) = lcProvincia 
	
	IF CsrLocalidad.id#0
		replace localidad WITH lcLocalidadBuscada,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		IF "CUIDAD DE BUENOS AIRES"$RTRIM(lcLocalidadBuscada)
			SELECT CsrLocalidad
			LOCATE FOR nombre = lcLocalidadBuscada &&AND cpostal = VAL(CsrCiudad.codpostal)
			
			replace cpostal WITH CsrCiudad.codpostal IN CsrCiudad
		ENDIF 
		replace idlocalidad WITH CsrLocalidad.id,provincia WITH CsrLocalidad.provincia in CsrCiudad
	ELSE
		replace estado WITH 'Z' IN CsrCiudad
	ENDIF 
	SELECT CsrCiudad
ENDSCAN

*!*	SELECT CsrCiudad
*!*	SET FILTER TO estado = 'Z'
*!*	IF RECCOUNT('CsrCiudad')#0
*!*		SELECT CsrCiudad
*!*		COPY TO PUTFILE('',ADDBS(SYS(5)+CURDIR())+"LOCALIDADES",'txt')  FOR estado='Z' SDF
*!*	ENDIF 
SET FILTER TO estado = 'A'

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)


SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP

LOCAL nCodigo,cCadeCtacte 
cCadeCtacte = ''
nCodigo = 1
lCancelar = .t.
*stop()
SCAN FOR nCodigo < 10000000 AND lCancelar

*!*		lnCodigo = VAL(CsrDeudor.codigo)
*!*	 	SELECT CsrCtacte
*!*	 	LOCATE FOR VAL(cnumero) = lnCodigo
*!*	 	IF VAL(cnumero) = lnCodigo
*!*	 		cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + ltrim(CsrDeudor.codigo)
*!*	 		SELECT CsrDeudor
*!*	 		LOOP 
*!*	 		
*!*	 	ENDIF 
 	
 	SELECT CsrDeudor 
 	STORE 0 TO lnidestado, 	lnctadeudor ,	lnctaacreedor, 	lnctabanco,	lnctaotro, 	lndctalogistica;
 			,lnidcateibrng ,lncomision ,lnidlocalidad ,lnidprovincia ,lntipoiva ,lnidcategoria;
			,lnidplanpago ,lnidcanalvta ,lnsaldoAuto ,lnlista ,lncomision ,lnconvenio,lndctalogistica;
			,lnbonif1,lcPasaporte,lnFacEmail,nCtaOtro 
	
 	STORE 1100000001 TO lnidbarrio, lnidcategoria, lnlista
 	STORE "" TO lcCuit,lcDNI,lcingbrutos,lcingbrutosBA,lcdatosfac,lcOtro01,lcObserva,lccp ,lcReferencia
 	STORE DATETIME(1900,01,01,0,0,0) TO ldfechac,ldfecultcompra,ldfecultpago,lcfefin
 	
 	*nCodigo		= lnCodigo	
 	lnctadeudor	= 1
 	lnidplanpago	= 1100000001 &&Por el momento todos de efectivo	
	lnidcanalvta	= 1100000001
	*lnlista		= CsrDeudor.codlista
	
*!*		IF lnLista > 2
*!*			SELECT CsrCanalVta
*!*			LOCATE FOR numero = lnLista
*!*			
*!*			lnidcanalvta = CsrCanalVta.id
*!*			lnLista = 0
*!*		ENDIF 
	&&Si el cliente tiene otra lista de precio mayor a 2. Entonces le cambiamos el canal de vta
*!*		SELECT CsrListaP
*!*		LOCATE FOR numero = lnLista
*!*		IF numero <> lnLista
*!*			GO TOP 
*!*			lnLista = CsrListaP.id
*!*		ENDIF 
		
	&&Localidad
	
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.localidad)),@lcProvincia)
	lcLocalidadBuscada = QuitarAcentos(lcLocalidadBuscada)
	SELECT CsrCiudad
	LOCATE FOR QuitarAcentos(ALLTRIM(nombre)) = lcLocalidadBuscada &&AND ALLTRIM(provincia) = lcProvincia 
	IF CsrCiudad.idlocalidad # 0 
		lnidlocalidad	= CsrCiudad.idlocalidad
	ENDIF
	SELECT CsrLocalidad
	LOCATE FOR id = lnidlocalidad
	lnidprovincia	= CsrLocalidad.idprovincia
	lccp 			= CsrLocalidad.cpostal
	
	&&TresPImp	
	cTipoiva	= ALLTRIM(CsrDeudor.tipoiva) &&5 Monotributo
	DO CASE 
	CASE cTipoiva = 'C.F' OR cTipoIVA$'CF'
		lntipoiva = 3		
	CASE cTipoiva = 'EX'
		lntipoiva = 4	
	CASE cTipoIva = 'I'
		lnTipoiva = 1
	OTHERWISE 
		lntipoiva = 5
	ENDCASE 
	
	lcNroDoc		= strtrim(VAL(PeloCuit(CsrDeudor.Documento)),15)
	lcPasaporte	= strtrim(VAL(PeloCuit(CsrDeudor.Cuit)),15)
	IF lntipoiva<>3
		lcCuit			= Cuit(lcPasaporte)
		lcPasaporte		= ''
	ENDIF
	
	SELECT CsrSexo
	LOCATE FOR clase=CsrDeudor.sexo
	lnidsexo = CsrSexo.id
	
	SELECT CsrCateCtacte
	GO TOP 
	lnidcategoria = CsrCateCtacte.id
	
	lcnumero	= strtrim(nCodigo,8)
	
	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrDeudor.apellido))) +", "+NombreNi(ALLTRIM(UPPER(CsrDeudor.nombre))) 
	oavisar.proceso('S',lcNombre)
	oavisar.waitwindow(lcNombre,0)
	
	lcDire_Calle= RTRIM(UPPER(CsrDeudor.direccion))
  	lcDire_Nro	= RTRIM(UPPER(CsrDeudor.direnro))
  	lcDire_Piso	= RTRIM(UPPER(CsrDeudor.direpiso))
  	lcDire_Dpto	= RTRIM(UPPER(CsrDeudor.diredpto))
  	
  	lcDire_Calle	=  STRTRAN(lcDire_Calle,'NULL','')
  	lcDire_Nro	=  STRTRAN(lcDire_Nro,'NULL','')
  	lcDire_Piso	=  STRTRAN(lcDire_Piso,'NULL','')
  	lcDire_Dpto	=  STRTRAN(lcDire_Dpto,'NULL','')
  	
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
  	*lcDireDespacho = ALLTRIM(CsrDeudor.DireDespacho)
  	*lnFacEmail = VAL(CsrDeudor.FacEmail)
	*nFleteImporte = CsrDeudor.flete
	lcocupacion = ALLTRIM(CsrDeudor.ocupacion)
	ldfecnac = stod(CsrDeudor.fecnac)
	lcdni = CsrDeudor.documento
	IF lcOcupacion='EMPRESA'
		nCtaOtro  = 1
	ENDIF 
	SELECT CsrCtacte
	APPEND BLANK
	replace id WITH lnId, cnumero WITH lcNumero, cnombre WITH lcNombre, cdireccion WITH lcDireccion 
	replace cpostal WITH lccp, idlocalidad WITH lnidlocalidad, idprovincia WITH lnIdProvincia
	replace ctelefono WITH lcTelefono, tipoiva WITH lntipoiva, cuit WITH lccuit, idcategoria WITH lnidcategoria
	replace idplanpago WITH lnidplanpago, idcanalvta WITH lnidcanalvta, estadocta WITH lnidestado
	replace ctadeudor WITH 1, inscri01 WITH "", fecins01 WITH lcfefin,fechalta WITH ldfechac
	replace lista WITH lnlista, email WITH lcEmail, observa WITH lcObserva, dni WITH lcdni
	replace referencia WITH lcReferencia, idsexo WITH lnidsexo, Ocupacion WITH lcOcupacion
	replace pasaporte WITH lcPasaporte, fecnac WITH ldfecnac, ctaotro WITH nCtaOtro 
	
*!*		INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
*!*		,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
*!*		,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
*!*		,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
*!*		,bonif1,email,observa,cdatosfac,dni,referencia,bonif1;
*!*		,idsexo,ocupacion,pasaporte,fecnac);
*!*		VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
*!*		,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
*!*		,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
*!*		,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
*!*		,lnconvenio,lndctalogistica,lnBonif1,lcEmail,lcObserva,lcDatosFac,lcDNI,lcReferencia;
*!*		,lnbonif1;
*!*		,lnidsexo,lcocupacion,lcpasaporte,ldfecnac)
	
	
*!*		&&Agregamos el flete por zona del cliente
*!*		SELECT CsrFlete
*!*		LOCATE FOR VAL(codigo) = VAL(CsrDeudor.codigo)
*!*		DO WHILE NOT EOF() AND VAL(codigo) = VAL(CsrDeudor.codigo)
*!*	*!*			SELECT CsrLocalidad
*!*	*!*			LOCATE FOR VAL(cpostal) = VAL(CsrFlete.CodPostal )
*!*	*!*			lnidruta = CsrLocalidad.id
*!*			SELECT CsrZonaRuta
*!*			LOCATE FOR VAL(cpostal) = VAL(CsrFlete.CodPostal )
*!*			IF CsrZonaRuta.idzona # 0 
*!*				SELECT CsrFletectacte
*!*				APPEND BLANK
*!*				replace id WITH lnidflete ,idzona WITH CsrZonaRuta.idzona, idctacte WITH lnid, feccorte WITH GOMONTH(DATE(),12*20),;
*!*						flete WITH CsrFlete.flete
*!*				lnidflete = lnidflete + 1 
*!*			ELSE
*!*				cMensaje = ('Cliente ' + ALLTRIM(CsrDeudor.codigo) + ' Localidad ' + ALLTRIM(CsrFlete.CodPostal) + ' Flete ' + strtrim(CsrFlete.flete,12,2))

*!*				APPEND BLANK IN  CsrFleteError 
*!*				replace detalle WITH cMensaje IN  CsrFleteError 
*!*			ENDIF 
*!*		
*!*			SELECT CsrFlete
*!*			SKIP 
*!*		ENDDO 
	lnid = lnid + 1
	nCodigo = nCodigo + 1 
	
	SELECT CsrDeudor           
ENDSCAN

oavisar.waitwindow('',-1)
SELECT CsrCtacte
vista()




Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')


CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

