use nuevasirena

go

GO

/****** Object:  Table [dbo].[canalvtaneg]    Script Date: 13/2/2025 16:49:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[canalvtadto](
	[id] [int] NOT NULL,
	[idcanalvta] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
	[min1] [numeric](11, 3) NOT NULL,
	[desc1] [numeric](6, 3) NOT NULL,
	[feccorte] [datetime] NOT NULL,
	[fecinicio] [datetime] NOT NULL,
 CONSTRAINT [PK_canalvtadto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
