use master
go
--execute actualizarid 1
go
sp_helpdb marucafiam
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE marucafiam
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(marucafiam, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(marucafiam_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE marucafiam
SET RECOVERY FULL;
go
sp_helpdb marucafiam
GO
 execute sp_backupdatabase 'marucafiam','F'