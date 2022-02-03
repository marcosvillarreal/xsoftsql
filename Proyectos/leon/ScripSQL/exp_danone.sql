use leon 
go
--select p.numero, p.nombre,p.idestado,p.unibulto,p.vtakilos,p.idctacte
--from producto as p
--where p.idctacte in (1100002234,1100002235,1100002232,1100002233,1100002236,1100002237
--) and p.vtakilos = 1

--select s.numero as sucursal,c.cnumero,c.cnombre,c.cdireccion,c.cuit
--,ct.numero as nrocatego, ct.nombre as nomcatego
--,ca.numero as nrocanal, ca.nombre as nomcanal
--,c.estadocta
-- from ctacte as c
--inner join CentroRecep as s on c.idsucursal = c.id
--inner join CanalVta as ca on c.idcanalvta = ca.id
--inner join catectacte as ct on c.idcategoria = ct.id
