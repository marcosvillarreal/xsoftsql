PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
SET PROCEDURE TO z00_elsure�o ADDITIVE 

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


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrListaPrecio.* FROM ListaPrecio as CsrListaPrecio
ENDTEXT 
=CrearCursorAdapter('CsrListaP',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.*,Provincia.codsicore FROM Localidad as CsrLocalidad
inner join Provincia on CsrLocalidad.idprovincia = Provincia.id
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)
SELECT CsrLocalidad

cArchivo = ADDBS(ALLTRIM(lcpath ))+"clientes.csv"
=LeerClientes(cArchivo)

SELECT CsrDeudor
*vista()
DELETE FROM CsrDeudor WHERE VAL(estado) = 0 &&No importamos los inactivos


SELECT distinct idlocalidad,UPPER(localidad) as nombre,codpostal ,codprovincia,provincia ,SPACE(30) AS Localidad, SPACE(6) as CPostal;
 FROM CsrDeudor  ORDER BY PROVINCIA, NOMBRE INTO CURSOR CsrCiudad READWRITE 


SELECT CsrCiudad
DELETE FROM CsrCiudad WHERE VAL(codpostal)=VAL(cpostal)
vista()

SCAN 
	IF VAL(CsrCiudad.codpostal)=8512
		stop()
	ENDIF 
	
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrCiudad.nombre)))
	
	lnCodProvincia = VAL(CsrCiudad.codprovincia)
	
	lnCodProvincia = IIF(lnCodProvincia =0 ,2,IIF(lnCodProvincia = 2,0,lnCodProvincia ))
	*lnCodProvincia = IIF(lnCodProvincia = 0 ,1,lnCodProvincia )
	SELECT CsrLocalidad
	
	LOCATE FOR nombre = lcLocalidadBuscada AND VAL(codsicore) = lnCodProvincia
	
	IF id#0
		replace localidad WITH lcLocalidadBuscada,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		IF "CUIDAD DE BUENOS AIRES"$RTRIM(lcLocalidadBuscada)
			SELECT CsrLocalidad
			LOCATE FOR nombre = lcLocalidadBuscada AND cpostal = VAL(CsrCiudad.codpostal)
			
			replace cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		ENDIF 
	ELSE
		LOCATE FOR VAL(cpostal) = VAL(CsrCiudad.codpostal)
		IF id#0
		*	replace localidad WITH CsrLocalidad.nombre,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		ENDIF 
	ENDIF 
	SELECT CsrCiudad
ENDSCAN


SELECT CsrCiudad
DELETE FROM CsrCiudad WHERE VAL(codpostal)=VAL(cpostal)
vista()

CURSORAdapterTOXML('CsrCiudad',ADDBS(SYS(5)+CURDIR())+'Ciudades.XML')

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

SELECT distinct UPPER(lista) as nombre FROM CsrDeudor INTO CURSOR CsrListaPrecio
SELECT CsrListaPrecio

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
*VISTA()

LOCAL nCodigo

nCodigo = 1
*stop()
SCAN 
	
	IF VAL(codigo)=9007
		*stop()
	ENDIF 
	
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
 		
 	lcReferencia	= ALLTRIM(CsrDeudor.codigo)
 	lnctadeudor		= 1
 	lnidplanpago	= 1100000002 &&Por el momento todos de cuenta corriente	
 	*lnidplanpago	= IIF(CsrDeudor.PlanPago<>1,1100000001,1100000002)	
	lnidcanalvta	= IIF(LEFT(lcReferencia,1)='L',1100000003,1100000001)
	lnidlista		= 0
	lnlista			= 1 &&IIF(LEFT(lcReferencia,1)='L',2,1)
*!*		DO CASE
*!*		CASE lnLista <= 1
*!*			lnLista = 1
*!*		OTHERWISE
*!*			&&Falta el resto de listas que nose cuales seran las por defecto
*!*			lnLista = lnLista + 3
*!*		ENDCASE
	SELECT CsrListaP
	LOCATE FOR numero = lnLista
	IF numero <> lnLista
		lnlista = 0
	ENDIF 
		
	
	IF ALLTRIM(UPPER(CsrDeudor.cODpOSTAL)) = '6301' AND nCodigo = 17
		*stop()
	ENDIF 
	&&Localidad
	lnidlocalidad	= 1100000345  &&Bahia Blanca
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)))
	SELECT CsrLocalidad
	*GO TOP 
	LOCATE FOR ALLTRIM(nombre) = lcLocalidadBuscada
	IF ALLTRIM(nombre) = lcLocalidadBuscada
		lnidprovincia	= CsrLocalidad.idprovincia
		lccp 			= CsrLocalidad.cpostal
		lnidlocalidad	= CsrLocalidad.id
	ELSE
		lnidestado = 1
		IF LEN(LTRIM(CsrDeudor.codpostal))<>0
			lcReferencia = lcReferencia + "  {"+CsrDeudor.codpostal+"} ["+lcLocalidadBuscada+"]"
		ENDIF 
	ENDIF
	
	&&TresPImp	
	nTipoiva	= CsrDeudor.Codcateiva
	DO CASE 
	CASE nTipoiva = 1 &&CF
		lntipoiva = 3	
	CASE nTipoiva = 3 &&RNI
		lntipoiva = 7	
	CASE nTipoiva = 4 &&EX sin impuestos?
		lntipoiva = 4	
	CASE nTipoIva = 2 &&RI
		lnTipoiva = 1
	OTHERWISE 
		lntipoiva = CsrDeudor.Codcateiva
	ENDCASE 
	lcNroDoc		= strtrim(VAL(PeloCuit(CsrDeudor.Documento)),15)
	IF lntipoiva<>3
		*IF ALLTRIM(CsrDeudor.tipodoc)$'CUIT'
			lcCuit			= Cuit(lcNroDoc)
			lcNroDoc		= ''
		*ENDIF 
	ENDIF
	
	lcnumero	= strtrim(nCodigo,8)
	
	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrDeudor.nombre)))  	
  	lcDireccion = RTRIM(UPPER(CsrDeudor.direccion))
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
	,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
	,bonif1,email,observa,cdatosfac,dni,referencia);
	VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
	,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
	,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	,lnconvenio,lndctalogistica,lnBonif1,lcEmail,lcObserva,lcDatosFac,lcDNI,lcReferencia;
	)
	
	lnid = lnid + 1
	nCodigo = nCodigo + 1 
	
	SELECT CsrDeudor           
ENDSCAN

INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
	,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
	,bonif1,email,observa,cdatosfac,dni,referencia);
	VALUES (lnid, strtrim(nCodigo,8),'EL SURE�O','','';
	,0,0,'',1,'',0,0,0;
	,0,1100000003,0,0,1,0,0,"",lcfefin,'';
	,"",0,ldfechac,0,0,0,'',0,ldfecultcompra,ldfecultpago;
	,0,0,0,'','','','','';
	)
	

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

