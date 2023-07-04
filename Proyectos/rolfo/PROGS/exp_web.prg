FUNCTION ExportarDatosWeb
cRuta = ADDBS(oConfigTermi.NetDriveGS1)

TEXT TO lcCmd TEXTMERGE NOSHOW 
select p.numero,p.nombre,p.codalfaprov,isnull(c.cnombre,'GENERICO') as proveedor, m.nombre as marca,r.nombre as rubro,p.prevtaf2 as precio
,f.nombre as familia,ISNULL(e.existe ,0) as stock
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
where p.nolista = 0 and ISNULL(e.iddeposito,1100000002) = 1100000002
and r.nolista =0 and not r.numero in (12,13,19,20)
union all
select p.numero,p.nombre,p.codalfaprov,isnull(c.cnombre,'GENERICO') as proveedor, m.nombre as marca,f.nombre as rubro,p.prevtaf2 as precio
,r.nombre as familia,ISNULL(e.existe,0) as stock
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
where p.nolista = 0 and ISNULL(e.iddeposito,1100000002) = 1100000002
and r.numero = 20
ENDTEXT 

=CrearCursorAdapter('CsrExp',lcCmd)
CursorAdapterToXML('CsrExp',cRuta  + "WEB.xml")
USE IN CsrExp

TEXT TO lcCmd TEXTMERGE NOSHOW 
select p.numero,p.nombre,p.codalfaprov,isnull(c.cnombre,'GENERICO') as proveedor, m.nombre as marca,r.nombre as rubro,p.prevtaf2 as precio
,f.nombre as familia,ISNULL(e.existe ,0)as stock
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
where p.nolista = 0 and ISNULL(e.iddeposito,1100000002) = 1100000002
and r.nolista =0 and ( r.numero in (12,13,19)
or   f.numero  in ( 18))
ENDTEXT 
=CrearCursorAdapter('CsrExp',lcCmd)
CursorAdapterToXML('CsrExp',cRuta  + "WEB_marca.xml")
USE IN CsrExp

oavisar.usuario('Exportacion WEB Finalizado')

ENDFUNC 