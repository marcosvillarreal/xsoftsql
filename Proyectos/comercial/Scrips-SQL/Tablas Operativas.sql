use corralon_hgarcia
go

delete from detanrocaja
delete from movstock
delete from cuerfac
delete from tablaimp
delete from cabeasi
delete from tablaasi
delete from renmaope
delete from maopera
delete from cabefac
delete from movcaja
delete from movbcocar
delete from movbcodeta
delete from movtarjeta
delete from subproducto
delete from existenc
delete from cabeord
delete from cuerord
delete from cuervariord
delete from cuercpra
delete from cuervaricpra
delete from cabecpra
delete from prodctacon
delete from cbioprecio
delete from antablaasi
delete from antablaimp
delete from ancabeasi
delete from anmaopera
delete from alertas
delete from gestion
delete from fleteren
delete from seguridad
delete from ctactectacon
delete from movctacte
delete from afecabefac
delete from afeconcilia
delete from afectacte
delete from ctacteflete
delete from cotizadolar
delete from padronafip
delete from cabedeta
delete from emaopera
delete from cuerdeta
delete from movremito
delete from afecompvta
delete from afeguarda
delete from movretiro
delete from movguarda
delete from afemovrto
delete from anmovstock
delete from ancabefac
delete from anmaopera
delete from anmovctacte
delete from anmovcaja
delete from idasociado
delete from afeasto
delete from favoritos
delete from prodelaborado
delete from mapeoimpresora
delete from movcheque
delete from cabeunifica

-- Solo para limpieza total
--delete from producto
--delete from productodeta
--delete from afecateprod
--delete from rubro
--delete from familia
--delete from categotipo
--delete from marca
--delete from prodprecio
--delete from productoimg
--delete from ctacte
--delete from areanegrubro
--delete from prodelaborado



execute actualizarid 1
select * from keysid order by nextid desc
