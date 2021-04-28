use leon
go
select * from ctacte where cnombre like '%paladini%'
go
select cu.codigo,cu.nombre,sum(cu.cantidad * ca.signo * (-1)) as cantidad
,sum(cu.kilos * ca.signo * (-1)) as kilos
 from maopera
inner join cabecpra as ca on maopera.id =ca.idmaopera
inner join cuercpra as cu on ca.id = cu.idcabeza
where ca.fecha between '20210301' and '20210430'
and ca.idctacte in (1100002345,1100000801,1100001540)
and maopera.estado = 0
group by cu.codigo,cu.nombre