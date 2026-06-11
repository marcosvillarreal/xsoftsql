use ptovta
go
select cabefac.fecha,tipoiva.tasa,cuerfac.* from cabefac
inner join cuerfac on cabefac.id = cuerfac.idcabeza 
inner join producto on cuerfac.idarticulo = producto.id
inner join tipoiva on producto.idiva = tipoiva.id
where  idarticulo <> 0 --and t = 0
order by cabefac.fecha desc

go
--update cuerfac set tasaiva = t.tasa from cuerfac 
--inner join producto on cuerfac.idarticulo = producto.id
--inner join tipoiva t on producto.idiva = t.id
--where idarticulo <> 0 and cuerfac.tasaiva = 0 
--go
--UPDATE cuerfac
--SET preunitasiva = preunita / (1.0 + (tasaiva / 100.0))
--WHERE preunita = preunitasiva; -- Filtramos los que quedaron idénticos por error
--go
--UPDATE cuerfac
--SET bonisiva = preunitasiva * (despor / 100.0) * kilos
--where bonisiva = boniciva and despor <> 0
--go
--UPDATE cuerfac
--SET totalsiva = totalciva / (1.0 + (tasaiva / 100.0))
--WHERE totalsiva = totalciva; -- Filtramos los que quedaron idénticos por error