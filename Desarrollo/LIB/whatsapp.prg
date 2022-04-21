FUNCTION EnviarWhatsapp
PARAMETERS cNroWhatsapp, cMensaje,cFilePath

  
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
     
     _cliptext = cFilePath
     
     =INKEY(5)
	FOR i=1 to 10
		ox.sendkeys ("{TAB}")
		WAIT WINDOW ("TAB" + STR(i)) nowait
		=INKEY(.2)
	ENDFOR
	ox.sendkeys ("{ENTER}")
	=INKEY(1)
	ox.sendkeys ("{UP}")
	ox.sendkeys ("{UP}")
	ox.sendkeys ("{UP}")
	ox.sendkeys ("{UP}")
	ox.sendkeys ("{ENTER}")
	=INKEY(1)
	ox.sendkeys ("^{v}")
	ox.sendkeys ("{ENTER}")
	=INKEY(2)
	ox.sendkeys ("{ENTER}")
     RETURN .t.
 ELSE 
     MESSAGEBOX ( "Whatsapp no activada!" )
     RETURN .f.
 ENDIF