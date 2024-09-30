PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
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
llok = CargarTabla(lcData,'Localidad')
llok = CargarTabla(lcData,'Ctacte',.t.)
llok = CargarTabla(lcData,'Provincia')
llok = CargarTabla(lcData,'CateIbRn',.t.)
*llok = CargarTabla(lcData,'CateIbRNg')
llok = CargarTabla(lcData,'TipoIva')
llok = CargarTabla(lcData,'CateCtacte')
llok = CargarTabla(lcData,'Barrio',.t.)
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Sucursal',.t.)
llok = CargarTabla(lcData,'Vendedor',.t.)
llok = CargarTabla(lcData,'Zona',.t.)
llok = CargarTabla(lcData,'ZonaRuta',.t.)
llok = CargarTabla(lcData,'Ruta',.t.)
llok = CargarTabla(lcData,'RutaVdor',.t.)
llok = CargarTabla(lcData,'CabeRuta',.t.)
llok = CargarTabla(lcData,'CuerRuta',.t.)
llok = CargarTabla(lcData,'FuerzaVta')

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM CateIbRNg 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrCateIbRNg',lcCmd)
	RETURN .f.
ENDIF 

Oavisar.proceso('S','Procesando '+alias()) 

USE  ALLTRIM(lcpath)+"\gestion\clientes" in 0 alias CsrDeudorViej EXCLUSIVE

SELECT * FROM CsrDeudorViej WHERE VAL(codcli)<>0 ORDER BY codcli INTO CURSOR CsrDeudor READWRITE 

USE in CsrDeudorViej 

USE  ALLTRIM(lcpath)+"\gestion\transpor" in 0 alias CsrTranspViej EXCLUSIVE

SELECT * FROM CsrTranspViej INTO CURSOR FsrTransporte READWRITE 

USE IN CsrTranspViej

USE  ALLTRIM(lcpath)+"\gestion\viajante" in 0 alias CsrVendeViej EXCLUSIVE

SELECT * FROM CsrVendeViej INTO CURSOR FsrVendedor READWRITE 

USE IN CsrVendeViej

USE  ALLTRIM(lcpath)+"\gestion\proveedo" in 0 alias CsrAcreeViej EXCLUSIVE

SELECT * FROM CsrAcreeViej INTO CURSOR CsrAcreedor READWRITE 

USE IN CsrAcreeViej


lnid = RecuperarID('CsrVendedor',Goapp.sucursal10)
lnCodigo = 1
SELECT FsrVendedor
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
   IF LEN(ltrim(nomviaj))=0
       loop
   ENDIF
   lnprevta = 1
   lnestado = 1
   lnnumero	= VAL(FsrVendedor.cviaj) 
   lcnombre	= NombreNi(alltrim(UPPER(FsrVendedor.nomviaj)))
   INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale);
   			 VALUES (lnid,lnnumero,lcnombre,FsrVendedor.comision,1,lnprevta,lnestado,1,0,0)
   lnid = lnid + 1
	*lnCodigo = lnCodigo + 1 
ENDSCAN

sELECT * FROM FsrVendedor INTO CURSOR FsrZona READWRITE 

lnid = RecuperarID('CsrZona',Goapp.sucursal10)
SELECT FsrZona
lnCodigo = 1
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()  
   lcnombre= NombreNi(alltrim(UPPER(fsrzona.nomviaj)))
   lnnumero	= VAL(fsrzona.cviaj)   
   INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
   			 VALUES (lnid,lnNUMERO,lcnombre,0,LEFT(lcnombre,3))
   
   lnid = lnid + 1
   *lnCodigo = lnCodigo + 1 
ENDSCAN

LOCAL lnidcabeza, lnidrutavdor,lnidzonaruta,lnidcuerruta,lnidruta

lnidruta= RecuperarID('CsrRuta',Goapp.sucursal10)
*****
lnidcabeza = RecuperarID('CsrCabeRuta',Goapp.sucursal10)
*******
lnidrutavdor = RecuperarID('CsrRutaVdor',Goapp.sucursal10)
*****
lnidzonaruta = RecuperarID('CsrZonaRuta',Goapp.sucursal10)
*******
lnidcuerruta = RecuperarID('CsrCuerRuta',Goapp.sucursal10)

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta  = CsrFuerzaVta.id

SELECT CsrCateCtacte
LOCATE FOR numero = 1
		
cCadeCtacte = "" 

lnUltimoCodigo = 0
SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO  TOP 

SCAN 
 	SELECT CsrCtacte
 	LOCATE FOR VAL(cnumero) = VAL(CsrDeudor.codcli)
 	IF VAL(cnumero) = VAL(CsrDeudor.codcli)
 		cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + (CsrDeudor.codcli) 
 		SELECT CsrDeudor
 		LOOP 
 		
 	ENDIF 
 	SELECT CsrDeudor 
 		
 		lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Loccli)))

		lnidbarrio = 0
		lnidlocalidad =	1100000006 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
		lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
		lccp = ""
		
		SELECT CsrLocalidad
		LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
		IF FOUND()
			lnidlocalidad = CsrLocalidad.id
			lnidprovincia = CsrLocalidad.idprovincia
			lccp = CsrLocalidad.cpostal
		ENDIF
		
		lnidestado = 0
    	lnctadeudor = 1
    	lnctaacreedor = 0
    	lnctabanco = 0
    	lnctaotro  = 0
    	lndctalogistica = 0

        lnidcateibrng = 0
		lnidcategoria = CsrCateCtacte.id

		SELECT CsrDeudor
		lntipoiva = regcli
		IF lntipoiva = 6
			lntipoiva = 5
		ENDIF 
		
		IF lnidprovincia = 1100000022 &&RN
			lnTasaRN = CsrDeudor.tRet
			SELECT CsrCateIbRNg
			LOCATE FOR porperce = lnTasaRN 
			IF NOT FOUND()
				LOCATE FOR numero = 1
			ENDIF 
			lnidcateibrng =CsrCateIbRNg.id
		ENDIF 
		
		lnidplanpago = 1100000001
		
              
		lcfefin       = DATETIME(1900,01,01,0,0,0)
		lnlista = CsrDeudor.Listapre
		ldfechac = lcfefin
		ldfecultcompra = lcfefin
		ldfechap = lcfefin
		ldfecultpago = lcfefin
		
		lcingbrutos = " "
		lcingbrutosBA = ''
		lncomision = 0
		lnconvenio = 0
		

		lccuit =STRTRAN(STRTRAN(CsrDeudor.cuitcli,".","-"),"*","-")
		IF VAL(lccuit)=0
			lindcateibrng=0
		ENDIF 

		lcnombre = NombreNi(ALLTRIM(UPPER(CsrDeudor.nomcli)))
		
		lcReferencia = ALLTRIM(CsrDeudor.ctransp)
		
		lcCodigo = ALLTRIM(STR(INT(VAL(CsrDeudor.codcli))))
*!*	      	
*!*	      	SELECT CsrCtacte
*!*	      	APPEND BLANK	
*!*	      	replace id WITH lnid, cnumero WITH LTRIM((CsrDeudor.codcli)), cnombre WITH lcnombre, cdireccion WITH UPPER(CsrDeudor.domcli)
*!*	      	replace cpostal WITH LTRIM(lccp), idlocalidad WITH lnidlocalidad, idprovincia WITH lnidprovincia
*!*	      	replace ctelefono WITH CsrDeudor.telcli_1, tipoiva WITH lntipoiva, cuit WITH lccuit, idcategoria WITH lnidcategoria
*!*	      	replace saldo WITH 0, saldoant WITH 0, idplanpago WITH lnidplanpago, idcanalvta WITH 1100000006, estadocta WITH lnidestado
*!*	      	replace ctadeudor WITH 1, inscri01 WITH '', fecins01 WITH lcfefin, inscri02 WITH lcingbrutosBA,inscri03 WITH ''
*!*	      	replace saldoauto WITH 0,fechalta WITH lcfefin,idbarrio WITH 0,lista WITH lnlista,idcateibrng WITH lnidcateibrng
      	
          INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
          ,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
          ,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
          ,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
          ,totalizabonif,referencia);
		  VALUES (lnid,CsrDeudor.codcli,lcnombre,UPPER(CsrDeudor.domcli),LTRIM(lccp);
		  ,lnidlocalidad,lnidprovincia,CsrDeudor.telcli_1,lntipoiva,lccuit,lnidcategoria,0,0;
		  ,lnidplanpago,1100000006,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
		  ,"",0,lcfefin,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
		  ,lnconvenio,lndctalogistica,0,0,lcReferencia)
		
		
		SELECT CsrCateibrn
		LOCATE FOR  idctacte = lnid
		IF !FOUND() AND lnidcateibrng <> 0
			lccuit =STRTRAN(lccuit,"-","")
			IF VAL(lccuit)<>0
				lccuit=STRTRAN(lccuit,"-","")
				INSERT INTO CsrCateibrn (cuit,idctacte,numero,porperce,porrete);
				VALUES (lccuit,lnid,lnidcateibrng,CsrCateIbRNg.porperce,CsrCateibRng.porrete)
			ENDIF 
		ENDIF 
	
		lnUltimoCodigo  = VAL(CsrDeudor.codcli)
		lnid = lnid + 1
	    
	    *stop()
	    &&Asiganamos la ruta
		IF LEN(LTRIM(CsrDEudor.cviaj))<=0
			replace cviaj WITH '05' IN CsrDeudor
		ENDIF 
			
			SELECT CsrVendedor
			LOCATE FOR numero=VAL(CsrDeudor.cviaj)
			IF numero<>VAL(CsrDeudor.cviaj)
				LOCATE FOR numero = 5 &&Miguel
			ENDIF 	
			
			SELECT CsrZona
			LOCATE FOR numero=val(CsrDeudor.cviaj)
			IF numero<>val(CsrDeudor.cviaj)
				LOCATE FOR numero = 5 &&Miguel
		     ENDIF
		    
		    SELECT CsrRuta
			LOCATE FOR nombre=TRIM(Csrzona.nombre)
			IF nombre#TRIM(Csrzona.nombre)
				INSERT INTO CsrRuta (id,numero,nombre) ;
				VALUES (lnid,Csrzona.numero,TRIM(Csrzona.nombre))		     		
				lnidRuta = lnidRuta + 1
				*lnNumRuta = lnNumRuta + 1 
			ENDIF 
			
			SELECT Csrzonaruta
			LOCATE FOR idzona=Csrzona.id AND idruta = Csrruta.id
			IF idzona#Csrzona.id OR idruta # Csrruta.id
				INSERT INTO Csrzonaruta (id,idzona,idruta,switch);
				VALUES (lnidzonaruta,Csrzona.id,Csrruta.id,'00000')
				lnidzonaruta = lnidzonaruta + 1
		    ENDIF 
		      
			SELECT CsrRutaVdor
			LOCATE FOR idvendedor=Csrvendedor.id  AND idruta=Csrruta.id
			IF !FOUND() OR !(idvendedor=Csrvendedor.id  AND  idruta=Csrruta.id )
				INSERT INTO CsrRutaVdor (id,idruta,idvendedor,switch,idfuerzavta);
				VALUES (lnidrutavdor,Csrruta.id,Csrvendedor.id,'00000',lnidfuerzavta )
				lnidrutavdor = lnidrutavdor + 1

			ENDIF 
			
			lcdias = "2" &&ALLTRIM(STR(CsrRecorrido.carpeta)) Lunes
			FOR i=1 TO LEN(lcdias)
				SELECT CsrCaberuta
				LOCATE FOR idrutavdor=Csrrutavdor.id AND dia=VAL(SUBSTR(lcdias,i,1))
				IF idrutavdor#Csrrutavdor.id OR dia#VAL(SUBSTR(lcdias,i,1))
					INSERT INTO Csrcaberuta (id,idrutavdor,dia) ;
					VALUES (lnidcabeza,Csrrutavdor.id,VAL(SUBSTR(lcdias,i,1)))
					lnidcabeza = lnidcabeza + 1
				ENDIF 
				
				SELECT CsrCuerruta
				COUNT ALL FOR idcaberuta=Csrcaberuta.id TO nOrden
				nOrden = nOrden + 1 
			
				&&IF CsrRecorrido.orden#0
				      SELECT CsrCuerruta
				      LOCATE FOR idcaberuta=Csrcaberuta.id AND idctacte=Csrctacte.id &&AND orden=Csrrecorrido.orden
				      IF idcaberuta#Csrcaberuta.id OR idctacte#Csrctacte.id &&OR orden#CsrRecorrido.orden
		   				INSERT INTO Csrcuerruta (id,idcaberuta,idctacte,orden,turno) ;
		   				VALUES (lnidcuerruta,Csrcaberuta.id,Csrctacte.id,nOrden,1)
		   				lnidcuerruta = lnidcuerruta + 1
					ENDIF 		   				
				&&ENDIF 	   				
			NEXT 
			  
		    
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("No se grabaron algunas clientes, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
ENDIF 

lnUltimoCodigo = lnUltimoCodigo + 1 
SELECT CsrCateCtacte
LOCATE FOR numero = 5

SELECT FsrTransporte 
Oavisar.proceso('S','Procesando '+alias()) 
GO  TOP 

SCAN 

	
 
 	SELECT FsrTransporte
 		
 		lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(FsrTransporte.Loctransp)))

		lnidbarrio = 0
		lnidlocalidad =	1100000006 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
		lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
		lccp = ""
		
		SELECT CsrLocalidad
		LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
		IF FOUND()
			lnidlocalidad = CsrLocalidad.id
			lnidprovincia = CsrLocalidad.idprovincia
			lccp = CsrLocalidad.cpostal
		ENDIF
		
		lnidestado = 0
    	lnctadeudor = 0
    	lnctaacreedor = 0
    	lnctabanco = 0
    	lnctaotro  = 1
    	lnctalogistica = 0

        lnidcateibrng = 0
		lnidcategoria = CsrCateCtacte.id

		lntipoiva = 3
		
		lnidplanpago = 1100000001
		
              
		lcfefin       = DATETIME(1900,01,01,0,0,0)
		lnlista = 0
		ldfechac = lcfefin
		ldfecultcompra = lcfefin
		ldfechap = lcfefin
		ldfecultpago = lcfefin
		
		lcingbrutos = " "
		lcingbrutosBA = ''
		lncomision = 0
		lnconvenio = 0
		

		lccuit =STRTRAN(STRTRAN(FsrTransporte.cuitransp,".","-"),"*","-")
		IF VAL(lccuit)=0
			lindcateibrng=0
		ENDIF 

		lcnombre = NombreNi(ALLTRIM(UPPER(FsrTransporte.ntransp)))
		
		lcReferencia = ''

         INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
          ,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
          ,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
          ,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
          ,totalizabonif,referencia);
		  VALUES (lnid,ALLTRIM(STR(lnUltimoCodigo)) ,lcnombre,UPPER(FsrTransporte.dtransp),LTRIM(lccp);
		  ,lnidlocalidad,lnidprovincia,FsrTransporte.teltransp,lntipoiva,lccuit,lnidcategoria,0,0;
		  ,lnidplanpago,1100000006,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
		  ,"",0,lcfefin,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
		  ,lnconvenio,lnctalogistica,0,0,lcReferencia)
		
		&&Asiganamos a los clientes el transporte por referencia
		replace ALL idctaotro WITH lnid,referencia WITH '' FOR ALLTRIM(referencia)=ALLTRIM(FsrTransporte.ctransp) IN CsrCtacte
		
		lnUltimoCodigo = lnUltimoCodigo + 1 
		lnid = lnid + 1

		    
