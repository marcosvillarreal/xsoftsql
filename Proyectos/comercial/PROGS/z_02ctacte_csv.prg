PARAMETERS ldvacio,lcpath,lcBase,lnlimite

LOCAL lcbdd,lcfecha,lnid
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcbdd = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
SET PROCEDURE TO z00_delpuerto ADDITIVE 

SET SAFETY OFF

Oavisar.proceso('S','Vaciando archivos') 
SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Vaciando archivos') 
llok = .t.
llok = CargarTabla(lcbdd,'Localidad')
llok = CargarTabla(lcbdd,'Ctacte',.t.)
llok = CargarTabla(lcbdd,'Provincia')
llok = CargarTabla(lcbdd,'TipoIva')
llok = CargarTabla(lcbdd,'PlanCue')
llok = CargarTabla(lcbdd,'PlanPago')
llok = CargarTabla(lcbdd,'TipoDoc')

=InitCursores()

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
Oavisar.proceso('S','Abriendo archivos') 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM CateCtacte as CsrCateCtacte 
ENDTEXT 
=CrearCursorAdapter('CsrCateCtacte',lcCmd)

SELECT CsrCateCtacte
GO TOP 
LOCATE FOR RIGHT(LEFT(switch,2),1)='1'
lnidctaacreedor = CsrCateCtacte.id
GO TOP 
lnidctadeudor = CsrCateCtacte.id


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.*,Provincia.nombre as provincia FROM Localidad as CsrLocalidad
inner join Provincia on CsrLocalidad.idprovincia = Provincia.id
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)
SELECT CsrLocalidad

cArchivo = ADDBS(ALLTRIM(lcpath ))+"clientes.csv"
=LeerClientes(cArchivo,7)
replace ALL ctadeudor  WITH 1 IN CsrDeudor
SELECT CsrDeudor
cArchivo = ADDBS(ALLTRIM(lcpath ))+"proveedores.csv"
=LeerClientes(cArchivo,8)
SELECT CsrDeudor
vista()

*!*	SELECT distinct codlocalidad,CAST(0 as numeric(10)) as idlocalidad,UPPER(localidad) as nombre,codpostal ,codprovincia,provincia ,SPACE(30) AS Localidad, SPACE(6) as CPostal;
*!*	 FROM CsrDeudor  ORDER BY PROVINCIA, NOMBRE INTO CURSOR CsrCiudad READWRITE 


*!*	SELECT CsrCiudad
*!*	*DELETE FROM CsrCiudad WHERE VAL(codpostal)=VAL(cpostal)
*!*	*vista()

*!*	*stop()
*!*	SCAN 
*!*		IF VAL(CsrCiudad.codpostal)=8138
*!*		*	stop()
*!*		ENDIF 
*!*		
*!*		lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrCiudad.nombre)))
*!*		
*!*		lnCodProvincia = VAL(CsrCiudad.codprovincia)
*!*		
*!*		lnCodProvincia = IIF(lnCodProvincia =0 ,1,IIF(lnCodProvincia = 1,0,lnCodProvincia ))
*!*	*!*		lnCodProvincia = IIF(VAL(CsrCiudad.codprovincia)=19 ,21,lnCodProvincia ) &&la pampa
*!*	*!*		lnCodProvincia = IIF(VAL(CsrCiudad.codprovincia)=21 ,20,lnCodProvincia ) &&neruquen
*!*	*!*		lnCodProvincia = IIF(VAL(CsrCiudad.codprovincia)=13 ,12,lnCodProvincia ) &&santa fe

*!*		*lnCodProvincia = IIF(lnCodProvincia = 0 ,1,lnCodProvincia )
*!*		SELECT CsrLocalidad
*!*		
*!*		LOCATE FOR ALLTRIM(nombre) = lcLocalidadBuscada AND VAL(codsicore) = lnCodProvincia
*!*		IF VAL(CsrCiudad.codpostal)=8138
*!*			*vista()
*!*		ENDIF 
*!*		
*!*		IF id#0
*!*			replace localidad WITH lcLocalidadBuscada,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
*!*			IF "CUIDAD DE BUENOS AIRES"$RTRIM(lcLocalidadBuscada)
*!*				SELECT CsrLocalidad
*!*				LOCATE FOR nombre = lcLocalidadBuscada AND cpostal = VAL(CsrCiudad.codpostal)
*!*				
*!*				replace cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
*!*			ENDIF 
*!*			replace idlocalidad WITH CsrLocalidad.id in CsrCiudad
*!*		ELSE
*!*			LOCATE FOR VAL(cpostal) = 7500 &&TresArroyos
*!*			IF id#0
*!*				*replace localidad WITH CsrLocalidad.nombre,cpostal WITH CsrLocalidad.cpostal IN CsrCiudad
*!*				replace idlocalidad WITH CsrLocalidad.id in CsrCiudad
*!*			ENDIF 
*!*		ENDIF 
*!*		SELECT CsrCiudad
*!*	ENDSCAN

