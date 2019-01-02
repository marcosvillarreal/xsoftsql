use leon
go
SELECT CsrProducto.id,CsrExistenc.iddeposito
,CsrSubProducto.id as idsubarti,ISNULL(Csrexistenc.existe,0) as existe
,ISNULL(Csrexistenc.kilos,0) as exi_kilos,CsrProducto.vtakilos as pesable

,(select ISNULL(SUM(csrMovstock.cantidad* CsrMovstock.signo),0) from movstock as csrmovstock
where csrproducto.id=csrmovstock.idarticulo and csrsubproducto.id=csrmovstock.idsubarti and csrExistenc.iddeposito=csrmovstock.iddeposito and Csrmovstock.fecha > '20190101') sumacantidad
,(select ISNULL(SUM(csrMovstock.kilos* CsrMovstock.signo),0) from movstock as csrmovstock
where csrproducto.id=csrmovstock.idarticulo and csrsubproducto.id=csrmovstock.idsubarti and csrExistenc.iddeposito=csrmovstock.iddeposito and Csrmovstock.fecha > '20190101') sumakilos

FROM producto as csrproducto
left join subproducto as Csrsubproducto ON Csrproducto.id=csrsubproducto.idarticulo
left join variedad as Csrvariedad on Csrsubproducto.idvariedad = Csrvariedad.id
left join existenc as Csrexistenc on Csrproducto.id = Csrexistenc.idarticulo and ISNULL(csrsubproducto.id,0)=ISNULL(csrexistenc.idsubarti,0)
WHERE Csrproducto.id>0 and CsrExistenc.iddeposito IN (1200000007) and CsrProducto.nolista=0
Order by CsrProducto.id
go
select count(*) from producto where  nolista = 0