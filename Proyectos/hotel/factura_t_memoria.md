# Hotel - Factura T (WSCT / RG 3971): memoria para retomar

Ultima actualizacion: 05/11/2026. Historial completo: `E:\GitHub\xsoftai\Proyectos\GMSmart\mimemoria.md` (lineas ~2897-3005, buscar "HOTEL Factura T").
Este archivo manda sobre los pendientes viejos de esa memoria. Anotar aca lo nuevo de Factura T.

## Estado al 05/11/2026
- Codigo instalado en el proyecto local (`E:\GitHub\xsoftsql\Proyectos\hotel`), **sin emitir ninguna T contra ARCA**: la primera sera un comprobante real.
- Scripts SQL ya aplicados en produccion (verificado abajo). Falta configuracion, exe y PCs.
- **Se retoma por:** decidir y aplicar el cambio de `regfacvta` para factura solo con extras (seccion siguiente).

## 1. Cambio pendiente en regfacvta: factura solo con extras
**Decision del usuario (05/11):** si la factura tiene solo extras (sin alojamiento, reintegro 0), regfacvta no la deja como T.

**Hoy no lo hace** (verificado leyendo el codigo; el usuario creia que si):
- `cambiocomproba` (~linea 5565 del .SCT) pone T al elegir cliente fiscal X, antes de conocer los items.
- `validarcomproba` (~13508) frena si no hay pasaporte. Orden validarcomproba -> actualizar tomado de la memoria del 29/10, no retrazado.
- `preguntoreintegrotur` (~12222): `IF .lnreintegrotur=0 -> RETURN .t.` sigue como T, sin preguntar.
- `pidopagotur` no se abre (`lbreintegrotur` en .F.), y `solicitar_select_t` rechaza con "falta la forma de pago".

**Propuesta, NO aplicada, esperando OK del usuario** (form cerrado en VFP; respaldar antes; version actual scx `BDEDCD1A` / SCT `2B000AA0`):

```foxpro
* preguntoreintegrotur: reemplaza el IF .lnreintegrotur=0 y la pregunta
IF .lnreintegrotur=0
	IF CsrComprobante.clase#'A'		&& una ND T no pasa a consumidor final
		RETURN .t.
	ENDIF
ELSE
	lnOk = oavisar.usuario(...)		&& la misma pregunta de hoy
	IF lnOk=6
		.lbreintegrotur = .t.
		.totalcomprobante()
		RETURN .t.
	ENDIF
ENDIF
*-- sigue igual: busca fiscal='C', cambiocomproba(lnIdCF), limpia tipodoc y dni
```

```foxpro
* validarcomproba: no exigir pasaporte a la factura que no va a salir como T
.ve_condicion((.lcLetra='T' OR LEFT(.proximonro,1)='T' OR CsrComprobante.clasetipo='06') AND ALLTRIM(CsrCategoiva.fiscal)=='X';
	AND NOT (CsrComprobante.clase='A' AND .lnreintegrotur=0);
	AND EMPTY(CHRTRAN(CsrAuxCabefac.dni,'0.- ','')),;
```

**A probar:** que `lnreintegrotur` este actualizado al llegar a `validarcomproba`; si no, una factura con alojamiento podria saltarse el control de pasaporte.

## 2. Produccion: base de datos
Servidor `hotel-server\sql2014,1170` por Tailscale (`SERVER1\SQL2014`, Express), base `hotel_mu`. Credenciales: pedirlas al usuario, no se guardan aca.

**Verificado el 05/11 (solo lectura):**
- `factura_turista.sql` y `paises_arca.sql` aplicados: `cabefac.dni` 20, 4 columnas nuevas, 3 `AfipComproba` T, 3 `clasecomp` 06, 310 paises sin faltantes.
- Valores 2, 5, 10, 14, 17 correctos, tildados y con cuenta en `valorctacon`. Rubro 1 CARGOS `codtur` 2. Categoria 9 `fiscal='X'`.
- `CAE_PCRT = hotelm.crt`, `CAE_PKEY = Gestion.key`, `CAE_PROD` y `CAE_FAC` con `estado=1`.

