# Memoria del proyecto distribuidora

Armada el 06/11/2026 con las notas de `E:\GitHub\xsoftai\Proyectos\GMSmart\mimemoria.md`, que sigue teniendo el detalle completo (los números de línea citados son de ese archivo). Cada dato vale a la fecha indicada: verificar contra el código antes de usarlo.

## Reglas de trabajo
- **Datos de la base de datos:** se leen de `CFCONFIG.INI` del proyecto, sin pedirlos ni escribirlos en el chat (servidor, usuario, contraseña) y sin mostrar su contenido. Los scripts los leen al ejecutarse; no se guardan en archivos ni en esta memoria.
- **Clases compartidas (30/10):** los cambios en `onegocioslocal`, `onegocio` y demás `.vcx` compartibles no se compilan ni se instalan. Se entrega un `.prg` con los métodos y dónde va cada uno, y Marcos los pasa a mano. Una excepción puntual (el hotel, 30/10) no cambia la regla.
- **Formularios (`.scx`):** se editan en copia con el método habitual (texto con FoxBin2Prg, regenerar, compilar, comparar) y se instalan con respaldo.
- **VFP abierto:** el IDE bloquea archivos, por ejemplo `onegocioslocal.vcx` con `gestion.pjx` abierto. Partir siempre de la versión instalada, porque Marcos también edita estos archivos.
- **Cursores de un registro:** después de `SELECT`, hacer `GO TOP` antes de leer campos (30/10).
- **Scripts VFP con rutas:** escribirlos con Write, no con python dentro de un heredoc, porque se rompen las `\` (30/10).

## Estructura
- **`clases\onegocioslocal.vcx`:** `ofacelectronica` solo redefine `lote_totalizar` y `solicitar_totalizar`; el resto viene de `desarrollo\clases\onegocio.vcx`. `Actualizafac` es subclase sobre `Desarrollo\clases\odata.vcx`. Tiene además `actualizafac.grabarliqlactea` (28/10), conector al SP de LUM.
- **`FORMS\impcompvtacae`:** hereda de `leon\clases\oformslocal`. Es una segunda implementación del armado del pedido de CAE, distinta de `solicitar_select`.
- **`FORMS\regnotaped`:** importa TXT de ancho fijo de la PDA vieja. Para bajar pedidos web se recomendó partir de `leon\FORMS\pedidos\regnotapedxml` (28/10, solo análisis).
- **`FORMS\ctacte\regrecibosandroid`:** flujo trazado el 30/10 (línea 3093).
- **`FORMS\buscompro`:** compartido; con origen `CPR` no encuentra las LUM (análisis 28/10, línea 2866).
- **Carpeta `Temporal`:** no hay variable global; algunos formularios usan `SYS(5)+CURDIR()+'Temporal'` y otros `SYS(5)+'\Temporal'` (raíz del disco). `generarandroid` hace `DELETE FILE` sobre la carpeta destino que elige el usuario: es peligroso si apunta a `Temporal` (línea 2565).

## Cambios registrados
- **28-29/10, LUM en `regfaclum_vai`:** grabado en modos F/M, `consultarlumarca` (consulta a ARCA, modo M) e impresión al grabar en M. Los PDF quedan en `distribuidora\LUM` (líneas 2855, 2885, 2891).
- **29/10, `FORMS\abmcomproba`:** el combo grababa por posición en vez de por id. Se corrigió con `BoundTo=.T.` y `LOCATE` en `validar` (línea 2921).
- **03/11, `FORMS\ventas\regfacvtapesaje`:** copia de `regfacvta` (primero se llamó `regfacvta_ia`, Marcos la renombró) con % Kilos F y Kilos F, solo en pantalla, no se graban. El `regfacvta` original no se tocó. Respaldos con el nombre viejo en `respaldo_20261103_kilosf` (líneas 3126-3127, 3145).

## Pendientes
- **`regfacpub`, empresa `codempresa = 16` (pedido de Marcos, 06/11/2026):** establecer un tipo de cantidad de 100. Sin implementar.

- **Envío automático del comprobante por email al grabar (pedido 06/11/2026, EN CURSO, pausado por otra urgencia de Marcos):** con email y tilde del cliente, enviar sin ninguna ventana; solo si hay error se avisa al operador. Detalle completo en `conocimiento\envio_comprobantes_email.md`.
  - **Decidido por Marcos:** tilde en el cliente (`ctacte`); todos los comprobantes; se envía aunque respondan No a imprimir o elijan solo grabar; solo con `EmailSender` (si la terminal no lo usa, no funciona); objeto en `onegocio`, el mismo `sendemail`.
  - **Hecho:** método `sendemail.envioauto` en `conocimiento\sendemail_envioauto.prg`, para que Marcos lo pegue en `onegocio.vcx`. Compila; probados con datos simulados los casos sin envío y el de falta del `.exe`. NO instalado y SIN envío real.
  - **Próximo paso:** Marcos pega el método y avisa; después siguen los formularios.
  - **Falta hacer:** campo `ctacte.envioemailauto` (0/1) en cada empresa; tilde en el ABM; llamadas en `regfacvta` y `regfacpub` (después del commit y de `SolicitaCAE`; vaciar antes `rutadelarchivo`; `regfacpub` no tiene `Sendemail1`); generar el PDF si no se imprimió, antes de `leerproximonro(id,.t.)`; revisar otras salidas de `inicioimpresora` como `generafacturacf` (se leyó solo `reportfa`); confirmar y corregir la posible leyenda DUPLICADO en `reportfa`.
  - **Falta que Marcos defina:** si acepta que la venta espere el envío (máximo 30 s; se recomendó probar así y medir; lanzarlo sin esperar impide avisar el error en el momento); qué ABM de clientes lleva el tilde (`abmctacte`, `_v20`, `_v31`, `_prod`, `abmctactepub`, `abmctactemode`); si las empresas que lo piden usan `CAE_LOTE` (habría que sumar `impcompvtacae`); si alguna usa Outlook (hoy `--provider gmail` fijo).
  - **Textos de trabajo:** exportados el 06/11 a la carpeta temporal `scratchpad\distri_texto` de la sesión f2ea8f16. Pueden quedar viejos o desaparecer: regenerarlos desde los originales.

## Sin confirmar
Vienen de notas viejas; revisar en `GMSmart/mimemoria.md` si siguen vigentes.
- **Anulación de LUM:** `sp_gms_liqlactea_anular.sql` y los cambios del formulario figuraban sin instalar el 29/10 (línea 2893).
- **Estado AFIP en LUM:** como en `regfacvta`, quedó en espera a pedido de Marcos (línea 2891).
- **Bajar pedidos web:** análisis sin decisión registrada en esta memoria (línea 3064).
