# Memoria del proyecto servicios

Creada el 06/11/2026.

## Proyecto
- Proyecto VFP en `E:\GitHub\xsoftsql\Proyectos\servicios`, con `gestion.pjx`. El repositorio git es `xsoftsql`, compartido con los demás proyectos.
- Carpetas principales: `FORMS`, `PROGS`, `clases`, `REPORTS`, `MENUS`, `SCRIP_SQL`, `config`.

## Reglas de trabajo
- **Datos de la base de datos:** se leen de `CFCONFIG.INI` del proyecto, sin pedirlos ni escribirlos en el chat (servidor, usuario, contraseña) y sin mostrar su contenido. Los scripts los leen al ejecutarse; no se guardan en archivos ni en esta memoria.
- **Clases compartidas:** los cambios en `onegocio`, `onegocioslocal` y demás `.vcx` compartibles no se compilan ni se instalan. Se entrega un `.prg` con los métodos y dónde va cada uno, y Marcos los pasa a mano.
- **Formularios (`.scx`):** se editan en copia (texto con FoxBin2Prg, regenerar, compilar, comparar) y se instalan con respaldo. Partir siempre de la versión instalada, porque Marcos también los edita. VFP abierto puede bloquear los archivos.

## Conexión a la base (06/11/2026)
- `CFCONFIG.INI` usa el formato `[CLAVE]valor`. `USERNAME` y `PWDNAME` están encriptados (la app usa `Desencripta`, con clave derivada del servidor); no hizo falta desencriptarlos.
- Conecta tomando `SERVENAME` e `INITCATALOGO` del INI, con autenticación de Windows. Probado en solo lectura; este acceso tiene permiso `db_owner`, así que no escribir sin OK de Marcos.
- Es una base local: el último movimiento en `maopera` era del 24/09/2026. Confirmar si corresponde al caso antes de sacar conclusiones.

## Pendientes
- Refundición de `regasiecierre` (06/11/2026): causa encontrada, parámetro 31 sin cuenta. Marcos anula en producción la refundición grabada y la rehace; no se vio el resultado. Falta confirmar la cuenta definitiva (24 o 23), que la inflación esté activa, y recompilar o copiar el cartel nuevo a producción. Detalle en la sección de refundición.

## `FORMS\regasiecierre` (revisado 06/11/2026, sin cambios)
Asientos de apertura, cierre e inflación. Es el que está en `gestion.pjx`; `_regasicierre` es una versión anterior, sin inflación ni clave para borrar.
- **Posible error, `controlarasi` (`tipoform='I'`, alta):** `lcCadenaTipo$'G-I'` está invertido. Como ahí la cadena siempre incluye `A`, nunca da verdadero, y con un asiento `E` existente responde "Existe otro asiento de inflacion". La rama de inflación tipo 2 (`Q`) queda inalcanzable. Dentro de esa rama está el nombre mal escrito `lcCandenaTipo`, que daría error si se llegara a ejecutar. Sale de leer el código, no se probó.
- **`validarfechacontable`:** el filtro `fecdesde >= fecha AND fecha >= fechasta` está invertido, pero en la base local las 659 cajas son de un solo día, así que ahí no afecta. Fallaría con cajas de varios días.
- `stop()` activo en esa misma rama.

## Refundición en `regasiecierre` (06/11/2026, en análisis, sin cambios)
Marcos reporta un problema en un asiento de refundición; falta el síntoma exacto. Sobre el punto de `G-I` de arriba, Marcos indica que el orden no afecta la lectura.

Flujo (`tipoform='C'`, `_cboasiento='1'`, tipo `G`, o `S` si hay reversa `K`):
1. **Aceptar:** `leerasiento` suma las cuentas `tipocuenta in (4,5)` del ejercicio, invierte debe y haber, y excluye la cuenta de `ParaConta` número 31. `totalcomprobante` calcula la diferencia y se carga en la primera línea (cuenta de cierre).
2. **Grabar:** `key_43` llama a `controlarasi`, `validarplancue`, controla diferencia y cero; `actualizar` llama a `validarasto` y `grabardato`.
3. **`grabardato`:** `grabarcabeasi` con fecha `CsrDetaConta.fechasta` y `grabarastocontable`.

