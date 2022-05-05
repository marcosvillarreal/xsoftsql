use grutamat
go

select maopera.fechaserver, maopera.fechaserver,maopera.numcomp, MOVREMITO.FECHA,ctacte.cnumero, ctacte.cnombre, producto.numero, movremito.nombre, movremito.cantidad
,(case when movremito.activo=0 then 'ANULADO' ELSE '' END), movremito.motivo 
from maopera inner join movremito on maopera.id = movremito.idmaopera 
inner join ctacte on movremito.idctacte = ctacte.id
inner join producto on movremito.idarticulo = producto.id
where sucursal = 1 and fechasis between '20220422' and '20220428'  --and movremito.activo = 1
-- and idarticulo = 1100001938
order by maopera.id
go
select maopera.fechaserver,maopera.fechaserver,maopera.numcomp,cabefac.fecha,cabefac.ctacte,cabefac.cnombre,cuerfac.codigo,cuerfac.nombre,cuerfac.cantidad from maopera  inner join cabefac on maopera.id = cabefac.idmaopera
inner join cuerfac on cabefac.id = cuerfac.idcabeza
where sucursal = 1 and fechasis between '20220422' and '20220428' and idcomproba = 29  order by maopera.id 