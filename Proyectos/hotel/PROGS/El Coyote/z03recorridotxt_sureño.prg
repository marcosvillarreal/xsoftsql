PARAMETERS ldvacio,lcpath,lcBase
ldvacio = IIF(PCOUNT()<1,"",ldvacio)
lcpath = IIF(PCOUNT()<2,"",lcpath)
lcData = lcBase

DO setup
SET PROCEDURE TO proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE TO syserror.prg ADDITIVE  
SET PROCEDURE TO z00_elsure�o ADDITIVE 

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

cArchivo = ADDBS(ALLTRIM(lcpath ))+"clientes.csv"
=LeerClientes(cArchivo)

SELECT CsrDeudor
vista()

LOCAL lnidvdor,lniddepo,lnidflet


   

sELECT distinct VAL(codvendedor) as numero,vendedor FROM CsrDeudor INTO CURSOR FsrVendedor READWRITE 
sELECT distinct zona FROM CsrDeudor INTO CURSOR FsrZona READWRITE 

lnidvdor = RecuperarID('CsrVendedor',Goapp.sucursal10)
lnidflet = RecuperarID('CsrFletero',Goapp.sucursal10)
lniddepo = RecuperarID('CsrDeposito',Goapp.sucursal10)

lnnumero	= 1

lcnombre	= "REPARTIDOR GRAL"
INSERT INTO CsrFletero (id,numero,nombre,direccion,telefono,tipoflete,idctacte,switch);
   			 VALUES (lnidflet,lnnumero,lcnombre,'','',0,0,'00000')
lnidflet = lnidflet + 1
   
lcnombre	= "DEPOSITO "
INSERT INTO CsrDeposito (id,numero,nombre,llevastock);
   			 VALUES (lniddepo,lnnumero,lcnombre,1)
lniddepo = lniddepo + 1


SELECT FsrVendedor
stop()
Oavisar.proceso('S','Procesando '+alias()) 
GO top
SCAN FOR !EOF()
    IF numero=0
       loop
   ENDIF
   lnprevta = 1
   lnestado = 1
   
   lcnombre	= NombreNi(UPPER(FsrVendedor.vendedor))
   INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale,passpreventamobile,activopm);
   			 VALUES (lnidvdor,FsrVendedor.numero,lcnombre,0,1,lnprevta,lnestado,1,0,0,'',1)
   lnidvdor = lnidvdor + 1
	
*!*		lcnombre	= NombreNi(alltrim(UPPER(FsrVendedor.numero)))
*!*		INSERT INTO CsrFletero (id,numero,nombre,direccion,telefono,tipoflete,idctacte,switch);
*!*	   			 VALUES (lnidflet,lnnumero,lcnombre,'','',0,0,'00000')
*!*	   lnidflet = lnidflet + 1
*!*	   
*!*	   lcnombre	= NombreNi(alltrim(UPPER(FsrVendedor.numero)))
*!*	   INSERT INTO CsrDeposito (id,numero,nombre,llevastock);
*!*	   			 VALUES (lniddepo,lnnumero,lcnombre,1)
*!*	   lniddepo = lniddepo + 1
*!*	   
*!*	   lnnumero = lnnumero + 1 
ENDSCAN

SELECT CsrVendedor
GO BOTTOM 
lnnumero	= CsrVendedor.numero + 1

lcnombre	= "VDOR GENERAL"
INSERT INTO Csrvendedor (id,numero,nombre,comision,planilla,prevta,estado,lista,idctacte,acumulavale,passpreventamobile,activopm);
   			 VALUES (lnidvdor,lnnumero,lcnombre,0,1,1,1,1,0,0,'',0)
   			 
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
   lcnombre= NombreNi(alltrim(UPPER(fsrzona.zona)))
   
   INSERT INTO CsrZona (id,numero,nombre,porflete,abrevia);
   			 VALUES (lnid,lnNUMERO,lcnombre,0,fsrzona.zona)
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
SELECT CsrDeudor
Oavisar.proceso('S','Procesando '+alias()) 
GO top
lnNumRuta = 1
SCAN FOR !EOF()
	
	SELECT Csrctacte
	LOCATE FOR val(cnumero)=CsrDeudor.idorigen AND ctadeudor = 1
       IF not(val(cnumero)=CsrDeudor.idorigen AND ctadeudor = 1)
           SELECT CsrDeudor
           LOOP 
       ENDIF 
		
*	IF CsrRecorrido.carpeta#0
		SELECT CsrVendedor
		LOCATE FOR numero=val(CsrDeudor.codvendedor)
		IF numero<>val(CsrDeudor.codvendedor)
			SELECT CsrRecorrido
			LOOP
		ENDIF 	
		
		SELECT CsrZona
		LOCATE FOR abrevia=CsrDeudor.zona
		IF abrevia#CsrDeudor.zona OR EMPTY(CsrDeudor.zona)
			SELECT CsrZona
		 	GO TOP 
	      ENDIF 
				
		SELECT CsrRuta
		LOCATE FOR nombre=LEFT(TRIM(Csrzona.nombre),25)+"-"+strzero(CsrVendedor.numero,3)
		IF nombre#LEFT(TRIM(Csrzona.nombre),25)+"-"+strzero(CsrVendedor.numero,3)
			INSERT INTO CsrRuta (id,numero,nombre) ;
			VALUES (lnid,lnNumRuta,LEFT(TRIM(Csrzona.nombre),25)+"-"+strzero(CsrVendedor.numero,3))		     		
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
	SELECT CsrDeudor
ENDSCAN

Oavisar.proceso('N') 
=MESSAGEBOX('Proceso terminado! ')
CLOSE tables
CLOSE INDEXES
CLOSE DATABASES
