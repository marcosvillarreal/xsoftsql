RAND(-1) && al inicio de tu aplicaci�n

FOR ln = 1 TO 10
lnNro = (RAND() * 99999999999999) + 1
	IF lnNro <> 1
		MESSAGEBOX("Carlos tiene raz�n" + STR(lnNro,14))
		*EXIT
	ENDIF
ENDFOR
MESSAGEBOX('Termino')