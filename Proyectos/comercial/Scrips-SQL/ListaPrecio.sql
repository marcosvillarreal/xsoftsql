
GO

/****** Object:  Table [dbo].[listaprecio]    Script Date: 26/11/2025 18:33:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[listaprecio](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [nvarchar](50) NOT NULL,
	[margen] [numeric](6, 3) NOT NULL,
	[abrevia] [char](2) NOT NULL,
 CONSTRAINT [PK_listaprecio] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


