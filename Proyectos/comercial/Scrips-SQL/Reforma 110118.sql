USE [comercio]
GO
/****** Objeto:  Table [dbo].[movremito]    Fecha de la secuencia de comandos: 01/10/2018 22:49:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movretiro](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idctacte] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[nombre] [char](80) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[iddeposito] [int] NOT NULL,
	[idubicacion] [int] NOT NULL,
	[activo] [int] NOT NULL,
 CONSTRAINT [PK_movretiro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF