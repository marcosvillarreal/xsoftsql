FUNCTION EnviarWhatsapp
PARAMETERS cNroWhatsapp, cMensaje
DECLARE  INTEGER FindWindow IN WIN32API STRING , STRING  
DECLARE  INTEGER SetForegroundWindow IN WIN32API INTEGER  
DECLARE  INTEGER  ShowWindow  IN WIN32API INTEGER , INTEGER 
DECLARE INTEGER ShellExecute IN shell32.dll ; 
  INTEGER hndWin, ; 
  STRING cAction, ; 
  STRING cFileName, ; 
  STRING cParams, ;  
  STRING cDir, ; 
  INTEGER nShowWin
  
  LOCAL lt, lhwnd
  **************************
  *** Carga Whatsapp
  **************************
   *comando='whatsapp://send?phone=542915128797&text=Mensaje%0AWhatsapp%20espa..final...final'
   cNroWhatsapp =  '542916436628'
  cMensaje = '%0AC:\comprobantespdf\RTO X0000100007022.pdf'
   comando='whatsapp://send?phone='+cNroWhatsapp+"&text="+cMensaje+""
  =ShellExecute(0, 'open', Comando,'', '', 1)
  **************************
  WAIT "" TIMEOUT 3
  lt = "Whatsapp"  
  lhwnd = FindWindow (0, lt)  
  IF lhwnd!= 0 && Comprueba si la ventana est� activada 
     SetForegroundWindow (lhwnd) && Establece el foco en la ventana de la aplicaci�n donde T� env�as la llave. 
     ShowWindow (lhwnd, 1)
     ox = CREATEOBJECT ( "Wscript.Shell" )
     ox.sendKeys ( '{ENTER}' )
     
*!*	     _cliptext = "c:\sqlmenu.txt"
*!*	     
*!*	     =INKEY(5)
*!*		FOR i=1 to 10
*!*			ox.sendkeys ("{TAB}")
*!*			WAIT WINDOW ("TAB" + STR(i)) nowait
*!*			=INKEY(.2)
*!*		ENDFOR
*!*		ox.sendkeys ("{ENTER}")
*!*		=INKEY(1)
*!*		ox.sendkeys ("{UP}")
*!*		ox.sendkeys ("{UP}")
*!*		ox.sendkeys ("{UP}")
*!*		ox.sendkeys ("{UP}")
*!*		ox.sendkeys ("{ENTER}")
*!*		=INKEY(1)
*!*		ox.sendkeys ("^{v}")
*!*		ox.sendkeys ("{ENTER}")
*!*		=INKEY(1)
*!*		ox.sendkeys ("{ENTER}")
     RETURN .t.
 ELSE 
     MESSAGEBOX ( "Whatsapp no activada!" )
     RETURN .f.
 ENDIF