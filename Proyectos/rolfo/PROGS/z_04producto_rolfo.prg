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
llok = CargarTabla(lcData,'Variedad',.t.)
llok = CargarTabla(lcData,'TipoFrio',.t.)
llok = CargarTabla(lcData,'Rubro',.t.)
llok = CargarTabla(lcData,'Marca',.t.)
llok = CargarTabla(lcData,'Familia',.t.)
llok = CargarTabla(lcData,'CategoTipo',.t.)
llok = CargarTabla(lcData,'SubProducto',.t.)
llok = CargarTabla(lcData,'BloqueoProd',.t.)
llok = CargarTabla(lcData,'GamaBase',.t.)
llok = CargarTabla(lcData,'Deposito',.t.)
llok = CargarTabla(lcData,'Ubicacion',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'Forma')
llok = CargarTabla(lcData,'AfeCateProd',.t.)
llok = CargarTabla(lcData,'ProductoDeta',.t.)
llok = CargarTabla(lcData,'AreaNeg',.t.)
llok = CargarTabla(lcData,'AreaNegRubro',.t.)
llok = CargarTabla(lcData,'Ctacte')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('FsrArticulo')
	USE IN FsrArticulo
ENDIF 

USE  ALLTRIM(lcpath )+"\articulo" in 0 alias FsrArticulos EXCLUSIVE	
		
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

SELECT FsrArticulos.* FROM FsrArticulos ORDER BY codigo INTO CURSOR FsrArticulo READWRITE 

*vista()
SELECT CsrFuerzaVta
GO TOP 
SELECT CsrForma
GO TOP 

lnid = RecuperarID("CsrRubro",goapp.sucursal10)
SELECT distinct rubro as numero FROM FsrArticulo WHERE rubro#0 INTO CURSOR FsrSeccion
SELECT FsrSeccion
Oavisar.proceso('S','Procesando RUBROS') 
GO top

lnnumero = 0
SCAN FOR !EOF()
    lnnumero	= FsrSeccion.numero
    lntipoprod 	= 0
    lntipovta   = 1
    lnretibruto = 0
    lnidfrzvta  = CsrFuerzaVta.id
    lnolista 	= 0
    lnporcecomi = 0
    lnporcedev 	= 0
    lnporcesuge = 0
    lntasavied 	= 0
    lntasapata 	= 0
	lcnombre	= STRTRAN(NaLetra(lnnumero,0),"-","")
	lcCadena	= ArmarAbrevia(lcNombre,'CsrRubro',2)
    lcSwitch = lcCadena+'000'
    
    INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
    ,porcecomi,porcesuge,porcedev,tasavied,tasapata,switch) ;
    VALUES (lnid,lnnumero,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfrzvta,lnolista;
    ,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata,lcSwitch)
    lnid = lnid + 1

ENDSCAN

lnid = RecuperarID("CsrMarca",goapp.sucursal10)
Oavisar.proceso('S','Procesando MARCAS') 
lnnumero = 1
lnflete		= 0
lnflete2	= 0
lnidfrzavta	= CsrFuerzaVta.id
lcnombre	= "GENERAL"
lcCadena	= ArmarAbrevia(lcNombre,'CsrMarca',2)
lcSwitch 	= lcCadena+'000'  	   
INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta,switch);
VALUES (lnid,lnnumero,"GENERAL",lnflete,lnflete2,lnidfrzavta,lcSwitch)
  

lnid = RecuperarID("CsrFamilia",goapp.sucursal10)
Oavisar.proceso('S','Procesando FAMILIAS') 
lnnumero 	= 1
lcnombre	= "GENERAL"
lcCadena	= LEFT(lcNombre,1) &&ArmarAbrevia(lcNombre,'CsrFamilia',1)
lcSwitch 	= lcCadena+'0000'  	   
INSERT INTO CsrFamilia(id,numero,nombre,switch);
VALUES (lnid,lnnumero,lcnombre,lcSwitch)


