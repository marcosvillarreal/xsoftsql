
GO

/****** Objeto: Table [dbo].[fletero] Fecha de script: 28/9/2026 10:59:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tambo](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) NOT NULL,
	[lat] [char](25) NOT NULL,
	[lng] [char](25) NOT NULL,
	[renspa] [char](20) NOT NULL,
	[idctacte] [int] NOT NULL,
	[switch] [char](5) NOT NULL,
	[vtobrucelosis] [datetime] NOT NULL,
	[vtotuberculosis] [datetime] NOT NULL,
	[idareaneg] [int] NULL,
	[iibb] [char](20) NOT NULL,
 CONSTRAINT [PK_tambo] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_tambo1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tambo] ADD  CONSTRAINT [DF_tambo_idareaneg]  DEFAULT ((0)) FOR [idareaneg]
GO


