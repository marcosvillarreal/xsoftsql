PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

LOCAL lnid

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
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


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrProducto.* FROM Producto as CsrProducto
ENDTEXT 
IF NOT CrearCursorAdapter('CsrProducto',lccmd)
	MESSAGEBOX('Nose puede importar, pq no puede cargar los productos')
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrVariedad.* FROM Variedad as CsrVariedad
ENDTEXT 
IF NOT CrearCursorAdapter('CsrVariedad',lccmd)
	MESSAGEBOX('Nose puede importar, pq no puede cargar las variedades')
	RETURN .f.
ENDIF 
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrSubProducto.* FROM SubProducto as CsrSubProducto
ENDTEXT 
IF NOT CrearCursorAdapter('CsrSubProducto',lccmd)
	MESSAGEBOX('Nose puede importar, pq no puede cargar los productos')
	RETURN .f.
ENDIF 

llok = .t.
llok = CargarTabla(lcData,'Existenc',.t.)
llok = CargarTabla(lcData,'MovStock',.t.)
llok = CargarTabla(lcData,'Deposito')
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'Maopera')
llok = CargarTabla(lcData,'CabeOrd',.t.)
llok = CargarTabla(lcData,'CuerOrd',.t.)
llok = CargarTabla(lcData,'CuerVariOrd',.t.)

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON


USE  ALLTRIM(lcpath )+"\gestion\existenc" in 0 alias CsrStock EXCLUSIVE
SELECT csrstock	

ldfecha 	= DATE()
lnid 		= RecuperarID('CsrExistenc',Goapp.sucursal10)
lnidmov 	= RecuperarID('CsrMovStock',Goapp.sucursal10) 
lnidmaopera	= RecuperarID('CsrMaopera',Goapp.sucursal10) 
lnidsubprod	= RecuperarID('CsrSubProducto',Goapp.sucursal10)
lnidcabeord	= RecuperarID('CsrCabeOrd',Goapp.sucursal10)
lnidcuerord	= RecuperarID('CsrCuerOrd',Goapp.sucursal10)
lnidcuervari= RecuperarID('CsrCuerVariOrd',Goapp.sucursal10)

&&&&				
SELECT deposito ,numero as producto,sabor as numsubprod,SUM(exiuni) as existe;
,SUM(exikilo) as kilos;
FROM CsrStock  WHERE deposito <> 9 GROUP BY deposito,numero,sabor ORDER BY deposito,producto,numsubprod;
INTO CURSOR 'CsrLista' READWRITE 

lnNumComp = 1

oavisar.proceso('N')
SELECT CsrLista

Oavisar.proceso('S','Procesando '+alias()) 
GO TOP 

