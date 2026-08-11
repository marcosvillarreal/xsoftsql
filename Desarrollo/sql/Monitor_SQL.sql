use leon

go

---- 1. Limpia los planes compilados en caché (fuerza a recompilar usando el nuevo índice)
--DBCC FREEPROCCACHE;

---- 2. Limpia los datos de las tablas de la memoria RAM (fuerza a leer desde el disco por primera vez)
--DBCC DROPCLEANBUFFERS;
--go

SELECT TOP 10
    qs.total_elapsed_time / 1000 AS TiempoTotal_ms,
    qs.total_elapsed_time / qs.execution_count / 1000 AS TiempoPromedio_ms,
    qs.total_logical_reads AS LecturasLogicas,
    qs.execution_count AS CantidadEjecuciones,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset)/2) + 1) AS QueryExacta
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
WHERE st.text NOT LIKE '%sys.dm_exec_query_stats%'
ORDER BY qs.total_elapsed_time / qs.execution_count DESC;