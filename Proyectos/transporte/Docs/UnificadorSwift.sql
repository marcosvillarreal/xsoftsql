use urquiza
go
select convert(char(10),CsrCabeza.fecha,105) as fecha
,CsrCabeza.ctacte as codcliente
,csrproducto.codbarra13 as ean13
,csrcuerpo.nombre as articulo
,(case when csrproducto.vtakilos=1 then 'KG' else 'CJ' end) as univenta
,(case when csrmaopera.clasecomp IN ('A','X','B') then (1) else (-1) end) * 
round(case when csrcuerpo.univenta=1 then csrcuerpo.cantidad / csrproducto.unibulto else csrcuerpo.cantidad end ,3) as cantfac
,csrproducto.unibulto
from maopera as csrmaopera
inner join cabefac as csrcabeza on csrmaopera.id = csrcabeza.idmaopera
inner join cuerfac as csrcuerpo on csrcabeza.id = csrcuerpo.idcabeza
inner join producto as csrproducto on csrcuerpo.idarticulo = csrproducto.id
left join vendedor as csrvendedor on csrmaopera.idvendedor = csrvendedor.id
where csrmaopera.estado = 0 and csrproducto.idctacte = 1100001110
and (csrcabeza.fecha between '20170701' and '20170731')
order by fecha