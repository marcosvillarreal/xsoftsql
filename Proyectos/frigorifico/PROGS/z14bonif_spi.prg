PARAMETERS ldvacio,lcpath,lcbase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcdata = lcbase

LOCAL llok,lnid
DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'BoniCtacte',.t.)
llok = CargarTabla(lcData,'Ctacte',.f.)
llok = CargarTabla(lcData,'Producto',.f.)
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

USE ALLTRIM(lcpath)+"\gestion\bonicli" IN 0 ALIAS CsrBoniCliente EXCLUSIVE 

Oavisar.proceso('S','Procesando '+alias()) 

lnid = RecuperarID('CsrBonictacte',Goapp.sucursal10)

SELECT CsrBoniCliente
GO TOP 
SCAN 
	STORE 0 TO lnidctacte,lnidproducto,lnbonifica
	
	SELECT CsrCtacte
	LOCATE FOR VAL(cnumero) = CsrBoniCliente.cliente
	lnidctacte = IIF(FOUND() AND VAL(cnumero) = CsrBoniCliente.cliente,CsrCtacte.id,0)
	
	SELECT CsrProducto
	LOCATE FOR numero = CsrBoniCliente.articulo
	lnidproducto = IIF(FOUND() and numero = CsrBoniCliente.articulo,CsrProducto.id,0)
		
	lnBonifica = IIF(EMPTY(CsrBoniCliente.fecha_ofer),0,CsrBoniCliente.Bonif)
	ldFecha = IIF(EMPTY(CsrBoniCliente.fecha_ofer),CTOD('01-01-1900'),CsrBoniCliente.fecha_ofer)
	
	IF lnidctacte<>0 AND lnidproducto<>0
		INSERT INTO CsrBoniCtacte(id,idctacte,idproducto,bonifica,fecha);
		VALUES (lnid,lnidctacte,lnidproducto,lnbonifica,ldfecha)
		lnid = lnid + 1 
	ENDIF 
	SELECT CsrBoniCliente
ENDSCAN 

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE IN CsrBoniCliente
