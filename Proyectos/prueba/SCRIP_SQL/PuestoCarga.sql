USE [kleja]
GO


---fleteplanilla.idpuesto int

/****** Object:  Table [dbo].[puestocarga]    Script Date: 09/12/2018 09:03:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[puestocarga](
	[id] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[nombre] [char](20) NOT NULL,
 CONSTRAINT [PK_puestocarga] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF