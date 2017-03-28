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
llok = CargarTabla(lcData,'Rubro')
llok = CargarTabla(lcData,'Familia')
llok = CargarTabla(lcData,'AfeCateProd')
llok = CargarTabla(lcData,'Producto')
llok = CargarTabla(lcData,'Marca')

SET SAFETY ON
IF !llok
	RETURN .f.
ENDIF

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid,lnidFamGral,lnidTipoGral

lnidAfe = RecuperarID('CsrAfeCateProd',Goapp.sucursal10)

*!*	INSERT INTO CsrAfeCateProd (id,idpadre,idhijo,clave,switch,estado);
*!*	VALUES (lnidAfe,lnidFamGral,lnidTipoGral,'FT',"00000",0)
*stop()
 
SELECT CsrProducto
SCAN
	
	nIdMarca	= CsrProducto.idmarca
	SELECT CsrMArca
	LOCATE FOR id = nIdMarca
	
	nIdRubro	= CsrProducto.idRubro
	IF CsrProducto.idrubro < 1100000000
		SELECT CsrRubro
		LOCATE FOR numero = CsrProducto.idrubro
		nIdRubro	= CsrRubro.id
	ENDIF 
	
	SELECT CsrAfeCateProd
	LOCATE FOR idpadre = nIdRubro AND clave='RF'
	IF NOT (idpadre = nIdRubro AND clave='RF')
		oavisar.usuario(CsrProducto.nombre + " No hay relacion con el Rubro "+CsrRubro.nombre)
		SELECT CsrProducto
		LOOP 
	ENDIF 
	nIdFamilia = CsrAfeCateProd.idhijo
	SELECT CsrFamilia
	LOCATE FOR id = nIDFamilia
	
	SELECT CsrAfeCateProd
	LOCATE FOR idpadre = nIdFamilia AND clave='FT'
	IF NOT (idpadre = nIdFamilia AND clave='FT')
		oavisar.usuario(CsrProducto.nombre + " No hay relacion con la Familia "+CsrFamilia.nombre)
		SELECT CsrProducto
		LOOP 
	ELSE
		nIdCategoTipo = CsrAfeCateProd.idhijo
	ENDIF 
	
	SELECT CsrAfeCateProd
	LOCATE FOR idpadre = nIdMarca AND idhijo = nIDRubro AND clave='MR'
	IF NOT (idpadre = nIdMarca AND idhijo = nIDRubro AND clave='MR')
		INSERT INTO CsrAfeCateProd (id,idpadre,idhijo,clave,switch,estado);
		VALUES (lnidAfe,nIdMarca,nIdRubro,'MR',"00000",0)
		
		lnidAfe = lnidAfe + 1 
	ENDIF 
	
	SELECT CsrAfeCateProd
	LOCATE FOR idpadre = nIdRubro AND idhijo = nIDFamilia AND clave='RF'
	IF NOT (idpadre = nIdRubro AND idhijo = nIDFamilia AND clave='RF')
		INSERT INTO CsrAfeCateProd (id,idpadre,idhijo,clave,switch,estado);
		VALUES (lnidAfe,nIdRubro,nIdFamilia,'RF',"00000",0)
		
		lnidAfe = lnidAfe + 1 
	ENDIF 
	
	replace idrubro WITH nIdRubro, idfamilia WITH nIdFamilia , idcategotipo WITH nIdCategoTipo IN CsrProducto
	
	SELECT CsrProducto
ENDSCAN 


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES

