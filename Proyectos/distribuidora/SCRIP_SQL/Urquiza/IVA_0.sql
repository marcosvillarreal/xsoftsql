use MARDONES
go
SELECT 	'K' as grupo,CAST(CsrTipoiva.id as numeric(12)) as id,SPACE(13) as numcomp,SPACE(8) as chrfecha
	,CAST(CsrTipoiva.nombre  as Char(30)) as cnombre

	,SUM(ISNULL(CsrCuerfac.totalsiva,0)* ISNULL(CsrCabeza.signo,1)) as TotalNG
	,SUM(ISNULL(cast(CsrCuerfac.totalsiva*(1+CsrTipoiva.tasa/100) as numeric(12,2)),0)* ISNULL(CsrCabeza.signo,1)) as TotalIG
	,SPACE(30)  as nomcatego,SPACE(31) as nomcompro,'0' as estado
	from cabefac as Csrcabeza
	left join maopera as Csrmaopera on Csrcabeza.idmaopera = Csrmaopera.id
	left join cuerfac as CsrCuerfac on CsrCabeza.id = CsrCuerfac.idcabeza
	inner join producto as CsrProducto on Csrcuerfac.idarticulo = CsrProducto.id
	left join marca as CsrMarca on CsrProducto.idmarca = CsrMarca.id
	left join categoiva as Csrcategoiva on Csrcabeza.idtipoiva = Csrcategoiva.id
	left join tipoiva as csrTipoiva on CsrProducto.idiva = CsrTipoiva.id
	
	
	where Csrcabeza.fecha >= '20191001'AND Csrcabeza.fecha <= '20191031' and Csrmaopera.origen IN ('FAC','FPE') and Csrmaopera.clasecomp IN ('A','B','C','U') 
	and CsrMaopera.estado='0' 
	AND LEFT(CsrMaopera.numcomp,1)<>' ' 
	and CsrMaopera.idcomproba  > 0 and CsrCuerfac.escambio = 0
	and CsrCuerfac.tasaiva = 0
	GROUP BY CsrTipoiva.nombre,CsrTipoiva.id,CsrTipoiva.tasa