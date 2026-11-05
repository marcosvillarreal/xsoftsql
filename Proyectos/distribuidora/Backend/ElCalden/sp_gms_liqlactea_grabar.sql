-- ============================================================
-- El Calden - Grabacion de la LIQUIDACION LACTEA (LUM) y sus NC / ND (28/10/2026). Solo elcalden.
-- Lo llama VFP (forms\liqlactea\regfaclum_vai) con odata.ejecutarsp, a traves de actualizafac
-- (actualizafac queda solo como conector: la logica de grabar esta aca).
-- Definido con el usuario:
--   - Un SP maestro (sp_gms_liqlactea_grabar) que llama a SPs hijos, uno por tema, para que si hay
--     que tocar algo el codigo siga siendo legible.
--   - Tablas: maopera (origen 'LUM'), cabeLiq (no cabecpra/cuercpra), movctacte + ctacte.saldo,
--     cabeasi, tablaasi, tablaimp (tablaori 'FLUM', idorigen = cabeLiq.id; la linea del tambo
--     tablaori 'MOCT', idorigen = movctacte.id, como el resto del sistema).
--   - Las "percepciones" de la LUM (asi las llama ARCA) son retenciones que practica El Calden: se le
--     paga menos al tambo. Se graban como RI (paraconta 7) y RB (paraconta 9).
--   - Asiento de la liquidacion (comprobante que resta, signocta 2):
--       D  NG compra de leche (paraconta 19) ....... total
--       D  IG IVA credito fiscal (paraconta 13) .... iva
--       H  RI retencion IVA (paraconta 7) .......... periva
--       H  RB retencion IIBB (paraconta 9) ......... periibb
--       H  ZZ tambo / proveedores (paraconta 3) .... neto       (cuenta corriente por el NETO)
--     La NC (signocta 1) lo invierte. Las cuentas salen de paraconta del ejercicio del periodo
--     (nada fijo en el codigo). plancue: el mismo id es la misma cuenta en todos los ejercicios.
--   - Fecha y periodo deben coincidir (el periodo es el de la liquidacion lactea).
--   - Ids: NuevoIdsql (KEYSID) + prefijo de sucursal de 2 digitos (goapp.sucursal10+10 en VFP).
-- Transaccion: si VFP ya tiene una abierta trabaja dentro de ella y NO hace rollback (lo deshace
-- VFP al recibir el error); si no hay, abre la suya. Los hijos no manejan transaccion: ante un error
-- hacen THROW y el maestro decide.
-- Literales solo ASCII (sqlcmd sin -f 65001 corrompe tildes).
-- ============================================================
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- ------------------------------------------------------------
-- Id nuevo para una tabla: KEYSID + prefijo de sucursal (mismo armado que odata.agregar)
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_nuevoid
    @tabla   VARCHAR(20),
    @prefijo VARCHAR(2),      -- '' = sin prefijo (goapp.sucursal10 = 0)
    @id      NUMERIC(12,0) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ultimo INT, @suma INT = 1;
    DECLARE @swallow TABLE (v VARCHAR(50));   -- NuevoIdsql devuelve result sets que no se usan

    INSERT INTO @swallow EXEC dbo.NuevoIdsql @Lcalias = @tabla, @RetValor = @ultimo OUTPUT, @Valsuma = @suma;
    IF ISNULL(@ultimo, 0) = 0
        THROW 50001, 'LUM: no se pudo obtener un id nuevo (KEYSID).', 1;

    SET @id = CASE WHEN ISNULL(@prefijo, '') = '' THEN @ultimo
                   ELSE CAST(@prefijo + RIGHT('0000000000' + CAST(@ultimo AS VARCHAR(10)), 10) AS NUMERIC(12,0)) END;
END
GO

-- ------------------------------------------------------------
-- 1) Validar. Devuelve los datos que usan los otros hijos (ejercicio, signo, cuentas, tambo, cuenta
--    corriente donde va el movimiento, CAE de la liquidacion original).
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_validar
    @idcomproba     INT,
    @numcomp        CHAR(13),
    @fecha          DATE,
    @periodo        CHAR(6),
    @idctacte       INT,
    @iddetanrocaja  INT,
    @tipoform       CHAR(1),
    @idliqlacteo    NUMERIC(12,0),
    @total          NUMERIC(15,2),
    @iva            NUMERIC(15,2),
    @periva         NUMERIC(15,2),
    @periibb        NUMERIC(15,2),
    @neto           NUMERIC(15,2),
    @cae            CHAR(14),
    @vtocae         DATE,
    @idmaoperaliq   NUMERIC(12,0),
    @tipoajuste     CHAR(10),
    -- salida
    @clase          CHAR(1)       OUTPUT,
    @signo          INT           OUTPUT,   -- +1 suma (NC), -1 resta (liquidacion / ND)
    @idejercicio    INT           OUTPUT,
    @idctaNG        INT           OUTPUT,
    @idctaIG        INT           OUTPUT,
    @idctaRI        INT           OUTPUT,
    @idctaRB        INT           OUTPUT,
    @idctaZZ        INT           OUTPUT,
    @idtambo        INT           OUTPUT,
    @caeajuste      CHAR(14)      OUTPUT,
    @idtipocbte     INT           OUTPUT    -- AfipComproba.id (clase + clasetipo del comprobante y letra)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @signocta NUMERIC(2,0), @desde CHAR(8), @clasetipo CHAR(2);

    -- Comprobante
    SELECT @clase = clase, @signocta = signocta, @clasetipo = clasetipo FROM dbo.comprobante WHERE id = @idcomproba;
    IF @clase IS NULL
        THROW 50001, 'LUM: el comprobante no existe.', 1;
    IF @clase NOT IN ('A', 'B', 'C')
        THROW 50001, 'LUM: el comprobante no es una liquidacion, nota de credito o nota de debito.', 1;
    SET @signo = CASE @signocta WHEN 1 THEN 1 WHEN 2 THEN -1 ELSE 0 END;
    IF @signo = 0
        THROW 50001, 'LUM: el comprobante no define si suma o resta en la cuenta corriente (signocta).', 1;
    IF @tipoform NOT IN ('F', 'M')
        THROW 50001, 'LUM: modo de grabacion desconocido (F normal / M manual).', 1;

    -- Tipo de comprobante ARCA: AfipComproba por clase + clasetipo y letra (como cabefac.IdTipoCbte).
    -- F lo necesita para enviar a ARCA; en M (ya emitida en el portal) se graba si esta cargado.
    SELECT TOP 1 @idtipocbte = id FROM dbo.AfipComproba
    WHERE clasecomp = @clase + ISNULL(@clasetipo, '') AND letra = LEFT(@numcomp, 1);
    IF @idtipocbte IS NULL AND @tipoform = 'F'
        THROW 50001, 'LUM: falta el tipo de comprobante ARCA en AfipComproba para este comprobante y letra.', 1;

    -- Cuenta corriente
    IF NOT EXISTS (SELECT 1 FROM dbo.ctacte WHERE id = @idctacte)
        THROW 50001, 'LUM: la cuenta corriente no existe.', 1;

    -- Numero no repetido (no anulado).
    -- F llega SIN NUMERO (letra + pto vta + 00000000) y se graba con numcomp vacio (sp_gms_liqlactea_maopera): el numero lo asigna ARCA
    -- y lo graba sp_gms_liqlactea_cae. Asi una LUM que ARCA no autorizo no ocupa un numero de otra.
    IF ISNULL(LTRIM(@numcomp), '') = '' OR LEN(RTRIM(@numcomp)) <> 13
        THROW 50001, 'LUM: falta el numero del comprobante (letra + pto vta + numero).', 1;
    IF @tipoform = 'F' AND RIGHT(@numcomp, 8) <> '00000000'
        THROW 50001, 'LUM: en F el comprobante se graba sin numero (lo asigna ARCA al autorizar).', 1;
    IF @tipoform = 'M' AND RIGHT(@numcomp, 8) = '00000000'
        THROW 50001, 'LUM: falta el numero del comprobante.', 1;
    IF @tipoform = 'M' AND EXISTS (SELECT 1 FROM dbo.maopera WHERE idcomproba = @idcomproba AND numcomp = @numcomp AND estado <> '1')
        THROW 50001, 'LUM: el numero de comprobante ya esta grabado.', 1;

    -- Fecha y periodo deben coincidir
    IF @periodo IS NULL OR LEN(@periodo) <> 6 OR @periodo LIKE '%[^0-9]%'
        THROW 50001, 'LUM: el periodo debe ser AAAAMM.', 1;
    IF CONVERT(CHAR(6), @fecha, 112) <> @periodo
        THROW 50001, 'LUM: la fecha del comprobante debe pertenecer al periodo de la liquidacion.', 1;

    -- Caja abierta
    IF NOT EXISTS (SELECT 1 FROM dbo.detanrocaja WHERE id = @iddetanrocaja AND LEFT(switch, 1) <> '1')
        THROW 50001, 'LUM: la caja no existe o esta cerrada.', 1;

    -- Ejercicio contable del periodo (como DevolverEjercicioContable)
    SET @desde = @periodo + '01';
    SELECT TOP 1 @idejercicio = id FROM dbo.detaconta WHERE fecdesde <= @desde AND @desde <= fechasta;
    IF @idejercicio IS NULL
        THROW 50001, 'LUM: el periodo no pertenece a ningun ejercicio contable.', 1;

    -- Cuentas contables (paraconta del ejercicio)
    SELECT @idctaZZ = MAX(CASE WHEN numero = 3  THEN idcuenta ELSE 0 END),
           @idctaRI = MAX(CASE WHEN numero = 7  THEN idcuenta ELSE 0 END),
           @idctaRB = MAX(CASE WHEN numero = 9  THEN idcuenta ELSE 0 END),
           @idctaIG = MAX(CASE WHEN numero = 13 THEN idcuenta ELSE 0 END),
           @idctaNG = MAX(CASE WHEN numero = 19 THEN idcuenta ELSE 0 END)
    FROM dbo.paraconta
    WHERE idejercicio = @idejercicio AND numero IN (3, 7, 9, 13, 19);
    IF ISNULL(@idctaZZ, 0) = 0 OR ISNULL(@idctaRI, 0) = 0 OR ISNULL(@idctaRB, 0) = 0
       OR ISNULL(@idctaIG, 0) = 0 OR ISNULL(@idctaNG, 0) = 0
        THROW 50001, 'LUM: faltan cuentas en parametros contables del ejercicio (3 proveedores, 7 ret. IVA, 9 ret. IIBB, 13 IVA credito, 19 compra).', 1;

    -- Importes: neto = total + iva - retenciones
    IF ISNULL(@total, 0) <= 0
        THROW 50001, 'LUM: el total de la liquidacion debe ser mayor a cero.', 1;
    IF ISNULL(@iva, 0) < 0 OR ISNULL(@periva, 0) < 0 OR ISNULL(@periibb, 0) < 0
        THROW 50001, 'LUM: los importes de IVA y retenciones no pueden ser negativos.', 1;
    IF ABS(@total + @iva - @periva - @periibb - @neto) > 0.01
        THROW 50001, 'LUM: el neto no coincide con total + IVA - retenciones.', 1;

    -- Tambo: el de la liquidacion (F) o el de menor numero de la cuenta (mismo criterio que el form)
    IF @tipoform = 'F' AND ISNULL(@idliqlacteo, 0) <> 0
    BEGIN
        -- mismo criterio que el form (buscarliqlacteo): la cuenta es la del tambo
        SELECT @idtambo = l.idtambo
        FROM dbo.liqlacteo l
        INNER JOIN dbo.tambo tb ON tb.id = l.idtambo
        WHERE l.id = @idliqlacteo AND tb.idctacte = @idctacte AND ISNULL(l.idmaopera, 0) = 0;
        IF @idtambo IS NULL
            THROW 50001, 'LUM: la liquidacion lactea no existe, es de otra cuenta o ya fue emitida.', 1;
    END
    ELSE
        SELECT TOP 1 @idtambo = id FROM dbo.tambo WHERE idctacte = @idctacte ORDER BY numero;
    IF @idtambo IS NULL
        THROW 50001, 'LUM: la cuenta corriente no tiene un tambo asociado.', 1;

    -- M (manual): la LUM ya fue emitida en el portal de ARCA, se registra con su CAE
    IF @tipoform = 'M'
    BEGIN
        IF LEN(LTRIM(RTRIM(ISNULL(@cae, '')))) <> 14 OR @cae LIKE '%[^0-9]%'
            THROW 50001, 'LUM: el CAE debe tener 14 digitos.', 1;
        IF @vtocae IS NULL
            THROW 50001, 'LUM: falta el vencimiento del CAE.', 1;
    END

    -- Una sola LUM por cuenta (tambo) y periodo, como ARCA (error 2078: unica por periodo, operador, productor
    -- y tambo, AUNQUE una NC la haya anulado por el total). Desactivada y REACTIVADA el 04/11/2026: sin esto
    -- el ERP grababa una LUM que ARCA rechazaba y quedaba sin numero tomando la liquidacion y la ctacte.
    -- No cuentan las anuladas en el ERP (estado 1: nunca llegaron a ARCA). La correccion va con ND / NC.
    IF @clase = 'A' AND EXISTS (
        SELECT 1 FROM dbo.cabeLiq cl
        INNER JOIN dbo.maopera m ON m.id = cl.idmaopera
        WHERE cl.idctacte = @idctacte AND cl.pefiscal = @periodo
          AND m.idcomproba = @idcomproba AND m.estado <> '1')
        THROW 50001, 'LUM: ya hay una liquidacion de la cuenta en el periodo (ARCA admite una sola). Corregir con ND o NC.', 1;

    -- NC / ND: liquidacion original (existente, misma cuenta, no anulada) y tipo de ajuste
    SET @caeajuste = NULL;
    IF @clase IN ('B', 'C')
    BEGIN
        SELECT @caeajuste = ISNULL(cl.cae, '')
        FROM dbo.cabeLiq cl
        INNER JOIN dbo.maopera m ON m.id = cl.idmaopera
        INNER JOIN dbo.comprobante c ON c.id = m.idcomproba
        WHERE cl.idmaopera = @idmaoperaliq AND cl.idctacte = @idctacte AND m.estado <> '1' AND c.clase = 'A';
        IF @caeajuste IS NULL
            THROW 50001, 'LUM: la liquidacion original no existe, es de otra cuenta o esta anulada.', 1;
        IF ISNULL(LTRIM(@tipoajuste), '') = ''
            THROW 50001, 'LUM: falta el tipo de ajuste de la nota de credito / debito.', 1;
    END
