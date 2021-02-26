USE [distribuidorasur]
GO

/****** Object:  Table [dbo].[renctacte]    Script Date: 26/2/2021 11:59:07:AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[rencaja](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
	[idfletero] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[switch] [char](5) NOT NULL,
 CONSTRAINT [PK_rencaja] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


