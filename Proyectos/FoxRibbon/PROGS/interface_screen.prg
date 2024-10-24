*- Por Camf para implementar FoxRibbon en Screen 15/11/2016
*-------------------------------------------------------------------------------------------
*- Mas informaci�n de FoxRibbon Camf: http://visualfoxpro.webcindario.com/foxribbon/foxribbon.php
*- Se ha movido a main antes del formulario de inicio FormInit
*	SET TALK OFF 
**	SET CONSOLE OFF
**	SET NOTIFY OFF
*	SET STATUS BAR OFF && Camf Intentando solucionar problemas. Solucionados con SET TALK OFF 
*--------------------------------------------------------------------------------------------
 PARAMETER tlCamf_Ribbonc, tlMaximizeForm &&-> Recibimos el parametro llCamf_Ribbonc = .F. o .T. y llMaximizeForm = .F. o .T.
 LOCAL llTitleBarWin, llFunction, llSidebar, llGradient, llTitleBar, llStatusBar, llRibbon, llStartButton, llTitleBar_Little, llLanguage, llOldLock
 

llTitleBarWin = .F. && Activar Barra de t�tulo Windows. Si FoxRibbon ya tiene una barra propia, la barra Windows se desactivar� igualmente

llFunction		  = .T. && Activar CamfFunction -> Function 
llSidebar		  = .T. && Activar Sidebar
llGradient		  = .T. && Activar Gradiente

llTitleBar		  = .T. && Activar TitleBar.    Desactivado, pues lo activa Ribbon en esta configuraci�n
llStatusBar		  = .T. && Activar StatusBar.   Desactivado, pues lo activa Ribbon en esta configuraci�n
llRibbon		  = .T. && Activar Ribbon
llStartButton 	  = .T. && Activar StartButton. Desactivado, pues lo activa Ribbon en esta configuraci�n
llTitleBar_Little = .F. && Utilizar barra de t�tulo peque�a. Normalmente se utiliza en Ribbon cuando no tenemos una barra de t�tulo
llLanguage		  = .F. && Activar cambio de idiomas. Est� desactivado porque el objeto ya se ha creado en Ribbon y Ribbonc

*- Los objetos se tienen que a�adir en el estricto orden que tiene esta configuraci�n
WITH _SCREEN
	llOldLock = .LOCKSCREEN
	.LOCKSCREEN = .T. && Para no ver modificaciones hasta el final cuando .LOCKSCREEN = llOldLock
	* .function1.LOCKSCREEN(.T.) && Si se utiliza poner despu�s de crear el objeto function1, es decir, 2 lineas mas abajo
	.MINWIDTH = 140
	.MINHEIGHT = 50
*---
	IF llTitleBarWin .AND. llTitleBar = .F. .AND. llTitleBar_Little = .F. && Si no tenemos otras barras de t�tulo
		.TitleBar = 1 && 0 - Desactivamos barra de t�tulo.
		.Caption="FoxRibbon Camf trabajando en la ventana principal de Visual FoxPro - Mode: Screen" && Texto en la barra de t�tulo de Visual FoxPro
	ENDIF
*-
    IF "CAMFFUNCTION" $ SET("CLASS") AND llFunction 
    	IF VARTYPE(_SCREEN.function1)="O"
    		_SCREEN.removeobject('function1')
		 ENDIF
       .ADDOBJECT("function1", "function")
    ENDIF
   
*-
    IF llSidebar
    	IF VARTYPE(_SCREEN.o_mysidebar1)="O"
    		_SCREEN.removeobject('o_mysidebar1')
    	ENDIF	
       .NEWOBJECT("o_mysidebar1", "_my_sidebar", "SampleRibbon.vcx")	 &&Problema con Propiedades de estilo resuelto al ponerlo el segundo
       *Al final est� la llamada a las funciones de centrado 
    ENDIF
*-
    IF llGradient
    	IF VARTYPE(_SCREEN._gradient1)="O"
    		_SCREEN.removeobject('_gradient1')
    	ENDIF	
       .NEWOBJECT("_gradient1", "_c_gradient", "CamfEngine.vcx")	 && Creamos el gradiente
       ._gradient1.visible = .T.
    ENDIF
*- Camf_Engine
    IF "CAMFENGINE" $ SET("CLASS") 
    	IF VARTYPE(_SCREEN.Camf_Engine1)="O"
    		_SCREEN.removeobject('camf_engine1')
    	ENDIF	
       .NEWOBJECT('camf_engine1', 'camf_engine') &&Es el motor FoxRibbon dise�ado por Camf 
    ENDIF									  	 
*-
    IF llSidebar
			.Camf_Engine1._mySideBar = .o_mysidebar1.NAME	&& A�adimos c�digo al motor para saber que tenemos un SideBar
    ENDIF
