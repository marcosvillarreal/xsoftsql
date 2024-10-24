USE [urquiza]
GO
/****** Object:  Table [dbo].[mapeoimpresora]    Script Date: 01/23/2019 10:10:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mapeoimpresora](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idterminal] [int] NOT NULL,
	[idmapeada] [int] NOT NULL,
	[idimpresora] [int] NOT NULL,
 CONSTRAINT [PK_mapeoimpresora] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
