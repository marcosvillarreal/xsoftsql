use mardones
go
--select * from movctacte where idmaopera = 110000313920
--select * from afectacte where idmaoperah = 110000313920
--select * from movctacte where ctacte = 3380 order by id desc
go

delete from movctacte
where id in 
		(select movctacte.id from movctacte
		inner join afectacte on movctacte.id = afectacte.idhaber and movctacte.idmaopera = afectacte.idmaoperah
		left join movctacte as movrto on afectacte.idmaoperad = movrto.idmaopera and afectacte.iddebe = movrto.id
		where  isnull(movrto.id,0) = 0)

