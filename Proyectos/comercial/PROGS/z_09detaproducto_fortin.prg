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
llok = CargarTabla(lcData,'Producto',.t.)
llok = CargarTabla(lcData,'ProductoDeta',.t.)
llok = CargarTabla(lcData,'Variedad',.t.)
llok = CargarTabla(lcData,'Rubro')
llok = CargarTabla(lcData,'Marca',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Ubicacion',.t.)
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


*USE ALLTRIM(lcpath )+"\gestion\seccion" IN 0 ALIAS CsrSeccion EXCLUSIVE 

USE  ALLTRIM(lcpath )+"\articulo" in 0 alias CsrArticulo EXCLUSIVE	

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid
*****
SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

lnid = RecuperarID('CsrMarca',Goapp.sucursal10)

SELECT distinct UPPER(marca) as nombre FROM CsrArticulo ORDER BY marca INTO CURSOR CsrMarcaVie READWRITE 

SELECT CsrMarcaVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
  	lcnombre=NombreNi(ALLTRIM(UPPER(CsrMarcaVie.nombre)))
	lcnombre	= TablaMarcas(lcNombre)
	
	SELECT CsrMarca
	LOCATE FOR nombre = lcnombre
	IF NOT FOUND() 
	   	INSERT INTO Csrmarca (id,numero,nombre,idfuerzavta);
	   	VALUES (lnid,RECNO('CsrMarca')+1,lcnombre,lnidfuerzavta)
	   	
	   	lnid = lnid + 1	
	ENDIF 
ENDSCAN

lnid = RecuperarID('CsrUbicacion',Goapp.sucursal10)
INSERT INTO CsrUbicacion VALUES (lnid,'1','LOCAL COMERCIAL')
lnid = lnid + 1 
INSERT INTO CsrUbicacion VALUES (lnid,'2','CORRALON')

lnid = RecuperarID('CsrProducto',Goapp.sucursal10)
lniddeta = RecuperarID('CsrProductoDeta',Goapp.sucursal10)
*stop()

SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	*SELECT CsrProducto
	IF DELETED()
		SELECT CsrArticulo
		LOOP 
	ENDIF 
	IF CsrArticulo.borrado
		LOOP 
	ENDIF 
	
	SELECT CsrProducto
	LOCATE FOR numero=VAL(CsrArticulo.numero )
	IF numero=VAL(CsrArticulo.numero)
		SELECT CsrArticulo
		LOOP 
	ENDIF
	
	STORE 0 TO   ncodigo , nidctacte , nidmarca , nidforma , nidunidad , nidtprod , nidtipovta; 
           , nidtamano , nidcatego , nidrubro , nidestado , nidubicacio , nidorigen ;
           , nincluirped , nidmoneda , nidiva , nunibulto , nnofactura , nnolista , nespromocion ;
           , nminimofac , npeso , nvolumen , nfracciona , npuntope, ndivisible ,nnomodifica  ;
           , nctaaorden, nesinsumo , nidfamilia , nidcategotipo, ncotidolar , nendolar ,nredondeo 
    STORE "" TO  cnombre , ccodalfa , ccontrolador , cnommayorista , ccodalfaprov , ccodbarra14;
           , ccodbarra13 
    STORE DATE() TO  dfeculcpra , dfeculvta , dfecalta , dfecmodi , dfeculpre
           
	cnombre		= NombreNi(alltrim(CsrArticulo.nombre))
	ncodigo		= VAL(Csrarticulo.NUMERO)
	IF nCodigo = 40
		stop()
	ENDIF 
	ccodalfaprov	= ALLTRIM(CsrArticulo.codigo_fac)
	ccodalfa = ALLTRIM(CsrArticulo.codigo_pro)
	
	cnommayorista	= cnombre
	ccontrolador	= cnombre
	*Almacenamos el codigo anterior para luego importar las secciones con productos
    nidrubro	= Csrarticulo.seccion
    
    nidUbicacio = CargarUbicacion(nidRubro)
    
    lcMarca 	= CsrArticulo.marca
    lcMarca		= TablaMarcas(lcMarca)
    
    SELECT CsrMarca
    LOCATE FOR nombre=lcMarca
    IF NOT FOUND()
	   	GO TOP 
	ENDIF 
   	nidmarca = CsrMarca.id
    
*!*		SELECT CsrUbicacion
*!*		GO TOP 
*!*		nidubicacio = CsrUbicacion.id
	
   	nidestado 	= IIF(empty(Csrarticulo.debaja),1,2)
    nidiva    	= VAL(STR(goapp.sucursal10+10)+strzero(IIF(Csrarticulo.tablaiva=1,2,3),8))
    nidtipovta	= 1 &&UNIDADES=1 ,	BULTOS = 2.
    nidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
    nredondeo	= CsrArticulo.redondeo
	cswitch		= "00000"

	IF NOT EMPTY(Csrarticulo.fechapre)   
		dfecmodi = DATETIME(YEAR(Csrarticulo.fechapre),MONTH(Csrarticulo.fechapre),DAY(Csrarticulo.fechapre),0,0,0)
	ENDIF 		
									
	
	INSERT INTO  csrproducto  ( id , numero  , nombre  , codalfa , idctacte , idmarca ;
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

