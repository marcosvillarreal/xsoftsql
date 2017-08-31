use prueba
go
update nmaopera set enpatron = convert(numeric(1),right(left(switch,3),1))
update nmaopera set facturado = 1 where left(switch,1)='1'
update fletecarga set espedido = 1
update fletecarga set facturado = convert(numeric(1),left(switch,1))
update fleteplanilla set estadomov = convert(numeric(1),left(switch,1))
update fleteplanilla set espedido = 1
update fleteplanilla set comprometida = convert(numeric(1),right(switch,1))