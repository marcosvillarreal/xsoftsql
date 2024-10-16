PARAMETERS ldvacio,lcpath,lcBase
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
SELECT CsrLocalidad.* FROM Localidad as CsrLocalidad
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)
SELECT CsrLocalidad
*vista()

SET SAFETY ON
CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrDeudor (Codigo c(8),Categoria c(20),Nombre c(70),Direccion c(100),Localidad c(50),CodPostal c(10),Provincia c(50);
		,Telefono c(20),Telefono2 c(20),Fax c(20),Celular c(20),Email c(50),fecAlta c(15),TipoDoc c(50),Documento c(20);
		,TipoIVA c(50),Vendedor c(30),Zona c(3),obsercli c(100),ctadeudor n(1),IngBrutos c(20);
		,DireNro c(5),DirePiso c(5),DireDpto c(5),Lista c(30),CodLista n(2),Estado c(1);
		,CodCateIVA n(2),CodGan n(3),PlanPago n(1),DiasVto n(3),Ganancia n(1))



		
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
cArchivo = ADDBS(ALLTRIM(lcpath ))+"clients.txt"
APPEND FROM  &cArchivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

Oavisar.proceso('S','Procesando '+alias()) 

cCadeCtacte = "" 


SELECT CsrLista
GO TOP 
vista()
lnPrimeraOcurrencia = 13
leiunarticulo = .f.

ldebug = .t.

*SKIP 
*stop()
DO WHILE NOT EOF()
	lnCantCampo = 12 &&Hay un campo vacio
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
		STORE "" TO lcTipoIVA,lcVendedor,lcZona,lcCodVendedor,lcDireNro,lcDirePiso,lcDireDpto,lcLista
		STORE "" TO lcEstado,lcCodLista,lcCodCateIVA
		
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
			lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=1,lcCadena,lcCodigo)))
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcNombre)))
			lcDocumento		= UPPER(LimpiarCadena(IIF(j + i=8,lcCadena,lcDocumento)))
			lcDireccion		= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcDireccion)))
			lcCodPostal		= UPPER(LimpiarCadena(IIF(j + i=5,lcCadena,lcCodPostal)))
			*lcDirePiso		= UPPER(LimpiarCadena(IIF(j + i=8,lcCadena,lcDirePiso)))
			*lcDireDpto		= UPPER(LimpiarCadena(IIF(j + i=10,lcCadena,lcDireDpto)))
			LcLocalidad		= UPPER(LimpiarCadena(IIF(j + i=6,lcCadena,lcLocalidad)))
			lcProvincia		= UPPER(LimpiarCadena(IIF(j + i=10,lcCadena,lcProvincia)))
			lcTelefono		= UPPER(LimpiarCadena(IIF(j + i=4,lcCadena,lcTelefono)))
			lcCodCateIVA	= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcCodCateIVA)))
			*lcTipoIVA		= UPPER(LimpiarCadena(IIF(j + i=15,lcCadena,lcTipoIVA)))
			*lcCategoria	= UPPER(LimpiarCadena(IIF(j + i=14,lcCadena,lcCategoria)))
			*lcTelefono2		= UPPER(LimpiarCadena(IIF(j + i=16,lcCadena,lcTelefono2)))
			*lcEstado		= UPPER(LimpiarCadena(IIF(j + i=17,lcCadena,lcEstado)))
			*lcCodLista			= UPPER(LimpiarCadena(IIF(j + i=18,lcCadena,lcCodLista)))
			*lcLista			= UPPER(LimpiarCadena(IIF(j + i=19,lcCadena,lcLista)))
			lcZona			= UPPER(LimpiarCadena(IIF(j + i=11,lcCadena,lcZona)))
			*lcCodVendedor	= UPPER(LimpiarCadena(IIF(j + i=9,lcCadena,lcCodVendedor)))
			lcVendedor		= UPPER(LimpiarCadena(IIF(j + i=9,lcCadena,lcVendedor)))
			
			*lcCodPostal		= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcCodPostal)))
			*lcFax			= UPPER(LimpiarCadena(IIF(j + i=12,lcCadena,lcFax)))
			*lcCelular		= UPPER(LimpiarCadena(IIF(j + i=13,lcCadena,lcCelular)))
			*lcEmail			= UPPER(LimpiarCadena(IIF(j + i=14,lcCadena,lcEmail)))
			*lcfecAlta		= IIF(j + i=19,lcCadena,lcFecAlta)
			lcTipoDoc		= 'CUIT'&&UPPER(LimpiarCadena(IIF(j + i=22,lcCadena,lcTipoDoc)))
			*lcZona			= UPPER(LimpiarCadena(IIF(j + i=29,lcCadena,lcZona)))
							
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
			
			IF VAL(lcCodigo)=1772 and ldebug
				*stop()
				ldebug = .f.
			ENDIF 
		
		ENDDO 
		lnSiguienteOcurrencia = 13
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
		&&Esta dise�ado para leer hasta los precios.
		&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.
		
		IF ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---'
			SKIP IN CsrLista
			LOOP 
		ENDIF 
		IF '*'$lcTelefono			
		
			INSERT INTO CsrDeudor (Codigo,Categoria,Nombre,Direccion,Localidad,CodPostal,Provincia;
			,Telefono,Telefono2,Fax,Celular,Email,fecAlta,TipoDoc,Documento;
			,TipoIVA,Vendedor,Zona,ctadeudor,DireNro,DirePiso,DireDpto,Lista,Estado,CodLista;
			,CodCateIVA) ;
			values (lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia ;
			,lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento ;
			,lcTipoIVA,lcVendedor,lcZona,1,lcDireNro,lcDirePiso,lcDireDpto,lcLista,lcEstado;
			,VAL(lcCodLista),VAL(lcCodCateIVA))
				
			*replace descripcion WITH lmDescripcion IN FsrArticulo
			leiunarticulo = .f.
		ENDIF 
	ENDIF 
	SKIP IN CsrLista
ENDDO 

SELECT distinct UPPER(localidad) as nombre ,SPACE(30) AS Localidad FROM CsrDeudor  INTO CURSOR CsrCiudad READWRITE 

SELECT CsrCiudad
*vista()

SCAN 
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(nombre)))
	SELECT CsrLocalidad
	LOCATE FOR nombre = lcLocalidadBuscada
	IF id#0
		replace localidad WITH lcLocalidadBuscada IN CsrCiudad
	ENDIF 
	SELECT CsrCiudad
ENDSCAN

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

SELECT distinct UPPER(lista) as nombre FROM CsrDeudor INTO CURSOR CsrListaPrecio
SELECT CsrListaPrecio

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
VISTA()

LOCAL nCodigo

nCodigo = 1
*stop()
SCAN 
	
	IF VAL(codigo)=9007
		*stop()
	ENDIF 
	
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
	VALUES (lnid, strtrim(nCodigo,8),'DISTRIBUIDORA SUR','','';
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

