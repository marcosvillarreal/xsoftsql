PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
Set Procedure To nfJsonRead additive

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Localidad')
llok = CargarTabla(lcData,'Ctacte',.t.)
llok = CargarTabla(lcData,'Provincia')
*llok = CargarTabla(lcData,'CateIbRn',.t.)
*llok = CargarTabla(lcData,'CateIbRNg',.t.)
llok = CargarTabla(lcData,'TipoIva')
*llok = CargarTabla(lcData,'CateCtacte')
*llok = CargarTabla(lcData,'Barrio',.t.)
*llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Sucursal',.t.)
SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


IF USED('CsrDeudor')
	USE IN CsrDeudor
ENDIF 

CREATE CURSOR CsrDeudor (id i,cnombre c(30),cdireccion c(30), cdirenro c(5);
		, cdire_piso c(5), cdire_dpto c(5), idlocalidad i, nomlocalidad c(30);
		, nomprov c(30), ctelefono c(30), idcategoiva i, nomcategoiva c(30);
		, cuit c(20), ctelefono2 c(30), estado i, idlista i, nomlista c(30);
		, zona i, idvendedor i, codvendedor c(30), nomvendedor c(30))

SET SAFETY OFF
SELECT CsrDeudor
INDEX on id TAG id
SET SAFETY ON 
					
LOCAL cFileName,loData
cFileName = ADDBS(lcpath)+"Clientes.json"

stop()

loJson = nfjsonread(FileToStr(cFileName))

For each loData in loJson.data

    Insert into CsrDeudor values (loData.id, loData.cnombre)

ENDFOR
    		
*XMLTOCURSOR(cFileName,"CsrDeudor",512+8192)

		
SELECT CsrLocalidad
IF FSIZE('id')>4
   lntamloc = 10
ELSE 
   lntamloc = 8
ENDIF 

SELECT CsrProvincia
IF FSIZE('id')>4
   lntamprov = 10
ELSE 
   lntamprov = 8
ENDIF 

SELECT CsrTipoIva
IF FSIZE('id')>4
   lntamiva = 10
ELSE 
   lntamiva = 8
ENDIF 

*!*	SELECT CsrCateCtacte
*!*	IF FSIZE('id')>4
*!*	   lntamcate = 10
*!*	ELSE 
*!*	   lntamcate = 8
*!*	ENDIF

lnid = RecuperarID('CsrCtacte',Goapp.sucursal10)

cCadeCtacte = "" 

SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO  TOP 
vista()

*!*	SCAN 
*!*	 	SELECT CsrCtacte
*!*	 	LOCATE FOR VAL(cnumero) = CsrDeudor.numero
*!*	 	IF VAL(cnumero) = CsrDeudor.numero
*!*	 		cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + STRtrim(CsrDeudor.numero,10) 
*!*	 		SELECT CsrDeudor
*!*	 		LOOP  		
*!*	 	ENDIF 
*!*	 	
*!*	 	SELECT CsrDeudor 
*!*	 		
*!*	 		lcLocalidadBuscada = Ciudades(ALLTRIM(UPPER(CsrDeudor.Localidad)))

*!*			lnidbarrio = 1100000001
*!*			lnidlocalidad =	1100000006 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
*!*			lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
*!*			lccp = ""
*!*			
*!*			SELECT CsrLocalidad
*!*			LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
*!*			IF FOUND()
*!*				lnidlocalidad = CsrLocalidad.id
*!*				lnidprovincia = CsrLocalidad.idprovincia
*!*				lccp = CsrLocalidad.cpostal
*!*			ENDIF
*!*			
*!*			lnidestado = 0
*!*	    	lnctadeudor = 1
*!*	    	lnctaacreedor = 0
*!*	    	lnctabanco = 0
*!*	    	lnctaotro  = 0
*!*	    	lndctalogistica = 0
*!*	        
*!*			lnidcategoria = VAL(str(Goapp.sucursal10+10,2)+strzero(1,lntamcate))
*!*			SELECT CsrCateCtacte
*!*			LOCATE FOR numero = CsrDeudor.categoria
*!*			IF FOUND()
*!*				lnidcategoria = CsrCateCtacte.id
*!*			ENDIF 

*!*			SELECT CsrDeudor
*!*			lntipoiva = tipocuit
*!*			IF lntipoiva=7
*!*				lntipoiva = 5
*!*			ENDIF 
*!*			IF lntipoiva=3
*!*				lncuit=''
*!*			ENDIF
*!*			lnidcateibrng =VAL(str(Goapp.sucursal10+10,2)+strzero(4,8))
*!*			
*!*			
*!*			lnidplanpago = CsrDeudor.tipo_pago
*!*			IF CsrDeudor.tipo_pago=0
*!*				lnidplanpago=1
*!*			ENDIF 
*!*			IF lnidplanpago>2 &&=3 remito 3ro
*!*				lnidplanpago = 10
*!*				lndctalogistica=1
*!*			ENDIF 
*!*			lnidplanpago =VAL("11"+strzero(lnidplanpago,8))
*!*			
*!*	              
*!*			lcfefin       = DATETIME(1900,01,01,0,0,0)
*!*			lnlista = CsrDeudor.Lista
*!*			ldfechac = CsrDeudor.Fechaulcpr
*!*			ldfecultcompra = lcfefin
*!*			IF !EMPTY(ldfechac)
*!*				ldfecultcompra = DATETIME(YEAR(ldfechac),MONTH(ldfechac),DAY(ldfechac),0,0,0)
*!*			ENDIF 
*!*			ldfechap = CsrDeudor.Fechaulpag
*!*			ldfecultpago = lcfefin
*!*			IF !EMPTY(ldfechap)
*!*				ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
*!*			ENDIF 
*!*			lcingbrutos = " "
*!*			lcingbrutosBA = CsrDeudor.ibrutos
*!*			lncomision = CsrDeudor.comision
*!*			lnconvenio = CsrDeudor.convenio
*!*			

*!*			SELECT CsrCateIbRNg
*!*			LOCATE FOR numero = CsrDeudor.cateibrn
*!*			IF FOUND()
*!*				lnidcateibrng = CsrCateIbRNg.id
*!*			ENDIF 
*!*			IF CsrDeudor.provincia = "R"
*!*				lcingbrutos = CsrDeudor.ibrutos
*!*				lcingbrutosBA = " "
*!*			ENDIF 
*!*			lccuit =STRTRAN(STRTRAN(CsrDeudor.cuit,".","-"),"*","-")
*!*			IF VAL(lccuit)=0
*!*				lindcateibrng=0
*!*			ENDIF 

*!*			lcnombre = NombreNi(ALLTRIM(UPPER(CsrDeudor.nombre)))
*!*	      	
*!*	      		
*!*	          INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
*!*	          ,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
*!*	          ,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
*!*	          ,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
*!*	          ,totalizabonif);
*!*			  VALUES (lnid,LTRIM(STR(CsrDeudor.numero)),lcnombre,UPPER(CsrDeudor.direccion),LTRIM(lccp);
*!*			  ,lnidlocalidad,lnidprovincia,CsrDeudor.telefono,lntipoiva,lccuit,lnidcategoria,0,0;
*!*			  ,lnidplanpago,1100000006,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
*!*			  ,"",0,lcfefin,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago;
*!*			  ,lnconvenio,lndctalogistica,0,0)

*!*			*IF lnidcateibrng<>VAL(STR(Goapp.sucursal10 + 10,2))+4 AND lntipoiva <>VAL(STR(Goapp.sucursal10 + 10,2))+ 3
*!*			SELECT CsrCateibrn
*!*			LOCATE FOR  idctacte = lnid
*!*			IF !FOUND() AND lnidcateibrng <> 0
*!*				lccuit =STRTRAN(CsrDeudor.cuit,"-","")
*!*				IF VAL(lccuit)<>0
*!*					lccuit=STRTRAN(lccuit,"-","")
*!*					INSERT INTO CsrCateibrn (cuit,idctacte,numero,porperce,porrete);
*!*					VALUES (lccuit,lnid,lnidcateibrng,CsrCateIbRNg.porperce,CsrCateibRng.porrete)
*!*				ENDIF 
*!*			ENDIF 
*!*			lnid = lnid + 1
*!*		          
*!*	ENDSCAN

*!*	IF LEN(LTRIM(cCadeCtacte)) != 0
*!*		=oavisar.usuario("No se grabaron algunas clientes, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
*!*	ENDIF 

*!*	SELECT  distinct CsrCtacte.idlocalidad,IIF(ISNULL(CsrbarrioViejo.nombre),0,CsrDeudor.barrio) as numbarrio,IIF(ISNULL(CsrbarrioViejo.nombre),"",CsrBarrioViejo.nombre) as nombre;
*!*	FROM CsrDeudor;
*!*	INNER JOIN CsrCtacte ON CsrDeudor.numero = VAL(CsrCtacte.cnumero);
*!*	left JOIN CsrBarrioViejo ON CsrDeudor.barrio = CsrBarrioViejo.numero;
*!*	into CURSOR 'CsrDire'

*!*	lnidd = RecuperarID('CsrBarrio',Goapp.sucursal10)

*!*	lnnumero = 1
*!*	SELECT CsrDire
*!*	GO top
*!*	SCAN 
*!*	   	lcnombre=NombreNi(ALLTRIM(UPPER(CsrDire.nombre)))

*!*		IF CsrDire.numbarrio <> 0
*!*			INSERT INTO CsrBarrio(id,numero,nombre,idlocalidad) VALUES (lnidd,lnnumero,lcnombre,CsrDire.idlocalidad)
*!*			lnidd = lnidd + 1
*!*			lnnumero = lnnumero + 1
*!*		ENDIF 
*!*	ENDSCAN 


*!*	SELECT CsrDeudor
*!*	GO top
*!*	SCAN 
*!*		lnidbarrio = 0
*!*		SELECT CsrCtacte
*!*		LOCATE FOR VAL(cnumero)=CsrDeudor.numero
*!*		IF FOUND() AND VAL(cnumero)=CsrDeudor.numero
*!*			lnidlocalidad = CsrCtacte.idlocalidad
*!*		ENDIF 
*!*		SELECT CsrBarrioviejo
*!*		LOCATE FOR numero = CsrDeudor.barrio
*!*		IF FOUND()
*!*			SELECT CsrBarrio
*!*			LOCATE FOR ALLTRIM(nombre)=ALLTRIM(CsrBarrioviejo.nombre) AND idlocalidad = lnidlocalidad
*!*			IF FOUND() AND ALLTRIM(nombre)=ALLTRIM(CsrBarrioviejo.nombre) AND idlocalidad = lnidlocalidad
*!*				lnidbarrio=CsrBarrio.id
*!*				UPDATE CsrCtacte SET idbarrio = lnidbarrio WHERE VAL(cnumero) = CsrDeudor.numero
*!*			ENDIF
*!*		ENDIF
*!*		SELECT CsrDeudor
*!*				
*!*	ENDSCAN 

*!*	SELECT CsrAcreedor
*!*	cCadeCtacte = "" 
*!*	Oavisar.proceso('S','Procesando '+alias()) 
*!*	GO  TOP 
*!*	SCAN 

*!*	 	
*!*			SELECT CsrCtacte
*!*			LOCATE FOR cnumero=LTRIM(STR(10000+CsrAcreedor.numero))
*!*			IF FOUND()
*!*				cCadeCtacte = LTRIM(cCadeCtacte) + IIF(LEN(LTRIM(cCadeCtacte)) != 0,",","") + STRtrim(CsrAcreedor.numero,10) 
*!*				SELECT  CsrAcreedor
*!*				LOOP
*!*			ENDIF
*!*			SELECT CsrAcreedor
*!*			lcLocalidadBuscada = Ciudades(STRTRAN(ALLTRIM(UPPER(CsrAcreedor.Localidad)),";",""))
*!*			
*!*			lnidbarrio = 0
*!*			lnidlocalidad =	1100000006 &&VAL(str(Goapp.sucursal10+10,2)+strzero(6,lntamloc))
*!*			lnidprovincia =	1100000002 &&VAL(str(Goapp.sucursal10+10,2)+strzero(2,lntamprov))
*!*			lccp = ""
*!*			
*!*			SELECT CsrLocalidad
*!*			LOCATE FOR ALLTRIM(nombre) = ALLTRIM(lcLocalidadBuscada)
*!*			IF FOUND()
*!*				lnidlocalidad = CsrLocalidad.id
*!*				lnidprovincia = CsrLocalidad.idprovincia
*!*				lccp = CsrLocalidad.cpostal
*!*			ENDIF

*!*			
*!*			SELECT CsrAcreedor
*!*			lntipoiva = tipocuit
*!*			IF lntipoiva=7
*!*				lntipoiva = 5
*!*			ENDIF 
*!*			IF lntipoiva=3
*!*				lncuit=''
*!*			ENDIF
*!*			lnidcateibrng =VAL(str(Goapp.sucursal10+10,2)+strzero(4,8))
*!*			
*!*			lnidcategoria = 22
*!*			SELECT CsrCateCtacte
*!*			LOCATE FOR numero=lnidcategoria
*!*			lnidcategoria = CsrCateCtacte.id
*!*			SELECT CsrPlanCue
*!*			LOCATE FOR cuenta = CsrAcreedor.cuenta
*!*			IF FOUND() AND cuenta = CsrAcreedor.cuenta AND 'MERCAD'$nombre
*!*				lnidcategoria = 21
*!*				SELECT CsrCateCtacte
*!*				LOCATE FOR numero=lnidcategoria
*!*				lnidcategoria = CsrCateCtacte.id
*!*			ENDIF

*!*			lnidestado = 0
*!*	    	lnctadeudor = 0
*!*	    	lnctaacreedor=1
*!*	    	lnctabanco = 0
*!*	    	lnctaotro  = 0
*!*	    	lnctalogistica = 0
*!*			lcfefin       = DATETIME(1900,01,01,0,0,0)
*!*			lnlista = 0
*!*			ldfechac = CsrAcreedor.Fechaulcpr
*!*			ldfecultcompra = lcfefin
*!*			IF !EMPTY(ldfechac)
*!*				ldfecultcompra = DATETIME(YEAR(ldfechac),MONTH(ldfechac),DAY(ldfechac),0,0,0)
*!*			ENDIF 
*!*			ldfechap = CsrAcreedor.Fechaulpag
*!*			ldfecultpago = lcfefin
*!*			IF !EMPTY(ldfechap)
*!*				ldfecultpago = DATETIME(YEAR(ldfechap),MONTH(ldfechap),DAY(ldfechap),0,0,0)
*!*			ENDIF 
*!*			lcingbrutosBA = CsrAcreedor.ibrutos
*!*			lcingbrutos = ""
*!*			IF CsrAcreedor.provincia = "R"
*!*				lcingbrutos = CsrAcreedor.ibrutos
*!*				lcingbrutosBA = " "
*!*			ENDIF 
*!*			
*!*			lnSaldoAnt = 0
*!*			lncomision = 0
*!*			lntotalizabonif = 0
*!*	    	lnesrecodevol = 0
*!*			*lnidcateibrng =VAL(STR(Goapp.sucursal10 + 10,2)+LTRIM(STR(4)))
*!*			lcnombre = NombreNi(ALLTRIM(UPPER(CsrAcreedor.nombre))) 
*!*	    		IF "MASTEL"$lcnombre OR "DANON"$lcnombre OR "NUTRIC"$lcnombre
*!*	    			lntotalizabonif = 1
*!*	    			lnesrecodevol = 1
*!*	    		ENDIF    
*!*		        INSERT INTO CsrCtacte (id,CNUMERO,CNOMBRE,CDIRECCION,CPOSTAL,IDLOCALIDAD,IDPROVINCIA,CTELEFONO;
*!*		        ,TIPOIVA,CUIT,IDCATEGORIA,SALDO,SALDOANT,idplanpago,idcanalvta,estadocta,ctadeudor,ctaacreedor;
*!*		        ,ctabanco,ctaotro,inscri01,fecins01,inscri02,inscri03,saldoauto,fechalta,idbarrio,lista;
*!*		        ,idcateibrng,ingbrutos,comision,fecultcompra,fecultpago,convenio,ctalogistica,esrecodevol;
*!*		        ,totalizabonif);
*!*			VALUES (lnid,LTRIM(STR(10000+CsrAcreedor.numero)),lcnombre,CsrAcreedor.direccion,LTRIM(lccp);
*!*			,lnidlocalidad,lnidprovincia,CsrAcreedor.telefono,lntipoiva,CsrAcreedor.cuit,lnidcategoria,0,lnSaldoAnt;
*!*			,1100000002,1100000006,lnidestado,lnctadeudor,lnctaacreedor,lnctabanco,lnctaotro,"",lcfefin,lcingbrutosBA;
*!*			,"",0,lcfefin,0,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,0;
*!*			,lnctalogistica,lnesrecodevol,lntotalizabonif)
*!*			          
*!*			SELECT CsrCateibrn
*!*			LOCATE FOR  idctacte = lnid
*!*			IF !FOUND() AND lnidcateibrng <> 0
*!*				lccuit =STRTRAN(CsrAcreedor.cuit,"-","")
*!*				IF VAL(lccuit)<>0
*!*					lccuit=STRTRAN(lccuit,"-","")
*!*					INSERT INTO CsrCateibrn (cuit,idctacte,numero,porperce,porrete);
*!*					VALUES (lccuit,lnid,lnidcateibrng,CsrCateIbRNg.porperce,CsrCateIbRNg.porrete)
*!*				ENDIF 
*!*			ENDIF 
*!*	         
*!*			lnid = lnid + 1
*!*	ENDSCAN

*!*	IF LEN(LTRIM(cCadeCtacte)) != 0
*!*		=oavisar.usuario("No se grabaron algunas proveedores, porque estan duplicados"+CHR(13)+cCadeCtacte,0)
*!*	ENDIF 

*!*	Oavisar.proceso('N') 
*!*	=MESSAGEBOX('Proceso terminado! ')

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
USE in CsrDeudor
 
*!*	USE in CsrAcreedor 
*!*	USE in CsrLocalidadViejo 
*!*	USE in CsrProvinciaViejo 
*!*	USE in CsrCaterionegro 
*!*	USE in CsrCategoriaDeudor 
*!*	USE in CsrBarrioviejo 