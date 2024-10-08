use mildelicias_alsina
--script de actualizacion

--Definir los valores por sucursal
--Cambiar clientes a contado efecivo
--Parametros geerales, poder cambiar plan de pago
--Plan de Pago, valor de efectivo

--update paraconfig set idejercicio = 1100000024 where idejercicio = 1600000025
--update detanrocaja set idejercicio = 1100000024 where idejercicio = 1600000025
--update rubroctacon set idejercicio = 1100000024 where idejercicio = 1600000025
--update valorctacon set idejercicio = 1100000024 where idejercicio = 1600000025
--update plancue set idejercicio = 1100000024 where idejercicio = 1600000025
--update detaconta set id = 1100000024 where numero = 14

--update paraconta set idcuenta = 1100017759 where idejercicio = 1600000025 and numero = 30
--update paraconta set idcuenta = 1100017764 where idejercicio = 1600000025 and numero in (1,22)
--update paraconta set idcuenta = 1100017783 where idejercicio = 1600000025 and numero in (2,33)
--update paraconta set idcuenta = 1100017787 where idejercicio = 1600000025 and numero in (13,14)
--update paraconta set idcuenta = 1100017818 where idejercicio = 1600000025 and numero in (3)
--update paraconta set idcuenta = 1100017819 where idejercicio = 1600000025 and numero in (34)
--update paraconta set idcuenta = 1100017821 where idejercicio = 1600000025 and numero in (35)
--update paraconta set idcuenta = 1100017822 where idejercicio = 1600000025 and numero in (7)
--update paraconta set idcuenta = 1100017827 where idejercicio = 1600000025 and numero in (4,5,26)
--update paraconta set idcuenta = 1100017841 where idejercicio = 1600000025 and numero in (31)
--update paraconta set idcuenta = 1100017845 where idejercicio = 1600000025 and numero in (15)
--update paraconta set idcuenta = 1100017848 where idejercicio = 1600000025 and numero in (16)
--update paraconta set idcuenta = 1100018016 where idejercicio = 1600000025 and numero in (18,19,21,24)
--update paraconta set idcuenta = 1100018017 where idejercicio = 1600000025 and numero in (20,23)
--update paraconta set idejercicio = 1100000024 where idejercicio = 1600000025 

--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[movturno](
--	[id] [int] NOT NULL,
--	[iddetanrocaja] [int] NOT NULL,
--	[turno] [numeric](2, 0) NOT NULL,
--	[importe] [numeric](14, 2) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[signo] [numeric](1, 0) NOT NULL,
--	[fecupdate] [datetime] NULL,
--	[sucursal] [numeric](3, 0) NULL,
--	[sector] [numeric](2, 0) NULL,
--	[idareaneg] [int] NULL,
-- CONSTRAINT [PK_movturno] PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[movturno] ADD  CONSTRAINT [DF_movturno_fecupdate]  DEFAULT (getdate()) FOR [fecupdate]
--GO

--ALTER TABLE [dbo].[movturno] ADD  CONSTRAINT [DF_movturno_idareaneg]  DEFAULT ((0)) FOR [idareaneg]
--GO