SCAN FOR !EOF('CsrLista')
	IF existe = 0 AND kilos = 0
		LOOP 
	ENDIF 
	
	nDeposito = IIF(CsrLista.deposito=10,1,2)
	
	SELECT CsrDeposito
	LOCATE FOR numero=nDeposito
	IF FOUND()
		SELECT CsrProducto
		LOCATE FOR numero=CsrLista.producto
		IF FOUND()
			lccodigo=ALLTRIM(STR(CsrProducto.numero))
		  	SELECT CsrVariedad
			LOCATE FOR numero = CsrLista.numsubprod
		  	SELECT CsrSubProducto
		  	LOCATE FOR idvariedad=Csrvariedad.id AND idarticulo =CsrProducto.id
		  	IF !FOUND() AND CsrLista.numsubprod#0
		  		LOOP 
			ENDIF 
			
	  		lnidsub=CsrSubproducto.id
	  		
			lnKilos = CsrLista.kilos
			IF CsrProducto.vtakilos=0
				lnKilos = INT(Round(CsrLista.existe,0)) * CsrProducto.peso
			ENDIF 
			
			
			ldfecha	= DATETIME(1996,1,1,0,0,0)
			
			INSERT INTO CsrExistenc (id,idarticulo,iddeposito,idsubarti,existe,existeant,existedisp,fecvto;
			,kilos,kilosant,kilosdisp,volumen,volumenant,volumendisp);
			 VALUES (lnid,CsrProducto.id,CsrDeposito.id,lnidsub,INT(Round(CsrLista.existe,0)),0;
			 ,INT(Round(CsrLista.existe,0)),ldfecha,lnKilos,0;
			 ,lnKilos,0,0,0)
			 
			lnid=lnid+1
			
			STORE 0 TO lniddepsale,lniddepentra
			
			IF CsrLista.existe<>0
				IF CsrLista.existe>0
					lnidDepEntra= CsrDeposito.id
					lnidcomproba= 9
					lcclasecomp = "L"
					lnsigno 	= 1
				ELSE
					lnidDepSale = CsrDeposito.id
					lnidcomproba= 10
					lcclasecomp = "M"
					lnsigno 	= -1
				ENDIF
				
				STORE 0 TO lnuniventa,lnunibulto,lnkilos,lnvolumen,lnlistaprecio,lnprecosto,lnprecostosiva;
				,lnpreunita,lnpreunitasiva,lnprearti,lnpreartisiva,lninterno,lndespor,lntasaiva,lnhojaactual;
				,lnpesable,lnidfrio
				
				lnHayMaopera = .f.
				
				SELECT CsrMaopera
				LOCATE FOR idcomproba=lnidcomproba AND clasecomp=lcclasecomp
				SCAN FOR idcomproba=lnidcomproba AND clasecomp=lcclasecomp
					IF !(idcomproba=lnidcomproba AND clasecomp=lcclasecomp)
						LOOP 
					ENDIF 
					SELECT CsrCabeOrd
					LOCATE FOR idmaopera = CsrMaopera.id
					IF idmaopera = CsrMaopera.id
						IF (iddepentra = CsrDeposito.id OR iddepsale = CsrDeposito.id )
							lnHayMaopera = .t.
							LNIDMAOPE = CsrMaopera.id
						ENDIF 
					ENDIF 
					SELECT CsrMaopera
				ENDSCAN  
				
				IF !lnHayMaopera	
					&&&Generamos encabezado para salida y entrada de stock
					STORE 0 TO lntotal,lnlistaprecio,lnidfletero
					STORE 0 TO lnhojaactual,lnhojatotal,lnidctacte,lnidconcepto

					ldfechaserver	= DATETIME()
					ldfechasis		= FechaHoraCero(ldfechaserver)
					lniDConcepto		= 3
					
					INSERT INTO CsrMaopera (id,origen,programa,sucursal,terminal,sector,fechasis;
					,idoperador,idvendedor,iddetanrocaja,idcomproba,numcomp,clasecomp,turno,puestocaja;
					,idcotizadolar,switch,estado,detalle,fechaserver);
					VALUES (lnidmaopera,"EXI","IMPORTACION STOCK",goapp.sucursal,goapp.terminal,1;
					,ldfechasis,1,1,lniddetanrocaja,lnidcomproba,"X0000"+strzero(lnNumComp,8),lcclasecomp;
					,1,1,1,"0000","0","Importación Stock",ldfechaserver)
					
					INSERT INTO Csrcabeord(id,idmaopera,total,switch,listaprecio,idfletero,iddepentra;
					,iddepsale,signo,hojaactual,hojatotal,idlotemaopera,idctacte,idconcepto);
					VALUES(lnidcabeord,CsrMaopera.id,lntotal,"00000",lnlistaprecio,lnidfletero;
					,0,0,lnsigno ,lnhojaactual,lnhojatotal,lnidmaopera,lnidctacte;
					,lnidconcepto)
					
					lnidmaopera = lnidmaopera + 1
					lnidcabeord = lnidcabeord + 1 
					
					LNIDMAOPE = CsrMaopera.id
					lnNumComp = lnNumComp + 1
				ENDIF 
	
				IF CsrCabeOrd.iddepentra = 0 AND CsrCabeOrd.iddepsale = 0
					replace iddepSale WITH lniddepsale, iddepentra WITH lniddepentra IN CsrCabeOrd
				ENDIF 
									
				lnuniventa	= CsrProducto.idtipovta
				lnunibulto 	= CsrProducto.unibulto
				lnPesable 	= CsrProducto.vtakilos
				lnIdFrio	= CsrProducto.idfrio	
				lncantidad	= INT(round(ABS(CsrLista.existe),0))
				lnGraboStock = .f.
				
				SELECT CsrLista			
				IF CsrLista.numsubprod#0
						
					lnCantVari 	= INT(round(ABS(CsrLista.existe),0))
					lnCantidad 	= lnCantVari
					lnKilos		= lnCantVari*CsrProducto.peso
					
					lnidvariedad = 0
					SELECT CsrVariedad
					LOCATE FOR numero = CsrLista.numsubprod
					IF FOUND() AND numero = CsrLista.numsubprod
						lnidvariedad = CsrVariedad.id
					ENDIF 
					lnidsubarti = 0
					SELECT CsrSubproducto
					LOCATE FOR idarticulo = CsrProducto.id AND idvariedad = lnidvariedad
					IF FOUND() AND idarticulo = CsrProducto.id AND idvariedad = lnidvariedad
						lnidsubarti = CsrSubproducto.id
						lnGraboStock = .t.
						
						INSERT INTO CsrMovStock (id,idmaopera,idorigen,idarticulo,idsubarti,codigo,fecha;
						,iddeposito,cantidad,kilos,volumen,importe,switch,signo);
						VALUES (lnidmov,LNIDMAOPE,CsrCabeord.id,CsrProducto.id,lnidsubarti,lccodigo;
						,ldfechasis,CsrDeposito.id,lnCantVari,lnKilos,lnKilos,0,"0000",lnSigno)
						lnidmov=lnidmov+1
						
						INSERT INTO cuervariord (id,idmaopera,idcuerfac,idarticulo,idsubarti,idvariedad;
								,cantidad,kilos,volumen);
						VALUES (lnidcuervari,LNIDMAOPE,lnidcuerord+1,CsrProducto.id,lnidsubarti;
								,lnidvariedad,lncantvari,lnkilos,lnKilos)
								
						lnidcuervari = lnidcuervari + 1
					ENDIF 
				ENDIF 
				
				lnKilos		= lnCantidad*IIF(lnPesable=1,CsrProducto.peso,1)
				
				SELECT CsrCuerOrd
				LOCATE FOR idmaopera = lnidmAope AND idarticulo = CsrProducto.id
				IF !(idmaopera = lnidmAope AND idarticulo = CsrProducto.id)
					INSERT INTO CsrCuerord (id,idmaopera,idcabeza,idarticulo,codigo,nombre,cantidad,univenta;
					,unibulto,kilos,volumen,listaprecio,precosto,precostosiva,preunita,preunitasiva,prearti;
					,preartisiva,interno,despor,tasaiva,hojaactual,switch,pesable,idfrio);
					VALUES (lnidcuerord,LNIDMAOPE,CsrCabeOrd.id,CsrProducto.id,lccodigo,CsrProducto.nombre;
					,lnCantidad,lnuniventa,lnunibulto,lnkilos,lnvolumen;
					,lnlistaprecio,lnprecosto,lnprecostosiva,lnpreunita,lnpreunitasiva,lnprearti;
					,lnpreartisiva,lninterno,lndespor,lntasaiva,lnhojaactual,"00000",lnpesable,lnidfrio)
				
					lnidcuerord = lnidcuerord + 1
				ENDIF 
				replace cantidad WITH cantidad + lnCantidad IN CsrCuerord
				
				
				IF !lnGraboStock
					INSERT INTO CsrMovStock (id,idmaopera,idorigen,idarticulo,idsubarti,codigo,fecha;
					,iddeposito,cantidad,kilos,volumen,importe,switch,signo);
					VALUES (lnidmov,LNIDMAOPE,CsrCabeord.id,CsrProducto.id,lnidsub,lccodigo,ldfechasis;
					,CsrDeposito.id,lnCantidad,lnKilos,lnKilos,0,"0000",IIF(CsrLista.existe>0,1,-1))
					
					lnidmov=lnidmov+1
				ENDIF 
				
			ENDIF
			
		ENDIF 
	ENDIF
	SELECT CsrLista
	
ENDSCAN
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE IN CsrStock

