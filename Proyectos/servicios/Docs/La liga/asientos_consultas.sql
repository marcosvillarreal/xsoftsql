use laligabb
go

--update tablaasi set importe =170540  ,detalle='*'  where id = 110000020648
--update movctacte set importe =170540.00    where idmaopera = 110000006783
--update movcaja set importe =170540   where id = 110000001758
--update afectacte set importe = 91700.00  where iddebe = 110000005825

--select * from tablaasi where idmaopera in (110000005460,110000005994) 
go
select tablaasi.* from cabeasi inner join tablaasi on cabeasi.idmaopera = tablaasi.idmaopera where idejercicio = 1100000001 and cabeasi.numero = 311
go
--select * from tablaasi where detalle like 'RECOB X000400000316%'
go
select * from maopera where id in (110000006968)
--select * from anmaopera where idmaopera = 110000004356
--select * from cabeasi where idmaopera =110000004349
go
select * from afectacte inner join movctacte on afectacte.iddebe = movctacte.id--left join cuerfac on movctacte.idmaopera =cuerfac.idmaopera 
where idmaoperah = 110000006968 --and isnull(idarticulo,0) <> 0
order by afectacte.id
--select * from movctacte where id in (110000005655) 
--select * from afectacte where iddebe in (110000000498,110000001135,110000000690,110000000696,110000000703,110000000768,110000000781,110000000790,110000000819,110000001392,110000001393)
--select * from movcaja where id = 110000000498
go

--select * from tablaimp where idmaopera in (110000000956)

--update tablaasi set debehaber= 'D' where id = 110000001126

--select * from maopera where id =110000000317
--select * from tablaasi where idorigen =110000001132

--insert into tablaasi values (17,110000001278,110000001104,'MOCT',1100000969,'ZZ','H',55000.00,'')

--update tablaasi set importe = 23000    where id = 110000001669
--select * from tablaasi where tablaori='MAOP' and detalle like 'RECOB%'

