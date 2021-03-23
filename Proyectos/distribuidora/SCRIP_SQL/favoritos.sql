USE fiori
GO

update datamenu set sec_idprograma = 1

/****** Object:  Table [dbo].[favoritos]    Script Date: 23/3/2021 16:11:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[favoritos](
	[id] [numeric](12, 0) NOT NULL,
	[idperfil] [numeric](12, 0) NOT NULL,
	[idusuario] [numeric](12, 0) NOT NULL,
	[idmenu] [numeric](12, 0) NOT NULL,
	[orden] [int] NOT NULL,
	[idprograma] [numeric](1, 0) NULL,
 CONSTRAINT [PK_favoritos] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


