*================================================================================================================================================
* JSON06.PRG
* Muestra como usar la clase W_JSON
* Se genera un objeto que contiene 3 objetos
* NOTA: El nombre de la propiedad es "género", con tilde en la primera letra "e". El JSON lo acepta.
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
    .SET_AGREGAR_PROPIEDAD("", "O", "datosEnObjeto1")
    .SET_AGREGAR_PROPIEDAD("", "L", "id", 1)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres", "Claudia Verónica")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos", "Martínez Estigarribia")
    .SET_AGREGAR_PROPIEDAD("", "L", "género", "femenino", "CERRAR")     && El argumento "CERRAR" indica que allí termina el objeto
    .SET_AGREGAR_PROPIEDAD("", "O", "datosEnObjeto2")
    .SET_AGREGAR_PROPIEDAD("", "L", "id", 2)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres", "Mónica Liliana")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos", "García Rodas")
    .SET_AGREGAR_PROPIEDAD("", "L", "género", "femenino", "CERRAR")     && El argumento "CERRAR" indica que allí termina el objeto
    .SET_AGREGAR_PROPIEDAD("", "O", "datosEnObjeto3")
    .SET_AGREGAR_PROPIEDAD("", "L", "id", 3)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres", "Sonia Elizabeth")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos", "Fernández Salcedo")
    .SET_AGREGAR_PROPIEDAD("", "L", "género", "femenino", "CERRAR")     && Si es el último par, no es necesario el argumento "CERRAR"
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
