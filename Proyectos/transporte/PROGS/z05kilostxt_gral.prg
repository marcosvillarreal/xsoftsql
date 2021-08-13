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
llok = CargarTabla(lcData,'Producto')


SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

IF USED('CsrLista')
	USE IN CsrLista
ENDIF 

CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrArticulo (Codigo c(8),Rubro c(20),Nombre c(30),Kilos c(8),VtaKilo c(8),UniBulto c(8))
				
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
cArhivo = ALLTRIM(lcpath )+"\pesables.txt"
APPEND FROM  &cArhivo SDF

lcDelimitador = ";"
replace ALL deta01 WITH STRTRAN(deta01,"	",lcDelimitador)
replace ALL deta02 WITH STRTRAN(deta02,"	",lcDelimitador)
replace ALL deta03 WITH STRTRAN(deta03,"	",lcDelimitador)


cCadeCtacte = "" 


SELECT CsrLista
GO TOP 
vista()
lnPrimeraOcurrencia = 1
leiunarticulo = .f.

STOP()
SCAN 
	lnCantCampo = 1 + 6 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcRubro,lcNombre,lcKilos,lcVtaKilo,lcUniBulto
		j = 0
	ELSE
		IF !leiunarticulo
			LOOP 
		ENDIF 
	ENDIF 
	
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
			lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcCodigo)))
			lcRubro			= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcRubro)))
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=4,lcCadena,lcNombre)))
			lcKilos			= IIF(j + i=5,lcCadena,lcKilos)
			LcVtaKilo		= IIF(j + i=6,lcCadena,lcVtaKilo)
			lcUniBulto		= IIF(j + i=7,lcCadena,lcUniBulto)
									
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
		
		IF ASC(LEFT(lcNombre,1))=149 OR ASC(LEFT(lcNombre,1))=149 OR lentrim(lcNombre)=0 OR LEFT(lcNombre,3)='---'
			LOOP 
		ENDIF 
		
		INSERT INTO CsrArticulo (Codigo,Rubro,Nombre,Kilos,VtaKilo,UniBulto);
		values (lcCodigo,lcRubro,lcNombre,STRTRAN(lcKilos,',','.'),lcVtaKilo,lcUniBulto)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 


SELECT CsrProducto
vista()



SELECT CsrArticulo
Oavisar.proceso('S','Procesando '+alias()) 
GO top
stop()
SCAN FOR !EOF()
	SELECT CsrProducto
	
	LOCATE FOR numero=VAL(CsrArticulo.codigo)
	IF numero<>VAL(CsrArticulo.codigo)
		SELECT CsrArticulo
		LOOP 
	ENDIF
	
	nunibulto = IIF(VAL(CsrArticulo.unibulto)=0,1,VAL(CsrArticulo.unibulto))
	replace peso WITH VAL(CsrArticulo.kilos),vtakilos WITH VAL(CsrArticulo.vtakilo),cprakilos WITH VAL(CsrArticulo.vtakilo) IN CsrProducto
	replace unibulto WITH nUniBulto IN CsrProducto
	SELECT CsrArticulo   				
ENDSCAN
SELECT CsrProducto
vista()

   	
Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')



CLOSE tables
CLOSE INDEXES
CLOSE DATABASES