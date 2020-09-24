USE ferretti
GO
/****** Object:  Table [dbo].[prodcodbarra]    Script Date: 01/07/2019 11:38:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[prodcodbarra](
	[id] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[codbarra] [char](15) NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_prodcodbarra] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF