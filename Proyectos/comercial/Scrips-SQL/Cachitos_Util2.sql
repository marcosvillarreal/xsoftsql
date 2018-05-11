use cachitos
go

--update tablaimp set importe=489.80,baseimp=2332.39,detalle='m' where id = 110000000071
--update tablaimp set importe=-113.48,detalle='m' where id = 110000001860
--update tablaimp set importe=-113.87,detalle='m' where id = 110000001860
--
update tablaimp set IMPORTE = 55390.410,detalle='m',TIPOCONCE='EX',tasa=0 where id = 110000001866
update tablaimp set tasa = 0,importe=0,baseimp=0,detalle='m' where id = 110000001867

--select * from maopera where id  in (110000004588)
select * from tablaimp
where idmaopera = 110000004587
order by tipoconce
select IDMAOPERA,ID,CTACTE,FECHA,total,bonif1 from cabefac where idmaopera =  110000003055
select idmaopera,tasaiva ,sum(totalciva), sum(totalsiva)
from cuerfac where idmaopera = 110000004587
group by idmaopera,tasaiva

--select * from afedmaope where idmaopera=110000004587
--select * from dimpuestos  where idmaopera = 110000004587

--select * from cabefac where idlotemaopera in (110000005229)

--update cabefac set total = 0 where id in (110000001473)



