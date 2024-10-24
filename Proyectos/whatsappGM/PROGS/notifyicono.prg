CLEAR ALL 

#DEFINE NIM_ADD 0

#DEFINE NIM_MODIFY 1

#DEFINE NIM_DELETE 2

*!* Mensajes NOTIFYICON

#DEFINE NIF_MESSAGE 1

#DEFINE NIF_ICON 2

#DEFINE NIF_TIP 4

*!* Boton izquierdo NOTIFYICON

#DEFINE WM_LBUTTONDBLCLK 515 && Double-click

#DEFINE WM_LBUTTONDOWN 513 && Button down

#DEFINE WM_LBUTTONUP 514 && Button up

*!* Boton derecho NOTIFYICON

#DEFINE WM_RBUTTONDBLCLK 518 && Double-click

#DEFINE WM_RBUTTONDOWN 516 && Button down

#DEFINE WM_RBUTTONUP 517 && Button up

*!* Ventanas NOTIFYICON

#DEFINE WM_MOVE 3

*!* Ventanas de sistema

#DEFINE GW_HWNDFIRST 0

#DEFINE GW_HWNDNEXT 2

#DEFINE GWL_HINSTANCE -6

#DEFINE SC_MAXIMIZE 61488

#DEFINE WM_CLOSE 16

#DEFINE WM_DESTROY 2

#DEFINE WM_SYSCOMMAND 274

#DEFINE WM_MOUSEMOVE 512

****************************************************
FUNCTION NotifyIconc
PARAMETERS cForm,cPathIcon

PUBLIC oNotifyIcono, gcNId

oNotifyIcono=CREATEOBJECT('NotifyIconc')
oNotifyIcono.forminit = cForm

cIconName = cPathIcon

IF FILE(cIconName)
	gcNId = AddNotifyIcon(_SCREEN.HWnd, cIconName, 'Pulsame')
ENDIF 

BINDEVENT(_SCREEN, 'MouseDown', oNotifyIcono, 'MouseDown')

****************************************************

DEFINE CLASS NotifyIconc AS custom

	Name = "notifyiconc"
	FormInit = ""
	
	PROCEDURE Destroy

		DelNotifyIcon(gcNId)

		UNBINDEVENTS(This)

	ENDPROC

	PROCEDURE MouseDown

	*!* Recoger los CallBackMessages de la tray icon

	*!* Sintaxis: MouseDown()

	*!* Nota: Este evento se llama por BINDEVENT

	*!* BINDEVENT(_SCREEN, 'MouseDown', oApp, 'MouseDown')

	*!*

	*!* Nota: Mensajes enviados por la TrayIcon

	*!*

	*!* Click: 1 0 513 0

	*!* 1 0 514 0 (514 -> WM_LBUTTONUP)

	*!*

	*!* DoubleClick: 1 0 513 0

	*!* 1 0 514 0

	*!* 1 0 515 0 (515 -> WM_LBUTTONDBLCLK)

	*!* 1 0 514 0

	*!*

	*!* MiddleClick: 1 0 519 0

	*!* 1 0 520 0 (520 -> WM_MBUTTONUP)

	*!*

	*!* MiddleDoubleClick: 1 0 519 0

	*!* 1 0 520 0

	*!* 1 0 521 0 (515 -> WM_MBUTTONDBLCLK)

	*!* 1 0 520 0

	*!*

	*!* RightClick: 1 0 516 0

	*!* 1 0 517 0 (514 -> WM_RBUTTONUP)

	*!*

	*!* RightDoubleClick: 1 0 516 0

	*!* 1 0 517 0

	*!* 1 0 518 0 (515 -> WM_RBUTTONDBLCLK)

	*!* 1 0 517 0

		LPARAMETERS tnButton , tnShift , tnXCoord ,	tnYCoord 

		IF tnXCoord = 514 AND tnYCoord = 0

			MESSAGEBOX('Hey Ya...')

		ENDIF
		IF tnXCoord = 517 AND tnYCoord = 0

			*MESSAGEBOX('Configuraci�n...')
			*MenuContext()
			
			DO FORM frmmenu &&  &(oApp.FormInit)
			
		ENDIF
	ENDPROC

