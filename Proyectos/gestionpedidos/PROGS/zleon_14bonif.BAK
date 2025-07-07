PARAMETERS ldvacio,lcpath
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)

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
llok = CargarTabla('leon','BoniCtacte',.t.)
llok = CargarTabla('leon','Ctacte',.f.)
llok = CargarTabla('leon','Producto',.f.)
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
		
	lnBonifica = CsrBoniCliente.Bonif
	ldFecha = IIF(EMPTY(CsrBoniCliente.fechafin),CTOD('01-01-1900'),CsrBoniCliente.fechafin)
	
	INSERT INTO CsrBoniCtacte(id,idctacte,idproducto,bonifica,fecha);
	VALUES (lnid,lnidctacte,lnidproducto,lnbonifica,ldfecha)
	lnid = lnid + 1 
	SELECT CsrBoniCliente
ENDSCAN 

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE IN CsrBoniCliente
