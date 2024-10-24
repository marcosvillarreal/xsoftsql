PARAMETERS ldvacio,lcpath,lcBase,lnlimite

ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
*lnlimite = IIF(PCOUNT()<4,"",lnlimite)
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
llok = CargarTabla(lcData,'Producto')
llok = CargarTabla(lcData,'ProdPrecio',.t.)
llok = CargarTabla(lcData,'TipoIVA')
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'Localidad')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


USE  ALLTRIM(lcpath )+"\precios" in 0 alias CsrPrecios EXCLUSIVE	

USE  ALLTRIM(lcpath )+"\articulo" in 0 alias CsrArticulo EXCLUSIVE	

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid

lnid = RecuperarID('CsrProdPrecio',Goapp.sucursal10)
lnidctacte = RecuperarID('CsrCtacte',Goapp.sucursal10)

nDecimalesP = 3
SELECT Csrctacte
GO BOTTOM 
nNumeroCtacte	= VAL(CsrCtacte.cnumero)
i = 1
SELECT CsrProducto
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF() &&AND i < lnlimite
*!*		IF numero <> 1
*!*			LOOP 
*!*		ENDIF 
*!*		stop()

	SELECT CsrArticulo
	LOCATE FOR VAL(numero )= CsrProducto.numero AND NOT borrado
	IF VAL(numero )<> CsrProducto.numero
		SELECT CsrProducto
		LOOP 
	ENDIF
	cProvArticulo	 = TablaPrecios(ALLTRIM(CsrArticulo.proveedor))
	
	SELECT * FROM CsrPrecios WHERE VAL(numero)=CsrProducto.numero INTO CURSOR CsrPrecio READWRITE 
	
	lActualizo		 = .f.
	
	SELECT CsrPrecio
	GO TOP 
	SCAN 
		cProvPrecio	 = TablaPrecios(ALLTRIM(CsrPrecio.nombre))
		&&El precio tiene que estar borrado y ser distinto al del articulo
		IF CsrPrecio.borrado AND cProvPrecio<>cProvArticulo
			LOOP 
		ENDIF 
		
		STORE 0 TO   nid, nidarticulo , nidctacte , nidestado  , ncostocpra , naumento ;
	           , ncosto , nbonif1 , nbonif2 , nbonif3 , nbonif4 , nbonif5 , nboniftotal ;
	           ,ncostobon , ninterno ;
	           , ninternoporce , nflete , nsegflete , ntotalflete , ncostosiva , ncostociva ;
	           , nmargen1 , nutilciva1 ;
	           , nutilsiva1 , nredondeo , ncostoagre , nfleteagre , npreconciva , npreconfsiva ;
	           , npreconfciva ;
	           , nprepubciva , nprepubfsiva , nprepubfciva  , ncotidolar , nendolar ;
	           , ncostoulcpra , npreotrociva1 , npreotrofsiva1 , npreotrofciva1;
	   			, nAlicuota
	   	        
	    STORE DATE() TO  dfecmodi 
		
		nIdArticulo	= CsrProducto.id
	   	nidestado 	= 1
	   	cswitch		= "00000"
		
		
		SELECT CsrCtacte
		LOCATE FOR cnombre = cProvPrecio
		IF FOUND()
			nIdCtacte = CsrCtacte.id
			replace ctaacreedor WITH 1 IN Csrctacte
		ENDIF 
		
		IF NOT EMPTY(CsrPrecio.fecha)   
			dfecmodi = DATETIME(YEAR(CsrPrecio.fecha),MONTH(CsrPrecio.fecha),DAY(CsrPrecio.fecha),0,0,0)
		ENDIF 		
		
		SELECT CsrTipoIva
		LOCATE FOR id = CsrProducto.idiva
		nAlicuota = CsrTipoIva.tasa
		
		nCostoCpra	= CsrPrecio.Costo
		nAumento	= CsrPrecio.aumento							
		nCosto		= red((nCostoCpra * nAumento) / 100,nDecimalesP) + nCostoCpra
		nBonif1		= CsrPrecio.bonif1
		nBonif2		= CsrPrecio.bonif2
		nBonif3		= CsrPrecio.bonif3
		nBonif4		= CsrPrecio.bonif4
		nBonif5		= CsrPrecio.bonif5
		nCostoBon	= nCosto - red(nCosto *(nbonif1/100),nDecimalesP)
		nCostoBon	= nCostoBon - red(nCostoBon *(nbonif2/100),nDecimalesP)
		nCostoBon	= nCostoBon - red(nCostoBon *(nbonif3/100),nDecimalesP)
		nCostoBon	= nCostoBon - red(nCostoBon *(nbonif4/100),nDecimalesP)
		nCostoBon	= nCostoBon - red(nCostoBon *(nbonif5/100),nDecimalesP)
		nBonifTotal	= red((nCosto - nCostoBon)/nCosto*100 ,ndecimalesP)
		nFlete		= CsrPrecio.Flete
		nSegFlete	= CsrPrecio.SeFlete
		nTotalFlete	= nFlete + red((nFlete*nSegFlete/100),ndecimalesP)
		nIvaCosto	= red((nCostoBon + nTotalFlete) * nAlicuota/100, nDecimalesP)
		nCostoSiva	= nCostoBon + nTotalFlete + nInterno
		nCostoCiva	= nCostoSiva + nIvaCosto
		nMargen1	= CsrPrecio.utilidad
		nCostoAgre	= CsrPrecio.costoagre
		nFleteAgre	= 0
		nPreConCiva	= CsrPrecio.preventa
		nPreVenta	= red(nPreConCiva * (1 - nAlicuota /100),nDecimalesP)
		nPreventa	= IIF(nPreVenta = 0,nCosto,nPReventa)
		IF nCostoCiva<>0	
			nUtilCiva1	= nPreConCiva - nCostoCiva
			nUtilSiva1	= red(nUtilCiva1 * 100 / 121,nDecimalesP)
			nPreVenta	= nCostoSiva + nUtilSiva1
		ENDIF 
		nRedondeo		= CsrArticulo.redondeo
		
		nPreConFSiva	= a_red(nRedondeo,nPreVenta + nCostoAgre + nFleteAgre)
		nPreConFCiva	= a_red(nRedondeo,nPreConCIva + nCostoAgre + nFleteAgre)
		nIncremento		= CsrPrecio.Bonlis2
		nIncremento		= red(1+(nIncremento/100),4)
		nPrePubCiva		= red(nPreConCiva * nIncremento,nDecimalesP)
		
		nPrePubFCiva	= red((nPreConCiva  + nCostoAgre + nFleteAgre) * nIncremento,nDecimalesP)
		*nPrePubFSiva	= red(nPreConCiva * red(1-(nAlicuota/100),nDecimalesP),nDecimalesP)
		*nPrePubFSiva	= red((nPrePubFSiva + nCostoAgre + nFleteAgre) * nIncremento,nDecimalesP)	
		nPrePubFSiva	= red(nPrePubFCiva * red(1-(nAlicuota/100),nDecimalesP),nDecimalesP)
		
		nPrePubFCiva	= a_red(nRedondeo,nPrePubFCiva)
		nPrePubFSiva	= a_red(nRedondeo,nPrePubFSiva)
		
		INSERT INTO  prodprecio  ( id, idarticulo , idctacte , idestado  , costocpra , aumento ;
	           , costo , bonif1 , bonif2 , bonif3 , bonif4 , bonif5 , boniftotal , costobon , interno ;
	           , internoporce , flete , segflete , totalflete , costosiva , costociva , margen1 , utilciva1 ;
	           , utilsiva1 , redondeo , costoagre , fleteagre , preconciva , preconfsiva , preconfciva ;
	           , prepubciva , prepubfsiva , prepubfciva , fecmodi , switch , cotidolar , endolar ;
	           , costoulcpra , preotrociva1 , preotrofsiva1 , preotrofciva1 );
	     VALUES  ( lnid, nidarticulo , nidctacte , nidestado  , ncostocpra , naumento ;
	           , ncosto , nbonif1 , nbonif2 , nbonif3 , nbonif4 , nbonif5 , nboniftotal ,ncostobon , ninterno ;
	           , ninternoporce , nflete , nsegflete , ntotalflete , ncostosiva , ncostociva , nmargen1 , nutilciva1 ;
	           , nutilsiva1 , nredondeo , ncostoagre , nfleteagre , npreconciva , npreconfsiva , npreconfciva ;
	           , nprepubciva , nprepubfsiva , nprepubfciva , dfecmodi , cswitch , ncotidolar , nendolar ;
	           , ncostoulcpra , npreotrociva1 , npreotrofsiva1 , npreotrofciva1) 
	    
	   
		lnid = lnid + 1
		
		&&Insertamos proveedor
		IF nidCtacte = 0
			
				
			STORE 0 TO lnidlocalidad,lnidprovincia,lntipoiva,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica;
			,lnctabanco,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,lnsaldo,lnsaldoant,lnestadocta;
		    ,lnbonif1,lnbonif2,lncopiatkt,lnconvenio,lnsaldoauto,lnidbarrio,lnlista,lnidcateibrng,lncomision;
		    ,lnidtipodoc,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif;
		    ,lndiasvto,lnplanpago
		    
		   	STORE "" TO lccnumero,lccnombre,lccdireccion,lccpostal,lcctelefono2,lcctelefono,lcemail,lccuit;
		    ,lcobserva,lcinscri01,lcinscri02,lcinscri03,lcingbrutos,lcnumdoc
		    
		    STORE 1 TO 	lnctaacreedor, lnidcanalvta
		    
		    STORE DATETIME(1900,01,01,0,0,0) TO ldfechalta,ldfecins01,ldfecultcompra,ldfecultpago
			nNumeroCtacte	= nNumeroCtacte + 1  
			lccnumero		= ALLTRIM(STR(50000+nNumeroCtacte))
			lccnombre		= cProvPrecio
			lcobserva		= "IMPORTADO"
			lntipoiva 		= 1
			lccuit 			= "00-00000000-0"
			lnidcategoria 	= 1100000003
			lnidplanpago	= 1100000002
					
			SELECT CsrLocalidad
			LOCATE FOR ALLTRIM(nombre) = ALLTRIM("CARMEN DE PATAGONES")
			IF FOUND()
				lnidlocalidad = CsrLocalidad.id
				lnidprovincia = CsrLocalidad.idprovincia
				lccpostal = CsrLocalidad.cpostal
			ENDIF

			lccnombre = NombreNi(ALLTRIM(UPPER(lccnombre)))
		     
			INSERT INTO Csrctacte (id,cnumero,cnombre,cdireccion,cpostal,idlocalidad,idprovincia,ctelefono2;
			,ctelefono,email,tipoiva,cuit,idcategoria,ctadeudor,ctaacreedor,ctalogistica,ctabanco,ctaotro;
			,ctaorden,idplanpago,idcanalvta,fechalta,observa,saldo,saldoant,estadocta,bonif1,bonif2,copiatkt;
			,inscri01,fecins01,inscri02,inscri03,convenio,saldoauto,idbarrio,lista,idcateibrng,ingbrutos;
			,comision,fecultcompra,fecultpago,numdoc,idtipodoc,existeibto,existegan,diasvto,idtablaint,esrecodevol;
			,totalizabonif);
		    VALUES(lnidctacte,lccnumero,lccnombre,lccdireccion,lccpostal,lnidlocalidad,lnidprovincia,lcctelefono2;
		    ,lcctelefono,lcemail,lntipoiva,lccuit,lnidcategoria,lnctadeudor,lnctaacreedor,lnctalogistica,lnctabanco;
		    ,lnctaotro,lnctaorden,lnidplanpago,lnidcanalvta,ldfechalta,lcobserva,lnsaldo,lnsaldoant,lnestadocta;
		    ,lnbonif1,lnbonif2,lncopiatkt,lcinscri01,ldfecins01,lcinscri02,lcinscri03,lnconvenio,lnsaldoauto;
		    ,lnidbarrio,lnlista,lnidcateibrng,lcingbrutos,lncomision,ldfecultcompra,ldfecultpago,lcnumdoc,lnidtipodoc;
		    ,lnexisteibto,lnexistegan,lndiasvto,lnidtablaint,lnesrecodevol,lntotalizabonif)
			
			replace idctacte WITH lnidctacte IN CsrProdPrecio
			
			lnidctacte = lnidctacte + 1 			
			
    	ENDIF 
    	&&Actualizamos el precio en csrproducto
    	IF cProvPrecio = cProvArticulo
    		SELECT CsrProdPrecio
    		SCATTER NAME OscPrecio
    		SELECT CsrProducto
    		GATHER NAME OscPRecio FIELDS EXCEPT id,idestado,fecmodi,switch,codalfaprov
    		lActualizo = .t.
    	ENDIF 
    	
		SELECT CsrPrecio
	ENDSCAN 
	
	IF NOT lActualizo
		SELECT CsrProdPrecio
		SCATTER NAME OscPrecio
		SELECT CsrProducto
		GATHER NAME OscPRecio FIELDS EXCEPT id,idestado,switch,codalfaprov,fecmodi
		replace fecUlPre WITH OscPrecio.fecmodi
    ENDIF 
    
	USE IN CsrPrecio 
	
	SELECT CsrProducto   
	i = i + 1 				
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
*USE IN  CsrSeccion 
USE IN  CsrArticulo 
USE in CsrPrecios


