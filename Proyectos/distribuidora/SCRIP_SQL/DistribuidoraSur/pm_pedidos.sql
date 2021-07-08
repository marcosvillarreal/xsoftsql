use pm
go


select clientes.nombre,cabpedido.fecha,cabpedido.horain,cabpedido.total from cabpedido 
left join clientes on cabpedido.idcliente = clientes.numero and cabpedido.idempresa =clientes.idempresa
where cabpedido.idempresa = 5 
--and vendedor = 7 
--and  idcliente  in (284)
--and total= '0' 
and isnull(loteexportacion,'')=''
order by fecha desc, horain desc
--update cuepedido set cantidad = 0 where id = 21013254
--select * from cuepedido where idcabpedido in (957543)
--select * from articulos where numero = 31042 and idempresa = 5