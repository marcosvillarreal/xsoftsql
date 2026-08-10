
--select * from ctacte where cnombre like '%BABA%'
select 
convert(char(10),m.fecha,105) fechaemi,
c.cnombre comprobante,
m.detalle numcomp,
m.neto total
from movpub m 
inner join clasecomp c on m.clasecomp = c.codigo
where idctacte = 1100002912
and fecha between '20230101' and '20231231'
order by m.fecha