use kleja
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP Principal
CREATE PROCEDURE sp_ws_ActualizaInventario
    @idusuario INT,
    @iddeposito INT,
    @detalle VARCHAR(500),
    @listaStock NVARCHAR(MAX)  -- Formato: "num|subnum|nom|var|univ|unib|cant|kilos;num2|..."
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @idoperador INT
    DECLARE @sucursal INT
    DECLARE @idcabeinvent INT
    DECLARE @error VARCHAR(500)
    
    DECLARE @fila NVARCHAR(MAX)
    DECLARE @idarticulo INT
    DECLARE @codigo VARCHAR(50)
    DECLARE @nombre VARCHAR(200)
    DECLARE @idvariedad INT
    DECLARE @codigovar VARCHAR(50)
    DECLARE @variedad VARCHAR(200)
    DECLARE @univenta INT
    DECLARE @unibulto NUMERIC(10,2)
    DECLARE @cantidad NUMERIC(10,2)
    DECLARE @kilos NUMERIC(10,2)
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- 1. Obtener CodVendedor
        SELECT @idoperador = @idusuario 
        FROM Usuarios 
        WHERE id = @idusuario
        
        IF @idoperador IS NULL
        BEGIN
            RAISERROR('Usuario no encontrado o sin código de vendedor', 16, 1)
            RETURN
        END
        
        -- 2. Obtener sucursal
        SELECT @sucursal = sucursal 
        FROM Deposito 
        WHERE id = @iddeposito
        
        IF @sucursal IS NULL
        BEGIN
            RAISERROR('Depósito no encontrado', 16, 1)
            RETURN
        END
        
        -- 3. Insertar cabecera
        INSERT INTO CabeInvent (idoperador, sucursal, iddeposito, detalle, fecha, estado, procesado)
        VALUES (@idoperador, @sucursal, @iddeposito, @detalle, GETDATE(), 0, 0)
        
        SET @idcabeinvent = SCOPE_IDENTITY()
        
        -- 4. Crear tabla temporal
        CREATE TABLE #TempStock (
            rownum INT IDENTITY,
            fila NVARCHAR(MAX)
        )
        
        -- Insertar filas separadas por ;
        INSERT INTO #TempStock (fila)
        SELECT splitdata FROM dbo.fn_SplitString(@listaStock, ';')
        WHERE LEN(RTRIM(LTRIM(splitdata))) > 0
        
        -- 5. Cursor para procesar cada fila
        DECLARE cur CURSOR FOR 
        SELECT fila FROM #TempStock
        
        OPEN cur
        FETCH NEXT FROM cur INTO @fila
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Parsear campos separados por |
            DECLARE @campos TABLE (pos INT, valor NVARCHAR(MAX))
            INSERT INTO @campos
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), splitdata 
            FROM dbo.fn_SplitString(@fila, '|')
            
            SELECT @idarticulo = CAST(valor AS INT) FROM @campos WHERE pos = 1
            --SELECT @codigo = valor FROM @campos WHERE pos = 1
            --SELECT @nombre = valor FROM @campos WHERE pos = 2
            SELECT @idvariedad = CAST(ISNULL(valor, 0) AS INT) FROM @campos WHERE pos = 2
            --SELECT @codigovar = ISNULL(valor, '') FROM @campos WHERE pos = 3
            --SELECT @variedad = ISNULL(valor, '') FROM @campos WHERE pos = 4
            SELECT @univenta = CAST(valor AS INT) FROM @campos WHERE pos = 3
            SELECT @unibulto = CAST(valor AS NUMERIC(10,2)) FROM @campos WHERE pos = 4
            SELECT @cantidad = CAST(valor AS NUMERIC(10,2)) FROM @campos WHERE pos = 5
            SELECT @kilos = CAST(ISNULL(valor, 0) AS NUMERIC(10,2)) FROM @campos WHERE pos = 6
            
			-- Obtener datos del producto
            SELECT @codigo = numero, @nombre = nombre 
            FROM producto 
            WHERE id = @idarticulo
            
            IF @codigo IS NULL
            BEGIN
                SET @codigo = ''
                SET @nombre = 'Producto no encontrado'
            END
            
            -- Obtener datos de variedad (si existe)
            IF @idvariedad > 0
            BEGIN
                SELECT @codigovar = numero, @variedad = nombre 
                FROM variedad 
                WHERE id = @idvariedad
                
                IF @codigovar IS NULL
                BEGIN
                    SET @codigovar = ''
                    SET @variedad = ''
                END
            END
            ELSE
            BEGIN
                SET @codigovar = ''
                SET @variedad = ''
            END

            -- Insertar detalle
            INSERT INTO CuerInvent (
                idcabeinvent, idarticulo, codigo, nombre,
                idvariedad, codigovar, variedad,
                univenta, unibulto, cantidad, kilos
            )
            VALUES (
                @idcabeinvent, @idarticulo, @codigo, @nombre,
                @idvariedad, @codigovar, @variedad,
                @univenta, @unibulto, @cantidad, @kilos
            )
            
            DELETE FROM @campos
            FETCH NEXT FROM cur INTO @fila
        END
        
        CLOSE cur
        DEALLOCATE cur
        DROP TABLE #TempStock
        
        -- 6. Actualizar estado
        UPDATE CabeInvent 
        SET estado = 1, fechaupdate = GETDATE()
        WHERE id = @idcabeinvent
        
        COMMIT TRANSACTION
        
        SELECT @idcabeinvent AS idInventario, 'OK' AS mensaje
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        IF CURSOR_STATUS('global', 'cur') >= 0
        BEGIN
            CLOSE cur
            DEALLOCATE cur
        END
            
        SELECT ERROR_MESSAGE() AS error
    END CATCH
END