END
GO

-- ------------------------------------------------------------
-- 2) maopera
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_maopera
    @prefijo        VARCHAR(2),
    @idcomproba     INT,
    @clase          CHAR(1),
    @numcomp        CHAR(13),
    @idctacte       INT,
    @programa       VARCHAR(15),
    @sucursal       NUMERIC(3,0),
    @terminal       NUMERIC(3,0),
    @sector         NUMERIC(2,0),
    @idoperador     INT,
    @idvendedor     INT,
    @iddetanrocaja  INT,
    @turno          NUMERIC(2,0),
    @puestocaja     NUMERIC(3,0),
    @idcotizadolar  INT,
    @idmaopera      NUMERIC(12,0) OUTPUT,
    @detalle        VARCHAR(80)   OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- (04/11/2026) F llega como letra + pto vta + 00000000 (validar toma la letra de ahi) y se graba
    -- con numcomp VACIO hasta que ARCA la autorice (sp_gms_liqlactea_cae pone el numero).
    IF RIGHT(@numcomp, 8) = '00000000' SET @numcomp = '';

    -- Detalle como VFP: abreviatura + numero + ' - ' + nombre de la cuenta (sin numero: abreviatura + ' - ' + nombre)
    SELECT @detalle = RTRIM(c.cabrevia) + CASE WHEN RTRIM(@numcomp) = '' THEN '' ELSE ' ' + RTRIM(@numcomp) END
                      + ' - ' + RTRIM(ct.cnombre)
    FROM dbo.comprobante c CROSS JOIN dbo.ctacte ct
    WHERE c.id = @idcomproba AND ct.id = @idctacte;

    EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'maopera', @prefijo = @prefijo, @id = @idmaopera OUTPUT;

    INSERT INTO dbo.maopera (id, origen, programa, sucursal, terminal, sector, fechasis, idoperador, idvendedor,
                             iddetanrocaja, idcomproba, numcomp, clasecomp, turno, puestocaja, idcotizadolar,
                             switch, estado, detalle, fechaserver)
    VALUES (@idmaopera, 'LUM', LEFT(@programa, 15), @sucursal, @terminal, @sector, CAST(CAST(GETDATE() AS DATE) AS DATETIME),
            @idoperador, ISNULL(@idvendedor, 0), @iddetanrocaja, @idcomproba, @numcomp, @clase, @turno, @puestocaja, @idcotizadolar,
            '00000', '0', LEFT(@detalle, 40), GETDATE());
