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

TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrParaConta.* FROM ParaConta as CsrParaConta
where idejercicio = <<goapp.idejercicio>>
ENDTEXT 
IF !CrearCursorAdapter('CsrParaConta',lccmd)
	MESSAGEBOX('Nose puede importar, pq no cargado el CsrParaConta')
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
llok = CargarTabla(lcData,'CabeFac')
llok = CargarTabla(lcData,'TablaImp')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Maopera')
llok = CargarTabla(lcData,'MovCaja')
llok = CargarTabla(lcData,'MovBcocar')
llok = CargarTabla(lcData,'Valor')
llok = CargarTabla(lcData,'ClaseValor')
llok = CargarTabla(lcData,'RenCtacte')
llok = CargarTabla(lcData,'Fletero')
llok = CargarTabla(lcData,'TablaAsi')
llok = CargarTabla(lcData,'AfeCtacte')


IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON

USE  ALLTRIM(lcpath )+"\gestion\clientes" in 0 alias CsrDeudor EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movimien" in 0 alias CsrMovipub EXCLUSIVE

*USE  ALLTRIM(lcpath )+"\gestion\comproba" in 0 alias CsrComproba EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\tablaope" in 0 alias CsrTablaOpe EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movbacar" in 0 alias CsrMovBco EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\afectaci" in 0 alias CsrAfectacion EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\afeventa" in 0 alias CsrAfeVentas EXCLUSIVE

CREATE CURSOR CsrOrden(orden c(15),idmaopera n(12,0))
INDEX on orden TAG orden 

CREATE CURSOR CsrComproba (numero i,debcre c(1),nombre c(20))
INSERT INTO Csrcomproba VALUES (2,"D","FACTURA")
INSERT INTO Csrcomproba VALUES (3,"D","N.DEBITO")
INSERT INTO Csrcomproba VALUES (4,"C","N.CREDITO")
INSERT INTO Csrcomproba VALUES (5,"C","RECIBO")

*fecha de importacion
ldfecha		=CTOD(lcfecha)
lcfiscal	=ALLTRIM(STR(YEAR(ldfecha)))+ALLTRIM(STRzero(MONTH(ldfecha),2,0))+ALLTRIM(STRzero(DAY(ldfecha),2,0))

lnidmaopera		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidrenCtacte	= RecuperarID('CsrRenCtacte',Goapp.sucursal10)
lnidmovctacte	= RecuperarID('CsrMovCtacte',Goapp.sucursal10)
lnidcabefac		= RecuperarID('CsrCabefac',Goapp.sucursal10)
lindtablaimp	= RecuperarID('CsrTablaImp',Goapp.sucursal10)
lnidmovcaja		= RecuperarID('CsrMovCaja',Goapp.sucursal10)
lnidmovbcocar	= RecuperarID('CsrMovBcocar',Goapp.sucursal10)
lnidtablaasi	= RecuperarID('CsrTablaAsi',Goapp.sucursal10)
lnidtablaimp	= RecuperarID('CsrTablaImp',Goapp.sucursal10)
lnidafectacte	= RecuperarID('CsrAfeCtacte',Goapp.sucursal10)

ldfechasis	=DATETIME(YEAR(ldfecha),MONTH(ldfecha),DAY(ldfecha),0,0,0)
ldfechas	=DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)

		
Oavisar.proceso('S','Recalculando saldo anterior') 	

**** sumatoria de los movimientos anteriores
SELECT cliente,IIF(ISNULL(CsrDeudor.saldo_ant),0,CsrDeudor.saldo_ant) as saldo_ant;
,SUM(importeco) as pago,SUM(saldocomp) as saldo;
FROM Csrmovipub ;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
left JOIN csrDeudor ON csrMovipub.cliente = CsrDeudor.numero;
where fecha<ldfecha AND CsrComproba.debcre='C';
GROUP BY cliente,CsrDeudor.saldo_ant INTO CURSOR CsrAntDebito READWRITE 

