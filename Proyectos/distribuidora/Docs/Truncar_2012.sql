use distmuller
go
--execute actualizarid 1
go
sp_helpdb distmuller
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE distmuller
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(distmuller, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(distmuller_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE distmuller
SET RECOVERY FULL;
go
sp_helpdb distmuller
GO
 execute sp_backupdatabase 'distmuller','F'