USE libreria
GO

/****** Object:  Table [dbo].[bonirubro]    Script Date: 27/9/2022 19:49:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[bonirubrocate](
	[id] [int] NOT NULL,
	[idcatectacte] [int] NOT NULL,
	[idrubro] [int] NOT NULL,
	[bonifica] [numeric](6, 2) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[fechao] [datetime] NOT NULL
 CONSTRAINT [PK_bonirubrocate] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


