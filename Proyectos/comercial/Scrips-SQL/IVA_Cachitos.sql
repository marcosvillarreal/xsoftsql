use cachitos
go

--update ctacte set tipoiva = 7 where tipoiva = 5
--update cabefac set idtipoiva = 7 where idtipoiva = 5



--update tablaimp set importe = importe * (-1), baseimp = baseimp * (-1), detalle=rtrim(ltrim(detalle))+'m' 
--where tipoconce='DC' and importe > 0 

--select * from tablaimp
--where id  between 110000001859 and 110000002000
--order by id desc

--insert into tablaimp values (110000001865,  110000005435,	110000001586,	'CAFA',	0,	1100004865,	'DC',	-189.390,	10.500000,	-171.380,  '' ,       	'm',	1100000002)
--insert into tablaimp values (110000001864,	110000004000,	110000000915,	'CAFA',	0,	1100004865,	'DC',	-104.880,	10.500000,	-94.910	 , '' ,       	'm',	1100000002)
--insert into tablaimp values (110000001863,	110000003364,	110000000601,	'CAFA',	0,	1100004865,	'DC',	-87.160,	10.500000,	-78.870	 ,  '',       	'm',	1100000002)
--insert into tablaimp values (110000001862,	110000003093,	110000000484,	'CAFA',	0,	1100004865,	'DC',	-101.670,	10.500000,	-92.000	 ,  '',       	'm',	1100000002)
--insert into tablaimp values (110000001861,	110000003041,	110000000454,	'CAFA',	0,	1100004865,	'DC',	-140.200,	10.500000,	-126.880,  '' ,       	'm',	1100000002)
--insert into tablaimp values (110000001860,	110000002986,	110000000422,	'CAFA',	0,	1100004865,	'DC',	-113.480,	10.500000,	-102.700,  '' ,       	'm',	1100000002)
--insert into tablaimp values (110000001859,	110000002533,	110000000198,	'CAFA',	0,	1100004865,	'DC',	-131.740,	10.500000,	-119.230,  '',         'm',	1100000002)

--select importe,tasa,baseimp,id from tablaimp 
--where detalle='m' and tipoconce='DC' 
--and not id in (110000002000,110000001865,110000001864,110000001863,110000001862,110000001861,110000001860,110000001859)
--order by id desc
--
--update tablaimp set importe = -2086.490,	tasa = 21.000000,	baseimp = -1724.350	,detalle='m' where id = 110000003386
--update tablaimp set importe = -688.150,	tasa = 0.000000,	baseimp = -568.730	,detalle='m' where id = 110000001856
--update tablaimp set importe = -1547.020,	tasa = 0.000000,	baseimp = -1278.510	,detalle='m' where id = 110000001853
--update tablaimp set importe = -1244.670,	tasa = 21.000000,	baseimp = -1028.620	,detalle='m' where id = 110000001848
--update tablaimp set importe = -3184.590,	tasa = 0.000000,	baseimp = -2631.890	,detalle='m' where id = 110000001845
--update tablaimp set importe = -7447.020,	tasa = 0.000000,	baseimp = -6154.600	,detalle='m' where id = 110000001842
--update tablaimp set importe = -849.960,	tasa = 0.000000,	baseimp = -702.450	,detalle='m' where id = 110000001837
--update tablaimp set importe = 0.000,	tasa = 0.000000,	baseimp = 0.000	,detalle='m' where id = 110000001836
--update tablaimp set importe = -201.280,	tasa = 21.000000,	baseimp = -166.340	,detalle='m' where id = 110000001762
--update tablaimp set importe = -137.320,	tasa = 21.000000,	baseimp = -113.480	,detalle='m' where id = 110000001115
--update tablaimp set importe = -869.210,	tasa = 21.000000,	baseimp = -718.350	,detalle='m' where id = 110000000844
--update tablaimp set importe = -51.450,	tasa = 21.000000,	baseimp = -42.520	,detalle='m' where id = 110000000791

--update tablaimp set importe=0.01,baseimp=0.08,detalle='m' where id = 110000000039
--update tablaimp set importe=0.08,detalle='m' where id = 110000000040
--update tablaimp set importe=0,baseimp=0,tasa=0,detalle='m' where id = 110000000041
--update tablaimp set importe=0,baseimp=0,tasa=0,detalle='m' where id = 110000000009
--update tablaimp set importe=0,baseimp=0,tasa=0,detalle='m' where id = 110000000013
--update tablaimp set importe=-67.310,baseimp=-55.620,tasa=21,detalle='m' where id = 110000000247

--update tablaimp set importe=1.65,detalle='m' where id = 110000000021
--update tablaimp set importe=0.35,baseimp=1.65,detalle='m' where id = 110000000020
--update tablaimp set importe=-0.20,baseimp=-0.17,tasa = 21 ,detalle='m' where id = 110000000022
--
--update tablaimp set importe=0.17,baseimp=0.83,detalle='m' where id = 110000000023
--update tablaimp set importe=0.83,detalle='m' where id = 110000000024
--update tablaimp set importe=-0.10,baseimp=-0.08,tasa = 21 ,detalle='m' where id = 110000000025
--
--update tablaimp set importe=0.17,baseimp=0.83,detalle='m' where id = 110000000048
--update tablaimp set importe=0.83,detalle='m' where id = 110000000049
--
--update tablaimp set importe=0.43,baseimp=2.07,detalle='m' where id = 110000000054
--update tablaimp set importe=2.07,detalle='m' where id = 110000000055
--
--update tablaimp set importe=0.51,baseimp=2.49,detalle='m' where id = 110000000056
--update tablaimp set importe=2.49,detalle='m' where id = 110000000057
--
--update tablaimp set tasa= 21 where tipoconce='DC' and tasa= 0
--
--update cabefac set total = 0
--where id in (110000000166,110000000167,110000000168,110000000169,110000000170,110000000171,110000000172,110000000173)
--
--update tablaimp set importe=489.8,baseimp=2332.39,detalle='m' where id = 110000000071
--update tablaimp set importe=2332.39,detalle='m' where id = 110000000072
--update tablaimp set importe=-0,baseimp=-0,tasa = 0 ,detalle='m' where id = 110000000073
--
--update cabefac set total = 0 where id in (110000000178110000000359,110000000421,110000000571,110000000932,110000000605,110000000606,110000000856
--,110000001205,110000001165,110000001246,110000001272,110000001351,110000001352,110000001365,110000001366,110000001403,110000001423,110000001424,110000001425,110000001426
--,110000001473,110000000178,110000000359)
--
----insert into tablaimp values (110000001866,  110000004587,	110000001166,	'CAFA',	0,	1100004894,	'EX',	55390.410,	0,	0, ''  ,       	'm',	1100000002)
--
--
--update tablaimp set TASA = 10.5 ,detalle='m' where id = 110000000494
--update tablaimp set tasa = 10.5,detalle='m' where id = 110000000802
--update tablaimp set tasa = 10.5,detalle='m' where id = 110000001274
--update tablaimp set tasa = 10.5,detalle='m' where id = 110000002017

