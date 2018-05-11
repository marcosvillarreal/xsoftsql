use cachitos
go
SELECT 'A' as grupo,CsrMaopera.id as idmaopera
--,CsrMaopera.estado
--,LEFT(CsrMaopera.numcomp,1) as Letra,CsrComprobante.clase as clasecomp
--,RIGHT(LEFT(CsrMaopera.numcomp,5),4) as Talonario
--,RIGHT(CsrMaopera.numcomp,8) as NumComproba
--,SPACE(20) as NumCoe
--,convert(char(8), CsrCabeza.fecha,112) as chrfecha
, CsrCabeza.fecha
--,CAST(CsrCabeza.cnombre as Char(30)) as NomCtacte
--,CsrCabeza.cuit as cuit
,ISNULL(CsrCabeza.dni,'0') as dni,ISNULL(CsrCtacte.dni,'0') as dnictacte
,CsrCabeza.total as TotalFac
,SUM((Case when tipoconce<>'' then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as Total
,SUM((Case when tipoconce='EX' then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalEX
,SUM((Case when tipoconce='PI' then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalPI
,SUM((Case when tipoconce='PB' then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalPB
,SUM((Case when tipoconce='PN' then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalPN
,SUM((Case when tipoconce='PG' then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalPG
,SUM((Case when tipoconce='II' then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalII
,SUM((Case when tipoconce IN ('IG','OI') then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalIG
,SUM((Case when tipoconce IN ('NG') then ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalNG
,SUM((Case when tipoconce IN ('DC') then ISNULL(Csrtablaimp.baseimp,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalDC
,SUM((Case when tipoconce IN ('DC') then ISNULL(Csrtablaimp.importe - CsrTablaimp.baseimp,CAST(0 as numeric(12,2))) else CAST(0 as numeric(12,2)) end)) as TotalDCIG
,0 as Dolar	,0 as EsCanje, CsrCategoiva.abrevia	
from CabeFac as CsrCabeza
left join maopera as Csrmaopera on CsrCabeza.idmaopera = Csrmaopera.id
left join categoiva as Csrcategoiva on CsrCabeza.idtipoiva = Csrcategoiva.id
left join comprobante as Csrcomprobante on Csrmaopera.idcomproba = Csrcomprobante.id
left join tablaimp as csrtablaimp on Csrmaopera.id = csrtablaimp.idmaopera
left join ctacte as Csrctacte on CsrCabeza.idctacte = CsrCtacte.id
where (CsrCabeza.fecha Between '20180401' and '20180602') 
and Csrmaopera.origen IN ('FAC','FPE') and Csrmaopera.clasecomp IN ('A','B','C','U') 
AND CsrMaopera.numcomp like 'B0003%001678' 
--and CsrMaopera.id = 110000005229
GROUP BY CsrMaopera.id ,CsrMaopera.estado
,CsrMaopera.numcomp,CsrComprobante.clase 
,CsrCabeza.fecha,CsrCategoiva.abrevia
,CsrCabeza.cnombre ,CsrCabeza.cuit,CsrCabeza.dni,CsrCtacte.dni,CsrCabeza.Total
Order by CsrCabeza.fecha,LEFT(CsrMaopera.numcomp,1),CsrMaopera.numcomp,CsrMaopera.estado