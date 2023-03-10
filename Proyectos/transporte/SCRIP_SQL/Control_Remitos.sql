use elcoyote

go

select   'A' as grupo,m.id,m.programa,m.letra,m.talonario,m.numcomp,co.cabrevia,ca.total,ca.fecha
,m.id as idmaopera,cr.id
,cast( ca.signo*(cr.flete + cr.seguro + cr.comireembolso + cr.conexion)  * (1  + (ca.bonif1/100)) as numeric(16,2)) as flete
,cast(ca.signo*(select sum(importe) from tablaimp with(index(idmaopera)) where idmaopera = m.id and tipoconce='NG') as numeric(16,2)) as neto
,ca.signo*(select sum(importe) from tablaimp with(index(idmaopera)) where idmaopera = m.id and tipoconce='IG') as iva_fac
,m.idcomproba, ca.idtiponcredito, ca.idtipoiva
from maopera as m
left join comprobante as co on m.idcomproba = co.id
inner join cabefac as ca on m.id = ca.idmaopera
left join afecabefac as afe with(index(idmaoperao)) on ca.id = afe.idorigen and ca.idmaopera = afe.idmaoperao
left join aferemito as aferto on ca.idmaopera = aferto.idmaoperac
left join provincia as pca on ca.idprovincia = pca.id
left join caberto as cr on afe.idafecta = cr.id or aferto.idmaoperar = cr.idmaopera
left join localidad as lrto on cr.idlocalidad_rte = lrto.id
left join provincia as prto on lrto.idprovincia = prto.id
where m.estado='0' and m.clasecomp in ('A','B','C','U') and (ca.fecha between '20230307' and '20230307')
order by ca.fecha,m.ID,CR.ID
	