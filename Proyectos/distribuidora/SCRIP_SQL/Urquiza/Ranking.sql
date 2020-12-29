use mardones
go
select top 5 ca.cuit,ca.cnombre ,sum(ca.signo*(cu.totalsiva)) as total from maopera as ma
left join cabefac as ca on ma.id = ca.idmaopera
left join cuerfac as cu on ca.id = cu.idcabeza
where ma.origen in ('FAC','FPE') and ma.clasecomp in ('A','B','C','U')
and ca.fecha between '20200601' and '20200630'
group by ca.cuit,ca.cnombre
order by total desc

go

select top 5 ca.cuit,ca.cnombre ,sum((-1)*ca.signo*(ta.importe)) as total from maopera as ma
left join cabecpra as ca on ma.id = ca.idmaopera
left join tablaimp as ta on ma.id = ta.idmaopera
where ma.origen in ('CPR') and ma.clasecomp in ('A','B','C','U')
and ca.fecha between '20200601' and '20200630'
and ta.tipoconce='NG' and ma.estado = 0
group by ca.cuit,ca.cnombre
order by total desc