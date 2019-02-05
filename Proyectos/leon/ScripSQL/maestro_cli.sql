use leon
go
select distinct ca.ctacte,1,ca.cnombre,ca.cdireccion,lo.nombre,cn.nombre 
,(select top 1  v.nombre from cuerruta as cu 
	inner join caberuta as ca on cu.idcaberuta = ca.id
	inner join rutavdor on ca.idrutavdor = rutavdor.id
	inner join ruta on rutavdor.idruta = ruta.id	
	inner join vendedor as v on rutavdor.idvendedor = v.id) as nomvendedor
,(case when isnull((select top 1 ca.dia from cuerruta as cu 
	inner join caberuta as  ca on cu.idcaberuta = ca.id where cu.idctacte = ctacte.id and ca.dia = 2),0) <> 0 then 'S' else 'N' end)
+(case when isnull((select top 1 ca.dia from cuerruta as cu 
	inner join caberuta as ca on cu.idcaberuta = ca.id where cu.idctacte = ctacte.id and ca.dia = 3),0) <> 0 then 'S' else 'N' end)	
+(case when isnull((select top 1 ca.dia from cuerruta as cu 
	inner join caberuta as ca on cu.idcaberuta = ca.id where cu.idctacte = ctacte.id and ca.dia = 4),0) <> 0 then 'S' else 'N' end)	
+(case when isnull((select top 1 ca.dia from cuerruta as cu 
	inner join caberuta as ca on cu.idcaberuta = ca.id where cu.idctacte = ctacte.id and ca.dia = 5),0) <> 0 then 'S' else 'N' end)	
+(case when isnull((select top 1 ca.dia from cuerruta as cu 
	inner join caberuta as ca on cu.idcaberuta = ca.id where cu.idctacte = ctacte.id and ca.dia = 6),0) <> 0 then 'S' else 'N' end)	
+(case when isnull((select top 1 ca.dia from cuerruta as cu 
	inner join caberuta as ca on cu.idcaberuta = ca.id where cu.idctacte = ctacte.id and ca.dia = 7),0) <> 0 then 'S' else 'N' end)	
as ruta
from maopera as m
inner join cabefac as ca on m.id = ca.idmaopera
left join ctacte on ca.idctacte = ctacte.id
left join canalvta as cn on ctacte.idcanalvta = cn.id
left join localidad as lo on ctacte.idlocalidad = lo.id
where m.estado=0 and ca.fecha between '20180801' and '20180831'
order by ca.ctacte
