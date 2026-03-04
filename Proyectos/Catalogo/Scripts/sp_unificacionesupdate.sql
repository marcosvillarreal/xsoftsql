USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_UnificacionesUpdate]    Script Date: 4/3/2026 10:00:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Stored Procedure: sp_UnificacionesUpdate
-- Descripción: CRUD de grupos unificadores
-- Autor: GMDash
-- Fecha: 2026-01-09
-- =============================================

CREATE PROCEDURE [dbo].[sp_UnificacionesUpdate]
    @comando NVARCHAR(10),  -- 'insert', 'update', 'delete'
    @datos NVARCHAR(MAX) ,   -- Formato: idunificacion|nombre (separados por ;)
	@listaProductos NVARCHAR(MAX) = NULL

AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @idunificacion INT
    DECLARE @codigo NVARCHAR(50)
    DECLARE @nombre NVARCHAR(100)
    DECLARE @success BIT = 0
    DECLARE @mensaje NVARCHAR(255) = ''
    DECLARE @resultado INT = 0

	DECLARE @fila NVARCHAR(MAX)
    DECLARE @idarticulo INT


    BEGIN TRY
                
        -- ========================================
        -- PARSEAR DATOS para INSERT/UPDATE
        -- ========================================
        -- Formato: idunificacion|nombre
        
		 -- Log de la consulta
		INSERT INTO Log_ConsultasDinamicas (
			NombreProcedimiento,
			cWhereGenerada,
			SQLCompleta
		)
		VALUES (
			OBJECT_NAME(@@PROCID),
			@datos,
			@listaProductos
		)

		DECLARE @temp TABLE (pos INT IDENTITY, valor VARCHAR(500))
		---
		INSERT INTO @temp (valor)
		SELECT value FROM dbo.SplitString(@datos, '|')
		WHERE LEN(RTRIM(LTRIM(value))) > 0
		---
		
		set @mensaje = 'Operación exitosa'

		-- Parsear datos (asume un solo registro: idcategoria|nombre)
		SELECT @idunificacion = CAST(valor AS INT) FROM @temp WHERE pos = 1
		SELECT @nombre = valor FROM @temp WHERE pos = 2

		INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
		)VALUES (OBJECT_NAME(@@PROCID),
					'@comando',@comando	)
		
		INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
		)VALUES (OBJECT_NAME(@@PROCID),
					'datos @idunificacion',@idunificacion	)

		-- ========================================
		-- VALIDACIÓN DE NOMBRE ÚNICO
		-- ========================================
		-- Para INSERT: validar que el nombre no exista
		IF @comando = 'insert'
		BEGIN
			IF EXISTS (SELECT 1 FROM cabeunifica WHERE nombre = @nombre)
			BEGIN
				SET @success = 0
				SET @mensaje = 'Ya existe una unificación con el nombre: ' + @nombre
        
				SELECT 
					0 AS success,
					0 AS idUnificacion,
					@mensaje AS mensaje
				RETURN
			END
		END

		-- Para UPDATE: validar que el nombre no exista en OTRO registro
		IF @comando = 'update'
		BEGIN
			IF EXISTS (SELECT 1 FROM cabeunifica WHERE nombre = @nombre AND id != @idunificacion)
			BEGIN
				SET @success = 0
				SET @mensaje = 'Ya existe otra unificación con el nombre: ' + @nombre
        
				SELECT 
					0 AS success,
					@idunificacion AS idUnificacion,
					@mensaje AS mensaje
				RETURN
			END
		END

		BEGIN TRANSACTION

		IF @comando = 'delete' or  @comando = 'update'
		BEGIN
			-- Validar que existe la unificación
			IF NOT EXISTS (SELECT 1 FROM cabeunifica WHERE id = @idunificacion)
			BEGIN
				SET @success = 0
				SET @mensaje = 'No se encontró la unificación'

				-- Log de la consulta
				INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
				)VALUES (OBJECT_NAME(@@PROCID),
					'delete-update',@mensaje	)
			END
			else 
			BEGIN
				IF @comando = 'delete'
				BEGIN
					-- Log de la consulta
					INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
					)VALUES (OBJECT_NAME(@@PROCID),
						'delete',''	)
    
					-- Eliminar primero el detalle (cuerpo)
					DELETE FROM cuerunifica WHERE idcabeunifica = @idunificacion
    
					-- Eliminar el encabezado
					DELETE FROM cabeunifica WHERE id = @idunificacion
    
					SET @resultado = @idunificacion
					SET @success = 1
					SET @mensaje = 'Unificación eliminada correctamente'

					-- Log de la consulta
					INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
					)VALUES (OBJECT_NAME(@@PROCID),
						'delete',@mensaje	)

				END


			
				-- ========================================
				-- COMANDO: INSERT
				-- ========================================
				-- Ejecutar según comando
				IF @comando = 'insert' or  @comando = 'update'
				BEGIN
					IF @comando = 'insert'
					begin
						-- Log de la consulta
						INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
						)VALUES (OBJECT_NAME(@@PROCID),
							'insert',''	)
						--
						-- Calcular el siguiente número automáticamente
						DECLARE @nuevoID INT
						SELECT @nuevoId = ISNULL(MAX(nextid), 0) + 1 
						FROM keysid where tabla='cabeunifica'
	
						DECLARE @nuevoNumero INT
						SELECT @nuevoNumero = ISNULL(MAX(numero), 0) + 1 
						FROM cabeunifica


						INSERT INTO cabeunifica (numero,nombre,id)
						VALUES (@nuevoNumero,@nombre, @nuevoID)
        
						SET @resultado = @nuevoId
						SET @success = 1
						SET @mensaje = 'Unificación creada correctamente'

						-- Actualizar keysid
						UPDATE keysid 
						SET nextid = nextid+1
						WHERE tabla='cabeunifica'

						-- Si no existe el registro, insertarlo
						IF @@ROWCOUNT = 0
						BEGIN
							INSERT INTO keysid (tabla, nextid) 
							VALUES ('cabeunifica', @nuevoId+1)
						END

						INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
						)VALUES (OBJECT_NAME(@@PROCID),
							'insert',@mensaje	)
				   END 
				   ELSE
				   BEGIN
						-- Log de la consulta
						INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
						)VALUES (OBJECT_NAME(@@PROCID),
							'update',''	)

						UPDATE cabeunifica
						SET  nombre = @nombre
						WHERE id = @idunificacion
			
						SET @resultado = @idunificacion

					 

						IF @@ROWCOUNT > 0
						BEGIN
							SET @success = 1
							SET @mensaje = 'Unificación actualizada correctamente'

							 -- Limpiar productos anteriores
							DELETE FROM cuerunifica WHERE idcabeunifica = @idunificacion
						END
						ELSE
						BEGIN
							SET @mensaje = 'No se encontró la unificación'
						END

						INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento,cWhereGenerada,	SQLCompleta
						)VALUES (OBJECT_NAME(@@PROCID),
							'update',@mensaje	)

					END

					---aHORA LOS ARTICULOS
					-- Insertar productos (si vienen)
					IF @listaProductos IS NOT NULL AND LEN(@listaProductos) > 0
					BEGIN
						-- Crear tabla temporal
						CREATE TABLE #TempProductos (
							rownum INT IDENTITY,
							fila NVARCHAR(MAX)
						)
            
						-- Separar filas por ;
						INSERT INTO #TempProductos (fila)
						SELECT value FROM dbo.SplitString(@listaProductos, ';')
						WHERE LEN(RTRIM(LTRIM(value))) > 0
            
						-- Cursor para procesar cada fila
						DECLARE cur CURSOR FOR 
						SELECT fila FROM #TempProductos
            
						OPEN cur
						FETCH NEXT FROM cur INTO @fila
				
						DECLARE @nuevoIDCuer INT

						WHILE @@FETCH_STATUS = 0
						BEGIN
							-- Parsear: idarticulo|numero|subnumero
							DECLARE @campos TABLE (pos INT, valor NVARCHAR(MAX))
							INSERT INTO @campos
							SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), value 
							FROM dbo.SplitString(@fila, '|')
                
							-- Extraer valores
							SELECT @idarticulo = CAST(valor AS INT) FROM @campos WHERE pos = 1

							-- Insertar producto si no existe
							IF NOT EXISTS (SELECT 1 FROM cuerunifica 
										  WHERE idcabeunifica = @idunificacion 
										  AND idproducto = @idarticulo)
							BEGIN
								-- Calcular el siguiente número automáticamente
					
								SELECT @nuevoIDCuer = ISNULL(MAX(nextid), 0) + 1 
								FROM keysid where tabla='cuerunifica'

							

								INSERT INTO cuerunifica (id,idcabeunifica, idproducto)
								VALUES (@nuevoIDCuer, @idunificacion, @idarticulo)

								-- Actualizar keysid
								UPDATE keysid 
								SET nextid = nextid+1
								WHERE tabla='cuerunifica'

								-- Si no existe el registro, insertarlo
								IF @@ROWCOUNT = 0
								BEGIN
									INSERT INTO keysid (tabla, nextid) 
									VALUES ('cuerunifica', @nuevoIDCuer+1)
								END

							END

							DELETE FROM @campos
							FETCH NEXT FROM cur INTO @fila
						END
            
						CLOSE cur
						DEALLOCATE cur
						DROP TABLE #TempProductos
					END

           
				END
			end 
		END
    
		COMMIT TRANSACTION
		-- Retornar resultado
		SELECT 
			CASE WHEN @resultado > 0 THEN 1 ELSE 0 END AS success,
			@resultado AS idUnificacion,
			@mensaje AS mensaje

    

    END TRY
    BEGIN CATCH
		 IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

        SELECT 
            0 AS success, 
            0 AS idUnificacion, 
            'Error: ' + ERROR_MESSAGE() AS mensaje
    END CATCH
END
GO

