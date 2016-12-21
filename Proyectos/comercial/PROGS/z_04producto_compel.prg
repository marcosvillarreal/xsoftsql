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

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 
IF USED('FsrArticulo')
	USE IN FsrArticulo
ENDIF 

CREATE CURSOR FsrArticulo (fecha c(10),Rubro c(100),Familia c(100),tipo c(50);
	,Articulo c(100),Marca c(50),Descripcion M,observa c(100),comentario c(100),email c(100))

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250);
	,deta04 c(250),deta05 c(250),deta06 c(250),deta07 c(250))
		
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
APPEND FROM  "c:\lista.txt" SDF

lcDelimitador = "^"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)
replace ALL deta04 WITH STRTRAN(deta04,"	",lcDelimitador)
replace ALL deta05 WITH STRTRAN(deta05,"	",lcDelimitador)
replace ALL deta06 WITH STRTRAN(deta06,"	",lcDelimitador)
replace ALL deta07 WITH STRTRAN(deta07,"	",lcDelimitador)


SELECT CsrLista
GO TOP 
*vista()
lnPrimeraOcurrencia = 1
leiunarticulo = .f.
*stop()
SCAN 
	lnCantCampo = 12 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
*!*		*Recupero el Rubro
*!*		IF AT(lcDelimitador,deta01,1)=1 AND AT(lcDelimitador,deta01,2)<>2 AND LEN(LTRIM(SUBSTR(deta01,2,AT(lcDelimitador,deta01,2)-2)))#0
*!*			lninicio = 2
*!*			lnpos = AT(lcDelimitador,deta01,2)
*!*			lcRubro = LimpiarCadena(SUBSTR(deta01,lninicio,lnpos-lninicio))
*!*		ENDIF 
*!*		*Recupero la Familia
*!*		IF AT(lcDelimitador,deta01,1)=1 AND AT(lcDelimitador,deta01,2)<>2 AND LEN(LTRIM(SUBSTR(deta01,2,AT(lcDelimitador,deta01,2)-2)))=0
*!*			lninicio = AT(lcDelimitador,deta01,2) +1
*!*			lnpos = AT(lcDelimitador,deta01,3)
*!*			lcFamilia = LimpiarCadena(SUBSTR(deta01,lninicio,lnpos-lninicio))
*!*		ENDIF 
	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcRubro,lcFamilia,lcComentario,lcEmail
		STORE "" TO lcTipo,lcModelo,lcFecha,lcMarca,lmDescripcion,lcAcarreo,lcObservaciones
		j = 0
	ELSE
		IF !leiunarticulo
			LOOP 
		ENDIF 
	ENDIF 
	
	DO WHILE lnCamposLeidos<8
		i = 1
		DO WHILE i + j <= lnCantCampo &&Campos de CsrArti + 1
			lnpos = AT(lcDelimitador,&lcNomCampo,i)
			IF lnPos#0 &&No es fin de linea
				lccadena = ALLTRIM(lcAcarreo) + SUBSTR(&lcNomCampo,lnSiguienteOcurrencia,lnpos-(lnSiguienteOcurrencia))
				lcAcarreo = ""
			ELSE 
				lcAcarreo = ALLTRIM(lcAcarreo) + ALLTRIM(SUBSTR(&lcNomCampo,lnSiguienteOcurrencia))
				EXIT 
			ENDIF 
			lcfecha			= IIF(j + i=10,DTOC(CDateEngSpa(lcCadena)),lcFecha)
			lcTipo			= UPPER(LimpiarCadena(IIF(j + i=6,lcCadena,lcTipo)))
			lcModelo		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcModelo)))
			lcMarca			= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcMarca)))
			lmDescripcion 	= UPPER(LimpiarCadena(IIF(j + i=8,lcCadena,lmDescripcion)))
			lcObservaciones = UPPER(LimpiarCadena(IIF(j + i=11,lcCadena,lcObservaciones)))
			lcRubro			= UPPER(LimpiarCadena(IIF(j + i=4,lcCadena,lcRubro)))
			lcFamilia		= UPPER(LimpiarCadena(IIF(j + i=5,lcCadena,lcFamilia)))
			lcEmail			= UPPER(LimpiarCadena(IIF(j + i=9,lcCadena,lcEmail)))
			lcComentario	= UPPER(LimpiarCadena(IIF(j + i=12,lcCadena,lcComentario)))
			
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
		ENDDO 
		lnSiguienteOcurrencia = 1
		lnCamposLeidos = lnCamposLeidos + 1
		lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
		IF lnPos = 0 AND i <= lnCantCampo &&Si no termino, y no es un campo csrati q nop existe
			 j = j + (i - 1)
		ENDIF 
		IF lnpos#0 AND i+j >= lnCantCampo
			EXIT 
		ENDIF 
	ENDDO 

	IF lnpos#0 AND i+j >= lnCantCampo
		&&Insertamos si se encontro una ultima ocurrencia con respecto a la cantidad de registros
		&&Que se grabaran en csrarti.
		&&Esta dise�ado para leer hasta los precios.
		&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.
		
		INSERT INTO FsrArticulo (fecha,tipo,articulo,marca,observa,rubro,familia,comentario,email);
		VALUES (lcfecha,lcTipo,lcModelo,lcMarca,lcObservaciones,lcrubro,lcFamilia,lcComentario,lcEmail)
		
		replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 
