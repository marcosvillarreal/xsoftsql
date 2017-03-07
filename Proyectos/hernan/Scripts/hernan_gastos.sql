use guerrero
go
select CsrMaopera.origen
,sum(isnull(CsrMovCtacte.total * CsrMovCtacte.signo,0) + isnull(CsrMovCaja.importe * (case when CsrMaopera.clasecomp='C' then -1 else 1 end),0) + isnull(CsrMovBcocar.importe * CsrMovBcocar.signo,0 )) as total
from maopera as CsrMaopera
inner join cabeasi as CsrCabeasi on Csrmaopera.id = Csrcabeasi.idmaopera
inner join cabefac as CsrCabefac on Csrmaopera.id = Csrcabefac.idmaopera
left join movcaja as CsrMovCaja on Csrmaopera.id = CsrMovCaja.idmaopera
left join movctacte as CsrMovCtaCte on Csrmaopera.id = CsrMovCtaCte.idmaopera
left join movbcocar as CsrMovBcocar on Csrmaopera.id = CsrMovBcocar.idmaopera
left join emaopera as Csremaopera on Csrmaopera.id = Csremaopera.idmaopera
where (CsrCabeasi.fecha BETWEEN '20170303' AND '20170304') and CsrEMaopera.idareaneg > 0
Group By CsrMaopera.origen
union all
select CsrMaopera.origen
,sum(isnull(CsrMovCtacte.total * CsrMovCtacte.signo,0) + isnull(CsrMovCaja.importe * (case when CsrMaopera.clasecomp='C' then -1 else 1 end),0) + isnull(CsrMovBcocar.importe * CsrMovBcocar.signo,0 )) as total
from maopera as CsrMaopera
inner join cabeasi as CsrCabeasi on Csrmaopera.id = Csrcabeasi.idmaopera
inner join cabecpra as CsrCabeCpra on Csrmaopera.id = Csrcabecpra.idmaopera
left join movcaja as CsrMovCaja on Csrmaopera.id = CsrMovCaja.idmaopera
left join movctacte as CsrMovCtaCte on Csrmaopera.id = CsrMovCtaCte.idmaopera
left join movbcocar as CsrMovBcocar on Csrmaopera.id = CsrMovBcocar.idmaopera
left join emaopera as Csremaopera on Csrmaopera.id = Csremaopera.idmaopera
where (CsrCabeasi.fecha BETWEEN '20170303' AND '20170304') and CsrEMaopera.idareaneg > 0
Group By CsrMaopera.origen
union all
select CsrMaopera.origen
,sum(isnull(CsrMovCtacte.total * CsrMovCtacte.signo,0) + isnull(CsrMovCaja.importe,0) + isnull(CsrMovBcocar.importe,0)) as total
from maopera as CsrMaopera
inner join cabeasi as CsrCabeasi on Csrmaopera.id = Csrcabeasi.idmaopera
left join movcaja as CsrMovCaja on Csrmaopera.id = CsrMovCaja.idmaopera
left join movctacte as CsrMovCtaCte on Csrmaopera.id = CsrMovCtaCte.idmaopera
left join movbcocar as CsrMovBcocar on Csrmaopera.id = CsrMovBcocar.idmaopera
left join emaopera as Csremaopera on Csrmaopera.id = Csremaopera.idmaopera
where (CsrCabeasi.fecha BETWEEN '20170303' AND '20170304') and CsrEMaopera.idareaneg > 0
and Csrmaopera.origen in ('RFL') 
Group By CsrMaopera.origen
union all
select CsrMaopera.origen
--,isnull(CsrMovCtacte.total,0),isnull(CsrMovCaja.importe,0),isnull(CsrMovBcocar.importe,0)
,sum(isnull(CsrMovCtacte.total,0) * isnull(CsrMovCtacte.signo,0)) as total
from maopera as CsrMaopera
inner join cabeasi as CsrCabeasi on Csrmaopera.id = Csrcabeasi.idmaopera
--left join movcaja as CsrMovCaja on Csrmaopera.id = CsrMovCaja.idmaopera
left join movctacte as CsrMovCtaCte on Csrmaopera.id = CsrMovCtaCte.idmaopera
--left join movbcocar as CsrMovBcocar on Csrmaopera.id = CsrMovBcocar.idmaopera
left join emaopera as Csremaopera on Csrmaopera.id = Csremaopera.idmaopera
where (CsrCabeasi.fecha BETWEEN '20170303' AND '20170304') and CsrEMaopera.idareaneg > 0
and Csrmaopera.origen in ('COB') 
Group By CsrMaopera.origen