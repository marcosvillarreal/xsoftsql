use mardones
go
--select ca.id from detaconta where id = 1100000027

update cabeasi set estado=1 where cabeasi.id in (

select ca.id from cabeasi as ca
left join maopera as ma on ca.idmaopera = ma.id
left join movctacte as mo on ma.id = mo.idmaopera
where ca.idejercicio = 1100000027 and ma.origen in ('COB')
and isnull(mo.id,0)= 0
union all
select ca.id from cabeasi as ca
left join maopera as ma on ca.idmaopera = ma.id
inner join movctacte as mo on ma.id = mo.idmaopera
left join afectacte as afe on mo.id = afe.idmaoperah
left join maopera as maafe on afe.idmaoperad = maafe.id
where ca.idejercicio = 1100000027 and ma.origen in ('COB')
and isnull(mo.id,0)<>0 and not isnull(maafe.clasecomp,'X') in ('A','B','C'))