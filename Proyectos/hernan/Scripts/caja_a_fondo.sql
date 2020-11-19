use mildelicias
go
select top 5 * from maopera

where id in (
	select distinct idmaopera from tablaasi
	left join plancue on tablaasi.idcuenta = plancue.id
	inner join clasecta on plancue.idclase = clasecta.id
	where clasecta.cnumero = 'SU')
and clasecomp = 'Y' and idcomproba = 33
order by fechasis desc
go
select * from usuarios