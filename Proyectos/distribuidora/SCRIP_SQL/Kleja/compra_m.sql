use kleja
go
select * from maopera where id = 110000162792
select * from tablaimp where idmaopera = 110000162792
go
SELECT 'B' as grupo, CsrMaopera.id as idmaopera,0 estado
,CsrTablaImP.Tasa as Alicuota
,SUM(ISNULL(Csrtablaimp.importe,CAST(0 as numeric(12,2)))) as TotalIG
,SUM(ISNULL(Csrtablaimp.baseimp,CAST(0 as numeric(12,2)))) as TotalNG
,ISNULL(CsrTipoIVA.SiapCpraVta,'0000') as CodTasa
from Cabecpra as CsrCabecpra
left join maopera as Csrmaopera on CsrCabecpra.idmaopera = Csrmaopera.id
left join tablaimp as csrtablaimp on Csrmaopera.id = csrtablaimp.idmaopera
left join tipoiva as CsrTipoIva on CsrTablaImp.tasa = CsrTipoiva.tasa
where (CsrCabecpra.pefiscal = 202106 ) 
and Csrmaopera.origen IN ('CPR','IMP') and Csrmaopera.clasecomp IN ('A','B','C') 
AND LEFT(CsrMaopera.numcomp,1)<>' ' and CsrTablaImp.tipoconce IN ('IG','OI')
and CsrMaopera.estado=0
and CsrMaopera.id = 110000162792
Group By CsrMaopera.id ,CsrTablaImP.Tasa,CsrTipoIVA.SiapCpraVta
Order by CsrMaopera.id