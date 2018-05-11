use cachitos
go
SELECT 	'A' as grupo,Csrmaopera.id as id,Csrmaopera.numcomp as numcomp,LEFT(CONVERT(Char,Csrcabeza.fecha,112),8) as chrfecha
	,(case when CsrMaopera.estado='0' then Csrcabeza.cnombre else 'COMPROBANTE ANULADO          ' end) as cnombre
	,Csrcabeza.cuit as cuit,CsrCabeza.signo as signo,0 as tasa
	,sum((Case when Csrtablaimp.tipoconce = 'PB' then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalPB
	,sum((Case when Csrtablaimp.tipoconce = 'PG' then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalPG
	,sum((Case when Csrtablaimp.tipoconce = 'PI'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalPI
	,sum((Case when Csrtablaimp.tipoconce = 'PN'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalPN
	,sum((Case when Csrtablaimp.tipoconce = 'EX'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalEX
	,sum((Case when Csrtablaimp.tipoconce = 'RB'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalRB
	,sum((Case when Csrtablaimp.tipoconce = 'RG'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalRG
	,sum((Case when Csrtablaimp.tipoconce = 'RI'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalRI
	,sum((Case when Csrtablaimp.tipoconce = 'NG'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)
	+ (Case when Csrtablaimp.tipoconce = 'DC'	then ISNULL(Csrtablaimp.baseimp * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)
	) as TotalNG
	,sum((Case when Csrtablaimp.tipoconce = 'IG'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)
	+ (Case when Csrtablaimp.tipoconce = 'DC'	then ISNULL((CsrTablaImp.importe - Csrtablaimp.baseimp) * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)
	) as TotalIG
	,sum((Case when Csrtablaimp.tipoconce = 'OI'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalOI
	,sum((Case when Csrtablaimp.tipoconce = 'II'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalII
	,sum((Case when Csrtablaimp.tipoconce = 'IN'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalIN
	,sum((Case when Csrtablaimp.tipoconce = 'IP'	then ISNULL(Csrtablaimp.importe * ISNULL(CsrCabeza.signo,1),CAST( 0 AS NUMERIC(11,2))) else CAST( 0 AS NUMERIC(11,2)) end)) as TotalIP

	,CsrCategoiva.abrevia as nomcatego,Csrcomprobante.cabrevia as nomcompro,CsrMaopera.estado
	,CAST(0 as numeric(12)) as idopcion,Cast(0 as int) as idAreaNeg,SPACE(30) as AreaNeg,CsrCategoiva.nombre as nomcategoria 
from cabefac as Csrcabeza
left join maopera as Csrmaopera on Csrcabeza.idmaopera = Csrmaopera.id
left join categoiva as Csrcategoiva on Csrcabeza.idtipoiva = Csrcategoiva.id
left join comprobante as Csrcomprobante on Csrmaopera.idcomproba = Csrcomprobante.id
left join tablaimp as csrtablaimp on Csrmaopera.id = csrtablaimp.idmaopera
left join EMaopera as CsrEMaopera on CsrMaopera.id = CsrEMaopera.idmaopera
left join AreaNeg as Csrareaneg on CsrEMaopera.idareaneg = CsrAreaNeg.id


where Csrcabeza.fecha >= '20180403'AND Csrcabeza.fecha <= '20180603' and Csrmaopera.origen IN ( 'FAC','FPE','FDI' ) and Csrmaopera.clasecomp IN ('A','B','C','U') 
and LEFT(csrmaopera.estado,1)<>'2' AND LEFT(CsrMaopera.numcomp,1)<>' ' and isnull(CsrEMaopera.idAreaNeg ,0) >= 0   
and CsrMaopera.id = 110000002760
group  by Csrmaopera.id ,Csrmaopera.numcomp ,Csrcabeza.fecha
	,CsrMaopera.estado,Csrcabeza.cnombre 
	,Csrcabeza.cuit ,CsrCabeza.signo 
,CsrCategoiva.abrevia ,Csrcomprobante.cabrevia ,CsrMaopera.estado
	,CsrCategoiva.nombre 