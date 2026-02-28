USE kkk
GO

/****** Object:  StoredProcedure [dbo].[sp_CategoriasUpdate]    Script Date: 27/2/2026 20:05:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CategoriasUpdate]
    @comando VARCHAR(10), -- 'insert', 'update', 'delete'
    @datos VARCHAR(MAX)   -- Formato: idcategoria|nombre|imagenURL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @idcategoria INT
    DECLARE @nombre VARCHAR(100)
    DECLARE @imagenURL VARCHAR(500)
    DECLARE @resultado INT = 0
    
	DECLARE @temp TABLE (pos INT IDENTITY, valor VARCHAR(500))
	---
	INSERT INTO @temp (valor)
    SELECT value FROM dbo.SplitString(@datos, '|')
    WHERE LEN(RTRIM(LTRIM(value))) > 0
	---


    -- Parsear datos (asume un solo registro: idcategoria|numero|nombre|imagenURL)
    SELECT @idcategoria = CAST(valor AS INT) FROM @temp WHERE pos = 1
	SELECT @nombre = valor FROM @temp WHERE pos = 2
	SELECT @imagenURL = NULLIF(valor, '') FROM @temp WHERE pos = 3

	 BEGIN TRANSACTION
    --
	-- Calcular el siguiente número automáticamente
    DECLARE @nuevoNumero INT
    SELECT @nuevoNumero = ISNULL(MAX(numero), 0) + 1 
    FROM categoria


    -- Ejecutar según comando
    IF @comando = 'insert'
    BEGIN
        INSERT INTO categoria (numero,nombre, imagenURL)
        VALUES (@nuevoNumero,@nombre, @imagenURL)
        
        SET @resultado = SCOPE_IDENTITY()
    END
    
    ELSE IF @comando = 'update'
    BEGIN
        UPDATE categoria
        SET  nombre = @nombre,
            imagenURL = @imagenURL
        WHERE id = @idcategoria
        
        
        SET @resultado = @idcategoria
    END
    
    ELSE IF @comando = 'delete'
    BEGIN
        DELETE FROM categoria
        WHERE id = @idcategoria
        
        SET @resultado = @idcategoria
    END
    
	COMMIT TRANSACTION

    -- Retornar resultado
    SELECT 
        CASE WHEN @resultado > 0 THEN 1 ELSE 0 END AS success,
        @resultado AS idRubro,
        'Operación exitosa' AS mensaje
END
GO


