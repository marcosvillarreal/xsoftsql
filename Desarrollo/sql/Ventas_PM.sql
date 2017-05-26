use pm
go
select idempresa,razonsocial, vendedor,count(cabpedido.id) from empresa left join cabpedido on empresa.id = cabpedido.idempresa 
where fecha >= '20170501' group by idempresa,razonsocial,vendedor order by idempresa