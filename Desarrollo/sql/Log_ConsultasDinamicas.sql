CREATE TABLE Log_ConsultasDinamicas (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    NombreProcedimiento NVARCHAR(128) NOT NULL,
    cWhereGenerada NVARCHAR(MAX), -- Para guardar solo la cláusula WHERE
    SQLCompleta NVARCHAR(MAX),    -- Opcional: Para guardar la consulta entera
    FechaEjecucion DATETIME DEFAULT GETDATE()
);
GO