SELECT FsrArticulo
*vista()
SELECT CsrFuerzaVta
GO TOP 
SELECT CsrForma
GO TOP 

lnid = RecuperarID("CsrRubro",goapp.sucursal10)
SELECT distinct rubro as nombre FROM FsrArticulo WHERE LEN(LTRIM(rubro))#0 INTO CURSOR FsrSeccion
SELECT FsrSeccion
Oavisar.proceso('S','Procesando RUBROS') 
GO top

lnnumero = 0
SCAN FOR !EOF()
    lnnumero	= lnnumero + 1 
    lntipoprod 	= 0
    lntipovta   = 1
    lnretibruto = 0
    lnidfrzvta  = CsrFuerzaVta.id
    lnolista 	= 1
    lnporcecomi = 0
    lnporcedev 	= 0
    lnporcesuge = 0
    lntasavied 	= 0
    lntasapata 	= 0
	lcnombre	= NombreNi(ALLTRIM(UPPER(STRTRAN(FsrSeccion.nombre,'.',''))))
	lcCadena	= ArmarAbrevia(lcNombre,'CsrRubro',2)
    lcSwitch = lcCadena+'000'
    
    INSERT INTO CsrRubro (id,numero,nombre,idtipoprod,idtipovta,perceibruto,idfuerzavta,nolista;
    ,porcecomi,porcesuge,porcedev,tasavied,tasapata,switch) ;
    VALUES (lnid,lnnumero,lcnombre,lntipoprod,lntipovta,lnretibruto,lnidfrzvta,lnolista;
    ,lnporcecomi,lnporcesuge,lnporcedev,lntasavied,lntasapata,lcSwitch)
    lnid = lnid + 1

ENDSCAN

lnid = RecuperarID("CsrMarca",goapp.sucursal10)
SELECT distinct marca as nombre FROM FsrArticulo WHERE LEN(LTRIM(marca))#0 INTO CURSOR FsrMarca
SELECT FsrMarca
Oavisar.proceso('S','Procesando MARCAS') 
GO top
lnnumero = 0
SCAN FOR !EOF()
   	lnnumero 	= lnnumero + 1
   	lnflete		= 0
   	lnflete2	= 0
   	lnidfrzavta	= CsrFuerzaVta.id
   	lcnombre	= NombreNi(ALLTRIM(UPPER(FsrMarca.nombre)))
   	lcCadena	= ArmarAbrevia(lcNombre,'CsrMarca',2)
    lcSwitch 	= lcCadena+'000'  	   
   	INSERT INTO Csrmarca (id,numero,nombre,flete,flete2,idfuerzavta,switch);
   	VALUES (lnid,lnnumero,lcnombre,lnflete,lnflete2,lnidfrzavta,lcSwitch)
   	lnid = lnid + 1
  
ENDSCAN

lnid = RecuperarID("CsrFamilia",goapp.sucursal10)
SELECT distinct familia as nombre FROM FsrArticulo WHERE LEN(LTRIM(familia))#0 INTO CURSOR FsrFamilia
SELECT FsrFamilia
Oavisar.proceso('S','Procesando FAMILIAS') 
GO top
lnnumero = 0
SCAN FOR !EOF()
   	lnnumero 	= lnnumero + 1
   	lcnombre	= NombreNi(ALLTRIM(UPPER(FsrFamilia.nombre)))
   	lcCadena	= LEFT(lcNombre,1) &&ArmarAbrevia(lcNombre,'CsrFamilia',1)
    lcSwitch 	= lcCadena+'0000'  	   
   	INSERT INTO CsrFamilia(id,numero,nombre,switch);
   	VALUES (lnid,lnnumero,lcnombre,lcSwitch)
   	lnid = lnid + 1