replace ALL pago WITH IIF(saldo_ant<0,(saldo_ant*-1)+pago,pago-saldo_ant) IN CsrAntDebito

SELECT cliente,SUM(importeco) as importe, SUM(saldocomp) as saldo;
FROM Csrmovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha<ldfecha  AND  CsrComproba.debcre='D';
GROUP BY cliente INTO CURSOR CsrAntCredito READWRITE 

SELECT distinct cliente FROM Csrmovipub ORDER BY cliente INTO CURSOR CsrClientes READWRITE 

SELECT Csrclientes.cliente,CAST(0 as n(12,0)) as idmaopera;
,IIF(ISNULL(CsrAntCredito.importe),CAST(0 as numeric(11,2)),CsrAntCredito.importe) as importe;
,IIF(ISNULL(CsrAntDebito.pago),CAST(0 as numeric(11,2)),CsrAntDebito.pago) as pago;
,IIF(ISNULL(CsrAntCredito.saldo),CAST(0 as numeric(11,2)),CsrAntCredito.saldo) - ;
 IIF(ISNULL(CsrAntDebito.saldo),CAST(0 as numeric(11,2)),CsrAntDebito.saldo) as saldo;
FROM CsrClientes;
LEFT JOIN  CsrAntCredito ON Csrclientes.cliente=CsrAntCredito.cliente;
LEFT JOIN  CsrAntDebito ON Csrclientes.cliente=CsrAntDebito.cliente;
into CURSOR CsrAnterior READWRITE

SELECT CsrAnterior
INDEX on cliente TAG cliente

replace ALL importe WITH (importe-pago) IN CsrAnterior
DELETE FROM CsrAnterior WHERE saldo=0 AND importe=0

****sumatoria de los movimientos posteriores
SELECT cliente,SUM(importeco) as pago;
FROM Csrmovipub ;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha>=ldfecha AND CsrComproba.debcre='C';
GROUP BY cliente INTO CURSOR CsrDebito READWRITE 

SELECT  cliente,SUM(importeco) as importe;
FROM Csrmovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha>=ldfecha AND  CsrComproba.debcre='D';
GROUP BY cliente INTO CURSOR CsrCredito READWRITE 

SELECT distinct cliente FROM Csrmovipub ORDER BY cliente INTO CURSOR CsrClientes READWRITE 

SELECT Csrclientes.cliente;
,IIF(ISNULL(CsrCredito.importe),CAST(0 as numeric(11,2)),CsrCredito.importe) as importe;
,IIF(ISNULL(CsrDebito.pago),CAST(0 as numeric(11,2)),CsrDebito.pago) as pago;
,CAST(0 as numeric(11,2)) as saldo;
FROM CsrClientes;
LEFT JOIN  CsrCredito ON Csrclientes.cliente = CsrCredito.cliente;
LEFT JOIN  CsrDebito ON Csrclientes.cliente = CsrDebito.cliente;
into CURSOR CsrSaldosPost READWRITE

replace ALL saldo WITH importe-pago IN CsrSaldosPost
DELETE FROM CsrSaldosPost WHERE saldo=0

UPDATE CsrCtacte SET saldo = 0 WHERE ctadeudor = 1

