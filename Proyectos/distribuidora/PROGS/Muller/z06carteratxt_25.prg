PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 
SET PROCEDURE TO z00_25 ADDITIVE 
SET PROCEDURE  TO  procimportar.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

*stop()
cArchivo = ADDBS(ALLTRIM(lcpath ))+"cartera.csv"
=LeerCartera_25(cArchivo )
SELECT CsrCartera
*stop()


SET SAFETY OFF

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Maopera',.t.)
llok = CargarTabla(lcData,'MovBcocar',.t.)
llok = CargarTabla(lcData,'MovBcoDeta',.t.)

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT Csrcomprobante.* FROM comprobante as Csrcomprobante WHERE regisc=1 and clase='O' 
ENDTEXT 
=CrearCursorAdapter('CsrComprobante',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT MAX(id) as id FROM maopera 
ENDTEXT 
=CrearCursorAdapter('FsrID',lcCmd)
lnidmaopera = FsrID.id + 1 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT MAX(id) as id FROM movbcocar 
ENDTEXT 
=CrearCursorAdapter('FsrID',lcCmd)
lnidmovbcocar = FsrID.id + 1
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT MAX(id) as id FROM movbcodeta 
ENDTEXT 
=CrearCursorAdapter('FsrID',lcCmd)
lnidmovbcodeta= FsrID.id + 1
*lnidmaopera = RecuperarID('CsrMaopera',Goapp.sucursal10)
*lnidmovbcocar = RecuperarID('CsrMovBcocar',Goapp.sucursal10)
*lnidmovbcodeta= RecuperarID('CsrMovBcoDeta',Goapp.sucursal10)

stop()
SELECT CsrCartera
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP 
SCAN FOR !EOF()
	
	SELECT CsrComprobante
	GO TOP 
	lnidcomproba = CsrComprobante.id
	lcclasecomp = CsrComprobante.clase
	lnidvalor = 0
	
	lcswitch = '00000'
	lcdetalle = ''
	ldfechasis = dtot(CTOD(CsrCartera.fecha))
	lcnumcomp = " 0000" + strzero(VAL(CsrCartera.numero),8)
	lniddetanrocaja = 0
	
	SELECT CsrMaopera
	APPEND BLANK
	replace id WITH lnidmaopera, origen WITH 'CAR', programa WITH 'regcartera'
	replace sucursal WITH goapp.sucursal, terminal WITH 0, sector WITH 0
	replace fechasis WITH ldfechasis, idoperador WITH 0, idvendedor WITH 0
	replace iddetanrocaja WITH lniddetanrocaja, idcomproba WITH lnidcomproba 
	replace numcomp WITH lcnumcomp, clasecomp WITH lcclasecomp
	replace turno WITH 1, puestocaja WITH 0, idcotizadolar WITH 0
	replace switch WITH lcSwitch, estado WITH '0', detalle WITH lcDetalle
	replace fechaserver WITH DATETIME()
	
*!*		INSERT INTO Csrmaopera (id,origen,programa,sucursal,terminal,sector,fechasis;
*!*	           ,idoperador,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp;
*!*	           ,turno,puestocaja,idcotizadolar,switch,estado,,detalle,fechaserver);
*!*	    VALUES (lnidmaopera,'CAR','regcartera',goapp.sucursal,0,0,ldfechasis,0;
*!*	            ,0,lniddetanrocaja,lnidcomproba,lcnumcomp,lcclasecomp,1,0;
*!*	            ,0,lcswitch,'0',lcdetalle,DATETIME())
	
	
	
	
	
	ldfecha		= dtot(CTOD(CsrCartera.femision))
	lnimporte   = VAL(CsrCartera.importe)
	lnnrocheque	= VAL(CsrCartera.numero)
	lcrecibido  = CsrCartera.cliente
	lctitular   = CsrCartera.titular
	lclocalidad = 'GENERAL M. CAMPOS'
	lccuit      = PeloCuit(CsrCartera.cuit)
	lcbanco     = CsrCartera.banco
	lcdetalle = ''
	lnidtipomov = lnidcomproba 
	
	INSERT INTO Csrmovbcocar(id,idmaopera,origen,importe,idtipomov,numero,idctabco;
           ,banco,localidad,fecha,fechavto,cuit,titular,recibido,entregado;
           ,detalle,signo,switch);
    VALUES (lnidmovbcocar ,lnidmaopera,'3RO',lnimporte,lnidtipomov,lnnrocheque,0,lcbanco;
           ,lclocalidad,ldfecha,ldfecha,lccuit,lctitular,lcrecibido,'',lcdetalle;
           ,1,lcswitch)

	INSERT INTO Csrmovbcodeta(id,idmovbcocar,codbarra,cuit,idvalor);
    VALUES (lnidmovbcodeta,lnidmovbcocar,'',lccuit,lnidvalor)
    
    lnidmaopera = lnidmaopera + 1 
	lnidmovbcocar = lnidmovbcocar + 1 
	lnidmovbcodeta = lnidmovbcodeta + 1 

	
	SELECT CsrCartera				
ENDSCAN

SELECT Csrmovbcocar
GO TOP 
vista()

   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')


CLOSE tables
CLOSE INDEXES
CLOSE DATABASES