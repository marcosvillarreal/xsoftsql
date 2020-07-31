USE [Urquiza]
GO

/****** Object:  Table [dbo].[infcontab]    Script Date: 15/11/2019 06:43:54 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[infcontab](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idejercicio] [int] NOT NULL,
	[periodo1] [numeric](6, 0) NOT NULL,
	[coeficiente1] [numeric](10, 7) NOT NULL,
	[periodo2] [numeric](6, 0) NOT NULL,
	[coeficiente2] [numeric](10, 7) NOT NULL,
	[periodo3] [numeric](6, 0) NOT NULL,
	[coeficiente3] [numeric](10, 7) NOT NULL,
	[periodo4] [numeric](6, 0) NOT NULL,
	[coeficiente4] [numeric](10, 7) NOT NULL,
	[periodo5] [numeric](6, 0) NOT NULL,
	[coeficiente5] [numeric](10, 7) NOT NULL,
	[periodo6] [numeric](6, 0) NOT NULL,
	[coeficiente6] [numeric](10, 7) NOT NULL,
	[periodo7] [numeric](6, 0) NOT NULL,
	[coeficiente7] [numeric](10, 7) NOT NULL,
	[periodo8] [numeric](6, 0) NOT NULL,
	[coeficiente8] [numeric](10, 7) NOT NULL,
	[periodo9] [numeric](6, 0) NOT NULL,
	[coeficiente9] [numeric](10, 7) NOT NULL,
	[periodo10] [numeric](6, 0) NOT NULL,
	[coeficiente10] [numeric](10, 7) NOT NULL,
	[periodo11] [numeric](6, 0) NOT NULL,
	[coeficiente11] [numeric](10, 7) NOT NULL,
	[periodo12] [numeric](6, 0) NOT NULL,
	[coeficiente12] [numeric](10, 7) NOT NULL,
	[periodo0] [numeric](6, 0) NOT NULL,
	[coeficiente0] [numeric](10, 7) NOT NULL,
 CONSTRAINT [PK_infcontab] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


