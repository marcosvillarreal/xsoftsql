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

TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.*,CsrProvincia.letracpostal as letra FROM Localidad as CsrLocalidad
INNER JOIN Provincia as CsrProvincia on CsrLocalidad.idprovincia = CsrProvincia.id
ENDTEXT 
IF !CrearCursorAdapter('CsrLocalidad',lccmd)
	MESSAGEBOX('Nose puede importar, pq no cargaron las localidades')
	RETURN .f.
ENDIF 

llok = CargarTabla(lcData,'Ctacte',.t.)
llok = CargarTabla(lcData,'Provincia')
llok = CargarTabla(lcData,'CateIbRn',.t.)
llok = CargarTabla(lcData,'CateIbRNg',.t.)
llok = CargarTabla(lcData,'TipoIva')
llok = CargarTabla(lcData,'CateCtacte',.t.)
llok = CargarTabla(lcData,'Barrio',.t.)
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Sucursal',.t.)
SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


USE  ALLTRIM(lcpath)+"\gestion\clientes" in 0 alias CsrDeudorViej EXCLUSIVE

USE  ALLTRIM(lcpath)+"\gestion\proveed" in 0 alias CsrAcreedor EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\localida" in 0 alias CsrLocalidadViejo EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\provinci" in 0 alias CsrProvinciaViejo EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\categori" in 0 alias CsrCategoriaDeudor EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 
SELECT * FROM CsrDeudorViej ORDER BY numero INTO CURSOR CsrDeudor


SELECT CsrProvinciaViejo
GO top
SCAN FOR !EOF()
	lcnombre=NombreNi(ALLTRIM(UPPER(CsrProvinciaViejo.nombre)))          
	SELECT CsrProvincia
	LOCATE FOR nombre$lcnombre
	IF nombre$lcnombre
		replace alicuota2 WITH ibrutosa,alicuota4 WITH ibrutosb,jurisdiccion WITH codjuri IN CsrProvincia
	ENDIF 
	SELECT CsrProvinciaViejo
ENDSCAN 


SELECT CsrCategoriaDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnid = RecuperarID('CsrCatectacte',Goapp.sucursal10)

SELECT CsrCategoriaDeudor
SCAN FOR !EOF()    
	&&&comprobar Ñ
	lcnombre=NombreNi(ALLTRIM(UPPER(CsrCategoriaDeudor.nombre)))
	INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch);
    VALUES (lnid,CsrCategoriaDeudor.numero,lcnombre,0,0,0,'00000')
    lnid = lnid +1 
ENDSCAN

INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,20,'CTA CTE BANCO',0,0,0,'00000')
lnid = lnid +1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,21,'CTA CTE PROVEEDOR',0,0,0,'01000')
lnid = lnid +1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,22,'CTA CTE SERVICIO',0,0,0,'00000')

SELECT CsrLocalidad
IF FSIZE('id')>4
   lntamloc = 10
ELSE 
   lntamloc = 8
ENDIF 

SELECT CsrProvincia
IF FSIZE('id')>4
   lntamprov = 10
ELSE 
   lntamprov = 8
ENDIF 

SELECT CsrTipoIva
IF FSIZE('id')>4
   lntamiva = 10
ELSE 
   lntamiva = 8
ENDIF 

SELECT CsrCateCtacte
IF FSIZE('id')>4
   lntamcate = 10
ELSE 
   lntamcate = 8
ENDIF

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

cCadeCtacte = "" 

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO  TOP 

