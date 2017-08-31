use prueba
go
SELECT request_session_id sessionid,
 resource_type type,
 resource_database_id dbid,
 OBJECT_NAME(resource_associated_entity_id, resource_database_id) objectname,
 request_mode rmode,
 request_status rstatus
FROM sys.dm_tran_locks
WHERE resource_type IN ('DATABASE', 'OBJECT') and request_mode<>'S'
go
SELECT blocking_session_id, wait_duration_ms, session_id
FROM sys.dm_os_waiting_tasks
WHERE blocking_session_id IS NOT NULL