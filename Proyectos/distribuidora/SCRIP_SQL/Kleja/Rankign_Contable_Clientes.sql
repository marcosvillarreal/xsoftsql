use kleja
go
---Los clientes que mas le deben a Carlos
select c.cnumero,c.cnombre,c.cuit,f.debe,f.haber,f.saldo from (select mo.idctacte
,sum((case when t.debehaber='D' then t.importe else 0 end)) as debe
,sum((case when t.debehaber='H' then t.importe else 0 end)) as haber
,sum(t.importe * (case when t.debehaber='D' then 1  else -1 end)) as saldo
from maopera as m
inner join movctacte as mo on m.id = mo.idmaopera
inner join cabeasi as casto on m.id = casto.idmaopera
inner join tablaasi as t on m.id = t.idmaopera
where casto.idejercicio <= 1100000033 and t.tablaori='MOCT'
and m.origen in ('COB','FAC','FPE')
group by mo.idctacte) as f
left join ctacte as c on f.idctacte = c.id
order by f.saldo desc