END
GO

-- ------------------------------------------------------------
-- 3) cabeLiq (cabeza de la liquidacion: cuenta, tambo, leche, totales, CAE, liquidacion original)
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_cabeliq
    @prefijo        VARCHAR(2),
    @idmaopera      NUMERIC(12,0),
    @idctacte       INT,
    @idtambo        INT,
    @fecha          DATE,
    @periodo        CHAR(6),
    @signo          INT,
    @ptovta         NUMERIC(4,0),
    @litros         NUMERIC(13,2),
    @grasa          NUMERIC(7,2),
    @proteina       NUMERIC(7,2),
    @kggrasa        NUMERIC(15,2),
    @kgproteina     NUMERIC(15,2),
    @total          NUMERIC(15,2),
    @pctiva         NUMERIC(5,2),
    @iva            NUMERIC(15,2),
    @periva         NUMERIC(15,2),
    @periibb        NUMERIC(15,2),
    @neto           NUMERIC(15,2),
    @cae            CHAR(14),
    @vtocae         DATE,
    @idmaoperaliq   NUMERIC(12,0),
    @caeajuste      CHAR(14),
    @tipoajuste     CHAR(10),
    @idtipocbte     INT,
    @idcabeliq      NUMERIC(12,0) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sinfecha DATETIME = '19000101';
    DECLARE @tienecae BIT = CASE WHEN LEN(LTRIM(RTRIM(ISNULL(@cae, '')))) = 14 THEN 1 ELSE 0 END;

    EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'cabeliq', @prefijo = @prefijo, @id = @idcabeliq OUTPUT;

    INSERT INTO dbo.cabeLiq (id, idmaopera, idctacte, ctacte, cnombre, cdireccion, cpostal, idlocalidad, idprovincia,
                             idtipoiva, cuit, iibb, idplanpago, fecha, pefiscal, renspa, vtobrucelosis, vtotuberculosis,
                             lat, lng, cidiretambo, partido, cpostaltambo, codlocarca, idprovinciatambo,
                             litros, grasa, proteina, alicuotaiva, t_kilos, t_impuestos, t_iva, t_neto, total,
                             switch, signo, infocae, cae, talonario, IdTipoCbte, vtocae, CAEtipo, recodevol, idzona, iddeposito,
                             idmaoperaliq, caeajuste, tipoajuste)
    SELECT @idcabeliq, @idmaopera, ct.id, LEFT(ISNULL(ct.cnumero, ''), 6), LEFT(ISNULL(ct.cnombre, ''), 35),
           LEFT(ISNULL(ct.cdireccion, ''), 25), LEFT(ISNULL(ct.cpostal, ''), 8), ISNULL(ct.idlocalidad, 0),
           ISNULL(ct.idprovincia, 0), ISNULL(ct.tipoiva, 0), LEFT(ISNULL(ct.cuit, ''), 13),
           LEFT(ISNULL(t.iibb, ''), 20), ISNULL(ct.idplanpago, 0), CAST(@fecha AS DATETIME), @periodo,
           LEFT(ISNULL(t.renspa, ''), 20), ISNULL(t.vtobrucelosis, @sinfecha), ISNULL(t.vtotuberculosis, @sinfecha),
           LEFT(ISNULL(t.lat, ''), 25), LEFT(ISNULL(t.lng, ''), 25), LEFT(ISNULL(t.domicilio, ''), 100),
           LEFT(ISNULL(t.partido, ''), 100), ISNULL(t.cpostal, 0), ISNULL(t.codlocarca, 0), ISNULL(t.idprovincia, 0),
           @litros, @grasa, @proteina, @pctiva, @kggrasa + @kgproteina, @periva + @periibb, @iva, @total, @neto,
           '00000', @signo, CASE WHEN @tienecae = 1 THEN 1 END, NULLIF(@cae, ''), @ptovta, @idtipocbte,
           CASE WHEN @tienecae = 1 THEN CAST(@vtocae AS DATETIME) END, CASE WHEN @tienecae = 1 THEN 'CAE' END,
           0, 0, 0,
           NULLIF(@idmaoperaliq, 0), NULLIF(@caeajuste, ''), NULLIF(@tipoajuste, '')
    FROM dbo.ctacte ct
    LEFT JOIN dbo.tambo t ON t.id = @idtambo
    WHERE ct.id = @idctacte;
