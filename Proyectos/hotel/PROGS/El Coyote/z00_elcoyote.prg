&&Fuentes de importacion de archivos de texto para elsure�o (Jaque Acces)
FUNCTION LeerClientes(cArchivo)

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )

CREATE CURSOR CsrDeudor (Codigo c(8),Categoria c(20),Nombre c(70),Direccion c(100),CodLocalidad c(6),Localidad c(50);
		,CodPostal c(10),CodProvincia c(6),Provincia c(50);
		,Telefono c(20),Telefono2 c(20),Fax c(20),Celular c(20),Email c(50),fecAlta c(15);
		,TipoDoc c(50),Documento c(20);
		,TipoIVA c(50),CodVendedor c(6),Vendedor c(30),Zona c(3),obsercli c(100),ctadeudor n(1),IngBrutos c(20);
		,DireNro c(5),DirePiso c(5),DireDpto c(5),Lista c(30),CodLista n(2),Estado c(1);
		,CodCateIVA n(2),CodGan n(3),PlanPago n(1),DiasVto n(3),Ganancia n(1),idlocalidad n(12),idorigen i;
		,DireDespachoc (100),FacEmail c(100))
	
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
APPEND FROM  &cArchivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

Oavisar.proceso('S','Procesando '+alias()) 

cCadeCtacte = "" 


SELECT CsrLista
GO TOP 
*vista()
lnPrimeraOcurrencia = 14
leiunarticulo = .f.

ldebug = .t.

SKIP 
*stop()
DO WHILE NOT EOF()
	lnCantCampo = 22 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		SKIP 
		LOOP 
	ENDIF 
	
*!*		IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo,lcIdJ
		STORE "" TO lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia
		STORE "" TO lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento
		STORE "" TO lcTipoIVA,lcVendedor,lcZona,lcCodVendedor,lcDireNro,lcDirePiso,lcDireDpto,lcLista
		STORE "" TO lcEstado,lcCodLista,lcCodCateIVA,lcCodProvincia	,lcCodLocalidad,lcLista
		STORE "" TO lcDireDespacho,lcFacEmail
		
		j = 0
