*================================================================================================================================================
* JSON12.PRG
* Muestra como usar la clase W_JSON
* Se crea un array que contiene varios objetos y un array de objetos.
* NOTA: Este formato era utilizado por Aranduka en Paraguay
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
    .SET_AGREGAR_PROPIEDAD("", "O", "informante")
    .SET_AGREGAR_PROPIEDAD("", "L", "ruc", "79787776", "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "O", "identificacion")
    .SET_AGREGAR_PROPIEDAD("", "L", "periodo", "2019", "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "A", "ingresos")
    .SET_AGREGAR_PROPIEDAD("", "O", "")
    .SET_AGREGAR_PROPIEDAD("", "L", "tipo", "5")
    .SET_AGREGAR_PROPIEDAD("", "L", "periodo", "2019")
    .SET_AGREGAR_PROPIEDAD("", "L", "tipoTexto", "Liquidación de Salario")
    .SET_AGREGAR_PROPIEDAD("", "L", "fecha", .NULL.)
    .SET_AGREGAR_PROPIEDAD("", "L", "ruc", "79787776")
    .SET_AGREGAR_PROPIEDAD("", "L", "tipoIngreso", "REMDEP")
    .SET_AGREGAR_PROPIEDAD("", "L", "ingresoMontoGravado", 12907381)
    .SET_AGREGAR_PROPIEDAD("", "L", "ingresoMontoNoGravado", 0)
    .SET_AGREGAR_PROPIEDAD("", "L", "ingresoMontoTotal", 12907381)
    .SET_AGREGAR_PROPIEDAD("", "L", "relacionadoTipoIdentificacion", "RUC")
    .SET_AGREGAR_PROPIEDAD("", "L", "relacionadoNumeroIdentificacion", "80024627")
    .SET_AGREGAR_PROPIEDAD("", "L", "relacionadoNombres", "MINISTERIO DE HACIENDA")
    .SET_AGREGAR_PROPIEDAD("", "L", "mes", "1", "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "L", "tipo", "1")
    .SET_AGREGAR_PROPIEDAD("", "L", "periodo", "2019")
    .SET_AGREGAR_PROPIEDAD("", "L", "tipoTexto", "Factura")
    .SET_AGREGAR_PROPIEDAD("", "L", "fecha", DATE(2019, 1, 1))
    .SET_AGREGAR_PROPIEDAD("", "L", "ruc", "79787776")
    .SET_AGREGAR_PROPIEDAD("", "L", "tipoIngreso", "DU")
    .SET_AGREGAR_PROPIEDAD("", "L", "ingresoMontoGravado", 2000000)
    .SET_AGREGAR_PROPIEDAD("", "L", "ingresoMontoNoGravado", 1000000)
    .SET_AGREGAR_PROPIEDAD("", "L", "ingresoMontoTotal", 3000000)
    .SET_AGREGAR_PROPIEDAD("", "L", "timbradoCondicion", "contado")
    .SET_AGREGAR_PROPIEDAD("", "L", "timbradoDocumento", "001-001-0000001")
    .SET_AGREGAR_PROPIEDAD("", "L", "timbradoNumero", "1111111")
    .SET_AGREGAR_PROPIEDAD("", "L", "relacionadoTipoIdentificacion", "RUC")
    .SET_AGREGAR_PROPIEDAD("", "L", "relacionadoNumeroIdentificacion", "80000958")
    .SET_AGREGAR_PROPIEDAD("", "L", "relacionadoNombres", "COOPERATIVA UNIVERSITARIA LTDA")
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