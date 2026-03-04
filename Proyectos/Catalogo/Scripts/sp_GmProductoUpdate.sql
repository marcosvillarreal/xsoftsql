use kleja
go
 CREATE PROCEDURE [dbo].[sp_GmProductoUpdate]
      @comando NVARCHAR(10),   -- 'update'
      @datos   NVARCHAR(MAX)   -- formato: idarticulo|imagenhttp|envioweb|idcategoria
  AS
  BEGIN
      SET NOCOUNT ON;

      DECLARE @idarticulo  BIGINT
      DECLARE @imagenhttp  NVARCHAR(500)
      DECLARE @envioweb    INT
      DECLARE @idcategoria INT
      DECLARE @success     BIT = 0
      DECLARE @mensaje     NVARCHAR(255) = ''

      BEGIN TRY
          INSERT INTO Log_ConsultasDinamicas (NombreProcedimiento, cWhereGenerada, SQLCompleta)
          VALUES (OBJECT_NAME(@@PROCID), @comando, @datos)

          DECLARE @temp TABLE (pos INT IDENTITY, valor NVARCHAR(500))
          INSERT INTO @temp (valor)
          SELECT value FROM dbo.SplitString(@datos, '|')
          WHERE LEN(RTRIM(LTRIM(value))) > 0

          SELECT @idarticulo  = CAST(valor AS BIGINT) FROM @temp WHERE pos = 1
          SELECT @imagenhttp  = valor                 FROM @temp WHERE pos = 2
          SELECT @envioweb    = CAST(valor AS INT)    FROM @temp WHERE pos = 3
          SELECT @idcategoria = CAST(valor AS INT)    FROM @temp WHERE pos = 4

          IF @comando = 'update'
          BEGIN
              UPDATE producto
              SET imagenhttp  = @imagenhttp,
                  envioweb    = @envioweb,
                  idcategoria = @idcategoria
              WHERE id = @idarticulo

              IF @@ROWCOUNT > 0
              BEGIN
                  SET @success = 1
                  SET @mensaje = 'Producto actualizado correctamente'
              END
              ELSE
                  SET @mensaje = 'No se encontró el producto: ' + CAST(@idarticulo AS NVARCHAR)
          END

          SELECT @success AS success, @idarticulo AS idarticulo, @mensaje AS mensaje

      END TRY
      BEGIN CATCH
          SELECT 0 AS success, 0 AS idarticulo, 'Error: ' + ERROR_MESSAGE() AS mensaje
      END CATCH
  END