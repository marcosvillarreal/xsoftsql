
--GO

--/****** Objeto: Table [dbo].[fletero] Fecha de script: 28/9/2026 10:59:11 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[tambo](
--	[id] [int] NOT NULL,
--	[numero] [numeric](4, 0) NOT NULL,
--	[nombre] [char](30) NOT NULL,
--	[lat] [char](25) NOT NULL,
--	[lng] [char](25) NOT NULL,
--	[renspa] [char](20) NOT NULL,
--	[idctacte] [int] NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[vtobrucelosis] [datetime] NOT NULL,
--	[vtotuberculosis] [datetime] NOT NULL,
--	[idareaneg] [int] NULL,
--	[iibb] [char](20) NOT NULL,
-- CONSTRAINT [PK_tambo] PRIMARY KEY NONCLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
-- CONSTRAINT [UQ_tambo1] UNIQUE NONCLUSTERED 
--(
--	[numero] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[tambo] ADD  CONSTRAINT [DF_tambo_idareaneg]  DEFAULT ((0)) FOR [idareaneg]
--GO

--CREATE TABLE [dbo].[movtambosliq](
--	[id] [numeric](12, 0) NOT NULL,
--	[idorigen] [numeric](12, 0) NOT NULL,
--	[origen] [char](4) NOT NULL,
--	[fechasis] [datetime] NOT NULL,
--	[programa] [char](15) NOT NULL,
--	[terminal] [numeric](3, 0) NOT NULL,
--	[idoperador] [int] NOT NULL,
--	[sucursal] [numeric](3, 0) NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[neto] [numeric](11, 2) NOT NULL,
--	[detalle] [varchar](30) NOT NULL,
--	[periodo] [char](6) NOT NULL,
--	[switch] [char](5) NOT NULL,
-- CONSTRAINT [PK_movtambo1] PRIMARY KEY NONCLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
GO
