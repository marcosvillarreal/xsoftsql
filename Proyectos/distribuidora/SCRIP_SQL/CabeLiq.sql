USE [elcalden]
GO

/****** Objeto: Table [dbo].[cabeliq] Fecha de script: 27/10/2026 10:11:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[cabeLiq](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idctacte] [int] NOT NULL,
	[ctacte] [char](6) NOT NULL,
	[cnombre] [char](35) NOT NULL,
	[cdireccion] [char](25) NOT NULL,
	[cpostal] [char](8) NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[idprovincia] [int] NOT NULL,
	[idtipoiva] [int] NOT NULL,
	[cuit] [char](13) NOT NULL,
	[iibb] [char](20) NOT NULL,
	[idplanpago] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[pefiscal] [char](6) NOT NULL,
	[renspa] [char](20) NOT NULL,
	[vtobrucelosis] [datetime] NOT NULL,
	[vtotuberculosis] [datetime] NOT NULL,
	[lat] [char](25) NOT NULL,
	[lng] [char](25) NOT NULL,
	[cidiretambo] [varchar](100) NOT NULL,
	[partido] [varchar](100) NOT NULL,
	[cpostaltambo] [int] NOT NULL,
	[codlocarca] [int] NOT NULL,
	[idprovinciatambo] [int] NOT NULL,

	[litros] [numeric](13, 2) NOT NULL,
	[grasa] [numeric](7, 2) NOT NULL,
	[proteina] [numeric](7, 2) NOT NULL,
	[alicuotaiva] [numeric](5, 2) NOT NULL,
	[t_kilos] [numeric](15, 2) NOT NULL,
	[t_impuestos] [numeric](15, 2) NOT NULL,
	[t_iva] [numeric](15, 2) NOT NULL,
	[t_neto] [numeric](15, 2) NOT NULL,
	[total] [numeric](11, 2) NOT NULL,
	[switch] [char](5) NOT NULL,
	
	[signo] [numeric](2, 0) NOT NULL,
	[infoafip] [nchar](10) NULL,
	[infocae] [numeric](1, 0) NULL,
	[cae] [char](14) NULL,
	[talonario] [numeric](4, 0) NULL,
	[IdTipoCbte] [int] NULL,
	[vtocae] [datetime] NULL,
	[CAEtipo] [char](4) NULL,
	[recodevol] [numeric](11, 2) NOT NULL,
	[idcentrorecep] [int] NULL,
	[idprovrecep] [int] NULL,
	[idzona] [int] NULL,
	[iddeposito] [int] NULL,

 CONSTRAINT [PK_cabeliq] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_cabeliq1] UNIQUE NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[cabeliq] ADD  CONSTRAINT [DF_cabeliq_idzona]  DEFAULT ((0)) FOR [idzona]
GO

ALTER TABLE [dbo].[cabeliq] ADD  CONSTRAINT [DF_cabeliq_iddeposito]  DEFAULT ((0)) FOR [iddeposito]
GO


