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

USE ALLTRIM(lcpath)+"\gestion\zona" IN 0 ALIAS CsrzonasVie EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\vendedor" IN 0 ALIAS CsrVendeVie EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\repartid" IN 0 ALIAS CsrFleteroVie EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\carpetas" IN 0 ALIAS CsrRecorrido EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\noventa" IN 0 ALIAS CsrNoventa EXCLUSIVE

USE ALLTRIM(lcpath)+"\gestion\clientes" IN 0 ALIAS CsrCliente EXCLUSIVE

Oavisar.proceso('S','Procesando '+alias()) 

LOCAL lnid

lnid = RecuperarID('CsrVendedor',Goapp.sucursal10)

SELECT CsrVendeVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF numero=0
       loop
   ENDIF
   lnprevta =1
   lnestado = 1
   lcnombre=NombreNi(alltrim(UPPER(CsrvendeVie.nombre)))
   INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale);
   			 VALUES (lnid,CsrvendeVie.numero,lcnombre,Csrvendevie.comision,1,lnprevta,lnestado,1,0,0)
   lnid = lnid + 1

ENDSCAN

lnid = RecuperarID('CsrFletero',Goapp.sucursal10)

SELECT CsrFleteroVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF numero=0
       loop
   	ENDIF
   	lnprevta =1
   	lnestado = 1
	lnnumero = CsrFleteroVie.numero
   	* agregado 19/08 nombres con �
   	lcnombre=NombreNi(alltrim(UPPER(CsrFleteroVie.nombre)))
	lnnumcli=CsrFleteroVie.cliente
	
   	SELECT CsrCtacte
   	LOCATE FOR VAL(cnumero) = lnnumcli
   	lnidctacte = IIF(FOUND() AND VAL(cnumero) = lnnumcli,CsrCtacte.id,0)

   	INSERT INTO Csrfletero (id,numero,nombre,direccion,telefono,tipoflete,idctacte,switch);
   	VALUES (lnid,lnnumero,lcnombre,"","",0,lnidctacte,"00000")
           
	lnid = lnid + 1
	SELECT CsrFleteroVie
ENDSCAN

lnid = RecuperarID('CsrZona',Goapp.sucursal10)

lnNumero = 1
SELECT CsrZonasVie
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()  
   lcnombre=NombreNi(alltrim(UPPER(CsrzonasVie.nombre)))
       
   INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
   			 VALUES (lnid,lnNUMERO,lcnombre,0,Csrzonasvie.numero)
   
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

SELECT CsrRecorrido
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnNumRuta = 1
SCAN FOR !EOF()

	SELECT Csrctacte
	LOCATE FOR VAL(cnumero)=CsrRecorrido.cliente
       IF VAL(cnumero) # CsrRecorrido.cliente
           SELECT CsrRecorrido
           LOOP 
       ENDIF 
       
       SELECT CsrCliente
	LOCATE FOR numero = CsrRecorrido.cliente
	IF numero #  CsrRecorrido.cliente
		SELECT CsrRecorrido
		LOOP 
	ENDIF 
		
	IF CsrRecorrido.carpeta#0
		SELECT CsrVendedor
		LOCATE FOR numero=CsrRecorrido.vendedor
		IF numero#CsrRecorrido.vendedor
			SELECT CsrRecorrido
			LOOP
		ENDIF 
		
		SELECT CsrZona
		LOCATE FOR abrevia=CsrCliente.zona
		IF abrevia#CsrCliente.zona OR EMPTY(CsrCliente.zona)
			SELECT CsrZona
		 	GO TOP 
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

		lcdias = ALLTRIM(STR(CsrRecorrido.carpeta))
		FOR i=1 TO LEN(lcdias)
			SELECT CsrCaberuta
			LOCATE FOR idrutavdor=Csrrutavdor.id AND dia=VAL(SUBSTR(lcdias,i,1))
			IF idrutavdor#Csrrutavdor.id OR dia#VAL(SUBSTR(lcdias,i,1))
				INSERT INTO Csrcaberuta (id,idrutavdor,dia) ;
				VALUES (lnidcabeza,Csrrutavdor.id,VAL(SUBSTR(lcdias,i,1)))
				lnidcabeza = lnidcabeza + 1
			ENDIF 
			IF CsrRecorrido.orden#0
			      SELECT CsrCuerruta
			      LOCATE FOR idcaberuta=Csrcaberuta.id AND idctacte=Csrctacte.id AND orden=Csrrecorrido.orden
			      IF idcaberuta#Csrcaberuta.id OR idctacte#Csrctacte.id OR orden#Csrdeudor.orden
	   				INSERT INTO Csrcuerruta (id,idcaberuta,idctacte,orden,turno) ;
	   				VALUES (lnidcuerruta,Csrcaberuta.id,Csrctacte.id,CsrRecorrido.orden,1)
	   				lnidcuerruta = lnidcuerruta + 1
				ENDIF 		   				
			ENDIF 	   				
		NEXT 
	ENDIF 
	SELECT CsrRecorrido
ENDSCAN


SELECT CsrCliente
GO TOP 
SCAN 
	SELECT CsrRecorrido
	LOCATE FOR cliente = CsrCliente.numero
	IF FOUND() AND cliente = CsrCliente.numero
		SELECT CsrCliente
		LOOP 
	ENDIF 

	&&Si esta en Ctacte pero no en el recorrido lo marcamos como bloqueado
	SELECT Csrctacte
	LOCATE FOR VAL(cnumero)=CsrCliente.numero
    	IF VAL(cnumero) = CsrCliente.numero AND CsrCtacte.ctalogistica=0
	    replace estadocta WITH 1 IN CsrCtacte
	    SELECT CsrCliente
	    LOOP 
    ENDIF 
        
    SELECT CsrCliente
ENDSCAN 

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
	
USE in CsrzonasVie 
USE IN CsrVendeVie 
USE IN CsrFleteroVie 
USE IN CsrRecorrido 
USE IN CsrNoventa 
USE IN CsrCliente