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
llok = CargarTabla(lcData,'CateCtacte',.t.)
llok = CargarTabla(lcData,'Barrio',.t.)
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Sucursal',.t.)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.* FROM Localidad as CsrLocalidad
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


USE  ALLTRIM(lcpath)+"\clientes" in 0 alias CsrDeudorViej EXCLUSIVE

USE  ALLTRIM(lcpath)+"\proveedo" in 0 alias CsrAcreedor EXCLUSIVE


Oavisar.proceso('S','Procesando '+alias()) 
SELECT * FROM CsrDeudorViej ORDER BY codigo INTO CURSOR CsrDeudor

lnid = RecuperarID('CsrCatectacte',Goapp.sucursal10)
lnnumero = 1
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,lnnumero,'CLIENTES',0,0,0,'00000')
lnid = lnid +1 
lnnumero = lnnumero + 1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,lnnumero,'CTA CTE BANCO',0,0,0,'00000')
lnid = lnid +1 
lnnumero = lnnumero + 1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,lnnumero,'CTA CTE PROVEEDOR',0,0,0,'01000')
lnid = lnid +1 
lnnumero = lnnumero + 1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,lnnumero,'CTA CTE SERVICIO',0,0,0,'00000')

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

cCadeCtacte = "" 

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
stop()
SCAN 
 	SELECT CsrCtacte
 	LOCATE FOR VAL(cnumero) = VAL(CsrDeudor.codigo)
 	IF VAL(cnumero) = VAL(CsrDeudor.codigo)
 		cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + ltrim(CsrDeudor.codigo)
 		SELECT CsrDeudor
 		LOOP 
 		
 	ENDIF 
 	SELECT CsrDeudor 
 	STORE 0 TO lnidestado, 	lnctadeudor ,	lnctaacreedor, 	lnctabanco,	lnctaotro, 	lndctalogistica;
 			,lnidcateibrng ,lncomision ,lnidlocalidad ,lnidprovincia ,lntipoiva ,lnidcategoria;
			,lnidplanpago ,lnidcanalvta ,lnsaldoAuto ,lnlista ,lncomision ,lnconvenio,lndctalogistica
	
 	STORE 1100000001 TO lnidbarrio, lnidcategoria, lnlista
 	STORE "" TO lcCuit,lcDNI,lcingbrutos,lcingbrutosBA
 	STORE DATETIME(1900,01,01,0,0,0) TO ldfechac,ldfecultcompra,ldfecultpago,lcfefin
 		
 	lnctadeudor		= 1
 	lnidplanpago	= 1100000002 &&Por el momento todos de cuenta corriente		
	lnidcanalvta	= 1100000006
	
	lcingbrutosBA = CsrDeudor.ingbrutos
	
	lcNroDoc		= strtrim(VAL(PeloCuit(CsrDeudor.NroDoc)),15)
	IF CsrDeudor.tipodoc$'01-02'
		lcCuit			= Cuit(lcNroDoc)
	ELSE
		lcDNI			= LEFT(RIGHT(lcNroDoc,8),2)+"."+LEFT(RIGHT(lcNroDoc,6),3)+"."+RIGHT(lcNroDoc,3)
	ENDIF 
	
	&&Localidad
	lnidlocalidad	= 1100000006 
	*lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)))
	lnPostal		= VAL(CsrDeudor.Postal)
	DO CASE
	CASE lnPostal = 1727
		lnidlocalidad	= 1100002059 &&MARCOS PAZ
	CASE lnPostal = 8109
		lnidlocalidad	= 1100002314 &&PUNTA ALTA
	CASE lnPostal = 8105
		lnidlocalidad	= 1100001422 &&GRAL CERRI
	CASE lnPostal = 8103
		lnidlocalidad	= 1100001557 &&ING WHITE
	CASE lnPostal = 8129
		lnidlocalidad	= 1100001374 &&FELIPE SOLA
	CASE lnPostal = 8132
		lnidlocalidad	= 1100002093 &&MEDANOS
	CASE lnPostal = 8142
		lnidlocalidad	= 1100001523 &&H. ASCASUBI
	CASE lnPostal = 8146
		lnidlocalidad	= 1100002085 &&BURATOVICH
	CASE lnPostal = 8148
		lnidlocalidad	= 1100002226 &&PEDRO LURO	
	CASE lnPostal = 8150
		lnidlocalidad	= 1100001102 &&DORREGO
	CASE lnPostal = 8153
		lnidlocalidad	= 1100002120 &&M. HERMOSO
	CASE lnPostal = 8160
		lnidlocalidad	= 1100002602 &&TORNQUIST	
	CASE lnPostal = 8170
		lnidlocalidad	= 1100002245 &&PIGUE
	CASE lnPostal = 8174
		lnidlocalidad	= 1100002419 &&SAAVEDRA
	CASE lnPostal = 8183
		lnidlocalidad	= 1100001146 &&DARREGUIERA
	CASE lnPostal = 8512
		lnidlocalidad	= 1100002777 &&VILLALONGA
	
	OTHERWISE
		SELECT CsrLocalidad
		LOCATE FOR VAL(cpostal) = lnpostal
		lnidlocalidad = CsrLocalidad.id
	ENDCASE
	SELECT CsrLocalidad
	LOCATE FOR id = lnidlocalidad
	IF id = lnidlocalidad
		lnidprovincia = CsrLocalidad.idprovincia
		lccp = CsrLocalidad.cpostal
	ENDIF
	
	&&TresPImp		
	lntipoiva = VAL(CsrDeudor.tipo)
	DO CASE 
	CASE lntipoiva = 1
		lntipoiva = 1	&&RI
	CASE lntipoiva = 5
		lntipoiva = 3	&&CF
	CASE lntipoiva = 7
		lntipoiva = 5	&&RM
	CASE lntipoiva = 3
		lntipoiva = 4	&&EXENTO
	OTHERWISE 
		lntipoiva = 7	&&NOCATEGORIZADO
	ENDCASE 
	IF lntipoiva=3
		lcCuit=''
	ENDIF

    DO CASE 
    CASE lnlista = VAL(CsrDeudor.Lista)
    	lnlista	= 1100000005
    CASE lnlista = VAL(CsrDeudor.Lista)
    	lnlista	= 1100000006
    ENDCASE 

	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrDeudor.nombre)))
  	lcnumero	= strtrim(VAL(CsrDeudor.codigo),8)
  	lcDireccion	= UPPER(CsrDeudor.domicilio)
  	lcCP		= LTRIM(lcCp)
  	lcTelefono	= LTRIM(CsrDeudor.telefono)
  	lcFax		= LTRIM(CsrDeudor.fax)
  	lnSaldoAuto	= CsrDeudor.limcrcli
  	ldfechac	= CsrDeudor.fechaini
  	lnBonif1	= CsrDeudor.bonifcli
  	lcEmail		= LTRIM(CsrDeudor.email)
  	lcObserva	= LTRIM(CsrDeudor.obsercli)
  	lcDatosFac	= LTRIM(CsrDeudor.contacli)
  		
	INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
	,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
	,totalizabonif,bonif1,fax,email,observa,cdatosfac,dni);
	VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
	,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
	,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	,lnconvenio,lndctalogistica,0,0,lnBonif1,lcFax,lcEmail,lcObserva,lcDatosFac,lcDNI)

	lnid = lnid + 1
	
	SELECT CsrDeudor           
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("No se grabaron algunas clientes, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
ENDIF 

SELECT CsrCtacte
GO BOTTOM 
lnCodProve = VAL(cnumero) + 1
SELECT CsrAcreedor
cCadeCtacte = "" 
Oavisar.proceso('S','Procesando '+alias()) 
GO  TOP 
SCAN 
 	STORE 0 TO lnidestado, 	lnctadeudor ,	lnctaacreedor, 	lnctabanco,	lnctaotro, 	lndctalogistica;
 			,lnidcateibrng ,lncomision ,lnidlocalidad ,lnidprovincia ,lntipoiva ,lnidcategoria;
			,lnidplanpago ,lnidcanalvta ,lnsaldoAuto ,lnlista ,lncomision ,lnconvenio,lndctalogistica;
			,lnlista
	
 	STORE 1100000001 TO lnidbarrio, lnidcategoria
 	STORE "" TO lcCuit,lcDNI,lcingbrutos,lcingbrutosBA,lcDatosFac
 	STORE DATETIME(1900,01,01,0,0,0) TO ldfechac,ldfecultcompra,ldfecultpago,lcfefin
 		
 	lnctaacreedor	= 1
 	lnidplanpago	= 1100000002 &&Por el momento todos de cuenta corriente		
	lnidcanalvta	= 1100000006
	
	lcingbrutosBA = CsrAcreedor.ing_brutos
	
	lcCuit			= Cuit(strtrim(VAL(PeloCuit(CsrAcreedor.cuit)),15))
	
	&&Localidad
	lnidlocalidad	= 1100000006 
	*lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)))
	lcPostal		= ALLTRIM(CsrDeudor.Postal)
	DO CASE
	CASE lcPostal	= '1607'
		lnidlocalidad	= 1100002654 &&VILLA ADELINA
	CASE lcPostal	= '1611'
		lnidlocalidad	= 1100001183 &&DON TORCUATO                  
	CASE lcPostal	= '1650'
		lnidlocalidad	= 1100002485 &&SAN MARTIN                    
	CASE lcPostal	= '1678'
		lnidlocalidad	= 1100000962 &&CASEROS (PDO. 3 DE FEBRERO)   
	CASE lcPostal	= '1727'
		lnidlocalidad	= 1100002059 &&MARCOS PAZ                    
	CASE lcPostal	= '1900'
		lnidlocalidad	= 1100001820 &&LA PLATA                      
	CASE lcPostal	= '2752'
		lnidlocalidad	= 1100000940 &&CAPITAN SARMIENTO             
	CASE lcPostal	= '5000'
		lnidlocalidad	= 1100008167 &&CORDOBA
	CASE lcPostal	= '6740'
		lnidlocalidad	= 1100000984 &&CHACABUCO                     	
	CASE '1708' $ lcPostal
		lnidlocalidad	= 1100002127 &&MORON                         
	CASE '1824' $ lcPostal
		lnidlocalidad	= 1100001897 &&LANUS                         
	CASE '1001' $ lcPostal
		lnidlocalidad	= 1100002991 &&CIUDAD	
	CASE '2300' $ lcPostal
		lnidlocalidad	= 1100019029 &&RAFAELA
	CASE '3002' $ lcPostal
		lnidlocalidad	= 1100019118 &&SANTA FE
	
	OTHERWISE
		SELECT CsrLocalidad
		LOCATE FOR VAL(cpostal) = lnpostal
		lnidlocalidad = CsrLocalidad.id
	ENDCASE
	SELECT CsrLocalidad
	LOCATE FOR id = lnidlocalidad
	IF id = lnidlocalidad
		lnidprovincia = CsrLocalidad.idprovincia
		lccp = CsrLocalidad.cpostal
	ENDIF
	
	&&TresPImp		
	lntipoiva = VAL(CsrAcreedor.tipo)
	DO CASE 
	CASE lntipoiva = 1
		lntipoiva = 1	&&RI
	CASE lntipoiva = 5
		lntipoiva = 3	&&CF
	CASE lntipoiva = 7
		lntipoiva = 5	&&RM
	CASE lntipoiva = 3
		lntipoiva = 4	&&EXENTO
	OTHERWISE 
		lntipoiva = 7	&&NOCATEGORIZADO
	ENDCASE 
	IF lntipoiva=3
		lcCuit=''
	ENDIF


	lcnombre	= NombreNi(ALLTRIM(UPPER(CsrAcreedor.nombre)))
  	lcnumero	= strtrim(lnCodProve,8)
  	lcDireccion	= UPPER(CsrAcreedor.domicilio)
  	lcCP		= LTRIM(lcCp)
  	lcTelefono	= LTRIM(CsrAcreedor.telefono)
  	lcFax		= LTRIM(CsrAcreedor.fax)
  	lnSaldoAuto	= CsrAcreedor.credito
  	lcEmail		= LTRIM(CsrAcreedor.email)
  	lcObserva	= LTRIM(CsrAcreedor.observaci)
  		
	INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
	,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
	,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
	,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
	,totalizabonif,bonif1,fax,email,observa,cdatosfac);
	VALUES (lnid,lcNumero,lcnombre,lcDireccion,lccp;
	,lnidlocalidad,lnidprovincia,lctelefono,lntipoiva,lccuit,lnidcategoria,0,0;
	,lnidplanpago,lnidcanalvta,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",lnsaldoAuto,ldfechac,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	,lnconvenio,lndctalogistica,0,0,lnBonif1,lcFax,lcEmail,lcObserva,lcDatosFac)

	lnid = lnid + 1
	lnCodProve = lnCodProve + 1 
	
	SELECT CsrAcreedor          
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("No se grabaron algunas proveedores, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
ENDIF 

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

SELECT CsrCtacte
vista()

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE in CsrDeudorViej 
USE in CsrAcreedor 