SELECT CsrAnterior
Oavisar.proceso('S','Generando saldo anterior por compactación') 
GO top
SCAN FOR !EOF('CsrAnterior')
	SELECT CsrCtacte
	LOCATE FOR ALLTRIM(cnumero)==ALLTRIM(STR(CsrAnterior.cliente))
	IF  ALLTRIM(cnumero)=ALLTRIM(STR(CsrAnterior.cliente))
		lnsigno=1
		&&Dejamos pasar las facturas. Por el saldo.
		replace Csrctacte.saldoant WITH 0, Csrctacte.saldo WITH CsrAnterior.Saldo IN CsrCtacte
		ldfechas=ldfechasis
		lnidcomproba=36
		lnimporte=CsrAnterior.importe
		lcclasecomp="F"
		IF lnimporte<0
			lnsigno=-1
			lnidcomproba=37
			lcclasecomp="G"
		ENDIF
		lnimporte		= lnimporte*lnsigno
		lcletra			= IIF(CsrCtacte.tipoiva=1,"A","B")
		lcnum			= strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0')
		lcnumero		= lcletra+"0000"+lcnum
		lcswitch		= "00000"
		lnSaldo			= ABS(CsrAnterior.saldo)
		lcctacte		= CsrCtacte.cnumero
		lnidctacte		= CsrCtacte.id
		ldfechaserver	= DATETIME()
		ldfechasis		= FechaHoraCero(ldfechaserver)
		
		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor;
		,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,detalle;
		,fechaserver);
		VALUES (lnidmaopera,"MOV","IMPORTACIÓN MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,lcswitch,"0";
		,"Importación. Compactación Mov Cliente.",ldfechaserver)
		
		lcswitch		= "00100"
		INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
		,entrega,vencimien,total,detalle,pefiscal,switch,signo);
		VALUES (lnidmovctacte,lnidmaopera,ldfecha-1,lcctacte,lnidctacte," ",0,1,lnimporte;
		,lnSaldo,0,ldfecha-1,lnimporte,"Saldo de Importación",SUBSTR(lcfiscal,1,6),lcswitch,lnsigno)
		
		replace idmaopera WITH lnidmaopera IN CsrAnterior
		
		lnidmovctacte=lnidmovctacte+1
		lnidmaopera=lnidmaopera+1
	ENDIF
ENDSCAN 

Oavisar.proceso('S','Extrayendo comprobantes desde la fecha')		
*fecha de importacion
ldfecha		=CTOD(lcfecha)

SELECT CsrMovipub.cliente,SPACE(20) as detalle,IIF((CsrComproba.debcre='C'),CsrMovipub.Importeco*-1,CsrMovipub.Importeco) as importe;
,CsrMovipub.fecha,CsrMovipub.letra,CsrMovipub.talonario,CsrMovipub.numcomp ,CsrMovipub.saldocomp;
,CsrMovipub.vencimien,SPACE(15) as orden,CsrMovipub.tipocomp; 
,0 as rendida;
,0 as repartidor;
FROM CsrMovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero ;
WHERE CsrMovipub.fecha=>ldfecha ;
order by cliente into cursor CsrPosterior READWRITE 

replace ALL orden WITH strzero(tipocomp,2)+left(letra,1)+strzero(talonario,4)+strzero(numcomp,8) IN CsrPosterior

SELECT CsrPosterior.Orden,CsrTablaOpe.importe as impvalor;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor;
,IIF(ISNULL(CsrValor.numero),0,CsrValor.numero) as valor;
,CsrTablaOpe.cliente,CsrTablaOpe.debehaber,CsrTablaOpe.detalle;
FROM CsrPosterior;
left JOIN CsrTablaOpe ON CsrPosterior.tipocomp = CsrTablaOpe.tipocomp AND CsrPosterior.letra = CsrTablaOpe.letra ;
AND CsrPosterior.talonario = CsrTablaOpe.talon AND CsrPosterior.numcomp = CsrTablaOpe.numcomp;
left JOIN CsrValor ON CsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where CsrTablaOpe.origen="R" AND valor<>0 into CURSOR CsrAuxTablaOpe READWRITE 

SELECT CsrAuxTablaOpe
INDEX on orden TAG korden
SET ORDER TO korden