END
GO

-- ------------------------------------------------------------
-- 4) Cuenta corriente: movctacte por el NETO (una cuota) + ctacte.saldo (como grabarmovcte).
--    Si la cuenta es sucursal de otra, el movimiento va a la central (como cambioctacte).
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_ctacte
    @prefijo        VARCHAR(2),
    @idmaopera      NUMERIC(12,0),
    @idctacte       INT,
    @fecha          DATE,
    @periodo        CHAR(6),
    @signo          INT,
    @neto           NUMERIC(15,2),
    @detalle        VARCHAR(80),
    @idmovctacte    NUMERIC(12,0) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @idcta INT = @idctacte, @cnumero CHAR(6), @subnumero CHAR(6) = '', @idsubcta INT = 0, @idcentral INT;

    SELECT @idcentral = s.idcentral FROM dbo.sucursal s WHERE s.idsucursal = @idctacte;
    IF ISNULL(@idcentral, 0) <> 0
    BEGIN
        SELECT @subnumero = cnumero FROM dbo.ctacte WHERE id = @idctacte;
        SET @idsubcta = @idctacte;
        SET @idcta    = @idcentral;
    END
    SELECT @cnumero = cnumero FROM dbo.ctacte WHERE id = @idcta;

    EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'movctacte', @prefijo = @prefijo, @id = @idmovctacte OUTPUT;

    INSERT INTO dbo.movctacte (id, idmaopera, fecha, ctacte, idctacte, subnumero, idsubcta, cuota, importe, saldo, entrega,
                               vencimien, total, detalle, pefiscal, switch, signo)
    VALUES (@idmovctacte, @idmaopera, CAST(@fecha AS DATETIME), ISNULL(@cnumero, ''), @idcta, ISNULL(@subnumero, ''), @idsubcta,
            1, @neto, @neto, 0, CAST(@fecha AS DATETIME), @neto, LEFT(@detalle, 30), @periodo, '00000', @signo);

    UPDATE dbo.ctacte SET saldo = saldo + @neto * @signo
    WHERE id = @idcta AND ISNULL(NoAcumuSaldo, 0) = 0;
END
GO

