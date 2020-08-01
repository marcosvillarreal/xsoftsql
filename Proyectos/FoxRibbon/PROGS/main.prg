*-------------------------------------------------------------------------------------------------------------------
*- César A. Mallo Fernández - CaMF
*- León - España
*- 01/12/2015 Comencé a interesarme por FoxRibbon y estuve 2 meses tanteando
*- 01/11/2016 Retomé el estudio de FoxRibbon
*- 25/12/2018 Decidí compartir FoxRibbon Camf públicamente de forma gratuita para la comunidad de Visual FoxPro 
*- Mas información de FoxRibbon Camf: http://visualfoxpro.webcindario.com/foxribbon/foxribbon.php
*-------------------------------------------------------------------------------------------------------------------
*- Puedes acelerar la inicialización si evita cargar archivos que no piensa utilizar.
*- Si la aplicación no usa el archivo FOXUSER o FOXHELP, desactívelos en el archivo Config.fpw
*- mediante los comandos siguientes: RESOURCE = OFF y HELP = OFF
*- HIDE WINDOW SCREEN  && Oculta la ventana principal.Luego se activa antes de Read Events. Desactivada en config.fwp es más rápido
*- consiguiendose con esto un incremento de velocidad de inicio.
*-------------------------------------------------------------------------------------------------------------------

*- 1. Definición de constantes -------------------------------------------------------------------------------------
 PUBLIC m.pcFolderStyle, ndefstyle, ndefLanguage
 LOCAL  llCamf_Screen, llCamf_Ribbonc, llMaximizeForm, llFormInit, llModeExample, llFoxRibbon,;
 		lcLastSetTalk, lcLastSetExact, lcLastSetStatusBar, lcLastSetSysMenu, lcLastSetDate, lcLastSetCentury,;
 		llVisible, lnWindowState, lnTitleBar, lcCaption, lcIcon, lnBorderStyle, llAutoCenter, lnHeight, lnWidth, lnBackColor 

 llCamf_Screen = .T.			&& Por Camf. Con ello conseguimos utilizar FoxRibbon en Screen (.T.) o en un formulario de nivel superior (.F.)
								&& Para utilizarlo en Screen previamente se debe programar para que así sea. El ejemplo esta programado de forma Dual,
								&& es decir, se puede utilizar en Screen o como formulario de nivel superior indistintamente
 
 llCamf_Ribbonc = .T.			&& .T. -> Utilizar ejemplo con Ribbonc diseñado por César A. Mallo Fernández 
								&& .F. -> Utilizar ejemplo con Ribbon diseñado por Guillermo Carrero. 

 llMaximizeForm = .t.			&& Conseguimos abrir nuestro formulario o Screen -> .T. = Maximizado - .F. = Minimizado
 
 llFormInit = .T.				&& .T. = Utilizar Formulario de inicio - .F. = No utilizar
 
 llModeExample = .T.			&& .T. -> Indica que vamos a utilizar main.prg en modo ejemplo - .F. -> Como plantilla para nuestra aplicación
 								&& Elimina el calendario y abrir USE (HOME(2) + "\Northwind\Customers.dbf")

 llFoxRibbon = .T.				&& .T. Indica el uso de FoxRibbon - .F. Main.prg se puede utilizar como pantilla de cualquier aplicación						

 CLEAR

 *- SET RESOURCE OFF			&& Especifica que los cambios realizados en el entorno de Visual FoxPro
								&& no se guarden en el archivo de recursos. Está en config.fpw
*-------------------------------------------------------------------------------------------------------------------


*- 2. Comprobar existencia de archivo de memoria para style, crearlo y restaurarlo ---------------------------------
	IF  llFoxRibbon					&& .T. Indica el uso de FoxRibbon
		 m.pcFolderStyle = "Styles"	&& -- Default folder
		IF !FILE(SYS(5)+CURDIR()+pcFolderStyle+"\STYLE.MEM")
    		ndefStyle = SYS(5)+CURDIR()+pcFolderStyle+"\Default.ini"
			*--ndefLanguage = "English"
    		ndefLanguage = "Español"
	    	SAVE TO (SYS(5)+CURDIR()+pcFolderStyle+"\STYLE.MEM") ALL LIKE ndef*
		ENDIF

		RESTORE FROM (SYS(5)+CURDIR()+pcFolderStyle+"\STYLE.MEM") ADDITIVE
	ENDIF &&llFoxRibbon	
