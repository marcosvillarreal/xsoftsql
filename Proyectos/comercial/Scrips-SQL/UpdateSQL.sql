--CAMBIOS EN BASE DE DATOS COMERCIO

use comercio
go
--Crear campo idvalor int NOT NULL
update operatoria set idvalor = 0
--Crear campo idoperatoria int NOT NULL
update cabefac set idoperatoria =  1100000002