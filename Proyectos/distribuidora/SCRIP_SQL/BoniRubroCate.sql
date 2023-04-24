USE [Kleja]
GO

/****** Object:  Table [dbo].[bonirubrocate]    Script Date: 24/4/2023 11:17:36 ******/
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
	[fechao] [datetime] NOT NULL,
	[semana] [char](7) NULL,
 CONSTRAINT [PK_bonirubrocate] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[bonirubrocate] ADD  CONSTRAINT [DF_bonirubrocate_semana]  DEFAULT ('0000000') FOR [semana]
GO


