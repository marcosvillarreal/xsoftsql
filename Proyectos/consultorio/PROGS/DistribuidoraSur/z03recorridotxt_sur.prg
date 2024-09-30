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
llok = CargarTabla(lcData,'PlanCue')
llok = CargarTabla(lcData,'Fletero',.t.)
llok = CargarTabla(lcData,'Deposito',.t.)

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

Oavisar.proceso('S','Abriendo archivos') 
SET SAFETY ON
CREATE CURSOR CsrLista (deta01 c(250),deta02 c(250),deta03 c(250) )
CREATE CURSOR CsrRecorrido (Codigo c(8),Vendedor c(3),Zona c(3))
Oavisar.proceso('S','Abriendo archivos') 

SELECT CsrLista
cArchivo = ALLTRIM(lcpath )+"\clients.txt"
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

*STOP()
SCAN 
	lnCantCampo = 12 &&Hay un campo vacio
	lnSiguienteOcurrencia = 1
	lnCamposLeidos = 1 &&Campos de CsrLista
	lcNomCampo = "CsrLista.deta"+strzero(lnCamposLeidos,2)

	IF AT(lcDelimitador,deta01)=1 AND (AT(lcDelimitador,deta01,2)=AT(lcDelimitador,deta01)+1 OR AT(lcDelimitador,deta01,3)=AT(lcDelimitador,deta01,2)+1)
		LOOP 
	ENDIF 
	
	IF AT(lcDelimitador,deta01)=lnPrimeraOcurrencia
		leiunarticulo = .t.
		STORE "" TO lcAcarreo
		STORE "" TO lcCodigo,lcCategoria,lcNombre,lcDireccion,LcLocalidad,lcCodPostal,lcProvincia
		STORE "" TO lcTelefono,lcTelefono2,lcFax,lcCelular,lcEmail,lcfecAlta,lcTipoDoc,lcDocumento
		STORE "" TO lcTipoIVA,lcVendedor,lcZona
		
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
			lcCodigo		= UPPER(LimpiarCadena(IIF(j + i=1,lcCadena,lcCodigo)))
*!*				lcCategoria		= UPPER(LimpiarCadena(IIF(j + i=3,lcCadena,lcCategoria)))
			lcNombre		= UPPER(LimpiarCadena(IIF(j + i=2,lcCadena,lcNombre)))
*!*				lcDireccion		= UPPER(LimpiarCadena(IIF(j + i=5,lcCadena,lcDireccion)))
*!*				LcLocalidad		= UPPER(LimpiarCadena(IIF(j + i=6,lcCadena,lcLocalidad)))
*!*				lcCodPostal		= UPPER(LimpiarCadena(IIF(j + i=7,lcCadena,lcCodPostal)))
*!*				lcProvincia		= UPPER(LimpiarCadena(IIF(j + i=8,lcCadena,lcProvincia)))
*!*				lcTelefono		= UPPER(LimpiarCadena(IIF(j + i=10,lcCadena,lcTelefono)))
*!*				lcTelefono2		= UPPER(LimpiarCadena(IIF(j + i=11,lcCadena,lcTelefono2)))
*!*				lcFax			= UPPER(LimpiarCadena(IIF(j + i=12,lcCadena,lcFax)))
*!*				lcCelular		= UPPER(LimpiarCadena(IIF(j + i=13,lcCadena,lcCelular)))
*!*				lcEmail			= UPPER(LimpiarCadena(IIF(j + i=14,lcCadena,lcEmail)))
*!*				lcfecAlta		= IIF(j + i=19,lcCadena,lcFecAlta)
*!*				lcTipoDoc		= UPPER(LimpiarCadena(IIF(j + i=22,lcCadena,lcTipoDoc)))
*!*				lcDocumento		= UPPER(LimpiarCadena(IIF(j + i=23,lcCadena,lcDocumento)))
*!*				lcTipoIVA		= UPPER(LimpiarCadena(IIF(j + i=25,lcCadena,lcTipoIVA)))
			*lcVendedor		= UPPER(LimpiarCadena(IIF(j + i=9,lcCadena,lcVendedor)))
			lcZona			= UPPER(LimpiarCadena(IIF(j + i=11,lcCadena,lcZona)))
							
			lnSiguienteOcurrencia = lnPos + 1
			i = i + 1
		ENDDO 
		lnSiguienteOcurrencia = 13
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
		
		INSERT INTO CsrRecorrido (Codigo,Vendedor,Zona) ;
		values (lcCodigo,LEFT(lcCodigo,1),lcZona)
				
		*replace descripcion WITH lmDescripcion IN FsrArticulo
		leiunarticulo = .f.
	ENDIF 
ENDSCAN 

SELECT CsrRecorrido
*vista()

LOCAL lnidvdor,lniddepo,lnidflet


   

sELECT distinct vendedor as numero FROM CsrRecorrido INTO CURSOR FsrVendedor READWRITE 
sELECT distinct zona as numero FROM CsrRecorrido INTO CURSOR FsrZona READWRITE 

lnidvdor = RecuperarID('CsrVendedor',Goapp.sucursal10)
lnidflet = RecuperarID('CsrFletero',Goapp.sucursal10)
lniddepo = RecuperarID('CsrDeposito',Goapp.sucursal10)

lnnumero	= 1

lcnombre	= "VDOR GENERAL"
INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale,passpreventamobile,activopm);
   			 VALUES (lnidvdor,lnnumero,lcnombre,0,1,1,1,1,0,0,'',0)
lnidvdor = lnidvdor + 1

lcnombre	= "REPARTIDOR GRAL"
INSERT INTO CsrFletero (id,numero,nombre,direccion,telefono,tipoflete,idctacte,switch);
   			 VALUES (lnidflet,lnnumero,lcnombre,'','',0,0,'00000')
lnidflet = lnidflet + 1
   
lcnombre	= "DEPOSITO "
INSERT INTO CsrDeposito (id,numero,nombre,llevastock);
   			 VALUES (lniddepo,lnnumero,lcnombre,1)
lniddepo = lniddepo + 1


lnnumero = lnnumero + 1 

*stop()

SELECT FsrVendedor
*vista()

Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF VAL(numero)=0
       *loop
   ENDIF
   lnprevta = 1
   lnestado = 1
   
   lcnombre	= NombreNi(alltrim(UPPER(FsrVendedor.numero)))
   INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale,passpreventamobile,activopm);
   			 VALUES (lnidvdor,lnnumero,lcnombre,0,1,lnprevta,lnestado,1,0,0,'',1)
   lnidvdor = lnidvdor + 1
	
	lcnombre	= NombreNi(alltrim(UPPER(FsrVendedor.numero)))
	INSERT INTO CsrFletero (id,numero,nombre,direccion,telefono,tipoflete,idctacte,switch);
   			 VALUES (lnidflet,lnnumero,lcnombre,'','',0,0,'00000')
   lnidflet = lnidflet + 1
   
   lcnombre	= NombreNi(alltrim(UPPER(FsrVendedor.numero)))
   INSERT INTO CsrDeposito (id,numero,nombre,llevastock);
   			 VALUES (lniddepo,lnnumero,lcnombre,1)
   lniddepo = lniddepo + 1
   
   lnnumero = lnnumero + 1 
ENDSCAN


lcnombre	= "DEP VACIOS/ROTOS"
INSERT INTO CsrDeposito (id,numero,nombre,llevastock);
   			 VALUES (lniddepo,lnnumero,lcnombre,0)
lniddepo = lniddepo + 1


lnid = RecuperarID('CsrZona',Goapp.sucursal10)
lnnumero = 1
SELECT FsrZona
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()  
   lcnombre= NombreNi(alltrim(UPPER(fsrzona.numero)))
   
   INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
   			 VALUES (lnid,lnNUMERO,lcnombre,0,fsrzona.numero)
   lnnumero = lnnumero + 1 
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
	
	IF alltrim(CsrRecorrido.codigo)='LMM50'
		stop()
	ENDIF 
	
	SELECT Csrctacte
	LOCATE FOR ALLTRIM(referencia)=alltrim(CsrRecorrido.codigo) AND ctadeudor = 1
       IF not(ALLTRIM(referencia)=alltrim(CsrRecorrido.codigo) AND ctadeudor = 1)
           SELECT CsrRecorrido
           LOOP 
       ENDIF 
		
*	IF CsrRecorrido.carpeta#0
		SELECT CsrVendedor
		LOCATE FOR left(lTRIM(nombre),1)=ALLTRIM(CsrRecorrido.vendedor)
		IF RIGHT(RTRIM(nombre),1)#(CsrRecorrido.vendedor)
			SELECT CsrRecorrido
			LOOP
		ENDIF 	
		
		SELECT CsrZona
		LOCATE FOR abrevia=CsrRecorrido.zona
		IF abrevia#CsrRecorrido.zona OR EMPTY(CsrRecorrido.zona)
			SELECT CsrZona
		 	GO TOP 
	      ENDIF 
				
		SELECT CsrRuta
		LOCATE FOR nombre=TRIM(Csrzona.nombre)+"-"+RIGHT(RTRIM(CsrVendedor.nombre),1)
		IF nombre#TRIM(Csrzona.nombre)+"-"+RIGHT(RTRIM(CsrVendedor.nombre),1)
			INSERT INTO CsrRuta (id,numero,nombre) ;
			VALUES (lnid,lnNumRuta,TRIM(Csrzona.nombre)+"-"+RIGHT(RTRIM(CsrVendedor.nombre),1))		     		
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
