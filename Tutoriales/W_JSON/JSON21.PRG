*================================================================================================================================================
* JSON21.PRG
* Muestra como usar la clase W_JSON
* Extrae los literales de un archivo de texto que tiene formato JSON
* NOTA: El string JSON puede encontrarse en una variable o en un archivo (la extensión más común de ese archivo es .json pero puede ser otra)
*       En este ejemplo se extraen los literales de un archivo.
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
  
  PRIVATE ruc, periodo, tipoTexto
  
  ruc       = ""
  periodo   = ""
  tipoTexto = ""
  
  loJSON = CREATEOBJECT("W_JSON")
  
  WITH loJSON
    lcTextoExtraido = .DO_EXTRAER_LITERALES("A", "ARANDUKA.JSON", .T., "", "", 0, 1)
    *--- "A"             = el string JSON se encuentra dentro de un archivo
    *--- "ARANDUKA.JSON" = el nombre del archivo que contiene al string JSON
    *--- .T.             = se quiere convertir los nombres de algunas propiedades en variables
    *--- ""              = delimitador inicial. Como está en blanco significa que se debe empezar en el inicio del archivo
    *--- ""              = delimitador final. Como está en blanco significa que se debe continuar hasta el final del archivo
    *--- 0               = número de ocurrencia donde empezar la búsqueda. Como está en 0 se empezará con la primera ocurrencia
    *--- 1               = decodificación a usar. Muchas veces los archivos .JSON están codificados y hay que decodificarlos. 1=UTF_8, 2=UNICODE
    lcMensajeError  = .GET_CABECERA("MensajeError")
    IF EMPTY(lcMensajeError) THEN     && Si está todo OK, entonces...
      ? lcTextoExtraido FONT "FixedSys", 12     && Se imprime el texto extraído de un archivo con formato JSON y
      ?
      ? "==========================================================================="
      ?
      ? ruc
      ? periodo
      ? tipoTexto
      _CLIPTEXT = lcTextoExtraido     && se coloca el texto extraído en el portapapeles para que sea fácil copiarlo en el Bloc de Notas o en otro lugar
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
