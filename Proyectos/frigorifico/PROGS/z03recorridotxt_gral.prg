PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE TO proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE TO syserror.prg ADDITIVE  

SET SAFETY OFF

SET CPCOMPILE TO 1252
codepage = 1252
SET CPDIALOG ON

Oavisar.proceso('S','Abriendo archivos') 
llok = .t.
llok = CargarTabla(lcData,'Zona',.t.)
llok = CargarTabla(lcData,'Ctacte')
llok = CargarTabla(lcData,'ZonaRuta',.t.)
llok = CargarTabla(lcData,'Vendedor',.t.)
llok = CargarTabla(lcData,'Ruta',.t.)
llok = CargarTabla(lcData,'RutaVdor',.t.)
llok = CargarTabla(lcData,'CabeRuta',.t.)
llok = CargarTabla(lcData,'CuerRuta',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
*llok = CargarTabla(lcData,'PlanCue')
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

Oavisar.proceso('S','Abriendo archivos') 
SET SAFETY ON
CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrRecorrido (Codigo c(8),Vendedor c(30),Zona c(30),CodVendedor c(3))
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
cArchivo = ALLTRIM(lcpath )+"\clientes.csv"
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
SKIP 
DO WHILE NOT EOF()
	lnCantCampo = 22 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcCodVendedor,lcVendedor,lcLocalidad
		
		j = 0
	ELSE
		IF !leiunarticulo
			SKIP 
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
			LcLocalidad		= UPPER(LimpiarCadena(IIF(j + i=10,lcCadena,lcLocalidad)))
			lcCodVendedor	= UPPER(LimpiarCadena(IIF(j + i=21,lcCadena,lcCodVendedor)))
			lcVendedor		= UPPER(LimpiarCadena(IIF(j + i=22,lcCadena,lcVendedor)))
			
			
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
		
		
		INSERT INTO CsrRecorrido (Codigo,Vendedor,Zona,CodVendedor) ;
		values (lcCodigo,lcVendedor,lcLocalidad,lcCodVendedor)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF
	SKIP  
ENDDO 

SELECT CsrRecorrido
*vista()

LOCAL lnid


sELECT distinct vendedor ,codvendedor as numero FROM CsrRecorrido INTO CURSOR FsrVendedor READWRITE 
sELECT distinct zona FROM CsrRecorrido INTO CURSOR FsrZona READWRITE 

lnid = RecuperarID('CsrVendedor',Goapp.sucursal10)
SELECT FsrVendedor
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF VAL(numero)=0
       loop
   ENDIF
   lnprevta = 1
   lnestado = 1
   lnnumero	= VAL(FsrVendedor.numero)
   lcnombre	= NombreNi(alltrim(UPPER(FsrVendedor.vendedor)))
   INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale);
   			 VALUES (lnid,lnnumero,lcnombre,0,1,lnprevta,lnestado,1,0,0)
   lnid = lnid + 1

ENDSCAN


lnid = RecuperarID('CsrZona',Goapp.sucursal10)
SELECT FsrZona
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnNumZona = 0
SCAN FOR !EOF()  
   lcnombre= NombreNi(alltrim(UPPER(fsrzona.zona)))
   lnnumzona = lnnumzona + 1 
   INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
   			 VALUES (lnid,lnnumzona,lcnombre,0,'')
   
   lnid = lnid + 1
ENDSCAN

LOCAL lnidcabeza, lnidrutavdor,lnidzonaruta,lnidcuerruta

lnid = RecuperarID('CsrRuta',Goapp.sucursal10)
*****
lnidcabeza = RecuperarID('CsrCabeRuta',Goapp.sucursal10)
*******
lnidrutavdor = RecuperarID('CsrRutaVdor',Goapp.sucursal10)
*****
lnidzonaruta = RecuperarID('CsrZonaRuta',Goapp.sucursal10)
*******
lnidcuerruta = RecuperarID('CsrCuerRuta',Goapp.sucursal10)
***
SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta  = CsrFuerzaVta.id

*stop()
SELECT CsrRecorrido
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnNumRuta = 1
SCAN FOR !EOF()

	SELECT Csrctacte
	LOCATE FOR VAL(cnumero)=VAL(CsrRecorrido.codigo)
   IF VAL(cnumero) # VAL(CsrRecorrido.codigo)
       SELECT CsrRecorrido
       LOOP 
   ENDIF 
		
*	IF CsrRecorrido.carpeta#0
		SELECT CsrVendedor
		LOCATE FOR numero=VAL(CsrRecorrido.codvendedor)
		IF numero#VAL(CsrRecorrido.codvendedor)
			SELECT CsrRecorrido
			LOOP
		ENDIF 	
		
		SELECT CsrZona
		LOCATE for CsrZona.nombre=CsrRecorrido.zona
		IF CsrZona.nombre#CsrRecorrido.zona OR EMPTY(CsrRecorrido.zona)
			SELECT CsrZona
		 	GO TOP 
	      ENDIF 
				
		SELECT CsrRuta
		LOCATE FOR nombre=TRIM(Csrzona.nombre)+" V"+STR(Csrvendedor.numero,3)
		IF nombre#TRIM(Csrzona.nombre)+" V"+STR(Csrvendedor.numero,3)
			INSERT INTO CsrRuta (id,numero,nombre) ;
			VALUES (lnid,lnNumRuta,TRIM(Csrzona.nombre)+" V"+STR(Csrvendedor.numero,3))		     		
			lnid = lnid + 1
			lnNumRuta = lnNumRuta + 1 
		ENDIF 
	
		SELECT Csrzonaruta
		LOCATE FOR idzona=Csrzona.id AND idruta = Csrruta.id
		IF idzona#Csrzona.id OR idruta # Csrruta.id
			INSERT INTO Csrzonaruta (id,idzona,idruta,switch);
			VALUES (lnidzonaruta,Csrzona.id,Csrruta.id,'00000')
			lnidzonaruta = lnidzonaruta + 1
	    ENDIF 
	      
		SELECT CsrRutaVdor
		LOCATE FOR idvendedor=Csrvendedor.id  AND idruta=Csrruta.id
		IF !FOUND() OR !(idvendedor=Csrvendedor.id  AND  idruta=Csrruta.id )
			INSERT INTO CsrRutaVdor (id,idruta,idvendedor,switch,idfuerzavta);
			VALUES (lnidrutavdor,Csrruta.id,Csrvendedor.id,'00000',lnidfuerzavta )
			lnidrutavdor = lnidrutavdor + 1

		ENDIF 

		lcdias = "2" &&ALLTRIM(STR(CsrRecorrido.carpeta)) Lunes
		FOR i=1 TO LEN(lcdias)
			SELECT CsrCaberuta
			LOCATE FOR idrutavdor=Csrrutavdor.id AND dia=VAL(SUBSTR(lcdias,i,1))
			IF idrutavdor#Csrrutavdor.id OR dia#VAL(SUBSTR(lcdias,i,1))
				INSERT INTO Csrcaberuta (id,idrutavdor,dia) ;
				VALUES (lnidcabeza,Csrrutavdor.id,VAL(SUBSTR(lcdias,i,1)))
				lnidcabeza = lnidcabeza + 1
			ENDIF 
			
			SELECT CsrCuerruta
			COUNT ALL FOR idcaberuta=Csrcaberuta.id TO nOrden
			nOrden = nOrden + 1 
		
			&&IF CsrRecorrido.orden#0
			      SELECT CsrCuerruta
			      LOCATE FOR idcaberuta=Csrcaberuta.id AND idctacte=Csrctacte.id &&AND orden=Csrrecorrido.orden
			      IF idcaberuta#Csrcaberuta.id OR idctacte#Csrctacte.id &&OR orden#CsrRecorrido.orden
	   				INSERT INTO Csrcuerruta (id,idcaberuta,idctacte,orden,turno) ;
	   				VALUES (lnidcuerruta,Csrcaberuta.id,Csrctacte.id,nOrden,1)
	   				lnidcuerruta = lnidcuerruta + 1
				ENDIF 		   				
			&&ENDIF 	   				
		NEXT 
	*ENDIF 
	SELECT CsrRecorrido
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
