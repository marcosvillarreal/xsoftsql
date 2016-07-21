PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcbdd,lcfecha,lnid
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcbdd = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

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
llok = CargarTabla(lcbdd,'CateCtacte',.t.)
llok = CargarTabla(lcbdd,'PlanCue')
llok = CargarTabla(lcbdd,'TablaInt')
llok = CargarTabla(lcbdd,'PlanPago')
llok = CargarTabla(lcbdd,'TipoDoc')

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE  ALLTRIM(lcpath)+"\gestion\clientes" in 0 alias FsrCliente EXCLUSIVE

USE  ALLTRIM(lcpath)+"\gestion\proveed" in 0 alias FsrProveedor EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\localida" in 0 alias FsrLocalidad EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\provinci" in 0 alias FsrProvincia EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\categori" in 0 alias FsrCateCtacte EXCLUSIVE



Oavisar.proceso('S','Procesando '+alias()) 
SELECT * FROM FsrCliente ORDER BY numero INTO CURSOR FsrDeudor

SELECT FsrCateCtacte
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnid = RecuperarID('CsrCatectacte',Goapp.sucursal10)

SELECT FsrCateCtacte
SCAN FOR !EOF()    
	&&&comprobar Ñ
	lcnombre=NombreNi(ALLTRIM(UPPER(FsrCateCtacte.nombre)))
	INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch);
    VALUES (lnid,FsrCateCtacte.numero,lcnombre,0,0,0,'00000')
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

LOCAL lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia;
,lnctabanco,lnctaotro,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2;
,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc,lnlista,lndiasvto;
,lnexistegan 

SELECT FsrDeudor
Oavisar.proceso('S','Procesando clientes') 	
GO  TOP 
SCAN 
	STORE 0 TO lnidlocalidad,lnidprovincia,lntipoiva,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
	,lnctabanco,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
    ,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif,lnidcategoria
    
   STORE "" TO lccnumero,lccnombre,lccdireccion,lccpostal,lcctelefono2,lcctelefono,lcemail,lccuit;
    ,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc
    
     IF recno('FsrDeudor')/500=INT(RECNO('FsrDeudor')/500)
	   lcTitulo = "Clientes "+STR(RECNO(),10)   
	   Oavisar.proceso('S',lcTitulo,.t.,recno())
	 ENDIF
    
    STORE 1 TO 	lnctadeudor,lnlista, lnidcanalvta
	lnestadocta		= IIF(FsrDeudor.debaja,1,0)
	lccnumero		= ALLTRIM(STR(FsrDeudor.numero))
	lccnombre		= ALLTRIM(FsrDeudor.nombre)
	lccdireccion	= ALLTRIM(FsrDeudor.direccion)
	lccpostal		= ""
	lcctelefono		= ALLTRIM(FsrDeudor.telefono)
	lcemail			= ""
	lccuit			= ""
	ldfechalta		= DATETIME(1900,01,01,0,0,0)
	lcobserva		= FsrDeudor.observa
	lcinscri01		= ""
	ldfecins01		= DATETIME(1900,01,01,0,0,0)
	lcinscri02		= IIF(FsrDeudor.ibrutos<>'N' and EMPTY(FsrDeudor.iblp),ALLTRIM(FsrDeudor.cuit),"")
	lcinscri03		= ""
	lcingbrutos		= IIF(FsrDeudor.ibrutos<>"N",ALLTRIM(FsrDeudor.Iblp),"")
	ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
	ldfecultpago	= DATETIME(1900,01,01,0,0,0)
	lnexisteibto	= IIF(FsrDeudor.Ibrutos<>'N',1,0)
	lnexistegan 	= IIF(FsrDeudor.gananciaS<>'N',1,0)
	lcctelefono2 	= STRTRAN(FsrDeudor.documento," ","")
	lndiasvto		= FsrDeudor.diasvto
	lntipoiva 		= FsrDeudor.tipocuit
	lcLocalidadBuscada = FsrDeudor.Localidad
	lnidplanpago	= 1100000001
	lnplanpago		= FsrDeudor.tipo_pago
	lntotalizabonif	= 0
	lnesrecodevol	= 0
	lccadena 		= strzero(6,lntamloc)
	lnidlocalidad 	= VAL(str(Goapp.sucursal10+10,2)+lccadena)
	lccadena 		= strzero(2,lntamprov)
	lnidprovincia 	= VAL(str(Goapp.sucursal10+10,2)+lccadena)
	lccp = ""
	lnidtablaint	= 4 &&Por defecto es el interes de socio
	lcnumdoc		= ALLTRIM(STRTRAN(FsrDeudor.documento,".",""))
	&&Buscamos si existen los tipo de documento valido
	lctipodoc		= LEFT(lcnumDoc,3)
	SELECT CsrTipoDoc
	LOCATE FOR abrevia=lctipodoc
	IF abrevia=lctipodoc
		lnidtipodoc = CsrTipoDoc.id
		lcnumDoc	= ArmarDocumento(ALLTRIM(STR(VAL(SUBSTR(lcnumdoc,4)),15)))
	ENDIF 
		
	SELECT CsrPlanPago
	LOCATE FOR codigo = lnplanpago
	IF codigo = lnplanpago
		lnidplanpago = CsrPlanPago.id
	ENDIF 
	
	lccadena = strzero(6,lntamloc)
	lnidlocalidad = VAL(str(Goapp.sucursal10+10,2)+lccadena)
	lccadena = strzero(2,lntamprov)
	lnidprovincia = VAL(str(Goapp.sucursal10+10,2)+lccadena)
	
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccpostal = CsrLocalidad.cpostal
	ELSE
		LOCATE FOR VAL(cpostal) = VAL(FsrDeudor.cp)
		IF VAL(cpostal) = val(FsrDeudor.cp)
			lnidlocalidad = CsrLocalidad.id
			lnidprovincia = CsrLocalidad.idprovincia
			lccpostal = CsrLocalidad.cpostal
		ENDIF 
	ENDIF
		
	lnidcategoria = VAL(str(Goapp.sucursal10+10,2)+strzero(1,lntamcate))
	SELECT CsrCateCtacte
	LOCATE FOR numero = FsrDeudor.categoria
	IF FOUND()
		lnidcategoria = CsrCateCtacte.id
	ENDIF 

*!*		IF lntipoiva=7
*!*		   lntipoiva = 5
*!*		ENDIF 
	
	lccuit =FsrDeudor.cuit
	IF lntipoiva=3
		lncuit=''
	ENDIF
			
	ldfecfac = FsrDeudor.fechaulcpr
	IF !EMPTY(ldfecfac)
		ldfecultcompra = DATETIME(YEAR(ldfecfac),MONTH(ldfecfac),DAY(ldfecfac),0,0,0)
	ENDIF 
	ldfechap = FsrDeudor.Fechaulpag
	IF !EMPTY(ldfechap)
		ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
	ENDIF 
	

	lccnombre = NombreNi(ALLTRIM(UPPER(lccnombre)))
	lccdireccion = NombreNi(ALLTRIM(UPPER(lccdireccion)))
      
	INSERT INTO Csrctacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono2;
	,ctelefono,email,tipoiva,cuit,idcategoria,ctadeudor,ctaacreedor,ctalogistica,ctabanco,ctaotro;
	,ctaorden,idplanpago,idcanalvta,fechalta,observa,saldo,saldoant,estadocta,bonif1,bonif2,copiatkt;
	,inscri01,fecins01,inscri02,inscri03,convenio,saldoauto,idbarrio,lista,idcateibrng,ingbrutos;
	,comision,fecultcompra,fecultpago,numdoc,idtipodoc,existeibto,existegan,diasvto,idtablaint,esrecodevol;
	,totalizabonif);
    VALUES(lnid,lccnumero,lccnombre,lccdireccion,lccpostal,lnidlocalidad,lnidprovincia,lcctelefono2;
    ,lcctelefono,lcemail,lntipoiva,lccuit,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica,lnctabanco;
    ,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,ldfechalta,lcobserva,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lcinscri01,ldfecins01,lcinscri02,lcinscri03,lnconvenio,lnsaldoauto;
    ,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,lcnumdoc,lnidtipodoc;
    ,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif)
    
	lnid = lnid + 1
	 
	SELECT FsrDeudor        
ENDSCAN



