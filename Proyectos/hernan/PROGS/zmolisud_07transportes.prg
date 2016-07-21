PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF 
Oavisar.proceso('S','Vaciando archivos') 
SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
llok = .t.
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'Chofer',.t.)
llok = CargarTabla(lcData,'Camion',.t.)
SET SAFETY ON
IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE ALLTRIM(lcpath )+"\CEREALES\clientes" in 0 alias FsrTransporte EXCLUSIVE

USE ALLTRIM(lcpath )+"\CEREALES\camiones" in 0 alias FsrCamiones EXCLUSIVE

USE ALLTRIM(lcpath )+"\CEREALES\chofer" in 0 alias FsrChofer EXCLUSIVE



Oavisar.proceso('S','Procesando Clientes de cereales') 

lnid = RecuperarID('CsrCtacte',goapp.sucursal10)

SELECT FsrTransporte
GO top

STORE 0 TO lnidlocalidad,lntipoiva,lnctalogistica,lnctadeudor,lnctaacreedor,lnidcategoria,lnidprovincia
STORE 0 TO lnctabanco,lnctaotro,lnidplanpago,lnsaldo,lnsaldoant,lnestadocta,lnbonif1,lnbonif2
STORE 0 TO lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnidcateibrng,lncomision,lnidtipodoc
STORE 1 TO 	lnctadeudor,lnctaotro,lnlista, lnidcanalvta

SELECT MAX(VAL(cnumero)) as codigo FROM CsrCtacte INTO CURSOR CsrCodigo READWRITE 
lccnumero		= STR(CsrCodigo.codigo + 1,6)
lccnombre		= 'TRANSPORTE DEFAULT IMPORTACION'
lccdireccion	= ""
lccpostal		= ""
lcctelefono		= ""
lcemail			= ""
lccuit			= ""
ldfechalta		= DATETIME(1900,01,01,0,0,0)
lcobserva		= ""
lcinscri01		= ""
ldfecins01		= DATETIME(1900,01,01,0,0,0)
lcinscri02		= ""
lcinscri03		= ""
lcingbrutos		= ""
ldfecultcompra	= DATETIME(1900,01,01,0,0,0)
ldfecultpago	= DATETIME(1900,01,01,0,0,0)
lcnumdoc		= ""
lnexisteibto	= 0
lnexistegan 	= 0
lctelefono2 	= ""
lndiasvto		= 0
lntipocuit 		= 0
lcLocalidadBuscada = 0
lnidplanpago	= 0
lnidcategoria 	= 0
lntipoiva 		=0
lncuit			=''


INSERT INTO CsrCtacte (id ,cnumero ,cnombre ,cdireccion ,cpostal,idlocalidad, idprovincia ,ctelefono,email ;
,tipoiva,cuit ,idcategoria ,ctadeudor , ctaacreedor ,ctalogistica ,ctabanco,ctaotro;
,idplanpago,idcanalvta ,fechalta ,observa ,saldo ,saldoant ,estadocta ,bonif1 ;
,bonif2 ,copiatkt ,inscri01 ,fecins01, inscri02,inscri03 ,convenio ,saldoauto;
,idbarrio ,lista ,idcateibrng,ingbrutos,comision ,fecultcompra ,fecultpago;
, numdoc ,idtipodoc	,existeibto	,existegan,ctelefono2 ,diasvto );
values (lnid,lccnumero, lccnombre,lccdireccion,lccpostal, lnidlocalidad,  lnidprovincia,lcctelefono, lcemail;
, lntipoiva,lccuit, lnidcategoria, lnctadeudor , lnctaacreedor,lnctalogistica, lnctabanco, lnctaotro;
, lnidplanpago, lnidcanalvta, ldfechalta, lcobserva, lnsaldo, lnsaldoant, lnestadocta, lnbonif1;
, lnbonif2, lncopiatkt, lcinscri01, ldfecins01, lcinscri02, lcinscri03, lnconvenio, lnsaldoauto;
, lnidbarrio, lnlista,lnidcateibrng, lcingbrutos, lncomision, ldfecultcompra, ldfecultpago;
, lcnumdoc, lnidtipodoc,lnexisteibto, lnexistegan, lctelefono2, lndiasvto )


*** filtramos solo los transportes
SELECT CsrCtacte
SET FILTER TO ctadeudor = 1 

lnid = RecuperarID('CsrChofer',goapp.sucursal10)

SELECT FsrChofer
Oavisar.proceso('S','Procesando los choferes') 
GO top
SCAN FOR !EOF()
		IF numero=0
        	LOOP 
        ENDIF
        lcnombre = NombreNI(UPPER(FsrChofer.nombre))
        lccuit 	 = STRTRAN(FsrChofer.carnet,'-','')
        lccuit 	 = STRTRAN(lccuit,'/','')
        lccuit 	 = cuit(ALLTRIM(lccuit))
        lnnumero = FsrChofer.numero
        lcnumdoc = ArmarDocumento(SUBSTR(FsrChofer.documento,1,8))
        lnidctacte = CsrCtacte.id
        lnidtipodoc= 1
        SELECT CsrCtacte
        LOCATE FOR cnumero=LTRIM(STR(FsrChofer.empresa))
        IF cnumero=LTRIM(STR(FsrChofer.empresa))
        	lnidctacte = CsrCtacte.id
        	replace ctaotro WITH 1 IN CsrCtacte
        ENDIF 
        
		INSERT INTO CsrChofer (id,numero,nombre,cuit,numdoc,idctatransp,idtipodoc);
		VALUES (lnid,lnnumero,lcnombre,lccuit,lcnumdoc,lnidctacte,lnidtipodoc)
      	lnid = lnid + 1
		SELECT FsrChofer
ENDSCAN
SELECT CsrCtacte
SET FILTER TO

lnid = RecuperarID('CsrCamion',goapp.sucursal10)
lnnumero = 0
SELECT FsrCamiones
Oavisar.proceso('S','Procesando Camiones') 
GO top
SCAN FOR !EOF()
		IF EMPTY(numero)
        	LOOP 
        ENDIF
        lcnombre = NombreNi(UPPER(FsrCamiones.nombre))
        lcpatente = LTRIM(FsrCamiones.numero)
        lnnumero = lnnumero+1
        lcmarca  = NombreNi(UPPER(FsrCamiones.marca))
        lccolor	 = NombreNi(UPPER(FsrCamiones.color))
        lntara 	 = FsrCamiones.tara
        lcswitch = '00001'
        lnidctacte = 0
        SELECT CsrCtacte
        LOCATE FOR cnumero=LTRIM(STR(FsrCamiones.empresa))
        IF cnumero=LTRIM(STR(FsrCamiones.empresa))
        	lnidctacte = CsrCtacte.id
        	replace ctaotro WITH 1 IN CsrCtacte
        ENDIF 
        lnidchofer = 0
        SELECT CsrChofer
        LOCATE FOR numero = FsrCamiones.chofer
        IF numero = FsrCamiones.chofer
        	lnidchofer = CsrChofer.id
        ENDIF 
		INSERT INTO CsrCamion (id,numero,nombre,switch,idctatransp,idchofer,patente,marca,color,tara);
		VALUES (lnid,lnnumero,lcnombre,lcswitch,lnidctacte,lnidchofer,lcpatente,lcmarca,lccolor,lntara)
      	lnid = lnid + 1
		SELECT FsrCamiones
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE in FsrTransporte

USE IN FsrCamiones

USE IN FsrChofer