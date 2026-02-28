USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_descuentos_get]    Script Date: 27/2/2026 20:07:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =====================================================
-- SP 3: OBTENER UN DESCUENTO POR ID
-- =====================================================
CREATE PROCEDURE [dbo].[sp_descuentos_get]
    @id INT,
    @idempresa INT
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
    WHERE id = @id AND idempresa = @idempresa;
END
GO


