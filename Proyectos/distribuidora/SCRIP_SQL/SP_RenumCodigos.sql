USE [distribuidorasur]
GO
/****** Object:  StoredProcedure [dbo].[RenumCodigos]    Script Date: 25/8/2021 18:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[RenumCodigos]
	-- Add the parameters for the stored procedure here
	@lnidmarca int, @lnidrubro int, @lnbase int

AS
BEGIN
	IF @lnidrubro<> 0
		begin
			;with art as 
			(
			select *,ROW_NUMBER() OVER(ORDER BY numero) + @lnbase AS RowNum
			from producto
			where idmarca = @lnidmarca	and idrubro = @lnidrubro
			)
			update art set numero = RowNum
		end
	else
		begin
			;with art as 
			(
			select *,ROW_NUMBER() OVER(ORDER BY idrubro,numero) + @lnbase AS RowNum
			from producto
			where idmarca = @lnidmarca
			)
			update art set numero = RowNum
		end
END
