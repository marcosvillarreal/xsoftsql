&&PRocedimiento de prueba para generar xml

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrProducto.numero as codigoInterno
,ISNULL(CsrSubProducto.subnumero,0) as CodigoVariedad
,ISNULL(CsrSubProducto.codigo,ISNULL(CsrProducto.codbarra13,SPACE(1))) as codigoIndividual
,ISNULL(CsrSubProducto.codbarra14,ISNULL(CsrProducto.codbarra14,SPACE(1))) as CodigoBulto
,ISNULL(SUM(CsrExistencia.existe),CAST(0 as numeric(10))) as UnidadesEnStock
,CsrProducto.unibulto as unidadesPorBulto
,CsrProducto.nombre as descripcion
,ISNULL(CsrSubProducto.nombre,SPACE(1)) as variedad
,SPACE(200) as Templeate
From Producto as CsrProducto
left join SubProducto as CsrSubProducto on CsrProducto.id = CsrSubProducto.idarticulo
left join Existenc as CsrExistencia on CsrProducto.id = CsrExistencia.idarticulo and ISNULL(CsrSubProducto.id,0) = CsrExistencia.idsubarti
Where CsrProducto.idestado = 1 and CsrExistencia.iddeposito = 1100000001 and ISNULL(CsrSubProducto.estado,0) = 0
Group By CsrProducto.numero, CsrProducto.codbarra13, CsrProducto.codbarra14, CsrProducto.unibulto
,CsrSubProducto.codigo, CsrSubProducto.codbarra14, CsrSubProducto.nombre ,CsrProducto.nombre
,CsrSubProducto.subnumero
ENDTEXT 

IF NOT CrearCursorAdapter('Producto',lcCmd)
	RETURN 
ENDIF 


=CURSORTOXML(ALIAS(),"C:\Cursor.xml",1,512)

USE IN Producto



