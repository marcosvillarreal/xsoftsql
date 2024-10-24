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
llok = CargarTabla(lcData,'i_empleados')


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.* FROM Localidad as CsrLocalidad
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)

SELECT * FROM CsrI_Empleados ORDER BY legajo INTO CURSOR CsrEmpleados READWRITE 


SELECT CsrCtacte
DELETE FROM CsrCtacte WHERE ctaempleado = 1
PACK 
SELECT VAL(cnumero) as codigo FROM CsrCtacte INTO CURSOR ListaCodigos READWRITE 

INDEX on codigo TAG korden
SET ORDER TO korden
*vista()
SET SAFETY ON

		
Oavisar.proceso('S','Abriendo archivos') 

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

SELECT ListaCodigos
GO TOP 
lnNroCta = codigo
lnUltNroCta = lnNroCta

SELECT CsrEmpleados
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
*VISTA()
cCadeCtacte = ''

*stop()
SCAN 
	IF CsrEmpleados.legajo = 0
		LOOP
	ENDIF 
		
	SELECT ListaCodigos
	LOCATE FOR codigo = lnUltNroCta
	IF lnNroCta+1>= lnUltNroCta
		lnNroCta = lnUltNroCta
		lHueco = .f.
		SKIP 
		DO WHILE NOT EOF() AND NOT lHueco
			
			lnNroCta = lnNroCta + 1 
			IF lnNroCta <>codigo
				lHueco = .t.
				lnUltNroCta = lnNroCta
			ENDIF  
			SKIP 
		ENDDO 
	ELSE
		lnNroCta = lnNroCta + 1 
	ENDIF 
	lnCodigo = lnNroCta
	 
 	SELECT CsrEmpleados
 	 
 	STORE 0 TO lnidestado, 	lnctadeudor ,	lnctaacreedor, 	lnctabanco,	lnctaotro, 	lndctalogistica;
 			,lnidcateibrng ,lncomision ,lnidlocalidad ,lnidprovincia ,lntipoiva ,lnidcategoria;
			,lnidplanpago ,lnidcanalvta ,lnsaldoAuto ,lnlista ,lncomision ,lnconvenio,lndctalogistica;
			,lnbonif1
	
 	STORE 1100000001 TO  lnidcategoria
 	STORE 1 TO  lnlista,lnctaempleado
 	STORE "" TO lcCuit,lcDNI,lcingbrutos,lcingbrutosBA,lcdatosfac,lcOtro01,lcObserva,lccp,lcDireccion
 	STORE "" TO lcDire_Calle,lcDire_Nro,lcDire_Piso,lcDire_Dpto,lcTelefono,lcEmail
 	STORE DATETIME(1900,01,01,0,0,0) TO ldfechac,ldfecultcompra,ldfecultpago,lcfefin
 		
 	lnidplanpago	= 1100000002 &&Por el momento todos de cuenta corriente		
	lnidcanalvta	= 1
	lcDatosFac		= ALLTRIM(STR(CsrEmpleados.legajo,10))
	
	&&Localidad
	lnidlocalidad	= 1100000345  &&Bahia Blanca
	lnidprovincia	= 1100000002
	
	lntipoiva = 3	
	
	lcnumero	= strtrim(lnCodigo,8)	
	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrEmpleados.apellido)))+","+NombreNi(ALLTRIM(UPPER(CsrEmpleados.nombre)))  	
   	
  		
	INSERT INTO CsrCtacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono;
	,tipoiva,cuit,idcategoria,saldo,saldoant,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscriiibb,fecinsiibb,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica;
	,bonif1,email,observa,cdatosfac,dni,cdirecalle,cdirenro,cdirepiso,cdiredpto,refotro,ctaempleado);
	VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
	,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
	,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	,lnconvenio,lndctalogistica,lnBonif1,lcEmail,lcObserva,lcDatosFac,lcDNI;
	,lcDire_Calle,lcDire_Nro,lcDire_Piso,lcDire_Dpto,"",lnCtaEmpleado)
	
	lnid = lnid + 1
	
	APPEND BLANK IN ListaCodigos
	replace codigo WITH VAL(lcNumero) IN ListaCodigos
	
	SELECT CsrEmpleados           
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

SELECT CsrCtacte
*vista()
USE IN CsrEmpleados
USE IN ListaCodigos

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