-- ------------------------------------------------------------
-- 5) Asiento: cabeasi + tablaasi. Devuelve el id de cada linea para tablaimp.
--    Linea en 0: no se graba (como grabartabasi).
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_asiento
    @prefijo        VARCHAR(2),
    @idmaopera      NUMERIC(12,0),
    @idcabeliq      NUMERIC(12,0),
    @idmovctacte    NUMERIC(12,0),
    @idejercicio    INT,
    @fecha          DATE,
    @signo          INT,
    @detalle        VARCHAR(80),
    @idctaNG        INT,
    @idctaIG        INT,
    @idctaRI        INT,
    @idctaRB        INT,
    @idctaZZ        INT,
    @total          NUMERIC(15,2),
    @iva            NUMERIC(15,2),
    @periva         NUMERIC(15,2),
    @periibb        NUMERIC(15,2),
    @neto           NUMERIC(15,2),
    @idasiNG        NUMERIC(12,0) OUTPUT,
    @idasiIG        NUMERIC(12,0) OUTPUT,
    @idasiRI        NUMERIC(12,0) OUTPUT,
    @idasiRB        NUMERIC(12,0) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @idcabeasi NUMERIC(12,0), @numero NUMERIC(12,0), @id NUMERIC(12,0);
    -- Lado de la compra (NG / IG) y lado de la cuenta corriente (ZZ / retenciones)
    DECLARE @dhCompra CHAR(1) = CASE WHEN @signo = -1 THEN 'D' ELSE 'H' END;
    DECLARE @dhCtacte CHAR(1) = CASE WHEN @signo = -1 THEN 'H' ELSE 'D' END;
    DECLARE @l TABLE (orden INT, tipoconce CHAR(2), idcuenta INT, debehaber CHAR(1), importe NUMERIC(16,2),
                      tablaori CHAR(4), idorigen NUMERIC(12,0), detalle VARCHAR(40), id NUMERIC(12,0));
    DECLARE @orden INT;

    SELECT @idasiNG = 0, @idasiIG = 0, @idasiRI = 0, @idasiRB = 0;

    -- Cabeza: numero siguiente del ejercicio (bloqueado hasta el fin de la transaccion)
    SELECT @numero = ISNULL(MAX(numero), 0) + 1 FROM dbo.cabeasi WITH (UPDLOCK, HOLDLOCK) WHERE idejercicio = @idejercicio;
    EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'cabeasi', @prefijo = @prefijo, @id = @idcabeasi OUTPUT;
    INSERT INTO dbo.cabeasi (id, idmaopera, idejercicio, numero, fecha, tipoasi, detalle, fechacarga, estado, switch)
    VALUES (@idcabeasi, @idmaopera, @idejercicio, @numero, CAST(@fecha AS DATETIME), 'C', LEFT(@detalle, 50),
            CAST(CAST(GETDATE() AS DATE) AS DATETIME), 0, '00000');

    -- Lineas (detalle: el de la operacion para compra y tambo, el nombre del parametro para impuestos)
    INSERT INTO @l (orden, tipoconce, idcuenta, debehaber, importe, tablaori, idorigen, detalle)
    SELECT 1, 'ZZ', @idctaZZ, @dhCtacte, @neto,    'MOCT', @idmovctacte, LEFT(@detalle, 40) UNION ALL
    SELECT 2, 'NG', @idctaNG, @dhCompra, @total,   'FLUM', @idcabeliq,   LEFT(@detalle, 40) UNION ALL
    SELECT 3, 'IG', @idctaIG, @dhCompra, @iva,     'FLUM', @idcabeliq,   NULL UNION ALL
    SELECT 4, 'RI', @idctaRI, @dhCtacte, @periva,  'FLUM', @idcabeliq,   NULL UNION ALL
    SELECT 5, 'RB', @idctaRB, @dhCtacte, @periibb, 'FLUM', @idcabeliq,   NULL;
    UPDATE l SET detalle = LEFT(RTRIM(p.cnombre), 40)
    FROM @l l
    INNER JOIN dbo.paraconta p ON p.idejercicio = @idejercicio
           AND p.numero = CASE l.tipoconce WHEN 'IG' THEN 13 WHEN 'RI' THEN 7 WHEN 'RB' THEN 9 END
    WHERE l.detalle IS NULL;
    UPDATE @l SET detalle = LEFT(@detalle, 40) WHERE detalle IS NULL;
    DELETE FROM @l WHERE importe = 0;

    IF (SELECT SUM(CASE debehaber WHEN 'D' THEN importe ELSE -importe END) FROM @l) <> 0
        THROW 50001, 'LUM: el asiento no balancea (debe distinto de haber).', 1;

    -- Un id por linea (en orden)
    SELECT @orden = MIN(orden) FROM @l;
    WHILE @orden IS NOT NULL
    BEGIN
        EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'tablaasi', @prefijo = @prefijo, @id = @id OUTPUT;
        UPDATE @l SET id = @id WHERE orden = @orden;
        SELECT @orden = MIN(orden) FROM @l WHERE orden > @orden;
    END

    INSERT INTO dbo.tablaasi (id, idmaopera, idorigen, tablaori, idcuenta, tipoconce, debehaber, importe, detalle)
    SELECT id, @idmaopera, idorigen, tablaori, idcuenta, tipoconce, debehaber, importe, detalle FROM @l ORDER BY orden;

    SELECT @idasiNG = ISNULL(MAX(CASE WHEN tipoconce = 'NG' THEN id ELSE 0 END), 0),
           @idasiIG = ISNULL(MAX(CASE WHEN tipoconce = 'IG' THEN id ELSE 0 END), 0),
           @idasiRI = ISNULL(MAX(CASE WHEN tipoconce = 'RI' THEN id ELSE 0 END), 0),
           @idasiRB = ISNULL(MAX(CASE WHEN tipoconce = 'RB' THEN id ELSE 0 END), 0)
    FROM @l;
END
GO

