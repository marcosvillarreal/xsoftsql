USE [master]
GO
/****** Objeto:  StoredProcedure [dbo].[sp_BackupDatabase]    Fecha de la secuencia de comandos: 10/29/2016 12:49:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Author: Edgewood Solutions  
-- Create date: 2007-02-07  
-- Description: Backup Database  
-- Parameter1: databaseName  
-- Parameter2: backupType F=full, D=differential, L=log
-- =============================================  
CREATE PROCEDURE [dbo].[sp_BackupDatabase]   
       @databaseName sysname, @backupType CHAR(1)  
AS  
BEGIN  
       SET NOCOUNT ON;  

       DECLARE @sqlCommand NVARCHAR(1000)  
       DECLARE @dateTime NVARCHAR(20)  

       SELECT @dateTime = REPLACE(CONVERT(VARCHAR, GETDATE(),111),'/','') +  
       REPLACE(CONVERT(VARCHAR, GETDATE(),108),':','')   

       IF @backupType = 'F'  
               SET @sqlCommand = 'BACKUP DATABASE ' + @databaseName +  
               ' TO DISK = ''C:\BackupSQL\Data\' + @databaseName + '_Full_' + @dateTime + '.BAK'''  
         
       IF @backupType = 'D'  
               SET @sqlCommand = 'BACKUP DATABASE ' + @databaseName +  
               ' TO DISK = ''C:\BackupSQL\Data\' + @databaseName + '_Diff_' + @dateTime + '.BAK'' WITH DIFFERENTIAL'  
         
       IF @backupType = 'L'  
               SET @sqlCommand = 'BACKUP LOG ' + @databaseName +  
               ' TO DISK = ''C:\BackupSQL\Data\' + @databaseName + '_Log_' + @dateTime + '.TRN'''  
         
       EXECUTE sp_executesql @sqlCommand  
END
