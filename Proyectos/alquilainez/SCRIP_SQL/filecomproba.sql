USE alquilainez
GO

/****** Object:  Table [dbo].[FileComproba]    Script Date: 31/3/2021 09:58:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[FileComproba](
	[id] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[filename] [char](100) NOT NULL,
	[filedata] [image] NULL,
	[origen] [char](8) NOT NULL,
 CONSTRAINT [PK_FileComproba] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

