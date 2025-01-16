*================================================================================================================================================
* JSON22.PRG
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
    .SET_CABECERA("CantidadDecimales", 0)                && La cantidad de decimales que tendrán los campos numéricos
    .SET_CABECERA("FormatoFechas"    , "9999-99-99")     && El formato que tienen las fechas en el string JSON
    *--- Nombre del cursor, del archivo con formato JSON, del array que contiene los registros, la cantidad de registros para obtener la estructura, y la codificación
    .DO_JSON_A_CURSOR("MI_CURSOR_1", "ARANDUKA.JSON", "ingresos", 10, 1)
    *--- "MI_CURSOR_1", es el nombre del cursor que será creado
    *--- "ARANDUKA.JSON", es el nombre del archivo que contiene un "array de objetos"
    *--- "ingresos", es el nombre del "array de objetos", esos objetos serán convertidos a registros de un cursor
    *--- 10, es la cantidad máxima de objetos dentro del "array de objetos" donde se buscará la estructura del cursor
    *--- 1, es la codificación. Es muy común que los archivos .JSON estén codificados y hay que decodificarlos para que sean legibles
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
