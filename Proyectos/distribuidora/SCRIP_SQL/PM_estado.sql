use pm
go
select * from empresa where id = 16
select top 1 fecupdate,idempresa from vendedor --where idempresa = 13 
order by fecupdate desc
select top 1 fecupdate,idempresa from articulos --where idempresa = 13 
order by fecupdate desc
select top 1 fecupdate,idempresa from clientes --where idempresa = 13 
order by fecupdate desc
select top 1 fecupdate,idempresa from movctacte --where idempresa = 13 
order by fecupdate  desc