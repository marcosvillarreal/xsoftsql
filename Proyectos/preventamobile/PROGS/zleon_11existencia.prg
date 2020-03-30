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

llok = .t.
llok = CargarTabla(lcData,'Producto')
llok = CargarTabla(lcData,'Variedad')
llok = CargarTabla(lcData,'SubProducto')
llok = CargarTabla(lcData,'Existenc',.t.)
llok = CargarTabla(lcData,'MovStock',.t.)
llok = CargarTabla(lcData,'Deposito')
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'PlanCue')
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
SELECT deposito as iddeposito,numero as idproducto,sabor as numsubprod,exiuni as existe;
,exikilo as kilos;
FROM CsrStock WHERE (exiuni<>0 OR exikilo<>0) ORDER BY iddeposito,idproducto,numsubprod;
INTO CURSOR 'CsrLista' READWRITE 

lnNumComp = 1

oavisar.proceso('N')
SELECT CsrLista
*SET FILTER TO idproducto=12


Oavisar.proceso('S','Procesando '+alias()) 
GO TOP 

SCAN FOR !EOF('CsrLista')
	SELECT CsrDeposito
	LOCATE FOR numero=CsrLista.iddeposito
	IF FOUND()
		SELECT CsrProducto
		LOCATE FOR numero=CsrLista.idproducto
		IF FOUND()
			lccodigo=ALLTRIM(STR(CsrProducto.numero) )
		  	SELECT CsrVariedad
			LOCATE FOR numero = CsrLista.numsubprod
		  	SELECT CsrSubProducto
		  	LOCATE FOR idvariedad=Csrvariedad.id AND idarticulo =CsrProducto.id
		  	IF !FOUND() AND CsrLista.numsubprod#0
		  	
		  		
		  		lnidarticulo 	= CsrProducto.id
		  		lnnumero		= CsrProducto.numero
		  		lnsubnumero		= CsrVariedad.numero
		  		lcnombre		= CsrVariedad.nombre
		  		lccodigo		= '0'
		  		lctroquel		= '00000000'
		  		lnnofactura		= 1
		  		lnidvariedad	= CsrVariedad.id
		  		lnestado		= 1
		  		
		  		INSERT INTO Csrsubproducto (id,idarticulo,numero,subnumero,nombre,codigo,troquel;
		  		,nofactura,idvariedad,estado);
		  		VALUES (lnidsubprod,lnidarticulo,lnnumero,lnsubnumero,lcnombre,lccodigo,lctroquel,lnnofactura;
		  		,lnidvariedad,lnestado)
				
				lnidsubprod		= lnidsubprod + 1
		  		
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
					,1,1,1,"0000","0","Importaci�n Stock",ldfechaserver)
					
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
					lnCantidad = 0
					lnRecno = RECNO('CsrLista')
					lnsubprod = CsrLista.numsubprod
					SCAN FOR CsrLista.idproducto=CsrProducto.numero AND CsrLista.iddeposito = CsrDeposito.numero AND lnsubprod = CsrLista.numsubprod
						
						IF !(lnsubprod = CsrLista.numsubprod)
							EXIT 
						ENDIF 
						
						lnCantVari 	= INT(round(ABS(CsrLista.existe),0))
						lnCantidad 	= lnCantidad + lnCantVari
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
						SELECT CsrLista
					ENDSCAN 
					GO lnRecno
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
				ELSE 
					replace cantidad WITH cantidad + lnCantidad IN CsrCuerord
				ENDIF 
				
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

