use quaglia
go
--execute actualizarid 1
go
sp_helpdb quaglia
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE quaglia
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(quaglia, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(quaglia_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE quaglia
SET RECOVERY FULL;
go
sp_helpdb quaglia
GO
 --execute sp_backupdatabase 'distmuller','F'