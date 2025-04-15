use tapia
go
select ca.ctacte,ca.cnombre
,rtrim(convert(char(8),cu.codigo)) + (case when isnull(cv.idsubarti,0) = 0 then '000'
else ( case when len(ltrim(sp.codartprovee))=0 then 
	right('000'+rtrim(ltrim(convert(char(8),sp.subnumero))),3) 
	else ltrim(sp.codartprovee)  end) end)
,rtrim(cu.nombre) + (case when isnull(cv.idsubarti,0) = 0 then '' else '-'+sp.nombre end)
,sum( (case when isnull(cv.idsubarti,0)=0 then cu.cantidad else cv.cantidad end) * p.peso) as vtapeso
,avg(cu.preunitasiva) as preunita
,avg(cu.despor) as bonif
,((case when isnull(cv.idsubarti,0) = 0 then sum(cu.cantidad) 
else sum(cv.cantidad) end)/ (case when cu.unibulto =0 then 1 else cu.unibulto end )) * ca.signo as bultos
,(case when isnull(cv.idsubarti,0) = 0 then sum(cu.cantidad) 
else sum(cv.cantidad) end) * ca.signo as cantidad
,cu.unibulto
,convert(char(10),ca.fecha,105)as fecha
from maopera as m
inner join cabefac as ca on m.id = ca.idmaopera
inner join cuerfac as cu on ca.id = cu.idcabeza
left join cuervari as cv on cu.id = cv.idcuerfac
left join ctacte on ca.idctacte = ctacte.id
left join canalvta as cn on ctacte.idcanalvta = cn.id
left join localidad as lo on ctacte.idlocalidad = lo.id
inner join producto as p on cu.idarticulo = p.id
left join subproducto as sp on cv.idsubarti = sp.id
where m.estado=0 and ca.fecha between '20250201' and '20250228' 
and p.idctacte in (1100001480,1100001481)
and (cu.escambio = 0 or p.espromocion = 0)
and M.claseCOMP in ('A','B','C')
and not ca.ctacte in (921,1060)
group by ca.ctacte,ca.cnombre,ca.cdireccion,lo.nombre,cn.nombre ,cu.codigo,cu.nombre,sp.subnumero,cv.idsubarti,sp.nombre
,ca.fecha,sp.codartprovee,cu.unibulto, ca.signo
order by ca.cnombre 