SELECT RECNO() as idcheque,CsrMovBco.*,CsrTablaOpe.cliente;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor;
,IIF(ISNULL(CsrCtacte.cnombre),SPACE(25),CsrCtacte.cnombre) as nomctacte;
,IIF(!(CsrMovBco.entregado),'0','1') as aentregar;
,IIF(!(CsrMovBco.depositado),'0','1') as depositados;
,CsrAfeVentas.letra as letraAfe,CsrAfeVentas.talonario as talonarioAfe,CsrAfeVentas.numcomp as numcompAfe,SPACE(15) as orden,CsrAfeVentas.tipocomp as tipocompAfe; 
FROM CsrMovBco ;
LEFT JOIN CsrAfeVentas ON CsrMovBco.tipocomp = CsrAfeVentas.tipocompb  and CsrMovBco.numcomp = CsrAfeVentas.numcompb and CsrMovBco.importe = CsrAfeVentas.importe ;
AND CsrMovBco.fecha = CsrAfeVentas.fecha AND CsrMovBco.fecha_vto=CsrAfeVentas.fechavto AND CsrMovBco.fecha_real = CsrAfeVentas.fecha_real ;
left JOIN CsrTablaOpe ON CsrAfeVentas.tipocomp = CsrAfeVentas.tipocomp AND CsrAfeVentas.letra = CsrTablaOpe.letra ;
AND CsrAfeVentas.talonario = CsrTablaOpe.talon AND CsrAfeVentas.numcomp = CsrTablaOpe.numcomp;
left JOIN CsrValor ON CsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrCtacte ON CsrTablaOpe.cliente = VAL(CsrCtacte.cnumero);
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where CsrMovBco.tipocomp=3 AND CsrMovBco.fecha_vto > ldfecha-60 and CsrClaseValor.numero='T';
INTO CURSOR CsrAuxMovBco READWRITE 

replace ALL orden WITH strzero(tipocompAfe,2)+left(letraAfe,1)+strzero(talonarioAfe,4)+strzero(numcompAfe,8) IN CsrAuxMovBco

&&AND CsrMovBco.depositado <> .T.;

SELECT CsrAuxMovBco
INDEX on orden TAG kcheque
SET ORDER TO kcheque
oavisar.proceso('N')
*BROWSE 

SELECT CsrSaldosPost
SCAN 
	SELECT CsrCtacte
	LOCATE FOR  VAL(cnumero)=CsrSaldosPost.cliente
	IF FOUND()
		replace Csrctacte.saldo WITH CsrCtacte.saldo+CsrSaldosPost.saldo IN CsrCtacte
	ENDIF 
ENDSCAN 

lcidcheque = ""

SELECT CsrPosterior

Oavisar.proceso('S','Procesando movimientos posteriores') 

