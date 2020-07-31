PARAMETERS ldfecha,lcpath,lcBase
lcfecha = IIF(PCOUNT()< 1,"01-08-2010",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcdata = lcbase
LOCAL lnid 

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  


SET SAFETY OFF

Oavisar.proceso('S','Vaciando archivos') 
*Oavisar.proceso('N') 
SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.

TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrParaConta.* FROM ParaConta as CsrParaConta
where idejercicio = <<goapp.idejercicio>>
ENDTEXT 
IF !CrearCursorAdapter('CsrParaConta',lccmd)
	MESSAGEBOX('Nose puede importar, pq no cargado el CsrParaConta')
	RETURN .f.
ENDIF 
TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrProvCtaCon.* FROM ProvCtaCon as CsrProvCtaCon
left join PlanCue as CsrPlanCue on CsrProvCtaCon.idctarete = CsrPlancue.id
where CsrProvCtaCon.idejercicio = <<goapp.idejercicio>> and ISNULL(CsrPlanCue.id,-1) > -1
ENDTEXT 
IF !CrearCursorAdapter('CsrProvCtaCon',lccmd)
	MESSAGEBOX('Nose puede importar, Se produjo un error al cargar las provincias asociadas')
	RETURN .f.
ENDIF 
TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrParaVario.* FROM ParaVario as CsrParaVario
ENDTEXT 
IF !CrearCursorAdapter('CsrParaVario',lccmd)
	MESSAGEBOX('Nose puede importar, las tablas varias nose cargaron')
	RETURN .f.
ENDIF

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

llok = CargarTabla(lcData,'Provincia')
llok = CargarTabla(lcData,'MovCtacte')
llok = CargarTabla(lcData,'CabeCpra')
llok = CargarTabla(lcData,'TablaImp')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Maopera')
llok = CargarTabla(lcData,'Valor')
llok = CargarTabla(lcData,'ClaseValor')
llok = CargarTabla(lcData,'MovCaja')
llok = CargarTabla(lcData,'MovBcocar')
llok = CargarTabla(lcData,'AfeBcocar')
llok = CargarTabla(lcData,'AfeCtacte')

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON

IF USED('CsrAcreedor ')
	USE  IN  CsrAcreedor 
ENDIF 
IF USED('CsrMoviprov')
	USE  IN CsrMoviprov 
ENDIF 
IF USED('CsrComproba')
	USE  IN  CsrComproba 
ENDIF 
IF USED('CsrAfeProv')
	USE IN CsrAfeProv
ENDIF
IF USED('CsrOrden')
	USE IN CsrOrden
ENDIF 
CREATE CURSOR CsrOrden(orden c(10),idmaopera n(12,0))
INDEX on orden TAG orden 

USE  ALLTRIM(lcpath )+"\gestion\proveed" in 0 alias CsrAcreedor EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\moviprov" in 0 alias CsrMoviprov EXCLUSIVE

*USE  ALLTRIM(lcpath )+"\gestion\compropr" in 0 alias CsrComproba EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\tablaope" in 0 alias CsrTablaOpe EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movbacar" in 0 alias CsrMovBco EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\afeprov" in 0 alias CsrAfeProv EXCLUSIVE

CREATE CURSOR CsrComproba (numero i,debcre c(1),nombre c(20))
INSERT INTO Csrcomproba VALUES (1,"D","FACTURA")
INSERT INTO Csrcomproba VALUES (2,"D","N.DEBITO")
INSERT INTO Csrcomproba VALUES (3,"C","N.CREDITO")
INSERT INTO Csrcomproba VALUES (4,"C","ORDENPAGO")

*fecha de importacion
ldfecha		=CTOD(lcfecha)
lfechapost	= ldfecha
lcfiscal	=ALLTRIM(STR(YEAR(ldfecha)))+ALLTRIM(STRzero(MONTH(ldfecha),2,0))+ALLTRIM(STRzero(DAY(ldfecha),2,0))

lnidmaopera		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidmovctacte	= RecuperarID('CsrMovCtacte',Goapp.sucursal10)
lnidCabeCpra	= RecuperarID('CsrCabeCpra',Goapp.sucursal10)
lnidtablaimp	= RecuperarID('CsrTablaImp',Goapp.sucursal10)
lnidmovcaja		= RecuperarID('CsrMovCaja',Goapp.sucursal10)
lnidmovbcocar	= RecuperarID('CsrMovBcocar',Goapp.sucursal10)
lnidafebcocar	= RecuperarID('CsrAfeBcocar',Goapp.sucursal10)
lnidafectacte	= RecuperarID('CsrAfeCtacte',Goapp.sucursal10)

ldfechas	=DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)

Oavisar.proceso('S','Recalculando saldos anteriores a la fecha')
**** sumatoria de los movimientos anteriores
**OR tipocomp=5
SELECT distinct cliente+30000 as cliente,fecha_fac;
,IIF(CsrMoviprov.provincia='Z',0,0) as idprovincia;
,IIF(isnull(importeco-decontado),CAST(0 as numeric(11,2)),importeco-decontado) as pago;
,IIF(ISNULL(saldoComp) OR tipocomp=5,CAST(0 as numeric(11,2)),SaldoComp) as SaldoCredito;
,IIF(isnull(negra),CAST(0 as numeric(11,2)),negra) as TotalNG;
,IIF(isnull(internos),CAST(0 as numeric(11,2)),internos) as TotalII;
,IIF(isnull(otroiva),CAST(0 as numeric(11,2)),otroiva) as TotalOI;
,IIF(isnull(exen),CAST(0 as numeric(11,2)),exen) as TotalEX;
,IIF(isnull(retegan),CAST(0 as numeric(11,2)),retegan) as TotalRG;
,IIF(isnull(reteib),CAST(0 as numeric(11,2)),reteib) as TotalRB;
,IIF(isnull(reteiva),CAST(0 as numeric(11,2)),reteiva) as TotalRI;
,IIF(isnull(iva),CAST(0 as numeric(11,2)),iva) as TotalIG;
,IIF(isnull(perceib),CAST(0 as numeric(11,2)),perceib) as TotalPB;
,IIF(isnull(percegan),CAST(0 as numeric(11,2)),percegan) as TotalPG;
,IIF(isnull(percep),CAST(0 as numeric(11,2)),percep) as TotalPI;
,IIF(isnull(porceniva),CAST(0 as numeric(11,2)),porceniva) as Tasa;
,CAST(0 as numeric(11,2)) as TotalPBRN;
,IIF(isnull(perceib),CAST(0 as numeric(11,2)),perceib) as totalPBBA;
FROM Csrmoviprov;
LEFT JOIN CsrComproba ON CsrMoviprov.tipocomp=CsrComproba.numero;
where (fecha_fac<ldfecha) AND estado<>'A' AND CsrComproba.debcre='C';
order BY CsrMoviProv.cliente INTO CURSOR CsrAuxAntDebito READWRITE

SELECT cliente,idprovincia,SUM(pago) as pago,SUM(TotalNG) as TotalNG;
,SUM(TotalII) as TotalII,SUM(TotalOI) as TotalOI,SUM(TotalEX) as TotalEX;
,SUM(TotalRG) as TotalRG,SUM(TotalRB) as TotalRB,SUM(TotalRI) as TotalRI;
,SUM(TotalIG) as TotalIG,SUM(TotalPB) as TotalPB,SUM(TotalPG) as TotalPG;
,SUM(TotalPI) as TotalPI,AVG(Tasa) as Tasa,SUM(saldoCredito) as Saldo;
,SUM(TotalPBRN) as TotalPBRN, SUM(TotalPBBA) as totalPBBA;
FROM CsrAuxAntDebito;
GROUP BY cliente,idprovincia order BY cliente INTO CURSOR CsrAntDebito READWRITE 

