*===================
*= ARCHIVO PRINCIPAL
*===================
*
*	VER AL PIE alguna consideracion con respecto a campos tablas
*

*!*	LPARAMETERS oIdPrograma

*!*	oIdprograma = IIF(PCOUNT()<1,"1",oIdprograma)

*!*	LOCAL nidprograma

*!*	nidprograma=IIF(VARTYPE(oIdprograma)="C",oIdprograma,LTRIM(STR(oIdprograma)))

CLEAR ALL
SET SYSMENU off
set classlib to
l='j:'
set talk off
public lldesarrollo
lldesarrollo=(_vfp.startmode()#4)

_vfp.AutoYield = .f.

lcVersion = "02.03.23"

lctituloGestion = "Gestion de Ventas"

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

cRutaCAE 	= sys(5)+CURDIR()+"caevacio.jpg"
cLogoFac	= SYS(5)+CURDIR()+"logofac.jpg"
cRutaQR		= SYS(5)+CURDIR()+"qr.jpg"
If lldesarrollo
   lcdd=L+'\xsoftsql\proyectos\distribuidora\'
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
   cRutaCAE	= _rutabmps + '\caevacio.jpg'
   cLogoFAC	= _rutabmps + '\logofac.jpg'
   cRutaQR	= _rutabmps + '\qr.jpg'
    
   _rutaformsd  =lcdd+'forms\dinamico'
   _rutaformsb  =lcdd+'forms\bancario'
   _rutaformsp  =lcdd+'forms\pedidos'
   _rutaformsc  =lcdd+'forms\caja'
   _rutaformut  =lcdd+'forms\util'
   _rutaformur  =lcdd+'forms\rutas'
   _rutaforcomi  =lcdd+'forms\comision'
   _rutaforcta  =lcdd+'forms\ctacte'
   _rutaforafip  =lcdd+'forms\afip'
   _rutaformv  =lcdd+'forms\ventas'
   _rutaformcpr  =lcdd+'forms\compra'
   _rutaformart  =lcdd+'forms\articulos'
   _rutaformpre  =lcdd+'forms\precio'
   _rutaformpat  =lcdd+'forms\patron'
   _rutaformconta = lcdd+'forms\contabilidad'
    _rutaformimp = lcdd+'forms\importadores'
   _rutaformpm  =lcdd+'forms\pm'
    _rutaformprueba = lcdd+'forms\pruebas'
    _rutaformpasaje = lcdd+'forms\pasaje'
    _rutaformest = lcdd+'forms\est'
    
    _rutaprogs_sur  =lcdd+'Progs\distribuidorasur'
    _rutaprogs_sureño  =lcdd+'Progs\elsureño'
   Set default to (lcdd) &&;(lcddc)

   Set path to &_rutaclases,&_rutaprogs,&_rutamenu,&_rutadatos,&_rutabmps,&_rutaforms;
               ,&_rutareports,&_rutaclased,&_rutabmpd,&_rutaformsDesarrollo,&_rutaffc,&_rutalib;
               ,&_rutaformsd,&_rutaformsb,&_rutaformsc,&_rutaformsp,&_rutaformut,&_rutaformur;
               ,&_rutaforcomi,&_rutaforcta,&_rutaforafip,&_rutaformv,&_rutaformcpr;
               ,&_rutaformart,&_rutaformpre,&_rutaformpat,&_rutaformconta,&_rutaprogs_sur;
               ,&_rutaformimp,&_rutaprogs_sureño,&_rutaformprueba, &_rutaformpm,&_rutaformpasaje;
               ,_rutaformest
               
 ELSE
 	SET CONSOLE OFF     
Endif

*-- CREACION DE OBJETO APLICACION

Set classlib to localaplicacion.vcx additive && Objeto Aplicacion

*-- APERTURA DE CLASES Y ARCHIVOS DE PROCEDIMIENTOS

   SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE  TO  procdesarrollo.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE  TO  procimportar.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE  TO  syserror.prg ADDITIVE  
   SET PROCEDURE  TO  syerrhand.prg ADDITIVE  
   SET PROCEDURE TO procfiscal.prg ADDITIVE 
   SET PROCEDURE  TO registry.prg ADDITIVE 
   SET PROCEDURE TO googlemaps.prg ADDITIVE 
   SET PROCEDURE TO mapsApiKey.prg ADDITIVE 
	SET PROCEDURE TO formposition.prg ADDITIVE 
   SET PROCEDURE TO ftp.prg ADDITIVE
   SET PROCEDURE TO whatsapp_ej ADDITIVE 
   SET PROCEDURE TO  foxypreviewercaller ADDITIVE 
   SET PROCEDURE TO FoxBarcodeQR ADDITIVE
   SET PROCEDURE  TO  SOVfp.prg ADDITIVE
       
   SET CLASSLIB  TO  reindexer ADDITIVE 
   SET CLASSLIB  TO  clasesgenerales ADDITIVE 
   SET CLASSLIB  TO  controles ADDITIVE 
   SET CLASSLIB  TO  controleslocal ADDITIVE 
   SET CLASSLIB  TO  controlesmenu ADDITIVE 
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
   *set classlib to deskalert ADDITIVE 
   set classlib to systray ADDITIVE 
   *SET CLASSLIB TO _ssclasses ADDITIVE 
   SET CLASSLIB TO _environ.vcx ADDITIVE 
   
   SET PROCEDURE TO alertaelegante.prg ADDITIVE 
   
   PUBLIC FOXHELPFILE 
   FOXHELPFILE  =  "DISTRIBUIDORA.CHM" 
*clear all

PUBLIC LcConectionString,LcDataSourceType,lcOrigenPublico,PcmsgIU,PcmsgIP,LcWebService,LcLlaveCf,Pnterminal,pnsucursal
PUBLIC lcConectionODBC,lnconectorODBC,GoogleMapsKeyAPI
PUBLIC oConfigTermi,pidsistema
PUBLIC cFileNameLog,cDirCloseBat,loScriptVFP 
Public m.osystray
 
STORE '' TO LcConectionString,LcDataSourceType,lcOrigenPublico,LcWebService,lcConectionODBC,cFileNameLog
STORE 0 TO Pnterminal,Pnsucursal,lnconectorODBC

LeerConfigTermi()
	
loScriptVFP = CREATEOBJECT("Scripting.FileSystemObject")	
	
_screen.lockscreen=.t.
_Screen.windowstate=2
_Screen.caption=lctituloGestion
_Screen.icon='pyro.ico'
_screen.picture= 'fondo51.jpg'
_Screen.closable=.f.
_Screen.visible=.t.



pidsistema = 1

GoogleMapsKeyAPI = 'AIzaSyBcWBS6HjNKZ2QkFWeQoiOQFtP6thnE8to'
cDirCloseBat = ADDBS(SYS(5)+CURDIR())+'close.bat'

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
ObjReporter.AddProperty('logo',"logogestion.jpg")
objReporter.AddProperty('logofac',cLogoFac)
ObjReporter.AddProperty('numcae',cRutaCAE)
ObjReporter.AddProperty('fileqr',cRutaQR)
ObjReporter.AddProperty('mensajeria_body',"")
ObjReporter.AddProperty('banner',"gmbanner.png")
*!*	IF lldesarrollo
*!*		ObjReporter.logo = lcdd+'graphics\logogestion.jpg'
*!*		ObjReporter.banner= ADDBS(_rutabmpd)+'gmbanner.png'
*!*	ENDIF 
ObjReporter.AddProperty('cartel',"")

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
	
	goapp.version = lcVersion
	goapp.gmsoft = "distribuidora"
	
	PUBLIC  gcicono
	     
	PcmsgIU  = 'Información al Usuario'
	PcmsgIP  = 'Información al Programador'
	   
	gcicono=lcdd+'help.ico'
	LcLlaveCf = SPACE(8)
	      
	on error do errorsys
	           		                          
	do setup
	_screen.LockScreen=.f.
	
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
	
	
	oavisar.proceso('S','Inicializando el sistema, aguarde unos instantes por favor ...')
	
	Grabar_Log('Verificando OCX') 
	
    	WAIT WINDOW "Verificando ActiveX instalados ..." nowait
    	DO Verifica_OCX WITH "Check"
    
   


	TEXT TO m_icon NOSHOW 
	AAABAAEAFBQAAAEAIAC4BgAAFgAAACgAAAAUAAAAKAAAAAEAIAAAAAAAQAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC4jsAA2K7gABgCFACceohMXEJJcDwiMqA0FitkMBYrtDAWJ7QwFiNoPCYerFQ+HXyYgixUAAIAANzCTAC8okADy8PsAAAAAAPj+/AAqH60AKyCtAGZX6AMZEZhPDgaPwQsCkPcLAZT/DACX/wkAmP8JAJf/CwCU/woBkP8KAor4DQeHxRkSiFRcVJ0EIhuKABoThgDv8fUAMSS5ACofrwBBNMQIFQyWfgwDkfMNAZr/DwGk/xABqv8aC7D/U0jC/01Cvv8VB6n/DgGh/w0Bmv8KAZH/CwOJ9RQNh4QwKI0KJByKADEpjwA6LMIAalj1AxcOmYANA5T7DwGj/xIBsf8UArv/EwDA/31z3P/5+P3/8/L7/2dcz/8PALD/EAGp/w4Bn/8LAZT/CgKJ/BQNh4ZdVJ0FOTGSAAQAhwAcEqBQDQOV8xABp/8UArv/FgLI/xgC0f8aA9b/rKTx////////////konl/xIAwP8TArb/EQGs/w4BoP8LAZT/CwSJ9hsUiFgAAH4AMSS5FREHmMMPAaP/FAK+/xgC0f8cAt//HgPn/x0B6/9ZRPH/zsj8/8W/+P9GM9//FQDN/xUCw/8TArf/EQGr/w4Bnv8KAZD/DwiHyjAojhkaD6FeDgOb+BMBuP8ZAtT/HgPo/yED9P8iA/j/IgP5/yEC+P8wFPf/LBHw/xwB5f8aAtr/GALO/xUCwv8SAbT/EAGm/wwBmP8KA4r6GhOIZxMJnKsQAaf/FwLM/x4D6f8iA/j/IgP6/yID+v8hAvr/Kgz6/5iK/P+Kevv/Iwbx/x0C5f8aAtf/FwLK/xQCvP8RAa3/DgGe/woBjv8SC4e1EQad3BIBtf8cAt7/IgP3/yID+v8iA/r/IgP6/yAB+v8+JPr/6+j+/9rV/v8yFfn/HwLu/xwC4P8YAtH/FQLC/xIBs/8PAaP/CwGS/w4Hh+MQBZ/uFQHB/x8D7f8iA/r/IgP6/yID+v8iA/r/HwD6/1E4+//08///6OX+/0Em+/8fAfT/HgPm/xoC1v8WAsf/EwK2/xABpv8LAZX/DQaH9hEFoe4XAsn/IQP0/yID+v8iA/r/IgP6/yID+v8eAPr/Z1H7//z8///08v//Uzv7/x8A+P8fA+r/GgLZ/xcCyf8TArj/EAGn/wsBlv8NBoj2Ewaj2hcCyv8hA/b/IgP6/yID+v8iA/r/IgP6/x4A+v9/bfz///////z8//9pVPv/HgD5/x8D7P8bAtr/FwLJ/xMCuP8QAab/CwGU/w8HiOIWCaSoFgLD/yED9f8iA/r/IgP6/yID+v8iA/r/IAH6/5mL/P///////////4Jx/P8eAPj/HwPr/xoC2f8WAsj/EwK2/w8Bo/8LAZH/EwyIsxsPp1kUA7f3HwPv/yID+/8iA/r/IgP6/yID+v8iA/r/qp/9////////////lIX9/x8A9/8eA+j/GQLV/xUCw/8SAbH/DgGe/wsDjPkbFIljMSS2EhUIq78bAtr/IgP6/yID+v8iA/r/IgP6/yID+v+sof3///////////+Xifz/HgDz/xwC4P8XAs7/FAK7/xABqf8LAZX/EAiJxTEojRYMAZsAHhKpSxYEuvAfA+7/IgP7/yID+v8iA/r/IgP6/62i/f///////////5eJ+v8cAOj/GQLV/xUCw/8SAbD/DQGd/wwEjfMbFIlRAgCBAD0vxwCMf/MCGQyodhYDw/kfA+//IgP7/yID+/8hAfr/l4j9////////////fm/w/xcA2P8WAsb/EgK0/w4Bof8MA5D7FQ6Jfm9moAM9NJQANCbAACUYsQAwJLUFGg2odRYFvO8bAt7/IAPx/yAC9v85H/X/g3Ty/3pt6f8qFdT/FAHC/xIBsf8OAZ//DQSQ8RYPins5MY4HKCCMADQskgAAAAAAHhGuACcbrwC0r+sCHhOkRxUHqrgUA7j0FgLF/xUAyf8SAMX/EQC8/xAAsf8PAqP/DgOX9RAIjrwaE4tLf3ehAiUdiwAgGIkAAAAAAAAAAAAAAAAAPTG7AEY6vwARBp0ALCOhDxoQm1EVCpydEgedzhEGm+QQBpjkEAeTzxIKj58YEYxULiiOEAkBhgA6M5QAMCiRAAAAAAAAAAAAwAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAQAMAAMAA=
	ENDTEXT
	
	SET SAFETY OFF 
	STRTOFILE(STRCONV(m_icon,14),"alert.ico")
	SET SAFETY ON 
	
	m.osystray = Createobject("ysystray")

   
	    
	Grabar_Log('Acceso al sistema, antes de autenticar') 
	 
	DO directivasfiscal    && en procfiscal.prg
	DO directivasHasar
	
   * =MESSAGEBOX(amodelofiscal[1])	  
   
	= Fwin32()    && funciones api win32
	
	
	Grabar_Log('Obteniendo conexion a servidor') 
	 =ObtenerServidor()
	  
	IF LEN(TRIM(LcConectionString))=0
		Grabar_Log('Solicitando nueva conexion a servidor') 
		DO FORM configbd
		=ObtenerServidor()
	ENDIF    

	PUBLIC loConnDataSource,lcIdObjCon,lcIdObjneg,lcServidor,ObjNeg
	
	*Marcos 19/12/14 No tiene utilidad esto.
	*LeerXMLClassID("objetodll.xml")
	
	Grabar_Log('Verificando Licencia') 
	=  Licencia()
	
	If lldesarrollo 
		oavisar.usuario('Conectado a  '+ALLTRIM(goapp.servidor)+'\'+LTRIM(goapp.initcatalo))
	ENDIF 
	
	Grabar_Log('Conectado..'+goapp.servidor) 
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

	Grabar_Log('Datos de la empresa') 
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
	Goapp.sucursal10   = Goapp.sucursal   && si sucursal10#0 en proc almacenado de insert suma 10 y concatena el numero de id obtenido, ver odata
	
	*--------------Codigo para que abra el form
    _screen.visible=.t.	   
	_screen.lockscreen=.f.
	_screen.Show() 

	DO FORM frmlogin
	
	_screen.lockscreen=.t.		 
	*--------------------------   
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
	
	lnuevomenu = IIF(oConfigTermi.MenuRibbon="TRUE",.t.,.f.)
	IF NOT lnuevomenu
		LOCAL oMenu
		oDesktop = ''
		oMenu = NEWOBJECT("createmenu","menu.vcx",.NULL.,.T.,odesktop,Goapp.perfilusuario,"'verdana',9","")
		oMenu.createMenu('datamenu','seguridad','favoritos',pidsistema)   
		oMenu = null
	ELSE
		_screen.AddObject('oMenuNative','base_menu')
		_screen.oMenuNative.Inicializar('Csrdatamenu',.f.)
	ENDIF 

	LeerEjercicioPerfil()
	
*!*		Grabar_Log('Verificando Licencia') 
*!*		IF NOT lEstadoLicencia 
*!*			CANCEL 
*!*			CLEAR ALL
*!*			RETURN 
*!*		ENDIF 
	
	Grabar_Log('Acceso exitoso') 
	IF NOT lnuevomenu 
		IF oConfigTermi.MenuDashBoard='FALSE'
			DO FORM frmmenu3
		ELSE 
			DO FORM frmmenu_DashBoard
		ENDIF 
		IF goapp.openfac = 1
			DO FORM regfacpub
		ENDIF 
	ENDIF 
	                     
	 _screen.visible=.t.	   
	_screen.lockscreen=.f.
	
	
	

*!*		public pcTextoBalloon, poSysTray, poTimer
*!*	  
*!*		  DO SETS_INICIALES
*!*		  
		  DO DECLARAR_FUNCIONES_API
*!*	  
*!*			 
*!*		poSysTray = CreateObject("WALTER_SYSTRAY")
*!*	  
*!*	  
*!*		  IF Vartype(poSysTray) == "O" THEN       && Si se pudo crear el objeto
		poTimer   = CreateObject("WALTER_TIMER")
*!*		  	
	  	IF oConfigTermi.ShowBalloonTip = 'FALSE'
    			poTimer.Enabled = .f.
   		ENDIF 
*!*	    
*!*		  		
*!*		    #DEFINE ICONO_NADA  0
*!*		    #DEFINE ICONO_INFO  1
*!*		    #DEFINE ICONO_AVISO 2
*!*		    #DEFINE ICONO_ERROR 3
*!*		    *poSysTray.ShowBalloonTip(pcTextoBalloon, "Ejemplo de un balloon", ICONO_NADA, 0)
*!*		    *poSysTray.RemoveIconFromSystray()     && El icono del menú es ocultado, el usuario no podrá verlo
*!*		    *READ EVENTS                           && Procesa los eventos, o sea que le permite al usuario elegir opciones del menú
*!*		
		
*!*		  ENDIF

	Read events   
	
	
	*poSysTray = .NULL.
  	*poTimer   = .NULL.
  
 	 *RELEASE poSysTray, poTimer
  
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

FUNCTION Recupera_App
	LPARAMETER nHwnd,llEstado

	DECLARE Integer SetForegroundWindow IN WIN32API Integer nHwnd

	_SCREEN.MousePointer = 0    
	SetForegroundWindow(nHwnd)   && Esto para abrir boca

	DECLARE SHORT SetWindowPos IN USER32 INTEGER hWnd,INTEGER hWndInsertAfter,INTEGER x,INTEGER y,INTEGER cx,INTEGER cy,INTEGER uFlags

	#DEFINE HWND_TOPMOST_WINDOW -1
	#DEFINE SWP_NOMOVE 2
	#DEFINE SWP_NOSIZE 1
	#DEFINE SWP_SHOWWINDOW 0x40
	#DEFINE SWP_BRINGTOTOP SWP_NOSIZE + SWP_NOMOVE + SWP_SHOWWINDOW
	#DEFINE HWND_NOTOPMOST     -2
	 
	DECLARE INTEGER GetLastError IN WIN32API
	&& Se asume que nHwnd es el hWnd del form que hay que poner encima
	_SCREEN.MousePointer = 0
	IF !llEstado
	   IF SetWindowPos(nHwnd,HWND_TOPMOST_WINDOW,0,0,0,0,SWP_BRINGTOTOP) # 0
	      RETURN .T.  &&  Funciona
	     ELSE
	      RETURN .F.  &&  Oooops
	   ENDIF
	 ELSE
	   IF SetWindowPos(nHwnd,HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE + SWP_NOMOVE) # 0
	      RETURN .T.  &&  Funciona
	     ELSE
	      RETURN .F.  &&  Oooops
	   ENDIF
	ENDIF 
ENDFUNC	

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
*!*	*
*!*	PROCEDURE MI_PROCEDURE_SALUDA
*!*	  
*!*	  =Messagebox("Hola, ¿cómo estás hoy?")
*!*	  
*!*	ENDPROC
*!*	*
*!*	*
*!*	PROCEDURE SETS_INICIALES
*!*	  
*!*	  SET CENTURY ON
*!*	  SET DATE    DMY
*!*	  SET SAFETY  OFF
*!*	  SET TALK    OFF
*!*	  
*!*	ENDPROC

PROCEDURE GMUPDATE
LOCAL cComando

cComando = ADDBS(SYS(5)+CURDIR())+'gmupdate.bat' 
IF NOT lldesarrollo
	RUN &cComando
ELSE
	oavisar.usuario('Actualizar!')
ENDIF 

ENDPROC 

*
*
*!*	DEFINE CLASS WALTER_SYSTRAY AS SYSTRAY OF "SYSTRAY.VCX"
*!*	  
*!*	  IconFile      = ADDBS(SYS(5)+CURDIR()) + "pyro.ICO"
*!*	  MenuText      = "4;Bienvenida;5;Mensaje;6;Salir"
*!*	  MenuTextIsMPR = .F.
*!*	  TipText       = "Ejemplo de un programa en la barra de tareas del Windows"
*!*	  *
*!*	  *
*!*	  PROCEDURE BalloonClickEvent     && El usuario hizo clic sobre el "balloon"
*!*	    
*!*	   * stop()
*!*	    =MessageBox("Hiciste clic sobre el BalloonTip, y yo lo detecté")
*!*	*!*	    LOCAL cRuta
*!*	*!*		cRuta = ADDBS(SYS(5)+CURDIR())+'close.bat'
*!*	*!*		IF FILE(cRuta)
*!*	*!*			RUN &cRuta
*!*	*!*		ENDIF 

*!*	  ENDPROC
*!*	  *
*!*	  *
*!*	  PROCEDURE ProcessMenuEvent     && Aquí se debe procesar la opción elegida por el usuario
*!*	  LPARAMETERS tnMenuItemID
*!*	    
*!*	    DO CASE
*!*	      CASE tnMenuItemID = 0     && Salió sin elegir opcion, nada se debe hacer entonces
*!*	      CASE tnMenuItemID = 1     && Eligió la primera opción
*!*	        =ShellExecute(0, "OPEN", "NOTEPAD.EXE", "", "", 1)
*!*	      CASE tnMenuItemID = 2     && Eligió la segunda opción
*!*	        =ShellExecute(0, "OPEN", "CALC.EXE", "", "", 1)
*!*	      CASE tnMenuItemID = 3     && Eligió la tercera opción
*!*	        =ShellExecute(0, "OPEN", "MSPAINT.EXE", "", "", 1)
*!*	      CASE tnMenuItemID = 4     && Eligió la cuarta opción
*!*	        =MessageBox("Un mensaje de bienvenida")
*!*	      CASE tnMenuItemID = 5     && Eligió la quinta opción
*!*	        DO MI_PROCEDURE_SALUDA
*!*	      CASE tnMenuItemID = 6     && Eligió la sexta opción
*!*	        This.RemoveIconFromSystray()
*!*	        CLEAR EVENTS
*!*	    ENDCASE
*!*	  
*!*	  ENDPROC
*!*	  *
*!*	  *1
*!*	ENDDEFINE
*
*
DEFINE CLASS WALTER_TIMER AS TIMER
  
  Enabled  = .T.
  Interval = 2000     && El control TIMER trabaja con milisegundos, por lo tanto 10.000 milisegundos equivalen a 10 segundos10
  
  PROCEDURE TIMER
 * stop()
   cVersion = HayVersionExe("gestion.exe",pidsistema )
    IF LEN(cVersion)> 0
    	
    	
	  *  poSysTray.AddIconToSystray()          && El icono del menú es mostrado para que se pueda ejecutar el método ShowBalloonTip()
	   * poSysTray.ShowBalloonTip("EXISTE UNA NUEVA VERSION"+CHR(13)+"SALIR PARA ACTUALIZAR EL SISTEMA", "Nueva Version", ICONO_INFO,30)
	    *poSysTray.RemoveIconFromSystray()     && El icono del menú es ocultado, el usuario no podrá verlo
	    FrmMenu3.Cont_Status.Cont_Update1.lbl.Caption = "EXISTE UNA NUEVA VERSION"

*!*			IF oConfigTermi.controlskin = 'TRUE'
*!*				_SCREEN.lcMensajeClickPopup = "EXISTE UNA NUEVA VERSION"   &&MENSAJE QUE APARECE PARA CUANDO SE DESEA PRESIONAR CLICK EN EL POPUP
*!*				_SCREEN.lcComandoPopup      = "GMUPDATE()"   &&COMANDO A EJECUTAR CUANDO SE PRESIONA EN EL MENSAJE CLICK DEL POPUP
*!*				_SCREEN.lnStyloPopup        = 2         &&ESTILOS DEL POPUP
*!*			
*!*				lcCaption = "GM Solutions"   			&&TITULO CAPTION DEL POPUP
*!*				lcMessage = "Existe una actualización importante del sistema"	&&MENSAJE A MOSTRAR EN EL POPUP

*!*				VFPs_MessagePopup (lcCaption,lcMessage)
*!*			ENDIF 

		m_tipo=1	&& ICONO DEL MENSAJE 0=icono predeterminado 1=Información 2=Alerta 3=Error 4=Informacion importante
		m_duracion=10

		*m.osystray.ShowBalloonTip("El sistema DEMO caducara dentro de : 30 Dia(s)", "Información" , m_tipo,m_duracion)
		m.osystray.ShowBalloonTip(cVersion, "GM Solutions" , m_tipo,m_duracion)


	    &&Subimos el intervalo porque el usuario ya vio el mensaje
	    This.Interval =   30000 
		
	ENDIF 
	This.Enabled = IIF(lldesarrollo,.f.,This.Enabled)
  ENDPROC
  *
  *
ENDDEFINE

