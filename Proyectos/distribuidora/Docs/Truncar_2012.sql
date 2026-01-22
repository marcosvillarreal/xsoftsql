use teomayorista04
go
--execute actualizarid 1
go
sp_helpdb teomayorista04
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE teomayorista04
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(teomayorista04, 1);
--Reducimos el log de transacciones a  1 MB.
go
DBCC SHRINKFILE(teomayorista04_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE teomayorista04
SET RECOVERY FULL;
go
sp_helpdb teomayorista04
GO
 execute sp_backupdatabase 'teomayorista04','F'