SELECT cliente+30000 as cliente,IIF(provincia='R',0,0) as idprovincia;
,SUM(importeco-decontado) as importe,SUM(saldoComp) as SaldoDebito;
,SUM(negra) as TotalNG,SUM(internos) as TotalII,SUM(otroiva) as TotalOI,SUM(exen) as TotalEX;
,SUM(retegan) as TotalRG,SUM(reteib) as TotalRB,SUM(reteiva) as TotalRI,SUM(iva) as TotalIG;
,SUM(perceib) as TotalPB,SUM(percegan) as TotalPG,SUM(percep) as TotalPI;
,AVG(porceniva) as Tasa,0 as TotalPBRN, SUM(perceib) as totalPBBA;
FROM Csrmoviprov;
LEFT JOIN CsrComproba ON CsrMoviprov.tipocomp=CsrComproba.numero;
where fecha_fac<ldfecha AND estado<>'A' AND  CsrComproba.debcre='D';
GROUP BY CsrMoviprov.cliente,CsrMoviprov.provincia;
order BY CsrMoviProv.cliente INTO CURSOR CsrAuxAntCredito READWRITE 

SELECT cliente,idprovincia,SUM(importe) as importe,SUM(TotalNG) as TotalNG;
,SUM(TotalII) as TotalII,SUM(TotalOI) as TotalOI,SUM(TotalEX) as TotalEX;
,SUM(TotalRG) as TotalRG,SUM(TotalRB) as TotalRB,SUM(TotalRI) as TotalRI;
,SUM(TotalIG) as TotalIG,SUM(TotalPB) as TotalPB,SUM(TotalPG) as TotalPG;
,SUM(TotalPI) as TotalPI,AVG(Tasa) as Tasa, SUM(saldoDebito) as Saldo;
,SUM(TotalPBRN) as TotalPBRN, SUM(TotalPBBA) as totalPBBA;
FROM CsrAuxAntCredito;
GROUP BY cliente,idprovincia order BY cliente INTO CURSOR CsrAntCredito READWRITE 

*replace ALL importe WITH IIF(saldo_ant>=0,(saldo_ant)+importe,importe) IN CsrAImporte

SELECT distinct Csrmoviprov.cliente+30000 as cliente;
,IIF(Csrmoviprov.provincia='R',0,0) as idprovincia;
FROM Csrmoviprov ;
ORDER BY cliente INTO CURSOR CsrProveedores

*stop()
*oavisar.proceso('N')

SELECT CsrProveedores.cliente,CsrProveedores.idprovincia;
,(IIF(ISNULL(CsrAntCredito.Saldo),CAST(0 as numeric(11,2)),CsrAntCredito.Saldo);
- IIF(ISNULL(CsrAntDebito.Saldo),CAST(0 as numeric(11,2)),CsrAntDebito.Saldo))as Saldo;
,IIF(ISNULL(CsrAntCredito.importe),CAST(0 as numeric(11,2)),CsrAntCredito.importe) as importe;
,IIF(ISNULL(CsrAntDebito.pago),CAST(0 as numeric(11,2)),CsrAntDebito.pago) as pago;
,(IIF(ISNULL(CsrAntCredito.TotalNG),CAST(0 as numeric(11,2)),CsrAntCredito.TotalNG);
- IIF(ISNULL(CsrAntDebito.TotalNG),CAST(0 as numeric(11,2)),CsrAntDebito.TotalNG))as TotalNG;
,(IIF(ISNULL(CsrAntCredito.TotalII),CAST(0 as numeric(11,2)),CsrAntCredito.TotalII);
- IIF(ISNULL(CsrAntDebito.TotalII),CAST(0 as numeric(11,2)),CsrAntDebito.TotalII))as TotalII;
,(IIF(ISNULL(CsrAntCredito.TotalOI),CAST(0 as numeric(11,2)),CsrAntCredito.TotalOI);
- IIF(ISNULL(CsrAntDebito.TotalOI),CAST(0 as numeric(11,2)),CsrAntDebito.TotalOI))as TotalOI;
,(IIF(ISNULL(CsrAntCredito.TotalEX),CAST(0 as numeric(11,2)),CsrAntCredito.TotalEX);
- IIF(ISNULL(CsrAntDebito.TotalEX),CAST(0 as numeric(11,2)),CsrAntDebito.TotalEX))as TotalEX;
,(IIF(ISNULL(CsrAntCredito.TotalRG),CAST(0 as numeric(11,2)),CsrAntCredito.TotalRG);
- IIF(ISNULL(CsrAntDebito.TotalRG),CAST(0 as numeric(11,2)),CsrAntDebito.TotalRG))as TotalRG;
,(IIF(ISNULL(CsrAntCredito.TotalRB),CAST(0 as numeric(11,2)),CsrAntCredito.TotalRB);
- IIF(ISNULL(CsrAntDebito.TotalRB),CAST(0 as numeric(11,2)),CsrAntDebito.TotalRB))as TotalRB;
,(IIF(ISNULL(CsrAntCredito.TotalRI),CAST(0 as numeric(11,2)),CsrAntCredito.TotalRI);
- IIF(ISNULL(CsrAntDebito.TotalRI),CAST(0 as numeric(11,2)),CsrAntDebito.TotalRI))as TotalRI;
,(IIF(ISNULL(CsrAntCredito.TotalIG),CAST(0 as numeric(11,2)),CsrAntCredito.TotalIG);
- IIF(ISNULL(CsrAntDebito.TotalIG),CAST(0 as numeric(11,2)),CsrAntDebito.TotalIG))as TotalIG;
,(IIF(ISNULL(CsrAntCredito.TotalPB),CAST(0 as numeric(11,2)),CsrAntCredito.TotalPB);
- IIF(ISNULL(CsrAntDebito.TotalPB),CAST(0 as numeric(11,2)),CsrAntDebito.TotalPB))as TotalPB;
,(IIF(ISNULL(CsrAntCredito.TotalPG),CAST(0 as numeric(11,2)),CsrAntCredito.TotalPG);
- IIF(ISNULL(CsrAntDebito.TotalPG),CAST(0 as numeric(11,2)),CsrAntDebito.TotalPG))as TotalPG;
,(IIF(ISNULL(CsrAntCredito.TotalPI),CAST(0 as numeric(11,2)),CsrAntCredito.TotalPI);
- IIF(ISNULL(CsrAntDebito.TotalPI),CAST(0 as numeric(11,2)),CsrAntDebito.TotalPI))as TotalPI;
,((IIF(ISNULL(CsrAntCredito.TASA),CAST(1 as numeric(11,2)),CsrAntCredito.TASA);
+ IIF(ISNULL(CsrAntDebito.TASA),CAST(1 as numeric(11,2)),CsrAntDebito.TASA))/2)as TASA;
,(IIF(ISNULL(CsrAntCredito.TotalPBBA),CAST(0 as numeric(11,2)),CsrAntCredito.TotalPBBA);
- IIF(ISNULL(CsrAntDebito.TotalPBBA),CAST(0 as numeric(11,2)),CsrAntDebito.TotalPBBA))as TotalPBBA;
,(IIF(ISNULL(CsrAntCredito.TotalPBRN),CAST(0 as numeric(11,2)),CsrAntCredito.TotalPBRN);
- IIF(ISNULL(CsrAntDebito.TotalPBRN),CAST(0 as numeric(11,2)),CsrAntDebito.TotalPBRN))as TotalPBRN;
,CAST(0 as n(12,0)) as idmaopera;
FROM CsrProveedores;
LEFT JOIN  CsrAntCredito ON CsrProveedores.cliente=CsrAntCredito.cliente;
AND CsrProveedores.idprovincia = CsrAntCredito.idprovincia;
LEFT JOIN  CsrAntDebito ON CsrProveedores.cliente=CsrAntDebito.cliente;
AND CsrProveedores.idprovincia = CsrAntDebito.idprovincia;
into CURSOR CsrAnterior READWRITE
SELECT CsrAnterior
INDEX on cliente TAG cliente

