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

lctituloGestion = "Sync Servidor"

*!*	If !lldesarrollo
*!*	   If f_activawin(lctituloGestion)
*!*	  
*!*	      =messagebox('Ya Estaba activo !!!!',48,'Información al Usuario')
*!*	    *' _Screen.windowstate=2
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
cRutaQR		= SYS(5)+CURDIR()+"qr.jpg"

If lldesarrollo
   lcdd=L+'\xsoftsql\proyectos\comercial\'
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
	_rutalib = L +'\xsoftsql\desarrollo\lib' 
	   
	_fbanco		= _rutaforms + '\bancario'
	_fafip		= _rutaforms + '\afip_otros'
	_fcaja		= _rutaforms + '\caja'
	_fcliente	= _rutaforms + '\cliente'
	_fcpra		= _rutaforms + '\compras'
	_fcontab	= _rutaforms + '\contabilidad'
	_fctacte	= _rutaforms + '\ctacte'
	_festad		= _rutaforms + '\estadisticas'
	_ffaccae	= _rutaforms + '\facelectronica'
	_fotros		= _rutaforms + '\otros'
	_fparame	= _rutaforms + '\parametros'
	_fprovee	= _rutaforms + '\proveedor'
	_fstock		= _rutaforms + '\stock'
	_ftarjeta	= _rutaforms + '\tarjeta'
	_futil		= _rutaforms + '\util'
	_fventa		= _rutaforms + '\ventas'
    	_fhelp		= _rutaforms + '\help'
   	_fsync		= _rutaforms + '\sync'
   	
   _rutareportsban	= _rutareports + '\bancario' 
   
   _rutaempresa		= lcdd+'empresas' 
   _rutaempresa01	= _rutaempresa + '\fortin'
   _rutaempresa02	= _rutaempresa + '\cachitos'
    _rutaempresa03	= _rutaempresa + '\grutamat'
    
   cRutaCAE	= _rutabmps + '\caevacio.jpg'
   cLogoFAC	= _rutabmps + '\logofac.jpg'
    cRutaQR	= _rutabmps + '\qr.jpg'
      
   Set default to (lcdd) &&;(lcddc)

   Set path to &_rutaclases,&_rutaprogs,&_rutamenu,&_rutadatos,&_rutabmps,&_rutaforms;
   				,&_fbanco,&_fafip,&_fcaja,&_fcliente,&_fcpra;
               ,&_fcontab,&_fctacte,&_festad,&_ffaccae,&_fotros,&_fparame,&_fprovee;
               ,&_fstock,&_ftarjeta,&_futil,&_fventa,&_fsync;
               ,&_rutareports,&_rutaclased,&_rutabmpd,&_rutaformsDesarrollo,&_rutaffc,&_rutalib;
               ,&_rutaformsban,&_rutareportsban,&fhelp,&_rutaempresa01,&_rutaempresa02;
               ,&_rutaempresa03
 
ELSE
	*-- RUTA
	l=SYS(5)
   	_rutadatos  =l+lcdd+'Datos'
   
   	Set default to (l+lcdd) &&;(lcddc)

   	Set path to &_rutadatos   
Endif

*-- CREACION DE OBJETO APLICACION

Set classlib to localaplicacion.vcx additive && Objeto Aplicacion

*-- APERTURA DE CLASES Y ARCHIVOS DE PROCEDIMIENTOS

   SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE  TO  syserror.prg ADDITIVE  
   SET PROCEDURE TO procfiscal.prg ADDITIVE 
   SET PROCEDURE TO procdesarrollo.prg ADDITIVE 
   SET PROCEDURE  TO registry.prg ADDITIVE       
   SET PROCEDURE TO googlemaps.prg ADDITIVE 
   SET PROCEDURE TO  foxypreviewercaller ADDITIVE 
   SET PROCEDURE TO FoxBarcodeQR ADDITIVE
   
   SET CLASSLIB  TO  reindexer ADDITIVE 
   SET CLASSLIB  TO  clasesgenerales ADDITIVE 
   SET CLASSLIB  TO  controleslocal ADDITIVE 
   SET CLASSLIB  TO  controles ADDITIVE 
   SET CLASSLIB  TO  controlesdashboard ADDITIVE
   SET CLASSLIB  TO  iabm.vcx ADDITIVE 
   SET CLASSLIB  TO  calc.vcx ADDITIVE  && Calculadora   
   SET CLASSLIB  TO  icontrolespersonalizados ADDITIVE 
   SET CLASSLIB TO onegocioslocal ADDITIVE 
   SET CLASSLIB TO rcscalendar ADDITIVE 
   SET CLASSLIB TO _reportlistener.vcx ADDITIVE 
   SET  CLASSLIB  TO  xfrxlib ADDITIVE 
   SET LIBRARY TO xfrxlib.fll ADDITIVE 
   SET CLASSLIB  TO  ZIP ADDITIVE 
   set classlib to systray ADDITIVE
