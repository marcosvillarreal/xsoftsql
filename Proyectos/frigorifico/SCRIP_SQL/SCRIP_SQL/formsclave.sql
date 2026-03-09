USE nuevasirena6
GO

/****** Object:  Table [dbo].[formsclave]    Script Date: 28/11/2022 13:30:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[formsclave](
	[form] [char](40) NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
	[clave] [char](10) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[formsclave] ADD  CONSTRAINT [DF_formsclave_estado]  DEFAULT ((0)) FOR [estado]
GO

insert into formsclave values ('regfacpub_del_afip',0,'993')


