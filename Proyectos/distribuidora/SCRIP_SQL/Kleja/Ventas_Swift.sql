use kleja
go
select v.numero,v.nombre,r.numero,r.nombre,p.numero,p.nombre
,SUM(cu.cantidad*ca.signo) as cantidad
from maopera as ma
inner join cabefac as ca on ma.id = ca.idmaopera
inner join cuerfac as cu on ca.id = cu.idcabeza
inner join producto as p on cu.idarticulo = p.id
inner join rubro as r on p.idrubro = r.id
inner join vendedor as v on ma.idvendedor = v.id
where ca.fecha between '20250501' and '20250630'
and p.idctacte = 1100001985
group by v.numero,v.nombre,r.numero,r.nombre,p.numero,p.nombre
order by v.numero,r.numero,p.numero