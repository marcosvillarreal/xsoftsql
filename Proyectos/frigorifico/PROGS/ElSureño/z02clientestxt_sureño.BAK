PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
SET PROCEDURE TO z00_elsureño ADDITIVE 

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

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCateIbrng.* FROM CateIbrng as CsrCateIbrng
ENDTEXT 
=CrearCursorAdapter('CsrCateIbrng',lcCmd)


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrCanalVta.* FROM CanalVta as CsrCanalVta
ENDTEXT 
=CrearCursorAdapter('CsrCanalVta',lcCmd)

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


SELECT distinct codlocalidad,UPPER(localidad) as nombre,codpostal ,codprovincia,provincia ,SPACE(30) AS Localidad, SPACE(6) as CPostal;
,CAST(0 as numeric(10)) as idlocalidad;
 FROM CsrDeudor  ORDER BY PROVINCIA, NOMBRE INTO CURSOR CsrCiudad READWRITE 


SELECT CsrCiudad
DELETE FROM CsrCiudad WHERE VAL(codpostal)=VAL(cpostal)
*vista()

SCAN 
	IF VAL(CsrCiudad.codpostal)=8138
	*	stop()
	ENDIF 
	
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrCiudad.nombre)))
	
	lnCodProvincia = VAL(CsrCiudad.codprovincia)
	
	lnCodProvincia = IIF(lnCodProvincia =0 ,2,IIF(lnCodProvincia = 2,0,lnCodProvincia ))
	lnCodProvincia = IIF(VAL(CsrCiudad.codprovincia)=19 ,21,lnCodProvincia ) &&la pampa
	lnCodProvincia = IIF(VAL(CsrCiudad.codprovincia)=21 ,20,lnCodProvincia ) &&neruquen
	lnCodProvincia = IIF(VAL(CsrCiudad.codprovincia)=13 ,12,lnCodProvincia ) &&santa fe

	*lnCodProvincia = IIF(lnCodProvincia = 0 ,1,lnCodProvincia )
	SELECT CsrLocalidad
	
	LOCATE FOR ALLTRIM(nombre) = lcLocalidadBuscada AND VAL(codsicore) = lnCodProvincia
	IF VAL(CsrCiudad.codpostal)=8138
		*vista()
	ENDIF 
	
	IF id#0
		replace localidad WITH lcLocalidadBuscada,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		IF "CUIDAD DE BUENOS AIRES"$RTRIM(lcLocalidadBuscada)
			SELECT CsrLocalidad
			LOCATE FOR nombre = lcLocalidadBuscada AND cpostal = VAL(CsrCiudad.codpostal)
			
			replace cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		ENDIF 
		replace idlocalidad WITH CsrLocalidad.id in CsrCiudad
	ELSE
		LOCATE FOR VAL(cpostal) = VAL(CsrCiudad.codpostal)
		IF id#0
		*	replace localidad WITH CsrLocalidad.nombre,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
		ENDIF 
	ENDIF 
	SELECT CsrCiudad
ENDSCAN

SELECT CsrCateIBRng
LOCATE FOR numero = 2

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

SELECT distinct UPPER(lista) as nombre,codlista FROM CsrDeudor INTO CURSOR CsrListaPrecio
SELECT CsrListaPrecio
*vista()

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
*VISTA()

LOCAL nCodigo,cCadeCtacte 
cCadeCtacte = ''
*nCodigo = 1
*stop()
SCAN 

	lnCodigo = CsrDeudor.idorigen
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
 	
 	nCodigo			= lnCodigo	
 	lcReferencia	= ALLTRIM(CsrDeudor.codigo)
 	lnctadeudor		= 1
 	lnidplanpago	= 1100000002 &&Por el momento todos de cuenta corriente	
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
	SELECT CsrCiudad
	LOCATE FOR VAL(CodLocalidad) = VAL(CsrDeudor.codlocalidad)
	lnidlocalidad	= CsrCiudad.idlocalidad
	
	*lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)))
	SELECT CsrLocalidad
	*GO TOP 
	LOCATE FOR id = lnidlocalidad
	IF id = lnidlocalidad
		lnidprovincia	= CsrLocalidad.idprovincia
		lccp 			= CsrLocalidad.cpostal
		lnidlocalidad	= CsrLocalidad.id
	ENDIF
	
	
	&&TresPImp	
	nTipoiva	= CsrDeudor.Codcateiva &&5 Monotributo
	DO CASE 
	CASE nTipoiva = 6 &&CF
		lntipoiva = 3		
	CASE nTipoiva = 11 &&EX sin impuestos?
		lntipoiva = 4	
	CASE nTipoIva = 1 &&RI
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
	
	IF nCodigo = 19
		stop()
	ENDIF 
	
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
  	
  	IF lnTipoIva <> 3 &&Sin no es CF y de RN le adjuntamos la percepcion
		IF lnidprovincia = 1100000022
			lnidcateibrng = CsrCateIBRNg.id		
			lnporperce = CsrCateIbRNg.porperce
			lnporrete = CsrCateIbRNg.porrete
		ENDIF 
	ENDIF 
	
	INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
	,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
	,bonif1,email,observa,cdatosfac,dni,referencia,bonif1);
	VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
	,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
	,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	,lnconvenio,lndctalogistica,lnBonif1,lcEmail,lcObserva,lcDatosFac,lcDNI,lcReferencia;
	,lnbonif1)
	
	IF lnidcateibrng#0
		INSERT INTO CsrCateIbrn(idctacte, cuit, porperce,porrete);
		VALUES (lnid, lccuit,lnporperce,lnporrete)
	ENDIF 
	
	
	lnid = lnid + 1
	*nCodigo = nCodigo + 1 
	
	SELECT CsrDeudor           
ENDSCAN

SELECT MAX(CAST(cnumero as i)) as codigo FROM CsrCtacte INTO CURSOR CsrMaxNumero READWRITE 

INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
	,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
	,bonif1,email,observa,cdatosfac,dni,referencia);
	VALUES (lnid, strtrim(CsrMaxNumero.codigo+1,8),'EL SUREÑO','','';
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
vista()

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

