*================================================================================================================================================
* JSON07.PRG
* Muestra como usar la clase W_JSON
* Se genera un array y un literal
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
    .SET_AGREGAR_PROPIEDAD("", "A", "colores")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "amarillo")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "azul")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "blanco")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "rojo", "CERRAR")     && El argumento "CERRAR" indica que allí termina el array
    .SET_AGREGAR_PROPIEDAD("", "L", "precio", 123)
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
