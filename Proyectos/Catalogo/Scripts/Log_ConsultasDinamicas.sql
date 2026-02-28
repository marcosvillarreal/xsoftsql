USE [Kleja]
GO

/****** Object:  Table [dbo].[Log_ConsultasDinamicas]    Script Date: 27/2/2026 20:13:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Log_ConsultasDinamicas](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[NombreProcedimiento] [nvarchar](128) NOT NULL,
	[cWhereGenerada] [nvarchar](max) NULL,
	[SQLCompleta] [nvarchar](max) NULL,
	[FechaEjecucion] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Log_ConsultasDinamicas] ADD  DEFAULT (getdate()) FOR [FechaEjecucion]
GO


