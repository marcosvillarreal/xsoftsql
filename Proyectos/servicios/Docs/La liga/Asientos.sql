use laligabb

--SCRIP DE ARREGLOS CONTABLES

update cabeasi set estado = 1 where idmaopera in ( 110000000338, 110000000339, 110000000403,110000000406,110000004349,110000004356,110000004359,110000004360,110000004370,110000004373
,110000006565,110000006599) or 
(idejercicio = 1100000001 and numero in (396,397,400,401,317,318)
)

update tablaasi set importe = 0   where id = 110000045767
update tablaasi set importe = 0   where id = 110000045768
update tablaasi set debehaber = 'H'    where id = 110000002160
update tablaasi set importe = 16132.00  where id = 110000002483
update movcaja set importe = 16132.00  where id = 110000000234
update tablaasi set debehaber = 'H'    where id = 110000000923

update tablaasi set importe =284550  ,detalle='*'  where id = 110000004474
update movctacte set importe =284550    where id = 110000001525
update movcaja set importe =284550    where id = 110000000498

update tablaasi set importe =274900  ,detalle='*'  where id = 110000006778
update movctacte set importe =274900    where idmaopera = 110000002460
update movcaja set importe =274900    where id = 110000000719

update tablaasi set importe =535450  ,detalle='*'  where id = 110000006800
update movctacte set importe =535450    where idmaopera = 110000002468
update movcaja set importe =535450    where id = 110000000721

update tablaasi set importe = 0 ,detalle='*' where id = 110000007337
update tablaasi set importe = 0 ,detalle='*' where id = 110000007452
update tablaasi set importe = 0 ,detalle='*' where id = 110000007457
update tablaasi set importe = 0 ,detalle='*' where id = 110000007972
update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000008315

update tablaasi set importe =687100  ,detalle='*'  where id = 110000008755
update movctacte set importe =687100    where idmaopera = 110000003026
update movcaja set importe =687100    where id = 110000000859

insert into tablaasi values (546,110000003194,110000003458,'MOCT',1100001399,'ZZ','H',28000.00,'*')
insert into tablaasi values (547,110000003194,110000003476,'MOCT',1100001399,'ZZ','H',9000.00,'*')

update tablaasi set importe =116000.00  ,detalle='*',idorigen=0  where id = 110000009366
update tablaasi set importe =0  ,detalle='*',idorigen=0  where id = 110000009367

update tablaasi set importe =242350  ,detalle='*'  where id = 110000009388
update movctacte set importe =242350    where idmaopera = 110000003212
update movcaja set importe =242350    where id = 110000000922


update tablaasi set debehaber = 'H'    where id = 110000009413

update tablaasi set importe = 0 ,detalle='*' where id = 110000009431
update tablaasi set importe = 0 ,detalle='*' where id = 110000009800
update tablaasi set importe = 0 ,detalle='*' where id = 110000011969
update tablaasi set importe = 0 ,detalle='*' where id = 110000012178

update tablaasi set importe =830800  ,detalle='*'  where id = 110000012256
update movctacte set importe =830800    where idmaopera = 110000004181
update movcaja set importe =830800    where id = 110000001129

update tablaasi set importe = 0 ,detalle='*' where id = 110000012641
update tablaasi set importe = 0 ,detalle='*' where id = 110000012646
update tablaasi set importe = 0 ,detalle='*' where id = 110000012651
update tablaasi set importe = 0 ,detalle='*' where id = 110000012687
update tablaasi set importe = 0 ,detalle='*' where id = 110000012651


update tablaasi set importe =339000  ,detalle='*'  where id = 110000012982
update movctacte set importe =339000    where idmaopera = 110000004349
update movcaja set importe =339000    where id = 110000001180

update tablaasi set importe = 0 ,detalle='*' where id = 110000013547
update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000016224

insert into tablaasi values (548,110000005424,110000005899,'MOCT',1100001379,'ZZ','H',8950.00,'*')
insert into tablaasi values (549,110000005424,110000006543,'MOCT',1100000199,'ZZ','H',1435.00,'*')

update tablaasi set importe =91700.00  ,detalle='*'  where id = 110000016389
update movctacte set importe =91700.00    where idmaopera = 110000005453
update movcaja set importe =91700.00    where id = 110000001447
update afectacte set importe = 91700.00  where iddebe = 110000005825

update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000017103
update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000017557

update tablaasi set importe =444200  ,detalle='*'  where id = 110000017877
update movctacte set importe =444200.00    where idmaopera = 110000005923
update movcaja set importe =444200.00    where id = 110000001558

update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000018669
update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000020645

update tablaasi set importe =170540  ,detalle='*'  where id = 110000020648
update movctacte set importe =170540.00    where idmaopera = 110000006783
update movcaja set importe =170540   where id = 110000001758

update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000020810
update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000020854
update tablaasi set importe = 0 ,detalle='*',idorigen = 0 where id = 110000021167

