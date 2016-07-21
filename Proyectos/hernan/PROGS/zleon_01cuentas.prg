PARAMETERS ldvacio,lcpath
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla('leon','PlanCue',.t.)
llok = CargarTabla('leon','Valor',.t.)
llok = CargarTabla('leon','ClaseValor',.f.)
llok = CargarTabla('leon','ValorCtaCon',.t.)
SET SAFETY ON
IF !llok
	RETURN .f.
ENDIF

USE ALLTRIM(lcpath)+"\gestion\cuen0126" IN 0 ALIAS CsrCuenta01 EXCLUSIVE 
USE ALLTRIM(lcpath)+"\gestion\valores" IN 0 ALIAS CsrValores EXCLUSIVE
USE ALLTRIM(lcpath)+"\gestion\claseval" IN 0 ALIAS CsrClase EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

&&& Generar el plancue
SELECT * FROM CsrCuenta01 WHERE VAL(clave)<>0 ORDER BY clave INTO CURSOR CsrCuentaX

LOCAL lnid
lnid = RecuperarID('CsrPlanCue',Goapp.sucursal10)

lnordenhijo = 0
lnordenmadre = 0
 
SELECT CsrCuentaX
SCAN
	lnrecno = RECNO()
	IF  SUBSTR(CsrCuentaX.Xcuenta,1,1)='*'or CsrCuentaX.nivel=0
		LOOP
	ENDIF
	lncuenta = CsrCuentaX.numero	
	
	&&Chequeamos que no exista en el PlanCue un valor con el mismo numero
	SELECT CsrPlanCue
	lnRecNoPlan = RECNO()
	
	lbhallado = .f.
	DO WHILE !lbhallado
		LOCATE FOR cuenta = lncuenta
		IF FOUND() AND cuenta = lncuenta
			lncuenta = lncuenta + 1000
		ELSE 
			lbhallado = .t.
		ENDIF 
	ENDDO 
	
	SELECT CsrPlanCue
	GO BOTTOM 
	
	SELECT CsrCuentaX
	GO lnRecNo
			
	DO CASE 
		CASE CsrcuentaX.Nivel=1
				*Es una opcion raiz principal
				lnidmadre = 0
				lcmadre = 0
				lbMenu = 1
				lnidMadreUlt = lncuenta
				lcmadreUlt = lncuenta
				lnorden = lnordenmadre + 1
				lnordenhijo = 0
				lnidpadre = lnid
			 	lnordenmadre =  lnordenmadre +1
		CASE  CsrCuentaX.Nivel#1
				* Es raiz de algun menu

				lnordenhijo = lnordenhijo + 1
				IF  CsrCuentaX.nivel > lnnivelant
				* El CuentaX es hijo del PlanCue anterior
					IF CsrPlanCue.idmadre#0
						lcmadreUlt = CsrPlanCue.CUENTA
						lnidmadreUlt = CsrPlanCue.CUENTA
						lnordenhijo = 1
					ENDIF 
				ELSE	
*!*						IF 	CsrCuentaX.nivel <  lnnivelant	
*!*						*el cuentX es futura (o no) madre	 
*!*							SELECT CsrPlanCue
*!*							LOCATE FOR cuenta = lnidmadreUlt
*!*							lcmadreUlt = CsrPlanCue.idmadre
*!*							lnidmadreUlt = CsrPlanCue.idmadre
*!*							lnordenhijo = CsrPlancue.orden+1
*!*						ENDIF 
					lbencontrado = .f.

					DO WHILE !lbencontrado
						IF CsrCuentaX.nivel =  lnnivelant
							lbencontrado = .t.
							LOOP 
						ENDIF 
						IF 	CsrCuentaX.nivel <  lnnivelant	
						*el cuentX es futura (o no) madre	 
							SELECT CsrPlanCue
							LOCATE FOR cuenta = lnidmadreUlt
							lcmadreUlt = CsrPlanCue.idmadre
							lnidmadreUlt = CsrPlanCue.idmadre
							lnordenhijo = CsrPlancue.orden+1
							lnnivelant = lnnivelant - 1	
						ENDIF 
						
					ENDDO 		
				ENDIF 		
				
				lnorden = lnordenhijo		
				lcmadre = lcmadreUlt
				lnidmadre = lnidMadreUlt	
			 
	ENDCASE 
	
	lcnombre= CsrCuentaX.nombre
	lnidentificador = lnid
	lncuenta = lncuenta
	lnnivelant = CsrcuentaX.nivel
	lnimputable = IIF(ALLTRIM(CsrCuentaX.imputable)='N',0,1)
	lnidclase = 99
	lctipocuenta =ALLTRIM(CsrCuentaX.Patri_resu)+ALLTRIM(CsrCuentaX.Sumaresta)
	IF lctipocuenta='P+'
		lntipocuenta =1
	ELSE
		IF lctipocuenta='P-'
			lntipocuenta =2
		ELSE
			IF lctipocuenta='R+'
				lntipocuenta =5
			ELSE
				lntipocuenta =4
			ENDIF
		ENDIF 
	ENDIF 
	lccodigo = ""
	lnidejercicio = goapp.idejercicio
	lnidejeantes = 1 
	
	INSERT INTO CsrPlanCue (id,cuenta,nombre,imputable,idmadre,madre,orden,idclase,tipocuenta,codigo,idejercicio,idejeantes);
	VALUES (lnidentificador,lncuenta,lcnombre,lnimputable,lnidmadre,lcmadre,lnorden,lnidclase,lntipocuenta,lccodigo,lnidejercicio,lnidejeantes)

	lnid = lnid +1 

	SELECT CsrCuentaX
