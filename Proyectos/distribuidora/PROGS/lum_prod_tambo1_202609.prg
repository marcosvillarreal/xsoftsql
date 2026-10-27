*-- =====================================================================
*-- El Calden - LUM en PRODUCCION (WSLUM via PyAfipWs COM)
*-- Visual FoxPro 9.0 - generado 26/10/2026
*-- (2026-10-26) Copia de prueba_lum_homo_tambo1_202609.prg adaptada a PRODUCCION:
*--   certificado ElCalden.crt / Gestion.key, CUIT 30642478296, URLs de produccion de WSAA y WSLUM,
*--   catalogo a lum_catalogos_prod.txt, PDF a liq_lum_prod.pdf, confirmacion antes de emitir.
*--
*-- !!! ATENCION: con llSoloCatalogos = .F. EMITE UNA LUM REAL CON CAE REAL !!!
*--   No se anula: solo se corrige con una LUM de ajuste (AgregarAjuste).
*-- !!! (2026-10-26) ESTA LUM YA ESTA EMITIDA: PV 4 Nro 251 (tambo 1, 2026/09, REBOL OSCAR OMAR,
*--   CAE consultable con ConsultarLiquidacion). Emitirla de nuevo por el PV 8 la DUPLICA.
*--   Usar este .prg como modelo para la PROXIMA LUM real (periodo 2026/10), no para 2026/09. !!!
*--
*-- Datos REALES: Liquidacion MENSUAL grabada en GMSmart
*--   liqlacteo origen='L' tipo='M' periodo='202609' idtambo=1 (TAMBO 1, REBOL OSCAR OMAR)
*--   + dbo.tambo + dbo.ctacte + dbo.empresa (base elcalden, 23/10/2026).
*--
*-- Pasos:
*--   1) llSoloCatalogos = .T. (como viene): login, dummy y catalogos a lum_catalogos_prod.txt.
*--      No emite nada. Sirve para verificar certificado, relacion y COM desde VFP.
*--   2) Resolver los pendientes marcados con  *** CONFIRMAR ***  y poner llPendientesOK = .T.
*--   3) llSoloCatalogos = .F. y correr: pide confirmacion y emite la LUM.
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
llSoloCatalogos = .F.          && .T. = solo login + catalogos (no emite); .F. = emitir la LUM REAL
llPendientesOK  = .t.          && poner .T. recien cuando esten resueltos los *** CONFIRMAR ***

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

stop()
*-- =====================================================================
*-- 4) CABECERA  ->  <liquidacion>
*-- =====================================================================
LOCAL tipo_cbte, pto_vta, nro_cbte, fecha_cbte, periodo
tipo_cbte  = 27                && LUM Clase A (productor Responsable Inscripto)
pto_vta    = 8                 && unico PV habilitado para WSLUM (ConsultarPuntosVentas, 26/10/2026)
fecha_cbte = "2026-09-30"      && ultimo dia del mes liquidado  *** CONFIRMAR fecha de emision ***
periodo    = "2026/09"         && liqlacteo.periodo 202609

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
*-- 7) BALANCE DE LITROS Y SOLIDOS  (liqlacteo M 202609 tambo 1)
*-- =====================================================================
LOCAL litros, decomisados, kg_grasa, kg_proteina
litros      = 21081        && liqlacteo.litros (facturados, entero)
decomisados = 0
kg_grasa    = 828.48       && liqlacteo.kggrasa   (grasa 3.93 %)
kg_proteina = 756.81       && liqlacteo.kgproteina (proteina 3.59 %)

ok = WSLUM.AgregarBalanceLitrosPorcentajesSolidos(litros, decomisados, kg_grasa, kg_proteina)


*-- =====================================================================
*-- 8) CONCEPTOS BASICOS - todo como basico en la grasa (como las LUM de junio)
*--    precio x kg = TOTAL LIQUIDACION / kg grasa, TRUNCADO a 2 decimales
*--    (2026-10-26) criterio CONFIRMADO por la LUM real PV 4 Nro 251: 828.48 kg x 13616.33 = 11280857.08.
*--    En las LUM reales los kg de proteina van con sus kg reales y precio 0 (ej. 756.81 x 0.0), pero
*--    por WS en homologacion eso dio 2106 -> aca se mandan 0 kg. Si ARCA prod lo acepta, usar kg reales.
*-- =====================================================================
LOCAL total_gms, precio_kg_gb, total_lum
total_gms    = 11280864.72                                && liqlacteo.subtotal (suma de las quincenales)
precio_kg_gb = INT(total_gms / kg_grasa * 100) / 100      && = 13616.33
total_lum    = ROUND(kg_grasa * precio_kg_gb, 2)          && = 11280857.08 (lo que va a calcular ARCA)
? "Precio x kg:", precio_kg_gb, " Total LUM:", total_lum, " Dif. con GMSmart:", total_lum - total_gms

*-- Proteina a $0: los kg van en 0 aca (ARCA 2106 si kg <> 0 con precio 0); el balance del paso 7 lleva los reales.
ok = WSLUM.AgregarConceptosBasicosMercadoInterno( ;
        kg_grasa, precio_kg_gb, 0, 0.00)                  && proteina: 0 kg a $0


*-- =====================================================================
*-- 9) OTROS IMPUESTOS - percepciones sobre el total de la LUM
*-- =====================================================================
LOCAL tipo_perc_iva, tipo_perc_iibb, base_imp
tipo_perc_iva  = 6     && Percepcion de IVA  (catalogo OTROS IMPUESTOS, igual en homo y prod)
tipo_perc_iibb = 7     && Percepcion de IIBB
*-- (2026-10-26) antes: total_lum (con centavos). Las LUM reales (PV 4, 240..258) informan la base de
*--   percepciones TRUNCADA a entero (ej. Nro 251: total 11280857.08 -> base 11280857).
base_imp       = INT(total_lum)

ok = WSLUM.AgregarOtroImpuesto(tipo_perc_iva,  base_imp, 1.00, "Percepcion de IVA")    && liqlacteo.pctretiva
ok = WSLUM.AgregarOtroImpuesto(tipo_perc_iibb, base_imp, 0.50, "Percepcion de IIBB")   && liqlacteo.pctiibb


*-- =====================================================================
*-- 10) ENVIO  (CAE REAL)
*-- =====================================================================
IF MESSAGEBOX("Se va a emitir una LUM REAL en PRODUCCION:" + CHR(13) + CHR(13) + ;
              "Tipo 27 - PV " + TRANSFORM(pto_vta) + " - Nro " + TRANSFORM(nro_cbte) + CHR(13) + ;
              "Periodo " + periodo + " - Tambo 1 (REBOL OSCAR OMAR)" + CHR(13) + ;
              "Total LUM: " + TRANSFORM(total_lum, "999,999,999.99") + CHR(13) + CHR(13) + ;
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

*-- Control contra GMSmart (liqlacteo M 202609 tambo 1):
*--   subtotal 11280864.72 / iva 2368981.59 / perc. IVA 112808.64 / perc. IIBB 56404.32 / neto 13480633.35
? "CAE ...................:", WSLUM.CAE
? "Nro. comprobante ......:", WSLUM.NroComprobante
? "Fecha .................:", WSLUM.FechaComprobante
? "Total liquidacion .....:", WSLUM.Total,          "  GMSmart:", total_gms
? "Otros impuestos .......:", WSLUM.TotalOtrosImpuestos, "  GMSmart: 169212.96"
? "Importe IVA ...........:", WSLUM.ImporteIVA,     "  GMSmart: 2368981.59"
? "Total neto ............:", WSLUM.TotalNeto,      "  GMSmart: 13480633.35"

ok = WSLUM.ConsultarLiquidacion(.NULL., .NULL., .NULL., WSLUM.CAE, .NULL., lcRuta + "liq_lum_prod.pdf")
IF ok AND FILE(lcRuta + "liq_lum_prod.pdf")
    WSLUM.MostrarPDF(lcRuta + "liq_lum_prod.pdf", .F.)
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