ENDDEFINE

****************************************************

*!* Agrega un icono a la barra de tareas de windows

*!* Sintaxis: AddNotifyIcon(tnhWnd, tcIconFile, tcIconText, tnIconNum)

*!* Retorno: lcRetVal

*!* Argumentos: tnhWnd controlador de ventana de un control Foxpro HWND

*!* tcIconFile especifica una libreria de iconos .ico, .dll o .exe con
*!*	imagenes para representar el icono

*!* lcIconText, opcional, especifica el texto mostrado por el icono en la
*!*	*!*	barra de tareas al pasar sobre �l

*!* tnIconNum, opcional, especifica el numero de imagen en libreria de
*!*	iconos que representar� al icono

*!* lcRetVal valor de retorno con una estructura NotifyIconData.

*!* Nota: Devolvera una cadena vacia si no se ha podido crear el icono. Para
*!*	verificar si el valor de retorno es

*!* valido, es preferible usar LEN(...) <> 0 que EMPTY(...) ya que el
*!*	retorno puede contener caracteres no visibles

*!* Nota: El valor devuelto debe conservarse hasta que
*!*	 se destruya el icono
*!*	con la funcion DelNotifyIcon()

FUNCTION AddNotifyIcon

	LPARAMETERS tnhWnd, tcIconFile, tcIconText, tnIconNum

	LOCAL lcNId, lcNId2, lnhWnd, lnhInst, lcRetVal, lnhIcon, lcIconFile, lcIconText, lnIconNum

	*!* Valores

	lcNId = ''

	lcNId2 = ''

	lnhIcon = 0

	lcRetVal = ''

	lnhWnd = IIF(EMPTY(tnhWnd), 0, tnhWnd)

	lnIconNum = IIF(EMPTY(tnIconNum), 0, tnIconNum)

	lcIconText = IIF(EMPTY(tcIconText), '', ALLTRIM(tcIconText))

	lcIconFile = IIF(EMPTY(tcIconFile), '', ALLTRIM(tcIconFile))

	*!* Verificar que se hayan enviado valores v�lidos

	IF FILE(lcIconFile)

		*!* Instrucciones DECLARE DLL para extraer, crear, modificar y destruir
		*!*	iconos en la barra de tareas

		DECLARE INTEGER DestroyIcon IN Win32API ;
		INTEGER hIcon

		DECLARE INTEGER GetWindowLong IN Win32API ;
		INTEGER hWnd, INTEGER nIndex

		DECLARE INTEGER Shell_NotifyIcon IN Shell32.dll ;
		INTEGER dwMessage, STRING @pnid

		DECLARE INTEGER ExtractIcon IN Shell32.dll ;
		INTEGER hInst, STRING	@lpszExeFileName, INTEGER nIconIndex

		*!* Valores

		lcIconFile = lcIconFile + CHR(0)

		*!* Obtener la instancia de la aplicacion

		lnhInst = GetWindowLong(lnhWnd, GWL_HINSTANCE)

		*!* Extraer el icono de la libreria de iconos .ico, .dll o .exe

		lnhIcon = ExtractIcon(lnhInst, @lcIconFile, lnIconNum)

		*!* Verificar que se haya cargado en memoria la estructura del icono

		IF lnhIcon > 1

			*!* *!* Valores

			lcNId = ''

			lcNId = lcNId + LongToStr(88)

			lcNId = lcNId + LongToStr(lnhWnd)

			lcNId = lcNId + LongToStr(1)

			lcNId = lcNId + LongToStr(NIF_ICON + NIF_TIP + NIF_MESSAGE) 
			*!*	Aunque el
			*!*	objeto _SCREEN y los forms de VFP no sean capaces de recibir CallBacks de la
			*!*	barra de tareas

			lcNId = lcNId + LongToStr(WM_LBUTTONDOWN) 
			*!*	procesamos igualmente los
			*!*	mensajes WM_LBUTTONDOWN enviados por el icono desde la barra de tareas

			lcNId = lcNId + LongToStr(lnhIcon)

			lcNId = lcNId + PADR(lcIconText, 64, CHR(0))

			*!* Preservar el valor de lcNId ya quue

			*!* Shell_NotifyIcon()podria alterar su valor

			lcNId2 = lcNId

			*!* Agregar el icono a la barra de tareas

			IF Shell_NotifyIcon(NIM_ADD, @lcNId) = 0

				*!* Si no se ha agregado el icono

				*!* descargar de memoria su estructura

				DestroyIcon(lnhIcon)

			ELSE

				*!* Valor de retorno

				lcRetVal = lcNId2

			ENDIF

		ENDIF

	ENDIF

	*!* Retorno

	RETURN lcRetVal

