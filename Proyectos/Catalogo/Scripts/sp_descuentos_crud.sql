USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_descuentos_crud]    Script Date: 27/2/2026 20:07:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =====================================================
-- SP 1: CRUD PRINCIPAL (INSERT/UPDATE/DELETE)
-- =====================================================
CREATE PROCEDURE [dbo].[sp_descuentos_crud]
    @accion VARCHAR(10),              -- 'INSERT', 'UPDATE', 'DELETE'
    @id INT = NULL,
    @idempresa INT = NULL,
    @tipo VARCHAR(50) = NULL,
    @nombre NVARCHAR(200) = NULL,
    @condiciones NVARCHAR(MAX) = NULL, -- JSON como texto
    @fecha_inicio DATE = NULL,
    @fecha_fin DATE = NULL,
    @prioridad INT = 0,
    @activo BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- ===== INSERT =====
        IF @accion = 'INSERT'
        BEGIN
            -- Validaciones
            IF @idempresa IS NULL OR @tipo IS NULL OR @nombre IS NULL
            BEGIN
                RAISERROR('Campos requeridos: idempresa, tipo, nombre', 16, 1);
                RETURN;
            END
            
            INSERT INTO descuentos (
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
            )
            VALUES (
                @idempresa,
                @tipo,
                @nombre,
                @condiciones,
                @fecha_inicio,
                @fecha_fin,
                COALESCE(@prioridad, 0),
                COALESCE(@activo, 1),
                GETDATE(),
                GETDATE()
            );
            
            -- Retornar el ID generado
            SELECT SCOPE_IDENTITY() AS id, 'Descuento creado exitosamente' AS mensaje;
        END
        
        -- ===== UPDATE =====
        ELSE IF @accion = 'UPDATE'
        BEGIN
            -- Validaciones
            IF @id IS NULL
            BEGIN
                RAISERROR('ID requerido para actualizar', 16, 1);
                RETURN;
            END
            
            -- Verificar que existe
            IF NOT EXISTS (SELECT 1 FROM descuentos WHERE id = @id AND idempresa = @idempresa)
            BEGIN
                RAISERROR('Descuento no encontrado', 16, 1);
                RETURN;
            END
            
            UPDATE descuentos
            SET 
                tipo = COALESCE(@tipo, tipo),
                nombre = COALESCE(@nombre, nombre),
                condiciones = COALESCE(@condiciones, condiciones),
                fecha_inicio = CASE WHEN @fecha_inicio IS NOT NULL THEN @fecha_inicio ELSE fecha_inicio END,
                fecha_fin = CASE WHEN @fecha_fin IS NOT NULL THEN @fecha_fin ELSE fecha_fin END,
                prioridad = COALESCE(@prioridad, prioridad),
                activo = COALESCE(@activo, activo),
                updated_at = GETDATE()
            WHERE id = @id AND idempresa = @idempresa;
            
            SELECT @id AS id, 'Descuento actualizado exitosamente' AS mensaje;
        END
        
        -- ===== DELETE =====
        ELSE IF @accion = 'DELETE'
        BEGIN
            -- Validaciones
            IF @id IS NULL
            BEGIN
                RAISERROR('ID requerido para eliminar', 16, 1);
                RETURN;
            END
            
            -- Verificar que existe
            IF NOT EXISTS (SELECT 1 FROM descuentos WHERE id = @id AND idempresa = @idempresa)
            BEGIN
                RAISERROR('Descuento no encontrado', 16, 1);
                RETURN;
            END
            
            -- Soft delete (recomendado) o hard delete
            -- Opción A: Soft delete
            UPDATE descuentos
            SET activo = 0, updated_at = GETDATE()
            WHERE id = @id AND idempresa = @idempresa;
            
            -- Opción B: Hard delete (descomentar si prefieres)
            -- DELETE FROM descuentos WHERE id = @id AND idempresa = @idempresa;
            
            SELECT @id AS id, 'Descuento eliminado exitosamente' AS mensaje;
        END
        
        ELSE
        BEGIN
            RAISERROR('Acción no válida. Use: INSERT, UPDATE o DELETE', 16, 1);
            RETURN;
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Retornar error
        SELECT 
            ERROR_NUMBER() AS error_number,
            ERROR_MESSAGE() AS error_message,
            ERROR_SEVERITY() AS error_severity;
    END CATCH
END
GO


