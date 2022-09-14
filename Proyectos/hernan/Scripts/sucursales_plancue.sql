use mildelicias
go

select 'update plancue set id_old= id, id=',id,',idejercicio=1100000022  where cuenta=',cuenta ,' and idejercicio = 1300000023'
from plancue where idejercicio = 1100000022 order by cuenta

--Una vez cambiado el id eso cambia los paramertros
--select 'update paraconta set idejercicio = 1100000022,idcuenta = ',plancue.id,' where idcuenta = ',plancue.id_old 
--from paraconta inner join plancue on paraconta.idcuenta = plancue.id_old where paraconta.idejercicio = 1300000023

--update detaconta set id = 1100000022 where id = 1300000023
--update paraconfig set idejercicio = 1100000022 where idejercicio = 1300000023

--select 'update valorctacon set idejercicio = 1100000022,idctaa = ',a.id,', idctab=',b.id,',idctac=',c.id,',idctad=',d.id,
--',idctaf=',f.id,',idctak=',k.id,' where id = ', v.ID
--from valorctacon as v
--inner join plancue as a on v.idctaa = a.id_old
--inner join plancue as b on v.idctaa = b.id_old
--inner join plancue as c on v.idctaa = c.id_old
--inner join plancue as d on v.idctaa = d.id_old
--inner join plancue as f on v.idctaa = f.id_old
--inner join plancue as k on v.idctaa = k.id_old
--where v.idejercicio = 1300000023