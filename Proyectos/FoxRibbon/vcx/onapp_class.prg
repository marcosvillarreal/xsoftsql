* OnApp
* Gesti�n de maximizar, restaurar y minimizar ventanas VFP 9.0 Sp2, Desconozco el funcionamiento en versiones anteriores.
* Camf
* https://visualfoxpro.webcindario.com
* Licencia Open Source
* 12 de Abril 2020
*
******************************
* Uso                        *
******************************
* OnApp es una clase Vfp que se creo para un correcto maximizado de las ventanas, es decir, con WindowState Real, cuando
* creamos aplicaciones sin la barra de t�tulos del sistema TitleBar = 0. Es funcional con Multi-pantallas.
* Visual FoxPro tiene un Bug cuando maximizamos una ventana sin barra de titulo TitleBar = 0 que consiste en maximizar
* la citada ventana tapando u ocultando la barra de Windows.
*
* La funcionalidad de esta clase es �nica y exclusiva de minimizar, maximizar y restaurar ventanas Vfp. Funciona en _Screen y formularios.
*
* Crear objeto en _Screen. Introduzca el siguiente c�digo en su Main.prg:
* SET PROCEDURE TO LOCFILE("Prog\onapp_class.prg") ADDITIVE  
* _SCREEN.AddObject("OnApp", "OnApp") 
*
* Crear objeto en formulario. Introduzca el siguiente c�digo en el evento Load:
* SET PROCEDURE TO LOCFILE("Prog\onapp_class.prg") ADDITIVE &&, LOCFILE("gpImage2.prg") 
* thisform.AddObject("OnApp", "OnApp") 					
*
* Llamada: 
* thisform.OnApp.WindowState = x. Ej. para maximizar nuestra ventana, thisform.OnApp.WindowState = 2
*
*
******************************
* Historial de Cambios       *
******************************
*
*
*****************************
* Bugs                      *
*****************************
* Problema de minimizado cuando WindowState = 2 resuelto pero con vuelta a WindowState = 0.
* Si al minimizar WindowState ten�a un valor de 2, primero pasamos a un valor de 0 y luego a 1
* pues luego al restaurar, lo hace el propio sistema quedando est� clase fuera del alcance. Cuando el
* estado anterior es WindowState = 0 no presenta problemas, pero si su valor es de 2 se restaurar�a
* al �ltimo valor antes de minimizar(1) que es 2 y nos tapar�a la barra de Windows.
* Siempre que minimizamos, independientemente del WindoState actual, 2 o 0, restauramos a un valor 0
*
*
********************************
********************************
* Versi�n 1.0 beta 12/04/2020  *
*	Inicio de la librer�a      *
********************************
********************************

* OnApp
 DEFINE CLASS OnApp as Container
		Version = "1.0 Beta"
		WindowState = 0	
		*Solo cuando utilizamos simulaci�n
		OldBorderStyle = 0 
		OldLeft = 0
		OldTop  = 0
		OldHeight = 0
		OldWidth  = 0
		
		lnMode = 2				&& Podemos elegir un determinado comportamiento (1 y 2 -> Con) (3 - Sin) simulaci�n
								&& Ejemplo _Screen sin simulaci�n y forms con simulaci�n. Valor por defecto .T.
								&& Simulaci�n de maximizado con los  modos 1 y 2.				
						   		&& Con c�digos diferentes llegamos a los mismos resultados  
		FullScreen = .F.		&& .T. -> No respeta la barra de Windows. Si lnMode = .F. no funciona
		BorderStyleYes = .T.	&& .T. Indica que queremos visualizar el BorderStyle que utilizamos en la ventana
		BorderStyleValue = 0    && Indicamos con que borde se maximiza la ventana 0 - 1 - 2 - 3 
								&& No se tiene en cuenta si BorderStyleYes = .T.
								&& El valor normal es 0. Cualquier valor que exceda el rango se considera 0
*- Init ---------------------------------------------------------------------------------------------------------------			

		PROCEDURE init
			*IF thisform.Name # "Screen"
			*IF thisform.Desktop &&Con Desktop = .T. utilizamos maximizado simulado
			*	this.lnMode= 1
			*ENDIF 
			
			*this.BorderStyle = thisform.BorderStyle
*			DECLARE INTEGER SystemParametersInfo IN user32 INTEGER, INTEGER, STRING @, INTEGER
			DECLARE INTEGER SystemParametersInfo IN user32 INTEGER, INTEGER, STRING @, INTEGER			
