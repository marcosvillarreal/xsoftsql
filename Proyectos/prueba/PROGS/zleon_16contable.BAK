PARAMETERS ldfecha,lcpath,lcbase
lcfecha = IIF(PCOUNT()< 1,"01-01-2011",DTOC(ldfecha))
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcdata = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
oavisar.proceso("Abriendo tablas...")
llok = .t.

TEXT TO lccmd TEXTMERGE NOSHOW 
SELECT CsrPlanCue.*,ISNULL(CsrClaseCta.cnumero,'ZZ') as clasecta FROM PlanCue as CsrPlanCue
left join ClaseCta as CsrClaseCta on CsrPlanCue.idclase = CsrClaseCta.id
where CsrPlanCue.idejercicio =  <<goapp.idejercicio>> 
ENDTEXT 
IF !CrearCursorAdapter('CsrPlanCue',lccmd) OR RECCOUNT('CsrPlanCue')=0
	MESSAGEBOX('Nose puede importar, pq no cargado el CsrPlanCue')
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

llok = CargarTabla(lcData,'TablaAsi',.t.)
llok = CargarTabla(lcData,'Cabeasi',.t.)
llok = CargarTabla(lcData,'Maopera')

IF !llok
	RETURN .f.
ENDIF

USE ALLTRIM(lcpath )+"\contab\cabe0127" IN 0 ALIAS FsrCabeAsiLeon  EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\contab\movi0127" in 0 alias FsrTablaAsiLeon EXCLUSIVE

*ldfechaant=DATE(2010,08,01)
ldfechaant=CTOD(lcfecha)

oavisar.proceso("S","Reindexando EnCabezados de asientos..")
SELECT FsrCabeAsiLeon.* FROM FsrCabeAsiLeon ORDER BY asiento INTO CURSOR CsrCabeza
SELECT CsrCabeza
INDEX on asiento TO korden

oavisar.proceso("S","Filtrando movimientos de asientos...")

SELECT FsrTablaAsiLeon.* FROM FsrTablaAsiLeon ORDER BY asiento INTO CURSOR CsrCuerpo
SELECT CsrCuerpo
INDEX on asiento TO kasiento

SET SAFETY ON
oavisar.proceso("Procesando tablas...")
LOCAL lnid,lnidcabeza,lnidcuerpo

lnid 		= RecuperarID('CsrMaopera',Goapp.sucursal10)
lnidcabeza 	= RecuperarID('CsrCabeasi',Goapp.sucursal10)
lnidcuerpo	= RecuperarID('CsrTablaAsi',Goapp.sucursal10)



SELECT Csrcabeza
COUNT ALL TO lnCountCabeza

ldfecha=CsrCabeza.fecha
GO TOP 
lcTitulo = "CabeAsi "+STR(RECNO(),10)+"/"+STR(lnCountCabeza,10) 
Oavisar.proceso('S',lcTitulo,.t.,lnCountCabeza)
lbSalir = .f.

SCAN FOR !EOF()
	SELECT Csrcabeza
	
   	lcTitulo = "Cabefac "+STR(RECNO(),10)+"/"+STR(lnCountCabeza,10) 
   	Oavisar.proceso('I',lcTitulo,.t.,lnCountCabeza,RECNO())


	lcnumcomp 		= strzero(lnid,13)
	ldfechaserver 	= DATETIME()
	ldfechasis 		= FechaHoraCero(ldfechaserver)
	
	
	lcestado 	= '0'
	
	lnidcomproba = 0
	lcclasecomp = ""
    lnidvendedor = 0      

	
	INSERT INTO Csrmaopera (id,origen,programa,terminal,fechasis,idoperador,idvendedor,idcomproba,numcomp;
	,clasecomp,iddetanrocaja,turno,switch,sucursal,sector,puestocaja,idcotizadolar,estado,fechaserver);
	VALUES (lnid,'AST',"IMPORTACION CONTABLE",goapp.terminal,ldfechasis,1,lnidvendedor,lnidcomproba;
	,lcnumcomp,lcclasecomp,lniddetanrocaja,1,"00000",goapp.sucursal,1,1,1,lcestado,ldfechaserver)

	ldfecha     = DATETIME(YEAR(Csrcabeza.fecha),MONTH(Csrcabeza.fecha),DAY(Csrcabeza.fecha),0,0,0)
	lnnumero	= CsrCabeza.asiento
	lctipoasi	= IIF(lnnumero#1,"C","A")
	lcdetalle	= ALLTRIM(CsrCabeza.nombre)
	ldfechacarga= ldfecha
	
	lnasiento	= CsrCabeza.asiori
	
	INSERT INTO Csrcabeasi (id,idmaopera,idejercicio,numero,fecha,tipoasi,detalle,fechacarga);
    VALUES (lnidcabeza,lnid,goapp.idejercicio,lnnumero,ldfecha,lctipoasi,lcdetalle,ldfechacarga)
    
    
   	SELECT CsrCuerpo
    SEEK lnasiento
    DO WHILE !EOF() AND CsrCuerpo.asiento= lnasiento
    	
    	STORE 0 TO lnidcuenta,lnidprovincia
    	lctipoconce = ""
    	lctablaori 	= "MAOP"
    	
    	SELECT CsrPlanCue
    	LOCATE FOR cuenta = CsrCuerpo.numero
    	IF 	cuenta = CsrCuerpo.numero
    		lnidcuenta = CsrPlanCue.id
    		lctipoconce = CsrPlanCue.clasecta
		ENDIF 

		
		lcDebeHaber = CsrCuerpo.deb_cre
		lnimporte 	= CsrCuerpo.importe
		lcDetalle	= CsrCuerpo.detalle
		
		INSERT INTO CsrTablaasi (id,idmaopera,idcuenta,debehaber,importe,idorigen,tablaori,tipoconce,detalle);
		VALUES (lnidcuerpo,lnid,lnidcuenta,lcdebehaber,lnimporte,lnid,lctablaori,lctipoconce,lcdetalle)

		lnidCuerpo = lnidCuerpo + 1		
		
		SELECT CsrCuerpo
		SKIP 
	ENDDO  
		
	lnid = lnid + 1
    lnidcabeza = lnidcabeza + 1
	SELECT CsrCabeza		     				
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE IN Fsrcabeasileon  
USE IN Fsrtablaasileon  
USE IN CsrCabeza
USE IN CsrCuerpo
	