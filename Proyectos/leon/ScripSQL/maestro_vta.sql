use leon
go
select ca.ctacte,1,ca.cnombre,ca.cdireccion,lo.nombre,cn.nombre 
,rtrim(convert(char(8),cu.codigo)) + (case when isnull(cv.idsubarti,0) = 0 then '' else '-'+convert(char(8),sp.subnumero) end)
,rtrim(cu.nombre) + (case when isnull(cv.idsubarti,0) = 0 then '' else '-'+sp.nombre end)
,sum( (case when isnull(cv.idsubarti,0)=0 then cu.cantidad else cv.cantidad end) * p.peso) as vtapeso
,avg(cu.preunitasiva) as preunita
,avg(cu.despor) as bonif
from maopera as m
inner join cabefac as ca on m.id = ca.idmaopera
inner join cuerfac as cu on ca.id = cu.idcabeza
left join cuervari as cv on cu.id = cv.idcuerfac
left join ctacte on ca.idctacte = ctacte.id
left join canalvta as cn on ctacte.idcanalvta = cn.id
left join localidad as lo on ctacte.idlocalidad = lo.id
left join producto as p on cu.idarticulo = p.id
left join subproducto as sp on cv.idsubarti = sp.id
where m.estado=0 and ca.fecha between '20180801' and '20180831'
group by ca.ctacte,ca.cnombre,ca.cdireccion,lo.nombre,cn.nombre ,cu.codigo,cu.nombre,sp.subnumero,cv.idsubarti,sp.nombre
