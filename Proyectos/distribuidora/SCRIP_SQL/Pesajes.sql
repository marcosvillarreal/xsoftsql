-- ============================================================
-- Tablas de PESAJES para cualquier ERP (22/10/2026, usuario: crearlas en las demas empresas aunque
-- no se usen, para que nada de error). Copia exacta de la estructura de El Calden:
--   cabePesaje  cabecera (un pesaje por cliente y fecha)
--   cuerPesaje  ordenes por producto (saldo_c / saldo_k en la orden 1 del producto)
--   afepesajes  comprobantes que afectaron cada pesaje (factura +, nota de credito -)
-- IDEMPOTENTE: crea solo lo que falta (tabla, columna, default, PK o indice); no toca datos ni lo
-- que ya existe. Se puede correr las veces que haga falta, tambien en El Calden.
-- Compatible con SQL Server 2014 (Juma): sin CREATE OR ALTER / DROP IF EXISTS.
-- Indices (analizados sobre los SPs de backend/sql/sp_gms_pesaje*.sql):
--   cabePesaje  PK id; (idctacte, fecha): get y grabar buscan el pesaje por cliente y fecha.
--   cuerPesaje  PK id; (idcabeza, idarticulo, orden): todos los SPs filtran por idcabeza (traer,
--               regrabar, saldo por producto, orden 1 = MIN(orden) del producto, imputaciones).
--   afepesajes  PK id; idcuerpesaje (joins con cuerPesaje); idmaopera (desimputar al borrar).
-- Los SPs van aparte (sp_gms_pesaje.sql / sp_gms_pesaje_imputar.sql usan CREATE OR ALTER: en
-- SQL 2014 hay que pasarlos a DROP + CREATE).
-- Instalar con: sqlcmd ... -f 65001 -i tablas_pesajes.sql
-- ============================================================
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;
GO

-- ── cabePesaje ──
IF OBJECT_ID('dbo.cabePesaje') IS NULL
BEGIN
    CREATE TABLE dbo.cabePesaje (
        id          NUMERIC(12,0) NOT NULL CONSTRAINT PK_cabePesaje PRIMARY KEY,
        idmaopera   NUMERIC(12,0) NOT NULL,
        switch      CHAR(5)       NOT NULL,
        idctacte    INT           NOT NULL,
        fecha       DATETIME      NOT NULL,
        idconcepto  INT           NOT NULL,
        t_pesajes   NUMERIC(11,2) NULL CONSTRAINT DF_cabePesaje_t_pesajes  DEFAULT 0,
        t_tara      NUMERIC(11,2) NULL CONSTRAINT DF_cabePesaje_t_tara     DEFAULT 0,
        t_kilos     NUMERIC(11,2) NULL CONSTRAINT DF_cabePesaje_t_kilos    DEFAULT 0,
        t_cantidad  NUMERIC(11,2) NULL CONSTRAINT DF_cabePesaje_t_kilos1   DEFAULT 0,
        estado      NUMERIC(1,0)  NULL CONSTRAINT DF_cabePesaje_estado     DEFAULT 0   -- <> 0 = facturado
    );
    PRINT 'cabePesaje: creada';
END
GO
-- PK (en El Calden la tabla se creo sin PK): solo si no hay ids repetidos
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.cabePesaje') AND is_primary_key = 1)
BEGIN
    IF EXISTS (SELECT id FROM dbo.cabePesaje GROUP BY id HAVING COUNT(*) > 1)
        PRINT 'cabePesaje: ATENCION, hay ids repetidos: no se crea la PK';
    ELSE
    BEGIN
        ALTER TABLE dbo.cabePesaje ADD CONSTRAINT PK_cabePesaje PRIMARY KEY (id);
        PRINT 'cabePesaje: PK creada';
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.cabePesaje') AND name = 'IX_cabePesaje_idctacte_fecha')
BEGIN
    CREATE INDEX IX_cabePesaje_idctacte_fecha ON dbo.cabePesaje (idctacte, fecha);
    PRINT 'cabePesaje: indice (idctacte, fecha) creado';
END
GO

-- ── cuerPesaje ──
IF OBJECT_ID('dbo.cuerPesaje') IS NULL
BEGIN
    CREATE TABLE dbo.cuerPesaje (
        id            NUMERIC(12,0) NOT NULL CONSTRAINT PK_cuerpesa PRIMARY KEY,
        idmaopera     NUMERIC(12,0) NOT NULL,
        idcabeza      NUMERIC(12,0) NOT NULL,   -- cabePesaje.id
        idarticulo    INT           NOT NULL,
        idvariedad    INT           NOT NULL,
        codigo        CHAR(8)       NOT NULL,
        nombre        VARCHAR(40)   NOT NULL,
        cantidad_t    NUMERIC(10,2) NOT NULL,
        total         NUMERIC(13,3) NOT NULL,   -- neto (pesada - tara)
        pesaje_t      NUMERIC(12,2) NOT NULL,
        tara_t        NUMERIC(10,2) NOT NULL,
        orden         NUMERIC(2,0)  NULL,
        tara_bandj    INT           NULL,
        tara_bandj_k  NUMERIC(10,3) NULL,
        saldo_c       NUMERIC(11,2) NOT NULL CONSTRAINT DF_cuerPesaje_saldo_c DEFAULT 0,
        saldo_k       NUMERIC(13,3) NOT NULL CONSTRAINT DF_cuerPesaje_saldo_k DEFAULT 0
    );
    PRINT 'cuerPesaje: creada';
END
GO
-- Columnas de saldo (por si la tabla ya existia de antes sin ellas)
IF COL_LENGTH('dbo.cuerPesaje', 'saldo_c') IS NULL
BEGIN
    ALTER TABLE dbo.cuerPesaje ADD saldo_c NUMERIC(11,2) NOT NULL CONSTRAINT DF_cuerPesaje_saldo_c DEFAULT 0;
    PRINT 'cuerPesaje: columna saldo_c agregada';
END
IF COL_LENGTH('dbo.cuerPesaje', 'saldo_k') IS NULL
BEGIN
    ALTER TABLE dbo.cuerPesaje ADD saldo_k NUMERIC(13,3) NOT NULL CONSTRAINT DF_cuerPesaje_saldo_k DEFAULT 0;
    PRINT 'cuerPesaje: columna saldo_k agregada';
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.cuerPesaje') AND is_primary_key = 1)
BEGIN
    IF EXISTS (SELECT id FROM dbo.cuerPesaje GROUP BY id HAVING COUNT(*) > 1)
        PRINT 'cuerPesaje: ATENCION, hay ids repetidos: no se crea la PK';
    ELSE
    BEGIN
        ALTER TABLE dbo.cuerPesaje ADD CONSTRAINT PK_cuerpesa PRIMARY KEY (id);
        PRINT 'cuerPesaje: PK creada';
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.cuerPesaje') AND name = 'IX_cuerPesaje_idcabeza')
BEGIN
    CREATE INDEX IX_cuerPesaje_idcabeza ON dbo.cuerPesaje (idcabeza, idarticulo, orden);
    PRINT 'cuerPesaje: indice (idcabeza, idarticulo, orden) creado';
END
GO

-- ── afepesajes ──
IF OBJECT_ID('dbo.afepesajes') IS NULL
BEGIN
    CREATE TABLE dbo.afepesajes (
        id            NUMERIC(12,0) NOT NULL CONSTRAINT PK_afepesajes PRIMARY KEY,
        idmaopera     NUMERIC(12,0) NOT NULL,   -- comprobante que afecta (factura / nota de credito)
        idcuerfac     NUMERIC(12,0) NOT NULL,   -- renglon del comprobante
        idcuerpesaje  NUMERIC(12,0) NOT NULL,   -- fila del saldo (orden 1 del producto)
        cantidad      NUMERIC(11,2) NOT NULL,   -- con signo: + factura, - nota de credito
        kilos         NUMERIC(13,3) NOT NULL,
        fechaserver   DATETIME      NOT NULL CONSTRAINT DF_afepesajes_fechaserver DEFAULT GETDATE()
    );
    PRINT 'afepesajes: creada';
END
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.afepesajes') AND name = 'IX_afepesajes_idcuerpesaje')
BEGIN
    CREATE INDEX IX_afepesajes_idcuerpesaje ON dbo.afepesajes (idcuerpesaje);
    PRINT 'afepesajes: indice idcuerpesaje creado';
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID('dbo.afepesajes') AND name = 'IX_afepesajes_idmaopera')
BEGIN
    CREATE INDEX IX_afepesajes_idmaopera ON dbo.afepesajes (idmaopera);
    PRINT 'afepesajes: indice idmaopera creado';
END
GO
PRINT 'tablas_pesajes.sql: listo';
GO
