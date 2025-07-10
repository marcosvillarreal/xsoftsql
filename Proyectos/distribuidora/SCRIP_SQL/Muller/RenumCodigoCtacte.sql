USE [distmuller]
GO

/****** Object:  StoredProcedure [dbo].[RenumerarCodigosCtacte]    Script Date: 10/7/2025 11:08:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[RenumerarCodigosCtacte]
		@nCodVendedor int, @lnbase int



AS
BEGIN
	IF @nCodVendedor = 0
		begin
			;with prov as 
			(
			select *,ROW_NUMBER() OVER(ORDER BY id) + @lnbase AS RowNum
			from ctacte
			where ctadeudor=0
			)
			update prov set cnumero = convert(char(8),RowNum)
		end
	else
		begin
			;with cli as 
			(
			select *,ROW_NUMBER() OVER(ORDER BY id) + @lnbase AS RowNum
			from ctacte
			where ctadeudor = 1 
			and id in ( select cu.idctacte from cuerruta as cu
			inner join caberuta as ca on cu.idcaberuta = ca.id
			inner join rutavdor as rv on ca.idrutavdor = rv.id
			inner join vendedor as v on rv.idvendedor = v.id
			where v.numero = @nCodVendedor
			)
			)
			update cli set cnumero = convert(char(8),RowNum)
		end
END
GO

