use nuevasirena6
go
sp_helpdb nuevasirena6
-- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
ALTER DATABASE nuevasirena6
SET RECOVERY SIMPLE;
GO
--Reducimos el log de transacciones a  1 MB.
DBCC SHRINKFILE(nuevasirena6_log, 1);
--Recucimos los archivos eliminados del principal

--DBCC SHRINKFILE(nuevasirena6, 1);
GO
-- Cambiamos nuevamente el modelo de recuperación a Completo.
ALTER DATABASE nuevasirena6
SET RECOVERY FULL;
go
sp_helpdb nuevasirena6
GO
 