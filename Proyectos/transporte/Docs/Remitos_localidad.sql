use elcoyote
go

select m.letra,m.talonario,m.numcomp,co.cabrevia,ca.total,ca.fecha,ca.idprovincia,pca.Nombre as ProvVenta
,(cr.flete + cr.seguro + cr.comireembolso + cr.conexion) as flete,cr.iva
,afe.nrolote
from maopera as m
left join comprobante as co on m.idcomproba = co.id
inner join cabefac as ca on m.id = ca.idmaopera
left join afecabefac as afe on ca.id = afe.idorigen and ca.idmaopera = afe.idmaoperao
left join aferemito as aferto on ca.idmaopera = aferto.idmaoperac
left join provincia as pca on ca.idprovincia = pca.id
left join caberto as cr on afe.idafecta = cr.id or aferto.idmaoperar = cr.idmaopera

where m.estado='0' and m.clasecomp in ('A','B','C','U') and (ca.fecha between '20220808' and '20220808')

order by m.id