SCAN 
 	SELECT CsrCtacte
 	LOCATE FOR VAL(cnumero) = CsrDeudor.numero
 	IF VAL(cnumero) = CsrDeudor.numero
 		cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + STRtrim(CsrDeudor.numero,10) 
 		SELECT CsrDeudor
 		LOOP 
 		
 	ENDIF 
 	SELECT CsrDeudor 
 	
	lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)))
	
	lnidbarrio = 0


	lnidlocalidad =	1100002314 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
	lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
	lnidbarrio	= 1100000001
	lccp = ""
	
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccp = CsrLocalidad.Letra+CsrLocalidad.cpostal
	ENDIF
		
		
		lnidestado = 0
    	lnctadeudor = 1
    	lnctaacreedor = 0
    	lnctabanco = 0
    	lnctaotro  = 0
    	lndctalogistica = 0
        
		lnidcategoria = VAL(str(Goapp.sucursal10+10,2)+strzero(1,lntamcate))
		SELECT CsrCateCtacte
		LOCATE FOR numero = CsrDeudor.categoria
		IF FOUND()
			lnidcategoria = CsrCateCtacte.id
		ENDIF 

		SELECT CsrDeudor
		lntipoiva = tipocuit
		IF lntipoiva=7
			lntipoiva = 5
		ENDIF 
		IF lntipoiva=3
			lncuit=''
		ENDIF
		lnidcateibrng =VAL(str(Goapp.sucursal10+10,2)+strzero(4,8))
		
		
		lnidplanpago = CsrDeudor.tipo_pago
		IF CsrDeudor.tipo_pago=0
			lnidplanpago=1
		ENDIF 
		IF lnidplanpago>2 &&=3 remito 3ro
			lnidplanpago = 10
			lndctalogistica=1
		ENDIF 
		lnidplanpago =VAL("11"+strzero(lnidplanpago,8))
		
              
		lcfefin       = DATETIME(1900,01,01,0,0,0)
		lnlista = CsrDeudor.Lista
		ldfechac = CsrDeudor.Fechaulcpr
		ldfeculcompra = lcfefin
		IF !EMPTY(ldfechac)
			ldfecultcompra = DATETIME(YEAR(ldfechac),MONTH(ldfechac),DAY(ldfechac),0,0,0)
		ENDIF 
		ldfechap = CsrDeudor.Fechaulpag
		ldfeculpago = lcfefin
		IF !EMPTY(ldfechap)
			ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
		ENDIF 
		lcingbrutos = ""
		lcingbrutosBA = ""&&CsrDeudor.ibrutos
		lncomision = CsrDeudor.comision
		lnconvenio = 0&&CsrDeudor.convenio
				
		lccuit =STRTRAN(STRTRAN(CsrDeudor.cuit,".","-"),"*","-")
		IF VAL(lccuit)=0
			lindcateibrng=0
		ENDIF 

	lcnombre = NombreNi(ALLTRIM(UPPER(CsrDeudor.nombre)))

      INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
      ,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
      ,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
      ,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
      ,totalizabonif);
	  VALUES (lnid,LTRIM(STR(CsrDeudor.numero)),lcnombre,UPPER(CsrDeudor.direccion),LTRIM(lccp);
	  ,lnidlocalidad,lnidprovincia,CsrDeudor.telefono,lntipoiva,lccuit,lnidcategoria,0,0;
	  ,lnidplanpago,1100000006,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	  ,"",0,lcfefin,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
	  ,lnconvenio,lndctalogistica,0,0)
	
		
	lnid = lnid + 1
	          
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("No se grabaron algunas clientes, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
ENDIF 


SELECT CsrAcreedor
cCadeCtacte = "" 
Oavisar.proceso('S','Procesando '+alias()) 
GO  TOP 
SCAN 

 	
		SELECT CsrCtacte
		LOCATE FOR cnumero=LTRIM(STR(30000+CsrAcreedor.numero))
		IF FOUND()
			cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + STRtrim(CsrAcreedor.numero,10) 
			SELECT  CsrAcreedor
			LOOP
		ENDIF
		SELECT CsrAcreedor
		IF CsrAcreedor.numero = 10
			stop()
		ENDIF 
		lcLocalidadBuscada = Ciudades(STRTRAN(ALLTRIM(UPPER(CsrAcreedor.Localidad)),";",""))

		lnidlocalidad =	 0
		lnidprovincia =	 0
		lccp			 = ""
		SELECT CsrLocalidad
		LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
		IF FOUND() AND NOT STRTRAN(nombre," ","") $ "SANMARTIN-SANTAROSA"
			lnidlocalidad = CsrLocalidad.id
			lnidprovincia = CsrLocalidad.idprovincia
			lccp = CsrLocalidad.Letra+CsrLocalidad.cpostal
		ELSE
			SELECT CsrLocalidad
			LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada) AND VAL(cpostal) = CsrAcreedor.cp
			IF FOUND()
				lnidlocalidad = CsrLocalidad.id
				lnidprovincia = CsrLocalidad.idprovincia
				lccp = CsrLocalidad.Letra+CsrLocalidad.cpostal
			ENDIF 
		ENDIF
		
		SELECT CsrAcreedor
		lntipoiva = tipocuit
		IF lntipoiva=7
			lntipoiva = 5
		ENDIF 
		IF lntipoiva=3
			lncuit=''
		ENDIF
		lnidcateibrng =VAL(str(Goapp.sucursal10+10,2)+strzero(4,8))
		
		lnidcategoria = 22
		SELECT CsrCateCtacte
		LOCATE FOR numero=lnidcategoria
		lnidcategoria = CsrCateCtacte.id
		SELECT CsrPlanCue
		LOCATE FOR cuenta = CsrAcreedor.cuenta
		IF FOUND() AND cuenta = CsrAcreedor.cuenta AND 'MERCAD'$nombre
			lnidcategoria = 21
			SELECT CsrCateCtacte
			LOCATE FOR numero=lnidcategoria
			lnidcategoria = CsrCateCtacte.id
		ENDIF

		lnidestado = 0
    	lnctadeudor = 0
    	lnctaacreedor=1
    	lnctabanco = 0
    	lnctaotro  = 0
    	lnctalogistica = 0
		lcfefin       = DATETIME(1900,01,01,0,0,0)
		lnlista = 0
		ldfechac = CsrAcreedor.Fechaulcpr
		ldfeculcompra = lcfefin
		IF !EMPTY(ldfechac)
			ldfecultcompra = DATETIME(YEAR(ldfechac),MONTH(ldfechac),DAY(ldfechac),0,0,0)
		ENDIF 
		ldfechap = CsrAcreedor.Fechaulpag
		ldfeculpago = lcfefin
		IF !EMPTY(ldfechap)
			ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
		ENDIF 
		lcingbrutosBA = CsrAcreedor.ibrutos
		lcingbrutos = ""
		IF CsrAcreedor.provincia = "R"
			lcingbrutos = CsrAcreedor.ibrutos
			lcingbrutosBA = " "
		ENDIF 
		
		lncomision = 0
		lntotalizabonif = 0
    	lnesrecodevol = 0
		*lnidcateibrng =VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(STR(4)))
		lcnombre = NombreNi(ALLTRIM(UPPER(CsrAcreedor.nombre))) 
		
        INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
        ,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
        ,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
        ,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
        ,totalizabonif);
		VALUES (lnid,LTRIM(STR(30000+CsrAcreedor.numero)),lcnombre,CsrAcreedor.direccion,LTRIM(lccp);
		,lnidlocalidad,lnidprovincia,CsrAcreedor.telefono,lntipoiva,CsrAcreedor.cuit,lnidcategoria,0,0;
		,1100000002,1100000006,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
		,"",0,lcfefin,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,0;
		,lnctalogistica,lnesrecodevol,lntotalizabonif)
		          
         
		lnid = lnid + 1
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("No se grabaron algunas proveedores, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
ENDIF 

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE in CsrDeudorViej 
USE in CsrAcreedor 
USE in CsrLocalidadViejo 
USE in CsrProvinciaViejo 
USE in CsrCategoriaDeudor 