ENDSCAN

lnid = RecuperarID("CsrCategoTipo",goapp.sucursal10)
SELECT distinct tipo as nombre FROM FsrArticulo WHERE LEN(LTRIM(tipo))#0 INTO CURSOR FsrCategoTipo
SELECT FsrCategoTipo
Oavisar.proceso('S','Procesando TIPOS') 
GO top
lnnumero = 0
SCAN FOR !EOF()
   	lnnumero 	= lnnumero + 1
   	lcnombre	= NombreNi(ALLTRIM(UPPER(FsrCategoTipo.nombre)))
   	lcCadena	= LEFT(lcNombre,1)&&ArmarAbrevia(lcNombre,'CsrCategoTipo',1)
    lcSwitch 	= lcCadena+'0000'  	   
   	INSERT INTO CsrCategoTipo(id,numero,nombre,switch);
   	VALUES (lnid,lnnumero,lcnombre,lcSwitch)
   	lnid = lnid + 1
ENDSCAN

lnid = RecuperarID("CsrProducto",goapp.sucursal10)
lnidproddeta = RecuperarID("CsrProductoDeta",goapp.sucursal10)
SELECT FsrArticulo
Oavisar.proceso('S','Procesando PRODUCTOS') 
GO top
lnnumero = 0
SCAN FOR !EOF()
	STORE 0 TO 	lnidctavta,lnidctacpra,lnnomodifica,lnminimofac,lnvolumen,lnidenvase;
	,lnctaaorden,lncprakilos,lnsiinforma,lnesinsumo,lnpeso,lnpuntope,lnendolar;
	,lnsubsidiado,lnidingbrutoslp,lnfracciona,lnnolista,lnnofactura,lnespromocion,lnvtakilos,lndivisible;
	,lnimportado,lnidmarca,lnidctacte,lnidRubro,lnidFrio,lnSiReparto,lnppt,lnitc;
	,lnidfamilia,lnidcategotipo;
	
	
	STORE 0 TO lncosto,lnflete,lnsegflete,lncostobon,lncostorepo,lncostoulcpra;
	,lnmargen4,lnprevta4,lnprevtaf4,lnmargen1,lnprevta1,lnprevtaf1,lnmargen2,lnprevta2,lnprevtaf2;
	,lnmargen3,lnprevta3,lnprevtaf3,lndesc1,lndesc2,lndesc3;
	,lnmin1,lnmin2,lnmin3,lninternoporce,lninterno,lnsugerido;
	,lnbonif1,lnbonif2,lnbonif3,lnbonif4,lncotidolar;
	
	lcCodAlfa = ""
	
	SELECT CsrMarca
    LOCATE FOR ALLTRIM(nombre)$ALLTRIM(Fsrarticulo.marca)
    IF FOUND()
       lnidmarca = CsrMarca.id
       lcCodAlfa = lcCodalfa + LEFT(CsrMarca.switch,2)    
    ENDIF
    
    SELECT CsrRubro
    LOCATE FOR ALLTRIM(nombre)$ALLTRIM(Fsrarticulo.rubro)
    IF FOUND()
        lnidrubro = CsrRubro.id
    	lcCodAlfa = lcCodalfa + LEFT(CsrRubro.switch,2)    
    ENDIF
    
	SELECT CsrFamilia
    LOCATE FOR ALLTRIM(nombre)$ALLTRIM(Fsrarticulo.familia)
    IF FOUND()
       lnidfamilia = CsrFamilia.id
       lcCodAlfa = lcCodalfa + LEFT(CsrFamilia.switch,1)    
    ENDIF
    
    SELECT CsrCategotipo
    LOCATE FOR ALLTRIM(nombre)$ALLTRIM(Fsrarticulo.tipo)
    IF FOUND()
       lnidCategotipo = CsrCategotipo.id
       lcCodAlfa = lcCodalfa + LEFT(CsrCategoTipo.switch,1)  
    ENDIF
    
    lnNumCodAlfa = 1
    SELECT MAX(CAST(RIGHT(codalfa,3) as i)) as numero FROM CsrProducto;
    WHERE idmarca = CsrMarca.id AND idrubro = CsrRubro.id AND idfamilia = CsrFamilia.id;
    AND idcategotipo = CsrCategoTipo.id INTO CURSOR CsrMaxCodAlfa READWRITE 
    SELECT CsrMaxCodAlfa
    IF RECCOUNT('CsrMaxCodAlfa')#0
    	lnNumCodAlfa = CsrMaxCodAlfa.numero + 1 
    ENDIF 
    lcCodAlfa = LEFT(lcCodalfa + strzero(lnNumCodAlfa,3),9)
    
    lcCodAlfaProv 	= FsrArticulo.articulo 
	lnidforma 		= 1100000001

    lnidestado 		= 1
    lnidiva        	= 1100000002
    lnidtipovta 	= 1 &&IIF(FsrArticulo.quefactura="B",2,1)
	ldfecha			= CTOD(FsrArticulo.fecha)
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
	
	lcnombre 		= NombreNi(ALLTRIM(FsrArticulo.Marca)+' '+ALLTRIM(FsrArticulo.Rubro)+' '+alltrim(FsrArticulo.articulo))
	lccontrolador	= LEFT(NombreNi(alltrim(lcnombre)),19)
	lcnommayorista	= lcnombre
	lnnumero 	 = lnnumero + 1
	lcnombulto 	 = ''
	
	*lccodalfa	 = LTRIM(STR(lnNumero))
	
	lnincluirped = 1
	ldfeculvta   = ldfecha
	ldfecalta	 = ldfecha
	lnunibulto	 = 1
	lcswitch	 = "00000"
	lccodartprod = ""
	
	lnidenvase = 0
						
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
	
	lcDeta 		= FsrArticulo.descripcion
	lcSwitch 	= '00000'
	IF LEN(LTRIM(lcDeta))#0
		INSERT INTO CsrProductoDeta(id,idarticulo,descripcion,switch);
		VALUES (lnidproddeta,lnid,lcdeta,lcswitch)
		lnidproddeta = lnidproddeta + 1
	ENDIF 
	lcDeta 		= FsrArticulo.comentario
	lcSwitch 	= '10000'
	IF LEN(LTRIM(lcDeta))#0
		INSERT INTO CsrProductoDeta(id,idarticulo,descripcion,switch);
		VALUES (lnidproddeta,lnid,lcdeta,lcswitch)
		lnidproddeta = lnidproddeta + 1
	ENDIF 
	lcDeta 		= FsrArticulo.email
	lcSwitch 	= '20000'
	IF LEN(LTRIM(lcDeta))#0
		INSERT INTO CsrProductoDeta(id,idarticulo,descripcion,switch);
		VALUES (lnidproddeta,lnid,lcdeta,lcswitch)
		lnidproddeta = lnidproddeta + 1
	ENDIF 
	lcDeta 		= FsrArticulo.observa
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