**Falta cargar (no lo hace ningun script):**
- [ ] Comprobantes clase/tipo 06: FACTURA TUR (A), NOTA CREDITO TUR (C), NOTA DEBITO TUR (B). En produccion no hay ninguno. En local solo FACTURA TUR (id 1100000067, numero 58): el `numero` puede estar ocupado en produccion, revisarlo.
- [ ] Talonarios letra T: factura, NC y ND en PV 9, `activocae` 1, formulario 3, impresora `1100000034` (la de A y B). Sin NC T no se puede corregir una T mal emitida.
- [ ] `prefitermi`: solo terminales **19, 37, 38 y 1100000036**, las unicas con FACTURA CAE en produccion. No copiar lo local (39, 42, 43 tienen solo FACTURA TUR).
- [ ] Clientes extranjeros: categoria 9, pasaporte, domicilio y pais (hoy 0 con categoria 9).

Quedo sin definir si se hace por script (propuesto, probado con ROLLBACK y corrido con OK) o desde los ABM.

## 3. Compilar e instalar el sistema
- [ ] Compilar `gestion.exe` (salida del proyecto `gestion.pjx`; no hay uno en la carpeta, `management.exe` es del 16/03). `pidopagotur` ya esta en el proyecto.
- [ ] Antes, revisar los cambios de LUM del 04/11 en `desarrollo\clases\onegocio.vcx`: entran al exe del hotel.
- `qdfoxjson.prg`: error `PUVALUE1/PUVALUE2` corregido con `EXTERNAL ARRAY` (lineas 369 y 519); el usuario confirmo que compila.

## 4. PCs del hotel (sin verificar: la consulta solo llego a la base)
Copiar desde `C:\GMSolutions\PyAfipWs\`, en cada PC que autorice comprobantes:
- [ ] `wsct.exe` 30/10, sha256 `2B77B032F9C0...`; registrar como administrador: `wsct.exe --register`. **No usar `pyafipws\dist\wsct.exe`: es build de homologacion y fuerza esa URL.**
- [ ] `wsfev1.exe` 28/07, `A7C22C070B98...`. Critico: una version anterior al 24/07 puede romper tambien las facturas A y B (condicion IVA receptor).
- [ ] `wsaa.exe` 28/07, `94E8392205DB...`.
- [ ] `AfipCert\hotelm.crt` (CN Fact elec, vence 03/09/2028) y `AfipCert\Gestion.key`.

ARCA: la autorizacion `wsct` del certificado ya existe y el PV 9 responde (ultimo numero 0, 30/10).

## 5. Despues de instalar
- [ ] Primera T real controlada, con la NC T lista.
- [ ] Revisar impresion: usa el formulario 3 como A y B; no hay registro de una T impresa. Ver letra, reintegro y pasaporte.
- [ ] TURIVA (regimen informativo mensual): no desarrollado.
- [ ] Contador: confirmar vigencia de la norma.

## Reglas para tener en cuenta
- Base local `hotel_mu` en `marcos-hp\sql2022` tiene `CAE_PROD` activo: una autorizacion desde ahi va a ARCA real. Su `CAE_PCRT` (`hotelmu.crt`) esta viejo.
- `onegocioslocal` / `onegocio` y demas vcx compartidos: se entrega `.prg` y el usuario los pasa a mano, salvo pedido puntual.
- Pruebas VFP automatizadas: correr ocultas y sin diálogos (`-c` con `SCREEN=OFF`, `-WindowStyle Hidden`, `ON ERROR`); el 05/11 unas pruebas abrieron ventanas en la pantalla del usuario.
- `JSONObject()` sin parametro: `JSONObject('')` da error 1470 en `ADDPROPERTY`. `JSONDecode` tambien falla con comas dentro de textos, `{}`, comillas dobles y nombres invalidos; no se corrigio.
