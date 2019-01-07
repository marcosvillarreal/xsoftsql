use gestion
go
/****** Object:  Table [dbo].[movcheque]    Script Date: 01/07/2019 11:36:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movcheque](
	[id] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[fechavto] [datetime] NOT NULL,
	[numero] [numeric](15, 0) NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[idctatitular] [int] NOT NULL,
	[titular] [varchar](25) NOT NULL,
	[cuit] [char](13) NOT NULL,
	[idbanco] [int] NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[idctarecibido] [int] NOT NULL,
	[recibido] [varchar](25) NOT NULL,
	[idctaentregado] [int] NOT NULL CONSTRAINT [DF_movcheque_idctaentregado]  DEFAULT ((0)),
	[entregado] [varchar](25) NOT NULL,
	[detalle] [varchar](30) NOT NULL,
	[retirado] [numeric](1, 0) NOT NULL CONSTRAINT [DF_movcheque_retirado]  DEFAULT ((0)),
	[anulado] [numeric](1, 0) NOT NULL CONSTRAINT [DF_movcheque_anulado]  DEFAULT ((0)),
	[switch] [char](5) NOT NULL CONSTRAINT [DF_movcheque_switch]  DEFAULT ('00000'),
	[fecupdate] [datetime] NULL,
	[detaretiro] [char](55) NULL CONSTRAINT [DF_movcheque_detaretiro]  DEFAULT (''),
	[fecretiro] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF