*-- =====================================================================
*-- El Calden - LUM de PRUEBA en PRODUCCION, importe chico (WSLUM via PyAfipWs COM)
*-- Visual FoxPro 9.0 - generado 26/10/2026
*-- (2026-10-26) Copia de lum_prod_tambo1_202609.prg. Prueba aprobada por el contador:
*--   LUM NORMAL periodo 2026/10, tambo 1 REBOL OSCAR OMAR (20126112824), 7 kg grasa + 6.39 kg proteina
*--   x 7118.32 (opcion A, mismo precio) = 95314.30 (< $100.000) + IVA 20016.00 + perc. IVA 953.14
*--   + perc. IIBB 476.57 = neto 116760.01.
*--
*-- !!! ATENCION: con llSoloCatalogos = .F. EMITE UNA LUM REAL CON CAE REAL !!!
*--   No se anula: solo se corrige con una LUM de ajuste (AgregarAjuste).
*-- !!! OJO: ocupa el periodo 2026/10 del tambo 1. La LUM REAL de octubre de este tambo puede chocar
*--   con esta (ARCA podria rechazarla por duplicada) o habra que emitirla como ajuste. !!!
*--
*-- Datos: los fijos del tambo 1 (tambero, tambo, ubicacion) son REALES, iguales a la LUM real
*--   PV 4 Nro 251. Litros y kg son de PRUEBA (proporcionales a septiembre: grasa 3.93 %, proteina 3.59 %).
*--
*-- Pasos:
*--   1) llSoloCatalogos = .T. (como viene): login, dummy y catalogos a lum_catalogos_prod.txt.
*--      No emite nada. Sirve para verificar certificado, relacion y COM desde VFP.
*--   2) llSoloCatalogos = .F. y correr: muestra los importes, pide confirmacion y emite la LUM.
*--   Siempre deja lum_request.xml / lum_response.xml para revisar lo que viajo.
*--
*-- Requisitos: wsaa.exe y wslum.exe 3.03c FINAL registrados como COM (Instalador_WSLUM_3.03c.exe).
*--   El exe de homologacion NO sirve: ignora la URL y va siempre a homologacion (wscommon_007).
*--   A WSLUM.Conectar hay que pasarle SIEMPRE la URL de produccion (vacio = homologacion).
*--   Relacion "wslum" de 30642478296 delegada al computador GMSolutions (hecha 26/10/2026).
*-- Verificado 26/10/2026 desde el COM: PV habilitado = 8, ultima LUM A en PV 8 = 0 (esta seria la 1).
*-- Solo ASCII a proposito (sin tildes).
*-- =====================================================================

CLEAR
ON ERROR

LOCAL llSoloCatalogos, llPendientesOK
*-- (2026-10-26) antes: .T. Queda en .F. a pedido del usuario (catalogos ya probados desde VFP);
*--   sigue protegido por el tope de $100.000 y la confirmacion Si/No antes de enviar.
llSoloCatalogos = .F.          && .T. = solo login + catalogos (no emite); .F. = emitir la LUM REAL
llPendientesOK  = .T.          && prueba aprobada por el contador (26/10/2026)

LOCAL lcRuta, lcCuitAuth, lcWSAA, lcWSDL, lcCrt, lcKey, lcLog
lcRuta     = ADDBS(JUSTPATH(SYS(16, 1)))
lcCuitAuth = "30642478296"     && El Calden (CUIT del certificado ElCalden.crt, alias GMSolutions)
lcWSAA     = "https://wsaa.afip.gov.ar/ws/services/LoginCms?wsdl"
lcWSDL     = "https://serviciosjava.afip.gob.ar/wslum/LumService?wsdl"
lcCrt      = "E:\GitHub\xsoftai\Proyectos\SistemasAgiles\pyafipws\conf\ElCalden.crt"
lcKey      = "E:\GitHub\xsoftai\Proyectos\SistemasAgiles\pyafipws\conf\Gestion.key"
lcLog      = lcRuta + "lum_catalogos_prod.txt"


*-- =====================================================================
*-- 1) WSAA
*-- =====================================================================
LOCAL WSAA, tra, cms, ta, ok
WSAA = CREATEOBJECT("WSAA")
WSAA.LanzarExcepciones = .F.
ok  = WSAA.Conectar("", lcWSAA)                && PRODUCCION ("" seria homologacion)
tra = WSAA.CreateTRA("wslum")
cms = WSAA.SignTRA(tra, lcCrt, lcKey)
ta  = WSAA.LoginCMS(cms)
IF LEN(WSAA.Excepcion) > 0
    ? WSAA.Excepcion
    ? WSAA.Traceback
    MESSAGEBOX("WSAA: no se pudo obtener token y sign" + CHR(13) + WSAA.Excepcion, 16, "LUM")
    RETURN .F.
ENDIF


*-- =====================================================================
*-- 2) WSLUM
*-- =====================================================================
LOCAL WSLUM
WSLUM = CREATEOBJECT("WSLUM")
WSLUM.LanzarExcepciones = .F.
IF "Homologaci" $ WSLUM.Version
    MESSAGEBOX("El WSLUM registrado es el de HOMOLOGACION (" + WSLUM.Version + ")." + CHR(13) + ;
               "Instalar Instalador_WSLUM_3.03c.exe (build final).", 16, "LUM")
    RETURN .F.
ENDIF
WSLUM.Token = WSAA.Token
WSLUM.Sign  = WSAA.Sign
WSLUM.Cuit  = lcCuitAuth
ok = WSLUM.Conectar("", lcWSDL)
IF !ok
    ? WSLUM.Excepcion
    MESSAGEBOX("No se pudo conectar a WSLUM", 16, "LUM")
    RETURN .F.
ENDIF
WSLUM.Dummy()
? "WSLUM", WSLUM.Version, " AppServer:", WSLUM.AppServerStatus, " DbServer:", WSLUM.DbServerStatus, ;
  " AuthServer:", WSLUM.AuthServerStatus


*-- =====================================================================
*-- 3) CATALOGOS (a lum_catalogos_prod.txt)  ->  "|| codigo || descripcion ||"
*-- =====================================================================
IF llSoloCatalogos
    *-- El array que devuelve el COM se asigna a una variable y se pasa por referencia (@)
    LOCAL laLista
    STRTOFILE("CATALOGOS WSLUM PRODUCCION - " + TTOC(DATETIME()) + CHR(13) + CHR(10), lcLog, 0)
    laLista = WSLUM.ConsultarPuntosVentas("||")
    =VolcarCatalogo(WSLUM, "PUNTOS DE VENTA", @laLista, lcLog)
    ok = WSLUM.ConsultarUltimoComprobante(27, 8)
    STRTOFILE(CHR(13) + CHR(10) + "=== ULTIMA LUM A (27) PV 8: " + TRANSFORM(WSLUM.NroComprobante) + ;
              " " + WSLUM.ErrMsg + CHR(13) + CHR(10), lcLog, 1)
    laLista = WSLUM.ConsultarProvincias("||")
    =VolcarCatalogo(WSLUM, "PROVINCIAS", @laLista, lcLog)
    laLista = WSLUM.ConsultarLocalidades(21, "||")
    =VolcarCatalogo(WSLUM, "LOCALIDADES LA PAMPA (21)", @laLista, lcLog)
    laLista = WSLUM.ConsultarLocalidades(22, "||")
    =VolcarCatalogo(WSLUM, "LOCALIDADES RIO NEGRO (22)", @laLista, lcLog)
    laLista = WSLUM.ConsultarOtrosImpuestos("||")
    =VolcarCatalogo(WSLUM, "OTROS IMPUESTOS", @laLista, lcLog)
    laLista = WSLUM.ConsultarBonificacionesPenalizaciones("||")
    =VolcarCatalogo(WSLUM, "BONIFICACIONES / PENALIZACIONES", @laLista, lcLog)
    MODIFY FILE (lcLog) NOWAIT
    RETURN .T.
