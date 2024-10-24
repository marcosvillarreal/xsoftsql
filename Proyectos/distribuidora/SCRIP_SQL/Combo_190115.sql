USE ferretti
GO
/****** Object:  Table [dbo].[cuerCombo]    Script Date: 01/15/2019 13:41:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuerCombo](
	[id] [int] NOT NULL,
	[idcabecombo] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[cantidad] [numeric](4, 0) NOT NULL,
	[bonifica] [numeric](6, 3) NOT NULL,
 CONSTRAINT [PK_cuerCombo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[cabeCombo]    Script Date: 01/15/2019 13:41:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cabeCombo](
	[id] [int] NOT NULL,
	[idpromocion] [int] NOT NULL,
	[feccorte] [datetime] NOT NULL,
 CONSTRAINT [PK_cabeCombo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