*-------------------------------------------------------------------------------------------------------------------


*- 3. Clases y  Objetos --------------------------------------------------------------------------------------------	 
		SET CLASSLIB TO vcx\FOXRIBBON
		SET CLASSLIB TO vcx\CAMFENGINE ADDITIVE		&& Contiene el motor Camf
		SET CLASSLIB TO vcx\CAMFFUNCTION ADDITIVE	&& Personal Camf con mis funciones 
		SET CLASSLIB TO vcx\SAMPLERIBBON ADDITIVE	&& Solo para los ejemplos
 
		DO SYSTEM.APP
 
	*--------------------------- oRibbon ----------------------------
	IF  llFoxRibbon									&& .T. Indica el uso de FoxRibbon
		IF "FOXRIBBON"$SET("CLASS")					&& Creamos el objeto oRibbon
			 IF VARTYPE(_SCREEN.oRibbon)="O"
 			   	_SCREEN.removeobject('oRibbon')
			 ENDIF

			 _SCREEN.newobject('oRibbon', 'RibbonSettings', 'foxribbon.vcx')
		ENDIF
	ENDIF &&llFoxRibbon
 
*SET PROCEDURE TO LOCFILE("Vcx\onapp_class.prg") ADDITIVE  
*_SCREEN.AddObject("OnApp", "OnApp") 

*-------------------------------------------------------------------------------------------------------------------


*- 4. Configuracion de la presentación de la pantalla Camf---------------------------------------------------------- 
	lcLastSetSysMenu=SET("SYSMENU")
	SET SYSMENU OFF    && Desactiva menus Vfp

	WITH _Screen
		llVisible = .Visible 	
		lnWindowState = .WindowState 
		lnTitleBar = .TitleBar
	    lcCaption = .Caption
	    lcIcon = .Icon 
	    lnBorderStyle = .BorderStyle
	    llAutoCenter = .AutoCenter
	    lnHeight = .Height
	    lnWidth = .Width
	    lnBackColor=.BackColor

			IF  llFoxRibbon									&& .T. Indica el uso de FoxRibbon	    
				.BackColor = _SCREEN.oRibbon.FormBackColor	&& Color de fondo FoxRibbon en la ventana principal
				.Icon = SYS(5) + curdir()+"\Images\FoxRibbon.ico"	&& Establecer un icono en la barra de título de Visual Foxpro 
			ENDIF &&llFoxRibbon	

		.TitleBar = 0 
		

		*.Visible = .F.                 					&& .F. dejaría la aplicación totalmente invisible. Si su valor es .T. cancelaría en el acto a HIDE WINDOW SCREEN, mostrando la pantalla	
		*.WindowState = 0                 					&& Estado de la pantalla 1 = Minimizada, 0 = Normal, 2 = Maximizada
		*- No use la propiedad WindowState = 2. Utilice en su lugar: MyTitleBar.MaximizeForm() en el objeto correspondiente
		*-----------------------------------------------------------------------------------------------------------
		*----------------------- 0 - Desactivamos barra de título, 1 - La activamos --------------------------------
	    *.Caption =_SCREEN.oRibbon._ClassName + " " + _SCREEN.oRibbon._Version + " " + _SCREEN.oRibbon._Date 
	    			&& Establecer un título en la barra de titulo de Visual Foxpro 
	    			&& Se carga en _titlebar en Camf_Engine.Refresh
*-------------------------------------------------------------------------------------------------------------------


*- 5. Configuracion de comandos SET -------------------------------------------------------------------------------- 
		
		lcLastSetTalk = SYS(103)	            && También serviría lcLastSetTalk = ('TALK')
		SET TALK OFF
		lcLastSetExact = SET("EXACT")
		*SET EXACT ON
			*- Quitamos la barra de estado de Visual FoxPro		
		lcLastSetStatusBar = SET("STATUS BAR")
 		SET STATUS BAR OFF						&& Camf Intentando solucionar problemas. Solucionados con SET TALK OFF
 			*- Formatos de fecha a utilizar 
 		lcLastSetDate = SET("DATE")	
		SET DATE DMY  
		lcLastSetCentury = SET("CENTURY")		&& Formato de fecha a utilizar dd/mm/aa
		SET CENTURY ON 							&& Especifica un formato de año con cuatro dígitos que ocupa 10 caracteres (incluidos los delimitadores de fecha). 