ENDIF

IF !llPendientesOK
    MESSAGEBOX("Hay datos marcados *** CONFIRMAR *** sin resolver." + CHR(13) + ;
               "Resolverlos y poner llPendientesOK = .T. antes de emitir.", 48, "LUM")
    RETURN .F.
ENDIF


*-- =====================================================================
*-- 4) CABECERA  ->  <liquidacion>
*-- =====================================================================
LOCAL tipo_cbte, pto_vta, nro_cbte, fecha_cbte, periodo
tipo_cbte  = 27                && LUM Clase A (productor Responsable Inscripto)
pto_vta    = 8                 && unico PV habilitado para WSLUM (ConsultarPuntosVentas, 26/10/2026)
*-- En las LUM reales fecha = ultimo dia del periodo, pero el 31/10 todavia es futuro: va la de hoy.
*--   Si ARCA rechaza la fecha o el periodo (mes en curso), probar periodo 2026/10 con otra fecha segun el error.
fecha_cbte = DTOC(DATE(), 1)
fecha_cbte = LEFT(fecha_cbte, 4) + "-" + SUBSTR(fecha_cbte, 5, 2) + "-" + RIGHT(fecha_cbte, 2)
periodo    = "2026/10"

ok = WSLUM.ConsultarUltimoComprobante(tipo_cbte, pto_vta)
IF ok AND EMPTY(WSLUM.ErrMsg)
    *-- (2026-10-26) antes: VAL(TRANSFORM(WSLUM.NroComprobante)) + 1 -> viajaba "1.0" y ARCA lo
    *--   rechazo (cvc-datatype-valid: 'nroComprobante' es integer). INT() lo deja sin decimales.
    nro_cbte = INT(VAL(TRANSFORM(WSLUM.NroComprobante))) + 1
ELSE
    ? WSLUM.ErrMsg
    MESSAGEBOX("No se pudo obtener el ultimo numero de comprobante" + CHR(13) + WSLUM.ErrMsg, 16, "LUM")
    RETURN .F.
ENDIF

LOCAL iibb_adquirente, domicilio_sede, inscripcion_registro_publico, datos_adicionales, alicuota_iva
iibb_adquirente              = "160401/0"      && empresa.ibruto (IIBB de El Calden)
domicilio_sede               = "ACCESO RUTA 1 0 - GENERAL MANUEL CAMPOS - LA PAMPA"   && del PDF de junio
inscripcion_registro_publico = .NULL.
datos_adicionales            = .NULL.          && (2026-10-26) antes: "PRUEBA HOMOLOGACION GMSMART ..."
alicuota_iva                 = 21.00           && liqlacteo.pctiva

ok = WSLUM.CrearLiquidacion(tipo_cbte, pto_vta, nro_cbte, fecha_cbte, periodo, ;
        iibb_adquirente, domicilio_sede, inscripcion_registro_publico, ;
        datos_adicionales, alicuota_iva)

*-- (2026-10-26) antes: AgregarCondicionVenta(3, "Cuenta Corriente"). Todas las LUM reales de El Calden
*--   (PV 4, 240..258) van con codigo 2 y SIN descripcion. El 2124 de homologacion con 0/1/2 era por
*--   mandar descripcion: solo se admite para el tipo "Otra" (seguramente el 3).
ok = WSLUM.AgregarCondicionVenta(2, .NULL.)


*-- =====================================================================
*-- 5) TAMBERO  (ctacte del titular de tambo 1)
*-- =====================================================================
*-- CUIT como string: un numerico VFP viaja como decimal ("20126112824.0") y el WSDL (xsd:long) no lo acepta.
*-- (2026-10-26) CUIT confirmado: la LUM real PV 4 Nro 251 tiene tambero 20126112824 REBOL OSCAR OMAR.
ok = WSLUM.AgregarTambero("20126112824", "186915/2")   && REBOL OSCAR OMAR / tambo.iibb


