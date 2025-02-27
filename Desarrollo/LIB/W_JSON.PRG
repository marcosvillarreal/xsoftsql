*=========================================================================
* W_JSON.PRG
* Define la clase W_JSON
* Walter R. Ojeda Valiente
* 23/JUL/2013
*==========================================================================
*
*
DEFINE CLASS W_JSON AS CUSTOM
  
  PROTECTED cCamelCase, cCierres, cDelimitadorInicial, cFormatoFechas, cFuncionExterna, cMensajeError, cSeparadorParametros, cTextoJSON, cUltimosDelimitadores
  PROTECTED cWaitWindowMensaje
  PROTECTED lCursorYaProcesado, lEnSiguienteLinea, lRespetarDecimales, lWaitWindow
  PROTECTED nCantidadDecimales, nCantidadEspacios, nCantidadPropiedades, nNumeroLineaActual, nNumeroLineaCabecera
  
  DIMENSION APROPIEDADES[1]
  
  cCamelCase            = ""
  cCierres              = ""
  cDelimitadorInicial   = "{"
  cFormatoFechas        = "99/99/9999"
  cFuncionExterna       = ""
  cMensajeError         = ""
  cSeparadorParametros  = "|||"
  cTextoJSON            = ""
  cUltimosDelimitadores = ""
  cWaitWindowMensaje    = "Se está realizando un proceso que puede demorar varios minutos. Paciencia por favor."
  
  lCursorYaProcesado = .F.
  lEnSiguienteLinea  = .T.
  lRespetarDecimales = .F.     && El string JSON tendrá los mismos decimales que fueron enviados, no se redondeará.
  lWaitWindow        = .F.
  
  nCantidadDecimales   = 0
  nCantidadEspacios    = 2
  nCantidadPropiedades = 0
  nNumeroLineaActual   = 0
  nNumeroLineaCabecera = 0
  *
  *
  *=== Convierte texto que se encuentra en el formato usado por JSON al formato usado en Visual FoxPro
  PROTECTED FUNCTION CONVERTIR_JSON_A_VFP
  LPARAMETERS tcTexto
  LOCAL lcTextoConvertido
    lcTextoConvertido = tcTexto
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\"', '"')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\\', '\')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\/', '/')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\t', CHR(  9))
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\n', CHR( 10))
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\f', CHR( 12))
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\r', CHR( 13))
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\b', CHR(127)) 
    RETURN (lcTextoConvertido)
  ENDFUNC
  *
  *=== Reemplaza los caracteres UNICODE por los correspondientes caracteres del idioma español
  PROTECTED FUNCTION CONVERTIR_UNICODE_A_ESPANOL
  LPARAMETERS tcTextoUnicode
  LOCAL lcResultado, lnPosicion, lcNumeroUnicode, lcCaracterLegible
  
    lcResultado = tcTextoUnicode
    
    lnPosicion  = AT("\u", lcResultado)
    
    DO WHILE lnPosicion > 0
      lcNumeroUnicode   = SUBSTR(lcResultado, lnPosicion, 6)
      lcCaracterLegible = CHR(EVALUATE("0x" + RIGHT(lcNumeroUnicode, 2)))
      lcResultado       = STRTRAN(lcResultado, lcNumeroUnicode, lcCaracterLegible)
      lnPosicion        = AT("\u", lcResultado)
    ENDDO
    
    RETURN (lcResultado)
    
  ENDFUNC
  *
  *=== Convierte texto que se encuentra en el formato usado por Visual FoxPro al formato usado en JSON
  PROTECTED FUNCTION CONVERTIR_VFP_A_JSON
  LPARAMETERS tcTexto
  LOCAL lcTextoConvertido
    
    lcTextoConvertido = tcTexto
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '"', '\"')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '\', '\\')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, '/', '\/')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, CHR(  9), '\t')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, CHR( 10), '\n')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, CHR( 12), '\f')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, CHR( 13), '\r')
    lcTextoConvertido = CHRTRAN(lcTextoConvertido, CHR(127), '\b')   
    
    RETURN (lcTextoConvertido)
    
  ENDFUNC
  *
  *=== Crea la estructura del cursor
  PROTECTED FUNCTION CREAR_ESTRUCTURA_CURSOR
  LPARAMETERS tcNombreCursor, tcStringJSON, tnCantidadRegistros
  LOCAL lcMensaje, lnCanReg, lcEstructura, llContinuar, lcRegistro, lnCantidadCampos, lcNombreValor, lcNombreCampo, luValorCampo, lnLongActual, lnLongAnterior
  LOCAL lnPosicionInicial, lnPosicionFinal, lnPosicionPuntoDecimal, lnCantidadDecimales, lnPosicionNombre, lnPosicionCorchete, lnI, lnJ, lnK
    lcMensaje    = ""
    lnCanReg     = 0
    lcEstructura = "CREATE CURSOR " + tcNombreCursor + "( "
    *--- Obtiene cada registro del array. Los registros deben estar delimitados por los símbolos { y }
    llContinuar = .T.
    DO WHILE llContinuar
      lcRegistro = STREXTRACT(tcStringJSON, "{", "}")
      IF !EMPTY(lcRegistro) THEN
        lnCanReg = lnCanReg + 1
        *--- Obtiene los nombres y los valores de cada uno de los campos
        lnJ = 1
        lnCantidadCampos = ALINES(laCampos, lcRegistro, 1, '":') - 1
        FOR lnI = 1 TO lnCantidadCampos
          lcNombreValor = ALLTRIM(GETWORDNUM(lcRegistro, lnJ, ","))
          lcNombreValor = ALLTRIM(lcNombreValor)
          lcNombreCampo = STREXTRACT(lcNombreValor, '"', '":')
          luValorCampo  = ALLTRIM(STRTRAN(lcNombreValor, '"' + lcNombreCampo + '":', ""))
          lnJ           = lnJ + 1
          IF OCCURS('"', luValorCampo) = 1 THEN     && Si dentro del valor del campo hay comillas, se debe manejar eso
            lnPosicionNombre = AT('"' + lcNombreCampo + '":', lcRegistro) + LEN(lcNombreCampo) + 3
            lnK              = lnPosicionNombre + LEN(luValorCampo) + 1
            DO WHILE SUBSTR(lcRegistro, lnK, 1) <> '"'
              luValorCampo = luValorCampo + SUBSTR(lcRegistro, lnK, 1)
              lnK          = lnK + 1
            ENDDO
            luValorCampo = luValorCampo + '"'
            lnJ          = lnJ + OCCURS(',', luValorCampo)
          ENDIF
          DO CASE
            CASE This.OBTENER_TIPO_CAMPO(luValorCampo) == "C"     && Carácter
              lnLongActual      = LEN(luValorCampo) - 2
              lnPosicionInicial = AT(lcNombreCampo + This.cSeparadorParametros, lcEstructura)
              IF lnPosicionInicial = 0 THEN
                lcEstructura = lcEstructura + lcNombreCampo + This.cSeparadorParametros + " C(" + TRANSFORM(MAX(lnLongActual, 1), "999") + "), "
              ELSE
                lnLongAnterior = INT(VAL(SUBSTR(lcEstructura, lnPosicionInicial + LEN(lcNombreCampo + This.cSeparadorParametros) + 3, 3)))
                IF lnLongActual > lnLongAnterior THEN
                  lcEstructura   = STRTRAN(lcEstructura, ;
                                           lcNombreCampo + This.cSeparadorParametros + " C(" + TRANSFORM(lnLongAnterior, "999") + "), ", ;
                                           lcNombreCampo + This.cSeparadorParametros + " C(" + TRANSFORM(lnLongActual  , "999") + "), ")
                ENDIF
              ENDIF
            CASE This.OBTENER_TIPO_CAMPO(luValorCampo) == "D"     && Date
              lnPosicionInicial = AT(lcNombreCampo + This.cSeparadorParametros, lcEstructura)
              IF lnPosicionInicial = 0 THEN
                lcEstructura = lcEstructura + lcNombreCampo + This.cSeparadorParametros + " D, "
              ENDIF
            CASE This.OBTENER_TIPO_CAMPO(luValorCampo) == "L"     && Lógico
              lnPosicionInicial = AT(lcNombreCampo + This.cSeparadorParametros, lcEstructura)
              IF lnPosicionInicial = 0 THEN
                lcEstructura = lcEstructura + lcNombreCampo + This.cSeparadorParametros + " L, "
              ENDIF
            CASE This.OBTENER_TIPO_CAMPO(luValorCampo) == "N"     && Numérico
              luValorCampo           = ALLTRIM(luValorCampo)
              lnLongActual           = LEN(luValorCampo)
              lnPosicionInicial      = AT(lcNombreCampo + This.cSeparadorParametros, lcEstructura)
              lnPosicionPuntoDecimal = AT(".", luValorCampo)
              lnCantidadDecimales    = IIF(lnPosicionPuntoDecimal > 0, lnLongActual - lnPosicionPuntoDecimal, 0)
              IF lnPosicionInicial = 0 THEN
                lcEstructura = lcEstructura + lcNombreCampo + This.cSeparadorParametros + " N (18, " + TRANSFORM(This.nCantidadDecimales) + "), "
              ENDIF
            CASE This.OBTENER_TIPO_CAMPO(luValorCampo) == "T"     && DateTime
              lnPosicionInicial = AT(lcNombreCampo + This.cSeparadorParametros, lcEstructura)
              IF lnPosicionInicial = 0 THEN
                lcEstructura = lcEstructura + lcNombreCampo + This.cSeparadorParametros + " T, "
              ENDIF
          ENDCASE
        ENDFOR
      ENDIF
      lnPosicionFinal    = AT("}", tcStringJSON)
      tcStringJSON       = ALLTRIM(SUBSTR(tcStringJSON, lnPosicionFinal + 2))
      lnPosicionFinal    = AT("}", tcStringJSON)
      lnPosicionCorchete = AT("]", tcStringJSON)
      llContinuar        = lnPosicionFinal > 0 .AND. lnPosicionFinal < lnPosicionCorchete .AND. (lnCanReg < tnCantidadRegistros .OR. tnCantidadRegistros = 0)
    ENDDO
    lcEstructura = LEFT(lcEstructura, LEN(lcEstructura) - 2) + ")"
    lcEstructura = CHRTRAN(lcEstructura, This.cSeparadorParametros, "") 
    TRY
      &lcEstructura
    CATCH
      lcMensaje = "No se pudo crear el cursor [" + UPPER(tcNombreCursor) + "]" + CHR(13) + "Verifica que se trate de un string JSON válido"
    ENDTRY
    RETURN (lcMensaje)
  ENDFUNC
  *
  *=== Crea y retorna un string con formato JSON
  FUNCTION DO_CREAR_JSON
  LPARAMETERS tcCerrarEstructuras
  LOCAL llCerrarEstructuras, lcDelimitadorFinal, lcCRLF, lnI, lnJ, lcElemento
  LOCAL lcObjetoPadre, lcTipoPropiedad, lcNombrePropiedad, lcValorPropiedad, lcTipoValor, lcIndicaciones, llCerrarItem, llEsFinObjeto, llArrayEnArray
  LOCAL llObjetoTieneNombre, lnCantidadCierres
  LOCAL lcPadreSiguiente, lcCaracteresValidos, lcComa, lnEspacios, lnIdentacion
    *--- No genera el string JSON si se detectó un error en algunos de los datos
    IF !EMPTY(This.cMensajeError) THEN
      RETURN ("ERROR. Datos erróneos, no es posible generar el string JSON")
    ENDIF
    tcCerrarEstructuras = IIF(VARTYPE(tcCerrarEstructuras) <> "C", "", tcCerrarEstructuras)
    llCerrarEstructuras = tcCerrarEstructuras <> "NO_CERRAR"
    TRY
      *=== PASO 1. Se inicializan las variables que serán necesarias para generar el string JSON
      *--- Un texto JSON debe finalizar con "}" si empezó con "{", o finalizar con "]" si empezó con "["
      lcDelimitadorFinal = IIF(This.cDelimitadorInicial == "{", "}", "]")
      *--- En la variable "lcCierres" se colocan las llaves de cierre y los corchetes de cierre, que aún están vigentes
      lcCierres = lcDelimitadorFinal
      *--- Después de escribir el valor de una propiedad se pasa a la siguiente línea o se continúa en la línea actual
      lcCRLF = IIF(This.lEnSiguienteLinea, CHR(13) + CHR(10), "")
      *=== PASO 2.  Se intenta crear el texto JSON
      FOR lnI = 1 TO This.nCantidadPropiedades
        *--- Se extrae del elemento actual del array cada dato ahí guardado. Hay 6 datos en cada elemento del array
        lcElemento        = This.APROPIEDADES[lnI]
        lcObjetoPadre     = GETWORDNUM(lcElemento, 1, This.cSeparadorParametros)
        lcTipoPropiedad   = GETWORDNUM(lcElemento, 2, This.cSeparadorParametros)
        lcNombrePropiedad = GETWORDNUM(lcElemento, 3, This.cSeparadorParametros)
        lcValorPropiedad  = GETWORDNUM(lcElemento, 4, This.cSeparadorParametros)
        lcTipoValor       = GETWORDNUM(lcElemento, 5, This.cSeparadorParametros)
        lcIndicaciones    = GETWORDNUM(lcElemento, 6, This.cSeparadorParametros)
        llCerrarItem      = "CERRAR" $ UPPER(lcIndicaciones) .OR. (lcTipoPropiedad == "O" .AND. "CERRAR" $ lcTipoValor)
        llEsFinObjeto     = "FIN_OBJETO" $ UPPER(lcIndicaciones)
        llArrayEnArray    = "ARRAY_EN_ARRAY" $ UPPER(lcIndicaciones)
        *--- Se guarda si el objeto tiene nombre o no lo tiene
        llObjetoTieneNombre = UPPER(lcNombrePropiedad) <> "***OBJETO***"
        *--- Se asegura que la variable "lcNombrePropiedad" contenga solamente caracteres válidos: mayúsculas, minúsculas, y dígitos
        lcCaracteresValidos = "ABCDEFGHIJKLMNOPQRSTUVWXYZÁÉÍÓÚÜÑabcdefghijklmnopqrstuvwxyzáéíóúüñ0123456789"
        lcNombrePropiedad   = CHRTRAN(lcNombrePropiedad, CHRTRAN(lcNombrePropiedad, lcCaracteresValidos, ""), "")
        *--- Se agrega el nombre de la propiedad al string JSON, cuando no es un elemento de un array
        lnIdentacion = IIF(This.lEnSiguienteLinea, LEN(This.cCierres) * This.nCantidadEspacios, 0)     && La cantidad de espacios en blanco que se pondrán al inicio de cada línea
        DO CASE
          CASE lcTipoPropiedad == "A"
            This.cTextoJSON = This.cTextoJSON + SPACE(lnIdentacion) + IIF(!llArrayEnArray, This.PONER_COMILLAS(lcNombrePropiedad) + ": ", "")
          CASE lcTipoPropiedad == "E"
            This.cTextoJSON = This.cTextoJSON + SPACE(lnIdentacion)
          CASE lcTipoPropiedad == "L"
            This.cTextoJSON = This.cTextoJSON + SPACE(lnIdentacion) + This.PONER_COMILLAS(lcNombrePropiedad) + ": "
          CASE lcTipoPropiedad == "O" .AND. llObjetoTieneNombre
            This.cTextoJSON = This.cTextoJSON + SPACE(lnIdentacion) + This.PONER_COMILLAS(lcNombrePropiedad) + ": "
          CASE lcTipoPropiedad == "O" .AND. !llObjetoTieneNombre
            This.cTextoJSON = This.cTextoJSON + SPACE(lnIdentacion)
        ENDCASE
        *--- Se obtiene el nombre del objeto padre del siguiente elemento para saber si se debe colocar una coma después del valor, o no
        lcPadreSiguiente = IIF(lnI < This.nCantidadPropiedades, GETWORDNUM(This.APROPIEDADES[lnI + 1], 1, This.cSeparadorParametros), "")
        *--- Si el nombre del siguiente padre tiene la misma o mayor cantidad de caracteres que el nombre del padre actual, se debe colocar una coma después del valor
        lcComa = IIF(LEN(lcPadreSiguiente) >= LEN(lcObjetoPadre), ", ", "")
        lcComa = IIF(llCerrarItem, "", lcComa)
        *--- Se agrega el valor de la propiedad al string JSON
        DO CASE
          CASE lcTipoPropiedad == "A"     && El valor es un "array", por eso al JSON se le debe agregar un "["
            lnEspacios  = GETWORDCOUNT(lcObjetoPadre, ",")
            This.cTextoJSON = This.cTextoJSON + "[" + lcCRLF     &&+ SPACE((lnEspacios + 1) * This.nCantidadEspacios) + "{" + lcCRLF
            This.cCierres   = This.cCierres + "]"     && Para recordar que se debe cerrar este "array"
          CASE lcTipoPropiedad == "E" .OR. lcTipoPropiedad == "L"     && El valor es un "elemento" de un array o es un valor "literal"
            lcValorPropiedad = This.EDITAR_VALOR(lcTipoValor, lcValorPropiedad)
            This.cTextoJSON  = This.cTextoJSON + lcValorPropiedad + lcComa + lcCRLF
          CASE lcTipoPropiedad == "O"     && El valor es un "objeto", por eso al JSON se le debe agregar un "{"
            This.cTextoJSON = This.cTextoJSON + "{" + lcCRLF
            This.cCierres   = This.cCierres + "}"     && Para recordar que se debe cerrar este "objeto"
        ENDCASE
        *--- Si se trata del último ítem de un "array" o de un "objeto" entonces se debe cerrar con "]" o con "}", según corresponda
        IF llCerrarItem THEN
          lnCantidadCierres = OCCURS("CERRAR", lcIndicaciones) + IIF(lcTipoPropiedad == "O", OCCURS("CERRAR", lcTipoValor), 0)
          FOR lnJ = 1 TO lnCantidadCierres
            lnIdentacion    = IIF(This.lEnSiguienteLinea, (LEN(This.cCierres) - 1) * This.nCantidadEspacios, 0)     && La cantidad de espacios en blanco que se pondrán al inicio de la línea de cierre
            This.cTextoJSON = This.cTextoJSON + SPACE(lnIdentacion) + RIGHT(This.cCierres, 1) + IIF(lnJ < lnCantidadCierres, lcCRLF, "")    && Se cierra el "array" o el "objeto"
            This.cCierres   = LEFT(This.cCierres, LEN(This.cCierres) - 1)     && Como ya se realizó este cierre, se lo elimina de la lista de cierres pendientes
          ENDFOR
          *--- Si en el JSON hay más propiedades, entonces se debe poner una coma antes de los datos de la siguiente propiedad
          IF lnI < This.nCantidadPropiedades THEN
            This.cTextoJSON = This.cTextoJSON + ", " + lcCRLF
            *--- Cuando es un objeto dentro de un array de objetos, se debe agregar el siguiente objeto
            IF RIGHT(This.cCierres, 1) == "]" .AND. !llEsFinObjeto THEN
              This.cTextoJSON = This.cTextoJSON + SPACE(LEN(This.cCierres) * This.nCantidadEspacios) + "{" + lcCRLF
              This.cCierres   = This.cCierres + "}"
            ENDIF
          ELSE
            This.cTextoJSON = This.cTextoJSON + lcCRLF
          ENDIF
        ENDIF
        *--- Si el padre de la siguiente propiedad tiene menor longitud, entonces hay que cerrar el "array" o el "objeto"
        IF LEN(lcPadreSiguiente) < LEN(lcObjetoPadre) .AND. LEN(This.cCierres) >= 1 .AND. llCerrarEstructuras THEN
          lnIdentacion = IIF(This.lEnSiguienteLinea, (LEN(This.cCierres) - 1) * This.nCantidadEspacios, 0)     && La cantidad de espacios en blanco que se pondrán al inicio de la línea de cierre
          This.cTextoJSON  = This.cTextoJSON + SPACE(lnIdentacion) + RIGHT(This.cCierres, 1)     && Se cierra el "array" o el "objeto"
          This.cTextoJSON  = This.cTextoJSON + IIF(lnI < This.nCantidadPropiedades, ", ", "") + lcCRLF     && Después de cerrar se agrega una coma si hay más propiedades
          This.cCierres    = LEFT(This.cCierres, LEN(This.cCierres) - 1)     && Como ya se realizó este cierre, se lo elimina de la lista de cierres pendientes
        ENDIF
      ENDFOR
      *--- Se colocan todas las llaves de cierre y todos los corchetes de cierre que faltaban colocar
      IF llCerrarEstructuras THEN
        *--- Si después del último símbolo de cierre hay una coma, se debe eliminar esa coma del string JSON
        IF RIGHT(This.cTextoJSON, 2 + LEN(lcCRLF)) == ", " + lcCRLF THEN
          This.cTextoJSON = LEFT(This.cTextoJSON, LEN(This.cTextoJSON) - (2 + LEN(lcCRLF))) + lcCRLF
        ENDIF
        *--- Se agregan todos los símbolos de cierres de estructura que faltaba colocar en el final del texto JSON para que éste sea correcto
        FOR lnI = LEN(This.cCierres) TO 1 STEP - 1
          This.cTextoJSON = This.cTextoJSON  + SPACE((lnI - 1) * This.nCantidadEspacios) + SUBSTR(This.cCierres, lnI, 1) + lcCRLF
        ENDFOR
      ENDIF
    CATCH
      This.cMensajeError = "ERROR. Hay datos errónes y el string JSON no fue generado correctamente"
      This.cTextoJSON        = IIF(VARTYPE(This.cTextoJSON) <> "C", This.cMensajeError, This.cTextoJSON)
    ENDTRY
    *--- Devuelve un texto con formato JSON
    RETURN (This.cTextoJSON)
  ENDFUNC
  *
  *=== Genera un string con formato JSON a partir de los datos obtenidos de una tabla/cursor
  FUNCTION DO_CURSOR_A_JSON
  LPARAMETERS tcNombreCursor, tcTipoPropiedad
  LOCAL llGeneracionOK, lcAlias, lcCRLF, lnIdentacion1, lnIdentacion2, lnIdentacion3, llPropiedadValor, lcNombreArray
  LOCAL lnCantidadCampos, lnI, lcComa, lcNombreCampo, lnPosicion, lcValorCampo
    
    *--- Se obtiene el tipo de propiedad de los registros de la tabla/cursor. Por defecto, se supone que los registros serán objetos y elementos de un array
    tcTipoPropiedad = IIF(VARTYPE(tcTipoPropiedad) <> "C", "O", tcTipoPropiedad)
    tcTipoPropiedad = UPPER(LEFT(ALLTRIM(tcTipoPropiedad), 1))
    tcTipoPropiedad = IIF(tcTipoPropiedad $ "EO", tcTipoPropiedad, "O")
    
    *--- Se agregan al string JSON los registros de la tabla/cursor
    llGeneracionOK = .T.
    
    lcAlias = ALIAS()
    
    SELECT (tcNombreCursor)
    
    WITH This
      lcCRLF        = IIF(.lEnSiguienteLinea, CHR(13) + CHR(10), "")
      lnIdentacion1 = IIF(.lEnSiguienteLinea, (LEN(.cCierres) + 0) * .nCantidadEspacios, 0)     && Espacios en blanco antes del símbolo de estructura
      lnIdentacion2 = IIF(.lEnSiguienteLinea, (LEN(.cCierres) + 1) * .nCantidadEspacios, 0)     && Espacios en blanco antes del campo
      lnIdentacion3 = IIF(.lEnSiguienteLinea, (LEN(.cCierres) - 1) * .nCantidadEspacios, 0)     && Espacios en blanco antes del cierre
      *--- Si el texto JSON está vacío, se le debe agregar el delimitador inicial, o sea una "{" o un "["
      IF EMPTY(.cTextoJSON) THEN
        .cCierres   = IIF(.cDelimitadorInicial == "{", "}", "]")
        .cTextoJSON = .cDelimitadorInicial + lcCRLF
      ENDIF
      DIMENSION .APROPIEDADES[1]
      .APROPIEDADES[1]      = ""
      .nCantidadPropiedades = 0
      lnCantidadCampos = AFIELDS(aCamposEnCursorJSON, tcNombreCursor)
      llPropiedadValor = IIF(tcTipoPropiedad == "O", .T., .F.)     && Muestra el nombre de la propiedad y su valor, o solamente su valor
      SCAN
        DO CASE
          CASE tcTipoPropiedad == "E"
            lcNombreArray = IIF(!EMPTY(.cFuncionExterna), EVALUATE(.cFuncionExterna), RECNO())
            .cTextoJSON   = .cTextoJSON + SPACE(lnIdentacion1) + .PONER_COMILLAS(lcNombreArray) + ": [" + lcCRLF
          CASE tcTipoPropiedad == "O"
            .cTextoJSON = .cTextoJSON + SPACE(lnIdentacion1) + "{" + lcCRLF
        ENDCASE
        FOR lnI = 1 TO lnCantidadCampos
          lcComa        = IIF(lnI < lnCantidadCampos, ", ", "")
          lcNombreCampo = aCamposEnCursorJSON[lnI, 1]
          lcNombreCampo = LOWER(lcNombreCampo)
          IF UPPER(lcNombreCampo) $ UPPER(.cCamelCase) THEN
            lnPosicion    = AT(UPPER(lcNombreCampo), UPPER(.cCamelCase))
            lcNombreCampo = SUBSTR(.cCamelCase, lnPosicion, LEN(lcNombreCampo))
          ENDIF
          *--- Se agrega el nombre del campo
          .cTextoJSON  = .cTextoJSON + SPACE(lnIdentacion2) + IIF(llPropiedadValor, .PONER_COMILLAS(lcNombreCampo) + ": ", "")
          *--- Se agrega el valor del campo
          lcValorCampo = This.EDITAR_VALOR(VARTYPE(EVALUATE(lcNombreCampo)), TRANSFORM(EVALUATE(lcNombreCampo)))
          .cTextoJSON  = .cTextoJSON + lcValorCampo + lcComa + lcCRLF
        ENDFOR
        DO CASE
          CASE tcTipoPropiedad == "E"
            .cTextoJSON = .cTextoJSON + SPACE(lnIdentacion1) + "]"
          CASE tcTipoPropiedad == "O"
            .cTextoJSON = .cTextoJSON + SPACE(lnIdentacion1) + "}"
        ENDCASE
        .cTextoJSON = .cTextoJSON + IIF(RECNO() < RECCOUNT(), ", ", "") + lcCRLF
      ENDSCAN
      .cTextoJSON = .cTextoJSON + SPACE(lnIdentacion3) + RIGHT(.cCierres, 1)     && Se cierra el "array" o el "objeto"
      .cTextoJSON = .cTextoJSON + ", " + lcCRLF     && Después de cerrar se agrega una coma si hay más propiedades
      .cCierres   = LEFT(.cCierres, LEN(.cCierres) - 1)     && Como ya se realizó este cierre, se lo elimina de la lista de cierres pendientes
    ENDWITH
    
    IF !EMPTY(lcAlias) THEN
      SELECT (lcAlias)
    ENDIF
    
    RETURN (llGeneracionOK)
    
  ENDFUNC
  *
  *=== Extrae todos los arrays de un archivo de texto o de un string
  FUNCTION DO_EXTRAER_ARRAYS
  LPARAMETERS tcTipoParametro, tcFuenteDatos, tlObtenerVariable, tcDelimitadorInicial, tcDelimitadorFinal, tnOcurrencia, tnCodificacion
  LOCAL lcStringOrigenJSON, lcStringDestinoJSON, lnCantidadPropiedades, lnI, lcNombrePropiedad, lcValorPropiedad, lnPosicionCorchete
    
    #DEFINE CRLF         CHR(13) + CHR(10)
    #DEFINE UTF_8_A_DBCS 11
    
    tcDelimitadorInicial = IIF(PCOUNT() >= 4, TRANSFORM(tcDelimitadorInicial), "")
    tcDelimitadorFinal   = IIF(PCOUNT() >= 5, TRANSFORM(tcDelimitadorFinal)  , "")
    tnOcurrencia         = IIF(VARTYPE(tnOcurrencia) == "N", tnOcurrencia, 1)
    tnCodificacion       = IIF(VARTYPE(tnCodificacion) <> "N", 0, tnCodificacion)
    
    lcStringOrigenJSON = IIF(tcTipoParametro == "A", FILETOSTR(tcFuenteDatos), tcFuenteDatos)     && A=archivo de texto
    
    DO CASE
      CASE tnCodificacion = 1
        lcStringOrigenJSON = STRCONV(lcStringOrigenJSON, UTF_8_A_DBCS)
      CASE tnCodificacion = 2
        lcStringOrigenJSON  = This.CONVERTIR_UNICODE_A_ESPANOL(lcStringOrigenJSON)
    ENDCASE
    
    IF !EMPTY(tcDelimitadorInicial) .OR. !EMPTY(tcDelimitadorFinal) THEN
      lcStringOrigenJSON = STREXTRACT(lcStringOrigenJSON, tcDelimitadorInicial, tcDelimitadorFinal, tnOcurrencia, 3)
    ENDIF
    
    lcStringOrigenJSON    = CHRTRAN(lcStringOrigenJSON, CHR(10), "")
    lcStringOrigenJSON    = CHRTRAN(lcStringOrigenJSON, CHR(13), "")
    lcStringDestinoJSON   = ""
    lnCantidadPropiedades = ALINES(laCampos, lcStringOrigenJSON, 1, '":') - 1
    
    lnJ                   = 1
    
    FOR lnI = 1 TO lnCantidadPropiedades
      *--- Se obtiene el nombre de la propiedad y el valor de esa propiedad
      lcNombrePropiedad   = STREXTRACT(lcStringOrigenJSON, '"', '":')
      lcValorPropiedad    = STREXTRACT(lcStringOrigenJSON, '[', ']', 1, 4)
      lnPosicionCorchete  = AT("]", lcStringOrigenJSON)
      IF !EMPTY(lcNombrePropiedad) THEN
        lcStringDestinoJSON = lcStringDestinoJSON + lcNombrePropiedad + " = " + lcValorPropiedad + CRLF
        IF tlObtenerVariable THEN
          lcPropiedadValor = "M." + lcNombrePropiedad + " = " + lcValorPropiedad
          IF VARTYPE(&lcNombrePropiedad) == "C" .AND. EMPTY(&lcNombrePropiedad) THEN
            &lcPropiedadValor
          ENDIF
        ENDIF
      ENDIF
      lcStringOrigenJSON  = SUBSTR(lcStringOrigenJSON, lnPosicionCorchete + 1)
    ENDFOR
    
    RETURN (lcStringDestinoJSON)
    
  ENDFUNC
  *
  *=== Extrae todos los literales de un archivo de texto o de un string
  FUNCTION DO_EXTRAER_LITERALES
  LPARAMETERS tcTipoParametro, tcFuenteDatos, tlObtenerVariable, tcDelimitadorInicial, tcDelimitadorFinal, tnOcurrencia, tnCodificacion
  LOCAL lcStringOrigenJSON, lcStringDestinoJSON, lnCantidadPropiedades, lnI, lnJ, lnK, lcPropiedadValor, lnPosicionInicio, lcNombrePropiedad, lcValorPropiedad
  LOCAL lnPosicionNombre
    
    #DEFINE CRLF         CHR(13) + CHR(10)
    #DEFINE UTF_8_A_DBCS 11
    
    tcDelimitadorInicial = IIF(PCOUNT() >= 4, TRANSFORM(tcDelimitadorInicial), "")
    tcDelimitadorFinal   = IIF(PCOUNT() >= 5, TRANSFORM(tcDelimitadorFinal)  , "")
    tnOcurrencia         = IIF(VARTYPE(tnOcurrencia) == "N", tnOcurrencia, 1)
    tnCodificacion       = IIF(VARTYPE(tnCodificacion) <> "N", 0, tnCodificacion)
    
    lcStringOrigenJSON = IIF(tcTipoParametro == "A", FILETOSTR(tcFuenteDatos), tcFuenteDatos)     && A=archivo de texto
    
    DO CASE
      CASE tnCodificacion = 1
        lcStringOrigenJSON = STRCONV(lcStringOrigenJSON, UTF_8_A_DBCS)
      CASE tnCodificacion = 2
        lcStringOrigenJSON  = This.CONVERTIR_UNICODE_A_ESPANOL(lcStringOrigenJSON)
    ENDCASE
    
    IF !EMPTY(tcDelimitadorInicial) .OR. !EMPTY(tcDelimitadorFinal) THEN
      lcStringOrigenJSON = STREXTRACT(lcStringOrigenJSON, tcDelimitadorInicial, tcDelimitadorFinal, tnOcurrencia, 3)
    ENDIF
    
    lcStringOrigenJSON    = CHRTRAN(lcStringOrigenJSON, CHR(10), "")
    lcStringOrigenJSON    = CHRTRAN(lcStringOrigenJSON, CHR(13), "")
    lcStringOrigenJSON    = CHRTRAN(lcStringOrigenJSON, "}]", "")
    lcStringDestinoJSON   = ""
    lnCantidadPropiedades = ALINES(laCampos, lcStringOrigenJSON, 1, '":') - 1
    
    lnJ                   = 1
    
    FOR lnI = 1 TO lnCantidadPropiedades
      lcPropiedadValor = GETWORDNUM(lcStringOrigenJSON, lnJ, ",")
      *--- Si hay una llave de apertura entonces no es un valor literal, es un objeto
      DO WHILE "{" $ lcPropiedadValor
        lnPosicionInicio = AT("{", lcPropiedadValor)
        lcPropiedadValor = SUBSTR(lcPropiedadValor, lnPosicionInicio + 1)
      ENDDO
      *--- Si hay un corchete de apertura entonces no es un valor literal, es un array
      DO WHILE "[" $ lcPropiedadValor
        lnPosicionInicio = AT("[", lcPropiedadValor)
        lcPropiedadValor = SUBSTR(lcPropiedadValor, lnPosicionInicio + 1)
      ENDDO
      *--- Se obtiene el nombre de la propiedad y el valor de esa propiedad
      lcPropiedadValor  = ALLTRIM(lcPropiedadValor)
      lcNombrePropiedad = STREXTRACT(lcPropiedadValor, '"', '":')
      lcValorPropiedad  = ALLTRIM(STREXTRACT(lcPropiedadValor, '":'))
      lnJ               = lnJ + 1
      IF OCCURS('"', lcValorPropiedad) = 1 THEN     && Si dentro del valor del campo hay comillas, se debe manejar eso
        lnPosicionNombre = AT('"' + lcNombrePropiedad + '":', lcStringOrigenJSON) + LEN(lcNombrePropiedad) + 3
        lnK              = lnPosicionNombre + LEN(lcValorPropiedad) + 1
        DO WHILE SUBSTR(lcStringOrigenJSON, lnK, 1) <> '"'
          lcValorPropiedad = lcValorPropiedad + SUBSTR(lcStringOrigenJSON, lnK, 1)
          lnK          = lnK + 1
        ENDDO
        lcValorPropiedad = lcValorPropiedad + '"'
        lnJ          = lnJ + OCCURS(',', lcValorPropiedad)
      ENDIF
      IF OCCURS('[', lcValorPropiedad) = 1 THEN     && Si dentro del valor del campo hay comillas, se debe manejar eso
        lnPosicionNombre = AT('"' + lcNombrePropiedad + '":', lcStringOrigenJSON) + LEN(lcNombrePropiedad) + 3
        lnK              = lnPosicionNombre + LEN(lcValorPropiedad) + 1
        DO WHILE SUBSTR(lcStringOrigenJSON, lnK, 1) <> ']'
          lcValorPropiedad = lcValorPropiedad + SUBSTR(lcStringOrigenJSON, lnK, 1)
          lnK          = lnK + 1
        ENDDO
        lcValorPropiedad = lcValorPropiedad + ']'
        lnJ          = lnJ + OCCURS(',', lcValorPropiedad)
      ENDIF
      lcValorPropiedad  = IIF(lcValorPropiedad  == "false", ".F."   , lcValorPropiedad)
      lcValorPropiedad  = IIF(lcValorPropiedad  == "true" , ".T."   , lcValorPropiedad)
      lcValorPropiedad  = IIF(lcValorPropiedad  == "null" , ".NULL.", lcValorPropiedad)
      *--- Se agrega a un string el nombre de la propiedad y el valor de esa propiedad
      IF !EMPTY(lcNombrePropiedad) THEN
        lcStringDestinoJSON = lcStringDestinoJSON + lcNombrePropiedad + " = " + lcValorPropiedad + CRLF
        IF tlObtenerVariable THEN
          lcPropiedadValor = "M." + lcNombrePropiedad + " = " + lcValorPropiedad
          IF VARTYPE(&lcNombrePropiedad) == "C" .AND. EMPTY(&lcNombrePropiedad) THEN
            &lcPropiedadValor
          ENDIF
        ENDIF
      ENDIF
    ENDFOR
    
    RETURN (lcStringDestinoJSON)
    
  ENDFUNC
  *  
  *=== Crea un cursor y le agrega registros. Cada registro se obtiene a partir de un array cuyos elementos son objetos
  FUNCTION DO_JSON_A_CURSOR
  LPARAMETERS tcNombreCursor, tcNombreArchivo, tcNombreArray, tnCantidadRegistros, tnCodificacion
  LOCAL lcStringJSON, llContinuar, lnI, lnJ, lnK, lnPosicionInicial, lnPosicionFinal, lnPosicionCorchete, lcStringTemp, lcRegistro, lnCantidadCampos
  LOCAL lcNombreValor, lcNombreCampo, luValorCampo, lcTipoCampo, lcSetDecimals, lnPosicionNombre, lnCanReg
    #DEFINE CRLF CHR(13) + CHR(10)
    *--- Se verifica si hay algún error en los parámetros
    WITH This
      .cMensajeError = IIF(PCOUNT() < 2                                                                 , "La función DO_JSON_A_CURSOR() debe recibir al menos 2 parámetros", .cMensajeError)
      .cMensajeError = IIF(VARTYPE(tcNombreCursor) <> "C" .OR. EMPTY(tcNombreCursor)                    , "Nombre del cursor inválido"                                      , .cMensajeError)
      .cMensajeError = IIF(VARTYPE(tcNombreArchivo) <> "C" .OR. EMPTY(tcNombreArchivo)                  , "Nombre del archivo con formato JSON inválido"                    , .cMensajeError)
      .cMensajeError = IIF(PCOUNT() >= 3 .AND. (VARTYPE(tcNombreArray) <> "C" .OR. EMPTY(tcNombreArray)), "Nombre del array inválido"                                       , .cMensajeError)
      IF !EMPTY(.cMensajeError) THEN
        RETURN (.F.)
      ENDIF
    ENDWITH
    *--- Se le muestra un mensaje al usuario avisándole que la generación del cursor se demorará un buen tiempo
    IF This.lWaitWindow THEN
      WAIT WINDOW This.cWaitWindowMensaje NOWAIT
    ENDIF
    *--- Si no se especificó un parámetro, entonces se le asigna un valor por defecto
    tnCantidadRegistros = IIF(VARTYPE(tnCantidadRegistros) <> "N" .OR. tnCantidadRegistros < 0, 10, tnCantidadRegistros)
    tnCodificacion      = IIF(VARTYPE(tnCodificacion)      <> "N" .OR. tnCodificacion      < 0,  0, tnCodificacion     )
    *--- Obtiene el contenido del archivo de texto con formato JSON
    lcStringJSON = FILETOSTR(tcNombreArchivo)
    *--- Elimina los retornos de carro y alimentación de línea del string JSON
    lcStringJSON = CHRTRAN(lcStringJSON, CRLF, "")
    *--- Convierte el string JSON a formato legible
    DO CASE
      CASE tnCodificacion = 1
        lcStringJSON = STRCONV(lcStringJSON, UTF_8_A_DBCS)
      CASE tnCodificacion = 2
        lcStringJSON = This.CONVERTIR_UNICODE_A_ESPANOL(lcStringJSON)
    ENDCASE
    *--- Busca el nombre del array en el string con formato JSON recién obtenido
    IF !EMPTY(tcNombreArray) THEN
      lnI         = 1
      llContinuar = .T.
      DO WHILE llContinuar
        lnPosicionInicial = AT('"' + tcNombreArray + '":', lcStringJSON, lnI)
        IF lnPosicionInicial > 0 THEN
          lcStringTemp = SUBSTR(lcStringJSON, lnPosicionInicial + LEN(tcNombreArray) + 3, 50)
          lcStringTemp = CHRTRAN(lcStringTemp, " " + CHR(13) + CHR(10), "")
          llContinuar  = IIF(LEFT(lcStringTemp, 1) == "[", .F., llContinuar)
        ENDIF
        lnI         = lnI + 1
        llContinuar = IIF(llContinuar .AND. lnI > 50, .F., llContinuar)
      ENDDO
      This.cMensajeError = IIF(lnPosicionInicial = 0, "No existe el nombre del array en el texto JSON. Verifica el nombre del array", This.cMensajeError)
      IF EMPTY(This.cMensajeError) THEN
        lcStringJSON = SUBSTR(lcStringJSON, lnPosicionInicial + LEN(tcNombreArray) + 3)
      ENDIF
    ENDIF
    *--- Se crea un cursor con la estructura obtenida de los objetos del array
    IF EMPTY(This.cMensajeError) THEN
      This.cMensajeError = This.CREAR_ESTRUCTURA_CURSOR(tcNombreCursor, lcStringJSON, tnCantidadRegistros)
    ENDIF
    *--- Se agregan los registros del string JSON al cursor. Los registros del string JSON deben estar delimitados por los símbolos { y }
    IF EMPTY(This.cMensajeError) THEN
      lcSetDecimals = SET("DECIMALS")
      SET DECIMALS TO This.nCantidadDecimales
      lnCanReg    = 0
      llContinuar = .T.
      DO WHILE llContinuar
        lcRegistro = STREXTRACT(lcStringJSON, "{", "}")
        IF !EMPTY(lcRegistro) THEN
          APPEND BLANK
          lnCanReg = lnCanReg + 1
          *--- Obtiene los nombres y los valores de cada uno de los campos
          lnJ              = 1
          lnCantidadCampos = ALINES(laCampos, lcRegistro, 1, '":') - 1
          FOR lnI = 1 TO lnCantidadCampos
            lcNombreValor = ALLTRIM(GETWORDNUM(lcRegistro, lnJ, ","))
            lcNombreValor = ALLTRIM(lcNombreValor)
            lcNombreCampo = STREXTRACT(lcNombreValor, '"', '":')
            luValorCampo  = ALLTRIM(STRTRAN(lcNombreValor, '"' + lcNombreCampo + '":', ""))
            IF !EMPTY(lcNombreCampo) THEN
              lnJ           = lnJ + 1
              IF OCCURS('"', luValorCampo) = 1 THEN     && Si dentro del valor del campo hay comillas, se debe manejar eso
                lnPosicionNombre = AT('"' + lcNombreCampo + '":', lcRegistro) + LEN(lcNombreCampo) + 3
                lnK              = lnPosicionNombre + LEN(luValorCampo) + 1
                DO WHILE SUBSTR(lcRegistro, lnK, 1) <> '"'
                  luValorCampo = luValorCampo + SUBSTR(lcRegistro, lnK, 1)
                  lnK          = lnK + 1
                ENDDO
                luValorCampo = luValorCampo + '"'
                lnJ          = lnJ + OCCURS(',', luValorCampo)
              ENDIF
              lcTipoCampo  = This.OBTENER_TIPO_CAMPO(luValorCampo)
              luValorCampo = CHRTRAN(luValorCampo, '"', '')
              DO CASE
                CASE lcTipoCampo == "C"     && Carácter
                  TRY
                    REPLACE &lcNombreCampo WITH luValorCampo
                  CATCH
                    This.cMensajeError = "Probablemente en el campo donde se encuentra [" + M.luValorCampo + "] hay una coma. Reemplázala y vuelve a intentarlo"
                    EXIT
                  ENDTRY
                CASE lcTipoCampo == "D"     && Date/Fecha
                  REPLACE &lcNombreCampo WITH This.FECHA_VALIDA(luValorCampo)
                CASE lcTipoCampo == "L"     && Lógico
                  REPLACE &lcNombreCampo WITH IIF(UPPER(luValorCampo) == "TRUE", .T., .F.)
                CASE lcTipoCampo == "N"     && Numérico
                  REPLACE &lcNombreCampo WITH ROUND(VAL(luValorCampo), 4)
                CASE lcTipoCampo == "T"     && DateTime/FechaHora
                  REPLACE &lcNombreCampo WITH This.FECHA_HORA_VALIDA(luValorCampo)
              ENDCASE
            ENDIF
          ENDFOR
        ENDIF
        lnPosicionFinal    = AT("}", lcStringJSON)
        lcStringJSON       = ALLTRIM(SUBSTR(lcStringJSON, lnPosicionFinal + 1))
        lnPosicionFinal    = AT("}", lcStringJSON)
        lnPosicionCorchete = AT("]", lcStringJSON)
        llContinuar        = lnPosicionFinal > 0 .AND. lnPosicionFinal < lnPosicionCorchete
      ENDDO
      SET DECIMALS TO &lcSetDecimals
    ENDIF
    *--- Si se había mostrado un WAITWINDOW al usuario, se deja de mostrarlo
    IF This.lWaitWindow THEN
      WAIT CLEAR
    ENDIF
    *--- Devuelve .T. si la función se completó con éxito, .F. si ocurrió algún error
    RETURN (EMPTY(This.cMensajeError))
  ENDFUNC
  *
  *=== Convierte una fecha al formato normalmente utilizado con JSON
  PROTECTED FUNCTION EDITAR_FECHA
  LPARAMETERS tuFecha
  LOCAL lcDia, lcMes, lcAno, lcFechaEditada
    tuFecha        = ALLTRIM(TRANSFORM(tuFecha))
    lcDia          = LEFT(tuFecha, 2)
    lcMes          = SUBSTR(tuFecha, 4, 2)
    lcAno          = RIGHT(tuFecha, 4)
    lcFechaEditada = lcAno + "-" + lcMes + "-" + lcDia
    RETURN (lcFechaEditada)
  ENDFUNC
  *
  *=== Convierte una fechahora al formato normalmente usado con JSON
  PROTECTED FUNCTION EDITAR_FECHA_HORA
  LPARAMETERS tuFechaHora
  LOCAL lcFechaHoraEditada
    lcFechaHoraEditada = This.EDITAR_FECHA(LEFT(tuFechaHora, 10)) + "T" + SUBSTR(tuFechaHora, 12)
    RETURN (lcFechaHoraEditada)
  ENDFUNC
  *
  *=== Edita el valor de una propiedad para que se encuentre acorde a su tipo
  PROTECTED FUNCTION EDITAR_VALOR
  LPARAMETERS tcTipoValor, tcValorPropiedad
    DO CASE
      CASE tcTipoValor == "C"     && El valor es de tipo "carácter"
        tcValorPropiedad = This.PONER_COMILLAS(ALLTRIM(tcValorPropiedad))
      CASE tcTipoValor == "D"     && El valor es de tipo "fecha"
        tcValorPropiedad = This.PONER_COMILLAS(This.EDITAR_FECHA(tcValorPropiedad))
      CASE tcTipoValor == "L"     && El valor es de tipo "lógico"
        tcValorPropiedad = IIF(ALLTRIM(tcValorPropiedad) == ".T.", "true", "false")
      CASE tcTipoValor == "N"     && El valor es de tipo "numérico"
        tcValorPropiedad = ALLTRIM(tcValorPropiedad)
      CASE tcTipoValor == "T"     && El valor es de tipo "fechaHora"
        tcValorPropiedad = This.PONER_COMILLAS(This.EDITAR_FECHA_HORA(tcValorPropiedad))
      CASE tcTipoValor == "X"     && El valor es de tipo "null"
        tcValorPropiedad = "null"
    ENDCASE
    RETURN (tcValorPropiedad)
  ENDFUNC
  *
  *=== Verifica si un string es una fecha o no
  PROTECTED FUNCTION ES_FECHA
  LPARAMETERS tcFecha
  LOCAL lcCaracteresValidos, llEsFecha, llFormatoDMA, llFormatoAMD, llFormatoMDA, lnDia, lnMes, lnAno
    tcFecha             = SUBSTR(tcFecha, 2, 10)
    lcCaracteresValidos = "0123456789-/"
    llEsFecha           = .T.
    llEsFecha           = IIF(LEN(tcFecha) <> 10                                       , .F., llEsFecha)
    llEsFecha           = IIF(!EMPTY(CHRTRAN(tcFecha, lcCaracteresValidos, ""))        , .F., llEsFecha)
    llEsFecha           = IIF(OCCURS("-", tcFecha) <> 2 .AND. OCCURS("/", tcFecha) <> 2, .F., llEsFecha)
    IF llEsFecha THEN
      llFormatoDMA = (SUBSTR(tcFecha, 3, 1) $ "-/" .AND. SUBSTR(tcFecha, 6, 1) $ "-/") .OR. UPPER(This.cFormatoFechas) == "DMY"
      llFormatoAMD = (SUBSTR(tcFecha, 5, 1) $ "-/" .AND. SUBSTR(tcFecha, 8, 1) $ "-/") .OR. UPPER(This.cFormatoFechas) == "YMD"
      llFormatoMDA = UPPER(This.cFormatoFechas) == "MDY" .OR. UPPER(This.cFormatoFechas) == "AMERICAN"
      DO CASE
        CASE llFormatoDMA
          lnDia = VAL(LEFT(tcFecha, 2))
          lnMes = VAL(SUBSTR(tcFecha, 4, 2))
          lnAno = VAL(RIGHT(tcFecha, 4))
        CASE llFormatoAMD
          lnDia = VAL(RIGHT(tcFecha, 2))
          lnMes = VAL(SUBSTR(tcFecha, 6, 2))
          lnAno = VAL(LEFT(tcFecha, 4))
        CASE llFormatoMDA
          lnDia = VAL(SUBSTR(tcFecha, 4, 2))
          lnMes = VAL(LEFT(tcFecha, 2))
          lnAno = VAL(RIGHT(tcFecha, 4))
        OTHERWISE
          llEsFecha = .F.
      ENDCASE
      llEsFecha = llEsFecha .AND. !EMPTY(DATE(lnAno, lnMes, lnDia))
    ENDIF
    RETURN (llEsFecha)
  ENDFUNC
  *
  *=== Verifica si el string es una fechaThora
  PROTECTED FUNCTION ES_FECHA_HORA
  LPARAMETERS tcFechaHora
  LOCAL lcFecha, lcHora, lcCaracteresValidos, llEsFechaHora
    tcFechaHora   = SUBSTR(tcFechaHora, 2, LEN(tcFechaHora) - 2)
    lcFecha       = LEFT(tcFechaHora, 10)
    lcHora        = SUBSTR(tcFechaHora, 12)
    llEsFechaHora = This.ES_FECHA('"' + lcFecha + '"')
    IF llEsFechaHora THEN
      lcCaracteresValidos = "0123456789:"
      llEsFechaHora       = llEsFechaHora .AND. EMPTY(CHRTRAN(lcHora, lcCaracteresValidos, ""))
      llEsFechaHora       = llEsFechaHora .AND. (LEN(lcHora) == 5 .OR. LEN(lcHora) == 8)
      llEsFechaHora       = llEsFechaHora .AND. ((LEN(lcHora) = 5 .AND. OCCURS(":", lcHora) = 1) .OR. (LEN(lcHora) = 8 .AND. OCCURS(":", lcHora) = 2))
      llEsFechaHora       = llEsFechaHora .AND. SUBSTR(lcHora, 3, 1) == ":"
      llEsFechaHora       = llEsFechaHora .AND. (LEN(lcHora) = 5 .OR. SUBSTR(lcHora, 6, 1) == ":")
    ENDIF
    RETURN (llEsFechaHora)
  ENDFUNC
  *
  *=== Convierte una fecha que llega como un string a una fecha válida
  PROTECTED FUNCTION FECHA_VALIDA
  LPARAMETERS tcFecha
  LOCAL lnDia, lnMes, lnAno, ldFecha
    DO CASE
      CASE This.cFormatoFechas == "DMY" .OR. This.cFormatoFechas == "99/99/9999" .OR. This.cFormatoFechas == "99-99-9999"
        lnDia   = VAL(LEFT(tcFecha, 2))
        lnMes   = VAL(SUBSTR(tcFecha, 4, 2))
        lnAno   = VAL(RIGHT(tcFecha, 4))
        ldFecha = DATE(lnAno, lnMes, lnDia)
      CASE This.cFormatoFechas == "MDY" .OR. UPPER(This.cFormatoFechas) == "AMERICAN"
        lnDia   = VAL(SUBSTR(tcFecha, 4, 2))
        lnMes   = VAL(LEFT(tcFecha, 2))
        lnAno   = VAL(RIGHT(tcFecha, 4))
        ldFecha = DATE(lnAno, lnMes, lnDia)
      CASE This.cFormatoFechas == "YMD" .OR. This.cFormatoFechas == "9999/99/99" .OR. This.cFormatoFechas == "9999-99-99"
        lnDia   = VAL(RIGHT(tcFecha, 2))
        lnMes   = VAL(SUBSTR(tcFecha, 6, 2))
        lnAno   = VAL(LEFT(tcFecha, 4))
        ldFecha = DATE(lnAno, lnMes, lnDia)      
      OTHERWISE
        ldFecha = {}
    ENDCASE
    RETURN (ldFecha)
  ENDFUNC
  *
  *=== Convierte una fechahora que llega como un string a una fechahora válida
  PROTECTED FUNCTION FECHA_HORA_VALIDA
  LPARAMETERS tcFechaHora
  LOCAL lcFecha, lcHora, ltFechaHora
    lcFecha     = LEFT(tcFechaHora, 10)
    lcFecha     = DTOC(This.FECHA_VALIDA(lcFecha))
    lcHora      = SUBSTR(tcFechaHora, 12)
    ltFechaHora = CTOT(lcFecha + " " + lcHora)
    RETURN (ltFechaHora)
  ENDFUNC
  *
  *=== Devuelve el valor de la cabecera que se especifique
  FUNCTION GET_CABECERA
  LPARAMETERS tcNombrePropiedad
  LOCAL luRetorno
    
    tcNombrePropiedad = IIF(VARTYPE(tcNombrePropiedad) <> "C", "", tcNombrePropiedad)
    tcNombrePropiedad = UPPER(tcNombrePropiedad)
    
    DO CASE
      CASE tcNombrePropiedad == "MENSAJEERROR"
        luRetorno = This.cMensajeError
      CASE tcNombrePropiedad == "TEXTOJSON"
        luRetorno = This.cTextoJSON
      OTHERWISE
        luRetorno = "***ERROR*** Nombre de propiedad desconocido"
    ENDCASE
    
    RETURN (luRetorno)
    
  ENDFUNC
  *
  *=== Obtiene el tipo de campo
  PROTECTED FUNCTION OBTENER_TIPO_CAMPO
  LPARAMETERS tcCampo
  LOCAL lcTipoCampo
    DO CASE
      CASE This.ES_FECHA_HORA(tcCampo)
        lcTipoCampo = "T"
      CASE This.ES_FECHA(tcCampo)
        lcTipoCampo = "D"
      CASE '"' $ tcCampo
        lcTipoCampo = "C"
      CASE UPPER(tcCampo) == "FALSE" .OR. UPPER(tcCampo) == "TRUE"
        lcTipoCampo = "L"
      CASE EMPTY(CHRTRAN(tcCampo, "0123456789.", ""))
        lcTipoCampo = "N"
      OTHERWISE
        lcTipoCampo = "U"
    ENDCASE
    RETURN (lcTipoCampo)
  ENDFUNC
  *
  *=== Agrega comillas al inicio y al final de un string
  PROTECTED FUNCTION PONER_COMILLAS
  LPARAMETERS tcTexto
    RETURN('"' + TRANSFORM(tcTexto) + '"')
  ENDFUNC
  *
  *=== Agrega a un array texto que luego será usado para generar un string con formato JSON
  FUNCTION SET_AGREGAR_PROPIEDAD
  LPARAMETERS tcObjetoPadre, tcTipoPropiedad, tcPropiedad, tuValor, tcIndicaciones
  LOCAL lcMensajeError
    *--- Si ya se había detectado algún error, finaliza esta función.
    IF !EMPTY(This.cMensajeError) THEN
      RETURN (.F.)
    ENDIF
    *--- Se validan todos los parámetros de entrada
    tcIndicaciones = IIF(VARTYPE(tcIndicaciones) <> "C", "", tcIndicaciones)
    lcMensajeError = This.VALIDAR_ENTRADA(tcObjetoPadre, tcTipoPropiedad, tcPropiedad, tuValor, tcIndicaciones)
    *--- Si se encontró cualquier error, se termina la función. Un mensaje descriptivo se puede obtener llamando al método GET_MENSAJE_ERROR()
    IF !EMPTY(lcMensajeError) THEN
      RETURN (.F.)
    ENDIF
    *--- Si se llegó hasta aquí, significa que está todo OK y por lo tanto se puede agregar esta propiedad al array
    IF EMPTY(This.cTextoJSON) THEN
      This.cCierres   = IIF(This.cDelimitadorInicial == "{", "}", "]")
      This.cTextoJSON = This.cDelimitadorInicial + IIF(This.lEnSiguienteLinea, CHR(13) + CHR(10), "")
    ENDIF
    tcObjetoPadre  = IIF(EMPTY(tcObjetoPadre), "1", tcObjetoPadre)
    tcObjetoPadre  = This.CONVERTIR_VFP_A_JSON(tcObjetoPadre)
    tcPropiedad    = ICASE(tcTipoPropiedad == "A" .AND. EMPTY(tcPropiedad), "***ARRAY***", ;
                           tcTipoPropiedad == "E", "***elemento***", ;
                           tcTipoPropiedad == "O" .AND. EMPTY(tcPropiedad), "***OBJETO***", ;
                           tcPropiedad)
    lcTipoValor    = VARTYPE(tuValor)
    tuValor        = IIF(lcTipoValor <> "N", TRANSFORM(tuValor), IIF(This.lRespetarDecimales, TRANSFORM(tuValor, "@B"), TRANSFORM(tuValor)))
    tuValor        = IIF(tcTipoPropiedad == "A", "***ARRAY***", tuValor)
    tuValor        = IIF(lcTipoValor == "C", This.CONVERTIR_VFP_A_JSON(tuValor), tuValor)
    tcIndicaciones = TRANSFORM(IIF(PCOUNT() < 5, "", tcIndicaciones))
    WITH This
      .nCantidadPropiedades = .nCantidadPropiedades + 1
      DIMENSION .APROPIEDADES[.nCantidadPropiedades]
      .APROPIEDADES[.nCantidadPropiedades] = tcObjetoPadre   + .cSeparadorParametros ;
                                           + tcTipoPropiedad + .cSeparadorParametros ;
                                           + tcPropiedad     + .cSeparadorParametros ;
                                           + tuValor         + .cSeparadorParametros ;
                                           + lcTipoValor     + .cSeparadorParametros ;
                                           + tcIndicaciones
    ENDWITH
    RETURN (.T.)
  ENDPROC
  *
  *=== Permite cambiar los valores de algunas propiedades de esta clase
  FUNCTION SET_CABECERA
  LPARAMETERS tcPropiedadDeEstaClase, tuValor
  LOCAL llPropiedadCambiada
    *--- Por consitencia, porque algunos valores de la cabecera se necesita conocer antes que las propiedades del JSON
    IF TRANSFORM(This.APROPIEDADES[1]) <> ".F." THEN
      This.cMensajeError = "Los valores de la cabecera deben ser puestos ANTES que las propiedades del JSON"
      RETURN (.F.)
    ENDIF
    *--- Las propiedades que cambian la estética del string JSON que será generado
    This.nNumeroLineaCabecera = This.nNumeroLineaCabecera + 1
    llPropiedadCambiada = .F.
    TRY
      *--- Los nombres de los campos que tienen 2 ó más palabras normalmente deben ser convertidos a camelCase para que sean aceptados por los servidores remotos
      IF UPPER(tcPropiedadDeEstaClase) == "CAMELCASE" THEN
        This.cCamelCase     = TRANSFORM(tuValor)
        llPropiedadCambiada = .T.
      ENDIF
      *--- La cantidad de decimales que tendrán TODOS los campos numéricos. 
      IF UPPER(tcPropiedadDeEstaClase) == "CANTIDADDECIMALES" THEN
        This.nCantidadDecimales = VAL(TRANSFORM(tuValor))
        llPropiedadCambiada     = .T.
      ENDIF
      *--- El delimitador inicial de un texto con formato JSON debe ser "{" (por defecto) o debe ser "["
      IF UPPER(tcPropiedadDeEstaClase) == "DELIMITADORINICIAL" THEN
        tuValor                  = TRANSFORM(tuValor)
        This.cDelimitadorInicial = IIF(tuValor == "[", tuValor, "{")
        llPropiedadCambiada      = .T.
      ENDIF
      *--- La cantidad de espacios en blanco que deben ser puestos a la izquierda de las líneas del string con formato JSON devuelto. Por defecto es 2
      IF UPPER(tcPropiedadDeEstaClase) == "ESPACIOS" THEN
        This.nCantidadEspacios = VAL(TRANSFORM(tuValor))
        llPropiedadCambiada    = .T.
      ENDIF
      *--- El formato que tienen las fechas recibidas en un string JSON
      IF UPPER(tcPropiedadDeEstaClase) == "FORMATOFECHAS" THEN
        This.cFormatoFechas = tuValor
        llPropiedadCambiada = .T.
      ENDIF
      *--- Se puede llamar a una función externa para que le coloque los nombres a los arrays que corresponden a los registros de una tabla/cursor
      IF UPPER(tcPropiedadDeEstaClase) == "NOMBRESARRAYS" THEN
        tuValor = ALLTRIM(tuValor)
        tuValor = tuValor + IIF(RIGHT(tuValor, 2) <> "()", "()", "")     && Si se escribió el nombre de una función sin sus paréntesis, se le agregan
        This.cFuncionExterna = tuValor
        llPropiedadCambiada  = .T.
      ENDIF
      *--- Si quiere que los números en el string JSON tengan los mismos decimales que los números enviados. No se redondeará
      IF UPPER(tcPropiedadDeEstaClase) == "RESPETARDECIMALES" THEN
        This.lRespetarDecimales = .T.
        llPropiedadCambiada     = .T.
      ENDIF
      *--- En un array, los componentes de sus elementos deben ser separados por caracteres que jamás puedan encontrarse en el nombre o en el valor de una propiedad
      IF UPPER(tcPropiedadDeEstaClase) == "SEPARADORPARAMETROS" THEN
        This.cSeparadorParametros = TRANSFORM(tuValor)
        llPropiedadCambiada       = .T.
      ENDIF
      *--- Las propiedades pueden colocarse debajo de la propiedad anterior (por defecto) o a la derecha de ls propiedad anterior
      IF UPPER(tcPropiedadDeEstaClase) == "UNAPROPIEDADPORLINEA" THEN
        This.lEnSiguienteLinea = tuValor
        llPropiedadCambiada    = .T.
      ENDIF
      *--- Se quiere mostrar un mensaje al usuario porque el proceso puede demorarse mucho tiempo
      IF UPPER(tcPropiedadDeEstaClase) == "WAITWINDOW" THEN
        This.lWaitWindow    = tuValor
        llPropiedadCambiada = .T.
      ENDIF
      *--- El mensaje de espera que se le mostrará al usuario
      IF UPPER(tcPropiedadDeEstaClase) == "WAITWINDOWMENSAJE" THEN
        This.cWaitWindowMensaje = tuValor
        llPropiedadCambiada     = .T.
      ENDIF
    CATCH
      This.cMensajeError = "En la cabecera, línea N° " + TRANSFORM(This.nNumeroLineaCabecera) + ": es incorrecto el nombre de la propiedad o el valor de esa propiedad"
    ENDTRY
    RETURN (llPropiedadCambiada)
  ENDFUNC
  *
  *=== Valida que los datos recibidos son aceptables
  PROTECTED FUNCTION VALIDAR_ENTRADA
  LPARAMETERS tcObjetoPadre, tcTipoPropiedad, tcPropiedad, tuValor, tcIndicaciones
  LOCAL lcMensaje, lcTipPro, lcUltDel
    *--- Se aumenta en 1 el número de línea actual para devolver ese número cuando hay un error
    This.nNumeroLineaActual = This.nNumeroLineaActual + 1
    *--- Se valida que todos los parámetros recibidos sean correctos
    lcMensaje = ""
    lcMensaje = IIF(EMPTY(lcMensaje) .AND. VARTYPE(tcObjetoPadre)   <> "C"                             , "El nombre del objeto padre debe ser de tipo Carácter", lcMensaje)
    lcMensaje = IIF(EMPTY(lcMensaje) .AND. VARTYPE(tcTipoPropiedad) <> "C"                             , "El tipo de la propiedad debe ser de tipo Carácter"   , lcMensaje)
    lcMensaje = IIF(EMPTY(lcMensaje) .AND. VARTYPE(tcPropiedad)     <> "C" .AND. tcTipoPropiedad == "L", "El nombre de la propiedad debe ser de tipo Carácter" , lcMensaje)
    lcMensaje = IIF(EMPTY(lcMensaje) .AND. PCOUNT() = 5 .AND. VARTYPE(tcIndicaciones) <> "C"           , "El quinto parámetro debe ser de tipo carácter"       , lcMensaje)
    *--- Si hasta aquí está todo correcto se sigue validando porque hay más errores posibles
    IF EMPTY(lcMensaje) THEN
      lcTipPro  = UPPER(tcTipoPropiedad)
      lcMensaje = IIF(EMPTY(lcMensaje) .AND. LEN(lcTipPro) <> 1, "El tipo de la propiedad debe constar de 1 solo carácter", lcMensaje)
      lcMensaje = IIF(EMPTY(lcMensaje) .AND. !lcTipPro$ "AELO" , "El tipo de la propiedad debe estar en 'AELO'"           , lcMensaje)
      IF EMPTY(lcMensaje) THEN
        lcUltDel  = RIGHT(This.cUltimosDelimitadores, 1)
        IF EMPTY(This.cUltimosDelimitadores) THEN
          This.cUltimosDelimitadores = This.cDelimitadorInicial
        ELSE
          This.cUltimosDelimitadores = This.cUltimosDelimitadores + ICASE(tcTipoPropiedad == "A", "[", tcTipoPropiedad == "O", "{", "")
        ENDIF
        lcMensaje = IIF(tcTipoPropiedad == "L" .AND. EMPTY(tcPropiedad)                      , "Falta el nombre de la propiedad (2)", lcMensaje)
        lcMensaje = IIF(This.cDelimitadorInicial == "{" .AND. EMPTY(lcUltDel) .AND. tcTipoPropiedad == "O" .AND. EMPTY(tcPropiedad), "Falta el nombre de la propiedad (3)", lcMensaje)
        lcMensaje = IIF(This.cDelimitadorInicial == "[" .AND. EMPTY(lcUltDel) .AND. tcTipoPropiedad == "O" .AND. !EMPTY(tcPropiedad), "La propiedad no debe tener nombre", lcMensaje)
      ENDIF
    ENDIF 
    *--- Si se encontró algún error, 
    IF !EMPTY(lcMensaje) THEN
      lcMensaje          = "ERROR en la línea N° " + TRANSFORM(This.nNumeroLineaActual) + ". " + lcMensaje
      This.cMensajeError = lcMensaje
    ENDIF
    RETURN (lcMensaje)
  ENDFUNC
  *
ENDDEFINE
*
*
