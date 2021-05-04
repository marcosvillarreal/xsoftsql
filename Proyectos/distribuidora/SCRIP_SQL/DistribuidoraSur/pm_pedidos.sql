use pm
go
--update cabpedido set loteexportacion='' where id = 922029

select clientes.nombre,cabpedido.* from cabpedido 
left join clientes on cabpedido.idcliente = clientes.numero and cabpedido.idempresa =clientes.idempresa
where cabpedido.idempresa = 5 and vendedor = 9 --and idcliente = 1007--and total= '0' --and loteexportacion='-20210427'
order by fecha desc, horain desc
--update cuepedido set cantidad = 0 where id = 21013254
select * from cuepedido where idcabpedido in (925429)
select * from articulos where numero = 31042 and idempresa = 5