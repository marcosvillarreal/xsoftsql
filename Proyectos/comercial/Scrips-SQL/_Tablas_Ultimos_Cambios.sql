use comercio
go
SELECT *  FROM sys.objects
WHERE type = 'U'
ORDER BY modify_date DESC