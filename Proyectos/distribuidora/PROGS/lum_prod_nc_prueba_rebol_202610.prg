*-- =====================================================================
*-- El Calden - NOTA DE CREDITO de la LUM de PRUEBA, en PRODUCCION (WSLUM via PyAfipWs COM)
*-- Visual FoxPro 9.0 - generado 26/10/2026
*-- (2026-10-26) Copia de lum_prod_prueba_rebol_202610.prg para CANCELAR la LUM de prueba:
*--   LUM original: tipo 27, PV 8, Nro 1, CAE 86439471180134, periodo 2026/10, emitida 26/10/2026,
*--   tambo 1 REBOL OSCAR OMAR (20126112824). Total 95314.30 / IVA 20016.00 / otros imp. 1429.71 /
*--   neto 113900.59.
*--
*-- Segun el manual WSLUM v1.4 (pyafipws\catalogos_lum\Manual_WSLUM_v1.4.pdf):
*--   - Tipo 48 = Nota de Credito - Liquidacion Unica - Comercial Impositiva Clase A.
*--   - Se informa <ajuste> con <tipoAjuste> y <caeAAjustar> (uno y solo uno: CAE o formulario papel).
*--   - Ajuste FISICO: lleva balance de litros (y conceptos). Ajuste MONETARIO: SIN balance ni conceptos,
*--     solo bonificaciones/debitos (error 1005/1006). Para cancelar TODA la LUM va FISICO con las
*--     mismas cantidades, precios y percepciones que la original.
*--   - ARCA busca la LUM a ajustar por CAE + CUIT productor + CUIT comprador + periodo + RENSPA
*--     (error 2004): esos datos tienen que ser IGUALES a los de la original.
*--   - Numeracion propia por tipo: ultimo comprobante (48, 8) + 1.
*--
*-- !!! ATENCION: EMITE UNA NOTA DE CREDITO REAL CON CAE REAL (confirma antes de enviar) !!!
*-- Siempre deja nc_request.xml / nc_response.xml; si sale el CAE guarda el PDF que viene en la
*--   respuesta (nc_lum_prueba_202610.pdf) y anota el CAE en lum_prueba_cae.txt.
*-- Solo ASCII a proposito (sin tildes).
*-- =====================================================================

CLEAR
ON ERROR

LOCAL lcRuta, lcCuitAuth, lcWSAA, lcWSDL, lcCrt, lcKey
lcRuta     = ADDBS(JUSTPATH(SYS(16, 1)))
lcCuitAuth = "30642478296"     && El Calden (CUIT del certificado ElCalden.crt, alias GMSolutions)
lcWSAA     = "https://wsaa.afip.gov.ar/ws/services/LoginCms?wsdl"
lcWSDL     = "https://serviciosjava.afip.gob.ar/wslum/LumService?wsdl"
lcCrt      = "E:\GitHub\xsoftai\Proyectos\SistemasAgiles\pyafipws\conf\ElCalden.crt"
lcKey      = "E:\GitHub\xsoftai\Proyectos\SistemasAgiles\pyafipws\conf\Gestion.key"

*-- LUM a cancelar
LOCAL lcCaeOrig, lnTipoOrig, lnPvOrig, lnNroOrig
lcCaeOrig  = "86439471180134"
lnTipoOrig = 27
lnPvOrig   = 8
lnNroOrig  = 1


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
    MESSAGEBOX("WSAA: no se pudo obtener token y sign" + CHR(13) + WSAA.Excepcion, 16, "LUM NC")
    RETURN .F.
ENDIF


*-- =====================================================================
*-- 2) WSLUM
*-- =====================================================================
LOCAL WSLUM
WSLUM = CREATEOBJECT("WSLUM")
WSLUM.LanzarExcepciones = .F.
IF "Homologaci" $ WSLUM.Version
    MESSAGEBOX("El WSLUM registrado es el de HOMOLOGACION (" + WSLUM.Version + ").", 16, "LUM NC")
    RETURN .F.
ENDIF
WSLUM.Token = WSAA.Token
WSLUM.Sign  = WSAA.Sign
WSLUM.Cuit  = lcCuitAuth
ok = WSLUM.Conectar("", lcWSDL)
IF !ok
    ? WSLUM.Excepcion
    MESSAGEBOX("No se pudo conectar a WSLUM", 16, "LUM NC")
    RETURN .F.
ENDIF


*-- =====================================================================
*-- 3) CONTROL: la LUM original existe y es la esperada
*-- =====================================================================
*-- ConsultarLiquidacion por numero: exige el CUIT del comprador (El Calden). Sin PDF ("").
*-- Ojo: los enteros calculados van con INT() (VAL() solo viaja "1.0" y ARCA lo rechaza).
ok = WSLUM.ConsultarLiquidacion(lnTipoOrig, lnPvOrig, lnNroOrig, .NULL., lcCuitAuth, "")
IF !ok OR !EMPTY(WSLUM.ErrMsg) OR ALLTRIM(TRANSFORM(WSLUM.CAE)) <> lcCaeOrig
    ? WSLUM.ErrMsg, WSLUM.Excepcion
    MESSAGEBOX("No se encontro la LUM original (PV " + TRANSFORM(lnPvOrig) + " Nro " + ;
               TRANSFORM(lnNroOrig) + ") con CAE " + lcCaeOrig + CHR(13) + ;
               "CAE devuelto: " + TRANSFORM(WSLUM.CAE) + CHR(13) + WSLUM.ErrMsg, 16, "LUM NC")
    RETURN .F.
ENDIF
? "LUM original OK. CAE:", WSLUM.CAE, " Total:", WSLUM.Total, " Neto:", WSLUM.TotalNeto


*-- =====================================================================
*-- 4) CABECERA  ->  <liquidacion> + <ajuste>
*-- =====================================================================
LOCAL tipo_cbte, pto_vta, nro_cbte, fecha_cbte, periodo
tipo_cbte  = 48                && Nota de Credito - LUM Clase A (manual WSLUM v1.4)
pto_vta    = 8                 && mismo PV que la original
fecha_cbte = DTOC(DATE(), 1)
fecha_cbte = LEFT(fecha_cbte, 4) + "-" + SUBSTR(fecha_cbte, 5, 2) + "-" + RIGHT(fecha_cbte, 2)
periodo    = "2026/10"         && el MISMO periodo de la LUM original (error 2004 si no coincide)

ok = WSLUM.ConsultarUltimoComprobante(tipo_cbte, pto_vta)
IF ok AND EMPTY(WSLUM.ErrMsg)
    nro_cbte = INT(VAL(TRANSFORM(WSLUM.NroComprobante))) + 1
ELSE
    ? WSLUM.ErrMsg
    MESSAGEBOX("No se pudo obtener el ultimo numero de NC" + CHR(13) + WSLUM.ErrMsg, 16, "LUM NC")
    RETURN .F.
ENDIF

ok = WSLUM.CrearLiquidacion(tipo_cbte, pto_vta, nro_cbte, fecha_cbte, periodo, ;
        "160401/0", "ACCESO RUTA 1 0 - GENERAL MANUEL CAMPOS - LA PAMPA", .NULL., ;
        .NULL., 21.00)
ok = WSLUM.AgregarCondicionVenta(2, .NULL.)                && 2 = Cuenta Corriente

*-- Ajuste FISICO sobre el CAE de la LUM original (cancela todas las cantidades)
ok = WSLUM.AgregarAjuste(lcCaeOrig, "FISICO")


*-- =====================================================================
*-- 5) TAMBERO / TAMBO / UBICACION  (iguales a la LUM original)
*-- =====================================================================
ok = WSLUM.AgregarTambero("20126112824", "186915/2")   && REBOL OSCAR OMAR
ok = WSLUM.AgregarTambo(1, "10.010.0.01001/01", "2027-02-18", "2027-02-18", .NULL.)
ok = WSLUM.AgregarUbicacionTambo(-37.434692, -63.593956, "BELGRANO 526", ;
        6519, 21, 6309, "GUATRACHE")


*-- =====================================================================
*-- 6) BALANCE + CONCEPTOS  (las mismas cantidades y precio que la original)
*-- =====================================================================
LOCAL litros, decomisados, kg_grasa, kg_proteina, precio_kg, importe_gb, importe_pr, total_lum
litros      = 178
decomisados = 0
kg_grasa    = 7.00
kg_proteina = 6.39
precio_kg   = 7118.32
importe_gb  = ROUND(kg_grasa * precio_kg, 2)               && 49828.24
importe_pr  = ROUND(kg_proteina * precio_kg, 2)            && 45486.06
total_lum   = ROUND(importe_gb + importe_pr, 2)            && 95314.30

ok = WSLUM.AgregarBalanceLitrosPorcentajesSolidos(litros, decomisados, kg_grasa, kg_proteina)
ok = WSLUM.AgregarConceptosBasicosMercadoInterno(kg_grasa, precio_kg, kg_proteina, precio_kg)