*			DECLARE INTEGER SetWindowLong IN WIN32API LONG, INTEGER, LONG		&& En app o activa esta o la siguiente
*			*DECLARE INTEGER SetWindowLong IN user32 LONG, INTEGER, INTEGER		&& Ribbon
*			DECLARE INTEGER GetWindowLong IN WIN32API LONG, INTEGER				&& En Ribbon esta y las de arriba

			*- S�lo necesaria en simulado de maximizaci�n
		
			IF this.lnMode # 3
				this.SetParamForm()
			ENDIF
				
		ENDPROC
		
*----------------------------------------------------------------------------------------------------------------------
*- WindowState --------------------------------------------------------------------------------------------------------	

			* Estado del Formulario o _Screen
	PROCEDURE WindowState_assign
		LPARAMETERS vNewVal
		*To do: Modify this routine for the Assign method
		WITH thisFORM
		IF .ShowWindow # 2 AND .Name # "Screen"	AND !((.ShowWindow = 0 OR .ShowWindow = 1) AND .Desktop = .T.) 	&& Excepciones que hacen uso normal de WindowState
																  												&& no la ventana principal y no Fns
			IF m.vNewVal = 1																					&& S�lo ventanas internas
				* Minimizado																					&& (.ShowWindow = 0 OR .ShowWindow = 1) AND .Desktop = .F.
				.WindowState = 1
			ELSE && this WindowState = 0 o 2
				IF this.WindowState = 0
					this.OldBorderStyle = .BorderStyle
				ENDIF
				IF this.BorderStyleYes			 				&& BorderStyle 0 para maximizar simulado, puede utlizar
					.BorderStyle = this.OldBorderStyle			&& cualquier BorderStyle que quedar� contenido en
				ELSE											&& la pantalla pero no recomiendo el 3 
					*- 7. Elegir BorderStyle a utilizar con la ventana maximizada
					IF this.BorderStyleValue >= 0 AND this.BorderStyleValue <=3
						.BorderStyle = this.BorderStyleValue	&& BorderStyle 0 para maximizar simulado, puede utilizar
					ELSE										&& cualquier BorderStyle que quedar� contenido en
						.BorderStyle = 0						&& la pantalla pero no recomiendo el 2 ni el 3
					ENDIF
				ENDIF											&& del WindowState del Sistema
				.WindowState = IIF(.WindowState = 0, 2, 0)
				this.WindowState = .WindowState	
				
				IF this.WindowState = 0
					.BorderStyle = this.OldBorderStyle	
				ENDIF
			ENDIF
			
		ELSE													&& Aplicamos la clase assign
			
			IF this.WindowState <> m.vNewVal

				DO CASE 
					CASE m.vNewVal = 0
						* Restaurar
						IF TYPE("thisform.WindowState")<>"U"
							IF this.lnMode = 3
								IF this.FullScreen
									.Windowstate = 0
								ELSE
									this.ChangeState(0)
									.BorderStyle = this.OldBorderStyle	&& Utilizar pone borde 2 0 3 obligatorio para
																		&& no recortar la pantalla con bordde 0
								ENDIF		
							ELSE 
								this.RestoreWindow() 			&&- Simulado - Recuperamos posiciones de memoria
							ENDIF 
						ENDIF
						this.WindowState = 0
						*this.WindowState = m.vNewVal
								
					CASE m.vNewVal = 1
						* Minimizado
						
						IF TYPE("thisform.WindowState")<>"U"
							IF this.lnMode = 3
								IF this.FullScreen
									.WindowState = 1	
								ELSE
									IF this.WindowState = 2		&& Cuando tenemos la ventana maximizada
										this.ChangeState(0) 	&& Primero la restauramos, de lo contrario, posteriormente al 
						   			ENDIF			        	&& restaurar, tapamos la barra de Windows	
						   			this.ChangeState(1)
						   			this.WindowState = 0 
						   		ENDIF
							ELSE
								.WindowState = 1
							ENDIF	
						ENDIF	
					CASE m.vNewVal = 2
						* Maximizado
						this.OldBorderStyle = .BorderStyle		&& Utilizar siempre
							
						IF this.lnMode = 3
							IF this.FullScreen
								.WindowState = 2
							ELSE
								BorderStyle = 2                	&& Con borde 2 0 3 al maximizar
								this.ChangeState(2)
							ENDIF
						ELSE
							this.MaximizeWindow()				&&- Simulaci�n de Maximizado  
						ENDIF 
						this.WindowState = m.vNewVal				
				ENDCASE	
				
			ENDIF

		ENDIF
		*WITH  this.ControlButtons.ButtonMax
		* 	.IMAGE1.Picture = IIF(thisform.WINDOWSTATE=2 OR THIS.WindowState=2, .IMAGEF.Picture, .IMAGET.Picture)
		*ENDWITH	
	ENDPROC

