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

--select r.id,r.numero+334,r.nombre,recargo,idtipovta,idtipoprod,perceibruto,idfuerzavta,nolista,porcecomi,porcedev,porcesuge,switch,nocomisiona,oferta,fechainicio,fechafin,observaciones,idproveedor1,idproveedor2,idproveedor3,idproveedor4,margen1,bonif1,bonif2,bonif3,bonif4,bonif5,flete,tipoflete,tienedimension
--from  rubro r 
--where not id in (1100001111,1100001116)
--union all
--select r.id,r.numero+333,r.nombre,recargo,idtipovta,idtipoprod,perceibruto,idfuerzavta,nolista,porcecomi,porcedev,porcesuge,switch,nocomisiona,oferta,fechainicio,fechafin,observaciones,idproveedor1,idproveedor2,idproveedor3,idproveedor4,margen1,bonif1,bonif2,bonif3,bonif4,bonif5,flete,tipoflete,tienedimension
--from  rubro r 
--where  id in (1100001111)

