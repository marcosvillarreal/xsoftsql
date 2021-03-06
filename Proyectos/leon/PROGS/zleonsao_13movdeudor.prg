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
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'Maopera')
llok = CargarTabla(lcData,'MovCaja')
llok = CargarTabla(lcData,'MovBcocar')
llok = CargarTabla(lcData,'Valor')
llok = CargarTabla(lcData,'ClaseValor')
llok = CargarTabla(lcData,'RenCtacte')
llok = CargarTabla(lcData,'Fletero')
llok = CargarTabla(lcData,'TablaOpe')
IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON

USE  ALLTRIM(lcpath )+"\gestion\clientes" in 0 alias CsrDeudor EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movimien" in 0 alias CsrMovipub EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\comproba" in 0 alias CsrComproba EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\tablaope" in 0 alias FsrTablaOpe EXCLUSIVE

USE  ALLTRIM(lcpath )+"\gestion\movbacar" in 0 alias CsrMovBco EXCLUSIVE


*fecha de importacion
ldfecha		=CTOD(lcfecha)
lcfiscal	=ALLTRIM(STR(YEAR(ldfecha)))+ALLTRIM(STRzero(MONTH(ldfecha),2,0))+ALLTRIM(STRzero(DAY(ldfecha),2,0))

lnidmaopera		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidrenCtacte	= RecuperarID('CsrRenCtacte',Goapp.sucursal10)
lnidmovctacte	= RecuperarID('CsrMovCtacte',Goapp.sucursal10)
lnidcabefac		= RecuperarID('CsrCabefac',Goapp.sucursal10)
lnidmovcaja		= RecuperarID('CsrMovCaja',Goapp.sucursal10)
lnidmovbcocar	= RecuperarID('CsrMovBcocar',Goapp.sucursal10)

ldfechasis	=DATETIME(YEAR(ldfecha),MONTH(ldfecha),DAY(ldfecha),0,0,0)
ldfechas	=DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)

		
Oavisar.proceso('S','Recalculando saldo anterior') 	

&& Se calculan los saldos posteriores y anteriores.
&&Los saldos anteriores genera movimiento para saldo anterior
&&Los saldos posteriores se usan para la fecha del cliente

**** sumatoria de los movimientos anteriores
SELECT (20000+cliente) as cliente,IIF(ISNULL(CsrDeudor.saldo_ant),0,CsrDeudor.saldo_ant) as saldo_ant;
,SUM(importeco) as pago,SUM(saldocomp) as saldo;
FROM Csrmovipub ;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
left JOIN csrDeudor ON csrMovipub.cliente = CsrDeudor.numero;
where fecha<ldfecha AND estado<>'A' AND CsrComproba.debcre='C';
GROUP BY cliente,CsrDeudor.saldo_ant INTO CURSOR CsrAntCredito READWRITE 

replace ALL pago WITH IIF(saldo_ant<0,(saldo_ant*-1)+pago,pago-saldo_ant) IN CsrAntCredito

SELECT (20000+cliente) as cliente,SUM(importeco) as importe, SUM(saldocomp) as saldo;
FROM Csrmovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha<ldfecha AND estado<>'A' AND  CsrComproba.debcre='D';
GROUP BY cliente INTO CURSOR CsrAntDebito READWRITE 

SELECT distinct (20000+cliente) as cliente FROM Csrmovipub ORDER BY cliente INTO CURSOR CsrClientes READWRITE 

SELECT 'H' as debehaber,Csrclientes.cliente;
,IIF(ISNULL(CsrAntCredito.pago),CAST(0 as numeric(11,2)),CsrAntCredito.pago) as importe;
,IIF(ISNULL(CsrAntCredito.saldo),CAST(0 as numeric(11,2)),CsrAntCredito.saldo) as saldo;
FROM CsrClientes;
LEFT JOIN  CsrAntCredito ON Csrclientes.cliente=CsrAntCredito.cliente;
union all;
SELECT 'D' as debehaber,Csrclientes.cliente;
,IIF(ISNULL(CsrAntDebito.importe),CAST(0 as numeric(11,2)),CsrAntDebito.importe) as importe;
,IIF(ISNULL(CsrAntDebito.saldo),CAST(0 as numeric(11,2)),CsrAntDebito.saldo) as saldo;
FROM CsrClientes;
LEFT JOIN  CsrAntDebito ON Csrclientes.cliente=CsrAntDebito.cliente;
into CURSOR CsrAnterior READWRITE