replace ALL importe WITH (importe-pago) IN CsrAnterior &&Inveritmos el signo pq es acreedor
*!*	oavisar. proceso('N')
*!*	BROWSE 
*!*	RETURN

SELECT distinct Csrmoviprov.cliente+30000 as cliente;
,IIF(ISNULL(CsrAcreedor.saldo_ant),CAST(0 as numeric(11,2)),CsrAcreedor.saldo_ant) as saldo_ant;
FROM Csrmoviprov ;
left JOIN csrAcreedor ON csrMoviprov.cliente = CsrAcreedor.numero;
ORDER BY cliente INTO CURSOR CsrProv_Saldoant

SELECT CsrAnterior
GO TOP
*!*	stop()
*!*	BROWSE 

lncliente = 0
SCAN 
	IF lncliente=CsrAnterior.cliente
		LOOP 
	ENDIF 
	lncliente = CsrAnterior.cliente 
	SELECT CsrProv_Saldoant
	LOCATE FOR cliente = lnCliente
	SELECT CsrAnterior
	replace saldo WITH (saldo + CsrProv_Saldoant.saldo_ant) &&Sumamos  pq el saldo_ant postivo es un credto.
ENDSCAN 

DELETE FROM CsrAnterior WHERE saldo=0 AND importe=0
*!*	**********************************************
*!*	****sumatoria de los movimientos posteriores**
*!*	**********************************************

*!*	SELECT cliente+10000 as cliente,SUM(importeco-decontado) as pago;
*!*	,SUM(saldoComp) as saldo;
*!*	,SUM(negra) as TotalNG,SUM(internos) as TotalII,SUM(otroiva) as TotalOI,SUM(exen) as TotalEX;
*!*	,SUM(retegan) as TotalRG,SUM(reteib) as TotalRB,SUM(reteiva) as TotalRI,SUM(iva) as TotalIG;
*!*	,SUM(perceibrn+perceib) as TotalPB,SUM(percegan) as TotalPG,SUM(percep) as TotalPI;
*!*	,AVG(porceniva) as Tasa,IIF(CsrMoviprov.provincia='R',1100000022,1100000002) as idprovincia;
*!*	,SUM(perceibrn) as TotalPBRN,SUM(perceib) as TotalPBBA;
*!*	FROM Csrmoviprov ;
*!*	LEFT JOIN CsrComproba ON CsrMoviprov.tipocomp=CsrComproba.numero;
*!*	where fecha_fac>=ldfecha AND estado<>'A' AND CsrComproba.debcre='C' ;
*!*	GROUP BY CsrMoviprov.cliente,CsrMoviprov.provincia ;
*!*	order BY CsrMoviProv.cliente INTO CURSOR CsrDebito READWRITE 

*!*	SELECT cliente+10000 as cliente,SUM(importeco-decontado) as importe;
*!*	,SUM(saldoComp) as saldo;
*!*	,SUM(negra) as TotalNG,SUM(internos) as TotalII,SUM(otroiva) as TotalOI,SUM(exen) as TotalEX;
*!*	,SUM(retegan) as TotalRG,SUM(reteib) as TotalRB,SUM(reteiva) as TotalRI,SUM(iva) as TotalIG;
*!*	,SUM(perceibrn+perceib) as TotalPB,SUM(percegan) as TotalPG,SUM(percep) as TotalPI;
*!*	,AVG(porceniva) as Tasa,IIF(CsrMoviprov.provincia='R',1100000022,1100000002) as idprovincia;
*!*	,SUM(perceibrn) as TotalPBRN,SUM(perceib) as TotalPBBA;
*!*	FROM Csrmoviprov;
*!*	LEFT JOIN CsrComproba ON CsrMoviprov.tipocomp=CsrComproba.numero;
*!*	where fecha_fac>=ldfecha AND estado<>'A' AND  CsrComproba.debcre='D';
*!*	GROUP BY CsrMoviprov.cliente,CsrMoviprov.provincia;
*!*	order BY CsrMoviProv.cliente INTO CURSOR CsrCredito READWRITE 

*!*	SELECT distinct cliente+10000 as cliente,IIF(provincia='R',1100000022,1100000002) as idprovincia;
*!*	FROM Csrmoviprov ORDER BY cliente INTO CURSOR CsrProveedores

*!*	SELECT CsrProveedores.cliente;
*!*	,IIF(ISNULL(CsrCredito.importe),CAST(0 as numeric(11,2)),CsrCredito.importe) as importe;
*!*	,IIF(ISNULL(CsrDebito.pago),CAST(0 as numeric(11,2)),CsrDebito.pago) as pago;
*!*	,CsrProveedores.idprovincia;
*!*	,(IIF(ISNULL(CsrCredito.Saldo),CAST(0 as numeric(11,2)),CsrCredito.Saldo);
*!*	- IIF(ISNULL(CsrDebito.Saldo),CAST(0 as numeric(11,2)),CsrDebito.Saldo))as Saldo;
*!*	,(IIF(ISNULL(CsrCredito.TotalNG),CAST(0 as numeric(11,2)),CsrCredito.TotalNG);
*!*	- IIF(ISNULL(CsrDebito.TotalNG),CAST(0 as numeric(11,2)),CsrDebito.TotalNG))as TotalNG;
*!*	,(IIF(ISNULL(CsrCredito.TotalII),CAST(0 as numeric(11,2)),CsrCredito.TotalII);
*!*	- IIF(ISNULL(CsrDebito.TotalII),CAST(0 as numeric(11,2)),CsrDebito.TotalII))as TotalII;
*!*	,(IIF(ISNULL(CsrCredito.TotalOI),CAST(0 as numeric(11,2)),CsrCredito.TotalOI);
*!*	- IIF(ISNULL(CsrDebito.TotalOI),CAST(0 as numeric(11,2)),CsrDebito.TotalOI))as TotalOI;
*!*	,(IIF(ISNULL(CsrCredito.TotalEX),CAST(0 as numeric(11,2)),CsrCredito.TotalEX);
*!*	- IIF(ISNULL(CsrDebito.TotalEX),CAST(0 as numeric(11,2)),CsrDebito.TotalEX))as TotalEX;
*!*	,(IIF(ISNULL(CsrCredito.TotalRG),CAST(0 as numeric(11,2)),CsrCredito.TotalRG);
*!*	- IIF(ISNULL(CsrDebito.TotalRG),CAST(0 as numeric(11,2)),CsrDebito.TotalRG))as TotalRG;
*!*	,(IIF(ISNULL(CsrCredito.TotalRB),CAST(0 as numeric(11,2)),CsrCredito.TotalRB);
*!*	- IIF(ISNULL(CsrDebito.TotalRB),CAST(0 as numeric(11,2)),CsrDebito.TotalRB))as TotalRB;
*!*	,(IIF(ISNULL(CsrCredito.TotalRI),CAST(0 as numeric(11,2)),CsrCredito.TotalRI);
*!*	- IIF(ISNULL(CsrDebito.TotalRI),CAST(0 as numeric(11,2)),CsrDebito.TotalRI))as TotalRI;
*!*	,(IIF(ISNULL(CsrCredito.TotalIG),CAST(0 as numeric(11,2)),CsrCredito.TotalIG);
*!*	- IIF(ISNULL(CsrDebito.TotalIG),CAST(0 as numeric(11,2)),CsrDebito.TotalIG))as TotalIG;
*!*	,(IIF(ISNULL(CsrCredito.TotalPB),CAST(0 as numeric(11,2)),CsrCredito.TotalPB);
*!*	- IIF(ISNULL(CsrDebito.TotalPB),CAST(0 as numeric(11,2)),CsrDebito.TotalPB))as TotalPB;
*!*	,(IIF(ISNULL(CsrCredito.TotalPG),CAST(0 as numeric(11,2)),CsrCredito.TotalPG);
*!*	- IIF(ISNULL(CsrDebito.TotalPG),CAST(0 as numeric(11,2)),CsrDebito.TotalPG))as TotalPG;
*!*	,(IIF(ISNULL(CsrCredito.TotalPI),CAST(0 as numeric(11,2)),CsrCredito.TotalPI);
*!*	- IIF(ISNULL(CsrDebito.TotalPI),CAST(0 as numeric(11,2)),CsrDebito.TotalPI))as TotalPI;
*!*	,((IIF(ISNULL(CsrCredito.TASA),CAST(1 as numeric(11,2)),CsrCredito.TASA);
*!*	+ IIF(ISNULL(CsrDebito.TASA),CAST(1 as numeric(11,2)),CsrDebito.TASA))/2)as TASA;
*!*	,(IIF(ISNULL(CsrCredito.TotalPBBA),CAST(0 as numeric(11,2)),CsrCredito.TotalPBBA);
*!*	- IIF(ISNULL(CsrDebito.TotalPBBA),CAST(0 as numeric(11,2)),CsrDebito.TotalPBBA))as TotalPBBA;
*!*	,(IIF(ISNULL(CsrCredito.TotalPBRN),CAST(0 as numeric(11,2)),CsrCredito.TotalPBRN);
*!*	- IIF(ISNULL(CsrDebito.TotalPBRN),CAST(0 as numeric(11,2)),CsrDebito.TotalPBRN))as TotalPBRN;
*!*	FROM CsrProveedores;
*!*	LEFT JOIN  CsrCredito ON CsrProveedores.cliente=CsrCredito.cliente;
*!*	AND CsrProveedores.idprovincia = CsrCredito.idprovincia;
*!*	LEFT JOIN  CsrDebito ON CsrProveedores.cliente=CsrDebito.cliente;
*!*	AND CsrProveedores.idprovincia = CsrDebito.idprovincia;
*!*	into CURSOR CsrSaldosPost READWRITE

