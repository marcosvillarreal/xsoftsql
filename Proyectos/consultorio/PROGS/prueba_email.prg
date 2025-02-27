*================================================================================================================================================
* jsonEmail.PRG
* Muestra como usar la clase W_JSON
* Se crea un objeto muy simple. Solamente consta de pares propiedad/valor
* Walter R. Ojeda Valiente
* 08/JUN/2024
*================================================================================================================================================
  
  CLOSE ALL
  CLEAR ALL
  
  SET CENTURY      ON
  SET DATE         DMY
  SET HOURS     TO 24
  SET MEMOWIDTH TO 240
  SET TALK         OFF

  
  CLEAR
  
loJSON = CREATEOBJECT("W_JSON")
 
WITH loJSON
  .SET_CABECERA("CamelCase", "smtpserver, smtppuerto, sendusing, emailuser, emailpass, email, emailauthen , smtpssl, emailcopy")     && Para poner en "camelCase" los nombres de estos campos
  .SET_AGREGAR_PROPIEDAD("", "A", "emails")
  lcTextoJSON    = .DO_CREAR_JSON("NO_CERRAR")     && No cierra el texto JSON, para que se le puedan agregar más líneas
  llGeneracionOK = .DO_CURSOR_A_JSON("CSRAUXEMAIL", "O")     && Cada registro de este cursor será un elemento de tipo objeto del array "ventasDelMes"
  lcTextoJSON    = .DO_CREAR_JSON()
  lcMensajeError = .GET_CABECERA("MensajeError")
  IF EMPTY(lcMensajeError) THEN     && Si está todo OK, entonces...
    ? lcTextoJSON FONT "FixedSys", 12     && Se imprime el texto JSON creado y
    _CLIPTEXT = lcTextoJSON     && se coloca el texto JSON en el portapapeles (lo puedes pegar y validar en: https://jsonlint.com/)
  ELSE
    =MESSAGEBOX(lcMensajeError)
  ENDIF
ENDWITH
  
  loJSON = .NULL.
  RELEASE loJSON
  
RETURN