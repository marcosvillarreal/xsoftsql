PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
SET PROCEDURE TO z00_km ADDITIVE 

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Ctacte',.t.)
llok = CargarTabla(lcData,'TipoIva')
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Rubro',.t.)


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.*FROM Localidad as CsrLocalidad WHERE cpostal = '8503'
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)
SELECT CsrLocalidad

cArchivo = ADDBS(ALLTRIM(lcpath ))+"proveedoresexp.csv"
=LeerProveedoresKM(cArchivo)

SELECT CsrAcreedor
*vista()

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)


SELECT CsrAcreedor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
VISTA()

LOCAL nCodigo,cCadeCtacte 
cCadeCtacte = ''
*nCodigo = 1
lnNumRuta = 1
*stop()
SCAN 
 	
 	SELECT CsrAcreedor
 	STORE 0 TO lnidestado, 	lnctadeudor ,	lnctaacreedor, 	lnctabanco,	lnctaotro, 	lndctalogistica;
 			,lnidcateibrng ,lncomision ,lnidlocalidad ,lnidprovincia ,lntipoiva ,lnidcategoria;
			,lnidplanpago ,lnidcanalvta ,lnsaldoAuto ,lnlista ,lncomision ,lnconvenio,lndctalogistica;
			,lnbonif1
	
 	STORE 0 TO lnidbarrio, lnidcategoria, lnlista
 	STORE "" TO lcCuit,lcDNI,lcingbrutos,lcingbrutosBA,lcdatosfac,lcOtro01,lcObserva,lccp ,lcReferencia,lcemail
 	STORE DATETIME(1900,01,01,0,0,0) TO ldfechac,ldfecultcompra,ldfecultpago,lcfefin
 	
 	IF VAL(CsrAcreedor.codigo)=13
 	*	stop()
 	ENDIF 
*!*	 	nCodigo			= lnCodigo	
 	lcReferencia	= ALLTRIM(CsrAcreedor.referencia) + IIF(LEN(ALLTRIM(CsrAcreedor.vendedor))=1,"/\" ,"")+ IIF(LEN(ALLTRIM(CsrAcreedor.zona))=1,"$" ,"")
 	lnctaacreedor	= 1
 	lnidplanpago	= 1100000002 &&Por el momento todos de cuenta corriente	
 	*lnidplanpago	= IIF(CsrDeudor.PlanPago<>1,1100000001,1100000002)	
	lnidcanalvta	= 1100000001

			
	SELECT CsrLocalidad
	LOCATE FOR cpostal = '8503'
	IF  cpostal = '8503'
		lnidprovincia	= CsrLocalidad.idprovincia
		lccp 			= CsrLocalidad.cpostal
		lnidlocalidad	= CsrLocalidad.id
	ENDIF
	
	
	&&TresPImp	
	cTipoiva	= 1 &&UPPER(CsrDeudor.TipoIVA)

	lcNroDoc		= strtrim(VAL(PeloCuit(CsrAcreedor.Documento)),15)
	IF VAL(lcNroDoc)=0
		lntipoiva = 3
	ENDIF 
	
	lcCuit			= Cuit(lcNroDoc)
	IF LEN(LTRIM(lcCuit))<>0
		lcNroDoc		= ''
		lntipoiva	= 1
	ENDIF
	

	lcnumero	= CsrAcreedor.codigo
	
	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrAcreedor.nombre))) 
	
	*IF nCodigo = 19
	*	stop()
	*ENDIF 
	
	lcDire_Calle= RTRIM(UPPER(CsrAcreedor.direccion))
  	lcDire_Nro	= RTRIM(UPPER(CsrAcreedor.direnro))
  	lcDire_Piso	= RTRIM(UPPER(CsrAcreedor.direpiso))
  	lcDire_Dpto	= RTRIM(UPPER(CsrAcreedor.diredpto))
  	
  	cDireNro	= IIF(ALLTRIM(lcDire_Nro)='0' or LEN(lcDire_Nro)=0,'',lcDire_Nro)
  	cDirePiso	= IIF(LEN(LcDire_Piso)=0,"","P:"+lcDire_Piso)
	cDireDpto	= IIF(LEN(LcDire_Dpto)=0,"","D:"+lcDire_Dpto)
	
  	lcDireccion = ALLTRIM(ALLTRIM(lcDire_Calle) + " " + cDireNro + " "+ cDirePiso + " "+cDireDpto)
 	
  	*lcDireccion = RTRIM(UPPER(CsrDeudor.direccion)) + ' ' + ALLTRIM(CsrDeudor.direnro) + ' ' + ALLTRIM(CsrDeudor.direpiso) + ' ' + ALLTRIM(CsrDeudor.diredpto)
  	lcTelefono	= LTRIM(CsrAcreedor.telefono)
  	
	
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
	
	
	lnid = lnid + 1
	
	
	SELECT CsrAcreedor
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

SELECT CsrCtacte
vista()

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