*-- =====================================================================
*-- 7) OTROS IMPUESTOS  (las mismas percepciones que la original)
*-- =====================================================================
LOCAL base_imp
base_imp = ROUND(total_lum, 2)                              && 95314.30
ok = WSLUM.AgregarOtroImpuesto(6, base_imp, 1.00, "Percepcion de IVA")
ok = WSLUM.AgregarOtroImpuesto(7, base_imp, 0.50, "Percepcion de IIBB")

IF LEN(WSLUM.Excepcion) > 0
    ? WSLUM.Excepcion
    MESSAGEBOX("Error al armar la NC:" + CHR(13) + WSLUM.Excepcion, 16, "LUM NC")
    RETURN .F.
ENDIF


*-- =====================================================================
*-- 8) ENVIO  (CAE REAL)
*-- =====================================================================
IF MESSAGEBOX("Se va a emitir una NOTA DE CREDITO REAL en PRODUCCION:" + CHR(13) + CHR(13) + ;
              "Tipo 48 - PV " + TRANSFORM(pto_vta) + " - Nro " + TRANSFORM(nro_cbte) + ;
              " - Fecha " + fecha_cbte + CHR(13) + ;
              "Ajuste FISICO de la LUM PV 8 Nro 1 (CAE " + lcCaeOrig + ")" + CHR(13) + ;
              "Periodo " + periodo + " - Tambo 1 (REBOL OSCAR OMAR)" + CHR(13) + ;
              "Total: " + TRANSFORM(total_lum, "999,999,999.99") + CHR(13) + CHR(13) + ;
              "Emitir?", 4 + 32 + 256, "LUM NC PRODUCCION") <> 6
    ? "Cancelado por el usuario: no se envio nada."
    RETURN .F.
ENDIF

ok = WSLUM.AutorizarLiquidacion()

LOCAL lcResp
lcResp = NVL(WSLUM.XmlResponse, "")
STRTOFILE(NVL(WSLUM.XmlRequest, ""), lcRuta + "nc_request.xml")
STRTOFILE(lcResp, lcRuta + "nc_response.xml")

IF LEN(WSLUM.Excepcion) > 0
    ? WSLUM.Excepcion
    ? WSLUM.Traceback
    MESSAGEBOX("Error al llamar al webservice" + CHR(13) + WSLUM.Excepcion + CHR(13) + ;
               "Antes de reintentar, consultar el ultimo comprobante 48 del PV 8: puede haberse emitido igual.", 16, "LUM NC")
    RETURN .F.
ENDIF
IF !EMPTY(WSLUM.ErrMsg)
    ? WSLUM.ErrMsg
    MESSAGEBOX("ARCA rechazo la nota de credito:" + CHR(13) + WSLUM.ErrMsg, 48, "LUM NC")
    RETURN .F.
ENDIF

*-- Esperado (igual a la original): total 95314.30 / IVA 20016.00 / otros imp. 1429.71 / neto 113900.59
? "CAE ...................:", WSLUM.CAE
? "Nro. comprobante ......:", WSLUM.NroComprobante
? "Fecha .................:", WSLUM.FechaComprobante
? "Total liquidacion .....:", WSLUM.Total,               "  esperado: 95314.30"
? "Otros impuestos .......:", WSLUM.TotalOtrosImpuestos, "  esperado: 1429.71"
? "Importe IVA ...........:", WSLUM.ImporteIVA,          "  esperado: 20016.00"
? "Total neto ............:", WSLUM.TotalNeto,           "  esperado: 113900.59"
STRTOFILE("NC PRUEBA tipo 48 PV " + TRANSFORM(pto_vta) + " Nro " + TRANSFORM(WSLUM.NroComprobante) + ;
          " CAE " + TRANSFORM(WSLUM.CAE) + " ajusta CAE " + lcCaeOrig + " " + TTOC(DATETIME()) + ;
          CHR(13) + CHR(10), lcRuta + "lum_prueba_cae.txt", 1)

*-- PDF: viene en la respuesta de AutorizarLiquidacion (<pdf> en base64); no hace falta consultarlo.
LOCAL lcPdf
lcPdf = STREXTRACT(lcResp, "<pdf>", "</pdf>")
IF !EMPTY(lcPdf)
    STRTOFILE(STRCONV(lcPdf, 14), lcRuta + "nc_lum_prueba_202610.pdf")
    WSLUM.MostrarPDF(lcRuta + "nc_lum_prueba_202610.pdf", .F.)
ELSE
    ? "La respuesta no trajo el PDF."
ENDIF

RETURN .T.
