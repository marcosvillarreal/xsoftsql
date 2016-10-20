--Scrip de Actualizacion 2012-11-21
USE compel
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dmaopera]') AND type in (N'U'))
DROP TABLE [dbo].[dmaopera]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dcabedeta]') AND type in (N'U'))
DROP TABLE [dbo].[dcabedeta]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dcabefac]') AND type in (N'U'))
DROP TABLE [dbo].[dcabefac]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dcuerfac]') AND type in (N'U'))
DROP TABLE [dbo].[dcuerfac]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dcuervari]') AND type in (N'U'))
DROP TABLE [dbo].[dcuervari]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dpagos]') AND type in (N'U'))
DROP TABLE [dbo].[dpagos]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[dmaopera](
	[id] [numeric](12, 0) NOT NULL,
	[programa] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sucursal] [numeric](3, 0) NOT NULL,
	[terminal] [numeric](3, 0) NOT NULL,
	[sector] [numeric](2, 0) NOT NULL,
	[fechasis] [datetime] NOT NULL,
	[idoperador] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[iddetanrocaja] [int] NOT NULL,
	[idcomproba] [int] NOT NULL,
	[numcomp] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clasecomp] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[turno] [numeric](2, 0) NOT NULL,
	[puestocaja] [numeric](3, 0) NOT NULL,
	[idcotizadolar] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[estado] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idprefijo] [int] NOT NULL,
	[copiatkt] [numeric](2, 0) NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idpuestospooler] [int] NOT NULL,
	[idareaneg] [int] NOT NULL,
 CONSTRAINT [PK_dmaopera] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[dcabefac](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idctacte] [int] NOT NULL,
	[ctacte] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnombre] [char](35) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cdireccion] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
	[listaprecio] [numeric](1, 0) NOT NULL,
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
	[diferiada] [numeric](1, 0) NOT NULL,
	[idtiponcredito] [int] NOT NULL,
	[rendida] [numeric](1, 0) NOT NULL,
	[iddeposito] [int] NOT NULL,
	[cotidolar] [numeric](12, 3) NOT NULL,
	[idctavta1] [int] NOT NULL,
	[ivari1] [numeric](11, 2) NOT NULL,
	[basegra1] [numeric](11, 2) NOT NULL,
	[tasa1] [numeric](5, 3) NOT NULL,
	[idctavta2] [int] NOT NULL,
	[ivari2] [numeric](11, 2) NOT NULL,
	[basegra2] [numeric](11, 2) NOT NULL,
	[tasa2] [numeric](5, 3) NOT NULL,
	[idctavta3] [int] NOT NULL,
	[ivari3] [numeric](11, 2) NOT NULL,
	[basegra3] [numeric](11, 2) NOT NULL,
	[tasa3] [numeric](5, 3) NOT NULL,
	[idctavta4] [int] NOT NULL,
	[ivari4] [numeric](11, 2) NOT NULL,
	[basegra4] [numeric](11, 2) NOT NULL,
	[tasa4] [numeric](5, 3) NOT NULL,
	[idctavta5] [int] NOT NULL,
	[ivari5] [numeric](11, 2) NOT NULL,
	[basegra5] [numeric](11, 2) NOT NULL,
	[tasa5] [numeric](5, 3) NOT NULL,
	[nomrete1] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[retencion1] [numeric](11, 2) NOT NULL,
	[baserete1] [numeric](11, 2) NOT NULL,
	[tasarete1] [numeric](6, 3) NOT NULL,
	[nomrete2] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[retencion2] [numeric](11, 2) NOT NULL,
	[baserete2] [numeric](11, 2) NOT NULL,
	[tasarete2] [numeric](6, 3) NOT NULL,
	[nomrete3] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[retencion3] [numeric](11, 2) NOT NULL,
	[baserete3] [numeric](11, 2) NOT NULL,
	[tasarete3] [numeric](6, 3) NOT NULL,
	[nomrete4] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[retencion4] [numeric](11, 2) NOT NULL,
	[baserete4] [numeric](11, 2) NOT NULL,
	[tasarete4] [numeric](6, 3) NOT NULL,
	[nomrete5] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[retencion5] [numeric](11, 2) NOT NULL,
	[baserete5] [numeric](11, 2) NOT NULL,
	[tasarete5] [numeric](6, 3) NOT NULL,
	[nomperc1] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[percepcion1] [numeric](11, 2) NOT NULL,
	[baseperc1] [numeric](11, 2) NOT NULL,
	[tasaperc1] [numeric](6, 3) NOT NULL,
	[nomperc2] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[percepcion2] [numeric](11, 2) NOT NULL,
	[baseperc2] [numeric](11, 2) NOT NULL,
	[tasaperc2] [numeric](6, 3) NOT NULL,
	[baseexe] [numeric](11, 2) NOT NULL,
	[copiatk] [numeric](2, 0) NOT NULL,
	[baseinterno] [numeric](11, 2) NOT NULL,
	[basedescto] [numeric](11, 2) NOT NULL,
	[basegra] [numeric](11, 2) NOT NULL,
	[baseiva] [numeric](11, 2) NOT NULL,
	[basenocatego] [numeric](11, 2) NOT NULL,
	[perceibto1] [numeric](11, 2) NOT NULL,
	[perceibto2] [numeric](11, 2) NOT NULL,
	[subtotsiva] [numeric](11, 2) NOT NULL,
	[subtotciva] [numeric](11, 2) NOT NULL,
	[basedesctosiva] [numeric](11, 2) NOT NULL,
	[subnumero] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[valorizado] [numeric](1, 0) NOT NULL,
	[comprometemerc] [numeric](1, 0) NOT NULL,
	[subcnombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idprefijo] [int] NOT NULL,
	[vencimien] [datetime] NOT NULL,
	[cuota] [int] NOT NULL,
	[idareaneg] [int] NOT NULL,
	[idafecta] [numeric](12, 0) NOT NULL,
	[idmaoperao] [numeric](12, 0) NOT NULL,
	[switchafe] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nrolote] [numeric](12, 0) NOT NULL,
	[idoperatoria] [int] NOT NULL,
	[switchope] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[porce] [numeric](4, 0) NOT NULL,
 CONSTRAINT [UQ_dcabefa1] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[dcabedeta](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[detalle] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_dcabedeta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_dcabedet1] UNIQUE NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[dcuerfac](
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
	[listaprecio] [numeric](1, 0) NOT NULL,
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
	[escambio] [numeric](1, 0) NULL,
	[oferfecha] [datetime] NULL,
	[oferbonif] [numeric](6, 3) NULL,
	[oferbonifcant] [numeric](11, 3) NOT NULL,
	[idfrio] [int] NOT NULL,
	[pesable] [numeric](1, 0) NOT NULL,
	[importado] [numeric](1, 0) NOT NULL,
	[desctociva] [numeric](14, 8) NOT NULL,
	[desctosiva] [numeric](14, 8) NOT NULL,
	[uniciva] [numeric](11, 3) NOT NULL,
	[unisiva] [numeric](11, 3) NOT NULL,
	[endolar] [numeric](1, 0) NOT NULL,
	[idfuerzavta] [int] NOT NULL,
	[alcohol] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idenvase] [int] NOT NULL,
	[bonidigitada] [numeric](1, 0) NOT NULL,
	[comprome] [numeric](1, 0) NOT NULL,
	[idareaneg] [int] NOT NULL,
	[hojaactual] [int] NOT NULL,
	[peso] [numeric](7, 3) NOT NULL,
	[codvalido] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_dcuerfac] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[dcuervari](
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
	[boniciva] [numeric](11, 3) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NULL,
	[subnumero] [int] NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[dpagos](
	[id] [int] NOT NULL,
	[numero] [numeric](3, 0) NOT NULL,
	[cnombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[importe] [numeric](9, 2) NOT NULL,
	[idcuenta] [int] NOT NULL,
	[ctactebco] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[titular] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[banco] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[localidad] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nrocheque] [numeric](12, 0) NOT NULL,
	[idtipobco] [int] NOT NULL,
	[fechavto] [datetime] NOT NULL,
	[entregado] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idvalor] [int] NOT NULL,
	[idprovincia] [int] NOT NULL,
	[tipocaja] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[esclase] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[recibido] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nrotarjeta] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cupon] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cuota] [numeric](2, 0) NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctabco] [int] NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcheque] [text] COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctatitular] [int] NOT NULL,
	[idctaentregado] [int] NOT NULL,
	[idctarecibido] [int] NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[idbanco] [int] NOT NULL,
	[nroidentificador] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[lccuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_dpagos_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF