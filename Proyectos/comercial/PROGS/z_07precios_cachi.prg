PARAMETERS ldvacio,lcpath,lcBase,lnlimite
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

lnidproveedor = 0

SELECT CsrPrecios.*,VAL(numero) as codigo FROM CsrPRecios ;
ORDER BY codigo,fecha DESC INTO CURSOR CsrPrecio READWRITE 

nDecimalesP = 2
SELECT Csrctacte
GO BOTTOM 
nNumeroCtacte	= VAL(CsrCtacte.cnumero)
SELECT CsrProducto
Oavisar.proceso('S','Procesando '+alias()) 
GO top

*stop()
SCAN FOR !EOF()
	IF numero <> 1
		*LOOP 
	ENDIF 
	*-stop()

	SELECT CsrArticulo
	LOCATE FOR VAL(numero )= CsrProducto.numero AND NOT borrado
	IF VAL(numero )<> CsrProducto.numero
		SELECT CsrProducto
		LOOP 
	ENDIF
	cProvArticulo	 = TablaPrecios(ALLTRIM(CsrArticulo.proveedor))
	lActualizo		 = .f.
	*SELECT * FROM CsrPrecios WHERE VAL(numero)=CsrProducto.numero INTO CURSOR CsrPrecio READWRITE 
	
	SELECT CsrPrecio
	LOCATE FOR codigo = CsrProducto.numero
	*GO TOP 
	*SCAN 
	DO WHILE codigo = CsrProducto.numero AND NOT EOF()
		cProvPrecio	 = TablaPrecios(ALLTRIM(CsrPrecio.nombre))
		dFechaPre	 = CsrPrecio.fecha
		&&El precio tiene que estar borrado y ser distinto al del articulo
		IF CsrPrecio.borrado AND cProvPrecio<>cProvArticulo
			SKIP 
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
		
		
		nCodCtacte = TablaProveedores(cProvPrecio)
		
		SELECT CsrCtacte
		LOCATE FOR VAL(cnumero) = 50000+nCodCtacte
		IF FOUND()
			nIdCtacte = CsrCtacte.id
			replace ctaacreedor WITH 1 IN CsrCtaCte
		ENDIF 
		IF nIdCtacte=0
			nIdCtacte = lnIdProveedor
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
		nPrePubCiva	= CsrPrecio.preventa
		nPreVenta	= red(nPrePubCiva * (1 - nAlicuota /100),nDecimalesP)
		nPreventa	= IIF(nPreVenta = 0,nCosto,nPReventa)
		IF nCostoCiva<>0	
			nUtilCiva1	= nPrePubCiva - nCostoCiva
			nUtilSiva1	= red(nUtilCiva1 * 100 / 121,nDecimalesP)
			nPreVenta	= nCostoSiva + nUtilSiva1
		ENDIF 
		nRedondeo		= CsrArticulo.redondeo
				
		nPrePubFSiva	= a_red(nRedondeo,nPreVenta + nCostoAgre + nFleteAgre)
		&&Recalculamos con el iva
		nPrePubCiva		= red(nPreVenta* (1 + nAlicuota /100),nDecimalesP)
		*nPrePubFCiva	= a_red(nRedondeo,nPrePubCIva + nCostoAgre + nFleteAgre)
		nPrePubFCiva	= a_red(nRedondeo,nPrePubCiva + nCostoAgre + nFleteAgre)
		nIncremento		= CsrPrecio.Bonlis2
		nIncremento		= red(1 -(nIncremento/100),4)
		nPreConCiva		= red(nPrePubCiva * nIncremento,nDecimalesP)
		
		nPreConFCiva	= red((nPreConCiva  + nCostoAgre + nFleteAgre),nDecimalesP)
		nPreConFSiva	= red(nPreConFCiva * red(1-(nAlicuota/100),nDecimalesP),nDecimalesP)	
		
		nPreConFCiva	= a_red(nRedondeo,nPreConFCiva)
		nPreconFSiva	= a_red(nRedondeo,nPreConFSiva)
		
		INSERT INTO  prodprecio  ( id, idarticulo , idctacte , idestado  , costocpra , aumento ;
	           , costo , bonif1 , bonif2 , bonif3 , bonif4 , bonif5 , boniftotal , costobon , interno ;
	           , internoporce , flete , segflete , totalflete , costosiva , costociva , margen1 , utilciva1 ;
	           , utilsiva1 , redondeo , costoagre , fleteagre , preconciva , preconfsiva , preconfciva ;
	           , prepubciva , prepubfsiva , prepubfciva , fecmodi , switch , cotidolar , endolar ;
	           , costoulcpra , preotrociva1 , preotrofsiva1 , preotrofciva1,descripcion );
	     VALUES  ( lnid, nidarticulo , nidctacte , nidestado  , ncostocpra , naumento ;
	           , ncosto , nbonif1 , nbonif2 , nbonif3 , nbonif4 , nbonif5 , nboniftotal ,ncostobon , ninterno ;
	           , ninternoporce , nflete , nsegflete , ntotalflete , ncostosiva , ncostociva , nmargen1 , nutilciva1 ;
	           , nutilsiva1 , nredondeo , ncostoagre , nfleteagre , npreconciva , npreconfsiva , npreconfciva ;
	           , nprepubciva , nprepubfsiva , nprepubfciva , dfecmodi , cswitch , ncotidolar , nendolar ;
	           , ncostoulcpra , npreotrociva1 , npreotrofsiva1 , npreotrofciva1, '') 
	    
	   
		lnid = lnid + 1
		
		&&Insertamos proveedor
		IF nidCtacte = 0 AND lnidproveedor= 0
			
				
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
			
			*lnidctacte = lnidctacte + 1 			
			
			lnidproveedor = lnidctacte
    	ENDIF 
    	&&Actualizamos el precio en csrproducto
    	IF cProvPrecio = cProvArticulo AND dFechaPre > CsrProducto.fecUlPre
    		SELECT CsrProdPrecio
    		SCATTER NAME OscPrecio
    		SELECT CsrProducto
    		GATHER NAME OscPRecio FIELDS EXCEPT id,idestado,switch,codalfaprov,fecmodi
    		replace fecUlPre WITH OscPrecio.fecmodi
    		
    		lActualizo = .t.
    	ENDIF 
		SELECT CsrPrecio
		SKIP 
	ENDDO 
	
	IF NOT lActualizo
		SELECT CsrProdPrecio
		SCATTER NAME OscPrecio
		SELECT CsrProducto
		GATHER NAME OscPRecio FIELDS EXCEPT id,idestado,switch,codalfaprov,fecmodi
		replace fecUlPre WITH OscPrecio.fecmodi
    ENDIF 
	*ENDSCAN 
	*USE IN CsrPrecio 
	
	SELECT CsrProducto   				
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
*USE IN  CsrSeccion 
USE IN  CsrArticulo 
USE in CsrPrecios
USE IN CsrPrecio

