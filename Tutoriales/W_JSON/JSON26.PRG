*================================================================================================================================================
* JSON26.PRG
* Muestra como usar la clase W_JSON
* Extrae los literales de un archivo de texto que tiene formato JSON y los inserta en un cursor.
* NOTA: Si los elementos de un array son objetos, cada uno de esos elementos puede ser el registro de un cursor.
*       Como un string JSON es texto plano no se puede saber de antemano si todos los objetos de un "array de objetos" tienen la misma estructura
*       o no. Hay que buscar. El argumento 30 del método DO_JSON_A_CURSOR() indica que solamente en los primeros 30 objetos del "array de objetos"
*       pueden existir nombres de propiedades diferentes. O sea que los nombres de los campos que tendrá el cursor se encontrarán, sí o sí, en
*       esos 30 primeros objetos.
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
    *--- Nombre del cursor, del archivo con formato JSON, del array que contiene los registros, la cantidad de registros para obtener la estructura, y la codificación
    .DO_JSON_A_CURSOR("MI_CURSOR_5", "VROJAS2019.JSON", "ingresos", 30, 0)
    *--- "MI_CURSOR_5", es el nombre que tendrá el cursor que será creado
    *--- "VROJAS2019.JSON", es el nombre del archivo que contiene al string JSON
    *--- "ingresos", es el nombre del array dentro del string JSON que contiene a los objetos que serán convertidos en registros del cursor
    *--- 30, indica que la estructura del cursor debe buscarse en los 30 primeros pares propiedad/valor del string JSON
    *--- 0, indica que el archivo JSON no está codificado
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