*-------------------------------------------------------------------------------------------------------------------

		
*- 6. Configuramos estilo del borde y el tamaño de pantalla
			.BorderStyle = 2					&& Estilo del borde -3. con borde- tamaño ajustable
		
		IF	llMaximizeForm OR !llCamf_Screen 	&& Si abrimos el formulario Maximizado o trabajamos en modo FNS. 												
			*.WindowState = 1					&& Con ello conseguimos no ver a Screen al iniciar la aplicación	
			*_Screen.OnApp.WindowState = 2
		ENDIF	
				
		*IF llCamf_Screen						&& Si trabajamos en Screen
			.Height = 720						&& Dimensión vertical de Screen
			.Width = 1280						&& Dimensión horizontal de Screen
		*ELSE									&& Si trabajamos en FNS
		*	.Height = 480						&& Dimensión vertical de Screen
		*	.Width = 480						&& Dimensión horizontal de Screen
		*ENDIF
		
			.autocenter = .T.			 		&& Centrado automático de Screen
    
	ENDWITH
*-------------------------------------------------------------------------------------------------------------------



*- 7.---------------------------------------------------------------------------------------------------------------
	IF  llFoxRibbon								&& .T. Indica el uso de FoxRibbon	    
		WITH _SCREEN.oRibbon
			*--Other Style
			*.FileIni = ndefStyle 				&& Está en RibbonSetings.init
			*.Settings()						&& Está en RibbonSetings.init
			*.ReDraw()							&& Está en RibbonSetings.init
			.Language = ndefLanguage
			*--Show time out progress bar in MessageBox
			.ShowProgressMessageBox = .T.		&& Barra de progreso en MessageBox. Tengo que incluirlo en Style.mem
		ENDWITH
	ENDIF &&llFoxRibbon	
*-------------------------------------------------------------------------------------------------------------------


*- 8. Utilizado en los ejemplos de fechas de FoxRibbon -------------------------------------------------------------
	IF llModeExample 							&& .T. -> Utilizamos el modo ejemplo
		WITH _SCREEN.oRibbon
			*--Calendario
			.c_FirstDayWeek = 2
			*--Días feriados de la semana
			.c_1SunHoli = .T.
			.c_2MonHoli = .F.
			.c_3TueHoli = .F.
			.c_4WedHoli = .F.
			.c_5ThuHoli = .F.
			.c_6FriHoli = .F.
			.c_7SatHoli = .T.
		ENDWITH

		*-- Open DBF --- usar solamente, en el modo ejemplo, con el ejemplo de sidebar -------------------
		USE (HOME(2) + "\Northwind\Customers.dbf") IN SELECT("Customers") NOUPDATE 
		*----------------------------------------------------------------------------
	ENDIF
*-------------------------------------------------------------------------------------------------------------------


*- 9. Mensaje en la barra de estado de Visual Foxpro si la tenemos activa ------------------------------------------
*SET MESSAGE TO _SCREEN.oRibbon._ClassName + " " + _SCREEN.oRibbon._Version + " " + _SCREEN.oRibbon._Date &&Mensaje Principal
*-------------------------------------------------------------------------------------------------------------------