SELECT FsrProveedor
Oavisar.proceso('S','Procesando Proveedores') 
GO  TOP 
SCAN 
	STORE 0 TO lnidlocalidad,lnidprovincia,lntipoiva,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
	,lnctabanco,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
    ,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif
    
   	STORE "" TO lccnumero,lccnombre,lccdireccion,lccpostal,lcctelefono2,lcctelefono,lcemail,lccuit;
    ,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc
    
    STORE 1 TO 	lnctaacreedor, lnidcanalvta

	IF recno('FsrProveedor')/1000=INT(RECNO('FsrProveedor')/1000)
	   lcTitulo = "Proveedor "+STR(RECNO(),10)   
	   Oavisar.proceso('S',lcTitulo,.t.,recno())
	ENDIF
	 
	lccnumero		= ALLTRIM(STR(50000+FsrProveedor.numero))
	lccnombre		= ALLTRIM(FsrProveedor.nombre)
	lccdireccion	= ALLTRIM(FsrProveedor.direccion)
	lccpostal		= ""
	lcctelefono		= ALLTRIM(FsrProveedor.telefono)
	lcemail			= ""
	lccuit			= ""
	ldfechalta		= DATETIME(1900,01,01,0,0,0)
	lcobserva		= FsrProveedor.observa
	lcinscri01		= ""
	ldfecins01		= DATETIME(1900,01,01,0,0,0)
	lcinscri02		= ""
	lcinscri03		= ""
	lcingbrutos		= ""
	ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
	ldfecultpago	= DATETIME(1900,01,01,0,0,0)
	lnexisteibto	= IIF(FsrProveedor.Ibrutos<>'N',1,0)
	lnexistegan 	= IIF(FsrProveedor.Ibrutos<>'N',1,0)
	lcctelefono2 	= FsrProveedor.fax
	lndiasvto		= 0
	lntipoiva 		= FsrProveedor.tipocuit
	lcLocalidadBuscada = FsrProveedor.Localidad
	lnidplanpago	= 1100000002
	lntotalizabonif	= 0
	lnesrecodevol	= 0
	lnidtablaint	= 2	
	
	lcnumDoc		= ArmarDocumento(ALLTRIM(STR(VAL(SUBSTR(FsrProveedor.cuit,4)),15)))
	lctipodoc		= IIF(LEN(ALLTRIM(lcNumDoc))<10,'LC','DNI')

	SELECT CsrTipoDoc
	LOCATE FOR abrevia=lctipodoc
	IF abrevia=lctipodoc
		lnidtipodoc = CsrTipoDoc.id
	ENDIF 
		
	lccadena = strzero(6,lntamloc)
	lnidlocalidad = VAL(str(Goapp.sucursal10+10,2)+lccadena)
	lccadena = strzero(2,lntamprov)
	lnidprovincia = VAL(str(Goapp.sucursal10+10,2)+lccadena)
	lccpostal = ""
	
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccpostal = CsrLocalidad.cpostal
	ELSE
		LOCATE FOR VAL(cpostal) = val(FsrProveedor.cp)
		IF VAL(cpostal) = val(FsrProveedor.cp)
			lnidlocalidad = CsrLocalidad.id
			lnidprovincia = CsrLocalidad.idprovincia
			lccpostal 		 = CsrLocalidad.cpostal
		ENDIF 
	ENDIF
	
	lnidcatectacte	= IIF(FsrProveedor.esProv$'S',22,21)	
	SELECT CsrCateCtacte
	LOCATE FOR numero = lnidcatectacte
	IF FOUND()
		lnidcategoria = CsrCateCtacte.id
	ENDIF 

	IF lntipoiva=7
	   lntipoiva =5
	ENDIF 
	
	lccuit =FsrProveedor.cuit
	IF lntipoiva=3
		lncuit=''
	ENDIF
			
	ldfecfac = FsrProveedor.fechaulcpr
	IF !EMPTY(ldfecfac)
		ldfecultcompra = DATETIME(YEAR(ldfecfac),MONTH(ldfecfac),DAY(ldfecfac),0,0,0)
	ENDIF 
	ldfechap = FsrProveedor.Fechaulpag
	IF !EMPTY(ldfechap)
		ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
	ENDIF 
	

	lccnombre = NombreNi(ALLTRIM(UPPER(lccnombre)))
	lccdireccion = NombreNi(ALLTRIM(UPPER(lccdireccion)))
     
    SELECT CsrCtacte
    LOCATE FOR cnumero = lccnumero
    IF cnumero = lccnumero
    	oavisar.usuario('El Proveedor '+lccnumero+'. Esta duplicado. Nose grabara el proveedor')
    	SELECT FsrProveedor
    	LOOP 
    ENDIF 
     
	INSERT INTO Csrctacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono2;
	,ctelefono,email,tipoiva,cuit,idcategoria,ctadeudor,ctaacreedor,ctalogistica,ctabanco,ctaotro;
	,ctaorden,idplanpago,idcanalvta,fechalta,observa,saldo,saldoant,estadocta,bonif1,bonif2,copiatkt;
	,inscri01,fecins01,inscri02,inscri03,convenio,saldoauto,idbarrio,lista,idcateibrng,ingbrutos;
	,comision,fecultcompra,fecultpago,numdoc,idtipodoc,existeibto,existegan,diasvto,idtablaint,esrecodevol;
	,totalizabonif);
    VALUES(lnid,lccnumero,lccnombre,lccdireccion,lccpostal,lnidlocalidad,lnidprovincia,lcctelefono2;
    ,lcctelefono,lcemail,lntipoiva,lccuit,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica,lnctabanco;
    ,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,ldfechalta,lcobserva,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lcinscri01,ldfecins01,lcinscri02,lcinscri03,lnconvenio,lnsaldoauto;
    ,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,lcnumdoc,lnidtipodoc;
    ,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif)
    
	lnid = lnid + 1
	 
	SELECT FsrPRoveedor         
ENDSCAN



Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
USE in FsrCliente 
USE in FsrProveedor 
USE in FsrLocalidad 
USE in FsrProvincia 
USE in FsrCateCtacte 

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

