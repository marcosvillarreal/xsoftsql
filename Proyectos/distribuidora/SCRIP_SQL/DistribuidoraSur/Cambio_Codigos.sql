use distribuidorasur
go
ALTER TABLE [dbo].[producto] DROP CONSTRAINT [UQ_product1]

execute RenumCodigos 1100000001,1100000067,0
execute RenumCodigos 1100000001,1100000036,9
execute RenumCodigos 1100000001,1100000040,10
execute RenumCodigos 1100000001,1100000056,14
execute RenumCodigos 1100000001,1100000007,15
--LA serenisima
execute RenumCodigos 1100000003,1100000029,999
execute RenumCodigos 1100000003,1100000030,1019
execute RenumCodigos 1100000003,1100000002,1034
execute RenumCodigos 1100000003,1100000034,1089
execute RenumCodigos 1100000003,1100000033,1099
execute RenumCodigos 1100000003,1100000035,1119
--tregar
execute RenumCodigos 1100000004,1100000003,5999
--otros
execute RenumCodigos 1100000005,1100000036,6069
execute RenumCodigos 1100000006,1100000036,6089
update producto set numero = 6095 where id = 1100005502
execute RenumCodigos 1100000007,1100000036,2009
execute RenumCodigos 1100000008,1100000036,2019
execute RenumCodigos 1100000009,1100000036,2029
execute RenumCodigos 1100000010,1100000036,2049
execute RenumCodigos 1100000010,1100000031,2059
execute RenumCodigos 1100000011,1100000037,2079
execute RenumCodigos 1100000012,1100000038,2099
execute RenumCodigos 1100000013,1100000032,2119
execute RenumCodigos 1100000014,1100000070,2149
execute RenumCodigos 1100000015,1100000040,2169
execute RenumCodigos 1100000016,1100000041,2189
execute RenumCodigos 1100000088,1100000036,2219
execute RenumCodigos 1100000090,1100000036,2239
execute RenumCodigos 1100000017,1100000039,2259
execute RenumCodigos 1100000018,1100000039,2299
execute RenumCodigos 1100000019,1100000039,2319
execute RenumCodigos 1100000020,1100000039,2334
execute RenumCodigos 1100000021,1100000031,2349
execute RenumCodigos 1100000021,1100000008,2379
execute RenumCodigos 1100000087,1100000048,2399
--fiambres
execute RenumCodigos 1100000022,1100000004,2409
execute RenumCodigos 1100000023,1100000042,2479
execute RenumCodigos 1100000023,1100000042,2479
execute RenumCodigos 1100000023,1100000044,2519
execute RenumCodigos 1100000024,0,2534
execute RenumCodigos 1100000025,1100000045,2544
execute RenumCodigos 1100000026,0,2554
execute RenumCodigos 1100000027,0,2589
execute RenumCodigos 1100000028,0,2619
execute RenumCodigos 1100000029,0,2649
execute RenumCodigos 1100000030,0,2659
execute RenumCodigos 1100000031,0,2679
execute RenumCodigos 1100000032,0,2695
execute RenumCodigos 1100000033,0,2799
execute RenumCodigos 1100000034,0,2829
execute RenumCodigos 1100000035,0,2844
execute RenumCodigos 1100000036,0,2859
execute RenumCodigos 1100000078,0,2869
execute RenumCodigos 1100000037,1100000057,2899
execute RenumCodigos 1100000037,1100000010,2919
execute RenumCodigos 1100000075,0,2959
execute RenumCodigos 1100000076,0,2989
execute RenumCodigos 1100000038,0,2999
execute RenumCodigos 1100000039,1100000029,3039
execute RenumCodigos 1100000039,1100000055,3045
execute RenumCodigos 1100000039,1100000005,3054
execute RenumCodigos 1100000039,1100000009,3069
execute RenumCodigos 1100000040,0,3099
execute RenumCodigos 1100000041,0,3139
execute RenumCodigos 1100000042,0,3159
execute RenumCodigos 1100000043,0,3179
execute RenumCodigos 1100000044,0,3194
execute RenumCodigos 1100000045,0,3199
execute RenumCodigos 1100000046,0,3219
execute RenumCodigos 1100000048,0,3239
execute RenumCodigos 1100000049,0,3289
execute RenumCodigos 1100000051,1100000012,3299
execute RenumCodigos 1100000051,1100000056,3309
execute RenumCodigos 1100000051,1100000056,3309
execute RenumCodigos 1100000052,0,3329
execute RenumCodigos 1100000053,0,3349
execute RenumCodigos 1100000054,0,3369
execute RenumCodigos 1100000055,0,3384
execute RenumCodigos 1100000056,0,3389
execute RenumCodigos 1100000058,0,4999
execute RenumCodigos 1100000059,0,5039
execute RenumCodigos 1100000060,0,5059
execute RenumCodigos 1100000061,0,5099
execute RenumCodigos 1100000062,0,5149
execute RenumCodigos 1100000062,0,5149
execute RenumCodigos 1100000063,0,5179
execute RenumCodigos 1100000064,0,5199
execute RenumCodigos 1100000065,0,5259
execute RenumCodigos 1100000066,0,5279
execute RenumCodigos 1100000068,0,5299
execute RenumCodigos 1100000069,0,5319
execute RenumCodigos 1100000070,0,5349
execute RenumCodigos 1100000071,0,5379
execute RenumCodigos 1100000072,0,5399
execute RenumCodigos 1100000073,0,5429
execute RenumCodigos 1100000074,0,5469
execute RenumCodigos 1100000077,0,5499
execute RenumCodigos 1100000079,0,5519
execute RenumCodigos 1100000080,0,5539
execute RenumCodigos 1100000081,0,5569
execute RenumCodigos 1100000082,0,5699
execute RenumCodigos 1100000083,0,5719
execute RenumCodigos 1100000084,0,5769
execute RenumCodigos 1100000085,0,3999
execute RenumCodigos 1100000086,0,4069
execute RenumCodigos 1100000089,0,4099

select marca.numero, marca.nombre, rubro.numero, rubro.nombre, producto.numero, producto.nombre
,producto.idmarca, producto.idrubro,producto.id
from marca
inner join producto on marca.id = producto.idmarca
inner join rubro on producto.idrubro = rubro.id
where not marca.numero in (2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,30,31,32,33,34,39,40
,41,42,43,44,45,46,47,48,49,50,51,52,70,71,74,75,76,77,80,81,82,83,84,85,86,87,88,90
,91,100,101,102,103,104,105,120,121,122,130,131,132,140,145,146,150,151,152,153,154,155,156
,160,161,162,165,170,171,172
)
order by marca.numero, rubro.numero,producto.numero


/****** Object:  Index [UQ_product1]    Script Date: 25/8/2021 15:33:25 ******/
ALTER TABLE [dbo].[producto] ADD  CONSTRAINT [UQ_product1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
