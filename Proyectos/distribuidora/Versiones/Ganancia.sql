USE [garrone]
GO
/****** Object:  Table [dbo].[CateGan]    Script Date: 09/11/2019 16:23:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CateGan](
	[id] [int] NOT NULL,
	[abrevia] [char](2) NOT NULL,
	[nombre] [char](40) NOT NULL,
	[cnumsicore] [char](2) NOT NULL,
 CONSTRAINT [PK_CateGan] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

/****** Object:  Table [dbo].[ConceptoGan]    Script Date: 09/11/2019 16:24:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ConceptoGan](
	[ID] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](130) NOT NULL,
 CONSTRAINT [PK_ConceptoGan] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

/****** Object:  Table [dbo].[PadronAfip]    Script Date: 09/11/2019 16:24:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PadronAfip](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[cuit] [char](13) NOT NULL,
	[idcategoria] [int] NOT NULL,
	[idconcepto] [int] NOT NULL,
	[fechaauto] [datetime] NOT NULL,
	[fechamanu] [datetime] NOT NULL,
	[automatico] [numeric](1, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[excluido] [numeric](1, 0) NOT NULL,
	[leyenda] [char](100) NOT NULL,
	[fecdesde] [datetime] NOT NULL,
	[fechasta] [datetime] NOT NULL,
 CONSTRAINT [PK_PadronAfip_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF