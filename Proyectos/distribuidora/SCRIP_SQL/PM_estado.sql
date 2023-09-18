use pm
go
select * from empresa where id = 13
select top 1 fecupdate,idempresa,'Vendedor' as tabla from vendedor --where idempresa = 6
order by fecupdate desc
select top 1 fecupdate,idempresa,'Rubros' as tabla from secciones --where idempresa = 6 
order by fecupdate desc
select top 1 fecupdate,idempresa,'Articulos' as tabla from articulos --where idempresa = 6 
order by fecupdate desc
select top 1 fecupdate,idempresa,'Variedades' as tabla from codbarras --where idempresa = 3
order by fecupdate desc
select top 1 fecupdate,idempresa,'Clientes' as tabla from clientes --where idempresa = 6 
order by fecupdate desc
select top 1 fecupdate,idempresa,'Cta.Cte.' as tabla from movctacte --where idempresa = 13 
order by fecupdate  desc