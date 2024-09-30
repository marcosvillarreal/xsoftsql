USE ferretti
GO
/****** Objeto:  Table [dbo].[ancabeasi]    Fecha de la secuencia de comandos: 04/28/2017 13:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ancabeasi](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idejercicio] [int] NOT NULL,
	[numero] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[tipoasi] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechacarga] [datetime] NOT NULL,
	[estado] [numeric](1, 0) NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

/****** Objeto:  Table [dbo].[Ancabefac]    Fecha de la secuencia de comandos: 04/28/2017 13:33:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Ancabefac](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idctacte] [int] NOT NULL,
	[ctacte] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnombre] [char](35) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cdireccion] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ctelefono] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cpostal] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[idprovincia] [int] NOT NULL,
	[idtipoiva] [int] NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idsubcta] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idplanpago] [int] NOT NULL,
	[total] [numeric](11, 2) NOT NULL,
	[bonif1] [numeric](6, 3) NOT NULL,
	[bonif2] [numeric](6, 3) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[listaprecio] [numeric](2, 0) NOT NULL,
	[idfletero] [int] NOT NULL,
	[idfuerzavta] [int] NOT NULL,
	[idrutavdor] [int] NOT NULL,
	[idcategoria] [int] NOT NULL,
	[hojaactual] [int] NOT NULL,
	[hojatotal] [int] NOT NULL,
	[idlotemaopera] [numeric](12, 0) NOT NULL,
	[signo] [numeric](2, 0) NOT NULL,
	[idfrio] [int] NOT NULL,
	[tasamuni] [numeric](1, 0) NOT NULL,
	[diferida] [numeric](1, 0) NOT NULL,
	[idtiponcredito] [int] NOT NULL,
	[rendida] [numeric](1, 0) NOT NULL,
	[nropatron] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cotidolar] [numeric](11, 2) NULL,
	[facturado] [numeric](1, 0) NULL,
	[dni] [char](10) COLLATE Modern_Spanish_CI_AS NULL,
	[infoafip] [numeric](1, 0) NULL,
	[infocae] [numeric](1, 0) NULL,
	[cae] [char](14) COLLATE Modern_Spanish_CI_AS NULL,
	[talonario] [numeric](4, 0) NULL,
	[idtipocbte] [int] NULL,
	[vtocae] [datetime] NULL,
	[caetipo] [char](4) COLLATE Modern_Spanish_CI_AS NULL,
	[fechafacest] [datetime] NULL,
 CONSTRAINT [UQ_ancabefa1] UNIQUE NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

/****** Objeto:  Table [dbo].[ancuerfac]    Fecha de la secuencia de comandos: 04/28/2017 13:34:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ancuerfac](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[codigo] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[univenta] [numeric](1, 0) NOT NULL,
	[unibulto] [int] NOT NULL,
	[oricod] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[iddeposito] [int] NOT NULL,
	[espromocion] [numeric](1, 0) NOT NULL,
	[perceibruto] [numeric](1, 0) NOT NULL,
	[escambio] [numeric](1, 0) NOT NULL,
	[oferfecha] [datetime] NOT NULL,
	[oferbonif] [numeric](6, 3) NOT NULL,
	[oferbonifcant] [numeric](11, 3) NOT NULL,
	[idfrio] [int] NOT NULL,
	[pesable] [numeric](1, 0) NOT NULL,
	[boniciva] [numeric](14, 8) NOT NULL,
	[bonisiva] [numeric](14, 8) NOT NULL,
	[totalciva] [numeric](11, 3) NOT NULL,
	[totalsiva] [numeric](11, 3) NOT NULL,
	[endolar] [numeric](1, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

/****** Objeto:  Table [dbo].[ancuervari]    Fecha de la secuencia de comandos: 04/28/2017 13:34:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ancuervari](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcuerfac] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[idvariedad] [int] NOT NULL,
	[cantidad] [numeric](6, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[volumen] [numeric](9, 3) NOT NULL,
	[escambio] [numeric](1, 0) NOT NULL,
	[bonisiva] [numeric](11, 3) NOT NULL,
	[boniciva] [numeric](11, 3) NOT NULL
) ON [PRIMARY]


/****** Objeto:  Table [dbo].[anmovbcocar]    Fecha de la secuencia de comandos: 04/28/2017 13:35:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[anmovbcocar](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[origen] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[idtipomov] [int] NOT NULL,
	[numero] [numeric](10, 0) NOT NULL,
	[idctabco] [int] NOT NULL,
	[banco] [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[localidad] [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[fechavto] [datetime] NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[titular] [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[recibido] [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[entregado] [varchar](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[signo] [numeric](2, 0) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Objeto:  Table [dbo].[anmovcaja]    Fecha de la secuencia de comandos: 04/28/2017 13:36:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[anmovcaja](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[tablaori] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clase] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[detalle] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idvalor] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Objeto:  Table [dbo].[anmovctacte]    Fecha de la secuencia de comandos: 04/28/2017 13:36:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[anmovctacte](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[ctacte] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctacte] [int] NOT NULL,
	[subnumero] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idsubcta] [int] NOT NULL,
	[cuota] [numeric](2, 0) NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[saldo] [numeric](11, 2) NOT NULL,
	[entrega] [numeric](11, 2) NOT NULL,
	[vencimien] [datetime] NOT NULL,
	[total] [numeric](11, 2) NOT NULL,
	[detalle] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[signo] [numeric](2, 0) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Objeto:  Table [dbo].[anmovstock]    Fecha de la secuencia de comandos: 04/28/2017 13:37:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[anmovstock](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[codigo] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[iddeposito] [int] NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[volumen] [numeric](9, 3) NOT NULL,
	[importe] [numeric](11, 3) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[signo] [numeric](2, 0) NOT NULL,
	[existereal] [numeric](9, 2) NULL,
	[existedisp] [numeric](9, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Objeto:  Table [dbo].[antablaasi]    Fecha de la secuencia de comandos: 04/28/2017 13:37:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[antablaasi](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[tablaori] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idcuenta] [int] NOT NULL,
	[tipoconce] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[debehaber] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[detalle] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF


/****** Objeto:  Table [dbo].[antablaimp]    Fecha de la secuencia de comandos: 04/28/2017 13:38:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[antablaimp](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[tablaori] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idasiento] [numeric](12, 0) NOT NULL,
	[idcuenta] [int] NOT NULL,
	[tipoconce] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](11, 3) NOT NULL,
	[tasa] [numeric](9, 6) NOT NULL,
	[baseimp] [numeric](11, 3) NOT NULL,
	[nombre] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idprovincia] [int] NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF