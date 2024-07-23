LPARAMETERS oOrigen

oOrigen = IIF(PCOUNT()<1,1,oOrigen)

nOrigen = IIF(VARTYPE(oOrigen)='C',VAL(oOrigen),oOrigen)


cVersionGoapp = "02.01.20"

SET SYSMENU off
set classlib to
l='j:'
set talk off

PUBLIC lldesarrollo

lldesarrollo=(_vfp.startmode()#4)

_vfp.AutoYield = .f.

lctituloGestion = "Gestión Comercial"

If !lldesarrollo
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
ELSE

ENDIF

Set cursor off

lccaption=_screen.caption

Set cursor on

lcdd=alltrim(curdir()) && directorio de arranque

cRutaCAE = sys(5)+CURDIR()+"caevacio.jpg"
cLogoFac	= SYS(5)+CURDIR()+"logofac.jpg"
cRutaQR		= SYS(5)+CURDIR()+"qr.jpg"

PUBLIC FOXHELPFILE 
FOXHELPFILE  =  "ayuda.CHM"

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
Endif

*-- CREACION DE OBJETO APLICACION

Set classlib to localaplicacion.vcx additive && Objeto Aplicacion

*-- APERTURA DE CLASES Y ARCHIVOS DE PROCEDIMIENTOS

   SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE  TO  procimportar.prg ADDITIVE
   SET PROCEDURE  TO  procfuncword.prg ADDITIVE
    SET PROCEDURE  TO  procdesarrollo.prg ADDITIVE
    SET PROCEDURE  TO  syerrhand.prg ADDITIVE  
    
   SET PROCEDURE  TO  syserror.prg ADDITIVE  
   SET PROCEDURE TO procfiscal.prg ADDITIVE 
   SET PROCEDURE  TO registry.prg ADDITIVE       
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
   SET PROCEDURE TO googlemaps.prg ADDITIVE 
    SET PROCEDURE TO  foxypreviewercaller.prg ADDITIVE 
     SET PROCEDURE TO FoxBarcodeQR ADDITIVE
   set classlib to systray ADDITIVE 
    SET PROCEDURE TO alertaelegante.prg ADDITIVE 
    
*clear all


_screen.lockscreen=.t.
_Screen.windowstate=2
_Screen.caption=lctituloGestion
_Screen.icon='pyro.ico'
_screen.picture= 'fondoscreen.jpg'
_Screen.closable=.f.
_Screen.visible=.t.

PUBLIC LcConectionString,LcDataSourceType,lcOrigenPublico,PcmsgIU,PcmsgIP,LcWebService,LcLlaveCf,Pnterminal,pnsucursal
PUBLIC lcConectionODBC,lnconectorODBC
PUBLIC oConfigTermi,pIdSistema
Public m.osystray
   
 STORE '' TO LcConectionString,LcDataSourceType,lcOrigenPublico,LcWebService,lcConectionODBC
 STORE 0 TO Pnterminal,Pnsucursal,lnconectorODBC,cDirCloseBat 

pIdSistema  = nOrigen 

cDirCloseBat = ADDBS(SYS(5)+CURDIR())+'close.bat'

LeerConfigTermi()

PUBLIC OAvisar
Oavisar=NewOBJECT('avisar','controles.vcx')

Public goapp,ObjReporter

goapp=createobject('app',!lldesarrollo,lldesarrollo)

ObjReporter= CREATEOBJECT("Custom")
ObjReporter.AddProperty('titulo1',"")
ObjReporter.AddProperty('titulo2',"")
ObjReporter.AddProperty('titulo3',"")
ObjReporter.AddProperty('titulo4',"")
ObjReporter.AddProperty('logo',"logogestion.jpg")
objReporter.AddProperty('logofac',cLogoFac)
ObjReporter.AddProperty('numcae',cRutaCAE)
ObjReporter.AddProperty('fileqr',cRutaQR)
ObjReporter.AddProperty('mensajeria_body',"")
ObjReporter.AddProperty('banner',"gmbanner.png")



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

	goapp.version = cVersionGoapp
	goapp.gmsoft = "comercial"
	
	PUBLIC  gcicono
	     
	PcmsgIU  = 'Información al Usuario'
	PcmsgIP  = 'Información al Programador'
	   
	gcicono=lcdd+'help.ico'
	LcLlaveCf = SPACE(8)
	      
	on error do errorsys
	           		                          
	do setup
	
	_screen.LockScreen=.t.
	
*!*		**** aca comienza la parte de posicionamiento del escritorio
*!*		PUBLIC oscreen    
*!*		LeerXML("screen.xml",@oscreen)  && rescato la posicion de la _screen	
*!*		try
*!*			_screen.Top=ABS(oscreen.top)
*!*			_screen.Left=ABS(oscreen.left)
*!*		CATCH
*!*			_screen.Top=38
*!*			_screen.Left=1
*!*		ENDTRY	
*!*		*_screen.height=oscreen.height
*!*		*_screen.width=oscreen.width

*!*		_screen.LockScreen=.f.

*!*		PUBLIC oHandler
*!*	    oHandler=NEWOBJECT("myhandler")
*!*	    BINDEVENT(_SCREEN,"Resize",oHandler,"myresize")    
*!*	    BINDEVENT(_SCREEN,"Moved",oHandler,"mymoved")
*!*		***** fin posicionamiento escritorio
	
	WAIT WINDOW "Verificando ActiveX instalados ..." nowait
    DO Verifica_OCX WITH "Check"
    
    TEXT TO m_icon NOSHOW 
	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
	ENDTEXT
	
	SET SAFETY OFF 
	STRTOFILE(STRCONV(m_icon,14),"alert.ico")
	SET SAFETY ON 
	
	m.osystray = Createobject("ysystray")
	
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
	
	*LeerXMLClassID("objetodll.xml")
	
	Grabar_Log('Verificando Licencia') 
	=  Licencia()
	
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

*!*		IF !lldesarrollo 
*!*			IF !LeerVersionExe(1)
*!*				CANCEL
*!*				CLEAR ALL
*!*				RETURN 	
*!*		      ENDIF 
*!*		ENDIF 
	
	
	LeerEmpresa()
	
	ObjReporter.logofac =  goapp.logofac
	IF lldesarrollo
		ObjReporter.logo = lcdd+'graphics\logogestion.jpg'
		ObjReporter.logofac = lcdd+'graphics\'+LTRIM(goapp.logofac)
		ObjReporter.banner= ADDBS(_rutabmpd)+'gmbanner.png'
	ENDIF 

	Goapp.idusuario           = 0
	Goapp.perfilusuario     = 0
	Goapp.nombreusuario= ""
	Goapp.switchperfil = '00000'
	Goapp.sucursal10   = Goapp.sucursal   && si sucursal10#0 en proc almacenado de insert suma 10 y concatena el numero de id obtenido, ver odata
	
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
	
	*--------------Codigo para que abra el form
	_screen.visible=.t.	   
	_screen.lockscreen=.f.
	_screen.Show() 
	
	IF pIdSistema = 3 OR pIdSistema=4
	ELSE 
		DO FORM frmlogin
	ENDIF 
	
	_screen.lockscreen=.t.	
	*--------------------------   
	
	LOCAL oMenu
	PUBLIC Pidsistema

	oDesktop = ''
	*oMenu = NEWOBJECT("createmenu","symde.vcx",.NULL.,.T.,odesktop,Goapp.perfilusuario,"'verdana',9","")
	*oMenu.createMenu() 
	oMenu = Newobject("createmenu","menu.vcx",.Null.,.T.,oDesktop,goapp.perfilusuario,"'verdana',9","")
	oMenu.createMenu('datamenu','seguridad','favoritos',Pidsistema)
	  
	oMenu = null
	

	
	LeerEjercicioPerfil()
	
	IF pIdSistema = 3 OR pIdSistema=4
	ELSE 
		DO FORM frmmenu3
	ENDIF 
	
	*stop()
	
	DO CASE 
	CASE pIdSistema  = 1
		IF goapp.termifacopen = 1
			DO FORM regfacvta
		ENDIF 
	CASE pIdSistema  = 3
		DO FORM regproceso_sync_exp WITH .t.
	CASE pIdSistema  = 4
		DO FORM regproceso_sync WITH .t.
	ENDCASE 
	
	_screen.visible=.t.	   
	_screen.lockscreen=.f.
	
	public pcTextoBalloon, poSysTray, poTimer
  
	 * DO SETS_INICIALES
	  
	  DO DECLARAR_FUNCIONES_API
  
*!*		TRY 	 
*!*			poSysTray = CreateObject("WALTER_SYSTRAY")
*!*	  	ENDTRY 
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
	    IF oConfigTermi.ShowBalloonTip = 'FALSE' OR lldesarrollo
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
DEFINE CLASS WALTER_SYSTRAY AS SYSTRAY OF "SYSTRAY.VCX"
  
 * LOCAL cIcon
 * cIcon = ADDBS(SYS(5)+CURDIR())+"pyro.ico"
 * IF FILE(cIcon)
  	IconFile      ="pyro.ico"
 * ENDIF 
  MenuText      = "4;Bienvenida;5;Mensaje;6;Salir"
  MenuTextIsMPR = .F.
  TipText       = "Notificaciones Sistema PYRO"
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
    	
    	TRY 
*!*		    	poSysTray.AddIconToSystray()          && El icono del menú es mostrado para que se pueda ejecutar el método ShowBalloonTip()
*!*		     	poSysTray.ShowBalloonTip("EXISTE UNA NUEVA VERSION"+CHR(13)+"SALIR PARA ACTUALIZAR EL SISTEMA", "Nueva Version", ICONO_INFO,30)
*!*		   	 	poSysTray.RemoveIconFromSystray()     && El icono del menú es ocultado, el usuario no podrá verlo
	   	 	FrmMenu3.Cont_Status.Cont_Update1.lbl.Caption = "EXISTE UNA NUEVA VERSION"
	   	 	
	   	 	m_tipo=1	&& ICONO DEL MENSAJE 0=icono predeterminado 1=Información 2=Alerta 3=Error 4=Informacion importante
			m_duracion=3

			*m.osystray.ShowBalloonTip("El sistema DEMO caducara dentro de : 30 Dia(s)", "Información" , m_tipo,m_duracion)
			m.osystray.ShowBalloonTip(cVersion, "GM Solutions" , m_tipo,m_duracion)

		 	&&Subimos el intervalo porque el usuario ya vio el mensaje
	  	  	This.Interval =   30000 
	   CATCH TO oError
	   		This.Enabled = .f.
	   ENDTRY 
	   		   	
	  	 
	 
	ENDIF 
  ENDPROC
    
ENDDEFINE 
