*===================
*= ARCHIVO PRINCIPAL
*===================
*
*	VER AL PIE alguna consideracion con respecto a campos tablas
*
clear all
set classlib to
l='c:'
set talk off
lldesarrollo=(_vfp.startmode()#4)

_vfp.AutoYield = .f.

lctituloGestion = "Gestión de Ventas"

*!*	If !lldesarrollo
*!*	   If f_activawin(lctituloGestion)
*!*	  
*!*	      =messagebox('Ya Estaba activo !!!!',48,'Información al Usuario')
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

If lldesarrollo
   lcdd=L+'\xsoftsql\proyectos\robotcae\'
*-- RUTA
   _rutaclases =lcdd+'Clases'
   _rutaclased =L+'\xsoftsql\desarrollo\clases'
   _rutabmpd   =L+'\xsoftsql\desarrollo\graficos'
   _rutaprogs  =lcdd+'Progs'
   _rutamenu   =lcdd+'Menus'
   _rutadatos  =lcdd+'Datos'
   _rutabmps   =lcdd+'graphics'
   _rutaforms  =lcdd+'forms'
   _rutareports=lcdd+'reports' 
    _rutaformsDesarrollo =L+'\xsoftsql\desarrollo\forms'
   _rutaffc  =L+'\xsoftsql\desarrollo\clases\ffc'
   _rutalib =    L+'\xsoftsql\desarrollo\lib'
   
   Set default to (lcdd) &&;(lcddc)

   Set path to &_rutaclases,&_rutaprogs,&_rutamenu,&_rutadatos,&_rutabmps,&_rutaforms;
               ,&_rutareports,&_rutaclased,&_rutabmpd,&_rutaformsDesarrollo,&_rutaffc,&_rutalib
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
   SET PROCEDURE TO notifyicono.prg ADDITIVE 
      
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
_Screen.windowstate=1
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
ObjReporter.AddProperty('numcae',"")

*!*	PUBLIC oFacCAE
*!*	oFACCAE = CREATEOBJECT('oFacElectronica')
*!*	oFacCAE.sw_conexion()

IF TYPE('goApp')='O'
*-- CARGAR PROPIEDADES DE RUTA EN OBJETO APLICACION
	IF lldesarrollo && Aplicacion en modo desarrollo
		goapp.cdefault=set('default')
		goapp.cpath=set('path')
	ELSE  && Aplicacion en modo ejecución
		IF LcDataSourceType = "NATIVE"
			Set defa to (goapp.cdefault)
			Set path to (goapp.cpath)
		ENDIF          
	ENDIF 

	goapp.version = "01.00.00"
	
	PUBLIC  gcicono
	     
	PcmsgIU  = 'Información al Usuario'
	PcmsgIP  = 'Información al Programador'
	   
	gcicono=lcdd+'help.ico'
	LcLlaveCf = SPACE(8)
	      
	on error do errorsys
	           		                          
	do setup
	_screen.LockScreen=.f.
	    
	 =ObtenerServidor()
	  
	IF LEN(TRIM(LcConectionString))=0
		DO FORM configbd
		=ObtenerServidor()
	ENDIF    

	PUBLIC loConnDataSource,lcIdObjCon,lcIdObjneg,lcServidor,ObjNeg

	LeerXMLClassID("objetodll.xml")
  
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

	LeerEmpresa()
	    
	Goapp.idusuario           = 0
	Goapp.perfilusuario     = 0
	Goapp.nombreusuario= ""
	Goapp.sucursal10   = Goapp.sucursal   && si sucursal10#0 en proc almacenado de insert suma 10 y concatena el numero de id obtenido, ver odata
	
	_screen.lockscreen=.f.
	_screen.Show() 
 
	_screen.lockscreen=.f.

	Read events   
ENDIF

loConnDataSource = null 

cancel all
clear all

 
Return
