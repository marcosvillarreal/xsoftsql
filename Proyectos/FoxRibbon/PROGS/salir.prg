*FUNCTION SALIR()
*IF MESSAGEBOX('¿Realmente desea salir?',4+32+256,'Seleccione, por favor')=6
*- Comprueba si se han efectuado cambios antes de salir. 

 PARAMETER lcCamf_Appli
 LOCAL lcScreen
	 lcScreen = IIF(lcCamf_Appli="Screen", "_Screen.", lcCamf_Appli + ".")
 IF VARTYPE(&lcScreen.camf_engine1)="O"  && Si tenemos activado el motor
    LOCAL lcMessageTitle, lcMessageText, lnAnswer, lcButtons
    IF  &lcScreen.Camf_Engine1.lChange AND ! EMPTY(_SCREEN.oRibbon.FileIni)
    
       lcMessageTitle = _SCREEN.oRibbon.Translate("OTH002", "Warning")
       lcMessageText = _SCREEN.oRibbon.Translate("MFQUESTION1", "The style has changed. Save changes?")
       lcButtons = _SCREEN.oRibbon.Translate("OTH007", "\<Yes") + "," + ;
	       _SCREEN.oRibbon.Translate("OTH008", "\<No") + "," + ;
    	   _SCREEN.oRibbon.Translate("OTH005", "\<Cancel")
       lnAnswer = _SCREEN.oRibbon.MESSAGEBOX( ;
     		lcMessageText, "?", lcMessageTitle, lcButtons)
       DO CASE
          CASE lnAnswer = 1 && Si
             &lcScreen.camf_engine1.SaveAs(.F.)
          CASE lnAnswer = 2 && No
          
          CASE lnAnswer = 3 .OR. lnAnswer = 0 && Cancelar
             RETURN .F.
       ENDCASE
    ENDIF
 ENDIF
 
 LOCAL lnValue
	 lnValue = _SCREEN.oRibbon._MessageBoxL("¿Realmente desea salir?", 32, "Seleccione, por favor     ", "Sí,No", "", 0)

 IF lnValue=2
    IF lcCamf_Appli = "Screen"
       CLEAR EVENTS
    ELSE
       RETURN .T.
    ENDIF
 ELSE
    RETURN .F.
 ENDIF