SCAN  FOR !EOF('CsrPosterior')
	SELECT CsrCtacte
	LOCATE FOR VAL(cnumero)=CsrPosterior.cliente
	IF FOUND()
		*ldfechas=DATETIME(YEAR(CsrPosterior.fecha),month(CsrPosterior.fecha),day(CsrPosterior.fecha),0,0,0)
		lnsigno		= 1
		lnimporte	= CsrPosterior.importe
		lntipocomp	= CsrPosterior.tipocomp
		lnidcomproba= 0
		DO case
			CASE lntipocomp=1      && remito
				lnidcomproba = 38
				lcclasecomp	 = 'X'
			CASE lntipocomp=2	&& factura
				lnidcomproba = 1
				lcclasecomp	 = 'A'
			CASE lntipocomp=3	&& n.deb
				lnidcomproba = 2
				lclasecomp	 = 'B'
			CASE lntipocomp	=4	&& n.cre
				lnidcomproba = 3
				lcclasecomp	 ='C'
				lnsigno 	 = -1
			CASE lntipocomp = 5 OR lntipocomp=6 &&recibos manuales entrada
				lnidcomproba = 4
				lcclasecomp	 ='D'
				lnsigno = -1
			CASE lntipocomp = 12 &&credito
				lnidcomproba = 37
				lcclasecomp	 ='G'
				lnsigno		 = -1
			CASE lntipocomp = 11 OR lntipocomp =10 OR lntipocomp=7 &&debito
				lnidcomproba = 36
				lcclasecomp	 ='F'
		ENDCASE 
	
		lnimporte	= CsrPosterior.importe*lnsigno	
		
		lcdetalle	= IIF(lnidcomproba=4,"Recibo cobro rendición","Movimiento ctacte")+" Importado"
		lcorigen	= IIF(lnidcomproba=4,"COB","MOV")
		
		lcletra		= LTRIM(CsrPosterior.letra)
		lcletra		= IIF(LEN(LTRIM(lcletra))=0,IIF(CsrCtacte.tipoiva=1,"A","B"),LEFT(CsrPosterior.letra,1))
		lcletra		= IIF(lnidcomproba=4,'X',lcletra)
		lcnum		= STRZERO(CsrPosterior.numcomp,8)
		lcnum		= IIF(LEN(LTRIM(lcnum))=0,strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0'),lcnum)
		lctalonario	= STRZERO(CsrPosterior.talonario,4)
		lctalonario = IIF(LEN(LTRIM(lctalonario))=0,"0000",lctalonario)
		lcnumero	= lcletra+lctalonario+lcnum
		
		ldfechaserver	= DATETIME()
		ldfechasis		= FechaHoraCero(ldfechaserver)
		
		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector	,fechasis,idoperador;
		,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch;
		,estado,detalle,fechaserver);
		VALUES (lnidmaopera,lcorigen,"IMPORTACION MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,"00000","0","Importación";
		,ldfechaserver)
		
		INSERT INTO CsrOrden (orden,idmaopera) VALUES (CsrPosterior.orden,lnidmaopera)
		
		lnidctacte	= CsrCtacte.id
		lcctacte	= Csrctacte.cnumero
		ldfecha		= DATETIME(YEAR(CsrPosterior.fecha),month(CsrPosterior.fecha),day(CsrPosterior.fecha),0,0,0)
		lcperiodo	= ALLTRIM(STR(YEAR(ldfecha)))+ALLTRIM(STRzero(MONTH(ldfecha),2,0))
		lnSaldo		= CsrPosterior.saldocomp
		ldfechavto	= DATETIME(YEAR(CsrPosterior.vencimien),month(CsrPosterior.vencimien),day(CsrPosterior.vencimien),0,0,0)
		
		
		INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
		,entrega,vencimien,total,detalle,pefiscal,switch,signo);
		VALUES (lnidmovctacte,lnidmaopera,ldfecha,lcctacte,lnidctacte," ",0,1,lnimporte,lnSaldo;
		,0,ldfechavto,lnimporte,lcdetalle,lcperiodo,"00000",lnsigno)
		
		&&Importamos los valores
		SELECT CsrAuxTablaOpe
		GO TOP 
		SEEK CsrPosterior.orden 
		DO WHILE CsrAuxTablaOpe.orden = CsrPosterior.orden
			
			DO CASE 
			CASE CsrAuxTablaOpe.clasevalor$'T-P'
			
				SELECT CsrAuxMovBco
				lcClave = LTRIM(CsrAuxTablaope.orden)
				IF !SEEK (lcClave,'CsrAuxMovBco','kcheque')
					SELECT CsrAuxTablaOpe
					SKIP 
					LOOP 
				ENDIF 
				
				lnidcheque  = CsrAuxMovBco.idcheque					
				lnimporte	= CsrAuxMovBco.importe
				lnnumero	= CsrAuxMovBco.numcomp
				lcbanco		= CsrAuxMovBco.banco
				lclocalidad	= CsrAuxMovBco.localidad
				ldfecha		= CsrAuxMovBco.fecha
				ldfechavto	= CsrauxMovBco.fecha_vto
				lctitular	= CsrAuxMovBco.titular
				lcrecibido	= CsrAuxMovBco.recibidode
				lcentregado	= CsrAuxMovBco.nomctacte
				lcdetalle	= CsrAuxMovBco.detalle
				lcSwitch	= IIF(VAL(CsrAuxMovBco.aentregar)+VAL(CsrAuxMovBco.depositados)>0,'1','0')+'0000'
				
				INSERT INTO CsrMovbcocar (id,idmaopera,origen,importe,idtipomov,numero;
				,idctabco,banco,localidad,fecha,fechavto,cuit,titular,recibido,entregado;
				,detalle,signo,switch);
				VALUES (lnidmovbcocar,lnidmaopera,'3RO',lnimporte,16,lnnumero,0,lcbanco;
				,lclocalidad,ldfecha,ldfechavto,'',lctitular,lcrecibido;
				,lcentregado,lcdetalle,1,lcSwitch)	
				
				lnidmovbcocar = lnidmovbcocar + 1	
				DELETE FROM CsrAuxMovBco WHERE idcheque = lnidcheque
				*lcidcheque = LTRIM(lcidcheque) + IIF(LEN(LTRIM(lcidcheque))#0,',','') + LTRIM(CsrAuxMovBco.idcheque)
			CASE CsrAuxTablaOpe.clasevalor$'E-N' AND NOT strzero(CsrAuxTablaOpe.valor ,2)$'33-34'
				
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
			CASE CsrAuxTablaOpe.clasevalor$'E-N' AND strzero(CsrAuxTablaOpe.valor ,2)$'33-34'
				
				lcdebehaber = 'D'
				lnidorigen	= lnidmovctacte
				lctablaori	= 'MOCT'
				lnimporte 	= CsrAuxTablaOpe.impvalor
				lcdetalle	= CsrAuxTablaOpe.detalle
				lnidprovincia = 0
				lcnombre	= ""
				lnidcuenta	= 0
				
				IF lnimporte<0
					lcdebehaber = IIF(lcdebehaber$'D','H','D')
					lnimporte = ABS(lnimporte)
				ENDIF 
				
				IF CsrAuxTablaOpe.valor = 33
					lctipoconce = "RB"
					SELECT CsrParaConta
					LOCATE FOR numero = 9
					IF !numero = 9
						LOOP 
					ENDIF 
					lnidcuenta = CsrParaConta.idcuenta
					SELECT CsrProvincia
					LOCATE FOR numero = 2
					lnidprovincia = CsrProvincia.id
					lcnombre = "IBTO2"

				ELSE
					lctipoconce = "RG"
					SELECT CsrParaConta
					LOCATE FOR numero = 10
					IF !numero = 10
						LOOP 
					ENDIF 
					lnidcuenta = CsrParaConta.idcuenta
				ENDIF 

				INSERT INTO CsrTablaAsi (id,idmaopera,idcuenta,debehaber,importe,detalle;
				,tablaori,idorigen,tipoconce);
				VALUES (lnidtablaasi,lnidmaopera,lnidcuenta,lcdebehaber,lnimporte;
				,lcdetalle,lctablaori,lnidorigen,lctipoconce)
        		
        		lnidtablaasi = lnidtablaasi + 1 
				
				INSERT INTO tablaimp (id,idmaopera,idorigen,tablaori,idasiento,idcuenta,tipoconce;
	        	,importe,tasa,baseimp,nombre,detalle,idprovincia);
	     		VALUES (lnidtablaimp,lnidmaopera,lnidorigen,lctablaori,0,lnidcuenta,lctipoconce;
	     		,lnimporte,0,0,LCNOMBRE,lcdetalle,lnidprovincia)
				
				lnidtablaimp = lnidtablaimp + 1
					
				
			ENDCASE 
			SELECT CsrAuxTablaOpe
			SKIP 
		ENDDO 

		lnidmovctacte	=lnidmovctacte+1
		lnidmaopera		=lnidmaopera+1

	ENDIF
	SELECT CsrPosterior
ENDSCAN 

&&Generaremos un registro de cheques en cartera que no fueron grabados. Entregados pero no vencidos
SELECT CsrauxMovBco
GO TOP 
SCAN 
   && cheque
	lnidcomproba = 16
	lcclasecomp	 = 'O'
			
	lcidcheque  = CsrAuxMovBco.idcheque					
	lnimporte	= CsrAuxMovBco.importe
	lnnumero	= CsrAuxMovBco.numcomp
	lcbanco		= CsrAuxMovBco.banco
	lclocalidad	= CsrAuxMovBco.localidad
	ldfecha		= CsrAuxMovBco.fecha
	ldfechavto	= CsrauxMovBco.fecha_vto
	lctitular	= CsrAuxMovBco.titular
	lcrecibido	= CsrAuxMovBco.recibidode
	lcentregado	= CsrAuxMovBco.nomctacte
	lcdetalle	= CsrAuxMovBco.detalle
		
	lcletra		= " "
	lcnum		= STRZERO(lnnumero,8)
	lcnum		= IIF(LEN(LTRIM(lcnum))=0,strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0'),lcnum)
	lctalonario	= "0000"
	lcnumero	= lcletra+lctalonario+lcnum
	lcSwitch	= IIF(VAL(CsrAuxMovBco.aentregar)+VAL(CsrAuxMovBco.depositados)>0,'1','0')+'0000'
	
	ldfechaserver	= DATETIME()
	ldfechasis		= FechaHoraCero(ldfechaserver)
		
	INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector	,fechasis,idoperador;
	,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch;
	,estado,detalle,fechaserver);
	VALUES (lnidmaopera,"CAR","IMPORTACION MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
	,111,111,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,"0000","0","Importación de Cartera";
	,ldfechaserver)
	
	INSERT INTO CsrMovbcocar (id,idmaopera,origen,importe,idtipomov,numero;
	,idctabco,banco,localidad,fecha,fechavto,cuit,titular,recibido,entregado;
	,detalle,signo,switch);
	VALUES (lnidmovbcocar,lnidmaopera,'3RO',lnimporte,lnidcomproba,lnnumero,0,lcbanco;
	,lclocalidad,ldfecha,ldfechavto,'',lctitular,lcrecibido;
	,lcentregado,lcdetalle,1,lcSwitch)	
		
	lnidmovbcocar = lnidmovbcocar + 1
	lnidmaopera		=lnidmaopera+1
ENDSCAN 

SELECT CsrAfectacion.*,SPACE(15) as orden, SPACE(15) as ordenafe,SPACE(1) as estado FROM CsrAfectacion INTO CURSOR CsrAfeMov READWRITE 
replace ALL orden WITH strzero(tipocomp,2)+left(letra,1)+strzero(talonario,4)+strzero(numcomp,8) IN CsrAfeMov
replace ALL ordenafe WITH strzero(tipoafe,2)+left(letrafe,1)+strzero(taloafe,4)+strzero(numafe,8) IN CsrAfeMov

SELECT CsrAfeMov
vista()

SELECT 'D' as tipo,CsrOrden.orden,CsrAfeMov.ordenafe,CsrAfeMov.importe,CsrAfeMov.estado;
FROM CsrOrden inner JOIN CsrAfeMov ON CsrOrden.orden = CsrAfeMov.orden ;
union ALL ;
SELECT 'A' as tipo,CsrOrden.orden,CsrAfeMov.orden as ordenafe,CsrAfeMov.importe,CsrAfeMov.estado;
FROM CsrOrden inner JOIN CsrAfeMov ON CsrOrden.orden = CsrAfeMov.ordenafe;
INTO CURSOR CsrAfectados READWRITE 

SELECT CsrAfectados
vista()

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
				IF CsrAfectados.orden$'05A000000018263'
					stop()
				ENDIF 
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
SELECT csrAuxMovBco
*BROWSE 

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

USE IN CsrDeudor
USE IN CsrMovipub
USE IN CsrComproba
USE IN CsrTablaOpe
USE IN CsrMovBco
USE IN CsrAfectacion
USE IN CsrAfeVentas

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
