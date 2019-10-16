use urquiza
go
--sp_helpdb urquiza
---- Antes de truncar el log cambiamos el modelo de recuperación a SIMPLE.
--ALTER DATABASE urquiza
--SET RECOVERY SIMPLE;
--GO
----Reducimos el log de transacciones a  1 MB.
--DBCC SHRINKFILE(urquiza_log, 1);
--GO
---- Cambiamos nuevamente el modelo de recuperación a Completo.
--ALTER DATABASE urquiza
--SET RECOVERY FULL;
--GO
 