Comprobado en la base local, que Marcos aclara que no está actualizada (último movimiento 24/09/2026). Ids: ejercicio 1 = ...001, ejercicio 2 = ...003, ejercicio 3 = ...004.
- **`ParaConta` número 31 tiene `idcuenta = 0` en los tres ejercicios.** Por el código, la primera línea, que lleva la diferencia, queda sin cuenta, y `validarplancue` frena con "no existe numero de cuenta" salvo que el operador cargue la cuenta en la grilla. No se ejecutó el formulario.
  - Marcos cree que es ese cartel y que no dice qué cuenta (06/11/2026, sin confirmar con una prueba). El mensaje antepone `CsrAuxPlancue.nombre`, que en esa línea viene vacío.
  - Marcos señala que el ejercicio 1 tampoco tiene cuenta 31 y sí tiene refundición: el parámetro en 0 no impide grabar por sí solo. Marcos cree que en el ejercicio 1 la cargaron a mano en la grilla.
  - **Solución, probada por Marcos (06/11/2026):** puso el parámetro 31 en la cuenta 24 y la refundición grabó sin error. Se grabó en producción, no en la base del `CFCONFIG` de servicios: ahí el parámetro sigue en 0 en los tres ejercicios y no hay asiento `G` nuevo, así que el resultado no se revisó. El parámetro es por ejercicio. Falta confirmar qué ejercicio se cerró y si había inflación activa al grabar.
  - El parámetro es "Cuenta Cierre". La refundición del ejercicio 1 (`G`) usó la cuenta 24 RESULTADO DEL EJERCICIO, id 1100000116, tipo 3. Falta confirmar que sea la correcta para los ejercicios 2 y 3, y dónde se carga el parámetro.
  - Marcos dijo "use mal la 23" (06/11/2026), sin más detalle; falta saber cómo afectó al asiento de producción. Cuenta 23 = RESULTADO NO ASIGNADOS (id 1100000115, tipo 3), sin movimientos activos en la base local. Cuenta 24 en el ejercicio 1: `A` H 13.630.538,20, `E` H 26.305.575,67, `G` D 13.469.405,72, `I` D 26.466.708,15. La apertura del ejercicio 2 trae 26.466.708,15 al haber de la 24.
- **Asientos de cierre:** el ejercicio 1 tiene `G` e `I`. El 2 tiene `A` y solo `E` anulados, sin `G` ni `I`. El 3 no tiene `A`, por lo que el formulario respondería "No existe una apertura del ejercicio". La apertura lee los `I`/`U` del ejercicio anterior.
- **Empresa y antecedentes:** los ejercicios coinciden en ids y fechas con la auditoría de `E:\GitHub\xsoftai\Proyectos\autorias\laligabb` (`mimemoria.md` y `auditoria\`). Ahí no se menciona refundición, cuenta de cierre ni `ParaConta`, y ningún script toca `paraconta` ni `cabeasi`. Según esa memoria, el ejercicio 3 es el actual; el que está sin cerrar en esta base es el 2.
- **Suma de resultado, ejercicio 2:** el formulario filtra `cabeasi.estado` y no `maopera.estado`. Saldo del formulario 11.974.811,01. Los 52 asientos con `maopera` anulado aportan -71.094.994,31 y los 45 de clase `K` +70.085.497,24. Neto -1.009.497,07. Hipótesis sin verificar: `K` sería el contraasiento del anulado y por eso casi se compensan. Sacar solo los anulados daría un saldo erróneo de 83.069.805,32.
- **Inflación antes de refundir:** en esta base, los 3 asientos `E` del ejercicio 2 están anulados y `controlarasi` no exige un `E` activo para generar `G`. Una refundición sin inflación activa saldría sin el ajuste.
- 291 asientos desbalanceados, todos en el ejercicio 3 (288 de clase `D`: 284 COB y 4 PAG). No afectan al ejercicio 2. Causa sin revisar; que la auditoría mencione 291 líneas corregidas parece coincidencia, no se verificó.
- Reversa: `lcacadena` (mal escrito) deja la negativa sin mensaje.
- Descartado: `STR(id,10)` alcanza para los ids de `plancue` (10 dígitos) y la comparación sin redondear no falló en una prueba en VFP.

## Cambios
- **06/11/2026, `FORMS\regasiecierre`, `validarplancue`:** si la línea sin cuenta no tiene nombre (`tipoform` C o I), el cartel dice que falta la cuenta de cierre o inflación y nombra el parámetro 31 o 40 de `ParaConta`. Compilado; no ejecutado. Respaldo: `FORMS\respaldo_20261106_cartel31`. Hay que recompilar para que llegue al ejecutable de producción. La regeneración también le quitó un espacio inicial a una línea del `SelectCmd` de `paraconfig`.
