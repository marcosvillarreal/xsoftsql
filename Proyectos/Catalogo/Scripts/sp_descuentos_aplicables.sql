USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_descuentos_aplicables]    Script Date: 27/2/2026 20:06:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =====================================================
-- SP 4: OBTENER DESCUENTOS APLICABLES (para cálculo)
-- =====================================================
CREATE PROCEDURE [dbo].[sp_descuentos_aplicables]
    @idempresa INT,
    @fecha DATE = NULL,              -- Fecha de aplicación (hoy si es NULL)
    @idcliente VARCHAR(20) = NULL,   -- Código de cliente
    @clasificacion_cliente VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Usar fecha actual si no se proporciona
    IF @fecha IS NULL
        SET @fecha = CAST(GETDATE() AS DATE);
    
    SELECT 
        id,
        tipo,
        nombre,
        condiciones,
        prioridad,
        fecha_inicio,
        fecha_fin
    FROM descuentos
    WHERE 
        idempresa = @idempresa
        AND activo = 1
        -- Verificar vigencia
        AND (fecha_inicio IS NULL OR fecha_inicio <= @fecha)
        AND (fecha_fin IS NULL OR fecha_fin >= @fecha)
    ORDER BY prioridad DESC;
    
    -- NOTA: El filtrado por cliente/clasificación se hace en el backend
    -- porque las condiciones están en JSON
END
GO


