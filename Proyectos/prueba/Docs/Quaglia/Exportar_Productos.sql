use quaglia
go
select 
a.numero,a.nombre,a.codalfa,a.codartprod,p.cnombre ,m.nombre,r.nombre,a.unibulto,a.nofactura,a.nolista
,a.minimofac,a.codbarra13,a.codbarra14,iva.tasa,a.prevtaf1



from producto as a
left join ctacte as p on a.idctacte = p.id
left join marca as m on a.idmarca = m.id
left join rubro as r on a.idrubro = r.id
left join tipoiva as iva on a.idiva = iva.id