ENDSCAN 
SELECT MAX(CUENTA) as cuenta FROM CsrPlanCue INTO CURSOR CsrMaxCuenta
lnCuenta = CsrMaxCuenta.cuenta + 1

&&& AGREGAMOS A LA FUERZA LAS IDCTACPRA Y IDCTAVTA
INSERT INTO CsrPlanCue(id,cuenta,nombre,imputable,idmadre,madre,orden,idclase,tipocuenta,codigo,idejercicio,idejeantes);
values (lnid,lnCuenta,'COMPRA DE MERCADERIA VARIA',1,67,67,20,9,4,"",goapp.idejercicio,0)
lnid = lnid +1 
lnCuenta = lnCuenta +1
INSERT INTO CsrPlanCue(id,cuenta,nombre,imputable,idmadre,madre,orden,idclase,tipocuenta,codigo,idejercicio,idejeantes);
values(lnid,lnCuenta,"VENTA DE MERCADERIA VARIA",1,66,66,20,9,5,"",goapp.idejercicio,0)


lnid = RecuperarID('CsrValor',Goapp.sucursal10)

SELECT CsrValores
GO TOP 
SCAN 
	lnidplanacre = 0
	lnidplandeu = 0
	lnidplanbco = 0
	lnidplanfactu = 0 
	lnidplanCAJA = 0
	lnidclase = 0
	lnregisa = 0
	lnregisd = 0
	lnregisb = 0
	lnregisf = 0
	lnregisK= 0
	SELECT CsrPlancue
	LOCATE FOR cuenta = CsrValores.cuenta
	IF FOUND()
		lnidplanacre =CsrPlancue.id
		lnregisa=1
		lnidplancaja = lnidplanacre
		lnregisk = 1
	ENDIF 
	LOCATE FOR cuenta = CsrValores.cuenta2
	IF FOUND()
		lnidplandeu = CsrPlanCue.id
		lnregisd = 1
	ENDIF 
	LOCATE FOR cuenta = CsrValores.cuenta4
	IF FOUND()
		lnidplanbco = CsrPlancue.id
		lnregisb = 1
	ENDIF 
	LOCATE FOR cuenta = CsrValores.cuenta3
	IF FOUND()
		lnidplanfactu = CsrPlancue.id
		lnregisf = 1
	ENDIF 

	SELECT CsrClaseValor
	LOCATE FOR numero = CsrValores.es_clase
	IF FOUND()
		lnidclase = CsrClaseValor.id
	ENDIF 
	lnnumero = CsrValores.numero
	lcnombre = ALLTRIM(UPPER(CsrValores.nombre))
	IF 'EFECT'$ lcnombre
		SELECT CsrClaseValor
		LOCATE FOR numero = 'E'
		lnidclase = CsrClaseValor.id
	ENDIF 
	INSERT INTO CsrValor (id,numero,nombre,regisa,regisb,regisd,regisf,regisc,regisk,idctaa,idctab,idctad;
	,idctaf,idctac,idclase,idctabco,idctak);
	VALUES (lnid,lnnumero,lcnombre,lnregisa,lnregisb,lnregisd,lnregisf,0,lnregisK,lnidplanacre,lnidplanbco;
	,lnidplandeu,lnidplanfactu,0,lnidclase,0,lnidplanCAJA)
	
	INSERT INTO CsrValorCtacon(id,idejercicio,idvalor,idctaa,idctab,idctac,idctad,idctaf,idctak);
	VALUES (lnid,goapp.idejercicio,lnid,lnidplanacre,lnidplanbco,0,lnidplandeu,lnidplanfactu,lnidplanCAJA)
	lnid = lnid + 1

ENDSCAN 


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE IN CsrCuenta01 
USE IN CsrValores 
USE IN CsrClase 
