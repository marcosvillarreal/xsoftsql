-- ============================================================
-- El Calden - Anulacion (borrar) de una LUM / NC / ND (29/10/2026). Solo elcalden.
-- Lo llama VFP (forms\liqlactea\regfaclum_vai, grabarborrado) con odata.ejecutarsp.
-- Definido con el usuario:
--   - Solo se puede borrar un comprobante SIN CAE (F grabada sin numero que ARCA no autorizo).
--     Con CAE no se borra: corresponde una nota de credito.
--   - Las validaciones de pantalla las hace VFP antes de llamar; el SP las repite por seguridad.
--   - Mismo resultado que la anulacion de VFP (actualizafac.borroasto / borromovctacte), tomado de una
--     anulacion real de elcalden (110000016561 -> 110000016577):
--       maopera original estado '1'; maopera nueva = copia con el comprobante de anulacion (clase K),
--       caja y fecha contable de la caja (actualizafac.controlcajaactiva en VFP); anmaopera (idmaopera = anulacion, idafecta = original);
--       movctacte 'ANULACION' con el signo invertido por importe - entrega, saldo 0 la original,
--       afectacte (iddebe = original, idhaber = anulacion) y ctacte.saldo;
--       asiento nuevo ('Anula ...') con las lineas de la original y debe / haber invertidos.
--       tablaimp no se toca (como VFP).
--   - Libera la liquidacion lactea de origen (liqlacteo.idmaopera = 0) para volver a emitirla.
-- Transaccion: igual que sp_gms_liqlactea_grabar (dentro de la de VFP si hay; si no, propia).
-- Requiere sp_gms_liqlactea_grabar.sql (sp_gms_liqlactea_nuevoid). Literales solo ASCII.
-- ============================================================
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_anular
    @prefijo          VARCHAR(2),       -- STR(goapp.sucursal10+10,2); '' si goapp.sucursal10 = 0
    @idmaopera        NUMERIC(12,0),    -- comprobante a anular
    @idcompanulacion  INT,              -- comprobante de anulacion (thisform.idcompanulacion, clase K)
    @programa         VARCHAR(15),
    @terminal         NUMERIC(3,0),
    @idoperador       INT,
    @iddetanrocaja    INT,              -- caja (la de la operacion o la proxima abierta: controlcajaactiva)
    @fecha            DATE,             -- fecha contable = fecdesde de esa caja (controlcajaactiva)
    @idanula          NUMERIC(12,0) OUTPUT   -- maopera de la anulacion
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET @idanula = 0;

    DECLARE @propia BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;
    DECLARE @hoy DATE = @fecha, @numcomp CHAR(13), @cae VARCHAR(14), @detalle VARCHAR(40),
            @idejercicio INT, @pefiscal CHAR(6), @idcabeasi NUMERIC(12,0), @numero NUMERIC(12,0),
            @idmovorig NUMERIC(12,0), @idmovanula NUMERIC(12,0), @idctacte INT, @signo INT,
            @pendiente NUMERIC(15,2), @id NUMERIC(12,0), @idafecta NUMERIC(12,0);
    DECLARE @l TABLE (orden INT IDENTITY(1,1), idorigen NUMERIC(12,0), tablaori CHAR(4), idcuenta INT, tipoconce CHAR(2),
                      debehaber CHAR(1), importe NUMERIC(16,2), id NUMERIC(12,0));
    DECLARE @orden INT;

    IF @fecha IS NULL
        THROW 50001, 'LUM: falta la fecha contable de la anulacion.', 1;
    IF ISNULL(@prefijo, '') <> '' AND @prefijo NOT LIKE '[0-9][0-9]'
        THROW 50001, 'LUM: el prefijo de sucursal debe tener 2 digitos.', 1;

    BEGIN TRY
        IF @propia = 1 BEGIN TRANSACTION;

        -- Validaciones
        SELECT @numcomp = m.numcomp, @cae = LTRIM(RTRIM(ISNULL(c.cae, ''))), @detalle = m.detalle
        FROM dbo.maopera m WITH (UPDLOCK)
        INNER JOIN dbo.cabeLiq c ON c.idmaopera = m.id
        WHERE m.id = @idmaopera AND m.origen = 'LUM' AND m.estado = '0';
        IF @numcomp IS NULL
            THROW 50001, 'LUM: el comprobante no existe, no es una LUM o ya esta anulado.', 1;
        IF @cae <> '' OR RIGHT(@numcomp, 8) <> '00000000'
            THROW 50001, 'LUM: el comprobante tiene CAE: no se puede borrar (corresponde una nota de credito).', 1;
        IF EXISTS (SELECT 1 FROM dbo.afectacte WHERE idmaoperad = @idmaopera OR idmaoperah = @idmaopera)
            THROW 50001, 'LUM: el comprobante esta afectado a otro (imputado en la cuenta corriente).', 1;
        IF EXISTS (SELECT 1 FROM dbo.cabeLiq c INNER JOIN dbo.maopera m ON m.id = c.idmaopera
                   WHERE c.idmaoperaliq = @idmaopera AND m.estado <> '1')
            THROW 50001, 'LUM: la liquidacion tiene notas de credito / debito activas.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.comprobante WHERE id = @idcompanulacion AND clase = 'K')
            THROW 50001, 'LUM: el comprobante de anulacion no existe o no es de clase K.', 1;
        IF NOT EXISTS (SELECT 1 FROM dbo.detanrocaja WHERE id = @iddetanrocaja AND LEFT(switch, 1) <> '1')
            THROW 50001, 'LUM: la caja no existe o esta cerrada.', 1;
        SELECT TOP 1 @idejercicio = id FROM dbo.detaconta
        WHERE fecdesde <= CONVERT(CHAR(8), @hoy, 112) AND CONVERT(CHAR(8), @hoy, 112) <= fechasta;
        IF @idejercicio IS NULL
            THROW 50001, 'LUM: la fecha de la caja no pertenece a ningun ejercicio contable.', 1;
        SELECT TOP 1 @pefiscal = pefiscal FROM dbo.paraconfig;
        SET @pefiscal = ISNULL(NULLIF(LTRIM(@pefiscal), ''), CONVERT(CHAR(6), @hoy, 112));

        -- 1) Operacion: original anulada + anulacion (copia con el comprobante K) + anmaopera
        UPDATE dbo.maopera SET estado = '1' WHERE id = @idmaopera;

        EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'maopera', @prefijo = @prefijo, @id = @idanula OUTPUT;
        INSERT INTO dbo.maopera (id, origen, programa, sucursal, terminal, sector, fechasis, idoperador, idvendedor,
                                 iddetanrocaja, idcomproba, numcomp, clasecomp, turno, puestocaja, idcotizadolar,
                                 switch, estado, detalle, fechaserver)
        SELECT @idanula, origen, LEFT(@programa, 15), sucursal, @terminal, sector, CAST(@hoy AS DATETIME), @idoperador,
               idvendedor, @iddetanrocaja, @idcompanulacion, numcomp, 'K', turno, puestocaja, idcotizadolar,
               switch, '0', detalle, GETDATE()
        FROM dbo.maopera WHERE id = @idmaopera;

        EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'anmaopera', @prefijo = @prefijo, @id = @id OUTPUT;
        INSERT INTO dbo.anmaopera (id, idmaopera, idafecta, detalle, idmotanula)
        VALUES (@id, @idanula, @idmaopera, @numcomp, 0);

        -- 2) Cuenta corriente: movimiento ANULACION por lo pendiente (importe - entrega), signo invertido
        SELECT @idmovorig = id, @idctacte = idctacte, @signo = signo, @pendiente = importe - entrega
        FROM dbo.movctacte WHERE idmaopera = @idmaopera;
        IF @idmovorig IS NOT NULL
        BEGIN
            EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'movctacte', @prefijo = @prefijo, @id = @idmovanula OUTPUT;
            INSERT INTO dbo.movctacte (id, idmaopera, fecha, ctacte, idctacte, subnumero, idsubcta, cuota, importe, saldo,
                                       entrega, vencimien, total, detalle, pefiscal, switch, signo)
            SELECT @idmovanula, @idanula, CAST(@hoy AS DATETIME), ctacte, idctacte, subnumero, idsubcta, 1, @pendiente, 0,
                   0, CAST(@hoy AS DATETIME), @pendiente, 'ANULACION', @pefiscal, switch, -signo
            FROM dbo.movctacte WHERE id = @idmovorig;

            UPDATE dbo.movctacte SET saldo = 0 WHERE id = @idmovorig;

            EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'afectacte', @prefijo = @prefijo, @id = @idafecta OUTPUT;
            INSERT INTO dbo.afectacte (id, idmaoperad, iddebe, idmaoperah, idhaber, importe)
            VALUES (@idafecta, @idmaopera, @idmovorig, @idanula, @idmovanula, @pendiente);

            UPDATE dbo.ctacte SET saldo = saldo - @pendiente * @signo
            WHERE id = @idctacte AND ISNULL(NoAcumuSaldo, 0) = 0;
        END

        -- 3) Asiento: lineas de la original con debe / haber invertidos
        INSERT INTO @l (idorigen, tablaori, idcuenta, tipoconce, debehaber, importe)
        SELECT idorigen, tablaori, idcuenta, tipoconce, CASE debehaber WHEN 'D' THEN 'H' ELSE 'D' END, importe
        FROM dbo.tablaasi WHERE idmaopera = @idmaopera ORDER BY id;
        IF EXISTS (SELECT 1 FROM @l)
        BEGIN
            SELECT @numero = ISNULL(MAX(numero), 0) + 1 FROM dbo.cabeasi WITH (UPDLOCK, HOLDLOCK) WHERE idejercicio = @idejercicio;
            EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'cabeasi', @prefijo = @prefijo, @id = @idcabeasi OUTPUT;
            INSERT INTO dbo.cabeasi (id, idmaopera, idejercicio, numero, fecha, tipoasi, detalle, fechacarga, estado, switch)
            VALUES (@idcabeasi, @idanula, @idejercicio, @numero, CAST(@hoy AS DATETIME), 'C', LEFT('Anula ' + RTRIM(@detalle), 50),
                    CAST(CAST(GETDATE() AS DATE) AS DATETIME), 0, '00000');

            SELECT @orden = MIN(orden) FROM @l;
            WHILE @orden IS NOT NULL
            BEGIN
                EXEC dbo.sp_gms_liqlactea_nuevoid @tabla = 'tablaasi', @prefijo = @prefijo, @id = @id OUTPUT;
                UPDATE @l SET id = @id WHERE orden = @orden;
                SELECT @orden = MIN(orden) FROM @l WHERE orden > @orden;
            END
            INSERT INTO dbo.tablaasi (id, idmaopera, idorigen, tablaori, idcuenta, tipoconce, debehaber, importe, detalle)
            SELECT id, @idanula, idorigen, tablaori, idcuenta, tipoconce, debehaber, importe, LEFT('Anula ' + RTRIM(@detalle), 40)
            FROM @l ORDER BY orden;
        END

        -- 4) Liquidacion lactea de origen: queda libre para volver a emitirla
        UPDATE dbo.liqlacteo SET idmaopera = 0 WHERE idmaopera = @idmaopera;

        IF @propia = 1 COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Solo se deshace la transaccion propia; la de VFP la deshace VFP al recibir el error
        IF @propia = 1 AND @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