lnid = RecuperarID("CsrCategoTipo",goapp.sucursal10)
Oavisar.proceso('S','Procesando TIPOS') 
lnnumTipo 	= 1
lcnombre	= "GENERAL"
lcCadena	= LEFT(lcNombre,1)&&ArmarAbrevia(lcNombre,'CsrCategoTipo',1)
lcSwitch 	= lcCadena+'0000'  	   
INSERT INTO CsrCategoTipo(id,numero,nombre,switch);
VALUES (lnid,lnnumero,lcnombre,lcSwitch)
lnidCategotipo = lnid

lnid = RecuperarID("CsrProducto",goapp.sucursal10)
lnidproddeta = RecuperarID("CsrProductoDeta",goapp.sucursal10)


SELECT FsrArticulo
Oavisar.proceso('S','Procesando PRODUCTOS') 
GO top
lnnumero = 0
nValor = 0
SCAN
	IF LEN(LTRIM(FsrArticulo.descrip))=0
		LOOP 
	ENDIF 
	
	STORE 0 TO 	lnidctavta,lnidctacpra,lnnomodifica,lnminimofac,lnvolumen,lnidenvase;
	,lnctaaorden,lncprakilos,lnsiinforma,lnesinsumo,lnpeso,lnpuntope,lnendolar;
	,lnsubsidiado,lnidingbrutoslp,lnfracciona,lnnolista,lnnofactura,lnespromocion,lnvtakilos,lndivisible;
	,lnimportado,lnidmarca,lnidctacte,lnidRubro,lnidFrio,lnSiReparto,lnppt,lnitc;
	,lnidfamilia;
	
	
	STORE 0 TO lncosto,lnflete,lnsegflete,lncostobon,lncostorepo,lncostoulcpra;
	,lnmargen4,lnprevta4,lnprevtaf4,lnmargen1,lnprevta1,lnprevtaf1,lnmargen2,lnprevta2,lnprevtaf2;
	,lnmargen3,lnprevta3,lnprevtaf3,lndesc1,lndesc2,lndesc3;
	,lnmin1,lnmin2,lnmin3,lninternoporce,lninterno,lnsugerido;
	,lnbonif1,lnbonif2,lnbonif3,lnbonif4,lncotidolar;
	
	
	lcctacte = TablaProveedores(FsrArticulo.codigo)
	SELECT CsrCtacte
	LOCATE FOR cnombre=lcCtacte AND ctaacreedor = 1
	IF cnombre=lcCtacte AND ctaacreedor = 1
		lnidctacte = CsrCtacte.id
	ENDIF 
	lnidctacte = IIF(lnidctacte=0,CsrParametros.idorigen,lnidctacte)
	
	lcCodAlfa = ""

	SELECT CsrMarca
    GO TOP 
    lnidmarca = CsrMarca.id
    lcCodAlfa = lcCodalfa + LEFT(CsrMarca.switch,2)    
        
    SELECT CsrRubro
    LOCATE FOR numero = Fsrarticulo.rubro
    IF FOUND()
        lnidrubro = CsrRubro.id
    	lcCodAlfa = lcCodalfa + LEFT(CsrRubro.switch,2) 
    ELSE
    	SELECT FsrArticulo
    	LOOP    
    ENDIF
    
	SELECT CsrFamilia
    GO TOP 
    lnidfamilia = CsrFamilia.id
    lcCodAlfa = lcCodalfa + LEFT(CsrFamilia.switch,1)    
        
    *SELECT CsrCategotipo
    *LOCATE FOR id = lnidCategotipo
    
    *lcSubCodAlfa = lcCodalfa + LEFT(CsrCategoTipo.switch,1)  

    lnNumCodAlfa = 1
	nValor = nValor + 1 
	IF nValor = 2858
		*stop()
	ENDIF 
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
			lcnombre	= "GENERAL "+strtrim(lnNumTipo)
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
    
    IF FsrArticulo.codigo ='ZZ9991212'
    	*()
    ENDIF 
    
    lnnumero 	 = lnnumero + 1
      
    lcCodAlfaProv 	= FsrArticulo.codigo
	lnidforma 		= 1100000001

    lnidestado 		= 1
    lnidiva        	= 1100000002
    lnidtipovta 	= 1 &&IIF(FsrArticulo.quefactura="B",2,1)
	ldfecha			= FsrArticulo.ultentfech
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
	
	lcnombre 		= FsrArticulo.descrip&&NombreNi(ALLTRIM(FsrArticulo.Marca)+' '+ALLTRIM(FsrArticulo.Rubro)+' '+alltrim(FsrArticulo.articulo))
	lccontrolador	= LEFT(NombreNi(alltrim(lcnombre)),19)
	lcnommayorista	= lcnombre
	
	lcnombulto 	 = ''
	
	*lccodalfa	 = LTRIM(STR(lnNumero))
	
	lnincluirped = 1
	ldfeculvta   = ldfecha
	ldfecalta	 = ldfecha
	lnunibulto	 = 1
	lcswitch	 = "00000"
	lccodartprod = ""
	
	lnidenvase = 0
	
	lncosto	= FsrArticulo.costo
	IF lncosto != 0
		lnprevta1	= FsrArticulo.precio3
		*lnmargen1	= ROUND(lnprevta1*100/lncosto,2)-100
		lnmargen1	= 169
		lnprevtaf1	= ROUND(lnprevta1*(1+FsrArticulo.iva/100),2)
		
		*lnprevta2	= ROUND(FsrArticulo.precio1*(1+(FsrArticulo.descuento+35)/100),2)
		*lnmargen2	= ROUND(lnprevta2*100/lncosto,2)-100
		*lnprevtaf2	= ROUND(lnprevta2*(1+FsrArticulo.iva/100),2)
		*lnmargen1 = 169
		*lnprevta1 = ROUND(lncosto*lnmargen1/100,2)
		
		lnprevta2	= FsrArticulo.precio1
		*lnmargen2	= ROUND(lnprevta2*100/lncosto,2)-100
		lnmargen2	= 39.88
		lnprevtaf2	= ROUND(lnprevta2*(1+FsrArticulo.iva/100),2)
	ENDIF 
	 			
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
	
	lcDeta 		= ""&&FsrArticulo.descripcion
	lcSwitch 	= '00000'
	IF LEN(LTRIM(lcDeta))#0
		INSERT INTO CsrProductoDeta(id,idarticulo,descripcion,switch);
		VALUES (lnidproddeta,lnid,lcdeta,lcswitch)
		lnidproddeta = lnidproddeta + 1
	ENDIF 
	lcDeta 		= "" &&FsrArticulo.observac
	lcSwitch 	= '10000'
	IF LEN(LTRIM(lcDeta))#0
		INSERT INTO CsrProductoDeta(id,idarticulo,descripcion,switch);
		VALUES (lnidproddeta,lnid,lcdeta,lcswitch)
		lnidproddeta = lnidproddeta + 1
	ENDIF 
	lcDeta 		= ""&&FsrArticulo.email
	lcSwitch 	= '20000'
	IF LEN(LTRIM(lcDeta))#0
		INSERT INTO CsrProductoDeta(id,idarticulo,descripcion,switch);
		VALUES (lnidproddeta,lnid,lcdeta,lcswitch)
		lnidproddeta = lnidproddeta + 1
	ENDIF 
	lcDeta 		= FsrArticulo.observac
	lcSwitch 	= '30000'
	IF LEN(LTRIM(lcDeta))#0
		INSERT INTO CsrProductoDeta(id,idarticulo,descripcion,switch);
		VALUES (lnidproddeta,lnid,lcdeta,lcswitch)
		lnidproddeta = lnidproddeta + 1
	ENDIF 
	lnid = lnid + 1

	SELECT FsrArticulo   				
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


***Area de negocios
lnid = RecuperarID("CsrAreaNeg",goapp.sucursal10)
INSERT INTO AreaNeg (id,numero,nombre,molino) VALUES (lnid,1,'NEGOCIO',0)


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

	
USE IN FsrArticulos
USE IN FsrArticulo
 

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES