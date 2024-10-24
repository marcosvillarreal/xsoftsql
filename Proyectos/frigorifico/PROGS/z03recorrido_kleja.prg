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
llok = CargarTabla(lcData,'Fletero',.t.)
llok = CargarTabla(lcData,'Ruta',.t.)
llok = CargarTabla(lcData,'RutaVdor',.t.)
llok = CargarTabla(lcData,'CabeRuta',.t.)
llok = CargarTabla(lcData,'CuerRuta',.t.)
llok = CargarTabla(lcData,'FuerzaVta')
llok = CargarTabla(lcData,'PlanCue')

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrLocalidad.* FROM Localidad as CsrLocalidad
ENDTEXT 
=CrearCursorAdapter('CsrLocalidad',lcCmd)

SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

Oavisar.proceso('S','Abriendo archivos') 

USE ALLTRIM(lcpath)+"\vendedor" IN 0 ALIAS CsrVendeVie EXCLUSIVE

USE ALLTRIM(lcpath)+"\clientes" IN 0 ALIAS CsrCliente EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid

lnid = RecuperarID('CsrVendedor',Goapp.sucursal10)

*stop()
SELECT CsrVendeVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF VAL(codvendedo)=0
       loop
   ENDIF
   lnprevta = 1
   lnestado = 1
   lncodigo	= VAL(codvendedo)
   lcnombre	= NombreNi(alltrim(UPPER(CsrvendeVie.desvendedo)))
   INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale);
   			 VALUES (lnid,lncodigo,lcnombre,0,1,lnprevta,lnestado,1,0,0)
   lnid = lnid + 1

ENDSCAN



LOCAL lnidcabeza, lnidrutavdor,lnidzonaruta,lnidcuerruta,lnidzona

lnid = RecuperarID('CsrRuta',Goapp.sucursal10)
*****
lnidcabeza	= RecuperarID('CsrCabeRuta',Goapp.sucursal10)
*******
lnidrutavdor = RecuperarID('CsrRutaVdor',Goapp.sucursal10)
*****
lnidzonaruta = RecuperarID('CsrZonaRuta',Goapp.sucursal10)
*******
lnidcuerruta = RecuperarID('CsrCuerRuta',Goapp.sucursal10)
***
lnidzona	 = RecuperarID('CsrZona',Goapp.sucursal10)

SELECT CsrFuerzaVta
GO TOP 
lnidfuerzavta  = CsrFuerzaVta.id

lnNumZona = 1

stop()
&&Armamos las zonas y recorridos por la ciudad
SELECT CsrCliente
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnNumRuta = 1
SCAN FOR !EOF()

	SELECT Csrctacte
	LOCATE FOR VAL(cnumero)=VAL(CsrCliente.codigo)
	IF VAL(cnumero) # VAL(CsrCliente.codigo)
		SELECT CsrCliente
		LOOP 
	ENDIF 
       		
	SELECT CsrVendedor
	LOCATE FOR numero=VAL(CsrCliente.vendedor)
	IF numero#VAL(CsrCliente.vendedor)
		SELECT CsrCliente
		LOOP
	ENDIF 

	SELECT CsrLocalidad
	LOCATE FOR id = CsrCtacte.idlocalidad
	IF id # CsrCtacte.idlocalidad or CsrCtacte.idlocalidad = 0
		SELECT CsrCliente
		LOOP 
	ENDIF 
	
	SELECT CsrZona
	LOCATE FOR abrevia=LEFT(CsrLocalidad.cpostal,4)
	IF abrevia#LEFT(CsrLocalidad.cpostal ,4)
		
		lcnombre=NombreNi(alltrim(UPPER(CsrLocalidad.nombre)))
   
		INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
		VALUES (lnidzona,lnNUMzona,lcnombre,0,CsrLocalidad.cpostal)
   
		lnidzona = lnidzona + 1
		lnNumZona = lnNumZona + 1

	ENDIF 

	SELECT CsrRuta
	LOCATE FOR nombre=TRIM(Csrzona.nombre)+" "+STR(Csrvendedor.numero,3)
	IF nombre#TRIM(Csrzona.nombre)+" "+STR(Csrvendedor.numero,3)
		INSERT INTO CsrRuta (id,numero,nombre) ;
		VALUES (lnid,lnNumRuta,TRIM(Csrzona.nombre)+" "+STR(Csrvendedor.numero,3))		     		
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

	lcdias = '2' &&Todo al Lunes
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
		
		SELECT CsrCuerruta
		LOCATE FOR idcaberuta=Csrcaberuta.id AND idctacte=Csrctacte.id &&AND orden=Csrrecorrido.orden
		IF idcaberuta#Csrcaberuta.id OR idctacte#Csrctacte.id &&OR orden#CsrRecorrido.orden
			INSERT INTO Csrcuerruta (id,idcaberuta,idctacte,orden,turno) ;
			VALUES (lnidcuerruta,Csrcaberuta.id,Csrctacte.id,nOrden,1)
			lnidcuerruta = lnidcuerruta + 1
		ENDIF 		   				
			   				
	NEXT 
	SELECT CsrCliente
ENDSCAN


Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE IN CsrVendeVie 
USE IN CsrCliente