*!*	*replace ALL saldo WITH (importe-pago) IN CsrSaldosPost 
*!*	DELETE FROM CsrSaldosPost WHERE saldo=0 

**************************************************
*******Blanqueo los saldos de los proveedores.****
**************************************************
UPDATE CsrCtacte SET saldo = 0 WHERE ctaacreedor = 1
		
SELECT CsrAnterior
Oavisar.proceso('S','Saldo Anterior '+alias()) 
GO top
SCAN FOR !EOF('CsrAnterior')
	SELECT CsrCtacte
	LOCATE FOR ALLTRIM(cnumero)=ALLTRIM(STR(CsrAnterior.cliente))
	IF  ALLTRIM(cnumero)=ALLTRIM(STR(CsrAnterior.cliente))
		lnsigno=-1
		replace saldoant WITH 0, saldo WITH CsrCtacte.saldo + CsrAnterior.Saldo IN CsrCtacte
		lnidcomproba=46 &&Dbto de Cpra
		lnimporte=CsrAnterior.importe
		lcclasecomp="B"
		IF lnimporte<0
			lnimporte=lnimporte*-1
			lnsigno=1
			lnidcomproba=47 &&Cdto de Cpra
			lcclasecomp="C"
		ENDIF 
		
		lcletra			= IIF(CsrCtacte.tipoiva=1,"A","B")
		lcnum			= strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0')
		lcnumero		= lcletra+"0000"+lcnum
		lcswitch		= "00000"
		ldfechaserver	= DATETIME()
		ldfechasis		= FechaHoraCero(ldfechaserver)
		
		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor;
		,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,detalle;
		,fechaserver);
		VALUES (lnidmaopera,"PAG","IMPORTACIÓN MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,lcswitch,"0";
		,"Importación. Compactación Mov Provee.",ldfechaserver)
		
		replace idmaopera WITH lnidmaopera IN CsrAnterior
		
		STORE 0 TO lnidsubcta,lnbonif1,lnbonif2,lnlistaprecio,lnidfletero,lnidfuerzavta,lnidrutavdor
		STORE 0 TO lnhojaactual,lnhojatotal,lnidfrio,lntasamuni,lndiferida,lnidtiponcredito,lnrendida
		
		lnidctacte		= CsrCtacte.id
		lcctacte		= Csrctacte.cnumero
		*ldfecha			= ldfechasis
		lnidprovincia	= CsrAnterior.idprovincia
		lcdetalle		= ""
		lccnombre		= CsrCtacte.cnombre
		lccdireccion	= CsrCtacte.cdireccion
		lcctelefono		= CsrCtacte.ctelefono
		lccpostal		= CsrCtacte.cpostal
		lnidlocalidad	= CsrCtacte.idlocalidad
		lnidtipoiva		= CsrCtacte.tipoiva
		lccuit			= CsrCtacte.cuit
		lnidplanpago	= CsrCtacte.idplanpago
		lntotal			= lnimporte
		lcswitch		="00100"
		lnidcategoria	= Csrctacte.idcategoria
		lnidlotemaopera	= lnidmaopera
		lcnropatron		= ""
		lnSaldo			= ABS(CsrAnterior.saldo)
         
         INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
		,entrega,vencimien,total,detalle,pefiscal,switch,signo);
		VALUES (lnidmovctacte,lnidmaopera,ldfecha-1,lcctacte,lnidctacte," ",0,1,lnimporte;
		,lnSaldo,0,ldfecha-1,lnimporte,"Saldo de Importación",SUBSTR(lcfiscal,1,6),lcSwitch,lnsigno)
		
		lnidauxmovctacte	= lnidmovctacte
		lnidauxmaopera		= lnidmaopera
		lnidauxcabecpra		= lnidcabecpra
		
		lnidmovctacte	= lnidmovctacte+1
		lnidmaopera		= lnidmaopera+1
		lnidcabecpra	= lnidcabecpra+1
		&&Generamos los asientos de los impuestos.
		lnBaseImp	= 0
		IF CsrAnterior.TotalNG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 19
			IF !numero = 19
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalNG
			lntasa		= 0
			lnBaseImp	= lnBaseImp + lnImporte
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"NG";
     		,lnimporte,lntasa,0,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
			
		ENDIF 
		IF CsrAnterior.TotalII#0
			SELECT CsrParaConta
			LOCATE FOR numero = 21
			IF !numero = 21
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalII
			lntasa		= 0
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"II";
     		,lnimporte,lntasa,0,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 	
		IF CsrAnterior.TotalEX#0
			SELECT CsrParaConta
			LOCATE FOR numero = 24
			IF !numero = 24
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalEX
			lntasa		= 0
			lnBaseImp	= lnBaseImp + lnImporte
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"EX";
     		,lnimporte,lntasa,0,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 	
		IF CsrAnterior.TotalIG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 13
			IF !numero = 13
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalIG
			lntasa		= CsrAnterior.tasa
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"IG";
     		,lnimporte,lntasa,lnBaseImp,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 
		IF CsrAnterior.TotalOI#0 
			lnBase = CsrAnterior.TotalNG
			
			SELECT CsrParaConta
			LOCATE FOR numero = 34
			IF !numero =34
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalOI
			lntasa		= ROUND((lnimporte*100)/CsrAnterior.TotalOI,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"OI";
     		,lnimporte,lntasa,lnBase,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF	
		IF CsrAnterior.TotalRG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 10
			IF !numero = 10
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalRG
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"RG";
     		,lnimporte,lntasa,lnBaseImp,"IBTO2",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 
		IF CsrAnterior.TotalRI#0
			SELECT CsrParaConta
			LOCATE FOR numero = 7
			IF !numero = 7
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalRI
			lntasa		= ROUND((lnimporte*100)/CsrAnterior.TotalNG,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"RI";
     		,lnimporte,lntasa,lnBaseImp,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 
		IF CsrAnterior.TotalRB#0
			SELECT CsrProvincia
			LOCATE FOR id = lnidprovincia
			SELECT CsrProvCtaCon
			LOCATE FOR idprovincia = lnidprovincia
			lnidcuenta = CsrProvCtaCon.idctarete

			IF lnidcuenta=0
				SELECT CsrParaConta
				LOCATE FOR numero = 9
				IF !numero = 9
					LOOP 
				ENDIF 
				lnidcuenta = CsrParaConta.idcuenta
			ENDIF 
			lnimporte	= CsrAnterior.TotalRB
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"RB";
     		,lnimporte,lntasa,lnBaseImp,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 

		IF CsrAnterior.TotalPBBA#0 OR CsrAnterior.TotalPBRN#0
			lccategoria	=	IIF(CsrAnterior.TotalPBBA#0,"CATEIBBA","CATEIBRN")
			SELECT CsrParaVario
			LOCATE FOR nombre = lccategoria
			lnidprov = CsrParaVario.idorigen
			
			SELECT CsrParaConta
			LOCATE FOR numero = 8
			IF !numero =8
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			
			SELECT CsrProvCtaCon
			LOCATE FOR idprovincia = lnidprov
			IF idprovincia = lnidprov
				lnidcuenta = CsrProvCtacon.idctarete
			ENDIF 
			
			lnimporte	= CsrAnterior.TotalPB
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"PB";
     		,lnimporte,lntasa,lnBaseImp,"IBTO2",lcdetalle,lnidprov)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF
		IF CsrAnterior.TotalPG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 11
			IF !numero =11
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalPG
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"PG";
     		,lnimporte,lntasa,lnBaseImp,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF
		IF CsrAnterior.TotalPI#0 
			lnBase = IIF(CsrAnterior.TotalNG#0,CsrAnterior.TotalNG,CsrAnterior.TotalEX)
			IF lnBase =0
				SELECT CsrAnterior
				LOOP 
			ENDIF 
			SELECT CsrParaConta
			LOCATE FOR numero = 6
			IF !numero =6
				LOOP 
			ENDIF 
			SELECT CsrParaConta
			LOCATE FOR numero = 6
			IF !numero =6
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrAnterior.TotalPI
			lntasa		= ROUND((lnimporte*100)/CsrAnterior.TotalIG,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"PI";
     		,lnimporte,lntasa,lnBase,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF
		
	ENDIF
	SELECT CsrAnterior
ENDSCAN 

Oavisar.proceso('S','Recuperando movimientos posteriores') 	
*fecha de importacion
ldfecha		=CTOD(lcfecha)

SELECT (CsrMoviprov.cliente+30000) as cliente ,detalle,IIF((CsrComproba.debcre='C'),-1,01) as Signo;
,fecha_fac;
,CsrMoviprov.Importeco as importe,porceniva as Tasa;
,negra as TotalNG,internos as TotalII,otroiva as TotalOI,exen as TotalEX;
,retegan as TotalRG,reteib as TotalRB,reteiva as TotalRI,iva as TotalIG;
,(perceib) as TotalPB,percegan as TotalPG,percep as TotalPI;
,IIF(provincia='R',1100000022,1100000002) as idprovincia;
,(0) as TotalPBRN,(perceib) as TotalPBBA;
,tipocomp,vencimien,IIF(ISNULL(decontado),CAST(0 as numeric(11,2)),decontado)as decontado;
,IIF(ISNULL(saldocomp),CAST(0 as numeric(11,2)),saldocomp)as saldo;
,letra,talonario,numcomp,CAST(0 as n(12,0)) as idmaopera;
,periodo,SPACE(15) as orden;
FROM CsrMoviprov ;
LEFT JOIN CsrComproba ON CsrMoviprov.tipocomp=CsrComproba.numero;
WHERE fecha_fac=>ldfecha AND estado<>'A' ;
order by fecha_fac,orden into cursor CsrPosterior READWRITE 

replace ALL orden WITH strzero(tipocomp,2)+left(letra,1)+strzero(talonario,4)+strzero(numcomp,8) IN CsrPosterior

SELECT CsrPosterior
INDEX on orden TAG orden
INDEX on DTOS(fecha_fac)+orden TAG fecha_fac 
SET ORDER TO fecha_fac ASCENDING 

SELECT CsrPosterior.Orden,CsrTablaOpe.importe as impvalor;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor,CsrTablaope.cheque;
,CsrTablaOpe.cliente,CsrTablaOpe.debehaber,CsrTablaOpe.detalle;
FROM CsrPosterior;
left JOIN CsrTablaOpe ON CsrPosterior.tipocomp = CsrTablaOpe.tipocomp AND CsrPosterior.letra = CsrTablaOpe.letra ;
AND CsrPosterior.talonario = CsrTablaOpe.talonario AND CsrPosterior.numcomp = CsrTablaOpe.numcomp;
left JOIN CsrValor ON CsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where CsrTablaope.origen = "A" AND valor<>0 into CURSOR CsrAuxTablaOpe READWRITE 

SELECT CsrAuxTablaOpe
INDEX on orden TAG korden
SET ORDER TO korden

&&Cheque de terceros
SELECT CsrMovBco.*,CsrTablaOpe.vendedor,CsrTablaOpe.cliente;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor;
,IIF(ISNULL(CsrCtacte.cnombre),SPACE(25),CsrCtacte.cnombre) as nomctacte;
,IIF(ISNULL(CsrMovBco.entregado),'0','1') as aentregar;
,IIF(ISNULL(CsrMovBco.depositado),'0','1') as depositados;
FROM CsrMovBco ;
LEFT JOIN CsrTablaOpe ON CsrMovBco.orden = CsrTablaOpe.orden AND CsrMovBco.numcomp = CsrTablaOpe.cheque;
left JOIN CsrValor ON CsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrCtacte ON CsrTablaOpe.cliente = VAL(CsrCtacte.cnumero);
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where LEN(LTRIM(CsrMovBco.idcheque))<>0 OR CsrMovBco.tipocomp=3 ;
INTO CURSOR CsrAuxMovBco READWRITE 

SELECT CsrAuxMovBco
INDEX on orden+STR(numcomp,10) TAG kcheque
SET ORDER TO kcheque

oavisar.proceso('N')



&&Para los recibos de pago, las retenciones nose encuentran en el moviprov.
&&De esa manera los buscamos en el tablaope y los cargamos en las variables.

 *oavisar.usuario(RECCOUNT("CsrPosterior"))
*!*	SELECT CsrSaldosPost
*!*	GO TOP 
*!*	SCAN 
*!*		SELECT CsrCtacte
*!*		LOCATE FOR  VAL(cnumero)=CsrSaldosPost.cliente
*!*		IF FOUND()
*!*			replace saldo WITH CsrCtacte.saldo+CsrSaldosPost.saldo IN CsrCtacte
*!*		ENDIF 
*!*	ENDSCAN 

*!*	replace ALL saldo WITH saldo * -1 IN CsrCtacte &&Inveritmos el signo pq es acreedor

SELECT CsrPosterior
Oavisar.proceso('S','Procesando movimientos posteriores')
 
SCAN  
	SELECT CsrCtacte
	LOCATE FOR VAL(cnumero)=CsrPosterior.cliente
	IF FOUND()
		*ldfechas=DATETIME(YEAR(CsrPosterior.fecha),month(CsrPosterior.fecha),day(CsrPosterior.fecha),0,0,0)
		

		DO CASE 
			CASE CsrPosterior.tipocomp=1 OR CsrPosterior.tipocomp=2
				lnidcomproba=22
				lcclasecomp="A"
				lcorigen = "CPR"
			CASE CsrPosterior.tipocomp=3 OR CsrPosterior.tipocomp=11
				lnidcomproba=44
				lcclasecomp="B"
				lcorigen = "CPR"
			CASE CsrPosterior.tipocomp=4 OR CsrPosterior.tipocomp=12
				lnidcomproba=7
				lcclasecomp="C"
				lcorigen = "CPR"
			CASE CsrPosterior.tipocomp=5 OR CsrPosterior.tipocomp=6
				lnidcomproba=8
				lcclasecomp="D"
				lcorigen = "PAG"
		ENDCASE
		
		lcletra		= LTRIM(CsrPosterior.letra)
		lcletra		= IIF(LEN(LTRIM(lcletra))=0,IIF(CsrCtacte.tipoiva=1,"A","B"),LEFT(CsrPosterior.letra,1))
		lcnum		= STRZERO(CsrPosterior.numcomp,8)
		lcnum		= IIF(LEN(LTRIM(lcnum))=0,strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0'),lcnum)
		lctalonario	= STRZERO(CsrPosterior.talonario,4)
		lctalonario = IIF(LEN(LTRIM(lctalonario))=0,"0000",lctalonario)
		lcnumero	= lcletra+lctalonario+lcnum
		ldfecha		= FechaHoraCero(CsrPosterior.fecha_fac)
		ldfechaserver	= DATETIME()
		ldfechasis		= FechaHoraCero(ldfechaserver)
		
		oavisar.proceso('S',CsrCtacte.cnombre+" "+ALLTRIM(lcnumero)+" "+DTOC(ldfecha))
		
		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector	,fechasis,idoperador;
		,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch;
		,estado,detalle,fechaserver);
		VALUES (lnidmaopera,lcorigen,"IMPORTACION MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,"0000","0","Importación";
		,ldfechaserver)
		
		replace idmaopera WITH lnidmaopera IN CsrPosterior
		INSERT INTO CsrOrden (orden,idmaopera) VALUES (CsrPosterior.orden,lnidmaopera)
		
		STORE 0 TO lnidsubcta,lnbonif1,lnbonif2,lnlistaprecio,lnidfletero,lnidfuerzavta,lnidrutavdor
		STORE 0 TO lnhojaactual,lnhojatotal,lnidfrio,lntasamuni,lndiferida,lnidtiponcredito,lnrendida
		
		lnidctacte		= CsrCtacte.id
		lcctacte		= Csrctacte.cnumero
		
		ldfechavto		= DATETIME(YEAR(CsrPosterior.vencimien),MONTH(CsrPosterior.vencimien),DAY(CsrPosterior.vencimien),0,0,0)

		lnidprovincia	= CsrPosterior.idprovincia
		lcdetalle		= ""
		lccnombre		= CsrCtacte.cnombre
		lccdireccion	= CsrCtacte.cdireccion
		lcctelefono		= CsrCtacte.ctelefono
		lccpostal		= CsrCtacte.cpostal
		lnidlocalidad	= CsrCtacte.idlocalidad
		lnidtipoiva		= CsrCtacte.tipoiva
		lccuit			= CsrCtacte.cuit
		lnidplanpago	= CsrCtacte.idplanpago
		lcswitch		="00000"
		lnidcategoria	= Csrctacte.idcategoria
		lnidlotemaopera	= lnidmaopera
		lcnropatron		= ""
		lcperiodo		= CsrPosterior.periodo
		lnimporte		= CsrPosterior.importe
		lntotal			= lnimporte
		lnentrega		= CsrPosterior.decontado
		lnsaldo			= CsrPosterior.saldo
	
		
		
		lnsigno=1
		IF lnidcomproba=22 OR lnidcomproba=44
			IF lnimporte<0
				lnimporte=lnimporte*-1
			ENDIF 
			lnsigno=-1
		ENDIF
		
		IF lcorigen$'CPR'	 && si es un pago no grabo el cabepra			
			INSERT INTO CsrCabeCpra (id,idmaopera,idctacte,ctacte,cnombre,cdireccion,ctelefono;
			,cpostal,idlocalidad,idprovincia,idtipoiva,cuit,fecha,idplanpago,total,switch,idcategoria;
			,signo,pefiscal,recodevol);
			VALUES (lnidcabecpra,lnidmaopera,lnidctacte,lcctacte,lccnombre,lccdireccion,lcctelefono;
			,lccpostal,lnidlocalidad,lnidprovincia,lnidtipoiva,lccuit,ldfecha,lnidplanpago,lntotal;
			,lcswitch,lnidcategoria,lnsigno,lcperiodo,0)
			
			lnidcabecpra	= lnidcabecpra+1
        ENDIF 
        
		INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
		,entrega,vencimien,total,detalle,pefiscal,switch,signo);
		VALUES (lnidmovctacte,lnidmaopera,ldfecha,lcctacte,lnidctacte," ",0,1,lnimporte,lnsaldo;
		,lnentrega,ldfechavto,lnimporte,"Comprobante Importado Sa",lcperiodo,"0000",lnsigno)
		
		&&id para los asientos de impuestos
		lnidauxmovctacte	= lnidmovctacte
		lnidauxmaopera		= lnidmaopera
		
		lnidmovctacte	= lnidmovctacte+1
		lnidmaopera		= lnidmaopera+1
		
		
         &&Generamos los asientos de los impuestos.
		lnBaseImp	= IIF(lcorigen$"CPR",0,lntotal)

		IF CsrPosterior.TotalNG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 19
			IF !numero = 19
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalNG
			lntasa		= 0
			lnBaseImp	= lnBaseImp + lnImporte
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"NG";
     		,lnimporte,lntasa,0,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 
		IF CsrPosterior.TotalEX#0
			SELECT CsrParaConta
			LOCATE FOR numero = 24
			IF !numero = 24
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalEX
			lntasa		= 0
			lnBaseImp	= lnBaseImp + lnImporte
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"EX";
     		,lnimporte,lntasa,0,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF
		IF CsrPosterior.TotalII#0
			SELECT CsrParaConta
			LOCATE FOR numero = 21
			IF !numero = 21
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalII
			lntasa		= 0
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"II";
     		,lnimporte,lntasa,0,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 	
		IF CsrPosterior.TotalIG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 13
			IF !numero = 13
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalIG
			lntasa		= CsrPosterior.tasa
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"IG";
     		,lnimporte,lntasa,lnBaseImp,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 	
		IF CsrPosterior.TotalOI#0 
			lnBase = CsrPosterior.TotalNG
			
			SELECT CsrParaConta
			LOCATE FOR numero = 34
			IF !numero =34
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalOI
			lntasa		= ROUND((CsrPosterior.TotalOI*100)/lnBase,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"OI";
     		,lnimporte,lntasa,lnBase,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF	
		IF CsrPosterior.TotalRG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 10
			IF !numero = 10
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalRG
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"RG";
     		,lnimporte,lntasa,lnBaseImp,"IBTO2",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 
		IF CsrPosterior.TotalRI#0
			SELECT CsrParaConta
			LOCATE FOR numero = 7
			IF !numero = 7
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalRI
			lntasa		= ROUND((lnimporte*100)/CsrPosterior.TotalNG,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"RI";
     		,lnimporte,lntasa,lnBaseImp,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 
		IF CsrPosterior.TotalRB#0
			SELECT CsrProvincia
			LOCATE FOR id = lnidprovincia
			SELECT CsrProvCtaCon
			LOCATE FOR idprovincia = lnidprovincia
			lnidcuenta = CsrProvCtaCon.idctarete

			IF lnidcuenta=0
				SELECT CsrParaConta
				LOCATE FOR numero = 9
				IF !numero = 9
					LOOP 
				ENDIF 
				lnidcuenta = CsrParaConta.idcuenta
			ENDIF 
			lnimporte	= CsrPosterior.TotalRB
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"RB";
     		,lnimporte,lntasa,lnBaseImp,"IBTO2",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF 
*!*			IF CsrPosterior.TotalPB#0
*!*				SELECT CsrProvincia
*!*				LOCATE FOR id = lnidprovincia
*!*				lnconta = 32
*!*				IF "BUENOS" $ nombre
*!*					lnconta = 8
*!*				ENDIF 	
*!*				SELECT CsrParaConta
*!*				LOCATE FOR numero = lnconta
*!*				IF !numero =lnconta
*!*					LOOP 
*!*				ENDIF 
*!*				lnidcuenta 	= CsrParaConta.idcuenta
*!*				lnimporte	= CsrPosterior.TotalPB
*!*				lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
*!*				lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
*!*				INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
*!*	        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
*!*	     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"PB";
*!*	     		,lnimporte,lntasa,lnBaseImp,"IBTO2",lcdetalle,lnidprovincia)
*!*				lnidtablaimp = lnidtablaimp + 1
*!*			ENDIF
		IF CsrPosterior.TotalPBBA#0 OR CsrPosterior.TotalPBRN#0
			lccategoria	=	IIF(CsrAnterior.TotalPBBA#0,"CATEIBBA","CATEIBRN")
			SELECT CsrParaVario
			LOCATE FOR nombre = lccategoria
			lnidprov = CsrParaVario.idorigen
			
			SELECT CsrParaConta
			LOCATE FOR numero = 8
			IF !numero =8
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			
			SELECT CsrProvCtaCon
			LOCATE FOR idprovincia = lnidprov
			IF idprovincia = lnidprov
				lnidcuenta = CsrProvCtacon.idctarete
			ENDIF 
			
			lnimporte	= CsrPosterior.TotalPB
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"PB";
     		,lnimporte,lntasa,lnBaseImp,"IBTO2",lcdetalle,lnidprov)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF
		
		IF CsrPosterior.TotalPG#0
			SELECT CsrParaConta
			LOCATE FOR numero = 11
			IF !numero =11
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalPG
			lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"PG";
     		,lnimporte,lntasa,lnBaseImp,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF
		IF CsrPosterior.TotalPI#0 
			lnBase = IIF(CsrPosterior.TotalNG#0,CsrPosterior.TotalNG,CsrPosterior.TotalEX)
			IF lnBase =0
				SELECT CsrPosterior
				LOOP 
			ENDIF 
			SELECT CsrParaConta
			LOCATE FOR numero = 6
			IF !numero =6
				LOOP 
			ENDIF 
			lnidcuenta 	= CsrParaConta.idcuenta
			lnimporte	= CsrPosterior.TotalPI
			lntasa		= ROUND((lnimporte*100)/lnBase,1)
			lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
			INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
     		VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"PI";
     		,lnimporte,lntasa,lnBase,"",lcdetalle,lnidprovincia)
			lnidtablaimp = lnidtablaimp + 1
		ENDIF
		&&Cargamos los valores de los comprobantes.
		&&Importamos los valores, Retenciones, Percepciones
		SELECT CsrAuxTablaOpe
		GO TOP 
		SEEK CsrPosterior.orden 
		DO WHILE CsrAuxTablaOpe.orden = CsrPosterior.orden
			
			DO CASE 
				CASE CsrAuxTablaOpe.clasevalor$'T-P'
					SELECT CsrAuxMovBco
					lcClave = LTRIM(CsrAuxTablaope.orden)+STR(CsrAuxTablaOpe.cheque,10)
					IF !SEEK (lcClave,'CsrAuxMovBco','kcheque')
						SELECT CsrAuxTablaOpe
						SKIP 
						LOOP 
					ENDIF 
					STORE 0 TO lnidmaoperao,lnidorigen,lnidmaoperaa,lnidafecta
					
*!*						IF CsrAuxMovBco.numcomp=40619761
*!*							DEBUG
*!*							SUSPEND 
*!*						ENDIF 
					
					lcidcheque  = CsrAuxMovBco.idcheque					
					lnimporte	= CsrAuxMovBco.importe
					lnnumero	= CsrAuxMovBco.numcomp
					lcbanco		= CsrAuxMovBco.banco
					lclocalidad	= CsrAuxMovBco.localidad
					ldfecha		= CsrAuxMovBco.fecha
					ldfechavto	= CsrauxMovBco.fecha_vto
					lctitular	= CsrAuxMovBco.titular
					lcrecibido	= ""
					lcentregado	= CsrAuxMovBco.nomctacte
					lcdetalle	= CsrAuxMovBco.detalle
					lcSwitch	= IIF(VAL(CsrAuxMovBco.aentregar)+VAL(CsrAuxMovBco.depositados)>0,'1','0')+'0000'
					
					&&grabamos el movimiento como retiro
					INSERT INTO CsrMovbcocar (id,idmaopera,origen,importe,idtipomov,numero;
					,idctabco,banco,localidad,fecha,fechavto,cuit,titular,recibido,entregado;
					,detalle,signo,switch);
					VALUES (lnidmovbcocar,lnidmaopera,'3RO',lnimporte,16,lnnumero,0,lcbanco;
					,lclocalidad,ldfecha,ldfechavto,'',lctitular,lcrecibido;
					,lcentregado,lcdetalle,-1,lcSwitch)	
					lnidorigen	  = lnidmovbcocar
					lnidmovbcocar = lnidmovbcocar + 1	
					
					DELETE FROM CsrAuxMovBco WHERE idcheque = lcidcheque
					*lcidcheque = LTRIM(lcidcheque) + IIF(LEN(LTRIM(lcidcheque))#0,',','') + LTRIM(CsrAuxMovBco.idcheque)
									
					lnidmaoperao	= lnidmaopera
									
					SELECT CsrMovBcocar
					LOCATE FOR numero=lnnumero AND signo=1
					IF FOUND()
						lnidmaoperaa	= CsrMovBcocar.idmaopera
						lnidafecta		= CsrMovBcocar.id
					ENDIF 
					
					INSERT INTO Csrafebcocar(id,idmaoperao,idorigen,idmaoperaa,idafecta);
     				VALUES(lnidafebcocar,lnidmaoperao,lnidorigen,lnidmaoperaa,lnidafecta)
     				
					lnidafebcocar = lnidafebcocar +1
					
				CASE CsrAuxTablaOpe.clasevalor$'E-N'
					
					idorigen	= lnidmovctacte
					lctablaori	= 'MOCT'
					lcclase 	= CsrAuxTablaOpe.debehaber
					lnimporte 	= CsrAuxTablaOpe.impvalor
					lcdetalle	= CsrAuxTablaOpe.detalle
					ldfecha		= CsrMovCtacte.fecha
					lnidvalor	= CsrAuxTablaOpe.idvalor

					INSERT INTO Csrmovcaja (id,idmaopera,idorigen,tablaori,clase,importe,detalle;
					,fecha,idvalor);
					VALUES (lnidmovcaja,lnidmaopera,lnidmovctacte,lctablaori,clase,lnimporte;
					,lcdetalle,ldfecha,lnidvalor)
					
					lnidmovcaja = lnidmovcaja + 1 
					
				CASE CsrAuxTablaOpe.clasevalor$'I-R' &&las ordenas de pago tiene las retenciones tablaope
					lnidprov = IIF(CsrAuxTablaOpe.clasevalor$'I',1100000002,1100000022)
					lnconta	 = IIF(CsrAuxTablaOpe.clasevalor$'I',9,31)
			 	
					SELECT CsrParaConta
					LOCATE FOR numero = lnconta
					IF !numero =lnconta
						LOOP 
					ENDIF 
					lnidcuenta 	= CsrParaConta.idcuenta
					lnimporte	= CsrAuxTablaOpe.impvalor
					lntasa		= ROUND((lnimporte*100)/lnBaseImp,1)
					lntasa		= ROUND(lntasa,IIF(lntasa<1,1,0))
					INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
        			,importe,tasa,baseimp,nombre,detalle,idprovincia);
     				VALUES (lnidtablaimp,lnidauxmaopera,lnidauxmovctacte,"MOCT",0,lnidcuenta,"RB";
     				,lnimporte,lntasa,lnBaseImp,"IBTO2",lcdetalle,lnidprov)
					lnidtablaimp = lnidtablaimp + 1
			ENDCASE 
			SELECT CsrAuxTablaOpe
			SKIP 
		ENDDO 
		
		
	ENDIF
	SELECT CsrPosterior
ENDSCAN 
oavisar.proceso('S','Armando afectaciones..')



SELECT 'D' as tipo,CsrAfeProv.orden,CsrAfeProv.ordenafe,CsrAfeProv.importe,CsrAfeProv.estado;
FROM CsrOrden inner JOIN CsrAfeProv ON CsrOrden.orden = CsrAfeProv.orden WHERE estado<>'A';
union ALL ;
SELECT 'A' as tipo,CsrAfeProv.ordenafe as orden,CsrAfeProv.orden as ordenafe,CsrAfeProv.importe;
,CsrAfeProv.estado FROM CsrOrden inner JOIN CsrAfeProv ON CsrOrden.orden = CsrAfeProv.ordenafe;
WHERE estado<>'A';
INTO CURSOR CsrAfectados READWRITE 
SELECT CsrAfectados
INDEX on orden TAG orden 
INDEX on ordenafe TAG ordenafe
SET ORDER TO orden 

*!*	SELECT * FROM CsrAfectados WHERE orden in ("0000830637","0000830745") ;
*!*	OR ordenafe in ("0000830637","0000830745") 

SELECT CsrPosterior
GO TOP 
Oavisar.proceso('S','Procesando afectaciones..') 

SCAN  
	SELECT CsrOrden
	SEEK CsrPosterior.orden
	IF !FOUND()
		LOOP 
	ENDIF 
	SELECT CsrMaopera
	LOCATE FOR id = CsrOrden.idmaopera
	IF FOUND()
		lcclasecomp	=	CsrMaopera.clasecomp
		lcorigen	= 	CsrMaopera.origen
		lnidcomproba=	CsrMaopera.idcomproba
		
		SELECT CsrMovCtacte
		LOCATE FOR idmaopera = CsrMaopera.id
		
		&&Imputamos el comprobante
		SELECT CsrAfectados
		SEEK CsrOrden.orden &&AND tipo = lctipo
		
		&&Puede que un comporbante afecte a mas d eun comprobante
		DO WHILE CsrAfectados.orden = CsrPosterior.orden AND !EOF() &&AND tipo=lctipo
			&&Si lo encontramos en el afeprov. fue afectado 
			IF orden = CsrPosterior.orden AND !(CsrAfectados.estado$'A')
				STORE 0 TO lnidmaoperad,lniddebe,lnidmaoperah,lnidhaber,lnimporte
*!*					IF CsrAfectados.orden$'0000830745-0000830637' AND CsrAfectados.ordenafe$'0000830745-0000830637'
*!*						stop()
*!*					ENDIF 
				llok = .f.
				&&Posicionamos en el comprobante afectador/afectado
				SELECT CsrOrden
				SEEK CsrAfectados.orden
				&&Si lo encontramos generamos la afectacion por el comprobante
				IF CsrOrden.orden = CsrAfectados.orden AND FOUND()
					SELECT CsrMovCtacte
					LOCATE FOR idmaopera = CsrOrden.idmaopera
					llok = IIF(idmaopera = CsrOrden.idmaopera,.t.,llok)
				ENDIF 
				IF !llok
					SELECT CsrAfectados
					SKIP
					LOOP 
				ENDIF 
				
				lnidhaber 	 = IIF((CsrMaopera.clasecomp$'A-B-C'),0,CsrMovCtacte.id)
				lniddebe 	 = IIF(!(CsrMaopera.clasecomp$'A-B-C'),0,CsrMovCtacte.id)
				lnidmaoperah = IIF((CsrMaopera.clasecomp$'A-B-C'),0,CsrMovCtacte.idmaopera)
				lnidmaoperad = IIF(!(CsrMaopera.clasecomp$'A-B-C'),0,CsrMovCtacte.idmaopera)
				lnimporte	 = CsrAfectados.importe	
				
				lnordenabuscar = CsrAfectados.ordenafe &&Afectado/Afectado
				lnEntro=0
				llok = .f.
				&&Buscamos si existe el afectador/afectado en el CsrPosterior
				SELECT CsrOrden
				SEEK lnOrdenABuscar
				&&Si lo encontramos generamos la afectacion por el comprobante
				IF CsrOrden.orden = lnordenabuscar AND FOUND()
					SELECT CsrMovCtacte
					LOCATE FOR idmaopera = CsrOrden.idmaopera
					IF idmaopera = CsrOrden.idmaopera
						llok = .t.
						lnEntro=1
					ENDIF 				
				ELSE
					&&afectaciones con orden nulo
					IF LEN(LTRIM(lnordenabuscar))=0
						LOOP 
					ENDIF 
					&&Sino esta en los posteriores. Debemos afectar al saldo anterior
					SELECT CsrAnterior
					SEEK VAL(CsrMovCtacte.ctacte)
					IF VAL(CsrMovCtacte.ctacte) = CsrAnterior.cliente AND FOUND()
						SELECT CsrMovctacte
						LOCATE FOR idmaopera = CsrAnterior.idmaopera
						IF idmaopera = CsrAnterior.idmaopera
							llok = .t.		
							lnEntro=2				
						ENDIF 						
					ENDIF 
				ENDIF 
				
				IF llok
					lnidhaber 	 = IIF(lnidhaber =0,CsrMovctacte.id,lnidhaber)
					lniddebe 	 = IIF(lniddebe =0,CsrMovCtacte.id,lniddebe)
					lnidmaoperah = IIF(lnidmaoperah=0,CsrMovctacte.idmaopera,lnidmaoperah)
					lnidmaoperad = IIF(lnidmaoperad=0,CsrMovCtacte.idMaopera,lnidmaoperad)
					lnimporteAfe = CsrAfectados.importe
					
					SELECT CsrAfeCtacte
					LOCATE FOR idmaoperah = lnidmaoperah AND idmaoperad = lnidmaoperad
					IF idmaoperah = lnidmaoperah AND idmaoperad = lnidmaoperad
						&&Si entro por lnEntro=2. Quiere decir que el comprobante esta compactado
						&&Por lo tanto debe incrementar a la afectacion el importe afectado.
						&&Y luego restar al total del comprobante compactado los saldos afectados
						&&Puede ser que se de el caso que incremente el saldo
						&&Si en una N.Credito y un R.Pago.
						IF lnEntro=2
							replace importe WITH importe + lnImporteAfe IN CsrAfeCtacte
							replace saldo WITH saldo - lnImporteAfe IN CsrMovCtacte						
						ENDIF 
						&&Ya se grabo con anterioridad
						SELECT CsrAfectados
						SKIP 
						LOOP 
					ENDIF 
					INSERT INTO Csrafectacte(id,idmaoperad,iddebe,idmaoperah,idhaber,importe);
					VALUES (lnidafectacte,lnidmaoperad,lniddebe,lnidmaoperah,lnidhaber,lnimporte)
					IF lnEntro=2 &&Unica vez con el primer registro  de la afectacion
						replace saldo WITH saldo - lnImporteAfe IN CsrMovCtacte
					ENDIF 
					
					lnidafectacte = lnidafectacte +1
				ENDIF 
			ENDIF 
			SELECT CsrAfectados
			SKIP 
		ENDDO 
	ENDIF
	SELECT CsrPosterior
ENDSCAN
SELECT CsrAfeCtacte
oavisar.proceso('N')
*BROWSE  



Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE  IN  CsrAcreedor 
USE  IN CsrMoviprov 
USE  IN  CsrComproba 
USE IN CsrAfeProv
USE IN CsrOrden