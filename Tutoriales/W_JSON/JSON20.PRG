*================================================================================================================================================
* JSON20.PRG
* Muestra como usar la clase W_JSON
* Extrae los literales de un texto que tiene formato JSON, pero parcialmente
* NOTA: A veces no se necesitan extraer todos los literales (o sea: pares propiedad/valor) de un string JSON, solamente se necesita extraer
*       algunos literales. Eso es muy común porque los strings JSON pueden ser muy grandes y frecuentemente solamente algunos de esos literales
*       son de interés para nosotros.
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
          "pais": "Paraguay"
        }, 
        "email": "clauvero@hotmail.com"
      }, 
      "cobrada": true, 
      "entregaEnDomicilio": false
    }
  ENDTEXT
  
  *--- Las variables que se desean obtener del string JSON
  PRIVATE calle, numero, ciudad, pais
  
  M.calle  = ""
  M.numero = ""
  M.ciudad = ""
  M.pais   = ""
  
  loJSON = CREATEOBJECT("W_JSON")
  
  WITH loJSON
    lcTextoExtraido = .DO_EXTRAER_LITERALES("L", lcTextoPrueba, .T., '"direccion": {', '}')
    lcMensajeError  = .GET_CABECERA("MensajeError")
    IF EMPTY(lcMensajeError) THEN     && Si está todo OK, entonces...
      ? lcTextoExtraido FONT "FixedSys", 12     && Se imprime el texto extraído de un JSON y
      ?
      ? "*********************************************************************************"
      ?
      ? M.calle  FONT "Courier New", 10
      ? M.numero FONT "Courier New", 10
      ? M.ciudad FONT "Courier New", 10
      ? M.pais   FONT "Courier New", 10
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
