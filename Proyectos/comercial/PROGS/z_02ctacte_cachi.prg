PARAMETERS ldvacio,lcpath,lcBase,lnlimite

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
llok = CargarTabla(lcbdd,'PlanPago')
llok = CargarTabla(lcbdd,'TipoDoc')
*!*	llok = CargarTabla(lcbdd,'MovCtacte',.t.)
*!*	llok = CargarTabla(lcbdd,'Maopera',.t.)

*!*	llok = CargarTabla(lcbdd,'Localidad',.t.)
*!*	TEXT TO lcCmd TEXTMERGE NOSHOW 
*!*	SELECT * FROM Localidad as CsrLocalidad
*!*	ENDTEXT 
*!*	CrearCursorAdapter('FsrLocalidad',lccmd)

*!*	SELECT FsrLocalidad
*!*	GO TOP 
*!*	SCAN 
*!*		SCATTER NAME Oscatter
*!*		
*!*		SELECT CsrLocalidad
*!*		APPEND BLANK
*!*		TRY 
*!*			GATHER NAME Oscatter
*!*		CATCH 
*!*			oavisar.usuario("ID "+strtrim(OScatter.id)+" "+ALLTRIM(Oscatter.nombre)+" "+ALLTRIM(Oscatter.cpostal))
*!*		ENDTRY 
*!*		SELECT FsrLocalidad
*!*	ENDSCAN 
&&Tomamos la primera caja
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
USE  ALLTRIM(lcpath)+"\clientes" in 0 alias FsrDeudor EXCLUSIVE

USE  ALLTRIM(lcpath)+"\proveed" in 0 alias FsrProveedor EXCLUSIVE

*!*	CREATE CURSOR FsrMovDeudor (codigo c(6),nombre c(31),direccion c(20),saldo c(16),debitocredito c(4))
*!*	SELECT FsrMovDeudor
*!*	APPEND FROM   ALLTRIM(lcpath )+"\clientes.prn" SDF

*!*	CREATE CURSOR FsrMovAcreedor (codigo c(6),nombre c(31),direccion c(20),saldo c(16),debitocredito c(4))
*!*	SELECT FsrMovAcreedor
*!*	APPEND FROM   ALLTRIM(lcpath )+"\proveedores.prn" SDF

Oavisar.proceso('S','Procesando Categorias') 
lnid = RecuperarID('CsrCatectacte',Goapp.sucursal10)

INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,20,'CTA CTE CLIENTE',0,0,0,'00000')
lnidcatedeudor = lnid
lnid = lnid +1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,20,'CTA CTE BANCO',0,0,0,'00000')
lnid = lnid +1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,21,'CTA CTE PROVEEDOR',0,0,0,'01000')
lnidcateacreedor = lnid
lnid = lnid +1 
INSERT INTO CsrCateCtacte (id,numero,nombre,tasa1,tasa2,tasa3,switch) VALUES (lnid,22,'CTA CTE SERVICIO',0,0,0,'00000')


lnid			= RecuperarID('CsrCtacte',Goapp.sucursal10)
*lnidmaopera		= RecuperarID('CsrMaopera',Goapp.sucursal10)
*lnidmovctacte	= RecuperarID('CsrMovCtacte',Goapp.sucursal10)

LOCAL lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia;
,lnctabanco,lnctaotro,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2;
,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc,lnlista,lndiasvto;
,lnexistegan 

