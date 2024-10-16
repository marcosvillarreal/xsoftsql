PARAMETERS ldfecha,lcpath,lcbase
lcfecha = IIF(PCOUNT()< 1,"01-08-2010",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcdata = lcbase
LOCAL lnid

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
Oavisar.proceso('S','Abriendo archivos') 
llok = .t.

llok = CargarTabla(lcData,'MovCtacte')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'TablaOpe')
llok = CargarTabla(lcData,'AfeCtacte',.t.)

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON

USE  ALLTRIM(lcpath )+"\gestion\afectaci" in 0 alias FsrAfectaci EXCLUSIVE

SELECT FsrAfectaci.* FROM FsrAfectaci WHERE estado<>"A" ORDER BY orden INTO CURSOR FsrAfectador READWRITE 

*fecha de importacion
ldfecha		=CTOD(lcfecha)

LOCAL nId 
nId	= RecuperarID('CsrAfeCtacte',Goapp.sucursal10)


SELECT FsrAfectador
GO TOP 
SCAN 
	&&Si el orden y el ordenafe no estan en el tabla ope, la afectacion esta compactada
	SELECT CsrTablaOpe
	LOCATE FOR orden = VAL(FsrAfectador.orden)
	IF orden != VAL(FsrAfectador.orden)
		SELECT CsrTablaOpe
		LOCATE FOR orden = VAL(FsrAfectador.ordenafe)
		IF orden != VAL(FsrAfectador.ordenafe)
			SELECT FsrAfectador
			LOOP 
		ENDIF 
	ENDIF 
	
	&&Hay tres casos
	&&Esta el Credito (Recibo) y no esta el afectador. Imputamos el movimiento debirto o credito que corresponda al cliente.
	&&Esta el Debito (Factura) y no esta el afectador. Imputamos el movimiento debirto o credito que corresponda al cliente.
	&&Esta el Credito y el Debito. Se imputan los comprobantes.
	
	STORE 0 TO nIdMaoperaD,nIdMaoperaH,nIdHaber,nIdDebe
	&&1 y 3
	SELECT CsrTablaOpe
	IF orden = VAL(FsrAfectador.orden)
		nIdmaoperaH = CsrTablaOpe.idmaopera
		SELECT CsrMovCtacte
		LOCATE FOR idmaopera = nIdmaoperaH
		nIdHaber = CsrMovCtacte.id
		nIdCtacte = CsrMovCtacte.idctacte
		
		&&Si el afectado no esta, es el caso uno. en caso contrario es el 3
		SELECT CsrTablaOpe
		LOCATE FOR orden = VAL(FsrAfectador.ordenafe)
		IF orden = VAL(FsrAfectador.ordenafe)
			&&Caso 3
			nIdMaoperaD = CsrTablaOpe.idmaopera
			SELECT CsrMovCtacte
			LOCATE FOR idmaopera = nIdMaoperaD
			nIdDebe = CsrMovCtacte.id
		ELSE
			SELECT CsrMovCtacte
			LOCATE FOR idctacte = nIdCtacte AND signo = 1 AND switch = "00100"
			IF idctacte = nIdCtacte AND signo = 1 AND switch = "00100"
				nIdMaoperaD = CsrMovCtacte.idmaopera
				nIdDebe = CsrMovCtacte.id
			ENDIF 
		ENDIF 
		INSERT INTO CsrAfeCtacte (id,idmaoperad,iddebe,idmaoperah,idhaber,importe);
		VALUES (nId,nIdMaoperaD,nIdDebe,nIdMaoperaH,nIdHaber,ABS(FsrAfectador.importe))
		nId = nId + 1 
		
		SELECT FsrAfectador
		LOOP 
	ENDIF 
	
	&&2
	SELECT CsrTablaOpe
	IF orden = VAL(FsrAfectador.ordenafe)
		nIdMaoperaD = CsrTablaOpe.idmaopera
		SELECT CsrMovCtacte
		LOCATE FOR idmaopera = nIdMaoperaD
		nIdDebe = CsrMovCtacte.id 
		
		SELECT CsrMovCtacte
		LOCATE FOR idctacte = nIdCtacte AND signo = -1 AND switch = "00100"
		IF idctacte = nIdCtacte AND signo = -1 AND switch = "00100"
			nIdMaoperaH = CsrMovCtacte.idmaopera
			nIdHaber = CsrMovCtacte.id
		ENDIF 
		
		INSERT INTO CsrAfeCtacte (id,idmaoperad,iddebe,idmaoperah,idhaber,importe);
		VALUES (nId,nIdMaoperaD,nIdDebe,nIdMaoperaH,nIdHaber,ABS(FsrAfectador.importe))
		nId = nId + 1 
		SELECT FsrAfectador
		LOOP 
	ENDIF 
	
ENDSCAN 


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

USE IN FsrAfectaci
USE IN FsrAfectador

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES