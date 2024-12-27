USE [meridiem]
GO

/****** Object:  Trigger [dbo].[update_plancue]    Script Date: 23/12/2024 19:34:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[update_plancue] 
   ON  [dbo].[plancue] 
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	update plancue set madre = cuenta where madre in (select cuenta_old from inserted)  
	update plancue set cuenta_old = cuenta where id in (select id from inserted) 

END
GO

ALTER TABLE [dbo].[plancue] ENABLE TRIGGER [update_plancue]
GO


