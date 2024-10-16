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

llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'CtacteCtaCon',.t.)

SET SAFETY ON
IF !llok
	RETURN .f.
ENDIF

USE ALLTRIM(lcpath)+"\gestion\proveed" in 0 alias FsrProveedor EXCLUSIVE

lnid=RecuperarID('CsrCtacteCtaCon',goapp.sucursal10)
SELECT FsrProveedor
Oavisar.proceso('S','Procesando los proveedores con la cuenta contable') 
GO top
SCAN FOR !EOF()
	STORE 0 TO lnIdctavta,lnIdctacpra,lnCuenta
	
	lncuenta = FsrProveedor.cuenta
	
	SELECT CsrCtacte
	LOCATE FOR cnumero = ALLTRIM(STR(3000+FsrProveedor.numero))
	IF !cnumero = ALLTRIM(STR(3000+FsrProveedor.numero))
		LOOP 
	ENDIF 
		
*!*		SELECT CsrPlanCue 
*!*		LOCATE FOR cuenta = lnCuenta
*!*		IF cuenta = lnCuenta
*!*			lnIdCtaVta = CsrPlancue.id
*!*		ENDIF 
	
	SELECT CsrPlanCue 
	LOCATE FOR cuenta = lnCuenta
	IF cuenta = lnCuenta
		lnIdCtaCpra = CsrPlancue.id
	ENDIF 
	
	lnIdEjercicio = Goapp.idejercicio
	lnidctacte = CsrCtaCte.id
	
   	INSERT INTO CsrCtacteCtaCon(id,idejercicio,idctacte,idctavta,idctacpra);
    VALUES (lnId, lnidejercicio,lnidctacte,lnidctavta,lnidctacpra)
    
    lnId = lnId +1  	
	
	SELECT FsrProveedor
ENDSCAN
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	