use hotel_mu
go
select zh.abrevia_zona as zona,h.desc_habit,h.idhabit,'' as cliente, r.pasajeros, r.fecha_in, r.fecha_out, r.idestreserva
,e.desc_estreserva
,r.comentvta,m.numcomp, m.estado
from maopera as m
inner join reservas as r on m.id = r.idmaopera
inner join habit as h on r.idhabit = h.idhabit
inner join zonahabit as zh on h.idzonahabit = zh.idzonahabit
inner join EstReserva as e on r.idestreserva = e.idestreserva
where r.idestreserva = 1
go
select hu.idreserva,hu.idctacte, ct.cnumero as ctacte, ct.cnombre as nomctacte
from maopera as m
inner join reservas as r on m.id = r.idmaopera
inner join habit as h on r.idhabit = h.idhabit
inner join zonahabit as zh on h.idzonahabit = zh.idzonahabit
inner join EstReserva as e on r.idestreserva = e.idestreserva
inner join Huesped as hu on r.idreserva = hu.idreserva
inner join ctacte as ct on hu.idctacte = ct.id
where  r.idestreserva = 1
order by r.idreserva,hu.estitular