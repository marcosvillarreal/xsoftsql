--OPTIMIZACION SQL
go
CREATE NONCLUSTERED INDEX IX_CabeAsi_ejercicio_numero 
ON [dbo].[CabeAsi] ([idejercicio], [numero] DESC);
go
CREATE NONCLUSTERED INDEX IX_cabefac_idmaopera_idtipocbte 
ON [dbo].[cabefac] ([idmaopera], [idtipocbte]);
go
CREATE NONCLUSTERED INDEX IX_cabefac_idtipocbte 
ON [dbo].[cabefac] ([idtipocbte]) 
INCLUDE ([idmaopera]);
go
CREATE NONCLUSTERED INDEX IX_maopera_max_num 
ON [dbo].[maopera] ([origen], [sucursal], [numcomp] DESC);
go
CREATE NONCLUSTERED INDEX IX_cabefac_max_num 
ON [dbo].[cabefac] ([idctacte], [fecha], [id]);
go

CREATE NONCLUSTERED INDEX IX_cuerfac_idmaopera_covering
ON [dbo].[cuerfac] ([idmaopera])
INCLUDE (
    [idarticulo], [cantidad], [univenta], [unibulto], [kilos], 
    [precosto], [precostosiva], [interno], [espromocion], 
    [pesable], [boniciva], [bonisiva], [totalsiva], [idcabeza], [escambio]
);

ALTER INDEX [IX_cuerfac_idmaopera_covering] ON [dbo].[cuerfac] 
REBUILD WITH (FILLFACTOR = 85);

ALTER INDEX [PK_cuerfac] ON [dbo].[cuerfac] 
REBUILD WITH (FILLFACTOR = 85);
go
CREATE NONCLUSTERED INDEX IX_maopera_vendedor_filtrado
ON [dbo].[maopera] ([idvendedor], [origen], [idcomproba])
INCLUDE ([numcomp], [clasecomp])
WHERE estado <> '1'; -- Solo incluye las filas que realmente consulta el reporte
go

CREATE NONCLUSTERED INDEX IX_movstock_articulo_subarti_deposito_fecha
ON [dbo].[movstock] ([idarticulo], [idsubarti], [iddeposito], [fecha])
INCLUDE ([cantidad], [signo]);

-- Resuelve la lectura masiva de 57k filas en fleteplanilla
CREATE NONCLUSTERED INDEX IX_fleteplanilla_numero_opt 
ON dbo.fleteplanilla (numero, idfletero) 
INCLUDE (fecha, switch, estado, nombre);

-- Optimiza los joins y conteos de ncuerfac
CREATE NONCLUSTERED INDEX IX_ncuerfac_idcabeza_cant 
ON dbo.ncuerfac (idcabeza, cantidad);

CREATE NONCLUSTERED INDEX IX_cabeasi_renumeracion 
ON dbo.cabeasi (idejercicio, fecha, tipoasi, id) 
INCLUDE (numero);

CREATE NONCLUSTERED INDEX IX_MovCtacte_fecha_opt
ON dbo.MovCtacte (fecha, idctacte, idmaopera)
INCLUDE (importe, signo, saldo, vencimien);

-- 2. Crear los índices optimizados
CREATE NONCLUSTERED INDEX IX_maopera_sucursal_vendedor_opt
ON dbo.maopera (sucursal, estado, clasecomp, idvendedor)
INCLUDE (idcomproba, numcomp);

CREATE NONCLUSTERED INDEX IX_cabefac_rendida_idmaopera
ON dbo.cabefac (rendida, idmaopera)
INCLUDE (idctacte, total, fecha, idtipoiva, idplanpago);

-- Para acelerar consultas y reportes por fecha de facturación estimada
CREATE NONCLUSTERED INDEX IX_cabefac_fechafacest
ON dbo.cabefac (fechafacest)
INCLUDE (idmaopera, idctacte, fecha);

DROP INDEX IF EXISTS IX_cabefac_rendida_idmaopera ON dbo.cabefac;

CREATE NONCLUSTERED INDEX IX_cabefac_rendida_idmaopera
ON dbo.cabefac (rendida, idmaopera)
INCLUDE (idctacte, ctacte, cnombre, total, fecha, bonif1, bonif2, signo, idtipoiva, idtiponcredito, idplanpago);