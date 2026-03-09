USE [elsureño]
GO

/****** Object:  Table [dbo].[mapeo_gs1]    Script Date: 20/9/2021 14:17:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[mapeo_gs1](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idctacte] [int] NOT NULL,
	[nrognlctacte] [char](15) NOT NULL,
	[nrognlpropio] [char](15) NOT NULL,
	[nrognlentrega] [char](15) NOT NULL,
	[nrognlreceptor] [char](15) NOT NULL,
	[nombre] [char](50) NOT NULL,
	[direccion] [char](50) NOT NULL,
	[calle] [char](10) NOT NULL,
	[localidad] [char](50) NOT NULL,
	[provincia] [char](50) NOT NULL,
	[cpostal] [char](8) NOT NULL,
 CONSTRAINT [PK_mapeo_gs1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


