use leon
go
BACKUP LOG leon WITH TRUNCATE_ONLY DBCC SHRINKDATABASE ( leon , TRUNCATEONLY ) 