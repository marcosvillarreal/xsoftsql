----OPTIMIZACION SQL
--go
--CREATE NONCLUSTERED INDEX IX_CabeAsi_ejercicio_numero 
--ON [dbo].[CabeAsi] ([idejercicio], [numero] DESC);
--go
--CREATE NONCLUSTERED INDEX IX_cabefac_idmaopera_idtipocbte 
--ON [dbo].[cabefac] ([idmaopera], [idtipocbte]);
--go
--CREATE NONCLUSTERED INDEX IX_cabefac_idtipocbte 
--ON [dbo].[cabefac] ([idtipocbte]) 
--INCLUDE ([idmaopera]);
--go
--CREATE NONCLUSTERED INDEX IX_maopera_max_num 
--ON [dbo].[maopera] ([origen], [sucursal], [numcomp] DESC);
--go
--CREATE NONCLUSTERED INDEX IX_cabefac_max_num 
--ON [dbo].[cabefac] ([idctacte], [fecha], [id]);
--go

--CREATE NONCLUSTERED INDEX IX_cuerfac_idmaopera_covering
--ON [dbo].[cuerfac] ([idmaopera])
--INCLUDE (
--    [idarticulo], [cantidad], [univenta], [unibulto], [kilos], 
--    [precosto], [precostosiva], [interno], [espromocion], 
--    [pesable], [boniciva], [bonisiva], [totalsiva], [idcabeza], [escambio]
--);

--ALTER INDEX [IX_cuerfac_idmaopera_covering] ON [dbo].[cuerfac] 
--REBUILD WITH (FILLFACTOR = 85);

--ALTER INDEX [PK_cuerfac] ON [dbo].[cuerfac] 
--REBUILD WITH (FILLFACTOR = 85);
--go
--CREATE NONCLUSTERED INDEX IX_maopera_vendedor_filtrado
--ON [dbo].[maopera] ([idvendedor], [origen], [idcomproba])
--INCLUDE ([numcomp], [clasecomp])
--WHERE estado <> '1'; -- Solo incluye las filas que realmente consulta el reporte
--go

--CREATE NONCLUSTERED INDEX IX_movstock_articulo_subarti_deposito_fecha
--ON [dbo].[movstock] ([idarticulo], [idsubarti], [iddeposito], [fecha])
--INCLUDE ([cantidad], [signo]);


