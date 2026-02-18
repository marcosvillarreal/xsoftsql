use laligabb

go


select --*,
ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as id,
a.idmaoperah as idmaopera, m.id as idorigen, 'MOCT' as tablaori, 1100000969 as idcuenta,'ZZ' as tipoconce,
(case when m.signo =1 then 'H' else 'D' end) as debehaber,a.importe,'' as detalle
from movctacte m
inner join afectacte a on m.id = a.iddebe
left  join tablaasi t on a.iddebe = t.idorigen and t.tablaori='MOCT'
where m.detalle like '___.inter%' and isnull(t.id,0) = 0
AND not a.idmaoperah in (110000000124,110000000222,110000000226,110000000134,110000000145,110000000235,110000000238,110000000283,110000000321,110000000491,110000002460,110000003026,110000003202)
order by m.id
go
----select * from tablaasi where idorigen = 0 and detalle like 'RECO%'
--select * from tablaasi where idmaopera in (110000000036,110000000053,110000000124,110000000128,110000000131,110000000134,110000000145,110000000222,110000000229)
--select * from movctacte where idmaopera = 110000000036 or id in (110000000050,110000000051,110000000052,110000000060,110000000061,110000000062)


select *,
'update tablaasi set debehaber= '+(case when t.debehaber='H' then '''D''' else '''H''' end)+' where id = '+convert(char(12),t.id)  as q
from movctacte m
inner join maopera ma on m.idmaopera = ma.id and ma.clasecomp in ('C','0','G')
inner join afectacte a on m.id = a.iddebe
left  join tablaasi t on a.iddebe = t.idorigen and t.tablaori='MOCT' and a.idmaoperah = t.idmaopera
inner join maopera ma2 on t.idmaopera = ma2.id  and ma2.origen='COB' and rtrim(ma2.programa) <>'REGINTERNO'
where m.signo=-1 and not t.id in (110000000729,110000000732,110000000734,110000000923)
order by m.id

go