*!*	*!*	*!*	SELECT CsrProducto.* FROM CsrProducto as CsrProducto;
*!*	*!*	*!*	ORDER BY idmarca,idrubro,idfamilia,idcategotipo INTO CURSOR CsrAuxProducto READWRITE 

*!*	*!*	*!*	SELECT CsrauxProducto
*!*	*!*	*!*	GO TOP 
*!*	*!*	*!*	SCAN 
*!*	*!*	*!*		
*!*	*!*	*!*	ENDSCAN 

*!*	lnid = RecuperarID("CsrDeposito",goapp.sucursal10)

*!*	SELECT FsrDeposito
*!*	Oavisar.proceso('S','Procesando DEPOSITO') 
*!*	GO top
*!*	SCAN FOR !EOF()
*!*	   	lnnumero		= FsrDeposito.numero
*!*		lnllevastock	= 1
*!*	   	lcnombre		= NombreNi(FsrDeposito.nombre)

*!*		INSERT INTO Csrdeposito (id,numero,nombre,llevastock);
*!*		VALUES (lnid,FsrDeposito.numero,lcnombre,lnllevastock)
*!*		lnid = lnid + 1

*!*	ENDSCAN
*!*	SELECT CsrRubro
*!*	vista()
*!*	SELECT CsrMarca
*!*	vista()


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')

	
USE IN FsrArticulo 
USE IN FsrSeccion 
USE IN FsrMarca
USE IN FsrAfectacion
USE IN FsrFamilia
USE IN FsrCategoTipo

CLOSE tables
CLOSE INDEXES
CLOSE DATABASES