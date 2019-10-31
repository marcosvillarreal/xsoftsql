*===================
*= ARCHIVO PRINCIPAL
*===================
*
*	VER AL PIE alguna consideracion con respecto a campos tablas
*
clear all
set classlib to
l='j:'
set talk off
lldesarrollo=(_vfp.startmode()#4)

_vfp.AutoYield = .f.

lctituloGestion = "Gesti�n de Ventas"

*!*	If !lldesarrollo
*!*	   If f_activawin(lctituloGestion)
*!*	  
*!*	      =messagebox('Ya Estaba activo !!!!',48,'Informaci�n al Usuario')
*!*	     _Screen.windowstate=2
*!*	      _screen.lockscreen=.f.
*!*	      _screen.visible=.t.
*!*	      _screen.refresh      
*!*				 * El programa ya estaba activo:
*!*	      Return && Termina el programa
*!*	   Endif
*!*	ENDIF

Set cursor off

lccaption=_screen.caption

Set cursor on

lcdd=alltrim(curdir()) && directorio de arranque

cRutaCAE = sys(5)+CURDIR()+"caevacio.jpg"
cLogoFac	= SYS(5)+CURDIR()+"logofac.jpg"
cFirma	= SYS(5)+CURDIR()+"firma.jpg"

If lldesarrollo
   lcdd=L+'\xsoftsql\proyectos\leon\'
*-- RUTA
   _rutaclases =lcdd+'Clases'
   _rutaclased =L+'\xsoftsql\desarrollo\clases'
   _rutabmpd   =L+'\xsoftsql\desarrollo\graficos'
   _rutaprogs  =lcdd+'Progs'
   _rutamenu   =lcdd+'Menus'
   _rutadatos  =lcdd+'Datos'
   _rutabmps   =lcdd+'graphics'
   _rutaforms  =lcdd+'forms'
   _rutaformsb  =lcdd+'forms\bancario'
   _rutaformsu  =lcdd+'forms\util'
   _rutareports=lcdd+'reports' 
   _rutareportsb=lcdd+'reports\bancario'
    _rutaformsDesarrollo =L+'\xsoftsql\desarrollo\forms'
   _rutaffc  =L+'\xsoftsql\desarrollo\clases\ffc'
   _rutalib =    L+'\xsoftsql\desarrollo\lib'
   cRutaCAE	= _rutabmps + '\caevacio.jpg'
   cLogoFAC	= _rutabmps + '\logofac.jpg'
   cFirma	= _rutabmps+"\firma.jpg"

   _rutaformse = lcdd + 'forms\exportar'
   _rutaformsp = lcdd + 'forms\precio'
   _rutaformsb = lcdd + 'forms\bancario'
   _rutaformsc = lcdd + 'forms\caja'
   _rutaformsd = lcdd + 'forms\dinamica'
   _rutaformar  =lcdd + 'forms\articulos'
   _rutaformpe  =lcdd + 'forms\pedidos'
   
   Set default to (lcdd) &&;(lcddc)

   Set path to &_rutaclases,&_rutaprogs,&_rutamenu,&_rutadatos,&_rutabmps,&_rutaforms;
               ,&_rutareports,&_rutaclased,&_rutabmpd,&_rutaffc,&_rutalib;
               ,&_rutaformsb, &_rutareportsb, &_rutaformse, &_rutaformsp, &_rutaformsb;
               ,&_rutaformsu, &_rutaformsc, &_rutaformsd ,&_rutaformsDesarrollo;
               ,&_rutaformar, &_rutaformpe
Endif

*-- CREACION DE OBJETO APLICACION

Set classlib to localaplicacion.vcx additive && Objeto Aplicacion

*-- APERTURA DE CLASES Y ARCHIVOS DE PROCEDIMIENTOS

   SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE  TO  syserror.prg ADDITIVE  
   SET PROCEDURE  TO  syerrhand.prg ADDITIVE  
   SET PROCEDURE TO procfiscal.prg ADDITIVE 
   SET PROCEDURE  TO registry.prg ADDITIVE 
   SET PROCEDURE TO procdesarrollo.prg ADDITIVE 
   SET PROCEDURE TO proc_importar.prg ADDITIVE 
   SET PROCEDURE TO googlemaps.prg ADDITIVE 
       
   SET CLASSLIB  TO  reindexer ADDITIVE 
   SET CLASSLIB  TO  clasesgenerales ADDITIVE 
   SET CLASSLIB  TO  controles ADDITIVE 
   SET CLASSLIB  TO  iabm.vcx ADDITIVE 
   SET CLASSLIB  TO  calc.vcx ADDITIVE  && Calculadora   
   SET CLASSLIB  TO  icontrolespersonalizados ADDITIVE 
   SET CLASSLIB TO onegocioslocal ADDITIVE 
   SET CLASSLIB TO controleslocal ADDITIVE 
   SET CLASSLIB TO rcscalendar ADDITIVE 
   SET CLASSLIB TO _reportlistener.vcx ADDITIVE 
   SET  CLASSLIB  TO  xfrxlib ADDITIVE 
   SET LIBRARY TO xfrxlib.fll ADDITIVE 
   SET CLASSLIB  TO  ZIP ADDITIVE
*clear all

_screen.lockscreen=.t.
_Screen.windowstate=2
_Screen.caption=lctituloGestion
_Screen.icon='help.ico'
_screen.picture= 'fondo51.jpg'
_Screen.closable=.f.
_Screen.visible=.t.

PUBLIC LcConectionString,LcDataSourceType,lcOrigenPublico,PcmsgIU,PcmsgIP,LcWebService,LcLlaveCf,Pnterminal,pnsucursal
PUBLIC lcConectionODBC,lnconectorODBC
   
 STORE '' TO LcConectionString,LcDataSourceType,lcOrigenPublico,LcWebService,lcConectionODBC
 STORE 0 TO Pnterminal,Pnsucursal,lnconectorODBC



PUBLIC OAvisar
Oavisar=CREATEOBJECT('avisar')

Public goapp,ObjReporter

goapp=createobject('app',!lldesarrollo,lldesarrollo)

ObjReporter= CREATEOBJECT("Custom")
ObjReporter.AddProperty('titulo1',"")
ObjReporter.AddProperty('titulo2',"")
ObjReporter.AddProperty('titulo3',"")
ObjReporter.AddProperty('titulo4',"")
ObjReporter.AddProperty('titsucursal',"")
objReporter.AddProperty('logofac',cLogoFac)
ObjReporter.AddProperty('numcae',cRutaCAE)
ObjReporter.AddProperty('firma',cFirma)

PUBLIC ObjInfNeg
ObjInfNeg=CREATEOBJECT("custom")
ObjInfNeg.AddProperty('odata','')

*!*	PUBLIC oFacCAE
*!*	oFACCAE = CREATEOBJECT('oFacElectronica')
*!*	oFacCAE.sw_conexion()

IF TYPE('goApp')='O'
*-- CARGAR PROPIEDADES DE RUTA EN OBJETO APLICACION
	IF lldesarrollo && Aplicacion en modo desarrollo
		goapp.cdefault=set('default')
		goapp.cpath=set('path')
	ELSE  && Aplicacion en modo ejecuci�n
		IF LcDataSourceType = "NATIVE"
			Set defa to (goapp.cdefault)
			Set path to (goapp.cpath)
		ENDIF          
	ENDIF 

	goapp.version = "01.00.00"
	
	PUBLIC  gcicono
	     
	PcmsgIU  = 'Informaci�n al Usuario'
	PcmsgIP  = 'Informaci�n al Programador'
	   
	gcicono=lcdd+'help.ico'
	LcLlaveCf = SPACE(8)
	      
	on error do errorsys
	           		                          
	do setup
	_screen.LockScreen=.f.
	 
	DO directivasfiscal    && en procfiscal.prg
	DO directivasHasar
	
   * =MESSAGEBOX(amodelofiscal[1])	  
   
	= Fwin32()    && funciones api win32
	
	 =ObtenerServidor()
	  
	IF LEN(TRIM(LcConectionString))=0
		DO FORM configbd
		=ObtenerServidor()
	ENDIF    

	PUBLIC loConnDataSource,lcIdObjCon,lcIdObjneg,lcServidor,ObjNeg

	LeerXMLClassID("objetodll.xml")

	If lldesarrollo 
		oavisar.usuario('Conectado a  '+ALLTRIM(goapp.servidor)+'\'+LTRIM(goapp.initcatalo))
	ENDIF 
	
	   * en proc.prg   
	IF ExisteDSN()  			
		IF !ConeccionADO()
			CANCEL 
			CLEAR ALL
			RETURN 
		ENDIF 
	ELSE
		CANCEL 
		CLEAR ALL
		RETURN 
	ENDIF 
	
	WAIT CLEAR 

* en proc.prg

	IF !lldesarrollo 
*!*			IF !LeerVersionExe(1)
*!*				CANCEL
*!*				CLEAR ALL
*!*				RETURN 	
*!*		      ENDIF 
	ENDIF 

	LeerEmpresa()
	    
	Goapp.idusuario           = 0
	Goapp.perfilusuario     = 0
	Goapp.nombreusuario= ""
	Goapp.sucursal10   = Goapp.sucursal   && si sucursal10#0 en proc almacenado de insert suma 10 y concatena el numero de id obtenido, ver odata
	
    _screen.visible=.t.	   
	_screen.lockscreen=.f.
	_screen.Show() 

	DO FORM frmlogin
	
	&&La empresa pudo cambiar si se accedio a otra sucursal
	LeerDatosEmpresa()
	_screen.lockscreen=.t.		 
	
	IF goapp.sucursal = 2
		_screen.picture= 'fondo512.jpg'
	ENDIF 

	LOCAL oMenu
	oDesktop = ''
	oMenu = NEWOBJECT("createmenu","symde.vcx",.NULL.,.T.,odesktop,Goapp.perfilusuario,"'verdana',9","")
	oMenu.createMenu()   
	oMenu = null

	LeerEjercicioPerfil()
	
	DO FORM frmmenu
	   
	_screen.visible=.t.	   
	_screen.lockscreen=.f.

	Read events   
ENDIF

loConnDataSource = null 

cancel all
clear all
 
Return

*-----------------------------
FUNCTION F_ActivaWin(cCaption)
*-----------------------------

LOCAL nHWD
DECLARE INTEGER FindWindow IN WIN32API ;
STRING cNULL,;
STRING cWinName

DECLARE SetForegroundWindow IN WIN32API ;
INTEGER nHandle

DECLARE SetActiveWindow IN WIN32API ;
INTEGER nHandle

DECLARE ShowWindow IN WIN32API ;
INTEGER nHandle, ;
INTEGER nState

nHWD = FindWindow(0, cCaption)
IF nHWD > 0
    * VENTANA YA ACTIVA
    * LA "LLAMAMOS":
    ShowWindow(nHWD,9)

    * LA PONEMOS ENCIMA
    SetForegroundWindow(nHWD)

    * LA ACTIVAMOS
    SetActiveWindow(nHWD)
    RETURN .T.
ELSE
    * VENTANA NO ACTIVA
    RETURN .F.
ENDIF

FUNCTION Fwin32
	DECLARE Beep IN WIN32API INTEGER nFrequency, INTEGER nDuration
RETURN .t.

DEFINE CLASS MiImagen AS IMAGE
	PROCEDURE ResizeFondo
		WITH THIS
		.LEFT = INT(_SCREEN.WIDTH  - .WIDTH)/ 2
		.TOP = INT(_SCREEN.HEIGHT - .HEIGHT)/ 2
		ENDWITH
	ENDPROC
	
	PROCEDURE DESTROY
		UNBINDEVENT(THIS)
	ENDPROC
ENDDEFINE


