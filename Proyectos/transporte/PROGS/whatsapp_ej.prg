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
   *cNroWhatsapp =  '542915128797'
   *cMensaje = 'Hola Amor'
   comando='whatsapp://send?phone='+cNroWhatsapp+"&text="+cMensaje+""
  =ShellExecute(0, 'open', Comando,'', '', 1)
  **************************
  WAIT "" TIMEOUT 3
  lt = "Whatsapp"  
  lhwnd = FindWindow (0, lt)  
  IF lhwnd!= 0 && Comprueba si la ventana está activada 
     SetForegroundWindow (lhwnd) && Establece el foco en la ventana de la aplicación donde Tú envías la llave. 
     ShowWindow (lhwnd, 1)
     ox = CREATEOBJECT ( "Wscript.Shell" )
     ox.sendKeys ( '{ENTER}' )
     RETURN .t.
 ELSE 
     MESSAGEBOX ( "Whatsapp no activada!" )
     RETURN .f.
 ENDIF