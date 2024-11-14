use delpuerto
go
select ltrim(rtrim(codalfaprov)) as codalfaprov ,idctacte,count(*) as precio from prodprecio 
where idctacte in (1100000249)
group by codalfaprov ,idctacte
having count(*)> 1 order by codalfaprov
go

go
SELECT Csrproducto.id,CsrProducto.nombre,ISNULL(Tipoiva.tasa,0) as tasa, ISNULL(CsrProdPrecio.codalfaprov,SPACE(20)) as CodAlfaPrecio
,ISNULL(CsrProdPrecio.id, CAST(0 as int)) as idprodprecio
,ISNULL(CsrProdPrecio.fecmodi, convert(date,'1900-01-01')) as fecmodiprecio
,remito.cantidad,cuerpo.cantidad
 FROM Producto as Csrproducto
LEFT JOIN Tipoiva on Csrproducto.idiva = Tipoiva.id 
left join ProdPrecio as csrProdPrecio on CsrProducto.id = CsrProdPrecio.idarticulo and CsrProducto.idctacte = CsrProdPrecio.idctacte
left join (select mo.idarticulo,SUM(cantidad) as cantidad from maopera as m
	inner join movremito as mo on m.id = mo.idmaopera
	group by mo.idarticulo) as remito on csrproducto.id =remito.idarticulo
left join (select mo.idarticulo,SUM(cantidad) as cantidad from maopera as m
	inner join cuerfac as mo on m.id = mo.idmaopera
	group by mo.idarticulo) as cuerpo on csrproducto.id =cuerpo.idarticulo
where CsrProducto.idctacte in (1100000249)
--and (remito.cantidad > 0 or cuerpo.cantidad>0)
order by CsrProdPrecio.codalfaprov,CsrProdPrecio.fecmodi desc