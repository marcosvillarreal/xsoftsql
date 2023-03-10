use pm
go

--update cabpedido set tipodepedido = 1 , remito = 2 where idempresa = 5 and vendedor = 5 and left(ltrim(observaciones),1)='R'
--update cabpedido set  tipodepedido=1, remito = 0  where idempresa = 5 and vendedor = 9 and isnull(remito,0)=0
--update cabpedido set loteexportacion = '',remito =2,tipodepedido=1 where id in ( 1042637 ,1042664,
--1042653,1042652,1042651,1042650,1042649,1042660,1042647,1042643,1042646,1042688,1042699,1042696,1042700,
--1042690,1042689,1042691,1042692,1042695,1042697,1042693,1042694,1042686,1042698,1042684,1042681,1042682,
--1042683,1042685,1042687 )
--update cabpedido set loteexportacion = '',remito =2,tipodepedido=1 where id in ( 1046333,1046289,1046336,
--1046337,1046298,1046297,1046307,1046343,1046309,1046310,1046311,1046313,1046314,1046346,1046315,1046317,
--1046318,1046319,1046347,1046348,1046349,1046350,1046351,1046352,1046353,1046354,1046355,1046356,1046357,
--1046358,1046320,1046321,1046324,1046325,1046326,1046327,1046328,1046329 )

select clientes.nombre,cabpedido.* from cabpedido 
left join clientes on cabpedido.idcliente = clientes.numero and cabpedido.idempresa =clientes.idempresa
where cabpedido.idempresa = 4
--and vendedor = 8
--and  idcliente  in (69)
--and (total <> '0' and total<>'')
and left(isnull(loteexportacion,''),8)<>''
--AND ISNULL(TIPODEPEDIDO,'0')<>'0'
--AND REMITO = 2
and pagoEfectivo = '-1'
order by fecha desc, horain desc
--update cuepedido set cantidad = 0 where id = 22566766
--select * from cuepedido where idcabpedido in (986873,986872)
--select * from articulos where numero = 20639 and idempresa = 5