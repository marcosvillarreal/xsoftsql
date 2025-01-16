*================================================================================================================================================
* JSON16.PRG
* Muestra como usar la clase W_JSON
* Similar a JSON15.PRG pero ahora los nombres de los arrays se obtienen de una función.
* NOTA: Por defecto, los nombres de los arrays son los números de los registros, es decir: "1", "2", "3", "4", etc. Pero si se desea que esos
*       arrays tengan nombres más descriptivos entonces se puede llamar a una función que se encargará de asignarles los nombres.
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
  
  CREATE CURSOR VENTASCAB ( ;
    IDENTIFICADOR    N (10)   , ;
    FECHAVENTA       D        , ;
    FACTURANRO       C (15)   , ;
    NOMBREDELCLIENTE C (30)   , ;
    TOTALVENTA       N (12, 4)  ;
  )
  
  INSERT INTO VENTASCAB VALUES( 1, DATE(2024, 6, 1), "001-001-1234567", "Elizabeth Martínez"     , 4300.00)
  INSERT INTO VENTASCAB VALUES( 2, DATE(2024, 6, 1), "001-001-1234568", "Mónica Valenzuela"      , 8110.25)
  INSERT INTO VENTASCAB VALUES( 5, DATE(2024, 6, 2), "001-001-1234569", "Teresa Sepúlveda"       , 2567.20)
  INSERT INTO VENTASCAB VALUES(17, DATE(2024, 6, 3), "001-001-1234570", "Graciela Beatriz García", 3415.00)
  
  SUM TOTALVENTA TO lnTotalVentas
  COUNT TO lnCantidadVentas
  
  loJSON = CREATEOBJECT("W_JSON")
  
  WITH loJSON
    .SET_CABECERA("camelCase", "fechaVenta, facturaNro, nombreDelCliente, totalVenta")     && Para poner en "camelCase" los nombres de estos campos
    .SET_CABECERA("nombresArrays", "NOMBRES_PAISES")     && Llama a la función NOMBRES_PAISES() para obtener los nombres de los arrays
    .SET_AGREGAR_PROPIEDAD("", "L", "Sucursal"         , "Asunción - Paraguay")
    .SET_AGREGAR_PROPIEDAD("", "L", "nombreDelVendedor", "Marco Antonio Cáceres")
    .SET_AGREGAR_PROPIEDAD("", "O", "ventasDelMes")
    =.DO_CREAR_JSON("NO_CERRAR")     && No cierra el texto JSON, para que se le puedan agregar más líneas
    llGeneracionOK = .DO_CURSOR_A_JSON("VENTASCAB", "E")     && Los registros de este cursor serán los elementos de un array
    .SET_AGREGAR_PROPIEDAD("", "L", "totalVentasDelMes", lnTotalVentas)
    .SET_AGREGAR_PROPIEDAD("", "L", "promedioPorVenta" , lnTotalVentas / lnCantidadVentas)
    lcTextoJSON    =.DO_CREAR_JSON()     && Siempre se debe escribir para que se cierren las estructuras
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
  
  CLOSE ALL
  CLEAR ALL
  
RETURN
*
*
FUNCTION NOMBRES_PAISES
LOCAL lcNombrePais
  
  DO CASE
    CASE RECNO() = 1
      lcNombrePais = "Argentina"
    CASE RECNO() = 2
      lcNombrePais = "Paraguay"
    CASE RECNO() = 3
      lcNombrePais = "Rusia"
    CASE RECNO() = 4
      lcNombrePais = "Italia"
    OTHERWISE
      lcNombrePais = "Colombia"
  ENDCASE
  
  RETURN (lcNombrePais)
  
ENDFUNC
*
*
