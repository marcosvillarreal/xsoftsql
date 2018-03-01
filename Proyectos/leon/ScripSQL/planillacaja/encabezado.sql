use leon
go
select csrtablaasi.idmaopera,csrparaconta.numero,csrparaconta.idcuenta
from tablaasi as csrtablaasi
inner join maopera as csrmaopera on csrtablaasi.idmaopera = csrmaopera.id
inner join detanrocaja as csrdetanrocaja on csrmaopera.iddetanrocaja = csrdetanrocaja.id
left join paraconta as csrparaconta on csrtablaasi.idcuenta = Csrparaconta.idcuenta
where csrdetanrocaja.nrocaja >= 20180301 and Csrdetanrocaja.nrocaja <= 20180301
--and csrparaconta.numero = 1
and CsrTablaasi.idcuenta in (1100001620,1100001621)
order by csrtablaasi.id 