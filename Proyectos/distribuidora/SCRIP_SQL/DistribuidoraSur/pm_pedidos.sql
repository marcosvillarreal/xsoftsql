use pm
go

--update cabpedido set tipodepedido = 1 , remito = 2 where idempresa = 5 and vendedor = 5 and left(ltrim(observaciones),1)='R'
--update cabpedido set  tipodepedido=1, remito = 0  where idempresa = 5 and vendedor = 9 and isnull(remito,0)=0
--update cabpedido set loteexportacion = '' where id = 1006216
select clientes.nombre,cabpedido.* from cabpedido 
left join clientes on cabpedido.idcliente = clientes.numero and cabpedido.idempresa =clientes.idempresa
where cabpedido.idempresa = 5 
and vendedor = 8
and  idcliente  in (210)
and (total <> '0' and total<>'')
--and isnull(loteexportacion,'')=''
--AND ISNULL(TIPODEPEDIDO,'0')<>'0'
order by fecha desc, horain desc
--update cuepedido set cantidad = 0 where id = 22566766
select * from cuepedido where idcabpedido in (986873,986872)
--select * from articulos where numero = 20639 and idempresa = 5