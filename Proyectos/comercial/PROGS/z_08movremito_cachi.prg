PARAMETERS ldvacio,lcpath,lcBase,lnlimite
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lnlimite = IIF(PCOUNT()<4,0,lnlimite)
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
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'Maopera',.t.)
llok = CargarTabla(lcData,'MovRemito',.t.)
llok = CargarTabla(lcData,'Vendedor')


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT TOP 1 CsrRubro.*,CsrProducto.id as idarticulo FROM Rubro as CsrRubro 
inner join Producto as CsrProducto on CsrRubro.id = CsrProducto.idrubro
WHERE CsrRubro.numero=226
ENDTEXT 
IF NOT CrearCursorAdapter('CsrRubro',lccmd)
	RETURN .f.
ENDIF

IF RECCOUNT('CsrRubro')=0
	oavisar.usuario('Importacion cancelada, no hay rubro con edicion de articulos')
	RETURN .f.
ENDIF 
*vista()

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

SET SAFETY ON
Oavisar.proceso('S','Abriendo archivos') 


USE  ALLTRIM(lcpath )+"\remitos" in 0 alias FsrMovimien EXCLUSIVE	

Oavisar.proceso('S','Procesando '+alias()) 

SELECT FsrMovimien.* FROM FsrMovimien WHERE saldocan > 0 AND NOT DELETED() ORDER BY cliente,fecha INTO CURSOR CsrMovimien READWRITE 

LOCAL lnid,lnidmaopera

*stop()

lnidproducto = RecuperarID('CsrProducto',Goapp.sucursal10) + 1
nidmaopera	 = RecuperarID('CsrMaopera',Goapp.sucursal10)
nid	 = RecuperarID('CsrMovRemito',Goapp.sucursal10)

lHayEdicion = .f.
IF RECCOUNT('CsrRubro')#0
	IF NVL(CsrRubro.idarticulo,0)<>0
		lHayEdicion = .t.
	ENDIF 
ENDIF 

nDecimalesP = 3

corigen		= "FAC"
cprograma	= "IMPORTACION"
nsucursal	= goapp.sucursal
nterminal	= goapp.terminal
nsector		= 1 &&goapp.sector
dfechasis	= FechaHoraCero(DATEtime())
nidoperador	= goapp.idusuario
nidvendedor	= 0
niddetanrocaja	= 0
nidcomproba	= 0
cclasecomp	= ''
nturno		= 0
npuestocaja	= 0
nidcotizadolar	= 0
cswitch		= "00000"
cestado		= '0'
cdetalle	= ""
dfechaserver = DATETIME()

*stop()
        
SELECT CsrMovimien
Oavisar.proceso('S','Procesando '+alias()) 
GO top
i = 0
DO WHILE NOT EOF() &&AND i <= lnlimite
	SELECT CsrMovimien
