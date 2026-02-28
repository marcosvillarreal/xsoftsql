USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_descuentos_stats]    Script Date: 27/2/2026 20:08:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =====================================================
-- SP 5: ESTADÍSTICAS DE DESCUENTOS
-- =====================================================
CREATE PROCEDURE [dbo].[sp_descuentos_stats]
    @idempresa INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) AS total_descuentos,
        SUM(CASE WHEN activo = 1 THEN 1 ELSE 0 END) AS descuentos_activos,
        SUM(CASE WHEN activo = 0 THEN 1 ELSE 0 END) AS descuentos_inactivos,
        SUM(CASE 
            WHEN activo = 1 
            AND (fecha_inicio IS NULL OR fecha_inicio <= CAST(GETDATE() AS DATE))
            AND (fecha_fin IS NULL OR fecha_fin >= CAST(GETDATE() AS DATE))
            THEN 1 ELSE 0 
        END) AS descuentos_vigentes
    FROM descuentos
    WHERE idempresa = @idempresa;
    
    -- Descuentos por tipo
    SELECT 
        tipo,
        COUNT(*) AS cantidad,
        SUM(CASE WHEN activo = 1 THEN 1 ELSE 0 END) AS activos
    FROM descuentos
    WHERE idempresa = @idempresa
    GROUP BY tipo
    ORDER BY cantidad DESC;
END
GO


