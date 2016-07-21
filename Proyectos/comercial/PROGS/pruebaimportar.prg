IF USED('CsrLista')
	USE IN CsrLista
ENDIF 
IF USED('CsrArti')
	USE IN CsrArti
ENDIF 

CREATE CURSOR CsrArti (fecha c(10),Rubro c(100),Familia c(100),tipo c(50),Articulo c(100);
						,Marca c(50),Descripcion M,observa c(100))

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250);
		,deta04 c(250),deta05 c(250),deta06 c(250),deta07 c(250))

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
BROWSE 
lnPrimeraOcurrencia = 10
leiunarticulo = .f.
*stop()
SCAN 
	lnCantCampo = 7 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)
	*Recupero el Rubro
	IF AT(lcDelimitador,deta01,1)=1 AND AT(lcDelimitador,deta01,2)<>2 AND LEN(LTRIM(SUBSTR(deta01,2,AT(lcDelimitador,deta01,2)-2)))#0
		lninicio = 2
		lnpos = AT(lcDelimitador,deta01,2)
		lcRubro = SUBSTR(deta01,lninicio,lnpos-lninicio)
	ENDIF 
	*Recupero la Marca
	IF AT(lcDelimitador,deta01,1)=1 AND AT(lcDelimitador,deta01,2)<>2 AND LEN(LTRIM(SUBSTR(deta01,2,AT(lcDelimitador,deta01,2)-2)))=0
		lninicio = AT(lcDelimitador,deta01,2) +1
		lnpos = AT(lcDelimitador,deta01,3)
		lcFamilia = SUBSTR(deta01,lninicio,lnpos-lninicio)
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
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
				lcAcarreo = ALLTRIM(lcAcarreo) + SUBSTR(&lcNomCampo,lnSiguienteOcurrencia)
				EXIT 
			ENDIF 
			lcfecha			= IIF(j + i=1,DTOC(CDateEngSpa(lcCadena)),lcFecha)
			lcTipo			= IIF(j + i=2,lcCadena,lcTipo)
			lcModelo		= IIF(j + i=3,lcCadena,lcModelo)
			lcMarca			= IIF(j + i=4,lcCadena,lcMarca)
			lmDescripcion 	= IIF(j + i=5,lcCadena,lmDescripcion)
			&&IIF(j + i=6,lcCadena,lmDescripcion) NO TIENE INFORMACION
			lcObservaciones = IIF(j + i=7,lcCadena,lcObservaciones)
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
		&&Esta diseñado para leer hasta los precios.
		&&Si se quiere leer todo. Se necesita un caracter de finalizado de linea.
		
		INSERT INTO csrArti (fecha,tipo,articulo,marca,observa,rubro,familia);
		VALUES (lcfecha,UPPER(lcTipo),UPPER(lcModelo),UPPER(lcMarca);
				,UPPER(lcObservaciones),UPPER(lcrubro),UPPER(lcFamilia))
		
		replace descripcion WITH lmDescripcion IN CsrArti
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 
SELECT distinct marca FROM CsrArti WHERE LEN(LTRIM(marca))#0 ORDER BY marca INTO CURSOR FsrMarca
SELECT FsrMarca
BROWSE 

SELECT CsrArti
GO TOP 
BROWSE 