*!*		IF CsrMovimien.cliente<>1000
*!*			SKIP 
*!*			LOOP
*!*		ENDIF 
*!*		IF nid = 110000000015
*!*			stop()
*!*		ENDIF 
	
	SELECT CsrCtacte
	LOCATE FOR VAL(cnumero) = CsrMovimien.cliente
	IF VAL(cnumero) <> CsrMovimien.cliente
		LOOP 
	ENDIF 
	
	nidvendemov  = 	nidvendedor
	
	SELECT CsrVendedor
	LOCATE FOR ALLTRIM(nombre) = ALLTRIM(CsrMovimien.quien)
	IF 	ALLTRIM(nombre) = ALLTRIM(CsrMovimien.quien)
		nidvendemov = CsrVendedor.id
	ENDIF 

	i = i + 1 
	cNumComp	= "X000100000001"
	
	INSERT INTO Csrmaopera (id,origen,programa,sucursal,terminal,sector,fechasis,idoperador,idvendedor,iddetanrocaja,idcomproba   ;        
           ,numcomp,clasecomp,turno,puestocaja,idcotizadolar,switch,estado,detalle,fechaserver);
    VALUES (nidmaopera,corigen,cprograma,nsucursal,nterminal,nsector,dfechasis,nidoperador,nidvendemov,niddetanrocaja,nidcomproba    ;       
           ,cnumcomp,cclasecomp,nturno,npuestocaja,nidcotizadolar,cswitch,cestado,cdetalle,dfechaserver)
           
	
	nidctacte	= CsrCtacte.id
	dFechaMov	= CsrMovimien.fecha
	SELECT CsrMovimien
	DO WHILE NOT EOF() AND VAL(Csrctacte.cnumero) = CsrMovimien.cliente AND dFechaMov = CsrMovimien.fecha
	
		SELECT CsrProducto
		LOCATE FOR CsrProducto.numero = VAL(CsrMovimien.articulo )
		IF CsrProducto.numero <> VAL(CsrMovimien.articulo )
			*stop()
			IF lHayEdicion
				nidarticulo = CsrRubro.idarticulo
			ELSE 
				 lHayEdicion = .t.
				&&Insertar producto con detalle
				SELECT CsrProducto
				GO BOTTOM 
				
				STORE 0 TO   ncodigo , nidctacte , nidmarca , nidforma , nidunidad , nidtprod , nidtipovta; 
	           , nidtamano , nidcatego , nidrubro , nidestado , nidubicacio , nidorigen ;
	           , nincluirped , nidmoneda , nidiva , nunibulto , nnofactura , nnolista , nespromocion ;
	           , nminimofac , npeso , nvolumen , nfracciona , npuntope, ndivisible ,nnomodifica  ;
	           , nctaaorden, nesinsumo , nidfamilia , nidcategotipo, ncotidolar , nendolar ,nredondeo 
			    STORE "" TO  cnombre , ccodalfa , ccontrolador , cnommayorista , ccodalfaprov , ccodbarra14;
			           , ccodbarra13 
			    STORE DATE() TO  dfeculcpra , dfeculvta , dfecalta , dfecmodi , dfeculpre
	    
				cnombre		= "�"+ALLTRIM(CsrMovimien.articulo)+"� "+CsrMovimien.nombre
				ncodigo		= CsrProducto.numero + 1
				
				cnommayorista	= cnombre
				ccontrolador	= cnombre
				
				nidrubro	= CsrRubro.id
				nidtipovta	= 1 &&UNIDADES=1 ,	BULTOS = 2.
	    		nidforma 	= VAL(STR(goapp.sucursal10+10)+strzero(1,8))  &&SIN CLASIFICAR
	    		cswitch		= "00000"
	    		
				INSERT INTO  producto  ( id , numero  , nombre  , codalfa , idctacte , idmarca ;
		           , idforma , idunidad , idtprod , idtipovta ;
		           , idtamano , idcatego , idrubro , idestado , idubicacio , idorigen ;
		           , nomodifica , incluirped , idmoneda , idiva , feculcpra , feculvta ;
		           , fecalta , fecmodi , unibulto , nofactura , nolista , espromocion ;
		           , minimofac , peso , volumen , fracciona , puntope, switch , divisible ;
		           , controlador , nommayorista , ctaaorden, esinsumo , idfamilia ;
		           , idcategotipo, codalfaprov , cotidolar , endolar , codbarra14;
		           , codbarra13 , feculpre ) ;
			     VALUES  ( lnidproducto , ncodigo , cnombre , ccodalfa , nidctacte , nidmarca ;
			           , nidforma , nidunidad , nidtprod , nidtipovta ;
			           , nidtamano , nidcatego , nidrubro , nidestado , nidubicacio , nidorigen ;
			           , nnomodifica , nincluirped , nidmoneda , nidiva , dfeculcpra , dfeculvta ;
			           , dfecalta , dfecmodi , nunibulto , nnofactura , nnolista , nespromocion ;
			           , nminimofac , npeso , nvolumen , nfracciona , npuntope, cswitch , ndivisible ;
			           , ccontrolador , cnommayorista , nctaaorden, nesinsumo , nidfamilia ;
			           , nidcategotipo, ccodalfaprov , ncotidolar , nendolar , ccodbarra14 ;
			           , ccodbarra13 , dfeculpre) 
				nidarticulo = lnidproducto
				lnidproducto = lnidproducto + 1 
			ENDIF 
	    ELSE
	    	nidarticulo = CsrProducto.id
		ENDIF
		
		cNombre		= CsrMovimien.nombre
		nPreunita	= CsrMovimien.importe
		nPreunitaSiva	= 0
		dFecha		= CsrMovimien.fecha
		nCantidad	= CsrMovimien.cantidad
		nSdoCant	= CsrMovimien.saldocan
		nInternos	= CsrMovimien.internos
		nTotal		= CsrMovimien.total
		nlistaprecio	= 1
		niddeposito	= 1100000002
		nDespor		= 0
		nActivo		= 1
		
*!*			SELECT CsrVendedor
*!*			LOCATE FOR nombre = CsrMovimien.quien
*!*			nidvendedor	= CsrVendedor.id
*!*			
		INSERT INTO csrmovremito (id,idmaopera,idctacte,idarticulo,nombre,preunita,preunitasiva,fecha,cantidad;
           ,total,listaprecio,iddeposito,internos,sdocant,despor,activo,codartimp);
     	VALUES (nid,nidmaopera,nidctacte,nidarticulo,cnombre,npreunita,npreunitasiva,dfecha,ncantidad;
           ,ntotal,nlistaprecio,niddeposito,ninternos,nsdocant,ndespor,nactivo,VAL(CsrMovimien.articulo ))
		
		nid = nid + 1 
		SELECT CsrMovimien
		SKIP 
	ENDDO 
	
	SELECT CsrMovimien
*!*		&&Si salio pq cambio de cliente, no muevo
*!*		IF NOT EOF() AND VAL(Csrctacte.cnumero) <> CsrMovimien.cliente
*!*			SKIP -1
*!*		ENDIF 
	nidmaopera = nidmaopera + 1 
ENDDO 

SELECT CsrMaopera
vista()

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE IN  CsrMovimien 
USE in FsrMovimien


