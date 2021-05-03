use pm
go

--update articulos set porcemerma = 40 where idempresa = 5

--update articulos set peso = 0.500 where idempresa = 5 and numero = 20111
--update articulos set peso = 2.4 where idempresa = 5 and numero = 20123
--update articulos set peso = 4.5 where idempresa = 5 and numero = 20161
--update articulos set peso = 1.6 where idempresa = 5 and numero = 20162
----------update articulos set peso = 1 where idempresa = 5 and numero = 20178
----------update articulos set peso = 1 where idempresa = 5 and numero = 20191
----------update articulos set peso = 1 where idempresa = 5 and numero = 20193
----------update articulos set peso = 1 where idempresa = 5 and numero = 20201
--update articulos set peso = 5 where idempresa = 5 and numero = 2025
--update articulos set peso = 2.5 where idempresa = 5 and numero = 20630
--update articulos set peso = 1.9 where idempresa = 5 and numero = 3012
------------update articulos set peso = 1 where idempresa = 5 and numero = 3013
------------update articulos set peso = 1 where idempresa = 5 and numero = 3018
------------update articulos set peso = 1 where idempresa = 5 and numero = 3101
------------update articulos set peso = 1 where idempresa = 5 and numero = 3110
------------update articulos set peso = 1 where idempresa = 5 and numero = 3068
------------update articulos set peso = 1 where idempresa = 5 and numero = 30130
------------update articulos set peso = 1 where idempresa = 5 and numero = 30140
------------update articulos set peso = 1 where idempresa = 5 and numero = 3143
--update articulos set peso = 2 where idempresa = 5 and numero = 30214
--update articulos set peso = 1.3 where idempresa = 5 and numero = 3073
--update articulos set peso = 3 where idempresa = 5 and numero = 3074
----------update articulos set peso = 1 where idempresa = 5 and numero = 3078
----------update articulos set peso = 1 where idempresa = 5 and numero = 3079
----------update articulos set peso = 1 where idempresa = 5 and numero = 3083
----------update articulos set peso = 1 where idempresa = 5 and numero = 30812
----------update articulos set peso = 1 where idempresa = 5 and numero = 30817
----------update articulos set peso = 1 where idempresa = 5 and numero = 31043
----------update articulos set peso = 1 where idempresa = 5 and numero = 31046
----------update articulos set peso = 1 where idempresa = 5 and numero = 31047
----------update articulos set peso = 1 where idempresa = 5 and numero = 3144
----------update articulos set peso = 1 where idempresa = 5 and numero = 30115
----------update articulos set peso = 1 where idempresa = 5 and numero = 30227
----------update articulos set peso = 1 where idempresa = 5 and numero = 31926
----------update articulos set peso = 1 where idempresa = 5 and numero = 31927
----------update articulos set peso = 1 where idempresa = 5 and numero = 31928

select 'update articulo set peso = 1 where idempresa = 5 and numero = '+numero,nombre,peso from articulos where idempresa = 5 and sikilos='S' and peso= 1 order by numero
