PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
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
llok = CargarTabla(lcData,'Variedad')
llok = CargarTabla(lcData,'TipoFrio')
llok = CargarTabla(lcData,'Rubro')
llok = CargarTabla(lcData,'Marca')
llok = CargarTabla(lcData,'Familia')
llok = CargarTabla(lcData,'CategoTipo')
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Forma')
llok = CargarTabla(lcData,'AreaNeg')
llok = CargarTabla(lcData,'Ctacte')
&&Limpiamos porque se regenera todo
llok = CargarTabla(lcData,'AreaNegRubro',.t.)
llok = CargarTabla(lcData,'AfeCateProd',.t.)

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 


IF USED('CsrLista105')
	USE IN CsrLista
ENDIF 

CREATE CURSOR CsrLista (codigo c(8),deta c(63),estado c(1))
CREATE CURSOR CsrLista105 (codigo c(8))
		
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
APPEND FROM   ALLTRIM(lcpath )+"\productos.prn" SDF


SELECT CsrLista105
APPEND FROM   ALLTRIM(lcpath )+"\productos_105.prn" SDF
		
Oavisar.proceso('S','Abriendo archivos') 

Oavisar.proceso('S','Abriendo Parametros Generales') 

TEXT TO lccmd TEXTMERGE NOSHOW
SELECT CsrParaVario.* FROM ParaVario as CsrParaVARIO
where nombre like 'PROVEEDOR'
ENDTEXT 
IF !CrearCursorAdapter('CsrParametros',lccmd)
	MESSAGEBOX('Nose puede importar, pq no se cargo el ParaConfig')
	RETURN .f.
ENDIF

*vista()
SELECT CsrFuerzaVta
GO TOP 
SELECT CsrForma
GO TOP 

*!*	lnid = RecuperarID("CsrRubro",goapp.sucursal10)
*!*	Oavisar.proceso('S','Procesando RUBROS') 
*!*	SELECT CsrRubro
*!*	GO BOTTOM 
*!*	lnnumero = CsrRubro.numero + 1
*!*	lntipoprod 	= 0
*!*	lntipovta   = 1
*!*	lnretibruto = 0
*!*	lnidfrzvta  = CsrFuerzaVta.id
*!*	lnolista 	= 0
*!*	lnporcecomi = 0
*!*	lnporcedev 	= 0
*!*	lnporcesuge = 0
*!*	lntasavied 	= 0
*!*	lntasapata 	= 0
*!*	lcnombre	= "FERRETERIA"
*!*	lcCadena	= ArmarAbrevia(lcNombre,'CsrRubro',2)
*!*	lcSwitch = lcCadena+'000'
*!*	    
*!*	 INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
*!*	 ,porcecomi,porcesuge,porcedev,tasavied,tasapata,switch) ;
*!*	 VALUES (lnid,lnnumero,lcnombre,lntipoprod,lntipovta,0,lnidfrzvta,lnolista,0,0,0,0,0,lcSwitch)
lnidRubro = 1100000008 &&lnid 
*!*	 
*!*	lnid = RecuperarID("CsrMarca",goapp.sucursal10)
*!*	Oavisar.proceso('S','Procesando MARCAS') 
*!*	SELECT CsrMarca
*!*	GO BOTTOM 
*!*	lnnumero 	= CsrMarca.numero + 1
*!*	lnflete		= 0
*!*	lnflete2	= 0
*!*	lnidfrzavta	= CsrFuerzaVta.id
*!*	lcnombre	= "FERRETERIA"
*!*	lcCadena	= ArmarAbrevia(lcNombre,'CsrMarca',2)
*!*	lcSwitch 	= lcCadena+'000'  	   
*!*	INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta,switch);
*!*	VALUES (lnid,lnnumero,lcnombre,lnflete,lnflete2,lnidfrzavta,lcSwitch)
lnidmarca = 1100000003 &&lnid

*!*	lnid = RecuperarID("CsrFamilia",goapp.sucursal10)
*!*	Oavisar.proceso('S','Procesando FAMILIAS') 
*!*	SELECT CsrFamilia
*!*	GO BOTTOM 
*!*	lnnumero 	= CsrFamilia.numero+1
*!*	lcnombre	= "FERRETERIA"
*!*	lcCadena	= LEFT(lcNombre,1) &&ArmarAbrevia(lcNombre,'CsrFamilia',1)
*!*	lcSwitch 	= lcCadena+'0000'  	   
*!*	INSERT INTO CsrFamilia(id,numero,nombre,switch);
*!*	VALUES (lnid,lnnumero,lcnombre,lcSwitch)
lnidFamilia = 1100000003 &&lnid

