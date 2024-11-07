use meridiem
go
execute actualizarid 1
go
sp_helpdb meridiem
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE meridiem
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(meridiem, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(meridiem_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE meridiem
SET RECOVERY FULL;
go
sp_helpdb meridiem
GO
 execute sp_backupdatabase 'meridiem','F'