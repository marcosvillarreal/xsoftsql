 PARAMETER llVisible, lcCamf_Appli
 WITH _SCREEN
*- Por Camf para centrar o_mysidebar1. Tenemos que configurarlo desde aqu� y en modo FNS tiene su configuraci�n en _mysidebar     IF "CAMFFUNCTION"$SET("CLASS")
	 IF "CAMFFUNCTION" $ SET("CLASS") && Por Camf
	 	IF VARTYPE(_SCREEN.camf_engine1)="O"	&& Si tenemos activado el motor
			LOCAL lcEngine, lnHeightStatus
				lcEngine = "Camf_Engine1."
				lnHeightStatus = 0
				IF ! EMPTY(.&lcEngine._MyStatusBar)
				LOCAL lcStatusBar
					lcStatusBar = .&lcEngine._MyStatusBar + "."
					lnHeightStatus = IIF(.&lcStatusBar.VISIBLE, 0, 22) 
				ENDIF
		ENDIF
       
		LOCAL lcScreen
			lcScreen = IIF(lcCamf_Appli="Screen", "_Screen", lcCamf_Appli)
			.o_mysidebar1.TOP    = IIF(VARTYPE(_SCREEN.camf_engine1)="O", &lcScreen..Function1.RESIZE("Top"), 122)
			.o_mysidebar1.HEIGHT = IIF(VARTYPE(_SCREEN.camf_engine1)="O", &lcScreen..Function1.RESIZE("Height") + 2 + lnHeightStatus, 600-25)
			.o_mysidebar1.left = 0	&&&lcScreen..Function1.resize("Left",   &lcScreen)
			*.o_mysidebar1.Width = &lcScreen..Function1.resize("Width",  &lcScreen)
			.o_mysidebar1.Anchor = 5
       
		IF llVisible
			.o_mysidebar1.visible = .T.
		ENDIF
	ENDIF
 ENDWITH