DELETE FROM CsrAnterior WHERE importe = 0

UPDATE CsrCtacte SET saldo = 0 WHERE ctadeudor = 1

SELECT CsrAnterior

Oavisar.proceso('S','Generando saldo anterior por compactación') 
GO top
SCAN FOR !EOF('CsrAnterior')
	SELECT CsrCtacte
	LOCATE FOR ALLTRIM(cnumero)==ALLTRIM(STR(CsrAnterior.cliente))
	IF  ALLTRIM(cnumero)=ALLTRIM(STR(CsrAnterior.cliente))
		lnsigno=1
		ldfechas	= ldfechasis
		lnidcomproba= 36
		lnimporte	= ABS(CsrAnterior.importe)
		lcclasecomp="F"

		IF CsrAnterior.debehaber="H"
			lnsigno=-1
			lnidcomproba=37
			lcclasecomp="G"
		ENDIF
		
		&&Dejamos pasar las facturas. Por el saldo.
		replace saldoant WITH 0, saldo WITH saldo + lnimporte*lnsigno IN CsrCtacte
		
		lnimporte		= lnimporte
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
		VALUES (lnidmaopera,"MOV","IMPORTACIÓN SAO MOV",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,lcswitch,"0";
		,"Importación SAO Compactación Mov Cliente.",ldfechaserver)
		
		lcswitch		= "00100"
		INSERT INTO CsrMovctacte (id,idmaopera,fecha,ctacte,idctacte,subnumero,idsubcta,cuota,importe,saldo;
		,entrega,vencimien,total,detalle,pefiscal,switch,signo);
		VALUES (lnidmovctacte,lnidmaopera,ldfecha-1,lcctacte,lnidctacte," ",0,1,lnimporte;
		,lnSaldo,0,ldfecha-1,lnimporte,"Saldo de Importación",SUBSTR(lcfiscal,1,6),lcswitch,lnsigno)
		
		lnidmovctacte=lnidmovctacte+1
		lnidmaopera=lnidmaopera+1
	ENDIF
ENDSCAN 

Oavisar.proceso('S','Extrayendo comprobantes desde la fecha')		
*fecha de importacion
ldfecha		=CTOD(lcfecha)

SELECT (20000+CsrMovipub.cliente) as cliente,CsrMovipub.detalle,IIF((CsrComproba.debcre='C'),CsrMovipub.Importeco*-1,CsrMovipub.Importeco) as importe;
,CsrMovipub.fecha,CsrMovipub.letra,CsrMovipub.talonario,CsrMovipub.numcomp ,CsrMovipub.saldocomp;
,CsrMovipub.vencimien,CsrMovipub.orden,CsrMovipub.tipocomp; 
,IIF(CsrMovipub.rendida='S',1,0) as rendida;
,IIF(CsrMovipub.reparinde=0,CsrMovipub.repalleva,CsrMovipub.reparinde) as repartidor;
FROM CsrMovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero ;
WHERE CsrMovipub.fecha=>ldfecha AND CsrMovipub.estado<>'A';
order by cliente into cursor CsrPosterior READWRITE 

SELECT FsrTablaOpe.Orden,FsrTablaOpe.importe as impvalor;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor,FsrTablaOpe.cheque;
,FsrTablaOpe.cliente,FsrTablaOpe.debehaber,FsrTablaOpe.detalle;
FROM CsrPosterior;
left JOIN FsrTablaOpe ON CsrPosterior.orden = FsrTablaOpe.orden;
left JOIN CsrValor ON FsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where valor<>0 into CURSOR CsrAuxTablaOpe READWRITE 

SELECT CsrAuxTablaOpe
INDEX on orden TAG korden
SET ORDER TO korden

