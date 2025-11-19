USE leon
GO

/****** Object:  Table [dbo].[CabeInvent]    Script Date: 12/11/2025 15:20:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CabeInvent](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idoperador] [int] NULL,
	[sucursal] [int] NULL,
	[iddeposito] [int] NULL,
	[detalle] [varchar](500) NULL,
	[fecha] [datetime] NULL,
	[switch] [char](5) NULL,
	[estado] [numeric](1, 0) NULL,
	[procesado] [numeric](1, 0) NULL,
	[fechaupdate] [datetime] NULL,
	[clasetipo] [char](1) NULL,
 CONSTRAINT [PK_CabeInvent] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CabeInvent] ADD  DEFAULT (getdate()) FOR [fecha]
GO

ALTER TABLE [dbo].[CabeInvent] ADD  DEFAULT ('00000') FOR [switch]
GO

ALTER TABLE [dbo].[CabeInvent] ADD  DEFAULT ((0)) FOR [estado]
GO

ALTER TABLE [dbo].[CabeInvent] ADD  DEFAULT ((0)) FOR [procesado]
GO

ALTER TABLE [dbo].[CabeInvent] ADD  DEFAULT (getdate()) FOR [fechaupdate]
GO


--------------------------------------

GO

/****** Object:  Table [dbo].[CuerInvent]    Script Date: 12/11/2025 15:21:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CuerInvent](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idcabeinvent] [int] NULL,
	[idarticulo] [int] NULL,
	[codigo] [varchar](50) NULL,
	[nombre] [varchar](200) NULL,
	[idvariedad] [int] NULL,
	[codigovar] [varchar](50) NULL,
	[variedad] [varchar](200) NULL,
	[univenta] [int] NULL,
	[unibulto] [numeric](10, 2) NULL,
	[cantidad] [numeric](10, 2) NULL,
	[kilos] [numeric](10, 2) NULL,
 CONSTRAINT [PK_CuerInvent] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CuerInvent]  WITH CHECK ADD  CONSTRAINT [FK_CuerInvent_CabeInvent] FOREIGN KEY([idcabeinvent])
REFERENCES [dbo].[CabeInvent] ([id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CuerInvent] CHECK CONSTRAINT [FK_CuerInvent_CabeInvent]
GO