*- ChangeState --------------------------------------------------------------------------------------------------------				
	PROCEDURE ChangeState
	PARAMETERS pWindowState
	LOCAL lcmacro

		WITH thisform
			
			IF .Titlebar = 0
				lcmacro= IIF(.name="Screen","_VFP." , "thisform.")
				
				setwindowlong(&lcmacro.hwnd, -16, BITOR(getwindowlong(&lcmacro.hwnd, -16), 12582912))
				setwindowpos(&lcmacro.hwnd, 0, 0, 0, 0, 0, BITOR(00032, 00002, 00001, 00004))
				IF TYPE(".WindowState")<>"U"
				   .WindowState = pWindowState
				  * MESSAGEBOX(lcmacro)
				ENDIF
				setwindowlong(&lcmacro.hwnd, -16, BITAND(getwindowlong(&lcmacro.hwnd, -16), 4282384383 ))
				setwindowpos(&lcmacro.hwnd, 0, 0, 0, 0, 0, BITOR(00032, 00002, 00001, 00004))
				 *RETURN DODEFAULT() &&Solo estaba cuando veniamos de minimizar
			ELSE
				.WindowState=2
			ENDIF	

		ENDWITH			
	ENDPROC		
*----------------------------------------------------------------------------------------------------------------------

*- S�lo con simulaci�n de maximizado
*- MaximizeWindow -------------------------------------------------------------------------------------------------------				 
	PROCEDURE MaximizeWindow
	LOCAL lnLeft, lnTop, lnWidth, lnHeight
		
		WITH thisform	
			IF .TitleBar = 0 
				
				*- Guardamos par�metros
				this.SetParamForm() 
	
				*- Variables locales para redimensionar las pantallas
				LOCAL lnHeightSysMenu, lnTopSysMenu, lnLeftMultiScreen, lnTopMultiScreen, lnHeightStatusBar, llMultiScreen,;
						lnLeft, lnTop, lnWidth, lnHeight 
				lnHeightSysMenu   = 0
				lnTopSysMenu      = 0
				lnLeftMultiScreen = 0
				lnTopMultiScreen  = 0
				lnHeightStatusBar = 0
				llMultiScreen = .F.
				lnWidth  = 0
				lnHeight = 0
																
				*- 1. Si usamos los menus de Vfp
				IF !SET("SYSMENU") = "OFF"	AND .Name = "Screen" &&
					lnHeightSysMenu  = 20 && 21														
				ENDIF
						
				*- 2. Si tenemos activado STATUS BAR en la ventana principal
				IF SET("STATUS BAR") = "ON" AND .Name = "Screen"  
					lnHeightStatusBar = 25
				ENDIF

				*- 3. Comprueba si usa MultiScreen - Activaci�n autom�tica
				*- Sobrepasamos por la derecha       o    por la izquierda
				IF (.Left + .Width/2) > Sysmetric(1) OR (.Left + .Width/2) < 0
					.BorderStyle = 0 && No lo borre o cambie su valor. Es obligatorio.
					.WindowState = 2						
						
					IF !((.ShowWindow = 0 OR .ShowWindow = 1) AND .Desktop = .T.)
						lnLeftMultiScreen = .Left + 8
						lnTopMultiScreen  = .Top  + 8
					ELSE
						lnLeftMultiScreen = .Left
						lnTopMultiScreen  = .Top  
						lnWidth  = lnWidth  + 16
						lnHeight = lnHeight + 16
					ENDIF
					llMultiScreen = .T.
				ELSE 
					*- 4. Con men�s en la ventana principal Screen
					IF !SET("SYSMENU") = "OFF"	AND .Name = "Screen" 
						lnTopSysMenu = 20 && 21
					ENDIF			
				ENDIF 
				
				*- 5. Redimensionado todo 
				lnLeft   = lnLeftMultiScreen
				lnTop    = lnTopMultiScreen + lnTopSysMenu 
                lnHeight = lnHeight - lnHeightStatusBar - lnHeightSysMenu
           
                               
				*-    No cambie nunca el valor del BorderStyle = 0 o lo borre en MultiScrenn 
				*-    pues provocar� que cuando se active MultiScreen autom�tico no coincidiran los bordes
				*- 6. Utlizar el mismo BorderStyle que tiene la ventana .T. o .F.
				IF this.BorderStyleYes			 				&& BorderStyle 0 para maximizar simulado, puede utlizar
					.BorderStyle = this.OldBorderStyle			&& cualquier BorderStyle que quedar� contenido en
				ELSE											&& la pantalla pero no recomiendo el 3 
					*- 7. Elegir BorderStyle a utilizar con la ventana maximizada
					IF this.BorderStyleValue >= 0 AND this.BorderStyleValue <=3
						.BorderStyle = this.BorderStyleValue	&& BorderStyle 0 para maximizar simulado, puede utilizar
					ELSE										&& cualquier BorderStyle que quedar� contenido en
						.BorderStyle = 0						&& la pantalla pero no recomiendo el 2 ni el 3
					ENDIF
				
				ENDIF				 							
								 	    						 
				*- 8. Redimensionando coordenadas dependiendo de los par�metros de BorderStyle
				DO case
					CASE .BorderStyle = 0
						lnLeft   = lnLeft
						lnTop    = lnTop			
						lnWidth  = lnWidth
						lnHeight = lnHeight	
					CASE .BorderStyle = 1
						lnLeft   = lnLeft + IIF(.Name = "Screen", 1, 0)
						lnTop    = lnTop  + IIF(.Name = "Screen", 1, 0)		
						lnWidth  = lnWidth  - 2
						lnHeight = lnHeight - 2
					CASE .BorderStyle = 2
						lnLeft   = lnLeft + IIF(.Name = "Screen", 3, 0)
						lnTop    = lnTop  + IIF(.Name = "Screen", 3, 0)			
						lnWidth  = lnWidth  - 6
						lnHeight = lnHeight - 6
					CASE .BorderStyle = 3
						lnLeft   = lnLeft + IIF(.Name = "Screen", 8, 0)
						lnTop    = lnTop  + IIF(.Name = "Screen", 8, 0)		
						lnWidth  = lnWidth  - 16
						lnHeight = lnHeight - 16
				ENDCASE  

				IF  this.lnMode = 1				
					LOCAL lcBuffer
					lcBuffer = REPLI(CHR(0), 16)

					= SystemParametersInfo(48, 0, @lcBuffer, 0)
					.Left   = lnLeft + this.buf2dword(SubStr(lcBuffer, 1,4)) 
					.Top    = lnTop + this.buf2dword(SubStr(lcBuffer, 5,4)) 
					.Width  = lnWidth + IIF(llMultiScreen,.Width - 16, this.buf2dword(SubStr(lcBuffer, 9,4)))
					IF !llMultiScreen
						.Height = lnHeight + this.buf2dword(SubStr(lcBuffer, 13,4)) + ;
										IIF(this.FullScreen,Sysmetric(2) - (Sysmetric(22) + Sysmetric(9)),0) 
					ENDIF
				ELSE	&& thwl
					.Left   = lnLeft
					.Top    = lnTop 
					.Width  = lnWidth + IIF(llMultiScreen,.Width - 16, Sysmetric(1))
					IF !llMultiScreen
						.Height = lnHeight + Sysmetric(2) - IIF(!this.FullScreen,Sysmetric(2) - (Sysmetric(22) + Sysmetric(9)),0)										
					ENDIF	
				ENDIF 	
				IF llMultiScreen
					.Height = lnHeight + .Height - 16 - IIF(!this.FullScreen,Sysmetric(2) - (Sysmetric(22) + Sysmetric(9)),0)	
				ENDIF
								
			ELSE
				.WindowState = 2
			ENDIF
		ENDWITH 	
	ENDPROC	

*- Restaurar -------------------------------------------------------------------------------------------------------		
	PROCEDURE RestoreWindow
	*MESSAGEBOX("Restore")		
		WITH thisform								 
			*- Tomamos las medidas que hemos guardado previamente en propiedades
			IF TYPE(".WindowState")<>"U"	
				*this.WindowState = 0 && m.vNewVal && A veces lo utilizamos al principio
				.BorderStyle = this.OldBorderStyle
				.Left   = this.OldLeft
				.Top    = this.OldTop
				.Width  = this.OldWidth
				.Height = this.OldHeight
				
			ENDIF
		ENDWITH 
	ENDPROC 

*- SetParamForm -------------------------------------------------------------------------------------------------------	
	PROCEDURE SetParamForm
	*- Almacena par�metros de ventana antes de maximizar
			WITH thisform
				this.WindowState = 0
				this.OldBorderStyle = .BorderStyle
				this.OldLeft   = .Left
				this.OldTop    = .Top
				this.OldHeight = .Height
				this.OldWidth  = .Width	
			ENDWITH

	ENDPROC 

*- Buf2dWord-----------------------------------------------------------------------------------------------------------
	PROCEDURE Buf2dWord
		PARAMETERS tcBuffer
		RETURN Asc(SubStr(tcBuffer, 1,1)) + ;
    		BitLShift(Asc(SubStr(tcBuffer, 2,1)),  8) +;
	    	BitLShift(Asc(SubStr(tcBuffer, 3,1)), 16) +;
	    	BitLShift(Asc(SubStr(tcBuffer, 4,1)), 24)
	ENDPROC 
*----------------------------------------------------------------------------------------------------------------------
 ENDDEFINE