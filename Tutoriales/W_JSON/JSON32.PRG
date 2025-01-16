*================================================================================================================================================
* JSON32.PRG
* Muestra como usar la clase W_JSON
* Extrae los arrays de un archivo de texto que tiene formato JSON
* NOTA: Si se tiene un "objeto de arrays", se puede extraer cada uno de esos arrays. Y los nombres de los arrays pueden convertirse en variables.
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
  
  PRIVATE aliceblue, antiquewhite
  
  aliceblue    = ""
  antiquewhite = ""
  
  loJSON = CREATEOBJECT("W_JSON")
  
  WITH loJSON
    *--- Nombre del cursor, archivo con formato JSON, array que contiene los registros, cantidad de registros para obtener la estructura
    lcTextoExtraido = .DO_EXTRAER_ARRAYS("A", "PRUEBA.JSON", .T., "", "", 0, 1)
    lcMensajeError = .GET_CABECERA("MensajeError")
    IF EMPTY(lcMensajeError) THEN     && Si está todo OK, entonces muestra el contenido del cursor creado
      ? lcTextoExtraido FONT "FixedSys", 12
      ? "------------------------------------------------"
      ? aliceblue
      ? antiquewhite
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
