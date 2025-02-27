USE xxxxx
GO
--Crear en Usuarios idemail

/****** Object:  Table [dbo].[EmailEmpresa]    Script Date: 27/2/2025 13:55:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EmailEmpresa](
	[id] [int] NOT NULL,
	[smtpserver] [char](100) NOT NULL,
	[smtppuerto] [int] NOT NULL,
	[sendusing] [int] NOT NULL,
	[emailuser] [char](100) NOT NULL,
	[emailpass] [char](100) NOT NULL,
	[email] [char](100) NOT NULL,
	[emailauthen] [numeric](1, 0) NOT NULL,
	[smtpssl] [numeric](1, 0) NOT NULL,
	[emailcopy] [char](100) NOT NULL,
	[numero] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_EmailEmpresa] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


