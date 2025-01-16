*================================================================================================================================================
* JSON01.PRG
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
  
  SET PROCEDURE TO W_JSON
  
  CLEAR
  
  loJSON = CREATEOBJECT("W_JSON")
  
  WITH loJSON
    .SET_CABECERA("respetarDecimales", .T.)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres"          , "Claudia Verónica")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos"        , "Martínez Estigarribia")
    .SET_AGREGAR_PROPIEDAD("", "L", "salario"          , 123456.00)
    .SET_AGREGAR_PROPIEDAD("", "L", "esJefe"           , .T.)
    .SET_AGREGAR_PROPIEDAD("", "L", "estadoCivil"      , .NULL.)
    .SET_AGREGAR_PROPIEDAD("", "L", "fechaDeNacimiento", DATE(1990, 3, 16))
    .SET_AGREGAR_PROPIEDAD("", "L", "fechaHoraActual"  , DATETIME())
    .SET_AGREGAR_PROPIEDAD("", "L", "email"            , "clauvero@hotmail.com")
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
*
*
