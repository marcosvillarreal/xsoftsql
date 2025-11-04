-- =============================================
-- Script de Creación de Tablas para Inventario
-- =============================================

-- 1. Tabla CabeInvent (Cabecera de Inventarios)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CabeInvent]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CabeInvent] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [idoperador] INT NULL,
        [sucursal] INT NULL,
        [iddeposito] INT NULL,
        [detalle] VARCHAR(500) NULL,
        [fecha] DATETIME NULL DEFAULT (GETDATE()),
        [switch] CHAR(5) NULL DEFAULT ('00000'),
        [estado] NUMERIC(1,0) NULL DEFAULT (0),
        [procesado] NUMERIC(1,0) NULL DEFAULT (0),
        [fechaupdate] DATETIME NULL DEFAULT (GETDATE()),
        CONSTRAINT [PK_CabeInvent] PRIMARY KEY CLUSTERED ([id] ASC)
    )
    
    PRINT 'Tabla CabeInvent creada exitosamente'
END
ELSE
BEGIN
    PRINT 'Tabla CabeInvent ya existe'
    
    -- Agregar columnas faltantes si la tabla existe
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[CabeInvent]') AND name = 'iddeposito')
    BEGIN
        ALTER TABLE [dbo].[CabeInvent] ADD [iddeposito] INT NULL
        PRINT '  - Columna iddeposito agregada'
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[CabeInvent]') AND name = 'detalle')
    BEGIN
        ALTER TABLE [dbo].[CabeInvent] ADD [detalle] VARCHAR(500) NULL
        PRINT '  - Columna detalle agregada'
    END
END
GO

-- 2. Tabla CuerInvent (Detalle de Inventarios)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CuerInvent]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[CuerInvent] (
        [id] INT IDENTITY(1,1) NOT NULL,
        [idcabeinvent] INT NULL,
        [idarticulo] INT NULL,
        [codigo] VARCHAR(50) NULL,
        [nombre] VARCHAR(200) NULL,
        [idvariedad] INT NULL,
        [codigovar] VARCHAR(50) NULL,
        [variedad] VARCHAR(200) NULL,
        [univenta] INT NULL,
        [unibulto] NUMERIC(10,2) NULL,
        [cantidad] NUMERIC(10,2) NULL,
        [kilos] NUMERIC(10,2) NULL,
        CONSTRAINT [PK_CuerInvent] PRIMARY KEY CLUSTERED ([id] ASC),
        CONSTRAINT [FK_CuerInvent_CabeInvent] FOREIGN KEY ([idcabeinvent]) 
            REFERENCES [dbo].[CabeInvent]([id])
            ON DELETE CASCADE
    )
    
    PRINT 'Tabla CuerInvent creada exitosamente'
END
ELSE
BEGIN
    PRINT 'Tabla CuerInvent ya existe'
END
GO

-- 3. Índices para mejorar rendimiento
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CabeInvent_idoperador' AND object_id = OBJECT_ID('CabeInvent'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_CabeInvent_idoperador] 
    ON [dbo].[CabeInvent] ([idoperador])
    PRINT 'Índice IX_CabeInvent_idoperador creado'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CabeInvent_fecha' AND object_id = OBJECT_ID('CabeInvent'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_CabeInvent_fecha] 
    ON [dbo].[CabeInvent] ([fecha])
    PRINT 'Índice IX_CabeInvent_fecha creado'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CuerInvent_idcabeinvent' AND object_id = OBJECT_ID('CuerInvent'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_CuerInvent_idcabeinvent] 
    ON [dbo].[CuerInvent] ([idcabeinvent])
    PRINT 'Índice IX_CuerInvent_idcabeinvent creado'
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_CuerInvent_idarticulo' AND object_id = OBJECT_ID('CuerInvent'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_CuerInvent_idarticulo] 
    ON [dbo].[CuerInvent] ([idarticulo])
    PRINT 'Índice IX_CuerInvent_idarticulo creado'
END
GO

PRINT '============================================='
PRINT 'Script completado exitosamente'
PRINT '============================================='