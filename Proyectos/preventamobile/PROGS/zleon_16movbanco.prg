PARAMETERS ldfecha,lcpath
lcfecha = IIF(PCOUNT()< 1,"01-08-2010",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)

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
&&Tomamos la ultima caja
TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT TOP 1 CsrDetaNroCaja.* FROM DetaNroCaja as CsrDetaNroCaja
order by id desc
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

llok = CargarTabla('leon','Provincia')
llok = CargarTabla('leon','MovCtacte')
llok = CargarTabla('leon','CabeFac')
llok = CargarTabla('leon','TablaImp')
llok = CargarTabla('leon','Ctacte')
llok = CargarTabla('leon','PlanCue')
llok = CargarTabla('leon','Maopera')
llok = CargarTabla('leon','MovCaja')
llok = CargarTabla('leon','MovBcocar')
llok = CargarTabla('leon','Valor')
llok = CargarTabla('leon','ClaseValor')
llok = CargarTabla('leon','RenCtacte')
llok = CargarTabla('leon','Fletero')

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON

USE  ALLTRIM(lcpath )+"\gestion\clientes" in 0 alias CsrDeudor EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movimien" in 0 alias CsrMovipub EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\comproba" in 0 alias CsrComproba EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\tablaope" in 0 alias CsrTablaOpe EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movbacar" in 0 alias CsrMovBco EXCLUSIVE


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

ldfechasis	=DATETIME(YEAR(ldfecha),MONTH(ldfecha),DAY(ldfecha),0,0,0)
ldfechas	=DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)

		
Oavisar.proceso('S','Recalculando saldo anterior') 	

**** sumatoria de los movimientos anteriores
SELECT cliente,IIF(ISNULL(CsrDeudor.saldo_ant),0,CsrDeudor.saldo_ant) as saldo_ant;
,SUM(importeco) as pago;
FROM Csrmovipub ;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
left JOIN csrDeudor ON csrMovipub.cliente = CsrDeudor.numero;
where fecha<ldfecha AND estado<>'A' AND CsrComproba.debcre='C';
GROUP BY cliente,CsrDeudor.saldo_ant INTO CURSOR CsrAntDebito READWRITE 

replace ALL pago WITH IIF(saldo_ant<0,(saldo_ant*-1)+pago,pago-saldo_ant) IN CsrAntDebito

SELECT cliente,SUM(importeco) as importe;
FROM Csrmovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha<ldfecha AND estado<>'A' AND  CsrComproba.debcre='D';
GROUP BY cliente INTO CURSOR CsrAntCredito READWRITE 

SELECT distinct cliente FROM Csrmovipub ORDER BY cliente INTO CURSOR CsrClientes READWRITE 

SELECT Csrclientes.cliente;
,IIF(ISNULL(CsrAntCredito.importe),CAST(0 as numeric(11,2)),CsrAntCredito.importe) as importe;
,IIF(ISNULL(CsrAntDebito.pago),CAST(0 as numeric(11,2)),CsrAntDebito.pago) as pago;
,CAST(0 as numeric(11,2)) as saldo;
FROM CsrClientes;
LEFT JOIN  CsrAntCredito ON Csrclientes.cliente=CsrAntCredito.cliente;
LEFT JOIN  CsrAntDebito ON Csrclientes.cliente=CsrAntDebito.cliente;
into CURSOR CsrAnterior READWRITE

replace ALL saldo WITH importe-pago IN CsrAnterior
DELETE FROM CsrAnterior WHERE saldo=0
****sumatoria de los movimientos posteriores

SELECT cliente,SUM(importeco) as pago;
FROM Csrmovipub ;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha>=ldfecha AND estado<>'A' AND CsrComproba.debcre='C';
GROUP BY cliente INTO CURSOR CsrDebito READWRITE 

SELECT  cliente,SUM(importeco) as importe;
FROM Csrmovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha>=ldfecha AND estado<>'A' AND  CsrComproba.debcre='D';
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
		lnidcomproba=37
		lnimporte=CsrCtacte.saldo
		lcclasecomp="G"
		IF lnimporte<0
			lnsigno=-1
			lnidcomproba=36
			lcclasecomp="F"
		ENDIF
		lnimporte	= lnimporte*lnsigno
		lcletra		= IIF(CsrCtacte.tipoiva=111,"A","B")
		lcnum		= strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0')
		lcnumero	= lcletra+"0000"+lcnum
		lcswitch	= "00000"
		
		lcctacte	= CsrCtacte.cnumero
		lnidctacte	= CsrCtacte.id
		
		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor;
		,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,detalle;
		,fechaserver);
		VALUES (lnidmaopera,"MOV","IMPORTACIÓN MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,111,111,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,lcswitch,"0";
		,"Importación. Compactación Mov Cliente.",ldfechasis)
		
		 &&Ponemos el Saldo en 0 de los mov compactados.  
		INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
		,entrega,vencimien,total,detalle,pefiscal,switch,signo);
		VALUES (lnidmovctacte,lnidmaopera,ldfecha-1,lcctacte,lnidctacte," ",0,1,lnimporte;
		,0,0,ldfecha-1,lnimporte,"Saldo de Importación",SUBSTR(lcfiscal,1,6),"00000",lnsigno)
		
		lnidmovctacte=lnidmovctacte+1
		lnidmaopera=lnidmaopera+1
	ENDIF
ENDSCAN 

Oavisar.proceso('S','Extrayendo comprobantes desde la fecha')		


