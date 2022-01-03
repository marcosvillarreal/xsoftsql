USE [kleja]
GO
/****** Objeto:  Table [dbo].[afependiente]    Fecha de la secuencia de comandos: 12/06/2017 00:40:19 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE TABLE [dbo].[afependiente](
--	[id] [numeric](12, 0) NOT NULL,
--	[idncuerfac] [numeric](12, 0) NOT NULL,
--	[idcuerpdte] [numeric](12, 0) NOT NULL,
-- CONSTRAINT [PK_afependiente] PRIMARY KEY NONCLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]


---AfeNPedido  origen c(3)

--/****** Objeto:  Table [dbo].[cabepdte]    Fecha de la secuencia de comandos: 12/06/2017 00:40:57 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--SET ANSI_PADDING ON
--GO
--CREATE TABLE [dbo].[cabepdte](
--	[id] [numeric](12, 0) NOT NULL,
--	[idctacte] [int] NOT NULL,
--	[idfleteplan] [numeric](12, 0) NULL,
--	[facturado] [numeric](1, 0) NULL,
--	[idvendedor] [int] NULL,
--	[sucursal] [numeric](3, 0) NULL,
--	[terminal] [numeric](3, 0) NULL,
--	[sector] [numeric](2, 0) NULL,
--	[idoperador] [int] NULL,
--	[estado] [char](1) NULL,
--	[fecserver] [datetime] NULL,
--	[fecha] [datetime] NULL,
--	[esremito] [numeric](1, 0) NULL,
-- CONSTRAINT [PK_pcabefac] PRIMARY KEY NONCLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
--
--GO
--SET ANSI_PADDING OFF

--/****** Objeto:  Table [dbo].[cuerpdte]    Fecha de la secuencia de comandos: 12/06/2017 00:41:25 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE TABLE [dbo].[cuerpdte](
--	[id] [numeric](12, 0) NOT NULL,
--	[idcabeza] [numeric](12, 0) NOT NULL,
--	[idncuerfac] [numeric](12, 0) NOT NULL,
--	[idncuervari] [numeric](12, 0) NOT NULL,
--	[idncabefac] [numeric](12, 0) NULL,
-- CONSTRAINT [PK_pcuerfac] PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
