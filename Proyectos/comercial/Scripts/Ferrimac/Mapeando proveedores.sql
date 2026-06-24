use ferrimac
go

update ctacte set idctafortin =1100004738   where id = 1100000465
go
select c.id,cnumero,c.cnombre,c.cuit,c.observa
--select distinct r.*
from  ctacte  c
where id in (select distinct idctacte from producto)
and isnull(idctafortin ,-1) = -1
and cnombre > 'D'
order by c.cnombre,c.cuit desc

--use fortin
--go

--select distinct c.id,cnumero,c.cnombre,c.cuit
----select distinct r.*
--from producto p
--inner join ctacte  c on p.idctacte = c.id
--where cnombre > 'D' order by c.cnombre,c.cuit desc
