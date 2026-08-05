
GO

/****** Object:  Table [dbo].[productoimg]    Script Date: 10/7/2025 16:03:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[productoimg](
	[id] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[imagen] [image] NOT NULL,
	[fecupdate] [datetime] NULL,
	[nombreimg] [char](100) NOT NULL,
 CONSTRAINT [PK_productoimg] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[productoimg] ADD  CONSTRAINT [DF_productoimg_fecupdate]  DEFAULT (getdate()) FOR [fecupdate]
GO


