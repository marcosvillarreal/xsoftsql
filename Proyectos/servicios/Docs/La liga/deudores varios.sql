use laligabb
go
--select * from detaconta where ejercicio = 1
--select * from plancue where nombre like 'deudo%' and idejercicio = 1100000001

select distinct t.importe,cu.totalciva,cu.codigo,cu.nombre,r.nombre,m.ctacte,ctacte.cnombre from cabeasi c 
inner join tablaasi t on c.idmaopera = t.idmaopera and t.tablaori= 'MOCT'
inner join movctacte m on c.idmaopera = m.idmaopera
inner join cuerfac cu on m.idmaopera = cu.idmaopera and t.importe = cu.totalciva
inner join ctacte on m.idctacte = ctacte.id
INNER JOIN producto p on cu.idarticulo = p.id
inner join rubro r on p.idrubro = r.id
where c.idejercicio = 1100000001 
--and c.idmaopera = 110000006173
and not t.idcuenta in ( select idctacon from ProdCtactectacon p  where  m.idctacte = p.idctacte)
order by cu.codigo,m.ctacte
go
--select * from plancue where id in ( 1100000199,1100000830,1100000117)
--( select idctacon from ProdCtactectacon p  where p.idctacte = 1100000441)

go
--select * from movctacte where id =  110000006756
--select * from tablaasi where idorigen =  110000006756
--select * from cuerfac where idmaopera = 110000006173
--select t.* from cabeasi c 
--inner join tablaasi t on c.idmaopera = t.idmaopera 
--where  c.numero = 6411
go
--SELECT CsrProdCtactectacon.* FROM ProdCtactectacon as CsrProdCtactectacon
--		where idarticulo in (1100000201) and idctacte = 1100000441
