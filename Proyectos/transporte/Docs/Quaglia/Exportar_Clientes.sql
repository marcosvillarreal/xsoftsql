use quaglia
go
select c.cnumero,c.cnombre,c.cdireccion,l.nombre
,p.nombre,c.ctelefono,c.email,iva.nombre,c.cuit
,cate.nombre,pg.nombre,cv.nombre,c.saldo,c.bonif1,c.bonif2
,b.nombre,c.lista
,(select top 1 dia from cuerruta as cuer
left join caberuta as cabe on cuer.idcaberuta = cabe.id
left join rutavdor as rutv on cabe.idrutavdor = rutv.id
where 1100000003 = cuer.idctacte and rutv.idfuerzavta = 1100000001) as dia
,(select top 1 v.nombre from cuerruta as cuer
left join caberuta as cabe on cuer.idcaberuta = cabe.id
left join rutavdor as rutv on cabe.idrutavdor = rutv.id
left join vendedor as v on rutv.idvendedor = v.id
where 1100000003 = cuer.idctacte and rutv.idfuerzavta = 1100000001) as vendedor
,(select top 1 r.nombre from cuerruta as cuer
left join caberuta as cabe on cuer.idcaberuta = cabe.id
left join rutavdor as rutv on cabe.idrutavdor = rutv.id
left join ruta as r on rutv.idruta = r.id
where 1100000003 = cuer.idctacte and rutv.idfuerzavta = 1100000001) as ruta
,(select top 1 z.nombre from cuerruta as cuer
left join caberuta as cabe on cuer.idcaberuta = cabe.id
left join rutavdor as rutv on cabe.idrutavdor = rutv.id
left join zonaruta as zr on rutv.idruta = zr.idruta
left join zona as z on zr.idzona = z.id
where 1100000003 = cuer.idctacte and rutv.idfuerzavta = 1100000001) as zona
from ctacte as c
left join localidad as l on c.idlocalidad = l.id
left join provincia as p on c.idprovincia = p.id
left join categoiva as iva on c.tipoiva = iva.id
left join catectacte as cate on c.idcategoria = cate.id
left join planpago as pg on c.idplanpago = pg.id
left join canalvta as cv on c.idcanalvta = cv.id
left join barrio as b on c.idbarrio = b.id

where c.ctadeudor= 1 and estadocta = 0
order by c.id