*!*		ELSE
*!*			IF !leiunarticulo
*!*				SKIP 
*!*				LOOP 
*!*			ENDIF 
*!*		ENDIF 
	
	DO WHILE lnCamposLeidos<4
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
			*lcIdJ			= UPPER(LimpiarCadena(IIF(j + i=1,lcCadena,lcIdJ)))
			lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=1,lcCadena,lcCodigo)))
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcNombre)))
			lcDireccion	= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcDireccion)))
			LcLocalidad	= UPPER(LimpiarCadena(IIF(j + i=4,lcCadena,lcLocalidad)))
			lcProvincia	= UPPER(LimpiarCadena(IIF(j + i=5,lcCadena,lcProvincia)))
			lcTelefono	= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcTelefono)))
			lcDocumento	= UPPER(LimpiarCadena(IIF(j + i=8,lcCadena,lcDocumento)))
			lcCodCateIVA	= UPPER(LimpiarCadena(IIF(j + i=9,lcCadena,lcCodCateIVA)))
			lcDireDespacho	= UPPER(LimpiarCadena(IIF(j + i=11,lcCadena,lcDireDespacho)))
			lcFacEmail	= UPPER(LimpiarCadena(IIF(j + i=12,lcCadena,lcFacEmail)))
			lcEmail			= UPPER(LimpiarCadena(IIF(j + i=13,lcCadena,lcEmail)))
			
			*lcDireNro		= UPPER(LimpiarCadena(IIF(j + i=6,lcCadena,lcDireNro)))
			*lcDirePiso		= UPPER(LimpiarCadena(IIF(j + i=8,lcCadena,lcDirePiso)))
			*lcDireDpto		= UPPER(LimpiarCadena(IIF(j + i=10,lcCadena,lcDireDpto)))
			*LcCodLocalidad	= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcCodLocalidad)))			
			*lcCategoria		= UPPER(LimpiarCadena(IIF(j + i=13,lcCadena,lcCategoria)))
			*lcCodLista		= UPPER(LimpiarCadena(IIF(j + i=14,lcCadena,lcCodLista))) 
			*lcLista			= UPPER(LimpiarCadena(IIF(j + i=15,lcCadena,lcLista))) 
			*lcCodVendedor	= UPPER(LimpiarCadena(IIF(j + i=16,lcCadena,lcCodVendedor)))
			*lcVendedor		= UPPER(LimpiarCadena(IIF(j + i=17,lcCadena,lcVendedor)))			
			*lcCelular		= UPPER(LimpiarCadena(IIF(j + i=19,lcCadena,lcCelular)))
			*lcEstado		= UPPER(LimpiarCadena(IIF(j + i=20,lcCadena,lcEstado)))
			*lcZona			= UPPER(LimpiarCadena(IIF(j + i=21,lcCadena,lcZona)))
			*lcFax			= UPPER(LimpiarCadena(IIF(j + i=12,lcCadena,lcFax)))			
			*lcfecAlta		= IIF(j + i=19,lcCadena,lcFecAlta)
			lcTipoDoc		= 'CUIT'&&UPPER(LimpiarCadena(IIF(j + i=22,lcCadena,lcTipoDoc)))
							
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
			
			IF VAL(lcCodigo)=1772 and ldebug
				*stop()
				ldebug = .f.
			ENDIF 
		
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
		
		IF ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---'
			LOOP 
		ENDIF 
		IF '*'$lcTelefono
			LOOP
		ENDIF 
		*lcCodigo = SUBSTR(lcCodigo,4)
		
		INSERT INTO CsrDeudor (Codigo,Categoria,Nombre,Direccion,Localidad,CodPostal,Provincia;
		,Telefono,Telefono2,Fax,Celular,Email,fecAlta,TipoDoc,Documento;
		,TipoIVA,Vendedor,Zona,ctadeudor,DireNro,DirePiso,DireDpto,Lista,Estado,CodLista;
		,CodCateIVA,CodLocalidad,CodProvincia,CodVendedor,idorigen;
		,DireDespacho,FacEmail) ;
		values (lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia ;
		,lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento ;
		,lcTipoIVA,lcVendedor,lcZona,1,lcDireNro,lcDirePiso,lcDireDpto,lcLista,lcEstado,VAL(lcCodLista);
		,VAL(lcCodCateIVA),lcCodLocalidad,lcCodProvincia,lcCodVendedor,VAL(lcIdJ);
		,lcDireDespacho,lcFacEmail)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
	SKIP IN CsrLista
ENDDO 

USE IN CsrLista

ENDFUNC 

FUNCTION LeerArticulos(lcArchivo)

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrArticulo (Codigo c(8),Rubro c(20),Nombre c(100),Proveedor c(8);
		,Alicuota c(8),UniBulto c(10),UniVenta c(1),Costo c(15),CodRubro c(6),IDJ c(8))

SELECT CsrLista
APPEND FROM  &cArchivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

Oavisar.proceso('S','Procesando '+alias()) 

cCadeCtacte = "" 


SELECT CsrLista
GO TOP 
*vista()
lnPrimeraOcurrencia = 13
leiunarticulo = .f.

SKIP 
*STOP()
SCAN 
	lnCantCampo = 8 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
*!*		IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcRubro,lcNombre,lcProveedor,lcAlicuota,lcUniVenta
		STORE "" TO lcCosto, lcLista1, lcLista2,lcIDJ ,lcUniBulto,lcCodRubro
		j = 0
