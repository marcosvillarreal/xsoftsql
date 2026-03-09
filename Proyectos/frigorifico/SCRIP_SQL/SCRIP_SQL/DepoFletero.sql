USE [distribuidorasur]
GO

/****** Object:  Table [dbo].[DepoFletero]    Script Date: 11/5/2021 14:18:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DepoFletero](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[iddeposito] [int] NOT NULL,
	[idfletero] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
 CONSTRAINT [PK_DepoFletero] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


