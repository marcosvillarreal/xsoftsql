use guerrero
go
USE master;
GO
ALTER DATABASE guerrero 
MODIFY FILE
    (NAME = guerrero_log,
    MAXSIZE = UNLIMITED);
GO