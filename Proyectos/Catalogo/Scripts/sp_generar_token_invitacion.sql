USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_generar_token_invitacion]    Script Date: 27/2/2026 20:09:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_generar_token_invitacion]
    @nombre_campana VARCHAR(100) = NULL,
    @dias_validez INT = 30,
    @creado_por VARCHAR(50),
    @beneficios NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @token VARCHAR(50)
    DECLARE @fecha_expira DATETIME
    
    -- Generar token único (12 caracteres)
    SET @token = REPLACE(CAST(NEWID() AS VARCHAR(50)), '-', '')
    SET @token = SUBSTRING(@token, 1, 12)
    
    SET @fecha_expira = DATEADD(DAY, @dias_validez, GETDATE())
    
    INSERT INTO tokens_invitacion (token, nombre_campana, beneficios, fecha_expira, creado_por)
    VALUES (@token, @nombre_campana, @beneficios, @fecha_expira, @creado_por)
    
    SELECT 
        @token AS token, 
        @fecha_expira AS expira,
        'Token generado exitosamente' AS mensaje
END

GO


