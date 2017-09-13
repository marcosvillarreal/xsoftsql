use comercio
go
select id,nombre,codalfa,codalfaprov,idrubro,idmarca,idfamilia,idcategotipo,feculpre,fecmodi
 from producto where rtrim(codalfa)  like '% %' order by fecmodi,nombre 
--update producto set codalfa = right(rtrim(codalfaprov),4) where rtrim(codalfa)  like '% %'