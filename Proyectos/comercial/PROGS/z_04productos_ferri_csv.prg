PARAMETERS ldvacio,lcpath,lcBase,lnlimite

ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE 
SET PROCEDURE TO z00_ferrimac ADDITIVE 

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Producto',.t.)
llok = CargarTabla(lcData,'ProductoDeta',.t.)
llok = CargarTabla(lcData,'Variedad',.t.)
llok = CargarTabla(lcData,'Rubro',.t.)
llok = CargarTabla(lcData,'Marca',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Ubicacion',.t.)
llok = CargarTabla(lcData,'Familia')
llok = CargarTabla(lcData,'CategoTipo')
SET SAFETY ON

=InitCursores()

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


cArchivo = ADDBS(ALLTRIM(lcpath ))+"productosExp.csv"
=LeerArticulos(cArchivo)
SELECT CsrArticulo
vista()


RETURN .f.
Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid
*****
SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta = CsrFuerzavta.id

lnid = RecuperarID('CsrMarca',Goapp.sucursal10)

SELECT distinct CodMarca,UPPER(marca) as nombre FROM CsrArticulo ORDER BY VAL(codmarca) INTO CURSOR FsrMarca READWRITE 
SELECT distinct CodRubro,UPPER(rubro) as nombre FROM CsrArticulo ORDER BY VAL(codrubro) INTO CURSOR FsrRubro READWRITE 


SELECT FsrMarca 
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	SCATTER NAME Oscatter
  	lcnombre	= NombreNi(ALLTRIM(UPPER(Oscatter.nombre)))
	
	SELECT CsrMarca
	LOCATE FOR nombre = lcnombre
	IF NOT FOUND() 
	   	INSERT INTO Csrmarca (id,numero,nombre,idfuerzavta);
	   	VALUES (lnid,VAL(CodMarca),lcnombre,lnidfuerzavta)
	   	
	   	lnid = lnid + 1	
	ENDIF 
ENDSCAN

SELECT FsrRubro
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	SCATTER NAME Oscatter
  	lcnombre	= NombreNi(ALLTRIM(UPPER(Oscatter.nombre)))
	
	SELECT CsrRubro
	LOCATE FOR nombre = lcnombre
	IF NOT FOUND() 
	   	INSERT INTO CsrRubro (id,numero,nombre);
	   	VALUES (lnid,VAL(CodRubro),lcnombre)
	   	
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
lnCodigo = 1
SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
	*SELECT CsrProducto
	IF DELETED()
		SELECT CsrArticulo
		LOOP 
	ENDIF 

	
	SELECT CsrProducto
	LOCATE FOR ALLTRIM(codalfa)=alltrim(CsrArticulo.codigo )
	IF ALLTRIM(codalfa)=alltrim(CsrArticulo.codigo )
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
	ncodigo		= lnCodigo 
	IF nCodigo = 40
		*stop()
	ENDIF 
	ccodalfaprov	= ALLTRIM(CsrArticulo.CodArtProveed)
	ccodalfa 		= ALLTRIM(CsrArticulo.codigo)
	
	cnommayorista	= cnombre
	ccontrolador	= cnombre
	*Almacenamos el codigo anterior para luego importar las secciones con productos
	SELECT CsrRubro
	LOCATE FOR numero = VAL(CsrArticulo.CodRubro)
	nidrubro	= CsrRubro.id
	
    SELECT CsrMarca
	LOCATE FOR numero = VAL(CsrArticulo.CodMarca)
	nidmarca	= CsrMarca.id	
	
    SELECT CsrUbicacion
    GO TOP 
    nidUbicacio = CsrUbicacion.id
    
    SELECT CsrFamilia
    GO TOP 
    nidfamilia = CsrFamilia.id
    
    SELECT CsrCategotipo
    GO TOP 
    idcategotipo = CsrCategotipo.id
    
	
   	nidestado 	= 1
   	
   	SELECT CsrTipoIva
   	DO CASE 
   	CASE VAL(CodAlicuota) = 0
   		LOCATE FOR tasa = 0
   	CASE VAL(CodAlicuota) = 1
   		LOCATE FOR tasa = 21   	
   	CASE VAL(CodAlicuota) = 2
   		LOCATE FOR tasa = 10.5   	
   	CASE VAL(CodAlicuota) = 3
   		LOCATE FOR tasa = 27
   	ENDCASE 
   	nidiva = CsrTipoIva.id
    nidtipovta	= 1 &&UNIDADES=1 ,	BULTOS = 2.
    nidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
    nredondeo	= 0
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

