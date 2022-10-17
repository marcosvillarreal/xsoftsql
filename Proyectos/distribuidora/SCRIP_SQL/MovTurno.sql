USE [almacen1810]
GO

/****** Object:  Table [dbo].[movturno]    Script Date: 17/10/2022 13:32:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[movturno](
	[id] [int] NOT NULL,
	[iddetanrocaja] [int] NOT NULL,
	[turno] [numeric](2, 0) NOT NULL,
	[importe] [numeric](14, 2) NOT NULL,
	[switch] [char](5) NOT NULL,
	[signo] [numeric](1, 0) NOT NULL,
	[fecupdate] [datetime] NULL,
	[sucursal] [numeric](3, 0) NULL,
	[sector] [numeric](2, 0) NULL,
 CONSTRAINT [PK_movturno] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[movturno] ADD  CONSTRAINT [DF_movturno_fecupdate]  DEFAULT (getdate()) FOR [fecupdate]
GO


