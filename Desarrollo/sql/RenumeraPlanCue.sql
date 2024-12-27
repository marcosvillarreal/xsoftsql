USE [meridiem]
GO

/****** Object:  StoredProcedure [dbo].[RenumeraPlanCue]    Script Date: 24/12/2024 09:21:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RenumeraPlanCue]
	-- Add the parameters for the stored procedure here
	@Cuenta int, 
	@CuentaOld int
	AS

	SET NOCOUNT ON;

   update plancue set madre = @cuenta where madre=@cuentaold

GO

