TEXT TO lcCmd TEXTMERGE NOSHOW 
select p.numero,p.nombre,p.codalfaprov,isnull(c.cnombre,'GENERICO') as proveedor, m.nombre as marca,r.nombre as rubro,p.prevtaf2 as precio
,f.nombre as familia,e.existe as stock
,isnull((select top 1 descripcion from productodeta as pd where pd.idarticulo = p.id and  left(switch,1)='0'),'') as descripcion
,isnull((select top 1 descripcion from productodeta as pd where pd.idarticulo = p.id and  left(switch,1)='1'),'') as comentario
,isnull((select top 1 descripcion from productodeta as pd where pd.idarticulo = p.id and  left(switch,1)='2'),'') as web
,isnull((select top 1 descripcion from productodeta as pd where pd.idarticulo = p.id and  left(switch,1)='3'),'') as observacion
from producto as p
left join ctacte as c on p.idctacte = c.id
left join marca as m on p.idmarca= m.id
left join rubro as r on p.idrubro = r.id
left join familia as f on p.idfamilia = f.id
left join existenc as e on p.id = e.idarticulo
where p.nolista = 0 and e.iddeposito = 1100000002
and e.existe > 0 and r.nolista =0
ENDTEXT 
=CrearCursorAdapter('CsrExp',lcCmd)
CursorAdapterToXML('CsrExp',SYS(5)+CURDIR()+"WEB.xml")
USE IN CsrExp
oavisar.usuario('Exportacion WEB Finalizado')