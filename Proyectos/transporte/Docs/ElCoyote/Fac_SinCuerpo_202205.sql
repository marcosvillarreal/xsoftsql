use elcoyote
go

select * from maopera inner join cabefac on maopera.id = cabefac.idmaopera left join cuerfac on cabefac.id = cuerfac.idcabeza where isnull(cuerfac.id,0) = 0
order by cabefac.id desc
select * from aferemito where idmaoperac  in (0)