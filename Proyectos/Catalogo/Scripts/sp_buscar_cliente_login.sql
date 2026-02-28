USE kkk
GO

/****** Object:  StoredProcedure [dbo].[sp_buscar_cliente_login]    Script Date: 27/2/2026 20:04:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_buscar_cliente_login]
  @idempresa INT,
  @codigo VARCHAR(50) = NULL,
  @email VARCHAR(200) = NULL,
  @nombre VARCHAR(200) = NULL
AS
BEGIN
  SET NOCOUNT ON;
  
  DECLARE @SQLString NVARCHAR(MAX)
	 DECLARE @cWhere NVARCHAR(MAX)

	 SET @cWhere = ''
	IF @codigo IS NOT NULL AND LTRIM(RTRIM(@codigo)) <> '' 
    BEGIN
		SET @cWhere = @cWhere + '  (c.cnumero LIKE ''%' + @codigo + '%'') '
    end 

	IF @email IS NOT NULL AND LTRIM(RTRIM(@email)) <> '' 
    BEGIN
		IF @cWhere <> '' SET @cWhere = @cWhere + ' OR '
		SET @cWhere = @cWhere + '   (c.email  LIKE ''%' + @email + '%'') '
    end 

	IF @nombre IS NOT NULL AND LTRIM(RTRIM(@nombre)) <> '' 
    BEGIN
		IF @cWhere <> '' SET @cWhere = @cWhere + ' OR '
		SET @cWhere = @cWhere + '   (c.cnombre  LIKE ''%' + @nombre + '%'') '
    end 


    

  -- Buscar clientes en tabla ctacte
  SET @SQLString = N'SELECT TOP 20
    c.cnumero as codigo,
    c.cnombre as nombre,
    RTRIM(LTRIM(c.email)) as email,
    c.ctelefono as telefono,
    c.cdireccion as direccion,
    ISNULL(L.nombre, '''') as localidad,
    ISNULL(P.nombre, '''') as provincia,
    c.lista as tipoPrecio,
    '''' as clasificacion,  
    c.estadocta as activo
  FROM ctacte c
  LEFT JOIN Provincia P ON c.idprovincia = P.id
  LEFT JOIN Localidad L ON c.idlocalidad = L.id
  WHERE c.ctadeudor = 1
    AND c.estadocta = 0  
    AND (' +  + @cWhere +  '   )
  ORDER BY c.cnombre'
  
  INSERT INTO Log_ConsultasDinamicas (
			NombreProcedimiento,
			cWhereGenerada,
			SQLCompleta
		)
		VALUES (
			OBJECT_NAME(@@PROCID),
			@cWhere,
			@SQLString
		)
	print @SQLString
	EXECUTE sp_executesql @SQLString
END

GO

