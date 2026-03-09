PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcbdd,lcfecha,lnid
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrConfiguracion.* FROM ParaConfig as CsrConfiguracion WHERE idejercicio = <<goapp.idejercicio>>
ENDTEXT 
IF !CrearCursorAdapter('CsrConfiguracion',lccmd) OR RECCOUNT('CsrConfiguracion')=0
	MESSAGEBOX('Nose puede seguir importando, porque nose puedo cargar el ParaConfig')
	RETURN .f.
ENDIF 

Oavisar.proceso('S','Vaciando archivos') 
SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Vaciando archivos') 
llok = .t.
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'CtacteCtaCon')
llok = CargarTabla(lcData,'TipoIva')
llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Categoiva')
llok = CargarTabla(lcData,'PlanPago')
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Valor')
llok = CargarTabla(lcData,'MovBcocar')
llok = CargarTabla(lcData,'Maopera')
llok = CargarTabla(lcData,'AfeConcilia',.t.)

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE  ALLTRIM(lcpath)+"\gestion\ctabco" in 0 alias FsrCliente EXCLUSIVE
USE  ALLTRIM(lcpath)+"\gestion\valores" in 0 alias FsrValor EXCLUSIVE
USE  ALLTRIM(lcpath)+"\gestion\movbacte" IN 0 alias FsrMovBcocar EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 
SELECT * FROM FsrCliente ORDER BY numero INTO CURSOR FsrBanco

lnid			= RecuperarID('CsrCtacte',Goapp.sucursal10)
lnidctacon 		= RecuperarID('CsrCtacteCtaCon',goapp.sucursal10)
lnidmovbcocar 	= RecuperarID('CsrMovBcocar',goapp.sucursal10)
lnidmaopera	  	= RecuperarID('CsrMaopera',goapp.sucursal10)
lnidafeconcilia = RecuperarID('CsrAfeConcilia',goapp.sucursal10)

SET SAFETY OFF
CREATE CURSOR FsrAfeConcilia (idmaopera n(12,0), clave c(8))
SELECT FsrAfeConcilia
INDEX on clave TAG clave
SET SAFETY ON 

LOCAL lnidlocalidad,lnidprovincia,lntipoiva,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
,lnctabanco,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif,lnidcategoria;
,lccnumero,lccnombre,lccdireccion,lccpostal,lcctelefono2,lcctelefono,lcemail,lccuit;
,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc

SELECT FsrBanco
Oavisar.proceso('S','Procesando bancos') 	
GO  TOP 
SCAN 
	STORE 0 TO lnidlocalidad,lnidprovincia,lntipoiva,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
	,lnctabanco,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
    ,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif,lnidcategoria
    
   STORE "" TO lccnumero,lccnombre,lccdireccion,lccpostal,lcctelefono2,lcctelefono,lcemail,lccuit;
    ,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc
    
     IF recno('FsrBanco')/500=INT(RECNO('FsrBanco')/500)
	   lcTitulo = "Bancos "+STR(RECNO(),10)   
	   Oavisar.proceso('S',lcTitulo,.t.,recno())
	 ENDIF
    
    STORE 1 TO 	lnctabanco, lnidcanalvta
    
	lnestadocta		= 0
	SELECT MAX(VAL(cnumero)) as codigo FROM CsrCtacte INTO CURSOR CsrCodigo READWRITE 
    lccnumero	= ALLTRIM(STR(CsrCodigo.codigo + 1,6))
    
	lccnombre		= 'BANCO '+ALLTRIM(IIF(EMPTY(FsrBanco.banco),FsrBanco.nombre,FsrBanco.banco))+ALLTRIM(FsrBanco.numero)
	lccdireccion	= ""
	lccpostal		= ""
	lcctelefono		= ""
	lcemail			= ""
	lccuit			= ""
	ldfechalta		= DATETIME(1900,01,01,0,0,0)
	lcobserva		= FsrBanco.numero
	lcinscri01		= ""
	ldfecins01		= DATETIME(1900,01,01,0,0,0)
	lcinscri02		= ""
	lcinscri03		= ""
	lcingbrutos		= ""
	ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
	ldfecultpago	= DATETIME(1900,01,01,0,0,0)
	lcctelefono2 	= ""
	lndiasvto		= 0
	lntipoiva 		= 0
	lcLocalidadBuscada = ""
	lnidplanpago	= 1100000001
	lnplanpago		= 0
	lntotalizabonif	= 0
	lnesrecodevol	= 0
	
	lnidlocalidad 	= 0
	lnidprovincia 	= 0
	lccpostal		= ""
	lccp = ""
			
	SELECT CsrPlanPago
	LOCATE FOR numero = "CCT"
	lnidplanpago = CsrPlanPago.id
	
	SELECT CsrCateCtacte
	LOCATE FOR ALLTRIM(nombre) = "CTA CTE BANCO"
	IF FOUND()
		lnidcategoria = CsrCateCtacte.id
	ENDIF 
	
	lccuit =""
	SELECT CsrCategoiva
	LOCATE FOR ALLTRIM(abrevia )= "RI"
	IF ALLTRIM(abrevia )= "RI"
		lntipoiva = CsrCategoiva.id
	ENDIF
			
	lccnombre = NombreNi(ALLTRIM(UPPER(lccnombre)))
	lccdireccion = NombreNi(ALLTRIM(UPPER(lccdireccion)))
     
      
	INSERT INTO Csrctacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia;
	,ctelefono,email,tipoiva,cuit,idcategoria,ctadeudor,ctaacreedor,ctalogistica,ctabanco,ctaotro;
	,idplanpago,idcanalvta,fechalta,observa,saldo,saldoant,estadocta,bonif1,bonif2,copiatkt;
	,inscri01,fecins01,inscri02,inscri03,convenio,saldoauto,idbarrio,lista,idcateibrng,ingbrutos;
	,comision,fecultcompra,fecultpago,esrecodevol;
	,totalizabonif);
    VALUES(lnid,lccnumero,lccnombre,lccdireccion,lccpostal,lnidlocalidad,lnidprovincia;
    ,lcctelefono,lcemail,lntipoiva,lccuit,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica,lnctabanco;
    ,lnctaotro,lnidplanpago,lnidcanalvta,ldfechalta,lcobserva,lnsaldo,lnsaldoant,lnestadocta;
    ,lnbonif1,lnbonif2,lncopiatkt,lcinscri01,ldfecins01,lcinscri02,lcinscri03,lnconvenio,lnsaldoauto;
    ,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
    ,lnesrecodevol,lntotalizabonif)
    
    *Agragamos la cuenta contable del banco
    lncuenta = FsrBanco.cuenta
    STORE 0 TO lnIdCtaVta,lnIdCtaCpra
    
    SELECT CsrPlanCue 
	LOCATE FOR cuenta = lnCuenta
	IF cuenta = lnCuenta
		lnIdCtaVta = CsrPlancue.id
	ENDIF 
	
	SELECT CsrPlanCue 
	LOCATE FOR cuenta = lnCuenta
	IF cuenta = lnCuenta
		lnIdCtaCpra = CsrPlancue.id
	ENDIF 
	
	lnIdEjercicio = Goapp.idejercicio
	lnidctacte = CsrCtaCte.id
	
   	INSERT INTO CsrCtacteCtaCon(id,idejercicio,idctacte,idctavta,idctacpra);
    VALUES (lnIdctacon, lnidejercicio,lnid,lnidctavta,lnidctacpra)
    
    *agregamos a los valores la referencia al banco
    SELECT FsrValor
    GO TOP 
    SCAN 
    	IF !(ALLTRIM(FsrBanco.numero)$ALLTRIM(FsrValor.ctabco))
    		LOOP 
    	ENDIF 
    	SELECT CsrValor
    	LOCATE FOR numero = FsrValor.numero
    	IF numero = FsrValor.numero
    		replace idctabco WITH lnid IN CsrValor
    	ENDIF 
    	SELECT FsrValor
    ENDSCAN 
    
    lnId = lnId +1  	
	lnIdctacon = lnidctacon + 1
	 
	SELECT FsrBanco      
