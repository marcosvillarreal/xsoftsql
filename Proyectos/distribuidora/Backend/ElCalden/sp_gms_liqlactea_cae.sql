-- ============================================================
-- El Calden - LUM autorizada por ARCA: graba el CAE y los importes que devolvio ARCA (29/10/2026).
-- Lo llama VFP (onegocio.vcx, ofacelectronica.grabardato_lum) despues de WSLUM.AutorizarLiquidacion
-- (o de consultar una ya autorizada).
--   1) Historico: lo que cargo el operador queda en cabeLiq.ori_* (solo la primera vez), con las
--      percepciones por separado (RI / RB de tablaimp) y el numero original de maopera.
--   2) maopera.numcomp = numero asignado por ARCA (control de repetido como el alta).
--   3) cabeLiq: CAE, vencimiento, tipo, infocae = 1, fecha de ARCA; movctacte.fecha.
--   4) Si vinieron importes (> 0): cabeLiq t_neto / t_iva / t_impuestos / total, tablaimp (NG, IG y su
--      base, RI, RB), tablaasi (ZZ, NG, IG, RI, RB), movctacte (importe, total, saldo) y ctacte.saldo por
--      la diferencia. El asiento tiene que balancear; si ARCA trae una percepcion que la LUM no tenia
--      (no existe la linea), se rechaza.
-- Nombres de importes iguales a sp_gms_liqlactea_grabar: @total = gravado (cabeLiq.t_neto),
-- @neto = a cobrar (cabeLiq.total).
-- Transaccion: igual que sp_gms_liqlactea_grabar (dentro de la de VFP si hay; si no, propia).
-- Requiere elcalden_cabeliq_originales.sql. Literales solo ASCII.
-- ============================================================
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE OR ALTER PROCEDURE dbo.sp_gms_liqlactea_cae
    @idmaopera      NUMERIC(12,0),
    @numcomp        CHAR(13),         -- letra + pto vta (4) + numero (8), el que asigno ARCA
    @fecha          DATE,             -- fechaComprobante de ARCA
    @cae            CHAR(14),
    @vtocae         DATE,
    @caetipo        CHAR(4) = 'CAE',
    -- Importes de ARCA (0 = no vinieron: quedan los del ERP)
    @total          NUMERIC(15,2) = 0, -- gravado (WSLUM.Total)
    @iva            NUMERIC(15,2) = 0, -- WSLUM.ImporteIVA
    @periva         NUMERIC(15,2) = 0, -- otro_impuesto 6
    @periibb        NUMERIC(15,2) = 0, -- otro_impuesto 7
    @neto           NUMERIC(15,2) = 0  -- a cobrar (WSLUM.TotalNeto)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @propia BIT = CASE WHEN @@TRANCOUNT = 0 THEN 1 ELSE 0 END;
    DECLARE @signo INT, @viejo NUMERIC(15,2), @idcta INT, @idcomproba INT, @numviejo CHAR(13);

    BEGIN TRY
        IF @propia = 1 BEGIN TRANSACTION;

        -- Validaciones
        IF LEN(LTRIM(RTRIM(ISNULL(@cae, '')))) <> 14 OR LTRIM(RTRIM(@cae)) LIKE '%[^0-9]%'
            THROW 50001, 'LUM: el CAE debe tener 14 digitos.', 1;

        SELECT @signo = c.signo, @viejo = c.total, @idcomproba = m.idcomproba
        FROM dbo.cabeLiq c
        INNER JOIN dbo.maopera m ON m.id = c.idmaopera
        WHERE c.idmaopera = @idmaopera AND m.origen = 'LUM' AND m.estado = '0' AND ISNULL(c.infocae, 0) = 0;
        IF @signo IS NULL
            THROW 50001, 'LUM: no existe la liquidacion a autorizar, esta anulada o ya tiene CAE.', 1;

        IF EXISTS (SELECT 1 FROM dbo.maopera WHERE idcomproba = @idcomproba AND numcomp = @numcomp
                   AND estado <> '1' AND id <> @idmaopera)
            THROW 50001, 'LUM: el numero asignado por ARCA ya esta grabado en otro comprobante.', 1;

        -- 1) Historico de lo que cargo el operador (solo la primera vez)
        UPDATE c SET ori_t_neto = c.t_neto, ori_t_iva = c.t_iva,
                     ori_periva = ISNULL(ri.importe, 0), ori_periibb = ISNULL(rb.importe, 0),
                     ori_total = c.total, ori_fecha = c.fecha, ori_numcomp = m.numcomp
        FROM dbo.cabeLiq c
        INNER JOIN dbo.maopera m ON m.id = c.idmaopera
        OUTER APPLY (SELECT SUM(importe) AS importe FROM dbo.tablaimp WHERE idmaopera = @idmaopera AND tipoconce = 'RI') ri
        OUTER APPLY (SELECT SUM(importe) AS importe FROM dbo.tablaimp WHERE idmaopera = @idmaopera AND tipoconce = 'RB') rb
        WHERE c.idmaopera = @idmaopera AND c.ori_total IS NULL;

        -- 2) y 3) Numero, CAE y fecha de ARCA.
        -- F se graba sin numero (00000000): el detalle de la operacion, la cuenta corriente y el asiento
        -- llevan ese numero y se reemplaza por el de ARCA.
        SELECT @numviejo = numcomp FROM dbo.maopera WHERE id = @idmaopera;
        IF @numviejo <> @numcomp
        BEGIN
            UPDATE dbo.maopera  SET detalle = REPLACE(detalle, RTRIM(@numviejo), RTRIM(@numcomp)) WHERE id = @idmaopera;
            UPDATE dbo.movctacte SET detalle = REPLACE(detalle, RTRIM(@numviejo), RTRIM(@numcomp)) WHERE idmaopera = @idmaopera;
            UPDATE dbo.cabeasi  SET detalle = REPLACE(detalle, RTRIM(@numviejo), RTRIM(@numcomp)) WHERE idmaopera = @idmaopera;
            UPDATE dbo.tablaasi SET detalle = REPLACE(detalle, RTRIM(@numviejo), RTRIM(@numcomp)) WHERE idmaopera = @idmaopera;
            UPDATE dbo.tablaimp SET detalle = REPLACE(detalle, RTRIM(@numviejo), RTRIM(@numcomp)) WHERE idmaopera = @idmaopera;
        END
        UPDATE dbo.maopera SET numcomp = @numcomp WHERE id = @idmaopera;

        UPDATE dbo.cabeLiq SET caetipo = @caetipo, infocae = 1, cae = @cae, vtocae = CAST(@vtocae AS DATETIME),
                               fecha = CAST(@fecha AS DATETIME), fechaarca = GETDATE()
        WHERE idmaopera = @idmaopera;

        UPDATE dbo.movctacte SET fecha = CAST(@fecha AS DATETIME) WHERE idmaopera = @idmaopera;

        -- 4) Importes de ARCA
        IF @total > 0 AND @neto > 0
        BEGIN
            IF (@periva <> 0 AND NOT EXISTS (SELECT 1 FROM dbo.tablaasi WHERE idmaopera = @idmaopera AND tipoconce = 'RI'))
            OR (@periibb <> 0 AND NOT EXISTS (SELECT 1 FROM dbo.tablaasi WHERE idmaopera = @idmaopera AND tipoconce = 'RB'))
                THROW 50001, 'LUM: ARCA devolvio una percepcion que no esta en el asiento. Revisar la liquidacion.', 1;

            UPDATE dbo.cabeLiq SET t_neto = @total, t_iva = @iva, t_impuestos = @periva + @periibb, total = @neto
            WHERE idmaopera = @idmaopera;

            UPDATE dbo.tablaimp
            SET importe = CASE tipoconce WHEN 'NG' THEN @total WHEN 'IG' THEN @iva WHEN 'RI' THEN @periva WHEN 'RB' THEN @periibb END,
                baseimp = CASE WHEN tipoconce = 'IG' THEN @total ELSE baseimp END
            WHERE idmaopera = @idmaopera AND tipoconce IN ('NG', 'IG', 'RI', 'RB');

            UPDATE dbo.tablaasi
            SET importe = CASE tipoconce WHEN 'ZZ' THEN @neto WHEN 'NG' THEN @total WHEN 'IG' THEN @iva
                                         WHEN 'RI' THEN @periva WHEN 'RB' THEN @periibb END
            WHERE idmaopera = @idmaopera AND tipoconce IN ('ZZ', 'NG', 'IG', 'RI', 'RB');

            IF (SELECT SUM(CASE debehaber WHEN 'D' THEN importe ELSE -importe END) FROM dbo.tablaasi WHERE idmaopera = @idmaopera) <> 0
                THROW 50001, 'LUM: con los importes de ARCA el asiento no balancea.', 1;

            SELECT @idcta = idctacte FROM dbo.movctacte WHERE idmaopera = @idmaopera;
            UPDATE dbo.movctacte SET importe = @neto, total = @neto, saldo = saldo + (@neto - @viejo)
            WHERE idmaopera = @idmaopera;
            UPDATE dbo.ctacte SET saldo = saldo + (@neto - @viejo) * @signo
            WHERE id = @idcta AND ISNULL(NoAcumuSaldo, 0) = 0;
        END

        IF @propia = 1 COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Solo se deshace la transaccion propia; la de VFP la deshace VFP al recibir el error
        IF @propia = 1 AND @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO
