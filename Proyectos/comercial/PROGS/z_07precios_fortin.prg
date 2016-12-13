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
llok = CargarTabla(lcData,'Producto')
llok = CargarTabla(lcData,'ProdPrecio',.t.)

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


*USE ALLTRIM(lcpath )+"\gestion\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\precios" in 0 alias CsrPrecio EXCLUSIVE	

USE  ALLTRIM(lcpath )+"\precios" in 0 alias CsrPrecio EXCLUSIVE	

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid

lnid = RecuperarID('CsrProdPrecio',Goapp.sucursal10)

SELECT CsrArticulo

Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	SELECT CsrProducto
	IF DELETED()
		SELECT CsrArticulo
		LOOP 
	ENDIF 
	LOCATE FOR numero=VAL(CsrArticulo.numero )
	IF numero=VAL(CsrArticulo.numero)
		SELECT CsrArticulo
		LOOP 
	ENDIF
	
	STORE 0 TO   ncodigo , nidctacte , nidmarca , nidforma , nidunidad , nidtprod , nidtipovta; 
           , nidtamano , nidcatego , nidrubro , nidestado , nidubicacio , nidorigen ;
           , nincluirped , nidmoneda , nidiva , nunibulto , nnofactura , nnolista , nespromocion ;
           , nminimofac , npeso , nvolumen , nfracciona , npuntope, ndivisible ,nnomodifica  ;
           , nctaaorden, nesinsumo , nidfamilia , nidcategotipo, ncotidolar , nendolar 
    STORE "" TO  cnombre , ccodalfa , ccontrolador , cnommayorista , ccodalfaprov , ccodbarra14;
           , ccodbarra13 
    STORE DATE() TO  dfeculcpra , dfeculvta , dfecalta , dfecmodi , dfeculpre
           
	cnombre		= NombreNi(alltrim(CsrArticulo.nombre))
	ncodigo		= VAL(Csrarticulo.NUMERO)
	ccodalfa	= ALLTRIM(CsrArticulo.codigo_fac)
	ccodalfaprov = ALLTRIM(CsrArticulo.codigo_pro)
	
	cnommayorista	= cnombre
	ccontrolador	= cnombre
	*Almacenamos el codigo anterior para luego importar las secciones con productos
    nidrubro	= Csrarticulo.seccion
    
    lcMarca 	= CsrArticulo.marca
    lcMarca		= TablaMarcas(lcMarca)
    
    SELECT CsrMarca
    LOCATE FOR nombre=lcMarca
    IF NOT FOUND()
	   	GO TOP 
	ENDIF 
   	nidmarca = CsrMarca.id
    
	SELECT CsrUbicacion
	GO TOP 
	nidubicacio = CsrUbicacion.id
	
   	nidestado 	= IIF(empty(Csrarticulo.debaja),1,2)
    nidiva    	= VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,1),8))
    nidtipovta	= 1 &&UNIDADES=1 ,	BULTOS = 2.
    nidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
	cswitch		= "00000"

	IF NOT EMPTY(Csrarticulo.fechapre)   
		dfecmodi = DATETIME(YEAR(Csrarticulo.fechapre),MONTH(Csrarticulo.fechapre),DAY(Csrarticulo.fechapre),0,0,0)
	ENDIF 		
									
	
	INSERT INTO  producto  ( id , numero  , nombre  , codalfa , idctacte , idmarca ;
           , idforma , idunidad , idtprod , idtipovta ;
           , idtamano , idcatego , idrubro , idestado , idubicacio , idorigen ;
           , nomodifica , incluirped , idmoneda , idiva , feculcpra , feculvta ;
           , fecalta , fecmodi , unibulto , nofactura , nolista , espromocion ;
           , minimofac , peso , volumen , fracciona , puntope, switch , divisible ;
           , controlador , nommayorista , ctaaorden, esinsumo , idfamilia ;
           , idcategotipo, codalfaprov , cotidolar , endolar , codbarra14;
           , codbarra13 , feculpre ) ;
     VALUES  ( lnid , ncodigo , cnombre , ccodalfa , nidctacte , nidmarca ;
           , nidforma , nidunidad , nidtprod , nidtipovta ;
           , nidtamano , nidcatego , nidrubro , nidestado , nidubicacio , nidorigen ;
           , nnomodifica , nincluirped , nidmoneda , nidiva , dfeculcpra , dfeculvta ;
           , dfecalta , dfecmodi , nunibulto , nnofactura , nnolista , nespromocion ;
           , nminimofac , npeso , nvolumen , nfracciona , npuntope, cswitch , ndivisible ;
           , ccontrolador , cnommayorista , nctaaorden, nesinsumo , nidfamilia ;
           , nidcategotipo, ccodalfaprov , ncotidolar , nendolar , ccodbarra14 ;
           , ccodbarra13 , dfeculpre) 
    
    cObservacion = CsrArticulo.observa
    IF lentrim(cObservacion)<>0
    	INSERT INTO CsrProductoDeta (id, idarticulo, descripcion, switch );
    	VALUES (lniddeta, lnid , cObservacion , "30000")
    	
    	lniddeta = lniddeta + 1 
    ENDIF 	        
	lnid = lnid + 1

	 SELECT CsrArticulo   				
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
*USE IN  CsrSeccion 
USE IN  CsrArticulo 
USE in CsrmarcaVie 

