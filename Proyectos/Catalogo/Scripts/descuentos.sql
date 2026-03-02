USE [Kleja]
GO

/****** Object:  Table [dbo].[descuentos]    Script Date: 2/3/2026 11:40:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[descuentos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idempresa] [int] NOT NULL,
	[tipo] [varchar](50) NOT NULL,
	[nombre] [nvarchar](200) NOT NULL,
	[condiciones] [nvarchar](max) NULL,
	[fecha_inicio] [date] NULL,
	[fecha_fin] [date] NULL,
	[prioridad] [int] NOT NULL,
	[activo] [bit] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[descuentos] ADD  DEFAULT ((0)) FOR [prioridad]
GO

ALTER TABLE [dbo].[descuentos] ADD  DEFAULT ((1)) FOR [activo]
GO

ALTER TABLE [dbo].[descuentos] ADD  DEFAULT (getdate()) FOR [created_at]
GO

ALTER TABLE [dbo].[descuentos] ADD  DEFAULT (getdate()) FOR [updated_at]
GO

ALTER TABLE [dbo].[descuentos]  WITH CHECK ADD  CONSTRAINT [CK_descuentos_tipo] CHECK  (([tipo]='combo' OR [tipo]='clasificacion_cliente' OR [tipo]='cliente' OR [tipo]='cantidad' OR [tipo]='nxm' OR [tipo]='precio_especial' OR [tipo]='monto_fijo' OR [tipo]='porcentaje'))
GO

ALTER TABLE [dbo].[descuentos] CHECK CONSTRAINT [CK_descuentos_tipo]
GO

