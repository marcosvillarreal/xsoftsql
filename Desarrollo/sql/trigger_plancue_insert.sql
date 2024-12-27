USE [meridiem]
GO

/****** Object:  Trigger [dbo].[insert_plancue]    Script Date: 23/12/2024 19:34:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[insert_plancue]
   ON  [dbo].[plancue]
   AFTER  INSERT
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update cabpedido set cuenta_old = cuenta where Id in (select id from inserted) 
    -- Insert statements for trigger here

END
GO

ALTER TABLE [dbo].[plancue] ENABLE TRIGGER [insert_plancue]
GO


