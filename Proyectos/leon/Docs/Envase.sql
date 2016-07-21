use leon
go
SELECT CsrCuerpo.id as idfleteplan,CsrCuerpo.numero,CsrEnvase.id,CsrEnvase.numero,CsrEnvase.nombre
,SUM(CAST(CsrCuerfac.cantidad * CsrCabefac.signo as numeric(15,2))) as unidades
,SUM(CAST(CsrCuerfac.cantidad /Csrcuerfac.unibulto * CsrCabefac.signo as numeric(15,2))) as CanBultos
From FletePlanilla as CsrCuerpo
Left Join FleteCarga as CsrFleteCarga on CsrCuerpo.id = CsrFleteCarga.idfleteplan
Left Join NCabefac as CsrNCabefac on CsrFleteCarga.idmaopera = CsrNCabefac.idmaopera
Left Join AfeNPedido as CsrAfeNPedido on CsrNCabefac.idmaopera = CsrAfeNPedido.idmaoperan
Left Join Maopera as CsrMaopera on CsrAfeNPedido.idmaoperac = CsrMaopera.id
Left Join Cabefac as CsrCabefac on CsrMaopera.id = CsrCabefac.idmaopera
Left Join Cuerfac as CsrCuerfac on CsrMaopera.id = CsrCuerfac.idmaopera
Left Join CuerVari as CsrCuerVari on CsrCuerfac.id = CsrCuerVari.idcuerfac
Left Join Producto as CsrProducto on CsrCuerfac.idarticulo = CsrProducto.id
Inner Join Producto as CsrEnvase on CsrProducto.idenvase = CsrEnvase.id
Where CsrCuerpo.id in (1100008149,1100008150,1100008153,1100008157) and CsrCuerpo.estado = 0 and LEFT(CsrCuerpo.switch,1) <> '1'
and CsrMaopera.estado = 0 and CsrMaopera.clasecomp <> 'K' and LEFT(CsrMaopera.numcomp,1)<>' '
group by CsrCuerpo.id,CsrCuerpo.numero,CsrEnvase.id,CsrEnvase.numero,CsrEnvase.nombre
order by CsrCuerpo.numero