-- ------------------------------------------------------------
-- 6) Impuestos: tablaimp (NG, IG con tasa y base, RI y RB con tasa y base), cada uno con su linea
--    del asiento. Importe en 0: no se graba, salvo IG (como grabartabimp).
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_impuestos
    @prefijo        VARCHAR(2),
    @idmaopera      NUMERIC(12,0),
    @idcabeliq      NUMERIC(12,0),
    @idejercicio    INT,
    @idctacte       INT,
    @detalle        VARCHAR(80),
    @idctaNG        INT,
    @idctaIG        INT,
    @idctaRI        INT,
    @idctaRB        INT,
    @idasiNG        NUMERIC(12,0),
    @idasiIG        NUMERIC(12,0),
    @idasiRI        NUMERIC(12,0),
    @idasiRB        NUMERIC(12,0),
    @total          NUMERIC(15,2),
    @pctiva         NUMERIC(9,6),
    @iva            NUMERIC(15,2),
    @baseperiva     NUMERIC(15,2),
    @pctperiva      NUMERIC(9,6),
    @periva         NUMERIC(15,2),
    @baseperiibb    NUMERIC(15,2),
    @pctperiibb     NUMERIC(9,6),
    @periibb        NUMERIC(15,2)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @idprovincia INT = (SELECT ISNULL(idprovincia, 0) FROM dbo.ctacte WHERE id = @idctacte);
    DECLARE @l TABLE (orden INT, tipoconce CHAR(2), idcuenta INT, idasiento NUMERIC(12,0), importe NUMERIC(16,3),
                      tasa NUMERIC(9,6), baseimp NUMERIC(16,3), detalle VARCHAR(30), id NUMERIC(12,0));
    DECLARE @orden INT, @id NUMERIC(12,0);

    INSERT INTO @l (orden, tipoconce, idcuenta, idasiento, importe, tasa, baseimp, detalle)
    SELECT 1, 'IG', @idctaIG, @idasiIG, @iva,     @pctiva,     @total,       NULL UNION ALL
    SELECT 2, 'RI', @idctaRI, @idasiRI, @periva,  @pctperiva,  @baseperiva,  NULL UNION ALL
    SELECT 3, 'RB', @idctaRB, @idasiRB, @periibb, @pctperiibb, @baseperiibb, NULL UNION ALL
    SELECT 4, 'NG', @idctaNG, @idasiNG, @total,   0,           0,            LEFT(@detalle, 30);
    UPDATE l SET detalle = LEFT(RTRIM(p.cnombre), 30)
    FROM @l l
    INNER JOIN dbo.paraconta p ON p.idejercicio = @idejercicio
           AND p.numero = CASE l.tipoconce WHEN 'IG' THEN 13 WHEN 'RI' THEN 7 WHEN 'RB' THEN 9 END
    WHERE l.detalle IS NULL;
    UPDATE @l SET detalle = LEFT(@detalle, 30) WHERE detalle IS NULL;
    DELETE FROM @l WHERE importe = 0 AND tipoconce <> 'IG';

    SELECT @orden = MIN(orden) FROM @l;
    WHILE @orden IS NOT NULL
    BEGIN
        EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'tablaimp', @prefijo = @prefijo, @id = @id OUTPUT;
        UPDATE @l SET id = @id WHERE orden = @orden;
        SELECT @orden = MIN(orden) FROM @l WHERE orden > @orden;
    END

    INSERT INTO dbo.tablaimp (id, idmaopera, idorigen, tablaori, idasiento, idcuenta, tipoconce, importe, tasa, baseimp,
                              nombre, detalle, idprovincia)
    SELECT id, @idmaopera, @idcabeliq, 'FLUM', idasiento, idcuenta, tipoconce, importe, tasa, baseimp,
           '', detalle, @idprovincia
    FROM @l ORDER BY orden;
END
GO

