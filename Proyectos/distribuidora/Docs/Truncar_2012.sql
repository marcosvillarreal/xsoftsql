use distssg
go
execute actualizarid 1
go
sp_helpdb distssg
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE distssg
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(distssg, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(distssg_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE distssg
SET RECOVERY FULL;
go
sp_helpdb distssg
GO
 execute sp_backupdatabase 'distssg','F'