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
SET SAFETY ON

IF !llok
	RETURN .f.
ENDIF

Oavisar.proceso('S','Abriendo archivos') 

USE ALLTRIM(lcpath)+"\viajante" IN 0 ALIAS CsrVendeVie EXCLUSIVE

USE ALLTRIM(lcpath)+"\clientes" IN 0 ALIAS CsrCliente EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid

lnid = RecuperarID('CsrVendedor',Goapp.sucursal10)

SELECT CsrVendeVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF VAL(CsrvendeVie.viajante)=0
       loop
   ENDIF
   lnprevta =1
   lnestado = 1
   lcnombre=NombreNi(alltrim(UPPER(CsrvendeVie.nombre)))
   INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale);
   			 VALUES (lnid,VAL(CsrvendeVie.viajante),lcnombre,0,1,lnprevta,lnestado,1,0,0)
   lnid = lnid + 1

ENDSCAN

lnid = RecuperarID('CsrFletero',Goapp.sucursal10)


SELECT distinct LEFT(zona,1) as cZona FROM CsrCliente INTO CURSOR CsrZonasVie 
lnid = RecuperarID('CsrZona',Goapp.sucursal10)

lnNumero = 1
SELECT CsrZonasVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()  
   lcnombre='ZONA '+CsrZonasVie.cZona
       
   INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
   			 VALUES (lnid,lnNUMERO,lcnombre,0,Csrzonasvie.cZona)
   
   lnid = lnid + 1
   lnNumero = lnNumero + 1
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

SELECT CsrCliente
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnNumRuta = 1
SCAN FOR !EOF()
	
*!*		SELECT CsrRecorrido
*!*		LOCATE FOR cliente = CsrCliente.numero AND carpeta = CsrCliente.carpeta
*!*		IF NOT (cliente = CsrCliente.numero AND carpeta = CsrCliente.carpeta)
*!*			SELECT CsrCliente
*!*			LOOP 
*!*		ENDIF 
	
	SELECT Csrctacte
	LOCATE FOR alltrim(email)=ALLTRIM(CsrCliente.cliente)
	IF alltrim(email) # ALLTRIM(CsrCliente.cliente)
		SELECT CsrCliente
		LOOP 
	ENDIF 
	
	DO CASE
	CASE LEFT(CsrCliente.zona,1)$"VPBC"
		nVendedor = 3
	CASE LEFT(CsrCliente.zona,1)$"DNESRTG"
		nVendedor = 1
	OTHERWISE
		nVendedor = 2
	ENDCASE

		SELECT CsrVendedor
		LOCATE FOR numero=nVendedor
		IF numero#nVendedor
			SELECT CsrCliente
			LOOP
		ENDIF 

		SELECT CsrZona
		LOCATE FOR abrevia=LEFT(CsrCliente.zona,1)
		IF abrevia#LEFT(CsrCliente.zona,1) OR EMPTY(CsrCliente.zona)
			SELECT CsrZona
		 	GO TOP 
	      ENDIF 
				
		SELECT CsrRuta
		LOCATE FOR nombre="RUTA "+CsrZona.abrevia
		IF nombre#"RUTA "+CsrZona.abrevia
			INSERT INTO CsrRuta (id,numero,nombre) ;
			VALUES (lnid,lnNumRuta,"RUTA "+CsrZona.abrevia)		     		
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

		lcdias = "2"&&ALLTRIM(STR(CsrRecorrido.carpeta))
		FOR i=1 TO LEN(lcdias)
			SELECT CsrCaberuta
			LOCATE FOR idrutavdor=Csrrutavdor.id AND dia=VAL(SUBSTR(lcdias,i,1))
			IF idrutavdor#Csrrutavdor.id OR dia#VAL(SUBSTR(lcdias,i,1))
				INSERT INTO Csrcaberuta (id,idrutavdor,dia) ;
				VALUES (lnidcabeza,Csrrutavdor.id,VAL(SUBSTR(lcdias,i,1)))
				lnidcabeza = lnidcabeza + 1
			ENDIF 
			*IF CsrRecorrido.orden#0
			      SELECT CsrCuerruta
			      LOCATE FOR idcaberuta=Csrcaberuta.id AND idctacte=Csrctacte.id 
			      IF idcaberuta#Csrcaberuta.id OR idctacte#Csrctacte.id 
	   				INSERT INTO Csrcuerruta (id,idcaberuta,idctacte,orden,turno) ;
	   				VALUES (lnidcuerruta,Csrcaberuta.id,Csrctacte.id,0,1)
	   				lnidcuerruta = lnidcuerruta + 1
				ENDIF 		   				
			*ENDIF 	   				
		NEXT 
	*ENDIF 
	SELECT CsrCliente
ENDSCAN

replace ALL email WITH "" IN CsrCtacte

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE in CsrzonasVie 
USE IN CsrVendeVie 
USE IN CsrCliente