ENDFUNC

*!* Elimina un icono de la barra de tareas de windows

*!* Sintaxis: DelNotifyIcon(tcNId)

*!* Retorno: llRetVal

*!* Argumentos: tcNId especifica el valor de una estructura NotifyIconData
*!*	obtenida como retorno de funciones las AddNotifyIcon() - ModifyNotifyIcon()

*!*

*!* Nota: Finalizada con exito la funcion DelNotifyIcon() no ser� necesario
*!*	conservar el valor de la estructura NotifyIconData

FUNCTION DelNotifyIcon

	LPARAMETERS tcNId

	LOCAL lcNId, llRetVal, lnhIcon

	*!* Valores

	lcNId = tcNId

	*!* Verificar que se hayan enviado valores v�lidos

	IF VARTYPE(lcNId) == 'C'

		*!* Valores

		lnhIcon = StrToLong(SUBSTR(lcNId, 21, 4))

		*!* Instrucciones DECLARE DLL para extraer, crear, modificar y destruir
*!*			iconos en la barra de tareas

		DECLARE INTEGER DestroyIcon IN Win32API INTEGER hIcon

		DECLARE INTEGER Shell_NotifyIcon IN Shell32.dll;
		INTEGER dwMessage, 	STRING	@pnid

		*!* Eliminar el icono de la barra de tareas

		IF Shell_NotifyIcon(NIM_DELETE, @lcNId) <> 0

			*!* Si se ha eliminado el icono de la barra de

			*!* tareas descargar su estructura de la memoria

			llRetVal = (DestroyIcon(lnhIcon) <> 0)

		ENDIF

	ENDIF

	*!* Retorno

	RETURN llRetVal

ENDFUNC

*!* Convierte un long integer a un 4-byte character string

*!* Sintaxis: LongToStr(tnLongVal)

*!* Retorno: lcRetStr

*!* Argumentos: tnLongVal

*!* lnLongVal especifica el long integer a convertir

FUNCTION LongToStr

	LPARAMETERS tnLongVal

	LOCAL lnCnt, lcRetStr, lnLongVal

	*!* Valores

	lcRetStr = ''

	lnLongVal = IIF(EMPTY(tnLongVal), 0, tnLongVal)

	*!* Convertir

	FOR lnCnt = 24 TO 0 STEP -8

		lcRetStr = CHR(INT(lnLongVal/(2^lnCnt))) + lcRetStr

		lnLongVal = MOD(lnLongVal, (2^lnCnt))

	NEXT

	*!* Retorno

	RETURN lcRetStr

ENDFUNC

*!* Convierte un 4-byte character string a un long integer

*!* Sintaxis: StrToLong(tcLongStr)

*!* Retorno: lnRetval

*!* Argumentos: tcLongStr

*!* tcLongStr especifica el 4-byte character string a convertir

FUNCTION StrToLong

	LPARAMETERS tcLongStr

	LOCAL lnCnt, lnRetVal, lcLongStr

	*!* Valores

	lnRetVal = 0

	lcLongStr = IIF(EMPTY(tcLongStr), '', tcLongStr)

	*!* Convertir

	FOR lnCnt = 0 TO 24 STEP 8

		lnRetVal = lnRetVal + (ASC(lcLongStr) * (2^lnCnt))

		lcLongStr = RIGHT(lcLongStr, LEN(lcLongStr) - 1)

	NEXT

	*!* Retorno

	RETURN lnRetVal

ENDFUNC