ENDSCAN

LOCAL lcorigen,lnimporte,lnidtipomov,lnnumero,lnidctabco,lcbanco,lclocalidad
local ldfecha,ldfechavto,lccuit,lctitular,lcrecibido,lcentregado,lcdetalle,lnsigno,lcswitch
LOCAL lcprograma,lnsucursal,lnterminal,lnsector, ldfechasis, lnidoperador,lnidvendedor
LOCAL lniddetanrocaja,lnidcomproba, lcnumcomp, lcclasecomp, lnturno,lnpuestocaja, lnidcotizadolar
LOCAL lcswitch, lcestado,lcdetalle, ldfechaserver       

SELECT FsrMovBcocar
Oavisar.proceso('S','Procesando movimientos bancarios') 	
GO  TOP 
SCAN 
	STORE 0 TO lnimporte,lnidtipomov,lnnumero,lnidctabco,lnsigno,lnsucursal,lnterminal,lnsector
	STORE 0 TO lnidoperador,lnidvendedor,lniddetanrocaja,lnidcomproba,lnturno,lnpuestocaja, lnidcotizadolar
           
    STORE "" TO lcorigen,lcbanco,lclocalidad,lccuit,lctitular,lcrecibido,lcentregado,lcdetalle,lcswitch
    STORE "" TO lcprograma,lcnumcomp,lcclasecomp,lcswitch,lcestado,lcdetalle
           
   
                 
	IF recno('FsrMovBcocar')/500=INT(RECNO('FsrMovBcocar')/500)
		lcTitulo = "Movimientos Bancarios "+STR(RECNO(),10)   
	   	Oavisar.proceso('S',lcTitulo,.t.,recno())
	ENDIF
    
    ldfecha			= DATETIME(1900,01,01,0,0,0)
    ldfechavto		= DATETIME(1900,01,01,0,0,0)
    
    DO CASE 
    	CASE FsrMovBcocar.tipocomp = 1
    		lnidcomproba = 19
    		lcclasecomp	 = "S"
    		lcesclase	 = "H"
    	CASE FsrMovBcocar.tipocomp = 2
    		lnidcomproba = 21
    		lcclasecomp	 = "R"
    		lcesclase	 = "D"
    	CASE FsrMovBcocar.tipocomp = 3
    		lnidcomproba = 16
    		lcclasecomp	 = "O"
    		lcesclase	 = "P"
    	CASE FsrMovBcocar.tipocomp = 4
    		lnidcomproba = 17
    		lcclasecomp	 = "P"
    		lcesclase	 = "D"
    	CASE FsrMovBcocar.tipocomp = 5
    		lnidcomproba = 18
    		lcclasecomp	 = "Q"
    		lcesclase	 = "T"
    ENDCASE 
    	
    lcorigen		= "BCO"
    lcprograma		= "MOV. IMPORTADO"
    lnsucursal		= goapp.sucursal
    lnterminal		= goapp.terminal
    lnsector		= 1
    lnidoperador	= 1
    lnidvendedor	= 0
    lniddetanrocaja	= CsrConfiguracion.iddetanrocaja
    lcnumcomp		= LEFT(TRIM(FsrMovBcocar.origen),1)+strzero(FsrMovBcocar.numcomp,12,0)
    lnturno			= 1
    lnpuestocaja	= 1
    lnidcotizadolar	= CsrConfiguracion.idcotizadolar
    lnEntregar		= 0&&IIF(entregado,1,0)+IIF(despositado,1,0)
    lcSwitch		= IIF(lnEntregar>1,'1','0')+"0000"
    lcestado		= "0"
    lcdetalle		= "Movimiento Importado"
    ldfechaserver	= DATETIME()
	ldfechasis		= FechaHoraCero(ldfechaserver)
 
    INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor,;
   			iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,;
       		detalle,fechaserver);
    VALUES (lnidmaopera,lcorigen,lcprograma,lnsucursal,lnterminal,lnsector, ldfechasis, lnidoperador,lnidvendedor,;
           lniddetanrocaja,lnidcomproba, lcnumcomp, lcclasecomp, lnturno,lnpuestocaja, lnidcotizadolar, ;
           lcswitch, lcestado,lcdetalle, ldfechaserver)
    
    lcorigen	= "PROP"
    lnimporte	= FsrMovBcocar.importe
    lnidtipomov	= lnidcomproba
    lnnumero	= FsrMovBcocar.numcomp
    lclocalidad	= ""
    ldfecha		= FsrMovBcocar.fecha
    ldfechavto	= FsrMovBcocar.fecha_vto
    lccuit		= ""
    lctitular	= ""
    lcrecibido	= ""
    lcentregado	= FsrMovBcocar.entregadoa
    lcdetalle	= FsrMovBcocar.detalle
    lnsigno		= IIF(trim(lcclasecomp)$'OR',-1,1)
    lcswitch	= '00000'
    
    SELECT CsrCtacte 
    LOCATE FOR VAL(observa) = VAL(FsrMovBcocar.cuenta)
    IF VAL(observa) = VAL(FsrMovBcocar.cuenta)
    	lnidctabco 	= CsrCtacte.id
    	lcbanco		= CsrCtacte.cnombre
    ENDIF 
    
    INSERT INTO CsrMovBcocar (id,idmaopera,origen,importe,idtipomov,numero,idctabco,banco,localidad,;
           fecha,fechavto,cuit,titular,recibido,entregado,detalle,signo,switch);
    VALUES(lnidmovbcocar,lnidmaopera,lcorigen,lnimporte,lnidtipomov,lnnumero,lnidctabco,lcbanco,lclocalidad,;
           ldfecha,ldfechavto,lccuit,lctitular,lcrecibido,lcentregado,lcdetalle,lnsigno,lcswitch)
   
   	
    lnidmaopera     = lnidmaopera  + 1  
    
    &&Si esta conciliado lo unimos a una conciliacion lote es por la fecha para la importación.
    IF FsrMovBcocar.conciliado
		lcclave = DTOS(FsrMovBcocar.fecha_conc)
		IF !SEEK(lcclave,"FsrAfeConcilia","clave") 
		   	
		   	lcorigen	= "CBN"
		   	lcnumcomp	= SPACE(5)+lcclave
		   	lcprograma	= "REGCONCILIA"
		   	lnidcomproba= 0
		   	lcclasecomp	= ""
 	
    		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor,;
    			iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,;
           		detalle,fechaserver);
   		 	VALUES (lnidmaopera,lcorigen,lcprograma,lnsucursal,lnterminal,lnsector, ldfechasis, lnidoperador,lnidvendedor,;
           		lniddetanrocaja,lnidcomproba, lcnumcomp, lcclasecomp, lnturno,lnpuestocaja, lnidcotizadolar, ;
           		lcswitch, lcestado,lcdetalle, ldfechaserver)
        	
           	INSERT INTO FsrAfeConcilia (idmaopera,clave) VALUES (lnidmaopera,lcclave)
           		
           	lnidmaopera = lnidmaopera  + 1 
        ENDIF 
        lnidMaopeAfe	= FsrAfeConcilia.idmaopera
        lcswitch 		= "00000"
           
    	INSERT INTO Csrafeconcilia (id,idmaopera,idmovbcocar,switch);
		VALUES (lnidafeconcilia,lnidMaopeAfe,lnidmovbcocar,lcswitch)
		
		lnidafeconcilia = lnidafeconcilia + 1 
		
		
    ENDIF  
   
   	lnidmovbcocar	= lnidmovbcocar + 1
	SELECT FsrMovBcocar      
ENDSCAN

replace ALL observa WITH "" FOR ctabanco = 1 IN CsrCtacte

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

USE in FsrBanco 
USE in FsrCliente
USE in FsrValor

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

