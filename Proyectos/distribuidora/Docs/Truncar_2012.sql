use nuevasirena5
go
sp_helpdb nuevasirena5
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE nuevasirena5
SET RECOVERY SIMPLE;
GO
--Reducimos el log de transacciones a  1 MB.
DBCC SHRINKFILE(nuevasirena5_log, 1);
--Recucimos los archivos eliminados del principal
DBCC SHRINKFILE(nuevasirena5, 1);
GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE nuevasirena5
SET RECOVERY FULL;
go
sp_helpdb nuevasirena5
GO
 