*-- =====================================================================
*-- 6) TAMBO + UBICACION  (dbo.tambo id 1)
*-- =====================================================================
ok = WSLUM.AgregarTambo(1, "10.010.0.01001/01", ;    && numero / RENSPA
        "2027-02-18", "2027-02-18", ;                && venc. tuberculosis / brucelosis
        .NULL.)                                      && nro tambo provincial (no tiene)

LOCAL latitud, longitud, domicilio, cod_localidad, cod_provincia, codigo_postal, partido
latitud       = -37.434692               && tambo.lat
longitud      = -63.593956               && tambo.lng
domicilio     = "BELGRANO 526"           && tambo.domicilio (cargado por el usuario = domicilio del productor)
cod_localidad = 6519                     && GRAL MANUEL CAMPOS (catalogos_lum\prod\localidades_todas.csv)
cod_provincia = 21                       && LA PAMPA
codigo_postal = 6309                     && tambo.cpostal
*-- (2026-10-26) antes: "GENERAL MANUEL CAMPOS". Las LUM reales (ej. PV 4 Nro 258) usan localidad 6519
*--   con nombrePartidoDepto = "GUATRACHE".
partido       = "GUATRACHE"

ok = WSLUM.AgregarUbicacionTambo(latitud, longitud, domicilio, ;
        cod_localidad, cod_provincia, codigo_postal, partido)


*-- =====================================================================
*-- 7) BALANCE DE LITROS Y SOLIDOS  (valores de PRUEBA)
*-- =====================================================================
LOCAL litros, decomisados, kg_grasa, kg_proteina
litros      = 178          && PRUEBA: 7 kg / 3.93 % de grasa
decomisados = 0
kg_grasa    = 7.00         && PRUEBA
kg_proteina = 6.39         && PRUEBA: 178 l x 3.59 %

ok = WSLUM.AgregarBalanceLitrosPorcentajesSolidos(litros, decomisados, kg_grasa, kg_proteina)


*-- =====================================================================
*-- 8) CONCEPTOS BASICOS - OPCION A (aprobada 26/10/2026): un mismo precio por kg de solidos utiles
*--    precio x kg = TOTAL A LIQUIDAR / (kg grasa + kg proteina), TRUNCADO a 2 decimales,
*--    igual para grasa y proteina.
*-- (2026-10-26) antes: todo el importe en la grasa (precio_kg_gb = 13616.33) y la proteina a $0, como
*--   las LUM de PV 4 (hechas por la web de ARCA). Por WS no se puede: el manual WSLUM v1.4 exige
*--   2054 = kg de proteina de los conceptos iguales a los del balance, y 2106 = si kg <> 0 el precio
*--   no puede ser 0. Con proteina 0 kg dio 2054; con 6.39 kg x $0 dio 2106.
*-- =====================================================================
LOCAL total_obj, precio_kg, importe_gb, importe_pr, total_lum
total_obj  = 95314.31                                     && PRUEBA: lo mismo que 7 kg x 13616.33
precio_kg  = INT(total_obj / (kg_grasa + kg_proteina) * 100) / 100   && = 7118.32
importe_gb = ROUND(kg_grasa * precio_kg, 2)               && = 49828.24
importe_pr = ROUND(kg_proteina * precio_kg, 2)            && = 45486.06
*-- (2026-10-26) antes: importe_gb + importe_pr sin ROUND -> por COM viajo 95314.29999999999 y ARCA lo
*--   rechazo (cvc-fractionDigits-valid: baseImponible admite 2 decimales). ROUND(..., 2) despues de sumar.
total_lum  = ROUND(importe_gb + importe_pr, 2)            && = 95314.30 (1 centavo menos por el truncado)
? "Precio x kg (grasa y proteina):", precio_kg, " Grasa:", importe_gb, " Proteina:", importe_pr, ;
  " Total LUM:", total_lum, " Dif.:", total_lum - total_obj
