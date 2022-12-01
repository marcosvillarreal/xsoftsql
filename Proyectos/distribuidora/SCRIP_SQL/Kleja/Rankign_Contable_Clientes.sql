use kleja

go
select idctacte,ctacte,cnombre,cuit,sum(afecta) as afecta from 
(select ma.numcomp,mo.fecha,mo.ctacte, isnull(afe.importe,mo.total)* afemo.signo as afecta,afemo.fecha as fechamov,mo.idctacte 
,c.cnombre, c.cuit
from maopera as ma
inner join movctacte as mo on ma.id = mo.idmaopera
inner join ctacte as c on mo.idctacte = c.id
left join afectacte as afe on mo.id = afe.idhaber and mo.idmaopera = afe.idmaoperah
left join movctacte as afemo on afe.iddebe = afemo.id and afe.idmaoperad = afemo.idmaopera
left join maopera as afema on afemo.idmaopera = afema.id
where ma.origen in ('COB') and mo.fecha  >= '20220701' and isnull(afemo.fecha,mo.fecha) < '20220701'
and ma.clasecomp='D' and afema.clasecomp in ('A','B','C','U')) as recibos
group by idctacte,ctacte,cnombre,cuit
union all
select idctacte,ctacte,cnombre,cuit,sum(afecta) as afecta from (
select ma.numcomp,mo.fecha,mo.ctacte, mo.saldo*mo.signo as afecta,mo.fecha as fechamov,mo.idctacte  
,c.cnombre, c.cuit
from maopera as ma
inner join movctacte as mo on ma.id = mo.idmaopera
inner join ctacte as c on mo.idctacte = c.id
inner join cabefac as ca on ma.id = ca.idmaopera
where mo.fecha < '20220701' and  mo.saldo <> 0 and ma.clasecomp in ('A','B','C','U')
) as fac
group by idctacte,ctacte,cnombre,cuit
order by afecta desc