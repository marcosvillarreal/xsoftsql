use distribuidorasur
go
--ALTER TABLE [dbo].[producto] DROP CONSTRAINT [UQ_product1]

--execute RenumCodigos 1100000001,1100000067,0
--execute RenumCodigos 1100000001,1100000036,9
--execute RenumCodigos 1100000001,1100000040,10
--execute RenumCodigos 1100000001,1100000056,14
--execute RenumCodigos 1100000001,1100000007,15
--LA serenisima
execute RenumCodigos 1100000003,1100000029,999
execute RenumCodigos 1100000003,1100000030,1019
execute RenumCodigos 1100000003,1100000002,1029
execute RenumCodigos 1100000003,1100000034,1069
execute RenumCodigos 1100000003,1100000033,1074
execute RenumCodigos 1100000003,1100000035,1089
--tregar
execute RenumCodigos 1100000004,1100000003,1199
--otros
execute RenumCodigos 1100000005,0,1299
execute RenumCodigos 1100000006,0,1349
execute RenumCodigos 1100000007,0,1399
execute RenumCodigos 1100000008,0,1429
execute RenumCodigos 1100000009,0,1449
execute RenumCodigos 1100000010,0,1499
execute RenumCodigos 1100000011,0,1549
execute RenumCodigos 1100000012,0,1599
execute RenumCodigos 1100000013,0,1649
execute RenumCodigos 1100000014,0,1699
execute RenumCodigos 1100000015,0,1749
execute RenumCodigos 1100000016,0,1799
execute RenumCodigos 1100000088,0,1849
execute RenumCodigos 1100000090,0,1899
execute RenumCodigos 1100000017,0,1949
execute RenumCodigos 1100000018,0,1999
execute RenumCodigos 1100000019,0,2049
execute RenumCodigos 1100000020,0,2099
execute RenumCodigos 1100000021,0,2349
execute RenumCodigos 1100000021,0,2399
execute RenumCodigos 1100000087,0,2489
--fiambres
execute RenumCodigos 1100000022,0,2999
execute RenumCodigos 1100000023,0,3049
execute RenumCodigos 1100000024,0,3099
execute RenumCodigos 1100000025,0,3149
execute RenumCodigos 1100000026,0,3199
execute RenumCodigos 1100000027,0,3249
execute RenumCodigos 1100000028,0,3299
execute RenumCodigos 1100000029,0,3349
execute RenumCodigos 1100000030,0,3399
execute RenumCodigos 1100000031,0,3449
execute RenumCodigos 1100000032,0,3499
execute RenumCodigos 1100000033,0,3549
execute RenumCodigos 1100000034,0,3599
execute RenumCodigos 1100000035,0,3649
--pastas
execute RenumCodigos 1100000036,0,3999
execute RenumCodigos 1100000078,0,4049
execute RenumCodigos 1100000037,0,4099
execute RenumCodigos 1100000075,0,4149
execute RenumCodigos 1100000076,0,4199
--bebidas
execute RenumCodigos 1100000038,0,4499
execute RenumCodigos 1100000039,0,4549
execute RenumCodigos 1100000040,0,4599
execute RenumCodigos 1100000041,0,4649
execute RenumCodigos 1100000042,0,4699
execute RenumCodigos 1100000043,0,4729
execute RenumCodigos 1100000044,0,4749
execute RenumCodigos 1100000045,0,4799
execute RenumCodigos 1100000046,0,4829
--encurtidos
execute RenumCodigos 1100000048,0,4999
execute RenumCodigos 1100000049,0,5199
execute RenumCodigos 1100000058,0,5249
--yerbas
execute RenumCodigos 1100000051,0,5499
execute RenumCodigos 1100000052,0,5549
execute RenumCodigos 1100000053,0,5599
execute RenumCodigos 1100000054,0,5649
execute RenumCodigos 1100000055,0,5699
execute RenumCodigos 1100000056,0,5749
execute RenumCodigos 1100000068,0,5799
execute RenumCodigos 1100000069,0,5849
--almacen
execute RenumCodigos 1100000059,0,5999
execute RenumCodigos 1100000060,0,6049
execute RenumCodigos 1100000061,0,6099
execute RenumCodigos 1100000062,0,6149
execute RenumCodigos 1100000063,0,6199
execute RenumCodigos 1100000064,0,6249
execute RenumCodigos 1100000065,0,6299
execute RenumCodigos 1100000066,0,6249
execute RenumCodigos 1100000070,0,6299
execute RenumCodigos 1100000071,0,6349
execute RenumCodigos 1100000072,0,6399
execute RenumCodigos 1100000073,0,6449

execute RenumCodigos 1100000074,0,6499
execute RenumCodigos 1100000077,0,6549
execute RenumCodigos 1100000079,0,6599
execute RenumCodigos 1100000080,0,6649
execute RenumCodigos 1100000081,0,6699
execute RenumCodigos 1100000082,0,6749
execute RenumCodigos 1100000083,0,6799
execute RenumCodigos 1100000084,0,6899
--aceite
execute RenumCodigos 1100000085,0,6999
execute RenumCodigos 1100000086,0,7049
execute RenumCodigos 1100000089,0,7099

select marca.numero, marca.nombre, rubro.numero, rubro.nombre, producto.numero, producto.nombre
,producto.idmarca, producto.idrubro,producto.id
from marca
inner join producto on marca.id = producto.idmarca
inner join rubro on producto.idrubro = rubro.id
where not  marca.numero in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,30,32,34,31,33
,40,41,39,42,43,44,45,46,47,48,49,50,51,52,70,71,74,75,76,77
,80,81,82,83,84,85,86,88,87,90,91,100,101,102,104,105,103,120
,121,122,130,131,132,140,145,146,150,151,152,153,154,155
)
order by marca.numero, rubro.numero,producto.numero


--/****** Object:  Index [UQ_product1]    Script Date: 25/8/2021 15:33:25 ******/
--ALTER TABLE [dbo].[producto] ADD  CONSTRAINT [UQ_product1] UNIQUE NONCLUSTERED 
--(
--	[numero] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO
