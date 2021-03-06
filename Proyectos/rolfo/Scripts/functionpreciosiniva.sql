USE [datos]
GO
/****** Object:  UserDefinedFunction [dbo].[f_preciosiniva]    Script Date: 07/18/2008 02:40:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[f_preciosiniva] ( @precioconiva numeric(11,3),@tasaiva numeric(6,3),@interno numeric(11,3) )
RETURNS numeric(11,3)
AS
BEGIN
DECLARE @nnbase numeric(11,3)
DECLARE @netogravado numeric(11,3)
DECLARE @netogravadoeinternos numeric(11,3)
DECLARE @iva numeric(11,3)
select @nnbase = @precioconiva - @interno
SELECT @netogravado = @nnbase / (1 + @tasaiva/100)
select @iva = @nnbase - @netogravado
select @netogravadoeinternos = @netogravado + @interno
RETURN @netogravadoeinternos
END



