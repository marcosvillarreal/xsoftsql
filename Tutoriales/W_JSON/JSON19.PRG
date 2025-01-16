*================================================================================================================================================
* JSON19.PRG
* Muestra como usar la clase W_JSON
* Extrae los literales de un texto que tiene formato JSON
* NOTA: Cuando se tiene un string JSON es muy común necesitar extraer los literales (o sea: pares propiedad/valor) de su contenido.
*       La clase W_JSON también permite que los nombres de esas propiedades se conviertan en nombres de variables, para su uso posterior.
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
  
  *--- El string JSON del cual se extraerá su contenido
  
  TEXT TO lcTextoPrueba NOSHOW
    {
      "facturaNro": "001-001-1234567", 
      "fecha": "2024-06-12", 
      "totalVenta": 54321, 
      "nombreVendedor": null, 
      "cliente": {
        "codigo": "CVME01", 
        "nombre": "Claudia Verónica Martínez Estigarribia", 
        "direccion": {
          "calle": "Avenida Colón", 
          "numero": "2730", 
          "ciudad": "Asunción", 
          "país": "Paraguay"
        }, 
        "email": "clauvero@hotmail.com"
      }, 
      "cobrada": true, 
      "entregaEnDomicilio": false
    }
  ENDTEXT
  
  *--- Las variables que se desean obtener del string JSON
  PRIVATE facturaNro, fecha, totalVenta, nombreVendedor, nombre, ciudad
  
  M.facturaNro     = ""
  M.fecha          = {}
  M.totalVenta     = 0
  M.nombreVendedor = ""
  M.nombre         = ""
  M.ciudad         = ""
  
  loJSON = CREATEOBJECT("W_JSON")
  
  WITH loJSON
    lcTextoExtraido = .DO_EXTRAER_LITERALES("L", lcTextoPrueba, .T.)
    lcMensajeError  = .GET_CABECERA("MensajeError")
    IF EMPTY(lcMensajeError) THEN     && Si está todo OK, entonces...
      ? lcTextoExtraido FONT "FixedSys", 12     && Se imprime el texto extraído de un JSON y
      ?
      ? "*********************************************************************************"
      ?
      ? M.facturaNro     FONT "Courier New", 10
      ? M.fecha          FONT "Courier New", 10
      ? M.totalVenta     FONT "Courier New", 10
      ? M.nombreVendedor FONT "Courier New", 10
      ? M.nombre         FONT "Courier New", 10
      ? M.ciudad         FONT "Courier New", 10
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
