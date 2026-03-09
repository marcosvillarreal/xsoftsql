use frigosur
go
--execute actualizarid 1
go
sp_helpdb frigosur
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE frigosur
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(frigosur, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(frigosur_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE frigosur
SET RECOVERY FULL;
go
sp_helpdb frigosur
GO
 execute sp_backupdatabase 'frigosur','F'