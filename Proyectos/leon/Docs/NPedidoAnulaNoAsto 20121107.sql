use leon
go

--update cabeasi set estado=1 where id in ()

select distinct cabeasi.id,cabeasi.estado,maopera.id,facmaopera.* 
from maopera 
inner join anmaopera on maopera.id = anmaopera.idmaopera
inner join maopera as facmaopera on anmaopera.idafecta = facmaopera.id
inner join tablaasi on facmaopera.id = tablaasi.idmaopera
inner join cabeasi on facmaopera.id = cabeasi.idmaopera
left join tablaasi as antablaasi on maopera.id = antablaasi.idmaopera
where facmaopera.estado = '1'  and maopera.origen = 'FPE' --and maopera.programa ='FACPEDIDO'
and facmaopera.idcomproba <> 38 and isnull(antablaasi.idmaopera,0) = 0
and facmaopera.numcomp like ''
and isnull(cabeasi.estado,0) = 0
order by maopera.id desc
