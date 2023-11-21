use distribuidorakm
go
sp_helpdb distribuidorakm
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE distribuidorakm
SET RECOVERY SIMPLE;
GO

--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(distribuidorakm, 1);
--Reducimos el log de transacciones a  1 MB.
DBCC SHRINKFILE(distribuidorakm_log, 1);

GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE distribuidorakm
SET RECOVERY FULL;
go
sp_helpdb distribuidorakm
GO
 