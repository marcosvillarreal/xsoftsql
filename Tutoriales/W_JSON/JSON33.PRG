*================================================================================================================================================
* JSON33.PRG
* Muestra como usar la clase W_JSON
* Se cierran varios objetos en una sola línea
* Walter R. Ojeda Valiente
* 15/JUN/2024
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
    .SET_AGREGAR_PROPIEDAD("", "O", "1")
    .SET_AGREGAR_PROPIEDAD("", "O", "jextrainfo")
    .SET_AGREGAR_PROPIEDAD("", "L", "sbarcode", "1010101", "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "L", "scustomname", "LEVADURA")
    .SET_AGREGAR_PROPIEDAD("", "L", "snotes")
    .SET_AGREGAR_PROPIEDAD("", "L", "nunitprice", 1234.56)
    .SET_AGREGAR_PROPIEDAD("", "L", "nquantity", 4)
    .SET_AGREGAR_PROPIEDAD("", "L", "nusertotal", 4 * 1234.56)
    .SET_AGREGAR_PROPIEDAD("", "L", "sstandarditemidentificacion", "1010101")
    .SET_AGREGAR_PROPIEDAD("", "O", "jtax")
    .SET_AGREGAR_PROPIEDAD("", "O", "jiva")
    .SET_AGREGAR_PROPIEDAD("", "L", "nrate", 19)
    .SET_AGREGAR_PROPIEDAD("", "L", "sname", "IVA")
    .SET_AGREGAR_PROPIEDAD("", "L", "namount", 4 * 1234.56 * 19 / 100)
    .SET_AGREGAR_PROPIEDAD("", "L", "nbaseamout", 4 * 1234.56, "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "O", "aallowancecharge", "", "CERRAR,CERRAR,CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "O", "2")
    .SET_AGREGAR_PROPIEDAD("", "O", "jextrainfo")
    .SET_AGREGAR_PROPIEDAD("", "L", "sbarcode", "2020202", "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "L", "scustomname", "HARINA")
    .SET_AGREGAR_PROPIEDAD("", "L", "snotes")
    .SET_AGREGAR_PROPIEDAD("", "L", "nunitprice", 222.33)
    .SET_AGREGAR_PROPIEDAD("", "L", "nquantity", 6)
    .SET_AGREGAR_PROPIEDAD("", "L", "nusertotal", 6 * 222.33)
    .SET_AGREGAR_PROPIEDAD("", "L", "sstandarditemidentificacion", "2020202")
    .SET_AGREGAR_PROPIEDAD("", "O", "jtax")
    .SET_AGREGAR_PROPIEDAD("", "O", "jiva")
    .SET_AGREGAR_PROPIEDAD("", "L", "nrate", 19)
    .SET_AGREGAR_PROPIEDAD("", "L", "sname", "IVA")
    .SET_AGREGAR_PROPIEDAD("", "L", "namount", 6 * 222.33 * 19 / 100)
    .SET_AGREGAR_PROPIEDAD("", "L", "nbaseamout", 6 * 222.33, "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "O", "aallowancecharge", "", "CERRAR,CERRAR,CERRAR")
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