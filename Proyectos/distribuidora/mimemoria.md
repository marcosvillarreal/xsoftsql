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
  - **Decidido por Marcos:** tilde en el cliente (`ctacte`); todos los comprobantes; se envía aunque respondan No a imprimir o elijan solo grabar; no se envía si el comprobante no tiene `maopera.numcomp`; solo con `EmailSender` (si la terminal no lo usa, no funciona); objeto en `onegocio`, el mismo `sendemail`.
  - **Hecho (06/11/2026):** `GmEmailLocal` creado y compilado, sin instalar en ninguna terminal. Métodos `sendemail.envioauto` y `jsontexto` instalados en `Desarrollo\clases\onegocio.vcx` con autorización puntual de Marcos para este cambio; respaldo en `Desarrollo\Clases\respaldo_20261106_envioauto`. Copia del texto en `conocimiento\sendemail_envioauto.prg`. Probado solo con datos y un EmailSender simulados: ningún envío real.
  - **Cambio de rumbo (06/11/2026):** distribuidora solo deja un archivo en `C:\GmEmailLocal\inbox\`; toda la lógica de envío está en `E:\GitHub\xsoftai\Proyectos\GmEmailLocal` (Python, PDF adjunto, mensaje emergente si falla). Estructura del archivo y ruta en `conocimiento\envio_comprobantes_email.md`. Marcos autorizó cambiar `onegocio`. El envío directo y la espera de 30 s quedan reemplazados.
  - **Estado al pausar (06/11/2026, 16:45):** ningún formulario de distribuidora cambió y nadie llama a `envioauto`, así que el sistema funciona como antes. `C:\GmEmailLocal` no existe en esta PC. Si Marcos tenía `onegocio` abierto en VFP, debe reabrirlo antes de grabar la clase. Primer envío real: usar una terminal ya autorizada y el email de Marcos como cliente de prueba.
  - **Falta hacer:** instalar `GmEmailLocal` en cada terminal con su `config.json`; campo `ctacte.envioemailauto` (0/1) en cada empresa; tilde en el ABM; llamadas en `regfacvta` y `regfacpub` (después del commit y de `SolicitaCAE`; vaciar antes `rutadelarchivo`; `regfacpub` no tiene `Sendemail1`); generar el PDF si no se imprimió, antes de `leerproximonro(id,.t.)`; revisar otras salidas de `inicioimpresora` como `generafacturacf` (se leyó solo `reportfa`); confirmar y corregir la posible leyenda DUPLICADO en `reportfa`.
  - **Falta que Marcos defina:** qué ABM de clientes lleva el tilde (`abmctacte`, `_v20`, `_v31`, `_prod`, `abmctactepub`, `abmctactemode`); si las empresas que lo piden usan `CAE_LOTE` (habría que sumar `impcompvtacae`); si alguna usa Outlook (EmailSender no adjunta con Outlook, así que GmEmailLocal solo admite Gmail); si un comprobante sin número debe avisar al operador (hoy sale en silencio).
  - **Textos de trabajo:** exportados el 06/11 a la carpeta temporal `scratchpad\distri_texto` de la sesión f2ea8f16. Pueden quedar viejos o desaparecer: regenerarlos desde los originales.

- **Actualizar precios de La Nueva Sirena desde Excel/CSV (pedido 06/11/2026, solo análisis, sin código):** archivo con código y precio. **Decisión de Marcos:** por ahora lo hacen a mano; la solución se diseña en GMSmart con un SP que copie la lógica de precios de VFP; referencia recomendada: flujo de `cbioprecio2`, a confirmar (`E:\GitHub\xsoftai\Proyectos\GMSmart\docs\precios_archivo_diseno.md`). Existen `FORMS\precio\cbioprecio_file` (CSV) y `cbioprecio_file_excel`, pero no calculan igual que `abmproducto` y su historial parece tener errores: no usarlos sin revisarlos.
  - **Qué hace `cbioprecio_file`:** toma el valor como **costo**, con o sin IVA; elige columnas por letra; separador `;` o `,`; saltea la primera fila; pide proveedores; cruza por `codartprod` o `codbarra13` (`numero` está comentado). Mantiene márgenes y redondea solo la lista 1 con `a_red`, recalculando `margen1`.
  - **Posibles problemas (leídos del código, sin probar):** `1.234,56` se lee como 1,234 (`VAL` tras cambiar coma por punto); los códigos del CSV sin artículo se borran sin avisar; la comparación `=` puede dar coincidencias parciales, o con código vacío, según `SET EXACT` (la versión Excel filtra `codartprod<>''`, la CSV no); si dos artículos tienen el mismo código, solo queda el último; `prevta1` se asigna antes de redondear; `grabardato` tiene un `DELETE IN CsrCbioPrecio` sobre el historial del día y solo se ve `Salvar('CsrProducto')`; `stop()` activo en `crearinforme` y `grabardato` (solo frena fuera del ejecutable). Buscar el nombre en `gestion.exe` no sirve: tampoco aparecen `cbioprecio2` ni `precioprod`.
  - **Cálculo:** con `precioprod1` (`Desarrollo\clases\odata.vcx` y `cfpreciovta` de `onegocioslocal`), sin rehacer fórmulas en SQL.
  - **Cálculo:** costo, bonificaciones (`cfcostobonificado`), interno, flete (`cfflete`), seguro de flete (`cfseguroflete`), `cfcostofinal`, y `cfpreciovta` con `margen1` a `margen4`. Graba en `producto` y deja historia en `cbioprecio`; actualiza `fecmodi`.
  - **Revisar:** ni `cbioprecio1` ni `cbioprecio2` mencionan `redondeo` ni `congelarprecio`; `cflimpiarprecio` deja `redondeo=0`. `cbioprecio2.grabardato` tiene un `vista()` activo. El historial se graba aunque solo se vea `Salvar('CsrProducto')`: en la base de distribuidora hay 22.329 filas de `CBIOPRECIO2`.
  - **Falta que Marcos defina:** ver "Falta definir" en el diseño de GMSmart. Falta ver el archivo real.

## Sin confirmar
Vienen de notas viejas; revisar en `GMSmart/mimemoria.md` si siguen vigentes.
- **Anulación de LUM:** `sp_gms_liqlactea_anular.sql` y los cambios del formulario figuraban sin instalar el 29/10 (línea 2893).
- **Estado AFIP en LUM:** como en `regfacvta`, quedó en espera a pedido de Marcos (línea 2891).
- **Bajar pedidos web:** análisis sin decisión registrada en esta memoria (línea 3064).
