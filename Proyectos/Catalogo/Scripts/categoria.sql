
GO

/****** Object:  Table [dbo].[categoria]    Script Date: 22/1/2026 18:56:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[categoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) NOT NULL,
	[imagenurl] [nvarchar](max) NULL,
 CONSTRAINT [PK_categoria] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

