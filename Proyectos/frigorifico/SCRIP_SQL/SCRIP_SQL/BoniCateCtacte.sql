USE [nuevasirena6]
GO

/****** Object:  Table [dbo].[bonirubrocate]    Script Date: 27/9/2022 22:34:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[bonicatectacte](
	[id] [int] NOT NULL,
	[idcatectacte] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
	[bonifica] [numeric](6, 2) NOT NULL,
	[fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_bonicatectacte] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