IF total_lum >= 100000
    MESSAGEBOX("La prueba tiene que ser menor a $100.000 y da " + TRANSFORM(total_lum), 16, "LUM")
    RETURN .F.
ENDIF

ok = WSLUM.AgregarConceptosBasicosMercadoInterno( ;
        kg_grasa, precio_kg, kg_proteina, precio_kg)      && grasa y proteina al mismo precio


*-- =====================================================================
*-- 9) OTROS IMPUESTOS - percepciones sobre el total de la LUM
*-- =====================================================================
LOCAL tipo_perc_iva, tipo_perc_iibb, base_imp
tipo_perc_iva  = 6     && Percepcion de IVA  (catalogo OTROS IMPUESTOS, igual en homo y prod)
tipo_perc_iibb = 7     && Percepcion de IIBB
*-- (2026-10-26) antes: total_lum (con centavos). Las LUM reales (PV 4, 240..258) informan la base de
*--   percepciones TRUNCADA a entero (ej. Nro 251: total 11280857.08 -> base 11280857).
*-- (2026-10-26) PRUEBA: base CON DECIMALES (95314.31) para ver si ARCA la acepta asi o la trunca.
*--   El WSDL lo permite (baseImponible = ImporteBI: xsd:decimal, fractionDigits 2). Las LUM reales de
*--   PV 4 tienen la base entera, quizas editada a mano por el operador. Despues de emitir, mirar
*--   <baseImponible> en lum_response.xml / el PDF: si vuelve 95314.31 acepta decimales.
*--   Para volver al criterio de las LUM reales: base_imp = INT(total_lum)
base_imp       = ROUND(total_lum, 2)

ok = WSLUM.AgregarOtroImpuesto(tipo_perc_iva,  base_imp, 1.00, "Percepcion de IVA")    && liqlacteo.pctretiva
ok = WSLUM.AgregarOtroImpuesto(tipo_perc_iibb, base_imp, 0.50, "Percepcion de IIBB")   && liqlacteo.pctiibb

stop()
*-- =====================================================================
*-- 10) ENVIO  (CAE REAL)
*-- =====================================================================
IF MESSAGEBOX("Se va a emitir una LUM REAL en PRODUCCION:" + CHR(13) + CHR(13) + ;
              "Tipo 27 - PV " + TRANSFORM(pto_vta) + " - Nro " + TRANSFORM(nro_cbte) + CHR(13) + ;
              "Periodo " + periodo + " - Fecha " + fecha_cbte + " - Tambo 1 (REBOL OSCAR OMAR)" + CHR(13) + ;
              "Total LUM: " + TRANSFORM(total_lum, "999,999,999.99") + " (PRUEBA)" + CHR(13) + CHR(13) + ;
              "No se puede anular (solo LUM de ajuste). Emitir?", 4 + 32 + 256, "LUM PRODUCCION") <> 6
    ? "Cancelado por el usuario: no se envio nada."
    RETURN .F.
ENDIF



ok = WSLUM.AutorizarLiquidacion()

STRTOFILE(NVL(WSLUM.XmlRequest, ""),  lcRuta + "lum_request.xml")
STRTOFILE(NVL(WSLUM.XmlResponse, ""), lcRuta + "lum_response.xml")

IF LEN(WSLUM.Excepcion) > 0
    ? WSLUM.Excepcion
    ? WSLUM.Traceback
    MESSAGEBOX("Error al llamar al webservice" + CHR(13) + WSLUM.Excepcion + CHR(13) + ;
               "Antes de reintentar, consultar el ultimo comprobante: puede haberse emitido igual.", 16, "LUM")
    RETURN .F.
ENDIF
IF !EMPTY(WSLUM.ErrMsg)
    ? WSLUM.ErrMsg
    MESSAGEBOX("ARCA rechazo la liquidacion:" + CHR(13) + WSLUM.ErrMsg, 48, "LUM")
    RETURN .F.