SELECT CsrCategoTipo
GO TOP 
lnnumTipo 	= CsrCategoTipo.numero
lnidCategotipo = CsrCategoTipo.id

lnid = ObtenerID("Producto")


SELECT CsrProducto
GO BOTTOM 
lnnumero = 5000

SELECT CsrLista
Oavisar.proceso('S','Procesando PRODUCTOS') 
GO top
nValor = lnNumero
SCAN
	IF LEN(LTRIM(CsrLista.deta))=0
		LOOP 
	ENDIF 
	
	STORE 0 TO 	lnidctavta,lnidctacpra,lnnomodifica,lnminimofac,lnvolumen,lnidenvase;
	,lnctaaorden,lncprakilos,lnsiinforma,lnesinsumo,lnpeso,lnpuntope,lnendolar;
	,lnsubsidiado,lnidingbrutoslp,lnfracciona,lnnolista,lnnofactura,lnespromocion,lnvtakilos,lndivisible;
	,lnimportado,lnidctacte,lnidFrio,lnSiReparto,lnppt,lnitc;
	
	*store 0 TO lnidmarca,lnidrubro,lnidfamilia,lnidcategotipo
	
	STORE 0 TO lncosto,lnflete,lnsegflete,lncostobon,lncostorepo,lncostoulcpra;
	,lnmargen4,lnprevta4,lnprevtaf4,lnmargen1,lnprevta1,lnprevtaf1,lnmargen2,lnprevta2,lnprevtaf2;
	,lnmargen3,lnprevta3,lnprevtaf3,lndesc1,lndesc2,lndesc3;
	,lnmin1,lnmin2,lnmin3,lninternoporce,lninterno,lnsugerido;
	,lnbonif1,lnbonif2,lnbonif3,lnbonif4,lncotidolar;
	
	*lnidctacte = TablaProveedores('FERRETERIA')
	*lnidctacte = IIF(lnidctacte=0,CsrParametros.idorigen,lnidctacte)
	
	lcctacte = TablaProveedores("FERRETERIA")
	SELECT CsrCtacte
	LOCATE FOR cnombre=lcCtacte AND ctaacreedor = 1
	IF cnombre=lcCtacte AND ctaacreedor = 1
		lnidctacte = CsrCtacte.id
	ENDIF 
	lnidctacte = IIF(lnidctacte=0,CsrParametros.idorigen,lnidctacte)
	
	
	lcCodAlfa = ""

	SELECT CsrMarca
    LOCATE FOR id = lnidmarca
    lcCodAlfa = lcCodalfa + LEFT(CsrMarca.switch,2)    
        
    SELECT CsrRubro
    LOCATE FOR id = lnidrubro
   	lcCodAlfa = lcCodalfa + LEFT(CsrRubro.switch,2) 
    
	SELECT CsrFamilia
    LOCATE FOR id = lnidfamilia
    lcCodAlfa = lcCodalfa + LEFT(CsrFamilia.switch,1)    
        
    lnNumCodAlfa = 1

	*Tenemos que tomar de lo grabado el maximo por categoria.
	*Para determinar que categoria esta libre
    SELECT idcategotipo,CAST(MAX(RIGHT(codalfa,3))as i) as numero FROM CsrProducto;
    WHERE idmarca = CsrMarca.id AND idrubro = CsrRubro.id AND idfamilia = CsrFamilia.id;
    GROUP  BY idcategotipo INTO CURSOR CsrMaxCodAlfa READWRITE 
    SELECT CsrMaxCodAlfa
    
    lbEncontrado = .f.
    lnidCategotipo = 0
    IF RECCOUNT('CsrMaxCodAlfa')#0
    	SELECT CsrMaxCodAlfa
    	GO TOP 
    	DO WHILE !EOF() AND NOT lbEncontrado
    		lnidCategotipo = CsrMaxCodAlfa.idcategotipo
	    	lnNumCodAlfa = CsrMaxCodAlfa.numero + 1 
	    	IF lnNumCodAlfa > 999
	    		SKIP 
	    		LOOP 
	    	ENDIF 
	    	SELECT CsrCategotipo
    		LOCATE FOR id = lnidCategotipo
    		lcCodAlfa = lcCodalfa + LEFT(CsrCategoTipo.switch,1)  
    		lbEncontrado = .t.
    	ENDDO 
    ENDIF 
	*Si no lo encontre. Buscamos si hay otra categoria mayor a la ultima asignada
	*Si no existe otra. La creamos
	IF NOT lbEncontrado
	 	SELECT CsrCategoTipo
	 	LOCATE FOR id > lnidCategotipo
	 	IF id <=lnidCategotipo
			lnidTipo = RecuperarID("CsrCategoTipo",goapp.sucursal10)
			lnnumTipo 	= lnnumTipo + 1
			lcnombre	= "GRAL FERRETERIA "+strtrim(lnNumTipo)
			lcCadena	= ArmarAbrevia(lcNombre,'CsrCategoTipo',1)
			lcSwitch 	= lcCadena+'0000'  	   
			INSERT INTO CsrCategoTipo(id,numero,nombre,switch);
			VALUES (lnidTipo,lnnumTipo,lcnombre,lcSwitch)
			
		ENDIF 
		*El numero comienza siempre en 1. Porque no hay ningun producto (marca+rubro+familia+tipo) guardado
		lnNumCodAlfa = 1
		lnidCategotipo = CsrCategotipo.id
		lcCodAlfa = lcCodalfa + LEFT(CsrCategoTipo.switch,1)  
	ENDIF 

    lcCodAlfa = LEFT(lcCodalfa + strzero(lnNumCodAlfa,3),9)
    
    lnnumero 	 = lnnumero + 1
      
    lcCodAlfaProv 	= "FER"+ALLTRIM(CsrLista.codigo)
	lnidforma 		= 1100000001

    lnidestado 		= 1
    lnidiva        	= 1100000002
    
    SELECT CsrLista105
    LOCATE FOR ALLTRIM(codigo)=ALLTRIM(CsrLista.codigo)
    IF ALLTRIM(codigo)=ALLTRIM(CsrLista.codigo)
    	lnidiva = 1100000003
    ENDIF 
    
    lnidtipovta 	= 1 &&IIF(FsrArticulo.quefactura="B",2,1)
	ldfecha			= CTOD('01-01-1900')
	ldfeculcpra		= ldfecha
	ldfecmodi		= ldfecha
	ldfecoferta		= ldfecha

	lnidunidad 		= 1100000001
	lnidtprod		= 1100000001
	lnidtamano		= 1100000001
	lnidcatego		= 1100000001
	lnidubicacio	= 1100000001
	lnidorigen		= 1100000001
	lnidingbrutos	= 1100000001
	lnidmoneda		= 1100000001
	
	lcnombre 		= CsrLista.deta
	lccontrolador	= LEFT(NombreNi(alltrim(lcnombre)),19)
	lcnommayorista	= lcnombre
	
	lcnombulto 	 = ''
	lnnofactura	 = VAL(CsrLista.estado)
	*lccodalfa	 = LTRIM(STR(lnNumero))
	
	lnincluirped = 1
	ldfeculvta   = ldfecha
	ldfecalta	 = ldfecha
	lnunibulto	 = 1
	lcswitch	 = "00000"
	lccodartprod = ""
	
	lnidenvase = 0
	
	lncosto	= 0
	 			
	INSERT INTO CsrProducto(id,numero,nombre,nombulto,codalfa,idctacte,idmarca;
	,idctavta,idctacpra,idforma,idunidad,idtprod,idtipovta,idtamano,idcatego,idrubro;
	,idestado,idubicacio,idorigen,nomodifica,incluirped,idiva,idmoneda,costo,flete;
	,segflete,interno,bonif1,bonif2,bonif3,bonif4,costobon,costorepo,costoulcpra,feculcpra;
	,margen1,prevta1,prevtaf1,margen2,prevta2,prevtaf2,margen3,prevta3,prevtaf3;
	,margen4,prevta4,prevtaf4,feculvta,fecalta,fecmodi,unibulto,nofactura,nolista;
	,espromocion,minimofac,peso,volumen,fracciona,puntope,switch,idenvase,sugerido;
	,idfrio,divisible,desc1,desc2,desc3,min1,min2,min3,codartprod,vtakilos,fecoferta;
	,internoporce,controlador,nommayorista,ppt,itc,subsidiado,ctaaorden,cprakilos;
	,siinforma,importado,esinsumo,endolar,cotidolar,idfamilia,idcategotipo,codalfaprov);
	VALUES	(lnid,lnnumero,lcnombre,lcnombulto,lccodalfa,lnidctacte,lnidmarca,lnidctavta,lnidctacpra;
	,lnidforma,lnidunidad,lnidtprod,lnidtipovta,lnidtamano,lnidcatego,lnidrubro,lnidestado,lnidubicacio;
	,lnidorigen,lnnomodifica,lnincluirped,lnidiva,lnidmoneda,lncosto,lnflete,lnsegflete,lninterno;
	,lnbonif1,lnbonif2,lnbonif3,lnbonif4,lncostobon,lncostorepo,lncostoulcpra,ldfeculcpra,lnmargen1;
	,lnprevta1,lnprevtaf1,lnmargen2,lnprevta2,lnprevtaf2,lnmargen3,lnprevta3,lnprevtaf3,lnmargen4;
	,lnprevta4,lnprevtaf4,ldfeculvta,ldfecalta,ldfecmodi,lnunibulto,lnnofactura,lnnolista,lnespromocion;
	,lnminimofac,lnpeso,lnvolumen,lnfracciona,lnpuntope,lcswitch,lnidenvase,lnsugerido,lnidfrio,lndivisible;
	,lndesc1,lndesc2,lndesc3,lnmin1,lnmin2,lnmin3,lccodartprod,lnvtakilos,ldfecoferta,lninternoporce;
	,lccontrolador,lcnommayorista,lnppt,lnitc,lnsubsidiado,lnctaaorden,lncprakilos,lnsiinforma,lnimportado;
	,lnesinsumo,lnendolar,lncotidolar,lnidfamilia,lnidcategotipo,lcCodAlfaProv)

	lnid = lnid + 1

	SELECT CsrLista  				
ENDSCAN


SELECT distinct idmarca as idpadre,idrubro as idhijo,'MR' as clave FROM CsrProducto;
where idmarca<>0 and idrubro<>0;
union ALL ;
SELECT distinct  idrubro as idpadre,idfamilia as idhijo,'RF' as clave FROM CsrProducto;
where idrubro<>0 and idfamilia<>0;
union ALL ;
SELECT distinct idfamilia as idpadre,idcategotipo as idhijo,'FT' as clave FROM CsrProducto;
where idfamilia<>0 and idcategotipo<>0;
into CURSOR FsrAfectacion

lnid = RecuperarID("CsrAfeCateProd",goapp.sucursal10)
SELECT FsrAfectacion
GO top
SCAN 
	lnidpadre	= FsrAfectacion.idpadre
	lnidhijo 	= FsrAfectacion.idhijo
	lcclave		= FsrAfectacion.clave
	lcSwitch	= '00000'
	lnestado	= 0
	SELECT CsrAfeCateProd
	LOCATE FOR idpadre = lnidpadre AND idhijo = lnidhijo AND clave = lcclave
	IF !(idpadre = lnidpadre AND idhijo = lnidhijo AND clave = lcclave)
		INSERT INTO CsrAfeCateProd (id,idpadre,idhijo,switch,estado,clave);
		VALUES (lnid,lnidpadre,lnidhijo,lcswitch,lnestado,lcclave)
		lnid = lnid + 1
	ENDIF 
	SELECT FsrAfectacion
ENDSCAN 

USE IN FsrAfectacion

***Area de negocios
SELECT CsrAreaNeg
GO TOP 

lnid = RecuperarID("CsrAreaNegRubro",goapp.sucursal10)
SELECT CsrRubro
GO TOP 
SCAN 
	SELECT CsrAreaNeg
	GO TOP 
	DO WHILE NOT EOF('CsrAreaNeg')
		INSERT INTO CsrAreaNegRubro(id,idrubro,idarea,estado) VALUES (lnid,CsrRubro.id,CsrAreaNeg.id,0)	
		lnid = lnid + 1 
		SKIP IN CsrAreaNeg
	ENDDO 
	SELECT CsrRubro
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

	
USE IN CsrLista
USE IN CsrLista105
 

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES