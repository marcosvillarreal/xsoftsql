*================================================================================================================================================
* JSON04.PRG
* Muestra como usar la clase W_JSON
* Se crea un objeto que contiene otro objeto (cliente), y este objeto (cliente) a su vez contiene a otro objeto (direccion). 
* Luego se agregan elementos a un array (productosVendidos). Los elementos de este array son objetos.
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
    .SET_AGREGAR_PROPIEDAD("", "L", "facturaNro"    , "001-001-1234567")
    .SET_AGREGAR_PROPIEDAD("", "L", "fecha"         , DATE())
    .SET_AGREGAR_PROPIEDAD("", "L", "totalVenta"    , 19840)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombreVendedor", .NULL.)
    .SET_AGREGAR_PROPIEDAD("", "O", "cliente")
    .SET_AGREGAR_PROPIEDAD("", "L", "codigo", "CVME01")
    .SET_AGREGAR_PROPIEDAD("", "L", "nombre", "Claudia Verónica Martínez Estigarribia")
    .SET_AGREGAR_PROPIEDAD("", "O", "direccion")
    .SET_AGREGAR_PROPIEDAD("", "L", "calle" , "Avenida Colón")
    .SET_AGREGAR_PROPIEDAD("", "L", "numero", "2730", "CERRAR")     && El argumento "CERRAR" indica que allí termina el objeto
    .SET_AGREGAR_PROPIEDAD("", "L", "ciudad", "Asunción")
    .SET_AGREGAR_PROPIEDAD("", "L", "pais"  , "Paraguay")
    .SET_AGREGAR_PROPIEDAD("", "L", "email", "clauvero@hotmail.com", "CERRAR")     && El argumento "CERRAR" indica que allí termina el objeto
    .SET_AGREGAR_PROPIEDAD("", "L", "cobrada"           , .T.)
    .SET_AGREGAR_PROPIEDAD("", "L", "entregaEnDomicilio", .F.)
    .SET_AGREGAR_PROPIEDAD("", "A", "productosVendidos")
    .SET_AGREGAR_PROPIEDAD("", "O", "")
    .SET_AGREGAR_PROPIEDAD("", "L", "codigoProducto" , "NB001")
    .SET_AGREGAR_PROPIEDAD("", "L", "nombreProducto" , "Notebook HP modelo 123")
    .SET_AGREGAR_PROPIEDAD("", "L", "cantidadVendida", 14)
    .SET_AGREGAR_PROPIEDAD("", "L", "precioUnidad"   , 1200)
    .SET_AGREGAR_PROPIEDAD("", "L", "totalLinea"     , 14 * 1200, "CERRAR")     && El argumento "CERRAR" indica que allí termina el objeto
    .SET_AGREGAR_PROPIEDAD("", "L", "codigoProducto" , "CE003")
    .SET_AGREGAR_PROPIEDAD("", "L", "nombreProducto" , "Computadora de escritorio ACER 456")
    .SET_AGREGAR_PROPIEDAD("", "L", "cantidadVendida", 2)
    .SET_AGREGAR_PROPIEDAD("", "L", "precioUnidad"   , 1520)
    .SET_AGREGAR_PROPIEDAD("", "L", "totalLinea"     ,  2 * 1520)     && No hace falta el argumento "CERRAR" porque es el último par propiedad/valor
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
