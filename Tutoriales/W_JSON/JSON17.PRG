*================================================================================================================================================
* JSON17.PRG
* Muestra como usar la clase W_JSON
* Similar a JSON15.PRG y a JSON16.PRG pero ahora se usan 2 cursores
* NOTA: Se puede crear un string JSON a partir del contenido de varias tablas .DBF o de varios cursores
* Walter R. Ojeda Valiente
* 08/JUN/2024
*================================================================================================================================================
  
  CLOSE ALL
  CLEAR ALL
  
  SET CENTURY      ON
  SET DATE         DMY
  SET HOURS     TO  24
  SET MEMOWIDTH TO 250
  SET TALK         OFF
  
  SET PROCEDURE TO W_JSON
  
  CLEAR
  
  CREATE CURSOR CLIENTES ( ;
    IDENTIFICADOR    N (10), ;
    CODIGO           C ( 6), ;
    NOMBREDELCLIENTE C (30), ;
    SALDOINICIAL     N (10)  ;
  )
  
  INSERT INTO CLIENTES VALUES(27, "ME0009", "Elizabeth Martínez"     , 1200.00)
  INSERT INTO CLIENTES VALUES(32, "VM0002", "Mónica Valenzuela"      ,  850.75)
*!*	  INSERT INTO CLIENTES VALUES(65, "ST0014", "Teresa Sepúlveda"       , 2400.25)
*!*	  INSERT INTO CLIENTES VALUES(97, "GG0001", "Graciela Beatriz García", 3500.40)
*!*	  INSERT INTO CLIENTES VALUES(97, "GG0001", "Raquel Fernández"       , 1800.70)
*!*	  INSERT INTO CLIENTES VALUES(97, "GG0001", "Nancy Argüello"         ,  500.40)
  
  CREATE CURSOR VENTASCAB ( ;
    IDENTIFICADOR    N (10)   , ;
    FECHAVENTA       D        , ;
    FACTURANRO       C (15)   , ;
    NOMBREDELCLIENTE C (30)   , ;
    TOTALVENTA       N (12, 4)  ;
  )
  
  INSERT INTO VENTASCAB VALUES( 1, DATE(2024, 6, 1), "001-001-1234567", "Elizabeth Martínez"     , 4300.00)
  INSERT INTO VENTASCAB VALUES( 2, DATE(2024, 6, 1), "001-001-1234568", "Mónica Valenzuela"      , 8110.25)
*!*	  INSERT INTO VENTASCAB VALUES( 5, DATE(2024, 6, 2), "001-001-1234569", "Teresa Sepúlveda"       , 2567.20)
*!*	  INSERT INTO VENTASCAB VALUES(17, DATE(2024, 6, 3), "001-001-1234570", "Graciela Beatriz García", 3415.00)
  
  SUM TOTALVENTA TO lnTotalVentas
  COUNT TO lnCantidadVentas
  
  loJSON = CREATEOBJECT("W_JSON")
  
  WITH loJSON
    .SET_CABECERA("camelCase", "saldoInicial, fechaVenta, facturaNro, nombreDelCliente, totalVenta")     && Para poner en "camelCase" los nombres de estos campos
    .SET_AGREGAR_PROPIEDAD("", "L", "Sucursal"         , "Asunción - Paraguay")
    .SET_AGREGAR_PROPIEDAD("", "L", "nombreDelVendedor", "Marco Antonio Cáceres")
    .SET_AGREGAR_PROPIEDAD("", "A", "clientesActivos")
    .DO_CREAR_JSON("NO_CERRAR")     && No cierra el texto JSON, para que se le puedan agregar más líneas
    llGeneracionOK = .DO_CURSOR_A_JSON("CLIENTES", "O")     && Los registros de este cursor serán elementos del array "clientesActivos"
    .SET_AGREGAR_PROPIEDAD("", "A", "ventasDelMes")
    .DO_CREAR_JSON("NO_CERRAR")     && No cierra el texto JSON, para que se le puedan agregar más líneas
    llGeneracionOK = .DO_CURSOR_A_JSON("VENTASCAB", "O")     && Los registros de este cursor serán elementos del array "ventasDelMes"
    .SET_AGREGAR_PROPIEDAD("", "L", "totalVentasDelMes", lnTotalVentas)
    .SET_AGREGAR_PROPIEDAD("", "L", "promedioPorVenta" , lnTotalVentas / lnCantidadVentas)
    lcTextoJSON    = .DO_CREAR_JSON()     && Siempre se debe escribir para que se cierren las estructuras
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

