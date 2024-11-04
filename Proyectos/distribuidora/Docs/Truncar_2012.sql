use distgattari
go
--execute actualizarid 1
go
sp_helpdb distgattari
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE distgattari
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(distgattari, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(distgattari_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE distgattari
SET RECOVERY FULL;
go
sp_helpdb distgattari
GO
-- execute sp_backupdatabase 'distgattari','F'