*clear all

_screen.lockscreen=.t.
_Screen.windowstate=2
_Screen.caption=lctituloGestion
_Screen.icon='help.ico'
_screen.picture= 'fondoscreen.jpg'
_Screen.closable=.f.
_Screen.visible=.t.

PUBLIC LcConectionString,LcDataSourceType,lcOrigenPublico,PcmsgIU,PcmsgIP,LcWebService,LcLlaveCf,Pnterminal,pnsucursal
PUBLIC lcConectionODBC,lnconectorODBC
PUBLIC oConfigTermi
   
 STORE '' TO LcConectionString,LcDataSourceType,lcOrigenPublico,LcWebService,lcConectionODBC
 STORE 0 TO Pnterminal,Pnsucursal,lnconectorODBC,pidsistema

PUBLIC OAvisar
Oavisar=CREATEOBJECT('avisar')

Public goapp,ObjReporter

goapp=createobject('app',!lldesarrollo,lldesarrollo)

ObjReporter= CREATEOBJECT("Custom")
ObjReporter.AddProperty('titulo1',"")
ObjReporter.AddProperty('titulo2',"")
ObjReporter.AddProperty('titulo3',"")
ObjReporter.AddProperty('titulo4',"")
objReporter.AddProperty('logofac',cLogoFac)
ObjReporter.AddProperty('numcae',cRutaCAE)
ObjReporter.AddProperty('fileqr',cRutaQR)

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
	_screen.LockScreen=.t.
	
	LeerConfigTermi()
	
	oavisar.proceso('S','Inicializando el sistema, aguarde unos instantes por favor ...')

    WAIT WINDOW "Verificando ActiveX instalados ..." nowait
    DO Verifica_OCX WITH "Check"
	
*!*		**** aca comienza la parte de posicionamiento del escritorio
	PUBLIC oscreen    
	LeerXML("screen.xml",@oscreen)  && rescato la posicion de la _screen	
	try
		_screen.Top=ABS(oscreen.top)
		_screen.Left=ABS(oscreen.left)
	CATCH
		_screen.Top=38
		_screen.Left=1
	ENDTRY	
	_screen.height=oscreen.height
	_screen.width=oscreen.width
	_screen.AutoCenter = .T.
	_screen.LockScreen=.f.

	PUBLIC oHandler
    	oHandler=NEWOBJECT("myhandler")
    	BINDEVENT(_SCREEN,"Resize",oHandler,"myresize")    
    	BINDEVENT(_SCREEN,"Moved",oHandler,"mymoved")
	***** fin posicionamiento escritorio
	
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
	
	If lldesarrollo 
		oavisar.usuario('Conectado a  '+ALLTRIM(goapp.servidor)+'\'+LTRIM(goapp.initcatalo))
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
	
	DO FORM frmlogin WITH .t.
		 
	LOCAL oMenu
	oDesktop = ''
	oMenu = NEWOBJECT("createmenu","symde.vcx",.NULL.,.T.,odesktop,Goapp.perfilusuario,"'verdana',9","","XML")
	oMenu.createMenu()   
	oMenu = null

	LeerEjercicioPerfil()
	
	_screen.visible=.t.	   
	_screen.lockscreen=.f.
	
	DO FORM frmmenu_xml
	
	DO FORM regproceso_sync
	
	Read events   
ENDIF

loConnDataSource = null 

cancel all
clear all

Return

*-----------------------------
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

*DEFINE CLASS MiImagen AS IMAGE
*	PROCEDURE ResizeFondo
*		WITH THIS
*		.LEFT = INT(_SCREEN.WIDTH  - .WIDTH)/ 2
*		.TOP = INT(_SCREEN.HEIGHT - .HEIGHT)/ 2
*		ENDWITH
*	ENDPROC
*	
*	PROCEDURE DESTROY
*		UNBINDEVENT(THIS)
*	ENDPROC
*ENDDEFINE

DEFINE CLASS myhandler AS Session
   PROCEDURE myresize
      IF ISNULL(oscreen) THEN
         UNBINDEVENTS(THIS)
      ELSE
		oscreen.Top=_screen.top
		oscreen.Left=_screen.left
		oscreen.height=_screen.height
		oscreen.width=_screen.width		 
 	  *=Oavisar.usuario('resize '+STR(oscreen.width,5),0)      
      *   _obrowser.left = _SCREEN.Width - _obrowser.width
      ENDIF
   RETURN
   PROCEDURE mymoved
      IF ISNULL(oscreen) THEN
         UNBINDEVENTS(THIS)
      ELSE
		oscreen.Top=_screen.top
		oscreen.Left=_screen.left
		oscreen.height=_screen.height
		oscreen.width=_screen.width		       
	 * =Oavisar.usuario('move '+STR(oscreen.width,5),0)      
      *   _obrowser.left = _SCREEN.Width - _obrowser.width
      ENDIF
   RETURN
   
ENDDEFINE
