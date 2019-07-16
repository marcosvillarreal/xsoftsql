use juma --bahia
go
select * from maopera
inner join cabecpra on maopera.id = cabecpra.idmaopera
where numcomp like '%122%30203'
select * from tablaasi where idmaopera = 110000030194

--update tablaimp set importe = 129.87 where id = 110000040954
--update tablaimp set importe = 144.30,tipoconce='II',idcuenta=1100000943 where id = 110000040955
--update tablaimp set importe = 0,tasa=0,baseimp=0,tipoconce='ZZ',idcuenta=0,idasiento=0 where id = 110000040956

--update tablaasi set importe = 129.87 where id = 110000047110
--update tablaasi set importe = 144.30,tipoconce='II',idcuenta=1100000943 where id = 110000047111
--update tablaasi set importe = 0,tipoconce='ZZ',idcuenta=0 where id = 110000047112