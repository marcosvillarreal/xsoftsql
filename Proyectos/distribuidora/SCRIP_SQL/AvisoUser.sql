USE [distribuidorasur]
GO

/****** Object:  Table [dbo].[avisouser]    Script Date: 11/5/2021 14:30:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[avisouser](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idusuario] [int] NOT NULL,
	[fechacorte] [datetime] NOT NULL,
	[diasaviso] [int] NOT NULL,
	[activo] [numeric](1, 0) NOT NULL,
	[detalle] [char](250) NOT NULL,
 CONSTRAINT [PK_avisotermi] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


