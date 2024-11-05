use elcoyote

go
select zonaren.numero,convert(char(10),Zonaren.fecha,105), zona.nombre  from zonaren
inner join renmaope on zonaren.id = renmaope.idzonaren
inner join maopera on renmaope.idmaopera = maopera.id
left join zona on Zonaren.idzona = zona.id
where left(renmaope.switch,1) = '1' and maopera.terminal = 7
and fechasis between '20230101' and '20231231'