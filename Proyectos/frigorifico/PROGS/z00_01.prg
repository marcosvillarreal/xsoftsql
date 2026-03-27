&&Fuentes de importacion de archivos de texto para 
FUNCTION LeerClientes_01(cArchivo)

SET SAFETY ON


CREATE CURSOR CsrDeudor (Codigo c(8),Categoria c(20),Nombre c(70),Direccion c(100),Localidad c(50),CodPostal c(10),Provincia c(50);
		,Telefono c(20),Telefono2 c(20),Fax c(20),Celular c(20),Email c(50),fecAlta c(15),TipoDoc c(50),Documento c(20);
		,TipoIVA c(50),Vendedor c(30),Zona c(3),obsercli c(100),ctadeudor n(1),IngBrutos c(20);
		,DireNro c(5),DirePiso c(5),DireDpto c(5),Lista c(30),CodLista n(2),Estado c(1);
		,CodCateIVA n(2),CodGan n(3),PlanPago n(1),DiasVto n(3),Ganancia n(1))

SET SAFETY OFF 
*INDEX on nombre TAG korden
SET SAFETY ON 
	
Oavisar.proceso('S','Abriendo archivos') 

LOCAL lcXml, lnFilas, i, loReg
lcXml = FILETOSTR(cArchivo)

* Usamos un truco: Convertimos los nodos <row> en registros de un array
lnFilas = ALINES(laRows, lcXml, 1 + 4, "<row>", "</row>")

FOR i = 2 TO lnFilas && Empezamos en 2 para saltar el encabezado
    lcFila = laRows[i]
	STORE "" TO lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia
	STORE "" TO lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento
	STORE "" TO lcTipoIVA,lcVendedor,lcZona,lcCodVendedor,lcDireNro,lcDirePiso,lcDireDpto,lcLista
	STORE "" TO lcEstado,lcCodLista,lcCodCateIVA

	lcCodigo		= STREXTRACT(lcFila, 'name="codigo">', '</field>')
	lcNombre		= STREXTRACT(lcFila, 'name="cnombre">', '</field>')
	lcDocumento		= STREXTRACT(lcFila, 'name="cuit">', '</field>')
	lcDireccion		= STREXTRACT(lcFila, 'name="cdireccion">', '</field>')
	lcDireNro		= STREXTRACT(lcFila, 'name="cdirenro">', '</field>')
	lcDirePiso		= STREXTRACT(lcFila, 'name="cdire_piso">', '</field>')
	lcDireDpto		= STREXTRACT(lcFila, 'name="cdire_dpto">', '</field>')
	LcLocalidad		= STREXTRACT(lcFila, 'name="nomlocalidad">', '</field>')
	lcProvincia		= STREXTRACT(lcFila, 'name="nomprov">', '</field>')
	lcTelefono		= STREXTRACT(lcFila, 'name="ctelefono">', '</field>')
	lcCodCateIVA	= STREXTRACT(lcFila, 'name="idcategoiva">', '</field>')
	lcTipoIVA		= STREXTRACT(lcFila, 'name="nomcategoiva">', '</field>')
	lcTelefono2		= STREXTRACT(lcFila, 'name="ctelefono2">', '</field>')
	lcEstado		= STREXTRACT(lcFila, 'name="estado">', '</field>')
	lcCodLista		= STREXTRACT(lcFila, 'name="idlista">', '</field>')
	lcLista			= STREXTRACT(lcFila, 'name="nomlista">', '</field>')
	lcZona			= STREXTRACT(lcFila, 'name="zona">', '</field>')
	lcCodVendedor	= STREXTRACT(lcFila, 'name="idvendedor">', '</field>')
	lcVendedor		= STREXTRACT(lcFila, 'name="nomvendedor">', '</field>')
	lcTipoDoc		= 'CUIT'&&UPPER(LimpiarCadena(IIF(j + i=22,lcCadena,lcTipoDoc)))
	
    
	IF not(ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---')
	
	
		INSERT INTO CsrDeudor (Codigo,Categoria,Nombre,Direccion,Localidad,CodPostal,Provincia;
		,Telefono,Telefono2,Fax,Celular,Email,fecAlta,TipoDoc,Documento;
		,TipoIVA,Vendedor,Zona,ctadeudor,DireNro,DirePiso,DireDpto,Lista,Estado,CodLista;
		,CodCateIVA) ;
		values (lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia ;
		,lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento ;
		,lcTipoIVA,lcVendedor,lcZona,1,lcDireNro,lcDirePiso,lcDireDpto,lcLista,lcEstado;
		,VAL(lcCodLista),VAL(lcCodCateIVA))
	ENDIF 
ENDFOR

SELECT CsrDeudor 

ENDFUNC 

FUNCTION LeerArticulos_01(lcArchivo)

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrArticulo (Codigo c(8),Rubro c(20),Nombre c(100),Proveedor c(8);
		,Alicuota c(8),IdJAque c(10))

LOCAL lcXml, lnFilas, i, loReg
lcXml = FILETOSTR(cArchivo)

* Usamos un truco: Convertimos los nodos <row> en registros de un array
lnFilas = ALINES(laRows, lcXml, 1 + 4, "<row>", "</row>")

FOR i = 2 TO lnFilas && Empezamos en 2 para saltar el encabezado
    lcFila = laRows[i]
	STORE "" TO lcCodigo,lcRubro,lcNombre,lcProveedor,lcAlicuota,lcIdJaque

	lcCodigo		= STREXTRACT(lcFila, 'name="codigo">', '</field>')
	lcNombre		= STREXTRACT(lcFila, 'name="nombre">', '</field>')
	lcRubro			= STREXTRACT(lcFila, 'name="nomRubro">', '</field>')
	lcProveedor		= STREXTRACT(lcFila, 'name="NomProveedor">', '</field>')
	lcAlicuota		= STREXTRACT(lcFila, 'name="alicIVA">', '</field>')
	lcIdJaque		= STREXTRACT(lcFila, 'name="id">', '</field>')

	IF LEN(LTRIM(lcCodigo))<>0
		INSERT INTO CsrArticulo (Codigo,Rubro,Nombre,Proveedor,Alicuota,IdJaque);
		values (lcCodigo,lcRubro,lcNombre,lcProveedor,lcAlicuota,lcIdJaque)
	ENDIF 
ENDFOR


ENDFUNC 

FUNCTION LeerPrecios_01(cArchivo)

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
		
CREATE CURSOR CsrPrecio (Codigo c(8),Lista c(8), Costo c(15))

LOCAL lcXml, lnFilas, i, loReg
lcXml = FILETOSTR(cArchivo)

* Usamos un truco: Convertimos los nodos <row> en registros de un array
lnFilas = ALINES(laRows, lcXml, 1 + 4, "<row>", "</row>")

FOR i = 2 TO lnFilas && Empezamos en 2 para saltar el encabezado
    lcFila = laRows[i]
	STORE "" TO lcCodigo,lcLista,lcCosto

	lcCodigo		= STREXTRACT(lcFila, 'name="codigo">', '</field>')
	lcLista			= STREXTRACT(lcFila, 'name="codlista">', '</field>')
	lcCosto			= STREXTRACT(lcFila, 'name="prevta">', '</field>')

	IF LEN(LTRIM(lcCodigo))<>0
		INSERT INTO CsrPRecio (Codigo,Lista,Costo);
			values (lcCodigo,lcLista,lcCosto)
	ENDIF 
ENDFOR


FUNCTION LeerProveedores_01(cArchivo)

SET SAFETY ON
CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )

CREATE CURSOR CsrDeudor (Codigo c(8),Categoria c(20),Nombre c(70),Direccion c(100),Localidad c(50),CodPostal c(10),Provincia c(50);
		,Telefono c(20),Telefono2 c(20),Fax c(20),Celular c(20),Email c(50),fecAlta c(15),TipoDoc c(50),Documento c(20);
		,TipoIVA c(50),Vendedor c(30),Zona c(3),obsercli c(100),ctadeudor n(1),IngBrutos c(20);
		,DireNro c(5),DirePiso c(5),DireDpto c(5),Lista c(30),CodLista n(2),Estado c(1);
		,CodCateIVA n(2),CodGan n(3),PlanPago n(1),DiasVto n(3),Ganancia n(1))

CREATE CURSOR CsrSaldos (Codigo c(8),Saldo c(20))


LOCAL lcXml, lnFilas, i, loReg
lcXml = FILETOSTR(cArchivo)

* Usamos un truco: Convertimos los nodos <row> en registros de un array
lnFilas = ALINES(laRows, lcXml, 1 + 4, "<row>", "</row>")

FOR i = 2 TO lnFilas && Empezamos en 2 para saltar el encabezado
    lcFila = laRows[i]
	STORE "" TO lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia
	STORE "" TO lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento
	STORE "" TO lcobservacion,lcIngBrutos,lcGanancia
	STORE "" TO lcTipoIVA,lcVendedor,lcZona,lcCodVendedor,lcDireNro,lcDirePiso,lcDireDpto,lcLista
	STORE "" TO lcEstado,lcCodLista,lcCodCateIVA,lcCodGan,lcPlanPago,lcDiasVto,lcCBU

	lcCodigo		= STREXTRACT(lcFila, 'name="codigo">', '</field>')
	lcNombre		= STREXTRACT(lcFila, 'name="cnombre">', '</field>')
	lcDocumento		= STREXTRACT(lcFila, 'name="cuit">', '</field>')
	lcDireccion		= STREXTRACT(lcFila, 'name="cdireccion">', '</field>')
	lcDireNro		= STREXTRACT(lcFila, 'name="cdire_nro">', '</field>')
	lcDirePiso		= STREXTRACT(lcFila, 'name="cdire_piso">', '</field>')
	lcDireDpto		= STREXTRACT(lcFila, 'name="cdire_dpto">', '</field>')
	LcLocalidad		= STREXTRACT(lcFila, 'name="nomlocalidad">', '</field>')
	lcProvincia		= STREXTRACT(lcFila, 'name="nomprov">', '</field>')
	lcTelefono		= STREXTRACT(lcFila, 'name="ctelefono">', '</field>')
	lcCodCateIVA	= STREXTRACT(lcFila, 'name="idcategoiva">', '</field>')
	lcTipoIVA		= STREXTRACT(lcFila, 'name="nomcategoiva">', '</field>')
	lcTelefono2		= STREXTRACT(lcFila, 'name="ctelefono2">', '</field>')
	lcGanancia		= STREXTRACT(lcFila, 'name="ganestado">', '</field>')
	lcCodGan		= STREXTRACT(lcFila, 'name="idganancia">', '</field>')
	lcPlanPago		= STREXTRACT(lcFila, 'name="tipocta">', '</field>')
	lcIngBrutos		= STREXTRACT(lcFila, 'name="nroiibb">', '</field>')
	lcCBU			= STREXTRACT(lcFila, 'name="cbu">', '</field>')
	lcTipoDoc		= 'CUIT'&&UPPER(LimpiarCadena(IIF(j + i=22,lcCadena,lcTipoDoc)))
	lcDiasVto		= STREXTRACT(lcFila, 'name="diasvto">', '</field>')
	
  
	
	IF not(ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---')
	
	
		INSERT INTO CsrDeudor (Codigo,Categoria,Nombre,Direccion,Localidad,CodPostal,Provincia;
		,Telefono,Telefono2,Fax,Celular,Email,fecAlta,TipoDoc,Documento;
		,TipoIVA,Vendedor,Zona,ctadeudor,DireNro,DirePiso,DireDpto,Lista,Estado,CodLista;
		,CodCateIVA,CodGan,PlanPago,DiasVto,Ganancia) ;
		values (lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia ;
		,lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento ;
		,lcTipoIVA,"","",0,lcDireNro,lcDirePiso,lcDireDpto,"",lcEstado;
		,0,VAL(lcCodCateIVA),VAL(lcCodGan),VAL(lcPlanPago),VAL(lcDiasVto),VAL(lcGanancia))
		
	ENDIF 
ENDFOR


ENDFUNC 

FUNCTION LeerSaldos_01(cArchivo)

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )

CREATE CURSOR CsrSaldos (Codigo c(8),Saldo c(20))

Oavisar.proceso('S','Abriendo archivos') 


LOCAL lcXml, lnFilas, i, loReg
lcXml = FILETOSTR(cArchivo)

* Usamos un truco: Convertimos los nodos <row> en registros de un array
lnFilas = ALINES(laRows, lcXml, 1 + 4, "<row>", "</row>")

FOR i = 2 TO lnFilas && Empezamos en 2 para saltar el encabezado
    lcFila = laRows[i]
	STORE "" TO lcCodigo,lcSaldo

	lcCodigo		= STREXTRACT(lcFila, 'name="cta">', '</field>')
	lcSaldo 		= STREXTRACT(lcFila, 'name="saldo">', '</field>')
  
	
	lcSaldo = STRTRAN(lcSaldo,',','.')
	INSERT INTO CsrSaldos (Codigo,Saldo) ;
	values (lcCodigo,lcSaldo)
		
ENDFOR



*!*	SELECT CsrLista
*!*	APPEND FROM  &cArchivo SDF

*!*	lcDelimitador = ";"
*!*	replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
*!*	replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
*!*	replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)

*!*	Oavisar.proceso('S','Procesando '+alias()) 

*!*	cCadeCtacte = "" 


*!*	SELECT CsrLista
*!*	GO TOP 
*!*	*vista()
*!*	lnPrimeraOcurrencia = 1
*!*	leiunarticulo = .f.

*!*	ldebug = .t.

*!*	*SKIP 
*!*	*stop()
*!*	DO WHILE NOT EOF()
*!*		lnCantCampo = 3 &&Hay un campo vacio
*!*		lnSiguienteOcurrencia = 1
*!*		lnCamposLeidos = 1 &&Campos de CsrLista
*!*		lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

*!*		IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
*!*			SKIP 
*!*			LOOP 
*!*		ENDIF 
*!*		
*!*		IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
*!*			leiunarticulo = .t.
*!*			STORE "" TO lcAcarreo
*!*			STORE "" TO lcCodigo,lcSaldo
*!*			
*!*			j = 0
*!*		ELSE
*!*			IF !leiunarticulo
*!*				SKIP 
*!*				LOOP 
*!*			ENDIF 
*!*		ENDIF 
*!*		
*!*		DO WHILE lnCamposLeidos<4
*!*			i = 1
*!*			DO WHILE i + j <= lnCantCampo &&Campos de CsrArti + 1
*!*				lnpos = AT(lcDelimitador,&lcNomCampo,i)
*!*				IF lnPos#0 &&No es fin de linea
*!*					lccadena = ALLTRIM(lcAcarreo) + SUBSTR(&lcNomCampo,lnSiguienteOcurrencia,lnpos-(lnSiguienteOcurrencia))
*!*					lcAcarreo = ""
*!*				ELSE 
*!*					lcAcarreo = ALLTRIM(lcAcarreo) + ALLTRIM(SUBSTR(&lcNomCampo,lnSiguienteOcurrencia))
*!*					EXIT 
*!*				ENDIF
*!*				lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcCodigo)))
*!*				*lcSaldo		= UPPER(LimpiarCadena(IIF(j + i=3,STRTRAN(STRTRAN(lcCadena,'.',''),',','.'),lcSaldo)))
*!*				lcSaldo			= UPPER((IIF(j + i=3,strtran(lcCadena,'.',''),lcSaldo)))
*!*								
*!*				lnSiguienteOcurrencia = lnPos + 1
*!*				i = i + 1
*!*						
*!*			ENDDO 
*!*			lnSiguienteOcurrencia = 1
*!*			lnCamposLeidos = lnCamposLeidos + 1
*!*			lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
*!*			IF lnPos = 0 AND i <= lnCantCampo &&Si no termino, y no es un campo csrati q nop existe
*!*				 j = j + (i - 1)
*!*			ENDIF 
*!*			IF lnpos#0 AND i+j >= lnCantCampo
*!*				EXIT 
*!*			ENDIF 
*!*		ENDDO 

*!*		IF lnpos#0 AND i+j >= lnCantCampo
*!*			&&Insertamos si se encontro una ultima ocurrencia con respecto a la cantidad de registros
*!*			&&Que se grabaran en csrarti.
*!*			&&Esta diseñado para leer hasta los precios.
*!*			&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.
*!*			lcSaldo = STRTRAN(lcSaldo,',','.')
*!*			INSERT INTO CsrSaldos (Codigo,Saldo) ;
*!*			values (lcCodigo,lcSaldo)
*!*					
*!*			*replace descripcion WITH lmDescripcion IN FsrArticulo
*!*			leiunarticulo = .f.
*!*		ENDIF 
*!*		SKIP IN CsrLista
*!*	ENDDO 


USE IN CsrLista

ENDFUNC 

FUNCTION LeerEmpleados_01(cArchivo)

SET SAFETY ON
CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )

CREATE CURSOR CsrEmpleados (Legajo c(8),Apellido c(20),Nombre c(70))

CREATE CURSOR CsrSaldos (Codigo c(8),Saldo c(20))


LOCAL lcXml, lnFilas, i, loReg
lcXml = FILETOSTR(cArchivo)

* Usamos un truco: Convertimos los nodos <row> en registros de un array
lnFilas = ALINES(laRows, lcXml, 1 + 4, "<row>", "</row>")

FOR i = 2 TO lnFilas && Empezamos en 2 para saltar el encabezado
    lcFila = laRows[i]
	STORE "" TO lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia
	STORE "" TO lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento
	STORE "" TO lcobservacion,lcIngBrutos,lcGanancia
	STORE "" TO lcTipoIVA,lcVendedor,lcZona,lcCodVendedor,lcDireNro,lcDirePiso,lcDireDpto,lcLista
	STORE "" TO lcEstado,lcCodLista,lcCodCateIVA,lcCodGan,lcPlanPago,lcDiasVto,lcCBU
	STORE "" TO lcApellido
	
	lcNombre		= STREXTRACT(lcFila, 'name="nombre">', '</field>')
	lcDocumento		= STREXTRACT(lcFila, 'name="legajo">', '</field>')
	lcApellido		= STREXTRACT(lcFila, 'name="apellido">', '</field>')
	  
	
	IF not(ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---')
	
		*lcNombre= = lcNombre= + ', '+lcApellido
		
		INSERT INTO CsrEmpleados (Legajo,Apellido,Nombre) ;
		values (LcDocumento,LcApellido,lcNombre)
		
	ENDIF 
ENDFOR


ENDFUNC 
