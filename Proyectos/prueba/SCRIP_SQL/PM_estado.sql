use pm
go
select * from empresa where id = 13
select top 1 fecupdate from vendedor where idempresa = 13 order by fecupdate 
select top 1 fecupdate from articulos where idempresa = 13 order by fecupdate 
select top 1 fecupdate from clientes where idempresa = 13 order by fecupdate 
select top 1 fecupdate from movctacte where idempresa = 13 order by fecupdate 