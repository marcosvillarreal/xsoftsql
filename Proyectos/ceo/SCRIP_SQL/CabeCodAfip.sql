USE [urquiza]
GO
/****** Objeto:  Table [dbo].[cabecodafip]    Fecha de la secuencia de comandos: 09/16/2016 12:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabecodafip](
	[id] [int] NOT NULL,
	[letra] [char](1) NOT NULL,
	[prefijo] [numeric](4, 0) NOT NULL,
	[numdesde] [numeric](8, 0) NOT NULL,
	[numhasta] [numeric](8, 0) NOT NULL,
	[fechavto] [datetime] NOT NULL,
	[control] [char](20) NOT NULL,
 CONSTRAINT [PK_cabecodafip] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF