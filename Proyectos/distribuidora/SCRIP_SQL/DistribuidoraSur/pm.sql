use distribuidorasur
go

update vendedor set passpreventamobile=''

select * from producto where idrubro = 1100000014

select * from rubro where numero > 20 and id in (select idrubro from producto) 
order by numero

--update rubro set nombre = 'FIAMBRES' where id = 1100000004
--update rubro set nombre='VARIOS' where id in ( 1100000003)
--update rubro set nombre = 'LECHES' where id = 1100000029
--update rubro set nombre = 'DULCE DE LECHE' where id = 1100000034
--update rubro set nombre = 'SAL' where id = 1100000035
--update rubro set nombre = 'SALSAS' where id = 1100000037
--UPDATE producto set idrubro = 1100000036 where idrubro in (1100000035,1100000037,1100000038,1100000032,1100000070,1100000040,1100000041)
--UPDATE producto set idrubro = 1100000004 where idrubro in (1100000042,1100000043,1100000045,1100000046,1100000047,1100000053,1100000049,1100000052)
--update producto set idrubro = 1100000055 where idrubro = 1100000054
--update producto set idrubro = 1100000035 where id in (1100000618,1100000619,1100000620,1100000621,1100000622,1100000623,1100000624)
--update producto set idrubro =1100000037 where id in (1100000652,1100000653,1100000655,1100000656,1100000658,1100000659,1100000660,1100000667)
--update rubro set nombre = 'VINAGRES / J.LIMON' WHERE id = 1100000006
--update rubro set nombre = 'ADEREZOS' where id = 1100000008
--update rubro set nombre = 'CALDOS /SABORIZANTES' where id = 1100000058
--update rubro set nombre = 'ENFUSIONES' where id = 1100000060
--update rubro set nombre = 'PANIFICADOS' where id = 1100000010
--UPDATE producto set idrubro = 1100000010 where idrubro = 1100000061
--update producto set idrubro = 1100000057 where idrubro = 1100000011
--update rubro set nombre = 'SNACK' where ID = 1100000013
--UPDATE RUBRO SET nombre = 'LECHE EN POLVO' where id = 1100000064
--update rubro set nombre = 'CONSERVAS' where id = 1100000014
--update producto set idrubro = 1100000014 where idrubro = 1100000066
--update rubro set nombre='HARINAS' where ID = 1100000016