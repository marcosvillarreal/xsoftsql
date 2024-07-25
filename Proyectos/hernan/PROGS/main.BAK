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
PUBLIC lldesarrollo 
lldesarrollo=(_vfp.startmode()#4)

_vfp.AutoYield = .f.

lctituloGestion = "Gestión de Ventas"

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
   lcdd=L+'\xsoftsql\proyectos\hernan\'
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
   _rutafutil  =lcdd+'forms\util'
   _rutafcont  =lcdd+'forms\contabilidad'
   _rutafctacte  =lcdd+'forms\CTACTE'
    _rutafcpra  =lcdd+'forms\compras'
   _rutaformsDesarrollo =L+'\xsoftsql\desarrollo\forms'
   _rutaffc  =L+'\xsoftsql\desarrollo\clases\ffc'
   _rutalib  =L+'\xsoftsql\desarrollo\lib'   
    _rutafvta  =lcdd+'forms\ventas'
     
   Set default to (lcdd) &&;(lcddc)

   Set path to &_rutaclases,&_rutaprogs,&_rutamenu,&_rutadatos,&_rutabmps,&_rutaforms;
               ,&_rutareports,&_rutaclased,&_rutabmpd,&_rutaformsDesarrollo,&_rutaffc,&_rutalib;
               ,&_rutafutil,&_rutafcont,&_rutafctacte,&_rutafcpra  ,&_rutafvta  
   
   cRutaCAE	= _rutabmps + '\caevacio.jpg'
   cLogoFAC	= _rutabmps + '\logofac.jpg'
   cRutaQR	= _rutabmps + '\qr.jpg'							  
   
Endif

*-- CREACION DE OBJETO APLICACION

Set classlib to localaplicacion.vcx additive && Objeto Aplicacion

*-- APERTURA DE CLASES Y ARCHIVOS DE PROCEDIMIENTOS

   SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE  TO  syserror.prg ADDITIVE  
   SET PROCEDURE TO procfiscal.prg ADDITIVE 
   SET PROCEDURE TO procdesarrollo.prg ADDITIVE 
   SET PROCEDURE  TO registry.prg ADDITIVE       
   SET PROCEDURE TO balanzasystel.prg ADDITIVE 
   SET PROCEDURE TO googlemaps.prg ADDITIVE 
   SET PROCEDURE TO  foxypreviewercaller ADDITIVE 
   SET PROCEDURE TO FoxBarcodeQR ADDITIVE												  
   
   SET CLASSLIB  TO  reindexer ADDITIVE 
   SET CLASSLIB  TO  clasesgenerales ADDITIVE 
   SET CLASSLIB  TO  controleslocal ADDITIVE 
   SET CLASSLIB  TO  controles ADDITIVE 
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
   SET CLASSLIB  TO  controlesmenu ADDITIVE 
   SET CLASSLIB  TO  controlesdashboard ADDITIVE
    SET CLASSLIB TO _environ.vcx ADDITIVE  
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
PUBLIC oConfigTermi,pidsistema			   
   
 STORE '' TO LcConectionString,LcDataSourceType,lcOrigenPublico,LcWebService,lcConectionODBC
 STORE 0 TO Pnterminal,Pnsucursal,lnconectorODBC

pidsistema = 1

PUBLIC OAvisar
Oavisar=CREATEOBJECT('avisar')

Public goapp,ObjReporter

_REPORTOUTPUT  = FULLPATH("REPORTOUTPUT.APP")
  
DO SYSTEM.APP

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
	
	goapp.version = "04.00.02"
	
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
	
	oConfigTermi.controlskin = 'FALSE'
	
*!*		IF oConfigTermi.controlskin = 'TRUE'
*!*			* Herramienta VFPsControlSkin
*!*			IF FILE("VFPsControlSkin.Exe")
*!*			   VFPsControlSkin(APPLICATION,_SCREEN,"8") && SE ENVIA EL STYLE W8
*!*			   *!* NUEVO 
*!*			   *!* AGREGAR BARA DE ESTADO Y HERRAMIENTAS
*!*			   IF VFPs_AddBar(_SCREEN,.T.) THEN 
*!*			      *!* AGREGAR PANEL AL ESTATUS BAR
*!*			      VFPs_AddPanelStatusBar (_SCREEN,"Terminal: " + SYS(0))
*!*			   ENDIF
*!*			ENDIF
*!*			*!* FIN INICIO
*!*			*!* LLENAR PARAMETROS VFPS MESSAGEBOX
*!*			_SCREEN.llHyperLinks  = .T.                 &&COLOCAR EN .T. SI SE DESEA USAR HYPERLINKS.
*!*			_SCREEN.lcTituloText  = "Atención !!"       &&TITULO OPCIONAL QUE DESEAMOS VISUALIZAR ANTES DEL MENSAJE EN EL VFPS MESSAGEBOX
*!*			_SCREEN.lcFooterText  = "<A HREF=" + ["] + "" + ["] + ">GM SOLUTIONS " + ALLTRIM(STR(YEAR(DATE()))) + "</A> Todos los Derechos Reservados"
*!*			_SCREEN.llVista8      = .F.				    &&SI DESEA USAR EL ESTILO DE VFPS MESSAGEBOX DE WINDOWS 8 COLOCARLO EN .T.
*!*			_SCREEN.lnDialogWidth = 0					&&TAMAÑO DE LA VENTANA DE VFPS MESSAGEBOX
*!*			** Herramienta VFPsControlSkin
*!*		ENDIF 
	
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
	
	DO FORM frmlogin
	
	TEXT TO lcCmd TEXTMERGE NOSHOW 
	SELECT CsrParaVario.* FROM ParaVario as CsrParaVario WHERE nombre='XML<<strzero(goapp.terminal,4)>>'
	ENDTEXT 
	=CrearCursorAdapter('CsrParaVario',lcCmd)
	
	****destino archivos xml
	*stop()
	LOCATE FOR nombre="XML"+strzero(goapp.terminal,4)
	IF nombre="XML"+strzero(goapp.terminal,4)
		lcDestinoXML = CsrParaVario.detalle

		goapp.rutasync = lcDestinoXML
		IF LEN(LTRIM(lcDestinoXML))#0
			IF !DIRECTORY(lcDestinoXML)
				MKDIR &lcDestinoXML
			ENDIF 
		ENDIF 
	ENDIF 
		 
	LOCAL oMenu
	oDesktop = ''
	oMenu = NEWOBJECT("createmenu","symde.vcx",.NULL.,.T.,odesktop,Goapp.perfilusuario,"'verdana',9","")
	oMenu.createMenu()   
	oMenu = null

	LeerEjercicioPerfil()
	
	
	_screen.visible=.t.	   
	_screen.lockscreen=.f.
	
	DO FORM frmmenu3
	
	*IF oConfigTermi.ActivarSyncSucursal='TRUE'
	*	EjecutaMenu('regproceso_sync')
	*ENDIF 
	
	public pcTextoBalloon, poSysTray, poTimer
  
	  DO SETS_INICIALES
	  
	  DO DECLARAR_FUNCIONES_API
  
		 
*!*		poSysTray = CreateObject("WALTER_SYSTRAY")
*!*	  
*!*	  
*!*		  IF Vartype(poSysTray) == "O" THEN       && Si se pudo crear el objeto
	  	poTimer   = CreateObject("WALTER_TIMER")
*!*		  		
*!*		    #DEFINE ICONO_NADA  0
*!*		    #DEFINE ICONO_INFO  1
*!*		    #DEFINE ICONO_AVISO 2
*!*		    #DEFINE ICONO_ERROR 3
*!*		    *poSysTray.ShowBalloonTip(pcTextoBalloon, "Ejemplo de un balloon", ICONO_NADA, 0)
*!*		    *poSysTray.RemoveIconFromSystray()     && El icono del menú es ocultado, el usuario no podrá verlo
*!*		    *READ EVENTS                           && Procesa los eventos, o sea que le permite al usuario elegir opciones del menú
*!*		    
	    IF oConfigTermi.ShowBalloonTip = 'FALSE'
	    	poTimer.Enabled = .f.
	    ENDIF 
*!*		  ENDIF
	  
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

PROCEDURE DECLARAR_FUNCIONES_API
  
  DECLARE INTEGER ShellExecute IN SHELL32.Dll ;
          INTEGER nWinHandle , ;
          STRING  cOperation , ;
          STRING  cFileName  , ;
          STRING  cParameters, ;
          STRING  cDirectory , ;
          INTEGER nShowWindow
  
ENDPROC
*
*
PROCEDURE MI_PROCEDURE_SALUDA
  
  =Messagebox("Hola, ¿cómo estás hoy?")
  
ENDPROC
*
*
PROCEDURE SETS_INICIALES
  
  SET CENTURY ON
  SET DATE    DMY
  SET SAFETY  OFF
  SET TALK    OFF
  
ENDPROC
*
*
DEFINE CLASS WALTER_SYSTRAY AS SYSTRAY OF "SYSTRAY.VCX"
  
  IconFile      = ADDBS(SYS(5)+CURDIR())+"pyro.ICO"
  MenuText      = "4;Bienvenida;5;Mensaje;6;Salir"
  MenuTextIsMPR = .F.
  TipText       = "Ejemplo de un programa en la barra de tareas del Windows"
  *
  *
  PROCEDURE BalloonClickEvent     && El usuario hizo clic sobre el "balloon"
    
   * stop()
    =MessageBox("Hiciste clic sobre el BalloonTip, y yo lo detecté")
*!*	    LOCAL cRuta
*!*		cRuta = ADDBS(SYS(5)+CURDIR())+'close.bat'
*!*		IF FILE(cRuta)
*!*			RUN &cRuta
*!*		ENDIF 

  ENDPROC
  *
  *
  PROCEDURE ProcessMenuEvent     && Aquí se debe procesar la opción elegida por el usuario
  LPARAMETERS tnMenuItemID
    
    DO CASE
      CASE tnMenuItemID = 0     && Salió sin elegir opcion, nada se debe hacer entonces
      CASE tnMenuItemID = 1     && Eligió la primera opción
        =ShellExecute(0, "OPEN", "NOTEPAD.EXE", "", "", 1)
      CASE tnMenuItemID = 2     && Eligió la segunda opción
        =ShellExecute(0, "OPEN", "CALC.EXE", "", "", 1)
      CASE tnMenuItemID = 3     && Eligió la tercera opción
        =ShellExecute(0, "OPEN", "MSPAINT.EXE", "", "", 1)
      CASE tnMenuItemID = 4     && Eligió la cuarta opción
        =MessageBox("Un mensaje de bienvenida")
      CASE tnMenuItemID = 5     && Eligió la quinta opción
        DO MI_PROCEDURE_SALUDA
      CASE tnMenuItemID = 6     && Eligió la sexta opción
        This.RemoveIconFromSystray()
        CLEAR EVENTS
    ENDCASE
  
  ENDPROC
  *
  *1
ENDDEFINE
*
*
DEFINE CLASS WALTER_TIMER AS TIMER
  
  Enabled  = .T.
  Interval = 2000     && El control TIMER trabaja con milisegundos, por lo tanto 10.000 milisegundos equivalen a 10 segundos10
  
  PROCEDURE TIMER
    cVersion = HayVersionExe("gestion.exe")
    IF LEN(cVersion)> 0
    	
    	
	   * poSysTray.AddIconToSystray()          && El icono del menú es mostrado para que se pueda ejecutar el método ShowBalloonTip()
	    *poSysTray.ShowBalloonTip("EXISTE UNA NUEVA VERSION"+CHR(13)+"SALIR PARA ACTUALIZAR EL SISTEMA", "Nueva Version", ICONO_INFO,30)
	    *poSysTray.RemoveIconFromSystray()     && El icono del menú es ocultado, el usuario no podrá verlo
	    FrmMenu3.Cont_Status.Cont_Update1.lbl.Caption = "EXISTE UNA NUEVA VERSION"
	    
*!*		IF oConfigTermi.controlskin = 'TRUE'
*!*			_SCREEN.lcMensajeClickPopup = "EXISTE UNA NUEVA VERSION"   &&MENSAJE QUE APARECE PARA CUANDO SE DESEA PRESIONAR CLICK EN EL POPUP
*!*			_SCREEN.lcComandoPopup      = "GMUPDATE()"   &&COMANDO A EJECUTAR CUANDO SE PRESIONA EN EL MENSAJE CLICK DEL POPUP
*!*			_SCREEN.lnStyloPopup        = 2         &&ESTILOS DEL POPUP
*!*			
*!*			lcCaption = "GM Solutions"   			&&TITULO CAPTION DEL POPUP
*!*			lcMessage = "Existe una actualización importante del sistema, hacer click"	&&MENSAJE A MOSTRAR EN EL POPUP

*!*			VFPs_MessagePopup (lcCaption,lcMessage)
*!*		ENDIF 
	
	    &&Subimos el intervalo porque el usuario ya vio el mensaje
	    This.Interval =   30000 
		
	ENDIF 
	This.Enabled = IIF(lldesarrollo,.f.,This.Enabled)
  ENDPROC
  *
  *
ENDDEFINE


