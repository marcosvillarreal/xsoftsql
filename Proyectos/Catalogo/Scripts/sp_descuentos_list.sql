USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_descuentos_list]    Script Date: 27/2/2026 20:08:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =====================================================
-- SP 2: LISTAR DESCUENTOS
-- =====================================================
CREATE PROCEDURE [dbo].[sp_descuentos_list]
    @idempresa INT,
    @activo BIT = NULL,              -- NULL = todos, 1 = activos, 0 = inactivos
    @tipo VARCHAR(50) = NULL,        -- Filtrar por tipo
    @vigente_en_fecha DATE = NULL    -- Filtrar por fecha de vigencia
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        id,
        idempresa,
        tipo,
        nombre,
        condiciones,
        fecha_inicio,
        fecha_fin,
        prioridad,
        activo,
        created_at,
        updated_at
    FROM descuentos
    WHERE 
        idempresa = @idempresa
        AND (@activo IS NULL OR activo = @activo)
        AND (@tipo IS NULL OR tipo = @tipo)
        AND (
            @vigente_en_fecha IS NULL 
            OR (
                (fecha_inicio IS NULL OR fecha_inicio <= @vigente_en_fecha)
                AND (fecha_fin IS NULL OR fecha_fin >= @vigente_en_fecha)
            )
        )
    ORDER BY prioridad DESC, created_at DESC;
END
GO