lnid			= RecuperarID('CsrCtacte',Goapp.sucursal10)

LOCAL lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia;
,lnctabanco,lnctaotro,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2;
,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc,lnlista,lndiasvto;
,lnexistegan 

SELECT CsrDeudor
Oavisar.proceso('S','Procesando clientes') 
nNumeroCtacte = 0	
GO  TOP 
SCAN 
	STORE 0 TO lnidlocalidad,lnidprovincia,lntipoiva,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
	,lnctabanco,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
    	,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
   	 ,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif,lnidcategoria;
    	,lndiasvto,lnplanpago
    
   	STORE "" TO lccnumero,lccnombre,lccdireccion,lccpostal,lcctelefono2,lcctelefono,lcemail,lccuit;
    	,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc
    
*!*	     	IF recno('FsrDeudor')/500=INT(RECNO('FsrDeudor')/500)
*!*		   lcTitulo = "Clientes "+STR(RECNO(),10)   
*!*		   Oavisar.proceso('S',lcTitulo,.t.,recno())
*!*		 ENDIF
    
    	STORE 1 TO 	lnlista, lnidcanalvta
    	&&lcEmail			= FsrDeudor.cliente
    	nNumeroCtacte	= nNumeroCtacte + 1 
	lnestadocta		= 0
	lccnumero		= ALLTRIM(STR(nNumeroCtacte))
	lccnombre		= ALLTRIM(CsrDeudor.nombre)
	lccdireccion	= ALLTRIM(CsrDeudor.direccion)
	lcctelefono		= ALLTRIM(CsrDeudor.telefono)
	ldfechalta		= DATETIME(1900,01,01,0,0,0)
	*lcobserva		= FsrDeudor.observa
	lccuit 		=cuit(PeloCuit(CsrDeudor.documento))
	ldfecins01		= DATETIME(1900,01,01,0,0,0)
	ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
	ldfecultpago	= DATETIME(1900,01,01,0,0,0)
	*lnbonif1		= FsrDeudor.bonif1
	*lntipoiva 		= FsrDeudor.tipocuit &&VAL(FsrDeudor.categiva)
	lcLocalidadBuscada = Ciudades(CsrDeudor.Localidad)
	lccp = ""
	lnidtablaint	= 0 &&Por defecto es el interes de socio
	&&Buscamos si existen los tipo de documento valido
	
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccpostal = CsrLocalidad.cpostal
	ENDIF
	lnctadeudor = CsrDeudor.ctadeudor  	
	lnidcategoria = lnidctadeudor
	IF lnctadeudor = 0
		lnctaacreedor = 1
		lnidcategoria = lnidctaacreedor
	ENDIF 
*!*		IF lntipoiva=7
*!*			lntipoiva = 5
*!*		ENDIF 
*!*		IF lntipoiva=3
*!*			lncuit=''
*!*		ENDIF

	cBuscar = 'CCT'
	
	SELECT CsrPlanPago
	LOCATE FOR numero=cBuscar
	lnidplanpago	= CsrPlanPago.id
	
	lccnombre = NombreNi(ALLTRIM(UPPER(lccnombre)))
	lccdireccion = NombreNi(ALLTRIM(UPPER(lccdireccion)))
      
	INSERT INTO Csrctacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono2;
	,ctelefono,email,tipoiva,cuit,idcategoria,ctadeudor,ctaacreedor,ctalogistica,ctabanco,ctaotro;
	,ctaorden,idplanpago,idcanalvta,fechalta,observa,saldo,saldoant,estadocta,bonif1,bonif2,copiatkt;
	,inscri01,fecins01,inscri02,inscri03,convenio,saldoauto,idbarrio,lista,idcateibrng,ingbrutos;
	,comision,fecultcompra,fecultpago,numdoc,idtipodoc,existeibto,existegan,diasvto,idtablaint,esrecodevol;
	,totalizabonif,codigo);
    VALUES(lnid,lccnumero,lccnombre,lccdireccion,lccpostal,lnidlocalidad,lnidprovincia,lcctelefono2;
    ,lcctelefono,lcemail,lntipoiva,lccuit,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica,lnctabanco;
    ,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,ldfechalta,lcobserva,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lcinscri01,ldfecins01,lcinscri02,lcinscri03,lnconvenio,lnsaldoauto;
    ,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,lcnumdoc,lnidtipodoc;
    ,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif,VAL(lccnumero))
    
	lnid = lnid + 1
	

	SELECT CsrDeudor
ENDSCAN



Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
USE in CsrDeudor
*!*	USE in FsrProveedor 
*!*	USE IN FsrMovDeudor
*!*	USE IN FsrMovAcreedor


CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