*- 10. Formularios de presentacion y entrada -----------------------------------------------------------------------
	SHOW WINDOW SCREEN								&&ACTIVA la ventana principal que tenemos desactivada en config.fwp con	SCREEN=off
 
	IF llCamf_Screen								&& Si trabajamos en modo Screen
		IF llFormInit
	    	DO FORM FORMINIT WITH llCamf_Screen		&&Abrimos formulario de inicio
	    ENDIF
	    
	    DO INTERFACE_SCREEN WITH llCamf_Ribbonc , llMaximizeForm
	ELSE											&& Si trabajamos en modo FNS
		IF llFormInit
	    	DO FORM FORMINIT WITH llCamf_Screen		&& Abrimos formulario de inicio
		ENDIF
		
	    IF llCamf_Ribbonc=.T.						&& Utilizamos ejemplos con Ribbonc en la pantalla principal
			DO FORM SCX\mainc WITH IIF(llMaximizeForm, .T. , .F.)	&& WITH .T. = Abrir maximizado
			*DO FORM SCX\mainc2 WITH IIF(llMaximizeForm, .T. , .F.)	&& WITH .T. = Abrir maximizado					
			*DO FORM SCX\main_dualc	WITH IIF(llMaximizeForm, .T. , .F.)	&& WITH .T. = Abrir maximizado				
			*DO FORM SCX\main_dualc2 WITH IIF(llMaximizeForm, .T. , .F.)	&& WITH .T. = Abrir maximizado				
	    ELSE										&& Utilizamos ejemplos con Ribbon en la pantalla principal
			DO FORM SCX\main_dual WITH IIF(llMaximizeForm, .T. , .F.)	&& WITH .T. = Abrir maximizado			
       		*DO FORM SCX\main2 WITH IIF(llMaximizeForm, .T. , .F.)	&& WITH .T. = Abrir maximizado					
	    ENDIF
    
    	HIDE WINDOW screen							&& Oculta la ventana principal.

	ENDIF
*-------------------------------------------------------------------------------------------------------------------


*- 11. Activar SET SYSMENU -----------------------------------------------------------------------------------------
	IF  !llCamf_Screen
    	SET SYSMENU ON		&& Activa menus Vfp antes de READ EVENTS, de lo contrario nos da un error al no salir con Exit KEYBOARD '{ALT+F4}' 
	ENDIF
*-------------------------------------------------------------------------------------------------------------------


*- 12. Ultimo - Salir de la aplicación -----------------------------------------------------------------------------
	IF llCamf_Screen					&& Si trabajamos en modo Screen
    	ON SHUTDOWN salir(_Screen.Name) &&CLEAR EVENTS Salir, Si cuando trabajamos en Screen y No si trabajamos con un formulario de nivel superior 
	ENDIF
 
	READ EVENTS
 
	IF llCamf_Screen					&& Si trabajamos en modo Screen
    	ON SHUTDOWN   
	ENDIF 

	*- Restaurar pantalla de Visual Foxpro Camf ---------------------------------
	WITH _Screen && Restablece Screen Visual Foxpro
		.Visible = llVisible
		.WindowState = lnWindowState
		.TitleBar = lnTitleBar          && Reestablecer barra de título
		.Caption = lcCaption            && Reestablecer un título
		.Icon = lcIcon                  && Restablece icono	
		.BorderStyle = lnBorderStyle    && Reestablece el estilo del borde
		.AutoCenter = llAutoCenter      && Reestablece centrado automático de Screen
		.Height = lnHeight              && Reestablece la dimensión vertical de Screen	
		.Width = lnWidth                && Reestablece la dimensión horizontal de Screen	
		.BackColor=lnBackColor          && Reestablece el color de fondo de Screen
	ENDWITH

	CLEAR MENUS
	RELEASE WINDOWS 					&& Quitar ventanas de la pantalla
	SET MESSAGE TO 						&& Borra mensajes en la barra de estado de Visual Foxpro 


	*- Restautar comandos SET ---------------------------------------------------
	SET TALK  			&lcLastSetTalk
	SET EXACT			&lcLastSetExact
 	SET STATUS BAR		&lcLastSetStatusBar
	SET SYSMENU 		&lcLastSetSysMenu	
	SET DATE    		&lcLastSetDate
	SET CENTURY 		&lcLastSetCentury
	
	* SET SYSMENU ON  && Activa menus Vfp subido antes de READ EVENTS por error con Exit KEYBOARD '{ALT+F4}' en modo FNS.

	*- Cerrar archivos de biblioteca de clases visuales y bases de datos --------
	 RELEASE CLASSLIB vcx\FoxRibbon.vcx, vcx\Camfengine.vcx
	 RELEASE CLASSLIB vcx\CamfFunction.vcx	&& Camf con nuevas funciones
	 RELEASE CLASSLIB vcx\SampleRibbon.vcx	&&Solo para los ejemplos

	 CLOSE DATABASES ALL				&&Si tenemos bases de datos abiertas 
	 CLEAR ALL
*---------------------------------------------------------------------------- 
ENDPROC
*-------------------------------------------------------------------------------------------------------------------