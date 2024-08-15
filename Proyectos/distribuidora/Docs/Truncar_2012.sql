use campisi
go
sp_helpdb campisi
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE campisi
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(campisi, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(campisi_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE campisi
SET RECOVERY FULL;
go
sp_helpdb campisi
GO
 