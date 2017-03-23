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
llok = CargarTabla(lcbdd,'Vendedor',.t.)


SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 
USE  ALLTRIM(lcpath)+"\remitos" in 0 alias FsrRemito EXCLUSIVE

LOCAL lnid
nid = RecuperarID('CsrVendedor',Goapp.sucursal10)

SELECT distinct quien as nombre FROM FsrRemito INTO CURSOR FsrVendedor READWRITE 

nNumero = 0
SELECT FsrVendedor
GO TOP
SCAN
	nnumero	= NNUMERO + 1
	cnombre	= nombre
	STORE "" TO cclave,cdireccion
	STORE 0 TO nidctaflete,nplanilla,ncomision,nidctacomision,nidctasueldo,nidgrupocomi;
				,nidctacte,nacumulavale
    nestado	= 1 
    nlista	= 1
    nprevta	= 1
	INSERT INTO Csrvendedor(id,numero,nombre,clave,idctaflete,planilla,comision;
           ,estado,idctacomision,idctasueldo,prevta,idgrupocomi,lista,idctacte;
           ,acumulavale);
     VALUES (nid,nnumero,cnombre,cclave,nidctaflete,nplanilla,ncomision;
           ,nestado,nidctacomision,nidctasueldo,nprevta,nidgrupocomi,nlista,nidctacte;
           ,nacumulavale)
	
	nid = nid + 1 
ENDSCAN 



Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
USE in FsrRemito


CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

