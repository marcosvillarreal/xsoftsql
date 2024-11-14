USE [delpuerto]
GO

/****** Object:  StoredProcedure [dbo].[EliminarDuplicados]    Script Date: 14/11/2024 20:11:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EliminarDuplicados]
	-- Add the parameters for the stored procedure here
	@CodAlfa varchar(20),
	@FechaHasta date,
	@IDCtacte int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	delete from producto where id in (select idarticulo from prodprecio where codalfaprov=ltrim(rtrim(@CodAlfa))
	and idctacte = @IDCtacte and fecmodi < @FechaHasta)
	
	delete from prodprecio where codalfaprov=ltrim(rtrim(@CodAlfa))
	and idctacte = @IDCtacte and fecmodi < @FechaHasta
END
GO


