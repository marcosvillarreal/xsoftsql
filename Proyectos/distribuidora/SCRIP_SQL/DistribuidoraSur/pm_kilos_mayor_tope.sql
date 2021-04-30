use distribuidorasur
go
select numero,nombre,prevtaf1,peso,prevtaf1*peso from producto-- where nombre like 'Fiambre%'
order by prevtaf1*peso desc