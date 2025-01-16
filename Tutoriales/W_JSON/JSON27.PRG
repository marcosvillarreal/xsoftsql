*================================================================================================================================================
* JSON27.PRG
* Muestra como usar la clase W_JSON
* Extrae los literales de un archivo de texto que tiene formato JSON y los inserta en un cursor.
* NOTA: Si los elementos de un array son objetos, cada uno de esos elementos puede ser el registro de un cursor.
*       En este ejemplo se le muestra un mensaje al usuario mientras se están obteniendo los registros del cursor. Para que no se impaciente.
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
    .SET_CABECERA("CantidadDecimales", 0)                && La cantidad de decimales que tendrán los campos numéricos
    .SET_CABECERA("FormatoFechas"    , "9999-99-99")     && El formato que tienen las fechas en el string JSON
    .SET_CABECERA("WaitWindow"       , .T.)              && Para que le muestre un mensaje al usuario avisándole que la generación se demorará
    .SET_CABECERA("WaitWindowMensaje", "Espera un momento. Estoy trabajando a full para generar los registros y mostrártelos.")
    *--- Nombre del cursor, del archivo con formato JSON, del array que contiene los registros, la cantidad de registros para obtener la estructura, y la codificación
    .DO_JSON_A_CURSOR("MI_CURSOR_6", "VROJAS2019.JSON", "egresos", 0, 0)
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
