*================================================================================================================================================
* JSON31.PRG
* Muestra como usar la clase W_JSON
* Extrae los literales de un archivo de texto que tiene formato JSON y los inserta en un cursor.
* NOTA: Si los elementos de un array son objetos, cada uno de esos elementos puede ser el registro de un cursor.
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
    *--- Nombre del cursor, archivo con formato JSON, array que contiene los registros, cantidad de registros para obtener la estructura
    .DO_JSON_A_CURSOR("MI_CURSOR_10", "CLIENTS.JSON", "clients", 10)
    lcMensajeError = .GET_CABECERA("MensajeError")
    IF EMPTY(lcMensajeError) THEN     && Si está todo OK, entonces muestra el contenido del cursor creado
      BROWSE
    ELSE
      =MESSAGEBOX(lcMensajeError)
    ENDIF
  ENDWITH
  
  loJSON = .NULL.
  RELEASE loJSON
  
  CLOSE ALL
  CLEAR ALL
  
RETURN
*
*