SELECT FsrDeudor
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
    
     IF recno('FsrDeudor')/500=INT(RECNO('FsrDeudor')/500)
	   lcTitulo = "Clientes "+STR(RECNO(),10)   
	   Oavisar.proceso('S',lcTitulo,.t.,recno())
	 ENDIF
    
    STORE 1 TO 	lnctadeudor,lnlista, lnidcanalvta
    &&lcEmail			= FsrDeudor.cliente
    nNumeroCtacte	= FsrDeudor.numero &&nNumeroCtacte + 1 
	lnestadocta		= 0
	lccnumero		= ALLTRIM(STR(nNumeroCtacte))
	lccnombre		= ALLTRIM(FsrDeudor.nombre)
	lccdireccion	= ALLTRIM(FsrDeudor.direccion)
	lcctelefono		= ALLTRIM(FsrDeudor.telefono)
	ldfechalta		= DATETIME(1900,01,01,0,0,0)
	lcobserva		= FsrDeudor.observa
	ldfecins01		= DATETIME(1900,01,01,0,0,0)
	ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
	ldfecultpago	= DATETIME(1900,01,01,0,0,0)
	lnbonif1		= FsrDeudor.bonif1
	lntipoiva 		= FsrDeudor.tipocuit &&VAL(FsrDeudor.categiva)
	lcLocalidadBuscada = Ciudades(FsrDeudor.Localidad)
	lccp = ""
	lnidtablaint	= 0 &&Por defecto es el interes de socio
	&&Buscamos si existen los tipo de documento valido
	lctipodoc		= LEFT(lcnumDoc,3)
	SELECT CsrTipoDoc
	LOCATE FOR abrevia=lctipodoc
	IF abrevia=lctipodoc
		lnidtipodoc = CsrTipoDoc.id
		lcnumDoc	= ArmarDocumento(ALLTRIM(STR(VAL(SUBSTR(lcnumdoc,4)),15)))
	ENDIF 
		
	&&lnidplanpago	= 1100000002

	
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccpostal = CsrLocalidad.cpostal
	ELSE
		LOCATE FOR VAL(cpostal) = FsrDeudor.cp
		IF VAL(cpostal) = FsrDeudor.cp
			lnidlocalidad = CsrLocalidad.id
			lnidprovincia = CsrLocalidad.idprovincia
			lccpostal = CsrLocalidad.cpostal
		ENDIF 
	ENDIF
		
	lnidcategoria = lnidcatedeudor

	IF lntipoiva=7
		lntipoiva = 5
	ENDIF 
	IF lntipoiva=3
		lncuit=''
	ENDIF
	
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
	
	cBuscar = FsrDeudor.tipo_pago
	IF cBuscar$'C'
		cBuscar = 'CCT'
	ENDIF 
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
	,totalizabonif);
    VALUES(lnid,lccnumero,lccnombre,lccdireccion,lccpostal,lnidlocalidad,lnidprovincia,lcctelefono2;
    ,lcctelefono,lcemail,lntipoiva,lccuit,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica,lnctabanco;
    ,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,ldfechalta,lcobserva,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lcinscri01,ldfecins01,lcinscri02,lcinscri03,lnconvenio,lnsaldoauto;
    ,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,lcnumdoc,lnidtipodoc;
    ,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif)
    
	lnid = lnid + 1
	
*!*		&&Agregamos movimiento por el saldo
*!*		SELECT FsrMovDeudor
*!*		LOCATE FOR ALLTRIM(codigo) = ALLTRIM(FsrDeudor.cliente)
*!*		IF ALLTRIM(codigo) = ALLTRIM(FsrDeudor.cliente)
*!*			lnimporte=val(FsrMovDeudor.Saldo)
*!*			lnsigno=1
*!*			replace Csrctacte.saldo WITH val(FsrMovDeudor.Saldo) IN CsrCtacte
*!*			lnidcomproba=36 
*!*			lcclasecomp="F"
*!*			IF ALLTRIM(FsrMovDeudor.debitocredito)$"CR"
*!*				lnsigno=-1
*!*				lnidcomproba=37
*!*				lcclasecomp="G"
*!*			ENDIF
*!*			lnimporte		= lnimporte*lnsigno
*!*			lcletra			= "X"
*!*			lcnum			= strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0')
*!*			lcnumero		= lcletra+"0000"+lcnum
*!*			lcswitch		= "00000"
*!*			lnSaldo			= lnImporte
*!*			lcctacte		= CsrCtacte.cnumero
*!*			lnidctacte		= CsrCtacte.id
*!*			ldfechaserver	= DATETIME()
*!*			ldfechasis		= FechaHoraCero(ldfechaserver)
*!*			lcfiscal		= LEFT(DTOS(TTOD(ldfechasis)),6)
*!*			
*!*			INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor;
*!*			,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,detalle;
*!*			,fechaserver);
*!*			VALUES (lnidmaopera,"MOV","IMPORTACIÓN MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
*!*			,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,lcswitch,"0";
*!*			,"Importación. Compactación Mov Cliente.",ldfechaserver)
*!*			
*!*			lcswitch		= "00100"
*!*			INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
*!*			,entrega,vencimien,total,detalle,pefiscal,switch,signo);
*!*			VALUES (lnidmovctacte,lnidmaopera,ldfechasis-1,lcctacte,lnidctacte," ",0,1,lnimporte;
*!*			,lnSaldo,0,ldfechasis-1,lnimporte,FsrMovDeudor.codigo+" Saldo de Importación",SUBSTR(lcfiscal,1,6),lcswitch,lnsigno)
*!*			
*!*			lnidmovctacte=lnidmovctacte+1
*!*			lnidmaopera=lnidmaopera+1
*!*			
*!*		ENDIF 
	SELECT FsrDeudor        
ENDSCAN


