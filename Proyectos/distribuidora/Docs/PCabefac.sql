--USE [kleja]
--GO
--/****** Objeto:  Table [dbo].[ncabefac]    Fecha de la secuencia de comandos: 12/01/2017 12:42:21 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--SET ANSI_PADDING ON
--GO
--CREATE TABLE [dbo].[pcabefac](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idctacte] [int] NOT NULL,
--	[cpostal] [char](8) NOT NULL,
--	[idsubcta] [int] NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[total] [numeric](11, 2) NOT NULL,
--	[bonif1] [numeric](6, 3) NOT NULL,
--	[bonif2] [numeric](6, 3) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[signo] [numeric](2, 0) NOT NULL,
--	[idfletero] [int] NOT NULL,
--	[idfuerzavta] [int] NOT NULL,
--	[idrutavdor] [int] NOT NULL,
--	[subnumero] [char](3) NOT NULL,
--	[listaprecio] [numeric](1, 0) NOT NULL,
--	[idfrio] [int] NOT NULL,
--	[tasamuni] [numeric](1, 0) NOT NULL,
--	[diferida] [numeric](1, 0) NOT NULL,
--	[esremito] [numeric](1, 0) NULL,
--	[detaref] [char](40) NULL,
--	[detacobranza] [char](30) NULL,
-- CONSTRAINT [PK_pcabefac] PRIMARY KEY NONCLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
--
--GO
--SET ANSI_PADDING OFF
--go
USE [kleja]
GO
/****** Objeto:  Table [dbo].[ncuerfac]    Fecha de la secuencia de comandos: 12/01/2017 12:46:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pcuerfac](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[Codigo] [char](8) NOT NULL,
	[nombre] [varchar](40) NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[univenta] [numeric](1, 0) NOT NULL,
	[unibulto] [int] NOT NULL,
	[oricod] [char](8) NOT NULL,
	[cantorig] [numeric](9, 2) NOT NULL,
	[idoriginal] [int] NOT NULL,
	[sdocant] [numeric](9, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[volumen] [numeric](9, 3) NOT NULL,
	[listaprecio] [numeric](2, 0) NOT NULL,
	[precosto] [numeric](11, 3) NOT NULL,
	[precostosiva] [numeric](11, 3) NOT NULL,
	[preunita] [numeric](11, 3) NOT NULL,
	[preunitasiva] [numeric](11, 3) NOT NULL,
	[prearti] [numeric](11, 3) NOT NULL,
	[preartisiva] [numeric](11, 3) NOT NULL,
	[interno] [numeric](11, 3) NOT NULL,
	[despor] [numeric](6, 3) NOT NULL,
	[tasaiva] [numeric](6, 3) NOT NULL,
	[switch] [char](5) NOT NULL,
	[ivauni] [numeric](11, 3) NOT NULL,
	[alcohol] [char](1) NOT NULL,
	[perceibruto] [numeric](1, 0) NOT NULL,
	[nofactura] [numeric](1, 0) NOT NULL,
	[espromocion] [numeric](1, 0) NOT NULL,
	[iddeposito] [int] NOT NULL,
	[oferfecha] [datetime] NOT NULL,
	[oferbonif] [numeric](11, 3) NOT NULL,
	[oferbonifcant] [numeric](11, 3) NOT NULL,
	[idfrio] [int] NOT NULL,
	[pesable] [numeric](1, 0) NOT NULL,
	[escambio] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_pcuerfac] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

--USE [kleja]
--GO
--/****** Objeto:  Table [dbo].[ncuervari]    Fecha de la secuencia de comandos: 12/01/2017 12:47:15 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--CREATE TABLE [dbo].[pcuervari](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idcuerfac] [numeric](12, 0) NOT NULL,
--	[idarticulo] [int] NOT NULL,
--	[idsubarti] [int] NOT NULL,
--	[idvariedad] [int] NOT NULL,
--	[cantidad] [numeric](6, 2) NOT NULL,
--	[kilos] [numeric](9, 3) NOT NULL,
--	[volumen] [numeric](9, 3) NOT NULL,
--	[cantorig] [numeric](6, 2) NOT NULL,
--	[escambio] [numeric](1, 0) NOT NULL,
-- CONSTRAINT [PK_pcuervari] PRIMARY KEY NONCLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]
