*===================
*= ARCHIVO PRINCIPAL
*===================

set classlib to
l='j:'
set talk off
lldesarrollo=(_vfp.startmode()#4)

_vfp.AutoYield = .f.

lctituloGestion = "Launcher GM"
 

If !lldesarrollo
   If f_activawin(lctituloGestion)
  
      =messagebox('Ya Estaba activo !!!!',48,'Información al Usuario')
     _Screen.windowstate=2
      _screen.lockscreen=.f.
      _screen.visible=.t.
      _screen.refresh      
			 * El programa ya estaba activo:
      Return && Termina el programa
   Endif
Endif

Set cursor off

lccaption=_screen.caption

Set cursor on



lcdd=alltrim(curdir()) && directorio de arranque
lcsys = '\xsoftsql'
If lldesarrollo
   lcdd=L+lcsys+'\proyectos\launcher\'
*-- RUTA
   _rutaclases =lcdd+'Clases'
   _rutaclased =L+lcsys+'\desarrollo\clases'
   _rutabmpd   =L+lcsys+'\desarrollo\graficos'
   _rutaprogs  =lcdd+'Progs'
   _rutamenu   =lcdd+'Menus'
   _rutadatos  =lcdd+'Datos'
   _rutabmps   =lcdd+'graphics'
   _rutaforms  =lcdd+'forms'
   _rutareports=lcdd+'reports' 
   _rutaformsDesarrollo =L+lcsys+'\desarrollo\forms'
   _rutaffc  =L+lcsys+'\desarrollo\clases\ffc'
   _rutalib  =L+lcsys+'\desarrollo\lib'
   Set default to (lcdd) &&;(lcddc)

   Set path to &_rutaclases,&_rutaprogs,&_rutamenu,&_rutadatos,&_rutabmps,&_rutaforms;
               ,&_rutareports,&_rutaclased,&_rutabmpd,&_rutaformsDesarrollo,&_rutaffc;
               ,&_rutalib
Endif

*-- CREACION DE OBJETO APLICACION

Set classlib to aplicacion.vcx additive && Objeto Aplicacion

*-- APERTURA DE CLASES Y ARCHIVOS DE PROCEDIMIENTOS

   SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos 
   SET PROCEDURE  TO  procdesarrollo.prg ADDITIVE  && Procedimientos generales
   SET PROCEDURE TO proclocal.prg ADDITIVE 
   SET PROCEDURE  TO  syserror.prg ADDITIVE  
   SET PROCEDURE  TO procfiscal.prg ADDITIVE 
   SET PROCEDURE  TO registry.prg ADDITIVE 
   SET CLASSLIB  TO  clasesgenerales ADDITIVE 
   SET CLASSLIB  TO  controles ADDITIVE 
   SET CLASSLIB  TO  iabm.vcx ADDITIVE 
   SET CLASSLIB  TO  icontrolespersonalizados ADDITIVE 
   SET CLASSLIB TO odata ADDITIVE 
   SET CLASSLIB TO _reportlistener.vcx ADDITIVE 
   
    SET PROCEDURE TO  foxypreviewercaller ADDITIVE 
   SET PROCEDURE TO FoxBarcodeQR ADDITIVE
   SET PROCEDURE  TO  SOVfp.prg ADDITIVE
   
*clear all

_screen.lockscreen=.t.
SET SYSMENU off	
* _Screen.windowstate=2
_Screen.caption=lctituloGestion
_Screen.icon='laun.ico'
_screen.picture= 'fondo.jpg'    &&'logoempresa.bmp'
_Screen.closable=.f.
IF !lldesarrollo
	_Screen.Height=430
	_Screen.Width=825
endif

_screen.AutoCenter= .T.
_screen.TitleBar= 0
_Screen.ControlBox= .t.
_Screen.visible= .f.  &&.t.

PUBLIC LcConectionString,LcDataSourceType,lcOrigenPublico,PcmsgIU,PcmsgIP,LcWebService
PUBLIC LcLlaveCf,Pnterminal,pnsucursal,lcClaveTerminal
PUBLIC oConfigTermi,pidsistema
   
 STORE '' TO LcConectionString,LcDataSourceType,lcOrigenPublico,LcWebService
 STORE 0 TO Pnterminal,Pnsucursal

pidsistema = 1

PUBLIC OAvisar
Oavisar=CREATEOBJECT('avisar')
 
Public goapp
goapp=createobject('app',!lldesarrollo,lldesarrollo)


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
	
	goapp.version = "03.00.00"
	
	PUBLIC  gcicono
	     
	PcmsgIU  = 'Información al Usuario'
	PcmsgIP  = 'Información al Programador'
	   
	gcicono=lcdd+'Laun.ico'
	LcLlaveCf = SPACE(8)
	      
	on error do errorsys
	           		                          
	do setup
	_screen.LockScreen= .t.   &&.f.
	 
	 
	 LeerConfigTermi()
	 
	DO directivasfiscal    && en procfiscal.prg
	DO directivasHasar
	  
	= Fwin32()    && funciones api win32
       
*!*		 =ObtenerServidor()
*!*		IF LEN(TRIM(LcConectionString))=0
*!*	  		_Screen.visible=.t.
*!*			DO FORM configbd
*!*			=ObtenerServidor()
*!*		ENDIF    

	PUBLIC loConnDataSource,lcIdObjCon,lcIdObjneg,lcServidor,ObjNeg

*!*		*stop()
*!*		*LeerXMLClassID("objetodll.xml")

*!*		   * en proc.prg   
*!*		IF ExisteDSN()  
*!*			IF !ConeccionADO()
*!*				CANCEL 
*!*				CLEAR ALL
*!*				RETURN 
*!*			ENDIF 
*!*		ELSE
*!*			CANCEL 
*!*			CLEAR ALL
*!*			RETURN 
*!*		ENDIF 
	
	WAIT CLEAR 

* en proc.prg

*!*		lcExe = ""
*!*		IF !lldesarrollo
*!*			SET SYSMENU TO
*!*			LeerVersionExe(2,@lcExe,nIdprograma)
*!*		Else	      	
*!*			 _screen.visible=.t.
*!*	    ENDIF
*!*		_screen.lockscreen=.f.
*!*		
*!*		lcidprograma=IIF(VARTYPE(nIdprograma)="C",nIdprograma,LTRIM(STR(nIdprograma)))
*!*		
*!*		IF  LEN(TRIM(lcExe))#0
*!*			oShell = createobject("WScript.Shell")
*!*			IF FILE(lcExe)
*!*				lcExe = ALLTRIM(lcExe)&&+" "+lcidprograma
*!*				oShell.run("&lcExe",0,.F.)	
*!*			ENDIF 			
*!*		ENDIF 	

	_screen.lockscreen=.t.	
	_screen.visible=.t.	
	   	 
	*IF !lldesarrollo	
		*SET SYSMENU TO
		DO FORM frmlauncher
		*DO FORM guardaexe
	*ENDIF 
		   
	*_screen.visible=.t.	   
	*_screen.lockscreen=.f.

	Read events   	
ENDIF

IF !lldesarrollo

	loConnDataSource = null 

	cancel all
	clear all
ENDIF  

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


PROCEDURE NUEVOIDSQL(TCALIAS,RetValor,LcOriCon)

	local LCALIAS
    RetValor = 0
	if parameters() < 1
	   RETURN 
	ENDIF    
	IF PARAMETERS() < 3
	   lcOriCon = 'ADO'
	ENDIF 
    LCALIAS = upper(TCALIAS)
	lCOriCon = UPPER(lcOriCon)
    IF lcOriCon='ADO'	
       SELECT * FROM Keysid WHERE Tabla=LCALIAS
	   IF !Lcalias$Keysid.tabla
	      INSERT INTO Keysid (Tabla,nextid,ctipocomp) VALUES (lcalias, 0 ,'')		   
       ENDIF           		
       UPDATE Keysid SET NextId = Nextid + 1 WHERE Tabla=lcalias
       RetValor = KeySid.nextid
    ELSE
   	   LNOLDAREA = select()
       lcdatabase = CursorGetProp("DATABASE",LCalias)
       lnrat      = rat('\',lcdatabase)
       lcdatabase = subs(lcdatabase,lnrat+1)        
	   LCOLDREPROCESS = set('REPROCESS')
       set reprocess to automatic	
       Lcids = iif(len(trim(lCdatabase))<>0,lcdatabase+'!KEYSID','KEYSID')        
	   if used("KEYSID")
	      Use in KEYSID
  	   endif

       Use &Lcids in 0 alias KEYSID

	   select KEYSID
       Set order to 1
	   IF !SEEK(alltrim(LCALIAS),"KEYSId", "tabla")
	      INSERT INTO Keysid (Tabla,nextid,ctipocomp) VALUES (lcalias, 0 ,'')		   
	   ENDIF
       if rlock()
          RetValor = KEYSID.NEXTID
	      replace KEYSID.NEXTID with KEYSID.NEXTID + 1
	      unlock
	   endif
       Use in KEYSID
	   select (LNOLDAREA)
	   set reprocess to LCOLDREPROCESS     
    ENDIF   
  	RETURN RetValor
ENDPROC

PROCEDURE OBTENERVADE(LcCodOso,RetValor,LcOriCon)

    RetValor = 0
	if parameters() < 1
	   RETURN 
	ENDIF    
	IF PARAMETERS() < 3
	   lcOriCon = 'ADO'
	ENDIF 
	RetValor = 0
	lCOriCon = UPPER(lcOriCon)
    IF lcOriCon='ADO'	
       SELECT TOP 1 count(vademecum.codOso) as lncant FROM Vademecum WHERE CodOso=lcCodOso
       IF Vademecum.lncant > 0
          Retvalor = 1
       ENDIF  
    ELSE
	   select VADEMECUM
	   RetValor = 0
	   IF SEEK(lcCodOso,"VADEMECUM", "CodOso")
	      RetValor = 1
	   ENDIF
    ENDIF   
  	RETURN RetValor
ENDPROC
