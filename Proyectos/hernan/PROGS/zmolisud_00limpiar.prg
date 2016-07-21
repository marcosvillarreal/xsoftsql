PARAMETERS ldfecha,lcpath,lcBase
LOCAL lcfecha,lnid,lcData
lcfecha = IIF(PCOUNT()< 1,"01-08-2010",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

Oavisar.proceso('S','Abriendo archivos') 
TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrParaConta.* FROM ParaConta as CsrParaConta
where idejercicio = <<goapp.idejercicio>>
ENDTEXT 
IF !CrearCursorAdapter('CsrParaConta',lccmd)
	MESSAGEBOX('Nose puede importar, pq no cargado el CsrParaConta')
	RETURN .f.
ENDIF 

Oavisar.proceso('S','Vaciando archivos') 

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

llok = .t.
llok = CargarTabla(lcData,'Maopera',.t.)
llok = CargarTabla(lcData,'MovCtacte',.t.)
llok = CargarTabla(lcData,'CabeCpra',.t.)
llok = CargarTabla(lcData,'CabeFac',.t.)
llok = CargarTabla(lcData,'CuerFac',.t.)
llok = CargarTabla(lcData,'CuerVari',.t.)
llok = CargarTabla(lcData,'CuerCpra',.t.)
llok = CargarTabla(lcData,'TablaImp',.t.)
llok = CargarTabla(lcData,'RenCtacte',.t.)
llok = CargarTabla(lcData,'MovCaja',.t.)
llok = CargarTabla(lcData,'MovBcocar',.t.)
llok = CargarTabla(lcData,'FuerzaVta',.t.)
llok = CargarTabla(lcData,'CabeAsi',.t.)
llok = CargarTabla(lcData,'AfeBcocar',.t.)
llok = CargarTabla(lcData,'DetaNroCaja',.t.)
llok = CargarTabla(lcData,'AfeCtacte',.t.)
llok = CargarTabla(lcData,'Emaopera',.t.)
llok = CargarTabla(lcData,'Ctacte',.t.)
llok = CargarTabla(lcData,'TablaAsi',.t.)
llok = CargarTabla(lcData,'CBU',.t.)
llok = CargarTabla(lcData,'CuerRuta',.t.)
llok = CargarTabla(lcData,'CabeRuta',.t.)

SET SAFETY ON 
IF !llok
	RETURN .f.
ENDIF

LOCAL lnid
lnid 			= RecuperarID('CsrFuerzaVta',Goapp.sucursal10)
lniddetanrocaja = RecuperarID('CsrDetanroCaja',Goapp.sucursal10)


INSERT INTO Csrfuerzavta (id,numero,nombre) VALUES (lnid,1,"FUERZA VTA 1")
lnid = lnid + 1 
INSERT INTO Csrfuerzavta (id,numero,nombre) VALUES (lnid,2,"FUERZA VTA 2")

STORE 0 TO lnidejercicio,lndebe,lnhaber,lnsaldo,lnnrocaja
STORE "" TO lcpefiscal,lcswitch
STORE CTOD('01-01-1900') TO ldfecdesde,ldfechasta

lniddetanrocaja = RecuperarID('CsrDetanroCaja',Goapp.sucursal10)
lnidejercicio	= CsrParaConta.idejercicio
lnnrocaja		= VAL(DTOS(CTOD(lcfecha)))
lcpefiscal		= LEFT(STR(lnnrocaja,8),6)
ldfecdesde		= CTOD('01-01-'+RIGHT(lcfecha,4))
ldfechasta		= CTOD(lcfecha)
lndebe			= 0
lnhaber			= 0
lnsaldo			= 0
lcswitch		= "0000000000"

INSERT INTO Csrdetanrocaja(id,idejercicio,nrocaja,pefiscal,fecdesde,fechasta,debe,haber,saldo,switch);
VALUES(lniddetanrocaja,lnidejercicio,lnnrocaja,lcpefiscal,ldfecdesde,ldfechasta,lndebe,lnhaber;
,lnsaldo,lcswitch)

oavisar.usuario('En enviar datos la opcion 1, asi los movimientos seran grabados en la caja numero '+ STR(lnnrocaja,8);
+"."+CHR(13)+"Si desea importar los movimientos a otra caja. Abra una nueva caja en el sistema.";
+CHR(13)+"Recuerde que la caja se captura del sistema nuevo.")

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
