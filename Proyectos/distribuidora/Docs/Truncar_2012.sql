use libreria
go
sp_helpdb libreria
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE libreria
SET RECOVERY SIMPLE;
GO
--Reducimos el log de transacciones a  1 MB.
DBCC SHRINKFILE(libreria_log, 1);
--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(libreria, 1);
GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE libreria
SET RECOVERY FULL;
go
sp_helpdb libreria
GO
 