USE [Kleja]
GO

/****** Object:  Table [dbo].[chofer]    Script Date: 30/3/2020 16:29:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[chofer](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](40) NOT NULL,
	[cuit] [char](15) NOT NULL,
	[activo] [numeric](1, 0) NULL,
 CONSTRAINT [PK_chofer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

