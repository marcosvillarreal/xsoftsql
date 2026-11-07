# Envío de comprobantes por email

Investigación del 06/11/2026 para el envío automático al grabar. Sale de leer el código de `regfacvta`, `regfacpub`, `impcompvta*`, `objimpresor` y `sendemail`. **No se probó nada ni se escribió código.** Los números de línea son del texto exportado ese día y pueden cambiar.

## Pedido
Al grabar un comprobante, si tiene email y el tilde de envío automático (por agregar), enviarlo por email en segundo plano.

## Cómo funciona hoy el envío manual

### Cuándo aparece
- `cmdimprimir` solo está visible en `ponerpantallamodoconsulta`; en edición se oculta.
- `key_afip`, después de asignar el número, llama a `cmdimprimir.Click()`.
- Al facturar normalmente no aparece. No hay condición por empresa ni por cliente.

### Flujo
1. `cmdimprimir.Click` abre `frmelijosalida`: 1 impresora, 2 email, 0 salir.
2. Con 2, llama a `imprimir` con `salidaporpdf` activo.
3. `Objimpresor.inicioimpresora` llega a `salidapdf`, que genera el PDF y guarda la ruta en `rutadelarchivo`.
4. Se abre `DO FORM SendEmail` con un objeto con `cFile`, `cSubject`, `cBody`, `cTo` y `EsModal`. El destinatario sale de `CsrCtacte.email`.

### Diferencias entre formularios
| | `regfacpub` | `regfacvta` |
|---|---|---|
| Activa el PDF | `activoenvioemail = .t.` | `salidaporpdf = .t.` directo |
| Segundo parámetro de `imprimir` | `Csrprefitermi.tipoimpresora` | `thisform.formulario` |
| Envío | `enviocorreo(rutadelarchivo)` | `Sendemail1.Send()` (`enviocorreo` comentado) |
| Controla que se generó el PDF | Sí, `lok` y `FILE()` | No |
| Cuerpo | "Le acercamos el comprobante" | "Le adjuntamos el comprobante de venta" y "Atte." con la empresa |
| Comprobante sin número | No lo controla en el botón | Avisa y corta |
| Pregunta "¿imprimir original?" | No | Solo en salida por impresora |

### Clases
- `Sendemail1`: clase `sendemail` de `clases\onegocioslocal.vcx`, que hereda de `Desarrollo\clases\onegocio.vcx`. `Send` llama a `compress`, que devuelve `rutadelarchivo` si `comprimir` está apagado.
- Formulario `Desarrollo\forms\sendemail`: subclase de `sendemail` en `controles.vcx`, que hace el envío.
- `key_43` elige el método según la terminal:
  - `oConfigTermi.emailsender = 'TRUE'`: `Enviar_EmailSender`, con la clase `EmailSender_OAuth`.
  - `oConfigTermi.EmailOld = 'TRUE'`: `Enviar`, con CDO.
  - Si no: `Enviar_csfoxsmtp`.
- La cuenta SMTP se toma de `EmailEmpresa`, según `ParaVario.EMAILID`.

## El PDF automático
- `reportfa` (`clases\localproyeto.vcx`, clase `objimpresor`): si no es salida por PDF, llama a `salidareport` y, en la primera copia, a `salidapdf`. Por eso al imprimir el PDF ya queda guardado.
- **Ubicación:** `pathpdf`, que sale de `PATHFACPDF` + terminal (4 dígitos) en `ParaVario`. Por defecto, `c:\comprobantespdf\`. Es una ruta por terminal.
- **Nombre:** `cabrevia + ' ' + proximonro`, más `.pdf`.
- **Ruta:** queda en `Objimpresor.rutadelarchivo`.
- **Copia:** es la primera, o sea ORIGINAL, salvo que `leyendaduplicado` esté activa.
- `salidapdf` genera con FoxyPreviewer (`.AddReport`, `.cDestFile`, `.RunReport`).

### Cuándo NO se genera al grabar
- Responden No a "¿Desea imprimir el comprobante?".
- "Solo grabar" (`chkSoloImprimir` en `regfacvta`).
- `CAE_LOTE` activo: `SolicitaCAE` vuelve sin imprimir y el lote se hace por `impcompvtacae`.
- Falla el CAE.
- `TIPOFactura = 'M'` en `regfacpub` (no llama a `Imprimir_comproba`).

## Secuencia de grabado (`actualizar`)
Confirmación, `Begintrans`, según el caso impresión, `GrabarDato`, `committrans` y después `SolicitaCAE`.
- **Sin CAE o con CAEA:** se imprime ANTES de grabar. El PDF puede existir aunque después haya ROLLBACK. El envío debe registrarse después del commit.
- **Con CAE:** se imprime dentro de `SolicitaCAE`, después del commit. El envío debe ir después, para que el PDF lleve la autorización.
- `regfacpub`, si no solicita CAE y `TIPOFactura <> 'M'`, llama a `Imprimir_comproba` después del commit.
- `regfacvta` puede grabar además un remito (`generarentrega`, `accion = "R"`) con otra llamada a `actualizar`.

## Problemas para reutilizar lo actual
- El formulario `sendemail` tiene pantalla y mensajes; `enviar_emailsender` tiene `stop()`, `MESSAGEBOX` y "Correo Enviado".
- CDO y CsFoxySmtp envían dentro del mismo proceso, así que dejarían esperando al operador.
- Según la memoria del proyecto EmailSender, `EmailSender_OAuth.exe` admite `--silent` y responde en `email_result.json`. Es un único archivo por carpeta: dos envíos seguidos podrían pisarse.
- La autorización OAuth es por terminal, y la pantalla de consentimiento de Google figuraba en modo Testing.

## Rumbo actual (06/11/2026): archivo en carpeta + GmEmailLocal
Decisión de Marcos: **distribuidora solo deja un archivo; toda la lógica de envío está en `E:\GitHub\xsoftai\Proyectos\GmEmailLocal`** (Python, programa local por terminal, PDF adjunto). `GmEmail` es otro proyecto (servicio con Supabase y link) y no se usa acá. La referencia completa es `CONTRATO.md` de GmEmailLocal.

### Archivo que deja distribuidora
**Ruta:** `C:\GmEmailLocal\inbox\<idmaopera>_<sufijo>.json`. Grabarlo como `.tmp` y renombrarlo a `.json` al final.

```json
{
  "idmaopera": 110000012345,
  "email": "cliente@ejemplo.com",
  "archivo": "C:\\comprobantespdf\\0001\\FAC A 0001-00000123.pdf",
  "comprobante": "FAC A 0001-00000123",
  "asunto": "Empresa - FAC A 0001-00000123",
  "cuerpo": "Estimado: le adjuntamos el comprobante..."
}
```
Obligatorios: `email`, `archivo`, `asunto`. Dentro de un string, `\` va como `\\` y `"` como `\"`.

### Qué hace distribuidora antes de dejarlo
Sale sin hacer nada si: la terminal no usa EmailSender, el comprobante no tiene `maopera.numcomp`, o el cliente no tiene tilde o email. Si `C:\GmEmailLocal\lector.vivo` falta o tiene más de 2 minutos, lanza `C:\GmEmailLocal\GmEmailLocal.exe`.

La propuesta de abajo, con el envío directo y la espera de 30 segundos, queda reemplazada.

## Propuesta anterior (06/11/2026, sin instalar, reemplazada)
Marcos aclaró que "segundo plano" significa **sin ninguna ventana, salvo que haya un error, y ahí se le informa al operador**. Por eso se descartó la tabla de pendientes y el proceso aparte.

- **Método:** `sendemail.envioauto(idctacte, idmaopera, archivo, detalle)` en `onegocio.vcx`. Texto para pasar a mano en `conocimiento\sendemail_envioauto.prg`.
- **Lanza** `EmailSender_OAuth.exe --silent` oculto y espera el resultado hasta 30 segundos. **La venta espera ese tiempo.**
- **No usa `EmailSender_OAuth.Enviar`:** ante un error abre el JSON con `RUN notepad.exe`, que deja VFP esperando, y si `provider` está vacío usa `toParams`, que no existe.
- **Salida en un archivo temporal único** (`--output`), así no se pisan los resultados.
- **Cuerpo en una sola línea:** un salto de línea cortaría el comando.

### Falta
1. Campo `ctacte.envioemailauto` (entero, 0/1) en cada empresa. Sin ese campo el método no hace nada.
2. El tilde en el ABM de clientes; hay varios `abmctacte*` y no se verificó cuál usa cada empresa.
3. Llamadas en `regfacvta`, `regfacpub` y, con lote, `impcompvtacae`. `regfacpub` no tiene objeto `Sendemail1`.
   - Vaciar `Objimpresor.rutadelarchivo` al empezar a grabar, para no adjuntar un PDF anterior.
   - Enviar después del commit y después de `SolicitaCAE`.
   - Si no se imprimió, generar el PDF con `salidaporpdf` antes de `leerproximonro(id,.t.)`.
4. Revisar las otras salidas de `inicioimpresora` (por ejemplo `generafacturacf`): se leyó solo `reportfa`, y puede haber salidas que no generen PDF.
5. Corregir antes el posible error de DUPLICADO en `reportfa` (punto 3 de abajo), porque afectaría al PDF generado sin imprimir.

## Decisiones de Marcos (06/11/2026)
1. **Tilde:** en el cliente (`ctacte`).
2. **Comprobantes:** todos.
3. **Si responden No a imprimir o eligen solo grabar:** se envía igual, generando el PDF sin imprimir.
4. **Método:** solo con `EmailSender`; si la terminal no lo usa, no funciona.
5. **Dónde va:** un objeto en `onegocio` que se encargue del proceso; puede ser el mismo `sendemail`. Rige la regla de entregar un `.prg` para pasar a mano.
6. **Sin número:** si el comprobante no tiene `maopera.numcomp`, no se envía. `envioauto` lo lee de la base después del commit y sale sin avisar (el silencio es una decisión provisoria, a confirmar con Marcos). Es el mismo dato que controla `regfacvta.cmdimprimir`.

## Sin verificar
- No se encontró dónde se define la clase `EmailSender_OAuth` (búsqueda en los `.prg` de `Desarrollo` y `distribuidora`).
- Las opciones del `.exe` salen de la memoria del proyecto EmailSender, no del código.
- `frmelijosalida` se vio por encima. Hay dos: `FORMS\util` y `Desarrollo\forms`; no se verificó cuál se ejecuta.
- No se revisó cómo se usa el email en `impcompvta*`.

## Posibles errores vistos en el envío manual
No probados; no se corrigió ninguno.
1. `regfacvta` llama a `Send()` sin controlar el resultado: si falla el PDF, podría adjuntar el `rutadelarchivo` anterior.
2. `regfacvta` pasa `thisform.formulario` donde `imprimir` espera el tipo de impresora.
3. En `reportfa`, con salida por PDF `copiastkt` queda en 1, pero el bucle le vuelve a sumar `CsrPlanPago.copias`. Si el plan tiene copias, el último PDF, que es el que se adjunta, saldría DUPLICADO.
4. `leyendaduplicado` solo se define en la opción de impresora de `regfacvta`, así que el PDF usa el último valor.