ENDIF

*-- (2026-10-26) esperados recalculados con la opcion A (antes: 95314.31 / 20016.01 / 1429.71 / 116760.03)
*-- Esperado: total 95314.30 / IVA 20016.00 / perc. IVA 953.14 + perc. IIBB 476.57 = 1429.71 / neto 116760.01
*--   (con base 95314.31 o 95314 los importes de percepcion dan igual al redondear: lo que distingue
*--   es la <baseImponible> que devuelve ARCA)
LOCAL lcResp, lnP
lcResp = NVL(WSLUM.XmlResponse, "")
lnP = AT("<baseImponible>", lcResp)
? "Base imponible devuelta:", IIF(lnP > 0, STREXTRACT(lcResp, "<baseImponible>", "</baseImponible>"), "(no vino)"), ;
  "  enviada:", base_imp
? "CAE ...................:", WSLUM.CAE
? "Nro. comprobante ......:", WSLUM.NroComprobante
? "Fecha .................:", WSLUM.FechaComprobante
? "Total liquidacion .....:", WSLUM.Total,               "  esperado: 95314.30"
? "Otros impuestos .......:", WSLUM.TotalOtrosImpuestos, "  esperado: 1429.71"
? "Importe IVA ...........:", WSLUM.ImporteIVA,          "  esperado: 20016.00"
? "Total neto ............:", WSLUM.TotalNeto,           "  esperado: 116760.01"
STRTOFILE("LUM PRUEBA PV " + TRANSFORM(pto_vta) + " Nro " + TRANSFORM(WSLUM.NroComprobante) + ;
          " CAE " + TRANSFORM(WSLUM.CAE) + " " + TTOC(DATETIME()) + CHR(13) + CHR(10), lcRuta + "lum_prueba_cae.txt", 1)

*-- (2026-10-26) ConsultarLiquidacion por numero: exige el CUIT del comprador (El Calden).
ok = WSLUM.ConsultarLiquidacion(tipo_cbte, pto_vta, VAL(TRANSFORM(WSLUM.NroComprobante)), .NULL., ;
        lcCuitAuth, lcRuta + "liq_lum_prueba_202610.pdf")
IF ok AND FILE(lcRuta + "liq_lum_prueba_202610.pdf")
    WSLUM.MostrarPDF(lcRuta + "liq_lum_prueba_202610.pdf", .F.)
ENDIF

RETURN .T.


*-- ---------------------------------------------------------------------
*-- Escribe un catalogo en el log: una linea "codigo | descripcion" por item
*-- ---------------------------------------------------------------------
FUNCTION VolcarCatalogo(toWS, tcTitulo, taLista, tcLog)
    EXTERNAL ARRAY taLista
    LOCAL lcItem, laCampos[1], lnN
    STRTOFILE(CHR(13) + CHR(10) + "=== " + tcTitulo + CHR(13) + CHR(10), tcLog, 1)
    IF !EMPTY(toWS.ErrMsg) OR LEN(toWS.Excepcion) > 0
        STRTOFILE("ERROR: " + toWS.ErrMsg + " " + toWS.Excepcion + CHR(13) + CHR(10), tcLog, 1)
        RETURN .F.
    ENDIF
    lnN = 0
    FOR EACH lcItem IN taLista
        ALINES(laCampos, lcItem, 1, "||")
        IF ALEN(laCampos) >= 3
            STRTOFILE(laCampos[2] + " | " + laCampos[3] + CHR(13) + CHR(10), tcLog, 1)
        ELSE
            STRTOFILE(lcItem + CHR(13) + CHR(10), tcLog, 1)
        ENDIF
        lnN = lnN + 1
    ENDFOR
    STRTOFILE("(" + TRANSFORM(lnN) + " items)" + CHR(13) + CHR(10), tcLog, 1)
    RETURN .T.
ENDFUNC