*!*		ELSE
*!*			IF !leiunarticulo
*!*				LOOP 
*!*			ENDIF 
*!*		ENDIF 
	
	DO WHILE lnCamposLeidos<4
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
			lcIDJ			= UPPER(LimpiarCadena(IIF(j + i=1,lcCadena,lcIdJ)))
			lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcCodigo)))
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcNombre)))
			lcCodRubro		= UPPER(LimpiarCadena(IIF(j + i=5,lcCadena,lcCodRubro)))
			lcRubro			= UPPER(LimpiarCadena(IIF(j + i=6,lcCadena,lcRubro)))
			lcUniBulto		= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcUniBulto)))
			lcUniVenta		= UPPER(LimpiarCadena(IIF(j + i=8,lcCadena,lcUniVenta)))
			*lcProveedor		= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcProveedor)))
			lcAlicuota		= "21"
			lcCosto			= "0"
			*lcLista1		= IIF(j + i=18,lcCadena,lcLista1)
			*lcLista2		= IIF(j + i=20,lcCadena,lcLista2)
			
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
		ENDDO 
		lnSiguienteOcurrencia = 1
		lnCamposLeidos = lnCamposLeidos + 1
		lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
		IF lnPos = 0 AND i <= lnCantCampo &&Si no termino, y no es un campo csrati q nop existe
			 j = j + (i - 1)
		ENDIF 
		*IF lnpos#0 AND i+j >= lnCantCampo
		IF lnCamposLeidos<4 AND i+j >= lnCantCampo
			EXIT 
		ENDIF 
	ENDDO 

	IF lnCamposLeidos>=1 AND i+j >= lnCantCampo
		&&Insertamos si se encontro una ultima ocurrencia con respecto a la cantidad de registros
		&&Que se grabaran en csrarti.
		&&Esta dise�ado para leer hasta los precios.
		&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.
		
		IF ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---'
			LOOP 
		ENDIF 
		lcCodigo = ALLTRIM(lcCodigo)
		INSERT INTO CsrArticulo (Codigo,Rubro,Nombre,Proveedor,Alicuota,UniVenta,Costo,CodRubro,IDJ,UniBulto);
		values (lcCodigo,lcRubro,lcNombre,lcProveedor,lcAlicuota,lcUniVenta,lcCosto,lcCodRubro,lcIDJ,lcUniBulto)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 

USE IN CsrLista

ENDFUNC 

FUNCTION LeerPrecios(cArchivo)

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
		
CREATE CURSOR CsrPrecio (Codigo c(8),Costo c(10),Lista1 c(10),Lista2 c(10),Lista3 c(10),Lista4 c(10))

SELECT CsrLista
APPEND FROM  &cArchivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

Oavisar.proceso('S','Procesando '+alias()) 

cCadeCtacte = "" 


SELECT CsrLista
GO TOP 
*vista()
lnPrimeraOcurrencia = 1
leiunarticulo = .f.
*STOP()
SCAN 
	lnCantCampo = 7 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
*!*		IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcLista1,lcCosto,lcFecha,lcLista2,lcLista3,lcLista4
		j = 0
*!*		ELSE
*!*			IF !leiunarticulo
*!*				LOOP 
*!*			ENDIF 
*!*		ENDIF 
	
	DO WHILE lnCamposLeidos<4
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
			lcCodigo	= UPPER(LimpiarCadena(IIF(j + i=1,lcCadena,lcCodigo)))
			lcCosto		= UPPER((IIF(j + i=3,lcCadena,lcCosto)))
			lcLista1	= UPPER((IIF(j + i=4,lcCadena,lcLista1)))
			lcLista2	= UPPER((IIF(j + i=5,lcCadena,lcLista2)))
			lcLista3	= UPPER((IIF(j + i=6,lcCadena,lcLista3)))
			lcLista4	= UPPER((IIF(j + i=7,lcCadena,lcLista4)))
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
		
		lcCosto = STRTRAN(lcCosto,',','.')
		lcCodigo = STRTRAN(STRTRAN(lcCodigo,'.',''),',','')
		lcLista1 = STRTRAN(lcLista1,'$','')
		lcLista2 = STRTRAN(lcLista2,'$','')
		lcLista3 = STRTRAN(lcLista3,'$','')
		lcLista4 = STRTRAN(lcLista4,'$','')
		
		INSERT INTO CsrPRecio (Codigo,Costo,Lista1,Lista2,Lista3,Lista4);
		values (lcCodigo,lcCosto,lcLista1,lcLista2,lcLista3,lcLista4)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN
ENDFUNC 