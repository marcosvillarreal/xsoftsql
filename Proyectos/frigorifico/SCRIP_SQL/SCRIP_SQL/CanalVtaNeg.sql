USE [distribuidorasur]
GO

/****** Object:  Table [dbo].[canalvtaneg]    Script Date: 21/12/2020 13:52:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[canalvtaneg](
	[id] [int] NOT NULL,
	[idcanalvta] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
	[costobon] [numeric](11, 3) NOT NULL,
	[margen1] [numeric](6, 3) NOT NULL,
	[prevta1] [numeric](11, 3) NOT NULL,
	[prevtaf1] [numeric](11, 3) NOT NULL,
	[feccorte] [datetime] NOT NULL,
	[feccostobon] [datetime] NOT NULL,
 CONSTRAINT [PK_canalvtaneg] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