SELECT CsrMovipub.cliente,CsrMovipub.detalle,IIF((CsrComproba.debcre='C'),CsrMovipub.Importeco*-1,CsrMovipub.Importeco) as importe;
,CsrMovipub.fecha,CsrMovipub.letra,CsrMovipub.talonario,CsrMovipub.numcomp ,CsrMovipub.saldocomp;
,CsrMovipub.vencimien,CsrMovipub.orden,CsrMovipub.tipocomp; 
,IIF(CsrMovipub.rendida='S',1,0) as rendida;
,IIF(CsrMovipub.reparinde=0,CsrMovipub.repalleva,CsrMovipub.reparinde) as repartidor;
FROM CsrMovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero ;
WHERE CsrMovipub.fecha=>ldfecha AND CsrMovipub.estado<>'A';
order by cliente into cursor CsrPosterior READWRITE 

SELECT CsrTablaOpe.Orden,CsrTablaOpe.importe as impvalor;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor,CsrTablaope.cheque;
,CsrTablaOpe.cliente,CsrTablaOpe.debehaber,CsrTablaOpe.detalle;
FROM CsrPosterior;
left JOIN CsrTablaOpe ON CsrPosterior.orden = CsrTablaOpe.orden;
left JOIN CsrValor ON CsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where valor<>0 into CURSOR CsrAuxTablaOpe READWRITE 

SELECT CsrAuxTablaOpe
INDEX on orden TAG korden
SET ORDER TO korden

SELECT CsrMovBco.*,CsrTablaOpe.vendedor,CsrTablaOpe.cliente;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor;
,IIF(ISNULL(CsrCtacte.cnombre),SPACE(25),CsrCtacte.cnombre) as nomctacte;
,IIF(ISNULL(CsrMovBco.entregado),'0','1') as aentregar;
FROM CsrMovBco ;
LEFT JOIN CsrTablaOpe ON CsrMovBco.orden = CsrTablaOpe.orden AND CsrMovBco.numcomp = CsrTablaOpe.cheque;
left JOIN CsrValor ON CsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrCtacte ON CsrTablaOpe.cliente = VAL(CsrCtacte.cnumero);
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where LEN(LTRIM(CsrMovBco.idcheque))<>0 ;
AND CsrMovBco.fecha_vto > ldfecha;
AND CsrMovBco.depositado <> .T.;
INTO CURSOR CsrAuxMovBco READWRITE 

SELECT CsrAuxMovBco
INDEX on orden+STR(numcomp,10) TAG kcheque
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
				lnidcomproba = 28
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
		
		
		INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector	,fechasis,idoperador;
		,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch;
		,estado,detalle,fechaserver);
		VALUES (lnidmaopera,lcorigen,"IMPORTACION MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,111,111,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,"00000","0","Importación",ldfechasis)

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
					lcClave = LTRIM(CsrAuxTablaope.orden)+STR(CsrAuxTablaOpe.cheque,10)
					IF !SEEK (lcClave,'CsrAuxMovBco','kcheque')
						SELECT CsrAuxTablaOpe
						SKIP 
						LOOP 
					ENDIF 
					
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
					lcSwitch	= CsrAuxMovBco.aentregar+'0000'
					
					INSERT INTO CsrMovbcocar (id,idmaopera,origen,importe,idtipomov,numero;
					,idctabco,banco,localidad,fecha,fechavto,cuit,titular,recibido,entregado;
					,detalle,signo,switch);
					VALUES (lnidmovbcocar,lnidmaopera,'3RO',lnimporte,16,lnnumero,0,lcbanco;
					,lclocalidad,ldfecha,ldfechavto,'',lctitular,lcrecibido;
					,lcentregado,lcdetalle,1,lcSwitch)	
					
					lnidmovbcocar = lnidmovbcocar + 1	
					DELETE FROM CsrAuxMovBco WHERE idcheque = lcidcheque
					*lcidcheque = LTRIM(lcidcheque) + IIF(LEN(LTRIM(lcidcheque))#0,',','') + LTRIM(CsrAuxMovBco.idcheque)
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
			ENDCASE 
			SELECT CsrAuxTablaOpe
			SKIP 
		ENDDO 
		IF lnidcomproba = 4 &&REcibo de rendicion
			lcswitch	= STR(CsrPosterior.rendida,1)+"0000"
			lnidfletero = 0
			lnidvendedor= 0
			
			SELECT CsrFletero
			LOCATE FOR numero = CsrPosterior.repartidor
			IF FOUND() AND  numero = CsrPosterior.repartidor
				lnidfletero = CsrFletero.id
			ENDIF 
			INSERT INTO Csrrenctacte(id,idmovctacte,estado,idfletero,idvendedor,switch);
			VALUES (lnidrenctacte,lnidmovctacte,0,lnidfletero,lnidvendedor,lcswitch)
			
			lnidrenctacte = lnidrenctacte + 1
		ENDIF 
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
	lcSwitch	= CsrAuxMovBco.aentregar+'0000'
	
	INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector	,fechasis,idoperador;
	,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch;
	,estado,detalle,fechaserver);
	VALUES (lnidmaopera,"CAR","IMPORTACION MOVIMIENTOS",goapp.sucursal,goapp.terminal,1,ldfechasis;
	,111,111,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,"0000","0","Importación de Cartera";
	,ldfechasis)
	
	INSERT INTO CsrMovbcocar (id,idmaopera,origen,importe,idtipomov,numero;
	,idctabco,banco,localidad,fecha,fechavto,cuit,titular,recibido,entregado;
	,detalle,signo,switch);
	VALUES (lnidmovbcocar,lnidmaopera,'3RO',lnimporte,lnidcomproba,lnnumero,0,lcbanco;
	,lclocalidad,ldfecha,ldfechavto,'',lctitular,lcrecibido;
	,lcentregado,lcdetalle,1,lcSwitch)	
		
	lnidmovbcocar = lnidmovbcocar + 1
	lnidmaopera		=lnidmaopera+1
ENDSCAN 

					
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

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