-- ------------------------------------------------------------
-- MAESTRO
-- ------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_grabar
    -- Comprobante y operacion (lo que VFP ya tiene en CsrAuxMaopera / goapp)
    @prefijo        VARCHAR(2),       -- STR(goapp.sucursal10+10,2); '' si goapp.sucursal10 = 0
    @idcomproba     INT,
    @numcomp        CHAR(13),         -- letra + pto vta (4) + numero (8)
    @ptovta         NUMERIC(4,0),
    @fecha          DATE,
    @periodo        CHAR(6),          -- AAAAMM
    @idctacte       INT,
    @tipoform       CHAR(1),          -- F normal (de liqlacteo) / M manual (LUM emitida en el portal)
    @idliqlacteo    NUMERIC(12,0),    -- F: liqlacteo.id; M: 0
    @programa       VARCHAR(15),
    @sucursal       NUMERIC(3,0),
    @terminal       NUMERIC(3,0),
    @sector         NUMERIC(2,0),
    @idoperador     INT,
    @idvendedor     INT,
    @iddetanrocaja  INT,
    @turno          NUMERIC(2,0),
    @puestocaja     NUMERIC(3,0),
    @idcotizadolar  INT,
    -- Datos de la liquidacion (LiqDatos)
    @litros         NUMERIC(13,2),
    @grasa          NUMERIC(7,2),
    @proteina       NUMERIC(7,2),
    @kggrasa        NUMERIC(15,2),
    @kgproteina     NUMERIC(15,2),
    @total          NUMERIC(15,2),
    @pctiva         NUMERIC(5,2),
    @iva            NUMERIC(15,2),
    @baseperiva     NUMERIC(15,2),
    @pctperiva      NUMERIC(9,6),
    @periva         NUMERIC(15,2),
    @baseperiibb    NUMERIC(15,2),
    @pctperiibb     NUMERIC(9,6),
    @periibb        NUMERIC(15,2),
    @neto           NUMERIC(15,2),
    @cae            CHAR(14),
    @vtocae         DATE,
    -- NC / ND
    @idmaoperaliq   NUMERIC(12,0),
    @tipoajuste     CHAR(10),
    -- Salida
    @idmaopera      NUMERIC(12,0) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @idmaopera = 0;

    DECLARE @clase CHAR(1), @signo INT, @idejercicio INT, @idtambo INT, @caeajuste CHAR(14),
            @idctaNG INT, @idctaIG INT, @idctaRI INT, @idctaRB INT, @idctaZZ INT,
            @detalle VARCHAR(80), @idcabeliq NUMERIC(12,0), @idmovctacte NUMERIC(12,0),
            @idasiNG NUMERIC(12,0), @idasiIG NUMERIC(12,0), @idasiRI NUMERIC(12,0), @idasiRB NUMERIC(12,0),
            @idnuevo NUMERIC(12,0), @idtipocbte INT;
    DECLARE @propia BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;

    IF ISNULL(@prefijo, '') <> '' AND @prefijo NOT LIKE '[0-9][0-9]'
        THROW 50001, 'LUM: el prefijo de sucursal debe tener 2 digitos.', 1;

    BEGIN TRY
        IF @propia = 1 BEGIN TRANSACTION;

        EXEC dbo.sp_gms_liqlactea_validar
             @idcomproba, @numcomp, @fecha, @periodo, @idctacte, @iddetanrocaja, @tipoform, @idliqlacteo,
             @total, @iva, @periva, @periibb, @neto, @cae, @vtocae, @idmaoperaliq, @tipoajuste,
             @clase OUTPUT, @signo OUTPUT, @idejercicio OUTPUT,
             @idctaNG OUTPUT, @idctaIG OUTPUT, @idctaRI OUTPUT, @idctaRB OUTPUT, @idctaZZ OUTPUT,
             @idtambo OUTPUT, @caeajuste OUTPUT, @idtipocbte OUTPUT;

        EXEC dbo.sp_gms_liqlactea_maopera
             @prefijo, @idcomproba, @clase, @numcomp, @idctacte, @programa, @sucursal, @terminal, @sector,
             @idoperador, @idvendedor, @iddetanrocaja, @turno, @puestocaja, @idcotizadolar,
             @idnuevo OUTPUT, @detalle OUTPUT;

        EXEC dbo.sp_gms_liqlactea_cabeliq
             @prefijo, @idnuevo, @idctacte, @idtambo, @fecha, @periodo, @signo, @ptovta,
             @litros, @grasa, @proteina, @kggrasa, @kgproteina, @total, @pctiva, @iva, @periva, @periibb, @neto,
             @cae, @vtocae, @idmaoperaliq, @caeajuste, @tipoajuste, @idtipocbte,
             @idcabeliq OUTPUT;

        EXEC dbo.sp_gms_liqlactea_ctacte
             @prefijo, @idnuevo, @idctacte, @fecha, @periodo, @signo, @neto, @detalle,
             @idmovctacte OUTPUT;

        EXEC dbo.sp_gms_liqlactea_asiento
             @prefijo, @idnuevo, @idcabeliq, @idmovctacte, @idejercicio, @fecha, @signo, @detalle,
             @idctaNG, @idctaIG, @idctaRI, @idctaRB, @idctaZZ,
             @total, @iva, @periva, @periibb, @neto,
             @idasiNG OUTPUT, @idasiIG OUTPUT, @idasiRI OUTPUT, @idasiRB OUTPUT;

        EXEC dbo.sp_gms_liqlactea_impuestos
             @prefijo, @idnuevo, @idcabeliq, @idejercicio, @idctacte, @detalle,
             @idctaNG, @idctaIG, @idctaRI, @idctaRB,
             @idasiNG, @idasiIG, @idasiRI, @idasiRB,
             @total, @pctiva, @iva, @baseperiva, @pctperiva, @periva, @baseperiibb, @pctperiibb, @periibb;

        -- F: la liquidacion lactea queda emitida con este comprobante
        IF @tipoform = 'F' AND ISNULL(@idliqlacteo, 0) <> 0
        BEGIN
            UPDATE dbo.liqlacteo SET idmaopera = @idnuevo WHERE id = @idliqlacteo AND ISNULL(idmaopera, 0) = 0;
            IF @@ROWCOUNT = 0
                THROW 50001, 'LUM: la liquidacion lactea ya fue emitida por otro comprobante.', 1;
        END

        IF @propia = 1 COMMIT TRANSACTION;
        SET @idmaopera = @idnuevo;
    END TRY
    BEGIN CATCH
        -- Solo se deshace la transaccion propia; la de VFP la deshace VFP al recibir el error
        IF @propia = 1 AND @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