ENDSCAN

SELECT CsrCateCtacte
LOCATE FOR numero = 3

SELECT CsrAcreedor
cCadeCtacte = "" 
Oavisar.proceso('S','Procesando '+alias()) 
GO  TOP 
SCAN 

	lcLocalidadBuscada = Ciudades(STRTRAN(ALLTRIM(UPPER(CsrAcreedor.locprov)),";",""))
	
	lnidbarrio = 0
	lnidlocalidad =	1100000006 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
	lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
	lccp = ""
	
	SELECT CsrLocalidad
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
	IF FOUND()
		lnidlocalidad = CsrLocalidad.id
		lnidprovincia = CsrLocalidad.idprovincia
		lccp = CsrLocalidad.cpostal
	ENDIF

	
	SELECT CsrAcreedor
	lntipoiva = regprov
	IF lntipoiva=6
		lntipoiva = 5
	ENDIF 
	IF lntipoiva=3
		lncuit=''
	ENDIF
	

	lnidestado = 0
	lnctadeudor = 0
	lnctaacreedor=1
	lnctabanco = 0
	lnctaotro  = 0
	lnctalogistica = 0
	
	lnidcategoria = CsrCateCtacte.id


	lcfefin       = DATETIME(1900,01,01,0,0,0)
	lnlista = 0
	ldfechac = lcfefin
	ldfecultcompra = lcfefin
	ldfechap = lcfefin
	ldfecultpago = lcfefin
 
	lcingbrutosBA = ''
	lcingbrutos = ""

	lnSaldoAnt = 0
	lncomision = 0
	lntotalizabonif = 0
	lnesrecodevol = 0
	*lnidcateibrng =VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(STR(4)))
	lcnombre = NombreNi(ALLTRIM(UPPER(CsrAcreedor.nomprov))) 
	lcReferencia = CsrAcreedor.cprov
		  
    INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
    ,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
    ,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
    ,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
    ,totalizabonif,referencia);
	VALUES (lnid,ALLTRIM(STR(lnUltimoCodigo)),lcnombre,CsrAcreedor.domprov,LTRIM(lccp);
	,lnidlocalidad,lnidprovincia,CsrAcreedor.telprov_1,lntipoiva,CsrAcreedor.cuitprov,lnidcategoria,0,lnSaldoAnt;
	,1100000002,1100000006,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
	,"",0,lcfefin,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,0;
	,lnctalogistica,lnesrecodevol,lntotalizabonif,lcreferencia)
	          
    
    lnUltimoCodigo = lnUltimoCodigo + 1 
	lnid = lnid + 1
ENDSCAN

IF LEN(LTRIM(cCadeCtacte)) != 0
	=oavisar.usuario("No se grabaron algunas proveedores, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
ENDIF 

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

*!*	USE in CsrAcreedor 
USE in FsrVendedor 
USE in FsrZona 
USE IN FsrTransporte
*USE in CsrCaterionegro 
*USE in CsrCategoriaDeudor 
*USE in CsrBarrioviejo 