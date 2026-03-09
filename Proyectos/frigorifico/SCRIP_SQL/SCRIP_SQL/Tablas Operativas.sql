use nuevasirena11
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
delete from bonirubro
delete from prodctacon
delete from cbioprecio
delete from antablaasi
delete from antablaimp
delete from ancabeasi
delete from anmaopera
delete from alertas
delete from prodcodbarra
delete from gestion

delete from fleteren
--delete from seguridad
delete from ctactectacon
delete from movctacte
delete from afecabecpra
delete from afecabefac
delete from afeconcilia
delete from afectacte
delete from ctacteflete
delete from ctacte_2
delete from cotizadolar
delete from padronafip
delete from cabedeta
delete from extmaopera
--DELETE FROM CABECOMBO
--delete from cuercombo
--delete from cabepromo
--delete from cuerpromo
delete from cuerdeta
--delete from bonirubrocta

execute actualizarid 1
select * from keysid order by nextid desc