SELECT CsrMovBco.*,FsrTablaOpe.vendedor,FsrTablaOpe.cliente;
,IIF(ISNULL(CsrClaseValor.numero),'',CsrClaseValor.numero) as clasevalor;
,IIF(ISNULL(CsrValor.id),0,CsrValor.id) as idvalor;
,IIF(ISNULL(CsrCtacte.cnombre),SPACE(25),CsrCtacte.cnombre) as nomctacte;
,IIF(!(CsrMovBco.entregado),'0','1') as aentregar;
,IIF(!(CsrMovBco.depositado),'0','1') as depositados;
FROM CsrMovBco ;
LEFT JOIN FsrTablaOpe ON CsrMovBco.orden = FsrTablaOpe.orden AND CsrMovBco.numcomp = FsrTablaOpe.cheque;
left JOIN CsrValor ON FsrTablaOpe.valor = CsrValor.numero;
left JOIN CsrCtacte ON FsrTablaOpe.cliente = VAL(CsrCtacte.cnumero);
left JOIN CsrClaseValor ON CsrValor.idclase = CsrClaseValor.id;
where (LEN(LTRIM(CsrMovBco.idcheque))<>0 OR CsrMovBco.tipocomp=3) ;
AND CsrMovBco.fecha_vto > ldfecha-60;
INTO CURSOR CsrAuxMovBco READWRITE 

&&AND CsrMovBco.depositado <> .T.;

SELECT CsrAuxMovBco
INDEX on orden+STR(numcomp,10) TAG kcheque
SET ORDER TO kcheque
oavisar.proceso('N')
*BROWSE 


****sumatoria de los movimientos posteriores

SELECT (20000+cliente) as cliente,SUM(importeco) as pago;
FROM Csrmovipub ;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha>=ldfecha AND estado<>'A' AND CsrComproba.debcre='C';
GROUP BY cliente INTO CURSOR CsrDebito READWRITE 

SELECT (20000+cliente) as cliente,SUM(importeco) as importe;
FROM Csrmovipub;
LEFT JOIN CsrComproba ON CsrMovipub.tipocomp=CsrComproba.numero;
where fecha>=ldfecha AND estado<>'A' AND  CsrComproba.debcre='D';
GROUP BY cliente INTO CURSOR CsrCredito READWRITE 

SELECT distinct (20000+cliente) as cliente FROM Csrmovipub ORDER BY cliente INTO CURSOR CsrClientes READWRITE 

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
GO TOP 
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
		VALUES (lnidmaopera,lcorigen,"IMPORTACION SAO MOV",goapp.sucursal,goapp.terminal,1,ldfechasis;
		,1,0,lniddetanrocaja,lnidcomproba,lcnumero,lcclasecomp,1,1,1,"00000","0","Importación";
		,ldfechaserver)
		
		INSERT INTO CsrTablaOpe (idmaopera,orden) VALUES (lnidmaopera,VAL(CsrPosterior.orden))
		
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
					lcSwitch	= IIF(VAL(CsrAuxMovBco.aentregar)+VAL(CsrAuxMovBco.depositados)>0,'1','0')+'0000'
					
					INSERT INTO CsrMovbcocar (id,idmaopera,origen,importe,idtipomov,numero;
					,idctabco,banco,localidad,fecha,fechavto,cuit,titular,recibido,entregado;
					,detalle,signo,switch,idsucorigen,idsucdestino);
					VALUES (lnidmovbcocar,lnidmaopera,'3RO',lnimporte,16,lnnumero,0,lcbanco;
					,lclocalidad,ldfecha,ldfechavto,'',lctitular,lcrecibido;
					,lcentregado,lcdetalle,1,lcSwitch,goapp.idsucursal,0)	
					
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
	,detalle,signo,switch,idsucorigen,idsucdestino);
	VALUES (lnidmovbcocar,lnidmaopera,'3RO',lnimporte,lnidcomproba,lnnumero,0,lcbanco;
	,lclocalidad,ldfecha,ldfechavto,'',lctitular,lcrecibido;
	,lcentregado,lcdetalle,1,lcSwitch,goapp.idsucursal,0)	
		
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
USE IN FsrTablaOpe
USE IN CsrMovBco

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
