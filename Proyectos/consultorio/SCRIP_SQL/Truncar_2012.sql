use corralon_ant
go
execute actualizarid 1
go
sp_helpdb corralon_ant
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE corralon_ant
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(corralon_ant, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(corralon_ant_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE corralon_ant
SET RECOVERY FULL;
go
sp_helpdb corralon_ant
GO
 execute sp_backupdatabase 'corralon_ant','F'