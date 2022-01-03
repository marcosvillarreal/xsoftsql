PARAMETERS ldfecha,lcpath,lcBase
ldFECHA = IIF(PCOUNT()<1,"",ldFECHA)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.

llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'MovCtacte')
llok = CargarTabla(lcData,'Maopera')


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


SET SAFETY ON
CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )

CREATE CURSOR CsrSaldos (Codigo c(8),Saldo c(20))

Oavisar.proceso('S','Abriendo archivos') 

cCadeCtacte = "" 

SELECT CsrLista
cArchivo = ADDBS(ALLTRIM(lcpath ))+"saldo_clientes.csv"
APPEND FROM  &cArchivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH ALLTRIM(STRTRAN(deta01,"	",lcDelimitador))
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

Oavisar.proceso('S','Procesando '+alias()) 

cCadeCtacte = "" 


SELECT CsrLista
GO TOP 
*vista()
lnPrimeraOcurrencia = 1
leiunarticulo = .f.

ldebug = .t.

*SKIP 
*stop()
DO WHILE NOT EOF()
	lnCantCampo = 3 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		SKIP 
		LOOP 
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcSaldo
		
		j = 0
	ELSE
		IF !leiunarticulo
			SKIP 
			LOOP 
		ENDIF 
	ENDIF 
	
	DO WHILE lnCamposLeidos<4
		i = 1
		DO WHILE i + j <= lnCantCampo &&Campos de CsrArti + 1
			lnpos = AT(lcDelimitador,&lcNomCampo,i)
			IF lnPos#0 &&No es fin de linea
				lccadena = ALLTRIM(lcAcarreo) + SUBSTR(&lcNomCampo,lnSiguienteOcurrencia,lnpos-(lnSiguienteOcurrencia))
				lcAcarreo = ""
			ELSE 
				lcAcarreo = ALLTRIM(lcAcarreo) + ALLTRIM(SUBSTR(&lcNomCampo,lnSiguienteOcurrencia))
				EXIT 
			ENDIF
			lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcCodigo)))
			*lcSaldo		= UPPER(LimpiarCadena(IIF(j + i=3,STRTRAN(STRTRAN(lcCadena,'.',''),',','.'),lcSaldo)))
			lcSaldo			= UPPER((IIF(j + i=3,strtran(lcCadena,'.',''),lcSaldo)))
							
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
					
		ENDDO 
		lnSiguienteOcurrencia = 1
		lnCamposLeidos = lnCamposLeidos + 1
		lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
		IF lnPos = 0 AND i <= lnCantCampo &&Si no termino, y no es un campo csrati q nop existe
			 j = j + (i - 1)
		ENDIF 
		IF lnpos#0 AND i+j >= lnCantCampo
			EXIT 
		ENDIF 
	ENDDO 

	IF lnpos#0 AND i+j >= lnCantCampo
		&&Insertamos si se encontro una ultima ocurrencia con respecto a la cantidad de registros
		&&Que se grabaran en csrarti.
		&&Esta diseñado para leer hasta los precios.
		&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.
		lcSaldo = STRTRAN(lcSaldo,',','.')
		INSERT INTO CsrSaldos (Codigo,Saldo) ;
		values (lcCodigo,lcSaldo)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
	SKIP IN CsrLista
ENDDO 

SELECT CsrSaldos
*vista()

*fecha de importacion
*ldfecha		=CTOD(lcfecha)
lcfiscal	=ALLTRIM(STR(YEAR(ldfecha)))+ALLTRIM(STRzero(MONTH(ldfecha),2,0))+ALLTRIM(STRzero(DAY(ldfecha),2,0))

lnidmaopera		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidmovctacte	= RecuperarID('CsrMovCtacte',Goapp.sucursal10)

ldfechasis	=DATETIME(YEAR(ldfecha),MONTH(ldfecha),DAY(ldfecha),0,0,0)
ldfechas	=DATETIME(YEAR(DATE()),MONTH(DATE()),DAY(DATE()),0,0,0)

*stop()
SELECT CsrSaldos
Oavisar.proceso('S','Procesando '+alias()) 
GO TOP
SCAN 
	
	IF VAL(codigo)=1
		*stop()
	ENDIF 
	
	lnCodigo = VAL(CsrSaldos.codigo)

 	SELECT CsrCtacte
 	LOCATE FOR VAL(cnumero) = lnCodigo
 	IF VAL(cnumero) <> lnCodigo
 		cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + ltrim(CsrSaldos.codigo)
 		SELECT CsrSaldos
 		LOOP  		
 	ENDIF 

	lnSaldo = VAL(CsrSaldos.saldo)

	&&Debemos insertar un movimiento de interno para generar saldos
	lnsigno=1
	replace saldoant WITH 0, saldo WITH lnSaldo IN CsrCtacte
	ldfechas=ldfechasis
	lnidcomproba=36
	lcclasecomp="F"
	IF lnSaldo<0
		lnsigno=-1
		lnidcomproba=37
		lcclasecomp="G"
	ENDIF
	lnimporte		= lnSaldo*lnsigno
	lcletra			= "X"
	lcnum			= strtran(str(VAL(CsrCtacte.cnumero),8,0),' ','0')
	lcnumero		= lcletra+"0000"+lcnum
	lcswitch		= "00000"
	lnSaldo			= ABS(lnSaldo)
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
	VALUES (lnidmovctacte,lnidmaopera,ldfecha-1,lcctacte,lnidctacte," ",0,1,ABS(lnimporte);
	,lnSaldo,0,ldfecha-1,ABS(lnimporte),"Saldo de Importación",SUBSTR(lcfiscal,1,6),lcswitch,lnsigno)
	
	lnidmovctacte=lnidmovctacte+1
	lnidmaopera=lnidmaopera+1
	
	
	SELECT CsrSaldos           
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("Hay Saldos sin imputar a un cliente"+CHR(13)+cCadeCtacte,0)
ENDIF 


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

SELECT CsrCtacte
*vista()

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

