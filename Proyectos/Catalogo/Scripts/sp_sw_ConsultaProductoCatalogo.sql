USE [Kleja]
GO

/****** Object:  StoredProcedure [dbo].[sp_sw_ConsultaProductoCatalogo]    Script Date: 27/2/2026 20:09:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_sw_ConsultaProductoCatalogo]
	@idempresa INT,	--No se usa aca, pq es por empresa
	@prmCadenaBusqueda varchar(200),
	@prmCadenaPalabras varchar(200),
	@prmIdDeposito varchar(20),
	@tipoPrecio varchar(1)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SQLString NVARCHAR(MAX)
    DECLARE @cWhere NVARCHAR(MAX)
	DECLARE @cWhereDep NVARCHAR(MAX)

    -- ? Crear tabla temporal LOCAL (una por sesión)
    CREATE TABLE #TempConsPrecio (
        numero INTEGER,
        subnumero INTEGER,
        nombre CHAR(100),
        nomvariedad CHAR(20),
        precio NUMERIC(16,2),
        existedisp NUMERIC(10,2),
        idarticulo INT,
        idvariedad INT,
		idmarca INT,
		idrubro INT,
		marca_nombre char(50),
		rubro_nombre char(50),
		imagen NVARCHAR(MAX),
		envioweb NUMERIC(1),
		unibulto NUMERIC(4),
        univenta CHAR(10),
		pesable BIT,
        peso NUMERIC(10,2),
		grupo_unificador  nvarchar(30)
    )

	DECLARE @whereTipoPrecio VARCHAR(50);
    
    -- Determinar qué campo de precio usar
    SET @whereTipoPrecio = CASE @tipoPrecio
        WHEN '2' THEN 'a.prevtaf2'
        WHEN '3' THEN 'a.prevtaf3'
        WHEN '4' THEN 'a.prevtaf4'
        ELSE 'a.prevtaf1'
    END;


   
    SET @cWhereDep = ''
	-- Procesar búsqueda por código/nombre
    IF @prmIdDeposito IS NOT NULL AND LTRIM(RTRIM(@prmIdDeposito)) <> '' AND LTRIM(RTRIM(@prmIdDeposito)) <> '0'
    BEGIN
        SET @cWhereDep = @cWhereDep + ' AND ( e.iddeposito = ' + @prmIdDeposito + ') '
    END

	 -- Construir WHERE
    SET @cWhere = ' WHERE ( a.espromocion = 0 AND a.idestado = 1 and a.idmarca > 0 and isnull(a.envioweb,1) = 1 '

    -- Procesar palabras
    IF @prmCadenaPalabras IS NOT NULL AND RTRIM(LTRIM(@prmCadenaPalabras)) <> ''
    BEGIN
        DECLARE @TempTable TABLE (value NVARCHAR(255))
        
        INSERT INTO @TempTable (value) 
        SELECT value 
        FROM dbo.SplitString(@prmCadenaPalabras, ' ')
        WHERE RTRIM(LTRIM(value)) <> ''

        DECLARE @Palabra NVARCHAR(255)
        DECLARE PalabrasCursor CURSOR LOCAL FAST_FORWARD FOR 
            SELECT value FROM @TempTable
        
        OPEN PalabrasCursor
        FETCH NEXT FROM PalabrasCursor INTO @Palabra
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @EscapedPalabra NVARCHAR(255) = REPLACE(@Palabra, '''', '''''')
            SET @cWhere = @cWhere + ' AND a.nombre LIKE ''%' + @EscapedPalabra + '%'' '
            FETCH NEXT FROM PalabrasCursor INTO @Palabra
        END
        
        CLOSE PalabrasCursor
        DEALLOCATE PalabrasCursor
    END

    -- Procesar búsqueda por código/nombre
    IF @prmCadenaBusqueda IS NOT NULL AND LTRIM(RTRIM(@prmCadenaBusqueda)) <> '' AND LTRIM(RTRIM(@prmCadenaBusqueda)) <> '9999999999999'
    BEGIN
        SET @cWhere = @cWhere + ' AND ( (a.codbarra13 LIKE ''%' + @prmCadenaBusqueda + '%'') '
        SET @cWhere = @cWhere + ' OR (a.codalfa LIKE ''%' + @prmCadenaBusqueda + '%'') '
        SET @cWhere = @cWhere + ' OR (s.codigo LIKE ''%' + @prmCadenaBusqueda + '%'') '
        SET @cWhere = @cWhere + ' OR (a.numero LIKE ''%' + @prmCadenaBusqueda + '%'')) '
    END

    SET @cWhere = @cWhere + ')'

    -- ? Insertar en tabla temporal LOCAL
    SET @SQLString = N'INSERT INTO #TempConsPrecio 
    SELECT 
        a.numero,
        ISNULL(s.subnumero, 0) AS subnumero,
        a.nombre AS nombre,
        ISNULL(s.nombre, SPACE(1)) AS nomvariedad,
		'+@whereTipoPrecio+' as precio,
        CONVERT(NUMERIC(10,2),
			ISNULL( (select sum(e.existe) from existenc as e 
				where (e.idsubarti = ISNULL(s.id, 0) AND e.idarticulo = a.id)
				'+@cWhereDep+')
			, CAST(0 AS NUMERIC(10,2)))) AS existedisp,
        a.id AS idarticulo,
        ISNULL(s.idvariedad, 0) AS idvariedad,
		a.idmarca,
		isnull(a.idcategoria,0) as idrubro,
		m.nombre as marca_nombre,
		c.nombre as rubro_nombre,
		isnull(a.imagenhttp,space(1)) as imagen,
		ISNULL(a.envioweb,1) as envioweb,
		a.unibulto,
        ''UNIDADES'' AS univenta,
		a.cprakilos AS pesable,
        a.peso,
		isnull((select top 1 ca.nombre from cabeunifica ca inner join cuerunifica cu on ca.id = cu.idcabeunifica
		where cu.idproducto = a.id),space(1)) as grupo_unificador
    FROM producto a 
    LEFT JOIN subproducto s ON s.idarticulo = a.id     
    LEFT JOIN marca m ON a.idmarca = m.id
	LEFT JOIN categoria c ON a.idcategoria = c.id
    ' + @cWhere

	--LEFT JOIN existenc e ON (e.idsubarti = ISNULL(s.id, 0) AND e.idarticulo = a.id) 
    -- Log de la consulta
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

    -- Ejecutar INSERT dinámico
    PRINT @SQLString
    EXECUTE sp_executesql @SQLString

    -- ? Devolver resultados de tabla temporal LOCAL
    SELECT * FROM #TempConsPrecio

    -- La tabla temporal se elimina automáticamente al finalizar el SP
END
GO


