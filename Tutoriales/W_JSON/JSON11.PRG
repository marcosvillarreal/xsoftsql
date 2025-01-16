*================================================================================================================================================
* JSON11.PRG
* Muestra como usar la clase W_JSON
* Se crea un array que contiene varios literales, varios objetos, y varios arrays
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
    .SET_CABECERA("delimitadorInicial", "[")
    .SET_AGREGAR_PROPIEDAD("", "E", "", DATE(2021, 7, 18))
    .SET_AGREGAR_PROPIEDAD("", "E", "", 5555)
    .SET_AGREGAR_PROPIEDAD("", "O", "")
    .SET_AGREGAR_PROPIEDAD("", "L", "id", 1)
    .SET_AGREGAR_PROPIEDAD("", "L", "nombres", "Claudia Verónica")
    .SET_AGREGAR_PROPIEDAD("", "L", "apellidos", "Martínez Estigarribia")
    .SET_AGREGAR_PROPIEDAD("", "L", "género", "femenino", "CERRAR, FIN_OBJETO")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "Asunción")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "Paraguay")
    .SET_AGREGAR_PROPIEDAD("", "A", "", "", "ARRAY_EN_ARRAY")     && Indica que no se debe colocar el nombre del array en el string JSON
    .SET_AGREGAR_PROPIEDAD("", "E", "", DATE())
    .SET_AGREGAR_PROPIEDAD("", "E", "", DATETIME())
    .SET_AGREGAR_PROPIEDAD("", "A", "", "", "ARRAY_EN_ARRAY")     && Indica que no se debe colocar el nombre del array en el string JSON
    .SET_AGREGAR_PROPIEDAD("", "E", "", "manzanas")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "naranjas")
    .SET_AGREGAR_PROPIEDAD("", "A", "", "", "ARRAY_EN_ARRAY")     && Indica que no se debe colocar el nombre del array en el string JSON
    .SET_AGREGAR_PROPIEDAD("", "E", "", "rojo")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "blanco")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "azul")
    .SET_AGREGAR_PROPIEDAD("", "A", "", "", "ARRAY_EN_ARRAY")     && Indica que no se debe colocar el nombre del array en el string JSON
    .SET_AGREGAR_PROPIEDAD("", "E", "", "cuero")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "madera")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "metal")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "piedra")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "plástico")
    .SET_AGREGAR_PROPIEDAD("", "E", "", "tela")
    .SET_AGREGAR_PROPIEDAD("", "O")
    .SET_AGREGAR_PROPIEDAD("", "L", "producto", "Notebook HP")
    .SET_AGREGAR_PROPIEDAD("", "L", "precio", 1234, "CERRAR")
    .SET_AGREGAR_PROPIEDAD("", "L", "producto", "Impresora Epson")
    .SET_AGREGAR_PROPIEDAD("", "L", "precio", 333)
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