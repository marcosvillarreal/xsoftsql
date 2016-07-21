PARAMETERS ldvacio,lcpath,lcBase
LOCAL lcData,lnid,lcfecha
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

SET SAFETY OFF 
Oavisar.proceso('S','Vaciando archivos') 
SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON
llok = .t.
llok = CargarTabla(lcData,'Producto')
llok = CargarTabla(lcData,'PlanCue')
SET SAFETY ON
IF !llok
	RETURN .f.
ENDIF

Oavisar.proceso('S','Abriendo archivos') 
USE ALLTRIM(lcpath )+"\gestion\insumos" IN 0 ALIAS FsrInsumo EXCLUSIVE 

lnidproducto = RecuperarID('CsrProducto',goapp.sucursal10)

SELECT MAX(numero) as CodMax FROM CsrProducto INTO CURSOR CsrCodigo
lnCodMax = CsrCodigo.CodMax
 
SELECT FsrInsumo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()

	lnNumero = lnCodMax + 1 
	lnCodMax = lnNumero + 1
	
	STORE 0 TO lnIdctacte,lnIdmarca,lnIdctavta,lnIdctacpra,lnIdforma,lnIdunidad,lnIdtprod,lnIdtipovta;
	,lnIdtamano,lnIdcatego,lnIdrubro,lnIdestado,lnIdubicacio,lnIdorigen,lnNomodifica,lnIncluirped,lnIdiva;
	,lnIdmoneda,lnCosto,lnFlete,lnSegflete,lnInterno,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnCostobon;
	,lnCostorepo,lnCostoulcpra,lnMargen1,lnPrevta1,lnPrevtaf1,lnMargen2,lnPrevta2,lnPrevtaf2,lnMargen3;
	,lnPrevta3,lnPrevtaf3,lnMargen4,lnPrevta4,lnPrevtaf4,lnUnibulto,lnNofactura,lnNolista,lnEspromocion;
    ,lnMinimofac,lnPeso,lnVolumen,lnFracciona,lnPuntope,lnIdenvase,lnSugerido,lnIdfrio,lnDivisible,lnDesc1;
    ,lnDesc2,lnDesc3,lnMin1,lnMin2,lnMin3,lnVtakilos,lnInternoporce,lnPpt,lnItc,lnSubsidiado,lnCtaaorden;
    ,lnCprakilos,lnSiinforma,lnImportado
    STORE "" TO lcNombulto,lcCodalfa,lcControlador,lcNommayorista,lcCodartprod
    
    lcNombre	 = NombreNi(alltrim(FsrInsumo.nombre))
    ldFeculcpra  = DATETIME(1900,1,1,0,0,0)
    ldFeculvta 	 = DATETIME(1900,1,1,0,0,0)
    ldFecalta 	 = DATETIME(1900,1,1,0,0,0)
    ldFecmodi 	 = DATETIME(1900,1,1,0,0,0)
    lcSwitch 	 = '00000'
    ldFecoferta  = DATETIME(1900,1,1,0,0,0)
    lnIdctacpra	 = FsrInsumo.Cuenta
    lnIdestado	 = 1 
    lnIdUbicacio = 1100000001
    
	INSERT INTO CsrProducto(Id,Numero,Nombre,Nombulto,Codalfa,Idctacte,Idmarca,Idctavta;
	,Idctacpra,Idforma,Idunidad,Idtprod,Idtipovta,Idtamano,Idcatego,Idrubro,Idestado;
    ,Idubicacio,Idorigen,Nomodifica,Incluirped,Idiva,Idmoneda,Costo,Flete,Segflete;
    ,Interno,Bonif1,Bonif2,Bonif3,Bonif4,Costobon,Costorepo,Costoulcpra,Feculcpra;
    ,Margen1,Prevta1,Prevtaf1,Margen2,Prevta2,Prevtaf2,Margen3,Prevta3,Prevtaf3;
    ,Margen4,Prevta4,Prevtaf4,Feculvta,Fecalta,Fecmodi,Unibulto,Nofactura,Nolista;
    ,Espromocion,Minimofac,Peso,Volumen,Fracciona,Puntope,Switch,Idenvase,Sugerido;
    ,Idfrio,Divisible,Desc1,Desc2,Desc3,Min1,Min2,Min3,Codartprod,Vtakilos,Fecoferta;
    ,Internoporce,Controlador,Nommayorista,Ppt,Itc,Subsidiado,Ctaaorden,Cprakilos;
    ,Siinforma,Importado,EsInsumo);
     VALUES (lnIdProducto,lnNumero,lcNombre,lcNombulto,lcCodalfa,lnIdctacte,lnIdmarca,lnIdctavta,lnIdctacpra;
     ,lnIdforma,lnIdunidad,lnIdtprod,lnIdtipovta,lnIdtamano,lnIdcatego,lnIdrubro,lnIdestado,lnIdubicacio;
     ,lnIdorigen,lnNomodifica,lnIncluirped,lnIdiva,lnIdmoneda,lnCosto,lnFlete,lnSegflete,lnInterno;
     ,lnBonif1,lnBonif2,lnBonif3,lnBonif4,lnCostobon,lnCostorepo,lnCostoulcpra,ldFeculcpra,lnMargen1;
     ,lnPrevta1,lnPrevtaf1,lnMargen2,lnPrevta2,lnPrevtaf2,lnMargen3,lnPrevta3,lnPrevtaf3,lnMargen4;
     ,lnPrevta4,lnPrevtaf4,ldFeculvta,ldFecalta,ldFecmodi,lnUnibulto,lnNofactura,lnNolista,lnEspromocion;
     ,lnMinimofac,lnPeso,lnVolumen,lnFracciona,lnPuntope,lcSwitch,lnIdenvase,lnSugerido,lnIdfrio;
     ,lnDivisible,lnDesc1,lnDesc2,lnDesc3,lnMin1,lnMin2,lnMin3,lcCodartprod,lnVtakilos,ldFecoferta;
     ,lnInternoporce,lcControlador,lcNommayorista,lnPpt,lnItc,lnSubsidiado,lnCtaaorden,lnCprakilos;
     ,lnSiinforma,lnImportado,1)
     
     lnIdProducto = lnIdProducto +1  	

	 SELECT FsrInsumo   				
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE IN FsrInsumo 