*================================================================================================================================================
* JSON08.PRG
* Muestra como usar la clase W_JSON
* Se crea un array que contiene 3 objetos
* NOTA: Para pasar el contenido de un string JSON a un cursor, lo más usual es hacerlo mediante un array de objetos
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
    .SET_CABECERA("delimitadorInicial", "[")     && El delimitador inicial indica que se trata de un array (lo normal es que se trate de un objeto)
    .SET_AGREGAR_PROPIEDAD("", "O", "")
    .SET_AGREGAR_PROPIEDAD("", "L", "id"       , 1)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres"  , "Claudia Verónica")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos", "Martínez Estigarribia")
    .SET_AGREGAR_PROPIEDAD("", "L", "género"   , "femenino", "CERRAR")     && El argumento "CERRAR" indica que allí termina el objeto
    .SET_AGREGAR_PROPIEDAD("", "L", "id"       , 2)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres"  , "Sonia Elizabeth")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos", "Fernández Salcedo")
    .SET_AGREGAR_PROPIEDAD("", "L", "género"   , "femenino", "CERRAR")     && El argumento "CERRAR" indica que allí termina el objeto
    .SET_AGREGAR_PROPIEDAD("", "L", "id"       , 3)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres"  , "Graciela Beatriz")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos", "García Chávez")
    .SET_AGREGAR_PROPIEDAD("", "L", "género"   , "femenino")     && Si es el último elemento, no es necesario el argumento "CERRAR"
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
