use leon

go

--update maopera set numcomp = 'A004400032971' where id = 110001288689
--select * from maopera where numcomp = 'C004400032971'
--select * from cabecpra where idmaopera = 110001285569
go
--SELECT CsrRubro.nombre as rubro,Csrproducto.id as idarticulo  
--,SUM(csrMovstock.cantidad * Csrmovstock.signo) as Saldo_uni  
--,ISNULL(Csrvariedad.id,CAST(0 as int)) as idvariedad  
--from Producto as CsrProducto  
--left join subproducto as Csrsubproducto on CsrProducto.id = Csrsubproducto.idarticulo  
--    and CsrSubProducto.idvariedad >= 0  
--left join variedad as Csrvariedad on Csrsubproducto.idvariedad = Csrvariedad.id  
--inner join movstock as csrmovstock on CsrProducto.id = CsrMovStock.idarticulo    
--    and ((CsrSubProducto.id) = CsrMovStock.idsubarti 
--    OR (CsrSubProducto.id IS NULL AND CsrMovStock.idsubarti = 0))
--left join rubro as csrrubro on CsrProducto.idrubro = csrrubro.id  
--WHERE CsrProducto.idctacte in (1100002234,1100002235,1100002236,1100002237,1100002232,1100002233,1100004499,1100004502)  
--and isnull(Csrmovstock.FECHA,'20260806') < '20260806'   
--and isnull(CsrMovStock.iddeposito,0) IN (1100000001,1200000007)   
--GROUP BY CsrRubro.nombre,Csrproducto.id,Csrvariedad.id,Csrsubproducto.coddanone
--go
SELECT TOP 10
    qs.total_elapsed_time / 1000 AS TiempoTotal_ms,
    qs.total_elapsed_time / qs.execution_count / 1000 AS TiempoPromedio_ms,
    qs.total_logical_reads AS LecturasLogicas,
    qs.execution_count AS CantidadEjecuciones,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset)/2) + 1) AS QueryExacta
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
WHERE st.text NOT LIKE '%sys.dm_exec_query_stats%'
ORDER BY qs.total_elapsed_time / qs.execution_count DESC;