*-
    IF llTitleBar
    	IF  tlCamf_Ribbonc
	    	*En esre ejemplo solo se activa con Ribbonc
	    	*No se activa con Ribbon ya que que se activa en YourTitlebar en la clase my_ribbon_screen
			.Caption="FoxRibbon Camf trabajando en la ventana principal de Visual FoxPro - Ribbonc - Mode: Screen" && Texto en la barra de t�tulo
			IF VARTYPE(_SCREEN._My_TitleBar)="O"
    			_SCREEN.removeobject('_My_TitleBar')
 		   	ENDIF	
			.NEWOBJECT("_My_TitleBar", "_c_titlebar_designer")	 && Se puede crear aqu� o en Ribbon
			*.Camf_Engine1._MyTitleBar = ._my_titleBar.Name && A�adimos c�digo al motor para saber que tenemos un TitleBar
			*.WindowState = 2
			*.ribbon1.Top = 30 && .Top donde aparece Ribbon ya que tiene que ser desplazado hacia abajo
			**.ribbon1.Anchor = 5 &&S�lo horizontal, puede ser interesante
			*.ribbon1.Anchor = 11 && Horizontal y vertical
		ELSE && Con Ribbon de Guillermo Carrero
			.Caption="FoxRibbon Camf trabajando en la ventana principal de Visual FoxPro - Ribbon - Mode: Screen"
		ENDIF
    ENDIF
*-
    IF llStatusBar
    	IF VARTYPE(_SCREEN._My_StatusBar)="O"
    		_SCREEN.removeobject('_My_StatusBar')
 	   	ENDIF	
       .NEWOBJECT("_My_StatusBar", "_c_StatusBar") && Se puede crear aqu� o en Ribbon
    ENDIF
*-
    IF llRibbon
		IF VARTYPE(_SCREEN.ribbon1)="O"
   			_SCREEN.removeobject('ribbon1')
   		ENDIF	

		IF ! tlCamf_Ribbonc	
			.NEWOBJECT("ribbon1", "my_ribbon_screen", "SampleRibbon.vcx")
			*.Camf_Engine1.ReDraw() && No es necesario aqu� porque para el ejemplo y centrar _language se ha puesto una l�nea al final 
		ELSE
			.NEWOBJECT("ribbon1", "my_ribbonc_screen", "SampleRibbon.vcx")
			IF llTitleBar	&& Si creamos el t�tulo aqu�, colocamos RibbonC debajo del t�tulo
				.RIBBON1.top = 30	&& S�lo para _ribbonc_screen. Con Ribbon debemos poner el ._Titlebar en Ribbon.YourTitlebar
			ENDIF
		ENDIF
		.ribbon1.visible = .T.	&& modificado en Ribbon.Init. No en Ribbonc
	ENDIF
*-
    IF llStartButton	&& Tiene que ir despu�s de llRibbon
		IF VARTYPE(_SCREEN._My_StartButton)="O"
   			_SCREEN.removeobject('_My_StartButton')
   		ENDIF	
       .NEWOBJECT("_My_StartButton", "_My_StartButton")	&& Se puede crear aqu� o en Ribbon
    ENDIF
*-
    IF llTitleBar_Little .AND. ! llTitleBar
    	IF VARTYPE(_SCREEN._My_TitleBar_Little)="O"
   			_SCREEN.removeobject('_My_TitleBar_Little')
   		ENDIF	
       .NEWOBJECT("_My_TitleBar_Little", "_TitleBar_Little")
    ENDIF
*-
    IF llLanguage
    * WITH .ribbon1
    	IF VARTYPE(_SCREEN._My_language1)="O"
   			_SCREEN.removeobject('_My_language1')
   		ENDIF	
       .NEWOBJECT("_My_language1", "language")
       *._My_language1.ANCHOR = 8
       ._my_language1.visible = .T.
	* ENDWITH
    ENDIF
*-
    IF llSideBar	&& Por Camf para centrar o_mysidebar1. Tenemos que configurarlo desde aqu� y en modo FNS tiene su configuraci�n en _mysidebar 
       Init_SideBar_Screen(.T., .name)	&& Configuramos sidebar. El .T. para hacerlo visible
    ENDIF
*---

*---
*  .LOCKSCREEN = llOldLock && Ahora podemos ver todo de un pantallazo     .refresh()	&& Necesario. De lo contrario no se actualiza _language
 	.refresh()	&& Necesario. De lo contrario no se actualiza _language

    IF llRibbon 
       .Camf_Engine1.ReDraw() 				&& No es necesario con Ribbonc a no ser por el ejemplo y centrar _language. Si es necesario con Ribbon y se ha anulado 
										&& su linea correspondiente porque se ha bajado aqu� a causa del ejemplo
    ENDIF
	 
    .LOCKSCREEN = llOldLock && Ahora podemos ver todo de un pantallazo 
	IF tlMaximizeForm && Screen maximizado al iniciar.
		
		IF !EMPTY(.Camf_Engine1._myTitleBar)
			LOCAL maximiza
			maximiza = .Camf_Engine1._myTitleBar + "."
			.&maximiza.MaximizeForm 
		ENDIF

	ENDIF    
    
    *.function1.LOCKSCREEN(.F.)
    
*	.alwaysOnTop = .T. && La primera vez que se abre FoxRibbon en _Screen puede quedar tapado por otras ventanas
*	.alwaysOnTop = .F. && VentanaTopMost(1) abajo tambi�n corrige el problema. Usar uno de los dos

*    .function1.VentanaTopMost(1) && Pasar la ventana Principal de VFP al primer plano fijo bug corregido 24/02/2020
*    .function1.VentanaTopMost(0) && Quitar la ventana Principal de VFP del primer plano fijo
    * El bug consistia en que la ventana principal se podia quedar detras de otras ventanas
ENDWITH
					