SELECT FsrProveedor
Oavisar.proceso('S','Procesando Proveedores') 
GO  TOP 
SCAN 
	STORE 0 TO lnidlocalidad,lnidprovincia,lntipoiva,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
	,lnctabanco,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
    ,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif;
    ,lndiasvto,lnplanpago
    
   	STORE "" TO lccnumero,lccnombre,lccdireccion,lccpostal,lcctelefono2,lcctelefono,lcemail,lccuit;
    ,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc
    
    STORE 1 TO 	lnctaacreedor, lnidcanalvta

	IF recno('FsrProveedor')/1000=INT(RECNO('FsrProveedor')/1000)
	   lcTitulo = "Proveedor "+STR(RECNO(),10)   
	   Oavisar.proceso('S',lcTitulo,.t.,recno())
	ENDIF
	nNumeroCtacte	= FsrProveedor.numero &&nNumeroCtacte + 1  
	lccnumero		= ALLTRIM(STR(50000+nNumeroCtacte))
	lccnombre		= ALLTRIM(FsrProveedor.nombre)
	lccdireccion	= ALLTRIM(FsrProveedor.direccion)
	lcctelefono		= ALLTRIM(FsrProveedor.telefono)
	ldfechalta		= DATETIME(1900,01,01,0,0,0)
	lcobserva		= FsrProveedor.observa
	ldfecins01		= DATETIME(1900,01,01,0,0,0)
	ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
	ldfecultpago	= DATETIME(1900,01,01,0,0,0)
	lcctelefono2 	= FsrProveedor.fax
	lntipoiva 		= FsrProveedor.tipocuit
	lccuit 			=FsrProveedor.cuit
*!*		IF lccuit='33-50265857-9'
*!*			stop()
*!*		ENDIF 
	lcLocalidadBuscada = Ciudades(FsrProveedor.Localidad)
	lnidplanpago	= 1100000002
	
	lcnumDoc		= ArmarDocumento(ALLTRIM(STR(VAL(SUBSTR(FsrProveedor.cuit,4)),8)))
	lctipodoc		= IIF(LEN(ALLTRIM(lcNumDoc))<10,'LC','DNI')

	SELECT CsrTipoDoc
	LOCATE FOR abrevia=lctipodoc
	IF abrevia=lctipodoc
		lnidtipodoc = CsrTipoDoc.id
	ENDIF 
			
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccpostal = CsrLocalidad.cpostal
	ELSE
		LOCATE FOR VAL(cpostal) = FsrProveedor.cp
		IF VAL(cpostal) = FsrProveedor.cp
			lnidlocalidad = CsrLocalidad.id
			lnidprovincia = CsrLocalidad.idprovincia
			lccpostal 		 = CsrLocalidad.cpostal
		ENDIF 
	ENDIF
	
	lnidcategoria 	= lnidcateacreedor

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
	
*!*		&&Agregamos movimiento por el saldo
*!*		SELECT FsrMovAcreedor
*!*		LOCATE FOR ALLTRIM(codigo) = ALLTRIM(FsrProveedor.proveedor)
*!*		IF ALLTRIM(codigo) = ALLTRIM(FsrProveedor.proveedor)
*!*			lnimporte=val(FsrMovAcreedor.Saldo)
*!*			lnsigno=1
*!*			replace Csrctacte.saldo WITH val(FsrMovAcreedor.Saldo) IN CsrCtacte
*!*			lnidcomproba=1100000048
*!*			lcclasecomp="F"
*!*			IF ALLTRIM(FsrMovAcreedor.debitocredito)$"CR"
*!*				lnsigno=-1
*!*				lnidcomproba=1100000049
*!*				lcclasecomp="G"
*!*			ENDIF
*!*			lnimporte		= lnimporte*lnsigno
*!*			lcletra			= "X"
*!*			lcnum			= strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0')
*!*			lcnumero		= lcletra+"0000"+lcnum
*!*			lcswitch		= "00000"
*!*			lnSaldo			= lnImporte
*!*			lcctacte		= CsrCtacte.cnumero
*!*			lnidctacte		= CsrCtacte.id
*!*			ldfechaserver	= DATETIME()
*!*			ldfechasis		= FechaHoraCero(ldfechaserver)
*!*			lcfiscal		= LEFT(DTOS(TTOD(ldfechasis)),6)
*!*			
*!*			INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor;
*!*			,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,detalle;
*!*			,fechaserver);
*!*			VALUES (lnidmaopera,"MOV","IMPORTACIÓN MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
*!*			,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,lcswitch,"0";
*!*			,"Importación. Compactación Mov Proveedor.",ldfechaserver)
*!*			
*!*			lcswitch		= "00100"
*!*			INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
*!*			,entrega,vencimien,total,detalle,pefiscal,switch,signo);
*!*			VALUES (lnidmovctacte,lnidmaopera,ldfechasis-1,lcctacte,lnidctacte," ",0,1,lnimporte;
*!*			,lnSaldo,0,ldfechasis-1,lnimporte,FsrMovAcreedor.codigo+" Saldo de Importación",SUBSTR(lcfiscal,1,6),lcswitch,lnsigno)
*!*			
*!*			lnidmovctacte=lnidmovctacte+1
*!*			lnidmaopera=lnidmaopera+1
*!*			
*!*		ENDIF 
	
	SELECT FsrPRoveedor         
ENDSCAN



Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
USE in FsrDeudor
USE in FsrProveedor 
*!*	USE IN FsrMovDeudor
*!*	USE IN FsrMovAcreedor


CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

