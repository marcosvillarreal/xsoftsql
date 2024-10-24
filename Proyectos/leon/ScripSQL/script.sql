USE [master]
GO
/****** Object:  Database [leon]    Script Date: 09/09/2021 13:50:22 ******/
CREATE DATABASE [leon] ON  PRIMARY 
( NAME = N'leon', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\leon.mdf' , SIZE = 10980480KB , MAXSIZE = UNLIMITED, FILEGROWTH = 2048KB )
 LOG ON 
( NAME = N'leon_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\leon_log.ldf' , SIZE = 3164032KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 COLLATE Modern_Spanish_CI_AS
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'leon', @new_cmptlevel=80
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [leon].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [leon] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [leon] SET ANSI_NULLS OFF
GO
ALTER DATABASE [leon] SET ANSI_PADDING OFF
GO
ALTER DATABASE [leon] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [leon] SET ARITHABORT OFF
GO
ALTER DATABASE [leon] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [leon] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [leon] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [leon] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [leon] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [leon] SET CURSOR_DEFAULT  GLOBAL
GO
ALTER DATABASE [leon] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [leon] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [leon] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [leon] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [leon] SET  DISABLE_BROKER
GO
ALTER DATABASE [leon] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [leon] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [leon] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [leon] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [leon] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [leon] SET  READ_WRITE
GO
ALTER DATABASE [leon] SET RECOVERY SIMPLE
GO
ALTER DATABASE [leon] SET  MULTI_USER
GO
ALTER DATABASE [leon] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [leon] SET DB_CHAINING OFF
GO
USE [leon]
GO
/****** Object:  Table [dbo].[TranspLog]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TranspLog](
	[id] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numero] [int] NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numdoc] [char](15) COLLATE Modern_Spanish_CI_AS NULL,
	[idtipodoc] [int] NULL,
	[telefono] [char](20) COLLATE Modern_Spanish_CI_AS NULL,
	[telefono02] [char](20) COLLATE Modern_Spanish_CI_AS NULL,
	[localidad] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[direccion] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[idctacte] [int] NOT NULL,
 CONSTRAINT [PK_TranspLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cuervaricpra]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuervaricpra](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcuerfac] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[idvariedad] [int] NOT NULL,
	[cantidad] [numeric](6, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[volumen] [numeric](9, 3) NOT NULL,
 CONSTRAINT [PK_cuervaricpra] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcuerfac] ON [dbo].[cuervaricpra] 
(
	[idcuerfac] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cuervaricpra] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[formaenvase]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[formaenvase](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idarticulo] [int] NOT NULL,
	[orden] [int] NULL,
 CONSTRAINT [PK_formaenvase] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tablaimp]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tablaimp](
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
	[idprovincia] [int] NOT NULL,
 CONSTRAINT [PK_tablaimp] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idasiento] ON [dbo].[tablaimp] 
(
	[idasiento] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[tablaimp] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[tablaimp] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [tipoconce] ON [dbo].[tablaimp] 
(
	[tipoconce] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empresa]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[empresa](
	[id] [int] NOT NULL,
	[nombre] [char](45) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ramo] [char](45) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[direccion] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cpostal] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[localidad] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[provincia] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[telefono] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[email] [char](45) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipoiva] [int] NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ibruto] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cajapre] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[impint] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[agenteibb] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tag] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[retenedora] [numeric](1, 0) NOT NULL,
	[reteiva] [numeric](1, 0) NOT NULL,
	[psw] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[utilidad] [numeric](1, 0) NOT NULL,
	[utisobreflete] [numeric](1, 0) NOT NULL,
	[utisobreinterno] [numeric](1, 0) NOT NULL,
	[incluyeiva] [numeric](1, 0) NOT NULL,
	[retegan] [numeric](1, 0) NULL,
	[idsucursal] [int] NULL,
	[esconvenio] [numeric](1, 0) NULL,
	[lat] [char](20) COLLATE Modern_Spanish_CI_AS NULL,
	[lng] [char](20) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bonivdor]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bonivdor](
	[id] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
	[bonifica] [numeric](6, 3) NOT NULL,
	[diasvisita] [char](7) COLLATE Modern_Spanish_CI_AS NULL,
	[diasfactura] [char](7) COLLATE Modern_Spanish_CI_AS NULL,
	[fecha] [datetime] NULL,
 CONSTRAINT [PK_bonivdor] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idvendedor] ON [dbo].[bonivdor] 
(
	[idvendedor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[valor]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[valor](
	[id] [int] NOT NULL,
	[numero] [numeric](3, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[regisa] [numeric](1, 0) NOT NULL,
	[regisb] [numeric](1, 0) NOT NULL,
	[regisd] [numeric](1, 0) NOT NULL,
	[regisf] [numeric](1, 0) NOT NULL,
	[regisc] [numeric](1, 0) NOT NULL,
	[regisk] [numeric](1, 0) NOT NULL,
	[idctaa] [int] NOT NULL,
	[idctab] [int] NOT NULL,
	[idctad] [int] NOT NULL,
	[idctaf] [int] NOT NULL,
	[idctac] [int] NOT NULL,
	[idclase] [int] NOT NULL,
	[idctabco] [int] NOT NULL,
	[idctak] [int] NOT NULL,
 CONSTRAINT [PK_valor] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_valo1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[valor] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ctactemod]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ctactemod](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[idmodelo] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idejercicio] [int] NOT NULL,
 CONSTRAINT [PK_ctactemode] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[ctactemod] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idejercici] ON [dbo].[ctactemod] 
(
	[idejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmodelo] ON [dbo].[ctactemod] 
(
	[idmodelo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CabeLog]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CabeLog](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[iddeposito] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[domicilio] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[localidad] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[dominio] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[signo] [numeric](2, 0) NOT NULL,
	[total] [int] NOT NULL,
 CONSTRAINT [PK_CabeTranspLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cuerdeta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cuerdeta](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcuerfac] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[idvariedad] [int] NOT NULL,
	[detalle] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_cuerdeta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_cuerdet1] UNIQUE NONCLUSTERED 
(
	[idcuerfac] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cuerdeta] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fleteplanilla]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fleteplanilla](
	[id] [int] NOT NULL,
	[idfletero] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[estado] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[espedido] [numeric](1, 0) NULL CONSTRAINT [DF_fleteplanilla_espedido]  DEFAULT ((1)),
	[estadomov] [numeric](1, 0) NULL CONSTRAINT [DF_fleteplanilla_estadomov]  DEFAULT ((0)),
	[comprometida] [numeric](1, 0) NULL CONSTRAINT [DF_fleteplanilla_comprometida]  DEFAULT ((0)),
 CONSTRAINT [PK_fleteplanilla] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [comprometida] ON [dbo].[fleteplanilla] 
(
	[comprometida] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [espedido] ON [dbo].[fleteplanilla] 
(
	[espedido] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [estadomov] ON [dbo].[fleteplanilla] 
(
	[estadomov] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfletero] ON [dbo].[fleteplanilla] 
(
	[idfletero] ASC,
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [switch] ON [dbo].[fleteplanilla] 
(
	[switch] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[logquery]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[logquery](
	[id] [numeric](12, 0) IDENTITY(1,1) NOT NULL,
	[terminal] [int] NOT NULL,
	[programa] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[namequery] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NULL CONSTRAINT [DF_Table_1_fecinicial]  DEFAULT (getdate()),
	[tipo] [int] NOT NULL,
	[retardo] [char](10) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_logqueary] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[renctacte]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[renctacte](
	[id] [numeric](12, 0) NOT NULL,
	[idmovctacte] [numeric](12, 0) NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
	[idfletero] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_renctacte] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[zcarpetas]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zcarpetas](
	[cliente] [numeric](5, 0) NOT NULL,
	[vendedor] [numeric](3, 0) NOT NULL,
	[carpeta] [numeric](6, 0) NOT NULL,
	[orden] [numeric](6, 0) NOT NULL,
	[quevende] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[zona] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CuerLog]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuerLog](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[idenvase] [int] NOT NULL,
	[idforma] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[altura] [int] NOT NULL,
	[ancho] [int] NOT NULL,
	[fila] [int] NOT NULL,
	[pilote] [int] NOT NULL,
	[sueltos] [int] NOT NULL,
	[sinaptitud] [int] NOT NULL,
	[totaldeposito] [int] NOT NULL,
	[totalcamion] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[univenta] [numeric](1, 0) NOT NULL,
	[unibulto] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_CuerLog] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[paravario]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[paravario](
	[id] [int] NOT NULL,
	[idorigen] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](13, 2) NOT NULL,
	[porce] [numeric](7, 3) NOT NULL,
	[detalle] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_paravario] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_paravari1] UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[zcategori]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zcategori](
	[numero] [numeric](3, 0) NOT NULL,
	[nombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[limite] [numeric](13, 2) NOT NULL,
	[minimo_fac] [numeric](13, 2) NOT NULL,
	[plazo] [numeric](4, 0) NOT NULL,
	[descuento] [numeric](3, 0) NOT NULL,
	[detalle] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[plagracia] [numeric](3, 0) NOT NULL,
	[impofle] [numeric](11, 4) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[zcodbarra]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zcodbarra](
	[numero] [numeric](5, 0) NOT NULL,
	[codbarra] [numeric](13, 0) NOT NULL,
	[sabor] [numeric](2, 0) NOT NULL,
	[nomsabor] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[comprobante]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[comprobante](
	[id] [int] NOT NULL,
	[numero] [numeric](3, 0) NOT NULL,
	[cnombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cabrevia] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clase] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[signocta] [numeric](1, 0) NOT NULL,
	[signostock] [numeric](1, 0) NOT NULL,
	[regisa] [numeric](1, 0) NOT NULL,
	[regisb] [numeric](1, 0) NOT NULL,
	[regisd] [numeric](1, 0) NOT NULL,
	[regisf] [numeric](1, 0) NOT NULL,
	[regiss] [numeric](1, 0) NOT NULL,
	[regisc] [numeric](1, 0) NOT NULL,
	[regisk] [numeric](1, 0) NOT NULL,
	[regish] [numeric](1, 0) NOT NULL,
	[afectado] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[libroiva] [numeric](1, 0) NOT NULL,
	[idmodelo] [numeric](10, 0) NOT NULL,
	[nroautoma] [numeric](1, 0) NOT NULL,
	[pidevalor] [numeric](1, 0) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clasetipo] [char](2) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_comprobante] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_comprobant1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE CLUSTERED INDEX [cnombre] ON [dbo].[comprobante] 
(
	[cnombre] ASC,
	[id] ASC,
	[cabrevia] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [clase] ON [dbo].[comprobante] 
(
	[clase] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[comivende]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[comivende](
	[id] [int] NOT NULL,
	[idgrupo] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[porcentaje] [numeric](6, 2) NOT NULL,
	[origen] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[objetivo1] [numeric](5, 0) NOT NULL,
	[comision1] [numeric](5, 2) NOT NULL,
	[objetivo2] [numeric](5, 0) NOT NULL,
	[comision2] [numeric](5, 2) NOT NULL,
	[objetivo3] [numeric](5, 0) NOT NULL,
	[comision3] [numeric](5, 2) NOT NULL,
 CONSTRAINT [UQ_comivend1] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[comivende] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idgrupo] ON [dbo].[comivende] 
(
	[idgrupo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CabeCom]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CabeCom](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idfletero] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[numpratron] [int] NOT NULL,
	[idfleteplan] [int] NULL,
	[fecha] [datetime] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_CabeCom] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[CabeCom] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfleteplan] ON [dbo].[CabeCom] 
(
	[idfleteplan] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfletero] ON [dbo].[CabeCom] 
(
	[idfletero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idlocalidad] ON [dbo].[CabeCom] 
(
	[idlocalidad] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idmaopera] ON [dbo].[CabeCom] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gruposcomi]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[gruposcomi](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [UQ_gruposcom1] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[gruposcomi] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paraconfig]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[paraconfig](
	[id] [int] NOT NULL,
	[idejercicio] [int] NOT NULL,
	[tipocaja] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pidodolar] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pidocosto] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[iddeposito] [int] NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[idcomproba1] [int] NOT NULL,
	[idcomproba2] [int] NOT NULL,
	[idcomproba3] [int] NOT NULL,
	[idcomproba4] [int] NOT NULL,
	[idcomproba5] [int] NOT NULL,
	[idcomproba6] [int] NOT NULL,
	[idcomproba7] [int] NOT NULL,
	[idcomproba8] [int] NOT NULL,
	[idcomproba9] [int] NOT NULL,
	[tasa1] [numeric](6, 2) NOT NULL,
	[sobtasa1] [numeric](6, 2) NOT NULL,
	[tasa2] [numeric](6, 2) NOT NULL,
	[sobtasa2] [numeric](6, 2) NOT NULL,
	[tasa3] [numeric](6, 2) NOT NULL,
	[sobtasa3] [numeric](6, 2) NOT NULL,
	[retencion1] [numeric](6, 2) NOT NULL,
	[minreten1] [numeric](11, 3) NOT NULL,
	[retencion2] [numeric](6, 2) NOT NULL,
	[minreten2] [numeric](11, 3) NOT NULL,
	[retencion3] [numeric](6, 2) NOT NULL,
	[minreten3] [numeric](11, 3) NOT NULL,
	[retencion4] [numeric](6, 2) NOT NULL,
	[minreten4] [numeric](11, 3) NOT NULL,
	[retencion5] [numeric](6, 2) NOT NULL,
	[minreten5] [numeric](11, 3) NOT NULL,
	[talonpc1] [numeric](4, 0) NOT NULL,
	[talonma1] [numeric](4, 0) NOT NULL,
	[talonpc2] [numeric](4, 0) NOT NULL,
	[talonma2] [numeric](4, 0) NOT NULL,
	[talonpc3] [numeric](4, 0) NOT NULL,
	[talonma3] [numeric](4, 0) NOT NULL,
	[talonpc4] [numeric](4, 0) NOT NULL,
	[talonma4] [numeric](4, 0) NOT NULL,
	[talonpc5] [numeric](4, 0) NOT NULL,
	[talonma5] [numeric](4, 0) NOT NULL,
	[listadefecto] [numeric](1, 0) NOT NULL,
	[idplanpago] [int] NOT NULL,
	[idcta01] [int] NOT NULL,
	[idcta02] [int] NOT NULL,
	[idcta03] [int] NOT NULL,
	[idcta04] [int] NOT NULL,
	[idcta05] [int] NOT NULL,
	[switch] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[iddetanrocaja] [int] NOT NULL,
	[idcotizadolar] [int] NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[fechafac] [datetime] NOT NULL,
	[turno] [numeric](1, 0) NOT NULL,
	[iddetafac] [int] NOT NULL,
	[diasvto] [numeric](3, 0) NOT NULL,
	[idcentrorecep] [int] NULL,
 CONSTRAINT [PK_paraconfig] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[zprovinci]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zprovinci](
	[patente] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numero] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ibrutosa] [numeric](5, 2) NOT NULL,
	[ibrutosb] [numeric](5, 2) NOT NULL,
	[coeficient] [numeric](7, 4) NOT NULL,
	[reinspe] [numeric](8, 0) NOT NULL,
	[codjuri] [numeric](3, 0) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CuerCom]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuerCom](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[nombre] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[signo] [numeric](1, 0) NOT NULL,
	[iddeposito] [int] NOT NULL,
 CONSTRAINT [PK_CuerCom] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[CuerCom] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabeza] ON [dbo].[CuerCom] 
(
	[idcabeza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [iddeposito] ON [dbo].[CuerCom] 
(
	[iddeposito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[CuerCom] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dcabedeta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dcabedeta](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[detalle] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_dcabedeta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_dcabedet1] UNIQUE NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[localidad]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[localidad](
	[id] [int] NOT NULL,
	[cpostal] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idprovincia] [int] NOT NULL,
 CONSTRAINT [PK_localidad] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [cnombre] ON [dbo].[localidad] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CabeRep]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CabeRep](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idfletero] [int] NOT NULL,
	[iddepvacio] [int] NOT NULL,
	[iddepmerc] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_CabeRep] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [iddepmerc] ON [dbo].[CabeRep] 
(
	[iddepmerc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [iddepvacio] ON [dbo].[CabeRep] 
(
	[iddepvacio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfletero] ON [dbo].[CabeRep] 
(
	[idfletero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idmaopera] ON [dbo].[CabeRep] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zona]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zona](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[porflete] [numeric](6, 3) NOT NULL,
	[abrevia] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_zona] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[zona] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[zona] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CuerRep]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CuerRep](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[nombre] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[origen] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[signo] [numeric](1, 0) NOT NULL,
	[iddeposito] [int] NOT NULL,
 CONSTRAINT [PK_CuerRep] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[CuerRep] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabeza] ON [dbo].[CuerRep] 
(
	[idcabeza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [iddeposito] ON [dbo].[CuerRep] 
(
	[iddeposito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[CuerRep] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[moneda]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[moneda](
	[id] [int] NOT NULL,
	[numero] [numeric](5, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[llevadenominaciones] [numeric](1, 0) NOT NULL,
	[llevacentavos] [numeric](1, 0) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [id] ON [dbo].[moneda] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[moneda] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[moneda] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zzona]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zzona](
	[numero] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[avisouser]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[avisouser](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idusuario] [int] NOT NULL,
	[fechacorte] [datetime] NOT NULL,
	[diasaviso] [int] NOT NULL,
	[activo] [numeric](1, 0) NOT NULL,
	[detalle] [char](250) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_avisotermi] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[zonaruta]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zonaruta](
	[id] [int] NOT NULL,
	[idzona] [int] NOT NULL,
	[idruta] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_zonaruta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idruta] ON [dbo].[zonaruta] 
(
	[idruta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idzona] ON [dbo].[zonaruta] 
(
	[idzona] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AfeReparto]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AfeReparto](
	[id] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[idmaopeo] [numeric](12, 0) NOT NULL,
	[idfleteplan] [int] NOT NULL,
	[idcabecom] [int] NOT NULL,
	[switch] [nchar](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_AfeReparto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabecom] ON [dbo].[AfeReparto] 
(
	[idcabecom] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfleteplanilla] ON [dbo].[AfeReparto] 
(
	[idfleteplan] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopeo] ON [dbo].[AfeReparto] 
(
	[idmaopeo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[AfeReparto] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[denominacion]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[denominacion](
	[id] [int] NOT NULL,
	[idmoneda] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[orden] [int] NOT NULL,
	[valor] [numeric](9, 2) NOT NULL,
 CONSTRAINT [PK_denominacion] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmoneda] ON [dbo].[denominacion] 
(
	[idmoneda] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[denominacion] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Devolverid]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Devolverid]
@Lcalias varchar(20),
@RetValor int OUTPUT
AS
  SET NOCOUNT ON 
 SELECT @Retvalor=SCOPE_IDENTITY() FROM dbo.producto
return
GO
/****** Object:  Table [dbo].[alertas]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[alertas](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[leido] [numeric](1, 0) NOT NULL,
	[detalle] [varchar](500) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_alertas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[alertas] 
(
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[alertas] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [leido] ON [dbo].[alertas] 
(
	[leido] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PieRep]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PieRep](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[totvacio] [numeric](10, 2) NOT NULL,
	[totdeposito] [numeric](10, 2) NOT NULL,
	[totentrego] [numeric](10, 2) NOT NULL,
	[totrecibio] [numeric](10, 2) NOT NULL,
	[totcargo] [numeric](10, 2) NOT NULL,
	[dife] [numeric](10, 2) NOT NULL,
 CONSTRAINT [PK_PieRep] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idcabeza] ON [dbo].[PieRep] 
(
	[idcabeza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idmaopera] ON [dbo].[PieRep] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[arqueo]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[arqueo](
	[id] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idfletero] [int] NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[arqueo] 
(
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [id] ON [dbo].[arqueo] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfletero] ON [dbo].[arqueo] 
(
	[idfletero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[arqueo] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuerarqueo]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cuerarqueo](
	[id] [int] NOT NULL,
	[idarqueo] [int] NOT NULL,
	[iddenominacion] [int] NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[importe] [numeric](9, 2) NOT NULL,
	[detalle] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_cuerarqueo] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarqueo] ON [dbo].[cuerarqueo] 
(
	[idarqueo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [iddenomina] ON [dbo].[cuerarqueo] 
(
	[iddenominacion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ncuerfac]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ncuerfac](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[Codigo] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[univenta] [numeric](1, 0) NOT NULL,
	[unibulto] [int] NOT NULL,
	[oricod] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cantorig] [numeric](9, 2) NOT NULL,
	[idoriginal] [int] NOT NULL,
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
	[ivauni] [numeric](11, 3) NOT NULL,
	[alcohol] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
	[idprodcombo] [int] NULL CONSTRAINT [DF_ncuerfac_idprodcombo]  DEFAULT ((0)),
	[escombo] [numeric](1, 0) NULL CONSTRAINT [DF_ncuerfac_escombo]  DEFAULT ((0)),
 CONSTRAINT [PK_ncuerfac] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[ncuerfac] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabeza] ON [dbo].[ncuerfac] 
(
	[idcabeza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[ncuerfac] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[marca]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[marca](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[flete] [numeric](6, 3) NOT NULL,
	[flete2] [numeric](6, 3) NOT NULL,
	[idfuerzavta] [int] NOT NULL,
	[esproveedor] [numeric](1, 0) NULL,
	[escombo] [numeric](1, 0) NULL,
 CONSTRAINT [PK_marca] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_marc1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[marca] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FileComproba]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FileComproba](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[filename] [char](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[filedata] [image] NULL,
 CONSTRAINT [PK_FileComproba] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cuerruta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuerruta](
	[id] [int] NOT NULL,
	[idcaberuta] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[orden] [int] NOT NULL,
	[turno] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_cuerruta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcaberuta] ON [dbo].[cuerruta] 
(
	[idcaberuta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[cuerruta] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[saldoresbco]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[saldoresbco](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[saldoresumen] [numeric](15, 2) NOT NULL,
 CONSTRAINT [PK_saldoresbco] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_saldoresbc1] UNIQUE NONCLUSTERED 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[usuarios](
	[id] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[password] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idperfil] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NULL,
	[secu_sucursal] [numeric](1, 0) NULL,
 CONSTRAINT [PK_usuarios] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idperfil] ON [dbo].[usuarios] 
(
	[idperfil] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[usuarios] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuercpra]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cuercpra](
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
	[precosto] [numeric](11, 3) NOT NULL,
	[precostosiva] [numeric](11, 3) NOT NULL,
	[preunita] [numeric](11, 3) NOT NULL,
	[preunitasiva] [numeric](11, 3) NOT NULL,
	[interno] [numeric](11, 3) NOT NULL,
	[tasaiva] [numeric](6, 3) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[iddeposito] [int] NOT NULL,
	[pesable] [numeric](1, 0) NOT NULL,
	[idfrio] [int] NOT NULL,
	[bonif1] [numeric](11, 3) NOT NULL,
	[bonif2] [numeric](11, 3) NOT NULL,
	[bonif3] [numeric](11, 3) NOT NULL,
	[bonif4] [numeric](11, 3) NOT NULL,
 CONSTRAINT [PK_cuercpra] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idcabeza] ON [dbo].[cuercpra] 
(
	[idcabeza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cuercpra] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[caberuta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[caberuta](
	[id] [int] NOT NULL,
	[idrutavdor] [int] NOT NULL,
	[dia] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_caberuta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idrutavdor] ON [dbo].[caberuta] 
(
	[idrutavdor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipofrio]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipofrio](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tipoingbrutos]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipoingbrutos](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[vendedor]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vendedor](
	[id] [int] NOT NULL,
	[numero] [numeric](5, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clave] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctaflete] [int] NOT NULL,
	[planilla] [int] NOT NULL,
	[comision] [numeric](6, 3) NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
	[idctacomision] [int] NOT NULL,
	[idctasueldo] [int] NOT NULL,
	[prevta] [numeric](1, 0) NOT NULL,
	[idgrupocomi] [int] NOT NULL,
	[lista] [numeric](1, 0) NOT NULL,
	[idctacte] [int] NOT NULL,
	[acumulavale] [numeric](13, 2) NOT NULL,
	[idsucursal] [int] NULL,
 CONSTRAINT [PK_vendedor] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idgrupocom] ON [dbo].[vendedor] 
(
	[idgrupocomi] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[vendedor] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rubro]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[rubro](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[recargo] [numeric](5, 2) NOT NULL,
	[idtipovta] [int] NOT NULL,
	[idtipoprod] [int] NOT NULL,
	[perceibruto] [numeric](1, 0) NOT NULL,
	[idfuerzavta] [int] NOT NULL,
	[nolista] [numeric](1, 0) NOT NULL,
	[porcecomi] [numeric](5, 3) NOT NULL,
	[porcedev] [numeric](5, 3) NOT NULL,
	[porcesuge] [numeric](5, 3) NOT NULL,
	[tasavied] [numeric](5, 3) NOT NULL,
	[tasapata] [numeric](5, 3) NOT NULL,
	[cfexentoiva] [numeric](1, 0) NULL CONSTRAINT [DF_rubro_cfexentoiva]  DEFAULT ((0)),
 CONSTRAINT [PK_rubro] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[rubro] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[anuafebcocar]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[anuafebcocar](
	[id] [numeric](12, 0) NOT NULL,
	[idmaoperao] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[idmaoperaa] [numeric](12, 0) NOT NULL,
	[idafecta] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_anuafebcocar] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [afectacion] ON [dbo].[anuafebcocar] 
(
	[idmaoperao] ASC,
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[barrio]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[barrio](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idlocalidad] [int] NOT NULL,
 CONSTRAINT [PK_barrio] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idlocalida] ON [dbo].[barrio] 
(
	[idlocalidad] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tiponcredito]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tiponcredito](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AfipComproba]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AfipComproba](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[clasecomp] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[letra] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[codafip] [numeric](3, 0) NOT NULL,
 CONSTRAINT [PK_AfipComproba] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[gamabase]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[gamabase](
	[id] [int] NOT NULL,
	[idcatectacte] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
	[idsubproducto] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[variedad]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[variedad](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tag] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_variedad] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_varieda1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[variedad] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuerfac]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cuerfac](
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
	[escambio] [numeric](1, 0) NOT NULL,
	[oferfecha] [datetime] NOT NULL,
	[oferbonif] [numeric](6, 3) NOT NULL,
	[oferbonifcant] [numeric](11, 3) NOT NULL,
	[idfrio] [int] NOT NULL,
	[pesable] [numeric](1, 0) NOT NULL,
	[boniciva] [numeric](14, 8) NOT NULL,
	[bonisiva] [numeric](14, 8) NOT NULL,
	[devolciva] [numeric](14, 8) NULL,
	[devolsiva] [numeric](14, 8) NULL,
	[devol] [numeric](6, 3) NULL,
	[idprodcombo] [int] NULL CONSTRAINT [DF_cuerfac_idprodcombo_1]  DEFAULT ((0)),
	[escombo] [numeric](1, 0) NULL CONSTRAINT [DF_cuerfac_escombo_1]  DEFAULT ((0)),
 CONSTRAINT [PK_cuerfac] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[cuerfac] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabeza] ON [dbo].[cuerfac] 
(
	[idcabeza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cuerfac] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [tasaiva] ON [dbo].[cuerfac] 
(
	[tasaiva] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[clasecomp2]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[clasecomp2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[afectado] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[debehaber] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo] [char](2) COLLATE Modern_Spanish_CI_AS NULL,
	[codarbaiibb] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_clasecomp2] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_clasecom2_1] UNIQUE NONCLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bonictacte]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bonictacte](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
	[bonifica] [numeric](6, 2) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[fecupdate] [datetime] NULL CONSTRAINT [DF_bonictacte_fecupdate]  DEFAULT (getdate()),
 CONSTRAINT [PK_bonictacte] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[bonictacte] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idproducto] ON [dbo].[bonictacte] 
(
	[idproducto] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seguridad]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[seguridad](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idperfil] [numeric](10, 0) NOT NULL,
	[idmenu] [numeric](10, 0) NOT NULL,
 CONSTRAINT [PK_seguridad] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmenu] ON [dbo].[seguridad] 
(
	[idmenu] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idperfil] ON [dbo].[seguridad] 
(
	[idperfil] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PadronAfip]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PadronAfip](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idcategoria] [int] NOT NULL,
	[idconcepto] [int] NOT NULL,
	[fechaauto] [datetime] NOT NULL,
	[fechamanu] [datetime] NOT NULL,
	[automatico] [numeric](1, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[excluido] [numeric](1, 0) NOT NULL,
	[leyenda] [char](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecdesde] [datetime] NOT NULL,
	[fechasta] [datetime] NOT NULL,
 CONSTRAINT [PK_PadronAfip_1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[movcaja]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movcaja](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[tablaori] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clase] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[detalle] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idvalor] [int] NOT NULL,
 CONSTRAINT [PK_movcaja] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[movcaja] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[movcaja] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[clasecomp]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[clasecomp](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[afectado] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[debehaber] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo] [char](2) COLLATE Modern_Spanish_CI_AS NULL,
	[codarbaiibb] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_clasecomp] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_clasecom_1] UNIQUE NONCLUSTERED 
(
	[codigo] ASC,
	[tipo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cateprod]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cateprod](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_cateprod] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_catepro1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[cateprod] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ctactectacon]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ctactectacon](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[idctavta] [int] NOT NULL,
	[idctacpra] [int] NOT NULL,
	[idejercicio] [int] NOT NULL,
 CONSTRAINT [PK_ctactectacon] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConceptoGan]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ConceptoGan](
	[ID] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](130) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_ConceptoGan] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[estprodu]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[estprodu](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_estprodu] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_estprod1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[estprodu] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuerCombo]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuerCombo](
	[id] [int] NOT NULL,
	[idcabecombo] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idvariedad] [int] NOT NULL,
	[cantidad] [numeric](4, 0) NOT NULL,
	[bonifica] [numeric](6, 3) NOT NULL,
 CONSTRAINT [PK_cuerCombo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tablagan]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tablagan](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idconcepto] [int] NULL,
	[impmin] [numeric](11, 2) NOT NULL,
	[impmax] [numeric](11, 2) NOT NULL,
	[baserete] [numeric](11, 2) NOT NULL,
	[porce] [numeric](6, 2) NOT NULL,
	[excede] [numeric](11, 2) NOT NULL,
	[min] [numeric](11, 2) NOT NULL,
	[neto] [numeric](11, 2) NOT NULL,
	[netoant] [numeric](11, 2) NOT NULL,
	[rete] [numeric](11, 2) NOT NULL,
	[reteant] [numeric](11, 2) NOT NULL,
	[topenorete] [numeric](11, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subctacte]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[subctacte](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[cnumero] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[subnumero] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnombre] [char](30) COLLATE Modern_Spanish_CI_AS NULL,
	[cdireccion] [char](30) COLLATE Modern_Spanish_CI_AS NULL,
	[ctelefono] [char](20) COLLATE Modern_Spanish_CI_AS NULL,
	[clocalidad] [char](30) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_subctacte] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_subctact1] UNIQUE NONCLUSTERED 
(
	[cnumero] ASC,
	[subnumero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [cnombre] ON [dbo].[subctacte] 
(
	[cnombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CateGan]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CateGan](
	[id] [int] NOT NULL,
	[abrevia] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnumsicore] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_CateGan] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[formsclave]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[formsclave](
	[form] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[estado] [numeric](1, 0) NOT NULL CONSTRAINT [DF_formsclave_estado]  DEFAULT ((0)),
	[clave] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tipoiva]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipoiva](
	[id] [int] NOT NULL,
	[numero] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tasa] [numeric](5, 2) NOT NULL,
	[recago] [numeric](5, 2) NOT NULL,
	[siapcpravta] [char](4) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_tipoiva] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_tipoiv1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[tipoiva] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ctacteflete]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ctacteflete](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[importe] [numeric](11, 3) NOT NULL,
 CONSTRAINT [PK_ctacteflete] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_ctacteflet1] UNIQUE NONCLUSTERED 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipoprod]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipoprod](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_tipoprod] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_tipopro1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[tipoprod] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prefijonro]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[prefijonro](
	[id] [int] NOT NULL,
	[prefijo] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[letra] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numero] [numeric](10, 0) NOT NULL,
	[idimpresora] [int] NOT NULL,
	[formulario] [int] NOT NULL,
	[copias] [numeric](2, 0) NOT NULL,
	[cantlinea] [numeric](3, 0) NOT NULL,
	[idnofiscal] [int] NOT NULL,
	[nroautoma] [numeric](1, 0) NOT NULL,
	[nronofiscal] [numeric](10, 0) NOT NULL,
	[activocae] [numeric](1, 0) NULL,
	[activocaea] [numeric](1, 0) NULL,
 CONSTRAINT [PK_prefijonro] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[prefijonro] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipounid]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipounid](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_tipounid] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_tipouni1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[tipounid] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[pedipad]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[pedipad](
	[id] [numeric](12, 0) NOT NULL,
	[idpedido] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctacte] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[origen] [char](5) COLLATE Modern_Spanish_CI_AS NULL,
	[pedidoid_pm] [varchar](200) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tipovta]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipovta](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_tipovta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_tipovt1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[tipovta] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabeord]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabeord](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[total] [numeric](11, 2) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[listaprecio] [numeric](1, 0) NOT NULL,
	[idfletero] [int] NOT NULL,
	[iddepentra] [int] NOT NULL,
	[iddepsale] [int] NOT NULL,
	[signo] [numeric](2, 0) NOT NULL,
	[hojaactual] [int] NOT NULL,
	[hojatotal] [int] NOT NULL,
	[idlotemaopera] [numeric](12, 0) NOT NULL,
	[idctacte] [int] NOT NULL,
	[idconcepto] [int] NOT NULL,
	[numremito] [char](13) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ubicacion]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ubicacion](
	[id] [int] NOT NULL,
	[numero] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idsucursal] [int] NULL,
 CONSTRAINT [PK_ubicacion] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_ubicacio1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idsucursal] ON [dbo].[ubicacion] 
(
	[idsucursal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[ubicacion] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabecpra]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabecpra](
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
	[fecha] [datetime] NOT NULL,
	[idplanpago] [int] NOT NULL,
	[total] [numeric](11, 2) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idcategoria] [int] NOT NULL,
	[signo] [numeric](2, 0) NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[recodevol] [numeric](11, 2) NOT NULL,
	[idcentrorecep] [int] NULL,
	[idprovrecep] [int] NULL,
	[numcoe] [char](20) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_cabecpra] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_cabecpr1] UNIQUE NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[cabecpra] 
(
	[idmaopera] ASC,
	[signo] ASC,
	[cnombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deposito]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[deposito](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[llevastock] [numeric](1, 0) NOT NULL,
	[idsucursal] [int] NULL,
 CONSTRAINT [PK_deposito] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[deposito] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[banco]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[banco](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[direccion] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_banco] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_banc1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cuerord]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cuerord](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcabeza] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[codigo] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[univenta] [numeric](1, 0) NOT NULL,
	[unibulto] [int] NOT NULL,
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
	[hojaactual] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pesable] [numeric](1, 0) NOT NULL,
	[idfrio] [int] NOT NULL,
 CONSTRAINT [PK_cuerord] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idcabeza] ON [dbo].[cuerord] 
(
	[idcabeza] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cuerord] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuervariord]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuervariord](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcuerfac] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[idvariedad] [int] NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[volumen] [numeric](9, 3) NOT NULL,
 CONSTRAINT [PK_cuervariord] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcuerfac] ON [dbo].[cuervariord] 
(
	[idcuerfac] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bloqueoprod]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bloqueoprod](
	[id] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[idctacte] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[suc_usuarios]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[suc_usuarios](
	[id] [int] NOT NULL,
	[idusuario] [int] NOT NULL,
	[idsucursal] [int] NOT NULL,
	[tipo] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_usuarios_suc] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[afectacte]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[afectacte](
	[id] [numeric](12, 0) NOT NULL,
	[idmaoperad] [numeric](12, 0) NOT NULL,
	[iddebe] [numeric](12, 0) NOT NULL,
	[idmaoperah] [numeric](12, 0) NOT NULL,
	[idhaber] [numeric](12, 0) NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
 CONSTRAINT [PK_afectacte] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [iddebe] ON [dbo].[afectacte] 
(
	[iddebe] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idhaber] ON [dbo].[afectacte] 
(
	[idhaber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperad] ON [dbo].[afectacte] 
(
	[idmaoperad] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperah] ON [dbo].[afectacte] 
(
	[idmaoperah] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[movbcodeta]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movbcodeta](
	[id] [numeric](12, 0) NOT NULL,
	[idmovbcocar] [numeric](12, 0) NOT NULL,
	[idbanco] [int] NOT NULL,
	[idctatitular] [int] NOT NULL,
	[idctaentrega] [int] NOT NULL,
	[idctarecibido] [int] NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[codbarra] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cuit] [char](11) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idvalor] [int] NULL,
 CONSTRAINT [PK_movbcodeta] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idbanco] ON [dbo].[movbcodeta] 
(
	[idbanco] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctaentre] ON [dbo].[movbcodeta] 
(
	[idctaentrega] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctarecib] ON [dbo].[movbcodeta] 
(
	[idctarecibido] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctatitul] ON [dbo].[movbcodeta] 
(
	[idctatitular] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idlocalida] ON [dbo].[movbcodeta] 
(
	[idlocalidad] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [uq_movbcodet1] ON [dbo].[movbcodeta] 
(
	[idmovbcocar] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[impresora]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[impresora](
	[id] [int] NOT NULL,
	[nombre] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo] [numeric](2, 0) NOT NULL,
	[modelofis] [numeric](2, 0) NOT NULL,
	[puerto] [int] NOT NULL,
	[direccionip] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idterminal] [int] NOT NULL,
	[portname] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_impresora] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_impresor1] UNIQUE NONCLUSTERED 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[keysid]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[keysid](
	[tabla] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nextid] [int] NOT NULL,
	[ctipocomp] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_keysid] PRIMARY KEY NONCLUSTERED 
(
	[tabla] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[formulario]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[formulario](
	[id] [int] NOT NULL,
	[numero] [numeric](2, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[diseno] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_formulario] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[datamenu]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[datamenu](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sec_codacce] [char](12) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_descacce] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_nivelacce] [numeric](1, 0) NOT NULL,
	[sec_promptacc] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_tipoacce] [numeric](1, 0) NOT NULL,
	[sec_doacce] [char](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_keyacce] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_condacce] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_fontstyle] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_picture] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_idprograma] [numeric](1, 0) NULL CONSTRAINT [DF_datamenu_sec_idprograma]  DEFAULT ((1)),
	[sec_tipodoacce] [numeric](2, 0) NULL CONSTRAINT [DF_datamenu_sec_tipodoacce]  DEFAULT ((0)),
 CONSTRAINT [PK_datamenu] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[afecomproba]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[afecomproba](
	[id] [numeric](12, 0) NOT NULL,
	[idafectado] [numeric](12, 0) NOT NULL,
	[idafectador] [numeric](12, 0) NOT NULL,
	[idmaopeafec] [numeric](12, 0) NOT NULL,
	[idmaopeafedor] [numeric](12, 0) NOT NULL,
	[origen] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_afecomproba] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[prefitermi]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prefitermi](
	[id] [int] NOT NULL,
	[idterminal] [int] NOT NULL,
	[idprefijonro] [int] NOT NULL,
	[idcomproba] [int] NOT NULL,
 CONSTRAINT [PK_prefitermi] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[favoritos]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[favoritos](
	[id] [numeric](12, 0) NOT NULL,
	[idperfil] [numeric](12, 0) NOT NULL,
	[idusuario] [numeric](12, 0) NOT NULL,
	[idmenu] [numeric](12, 0) NOT NULL,
	[orden] [int] NOT NULL,
	[idprograma] [numeric](1, 0) NULL,
 CONSTRAINT [PK_favoritos] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CentroRecep]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CentroRecep](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idprovincia] [int] NOT NULL,
	[abrevia] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[addejercicio] [char](1) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_CentroRecep] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [numero] ON [dbo].[CentroRecep] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cbantevdor]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbantevdor](
	[id] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[idcomprobante] [int] NOT NULL,
 CONSTRAINT [PK_cbantevdor] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idvendedor] ON [dbo].[cbantevdor] 
(
	[idvendedor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Default [dbo].[UW_ZeroDefault]    Script Date: 09/09/2021 13:50:22 ******/
CREATE DEFAULT [dbo].[UW_ZeroDefault] AS 0
GO
/****** Object:  Table [dbo].[detaconta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[detaconta](
	[id] [int] NOT NULL,
	[idempresa] [int] NOT NULL,
	[ejercicio] [numeric](3, 0) NOT NULL,
	[fecdesde] [datetime] NOT NULL,
	[fechasta] [datetime] NOT NULL,
	[nrocaja1] [numeric](8, 0) NOT NULL,
	[nrocaja2] [numeric](8, 0) NOT NULL,
	[switch] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_detaconta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_detaconta] UNIQUE NONCLUSTERED 
(
	[idempresa] ASC,
	[ejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[afeconcilia]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[afeconcilia](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idmovbcocar] [numeric](12, 0) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_afeconcilia] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[afeconcilia] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmovbcoca] ON [dbo].[afeconcilia] 
(
	[idmovbcocar] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aferemito]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aferemito](
	[id] [numeric](12, 0) NOT NULL,
	[idmaoperao] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[idmaoperaa] [numeric](12, 0) NOT NULL,
	[idafecta] [numeric](12, 0) NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
 CONSTRAINT [PK_aferemito] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idafecta] ON [dbo].[aferemito] 
(
	[idafecta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperaa] ON [dbo].[aferemito] 
(
	[idmaoperaa] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperao] ON [dbo].[aferemito] 
(
	[idmaoperao] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[aferemito] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[produbicacion]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[produbicacion](
	[id] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idubicacion] [int] NOT NULL,
 CONSTRAINT [PK_suc_ubicacion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[produbicacion] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idubicacion] ON [dbo].[produbicacion] 
(
	[idubicacion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[movbcocar]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movbcocar](
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
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idsucorigen] [int] NULL,
	[idsucdestino] [int] NULL,
	[fechainfo] [datetime] NULL,
 CONSTRAINT [PK_movbcocar] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[movbcocar] 
(
	[id] ASC,
	[idmaopera] ASC,
	[importe] ASC,
	[numero] ASC,
	[idctabco] ASC,
	[signo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[movbcocar] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [origen] ON [dbo].[movbcocar] 
(
	[origen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[valorctacon]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[valorctacon](
	[id] [int] NOT NULL,
	[idejercicio] [int] NOT NULL,
	[idvalor] [int] NOT NULL,
	[idctaa] [int] NOT NULL,
	[idctab] [int] NOT NULL,
	[idctac] [int] NOT NULL,
	[idctad] [int] NOT NULL,
	[idctaf] [int] NOT NULL,
	[idctak] [int] NOT NULL,
	[idsucursal] [int] NULL,
 CONSTRAINT [PK_valorctacon] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idejercici] ON [dbo].[valorctacon] 
(
	[idejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idvalor] ON [dbo].[valorctacon] 
(
	[idvalor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[movctacte]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movctacte](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[ctacte] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctacte] [int] NOT NULL,
	[subnumero] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
	[signo] [numeric](2, 0) NOT NULL,
	[transferido] [numeric](1, 0) NULL,
 CONSTRAINT [PK_movctacte] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[movctacte] 
(
	[id] ASC,
	[idmaopera] ASC,
	[idctacte] ASC,
	[signo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[movctacte] 
(
	[idctacte] ASC,
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[movctacte] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[plancue]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[plancue](
	[id] [int] NOT NULL,
	[cuenta] [numeric](4, 0) NOT NULL,
	[nombre] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[imputable] [numeric](1, 0) NOT NULL,
	[idmadre] [int] NOT NULL,
	[madre] [int] NOT NULL,
	[orden] [int] NOT NULL,
	[idclase] [int] NOT NULL,
	[tipocuenta] [numeric](1, 0) NOT NULL,
	[codigo] [char](12) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idejercicio] [int] NOT NULL,
	[idejeantes] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_plancue] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[plancue] 
(
	[id] ASC,
	[cuenta] ASC,
	[nombre] ASC,
	[codigo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [cuenta] ON [dbo].[plancue] 
(
	[cuenta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[plancue] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [orden] ON [dbo].[plancue] 
(
	[madre] ASC,
	[orden] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[afebcocar]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[afebcocar](
	[id] [numeric](12, 0) NOT NULL,
	[idmaoperao] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[idmaoperaa] [numeric](12, 0) NOT NULL,
	[idafecta] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_afebcocar] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [afectacion] ON [dbo].[afebcocar] 
(
	[idorigen] ASC,
	[idmaoperao] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idafecta] ON [dbo].[afebcocar] 
(
	[idafecta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperaa] ON [dbo].[afebcocar] 
(
	[idmaoperaa] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperao] ON [dbo].[afebcocar] 
(
	[idmaoperao] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[afebcocar] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[movtarjeta]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movtarjeta](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[tarjeta] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numero] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cupon] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [datetime] NOT NULL,
	[fechavto] [datetime] NOT NULL,
	[cuota] [numeric](2, 0) NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[saldo] [numeric](11, 2) NOT NULL,
 CONSTRAINT [PK_movtarjeta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[movtarjeta] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fletero]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fletero](
	[id] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[direccion] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[telefono] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipoflete] [numeric](1, 0) NOT NULL,
	[idctacte] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idsucursal] [int] NULL,
	[numero] [numeric](4, 0) NOT NULL,
 CONSTRAINT [PK_fletero] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[fletero] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[fletero] 
(
	[nombre] ASC,
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[afetarjeta]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[afetarjeta](
	[id] [numeric](12, 0) NOT NULL,
	[idmaoperao] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[idmaoperaa] [numeric](12, 0) NOT NULL,
	[idafecta] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_afetarjeta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idafecta] ON [dbo].[afetarjeta] 
(
	[idafecta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperaa] ON [dbo].[afetarjeta] 
(
	[idmaoperaa] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperao] ON [dbo].[afetarjeta] 
(
	[idmaoperao] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[afetarjeta] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rutavdor]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[rutavdor](
	[id] [int] NOT NULL,
	[idruta] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idfuerzavta] [int] NOT NULL,
 CONSTRAINT [PK_rutavdor] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idruta] ON [dbo].[rutavdor] 
(
	[idruta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idvendedor] ON [dbo].[rutavdor] 
(
	[idvendedor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[zseccion]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zseccion](
	[numero] [numeric](2, 0) NOT NULL,
	[nombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ventas] [numeric](11, 2) NOT NULL,
	[reg_movis] [numeric](8, 0) NOT NULL,
	[porcedev] [numeric](5, 2) NOT NULL,
	[porsuge] [numeric](5, 2) NOT NULL,
	[pasasuc] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tasa] [numeric](8, 3) NULL,
	[tasapata] [numeric](8, 3) NOT NULL,
	[estado] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[comision] [numeric](8, 3) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cabedeta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabedeta](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[detalle] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NULL CONSTRAINT [DF_cabedeta_switch]  DEFAULT ('00000'),
 CONSTRAINT [PK_cabedeta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ruta]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ruta](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_ruta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[ruta] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[ruta] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ztablaiva]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ztablaiva](
	[numero] [numeric](1, 0) NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ivari] [numeric](6, 3) NOT NULL,
	[ivarni] [numeric](6, 3) NOT NULL,
	[otros] [numeric](6, 3) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[zvendedor]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zvendedor](
	[numero] [numeric](1, 0) NOT NULL,
	[nombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[direccion] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[telefono] [char](11) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[seccion] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[objetivo] [numeric](6, 0) NOT NULL,
	[comision] [numeric](5, 2) NOT NULL,
	[porce1] [numeric](5, 2) NOT NULL,
	[comision1] [numeric](5, 2) NOT NULL,
	[porce2] [numeric](5, 2) NOT NULL,
	[comision2] [numeric](5, 2) NOT NULL,
	[vadevol] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cliente] [numeric](5, 0) NOT NULL,
	[valistado] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ctactebco]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ctactebco](
	[id] [int] NOT NULL,
	[idctacte] [int] NOT NULL,
	[idbanco] [int] NOT NULL,
	[numero] [nchar](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cbu] [nchar](22) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_ctactebco] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[clasevalor]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[clasevalor](
	[id] [int] NOT NULL,
	[numero] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_clasevalor] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_clasevalo1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[clasevalor] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[concepto]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[concepto](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[estadomerc] [numeric](1, 0) NOT NULL,
	[tipoajuste] [numeric](1, 0) NOT NULL,
	[notacred] [numeric](1, 0) NOT NULL,
	[iddeposito] [int] NOT NULL,
	[switch] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[fletecarga]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fletecarga](
	[id] [int] NOT NULL,
	[idfleteplan] [int] NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[espedido] [numeric](1, 0) NULL CONSTRAINT [DF_fletecarga_espedido]  DEFAULT ((1)),
	[facturado] [numeric](1, 0) NULL CONSTRAINT [DF_fletecarga_estadopago]  DEFAULT ((0)),
 CONSTRAINT [PK_fletecarga] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [espedido] ON [dbo].[fletecarga] 
(
	[espedido] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [facturado] ON [dbo].[fletecarga] 
(
	[facturado] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfletepla] ON [dbo].[fletecarga] 
(
	[idfleteplan] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[fletecarga] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [switch] ON [dbo].[fletecarga] 
(
	[switch] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[clasecta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[clasecta](
	[id] [int] NOT NULL,
	[cnumero] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[provincia] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_clasecta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_clasect1] UNIQUE NONCLUSTERED 
(
	[cnumero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[afenpedido]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[afenpedido](
	[id] [numeric](12, 0) NOT NULL,
	[idmaoperan] [numeric](12, 0) NOT NULL,
	[idmaoperac] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_afenpedido] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperac] ON [dbo].[afenpedido] 
(
	[idmaoperac] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperan] ON [dbo].[afenpedido] 
(
	[idmaoperan] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tamano]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tamano](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_tamano] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_taman1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[tamano] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[detanrocaja]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[detanrocaja](
	[id] [int] NOT NULL,
	[idejercicio] [int] NOT NULL,
	[nrocaja] [numeric](8, 0) NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecdesde] [datetime] NOT NULL,
	[fechasta] [datetime] NOT NULL,
	[debe] [numeric](13, 3) NOT NULL,
	[haber] [numeric](13, 3) NOT NULL,
	[saldo] [numeric](13, 3) NOT NULL,
	[switch] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[feccierre] [datetime] NULL,
	[fecapertura] [datetime] NULL,
	[idsucursal] [int] NULL,
 CONSTRAINT [PK_detanrocaja] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idejercici] ON [dbo].[detanrocaja] 
(
	[idejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idsucursal] ON [dbo].[detanrocaja] 
(
	[idsucursal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nrocaja] ON [dbo].[detanrocaja] 
(
	[nrocaja] ASC,
	[idsucursal] ASC,
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[visitas]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[visitas](
	[id] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idcliente] [int] NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idvendedor] [int] NOT NULL,
	[idmotivo] [int] NOT NULL,
	[idpedido] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_visitas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dcabefac]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
	[idfletero] [int] NOT NULL,
	[idfuerzavta] [int] NOT NULL,
	[idrutavdor] [int] NOT NULL,
	[ivari1] [numeric](11, 2) NOT NULL,
	[basegra1] [numeric](11, 2) NOT NULL,
	[tasa1] [numeric](5, 3) NOT NULL,
	[ivari2] [numeric](11, 2) NOT NULL,
	[basegra2] [numeric](11, 2) NOT NULL,
	[tasa2] [numeric](5, 3) NOT NULL,
	[ivari3] [numeric](11, 2) NOT NULL,
	[basegra3] [numeric](11, 2) NOT NULL,
	[tasa3] [numeric](5, 3) NOT NULL,
	[ivari4] [numeric](11, 2) NOT NULL,
	[basegra4] [numeric](11, 2) NOT NULL,
	[tasa4] [numeric](5, 3) NOT NULL,
	[ivari5] [numeric](11, 2) NOT NULL,
	[basegra5] [numeric](11, 2) NOT NULL,
	[tasa5] [numeric](6, 3) NOT NULL,
	[baseexe] [numeric](11, 2) NOT NULL,
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
	[subnumero] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[listaprecio] [numeric](1, 0) NOT NULL,
	[idcategoria] [int] NOT NULL,
	[signo] [numeric](2, 0) NOT NULL,
 CONSTRAINT [UQ_dcabefa1] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[dcabefac] 
(
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[dcabefac] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[motivopad]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[motivopad](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dcuerfac]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
	[ivauni] [numeric](11, 3) NOT NULL,
	[alcohol] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[perceibruto] [numeric](1, 0) NOT NULL,
	[nofactura] [numeric](1, 0) NOT NULL,
	[espromocion] [numeric](1, 0) NOT NULL,
	[iddeposito] [int] NOT NULL,
	[unisiva] [numeric](11, 3) NOT NULL,
	[uniciva] [numeric](11, 3) NOT NULL,
	[pesable] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_dcuerfac] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[dcuerfac] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabecodafip]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabecodafip](
	[id] [int] NOT NULL,
	[letra] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[prefijo] [numeric](4, 0) NOT NULL,
	[numdesde] [numeric](8, 0) NOT NULL,
	[numhasta] [numeric](8, 0) NOT NULL,
	[fechavto] [datetime] NOT NULL,
	[control] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_cabecodafip] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dpagos]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
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
	[nrotarjeta] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cupon] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cuota] [numeric](2, 0) NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctabco] [int] NOT NULL,
	[esclase] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_dpagos] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[dpagos] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipotran]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipotran](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[expc] [numeric](1, 0) NOT NULL,
	[impc] [numeric](1, 0) NOT NULL,
	[exps] [numeric](1, 0) NOT NULL,
	[imps] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tipotran] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [expc] ON [dbo].[tipotran] 
(
	[expc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [exps] ON [dbo].[tipotran] 
(
	[exps] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [impc] ON [dbo].[tipotran] 
(
	[impc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [imps] ON [dbo].[tipotran] 
(
	[imps] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[tipotran] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dmaopera]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dmaopera](
	[id] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idcomproba] [int] NOT NULL,
	[numcomp] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clasecomp] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctacte] [int] NOT NULL,
	[importe] [numeric](10, 2) NOT NULL,
	[idprefijo] [int] NOT NULL,
	[copiatkt] [numeric](2, 0) NOT NULL,
	[sucursal] [numeric](3, 0) NOT NULL,
	[terminal] [numeric](3, 0) NOT NULL,
	[sector] [numeric](2, 0) NOT NULL,
	[iddetanrocaja] [int] NOT NULL,
	[turno] [numeric](2, 0) NOT NULL,
	[puestocaja] [numeric](3, 0) NOT NULL,
	[idoperador] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[idcotizadolar] [int] NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechasis] [datetime] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[estado] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[idpuestospooler] [int] NOT NULL,
 CONSTRAINT [PK_dmaopera] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[dmaopera] 
(
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Provincia]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Provincia](
	[Id] [int] NOT NULL,
	[Numero] [numeric](2, 0) NOT NULL,
	[Nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Alicuota1] [numeric](6, 2) NOT NULL,
	[Minimo1] [numeric](11, 3) NOT NULL,
	[Fecdesde1] [datetime] NOT NULL,
	[Alicuota2] [numeric](6, 2) NOT NULL,
	[Minimo2] [numeric](11, 3) NOT NULL,
	[Fecdesde2] [datetime] NOT NULL,
	[Alicuota3] [numeric](6, 2) NOT NULL,
	[Minimo3] [numeric](11, 3) NOT NULL,
	[Fecdesde3] [datetime] NOT NULL,
	[Alicuota4] [numeric](6, 2) NOT NULL,
	[Alicuota5] [numeric](6, 2) NOT NULL,
	[Coeficiente] [numeric](6, 2) NOT NULL,
	[Adicional] [numeric](6, 2) NOT NULL,
	[Abrevia] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[Convenio] [numeric](9, 3) NOT NULL,
	[Idcuenta] [int] NOT NULL,
	[Jurisdiccion] [numeric](4, 0) NOT NULL CONSTRAINT [DF__Provincia__Juris__5CA28C58]  DEFAULT ((0)),
	[RecInspe] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ImpAbre] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[codsicore] [char](2) COLLATE Modern_Spanish_CI_AS NULL,
	[codconvmult] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_provincia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UK_provinci1] UNIQUE NONCLUSTERED 
(
	[Numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idcuenta] ON [dbo].[Provincia] 
(
	[Idcuenta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[Provincia] 
(
	[Nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fuerzavta]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fuerzavta](
	[id] [int] NOT NULL,
	[numero] [numeric](5, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_fuerzavta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_fuerzavt1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[fuerzavta] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipotransf]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipotransf](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[expc] [numeric](1, 0) NOT NULL,
	[impc] [numeric](1, 0) NOT NULL,
	[exps] [numeric](1, 0) NOT NULL,
	[imps] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tipotransf] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [expc] ON [dbo].[tipotransf] 
(
	[expc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [exps] ON [dbo].[tipotransf] 
(
	[exps] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [impc] ON [dbo].[tipotransf] 
(
	[impc] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [imps] ON [dbo].[tipotransf] 
(
	[imps] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[tipotransf] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transf]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[transf](
	[idmaopera] [numeric](12, 0) NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_transf] PRIMARY KEY CLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cateibrn]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cateibrn](
	[idctacte] [int] NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numero] [int] NOT NULL,
	[porperce] [numeric](6, 3) NOT NULL,
	[porrete] [numeric](6, 3) NOT NULL,
 CONSTRAINT [PK_cateibrn] PRIMARY KEY CLUSTERED 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[cateibrn] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabeunifica]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabeunifica](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_cabeunifica] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_cabeunific1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[cabeunifica] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[citicomp]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[citicomp](
	[id] [int] NOT NULL,
	[idcomprobante] [int] NOT NULL,
	[letra] [nchar](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nrociti] [nchar](2) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuerunifica]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuerunifica](
	[id] [int] NOT NULL,
	[idcabeunifica] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
 CONSTRAINT [PK_cuerunifica] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabunifi] ON [dbo].[cuerunifica] 
(
	[idcabeunifica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[catectacte]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[catectacte](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tasa1] [numeric](5, 4) NOT NULL,
	[tasa2] [numeric](3, 2) NOT NULL,
	[tasa3] [numeric](3, 2) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[haydevol] [numeric](1, 0) NULL,
 CONSTRAINT [PK_catectacte] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[catectacte] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabepromo]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabepromo](
	[id] [int] NOT NULL,
	[idprodgenera] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](35) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idprodpromo] [int] NOT NULL,
	[idprodregalo] [int] NOT NULL,
	[cada] [int] NOT NULL,
	[entrega] [int] NOT NULL,
	[fechasta] [datetime] NULL,
 CONSTRAINT [PK_cabepromo] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idprodgene] ON [dbo].[cabepromo] 
(
	[idprodgenera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idprodprom] ON [dbo].[cabepromo] 
(
	[idprodpromo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[cabepromo] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[cabepromo] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[planpago]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[planpago](
	[id] [int] NOT NULL,
	[numero] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idvalor] [int] NOT NULL,
	[dias] [char](19) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tasa] [numeric](6, 3) NOT NULL,
	[copias] [numeric](1, 0) NULL,
 CONSTRAINT [PK_planpago] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_planpag1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[planpago] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuerpromo]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuerpromo](
	[id] [int] NOT NULL,
	[idcabepromo] [int] NOT NULL,
	[candesde] [int] NOT NULL,
	[canhasta] [int] NOT NULL,
	[bonifica] [numeric](7, 3) NOT NULL,
	[fechasta] [datetime] NOT NULL,
 CONSTRAINT [PK_cuerpromo] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabeprom] ON [dbo].[cuerpromo] 
(
	[idcabepromo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prodctacon]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prodctacon](
	[id] [int] NOT NULL,
	[idejercicio] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idctavta] [int] NOT NULL,
	[idctacpra] [int] NOT NULL,
 CONSTRAINT [PK_prodctacon] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[prodctacon] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idejercici] ON [dbo].[prodctacon] 
(
	[idejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cae_anticipado]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cae_anticipado](
	[periodo] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[quincena] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[caea] [char](14) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[manual] [numeric](1, 0) NOT NULL,
	[vencimiento] [datetime] NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[informado] [numeric](1, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[sistema]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sistema](
	[id] [int] NOT NULL,
	[programa] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[hora] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[prioridad] [numeric](2, 0) NOT NULL,
	[idprograma] [numeric](12, 0) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cabeasi]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabeasi](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idejercicio] [int] NOT NULL,
	[numero] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[tipoasi] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechacarga] [datetime] NOT NULL,
	[estado] [numeric](1, 0) NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_cabeasi] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[cabeasi] 
(
	[fecha] ASC,
	[idmaopera] ASC,
	[estado] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fechacarga] ON [dbo].[cabeasi] 
(
	[fechacarga] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idejercici] ON [dbo].[cabeasi] 
(
	[idejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cabeasi] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[cabeasi] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [tipoasi] ON [dbo].[cabeasi] 
(
	[tipoasi] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[perfiles]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[perfiles](
	[id] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [id] ON [dbo].[perfiles] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[afeasto]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[afeasto](
	[id] [numeric](12, 0) NOT NULL,
	[idmaoperao] [numeric](12, 0) NOT NULL,
	[idmaoperaa] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_afeasto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperaa] ON [dbo].[afeasto] 
(
	[idmaoperaa] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaoperao] ON [dbo].[afeasto] 
(
	[idmaoperao] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[precioperiodo]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[precioperiodo](
	[id] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[periodo] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[costo] [numeric](11, 3) NOT NULL,
	[costorepo] [numeric](11, 3) NOT NULL,
	[precio1] [numeric](11, 3) NOT NULL,
	[precio2] [numeric](11, 3) NOT NULL,
	[precio3] [numeric](11, 3) NOT NULL,
	[precio4] [numeric](11, 3) NOT NULL,
 CONSTRAINT [PK_precioperiodo] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[precioperiodo] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [periodo] ON [dbo].[precioperiodo] 
(
	[periodo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CabeImpresion]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CabeImpresion](
	[sucursal] [int] NOT NULL,
	[Empresa] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Ramo] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Direccion] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[TelefFax] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Localidad] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[IVA] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Otro01] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Otro02] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Otro03] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Otro04] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[Otro05] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
	[pathreporte] [char](100) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_CabeImpresion] PRIMARY KEY CLUSTERED 
(
	[sucursal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[provctacon]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[provctacon](
	[id] [int] NOT NULL,
	[idprovincia] [int] NOT NULL,
	[idctaperce] [numeric](12, 0) NOT NULL,
	[idctarete] [numeric](12, 0) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idejercicio] [int] NOT NULL,
 CONSTRAINT [PK_provctacon] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idctaperce] ON [dbo].[provctacon] 
(
	[idctaperce] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctarete] ON [dbo].[provctacon] 
(
	[idctarete] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idejercici] ON [dbo].[provctacon] 
(
	[idejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idprovinci] ON [dbo].[provctacon] 
(
	[idprovincia] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paradiario]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[paradiario](
	[id] [int] NOT NULL,
	[iddetanrocaja] [int] NOT NULL,
	[idcotizadolar] [int] NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[iddetafac] [int] NOT NULL,
	[fechafac] [datetime] NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[turno] [numeric](2, 0) NOT NULL,
 CONSTRAINT [PK_paradiario] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[cotizadolar]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cotizadolar](
	[id] [int] NOT NULL,
	[fechacoti] [datetime] NOT NULL,
	[preciocpra] [numeric](11, 3) NOT NULL,
	[preciovta] [numeric](11, 3) NOT NULL,
 CONSTRAINT [PK_cotizadolar] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_cotizadola1] UNIQUE NONCLUSTERED 
(
	[fechacoti] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[extmaopera]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[extmaopera](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idareaneg] [int] NOT NULL,
 CONSTRAINT [PK_extmaopera] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_extmaopera] UNIQUE NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idareaneg] ON [dbo].[extmaopera] 
(
	[idareaneg] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[categoiva]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[categoiva](
	[id] [int] NOT NULL,
	[numero] [numeric](2, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[letravta] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[letracpra] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[letrad] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[letrah] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ivavtari] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ivavtarni] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ivavtape] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[ivacpra] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[abrevia] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fiscal] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tasa1] [numeric](6, 2) NOT NULL,
	[tasa2] [numeric](6, 2) NOT NULL,
 CONSTRAINT [PK_categoiva] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_categoiv1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[categoiva] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[datapvta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[datapvta](
	[id] [numeric](10, 0) NOT NULL,
	[sec_codacce] [char](12) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_descacce] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_nivelacce] [numeric](1, 0) NOT NULL,
	[sec_promptacc] [char](45) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_tipoacce] [numeric](1, 0) NOT NULL,
	[sec_doacce] [char](100) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_keyacce] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_condacce] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_fontstyle] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sec_picture] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[boniproducto]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[boniproducto](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idprodcant] [int] NOT NULL,
	[cantidad] [numeric](9, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[idprodcant2] [int] NOT NULL,
	[cantidad2] [numeric](9, 2) NOT NULL,
	[kilos2] [numeric](6, 3) NOT NULL,
	[idprodbonif] [int] NOT NULL,
	[bonif] [numeric](6, 3) NOT NULL,
	[feccorte] [datetime] NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_boniproducto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[subproducto]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[subproducto](
	[id] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[subnumero] [int] NOT NULL,
	[nombre] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[codigo] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[troquel] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nofactura] [numeric](1, 0) NOT NULL,
	[idvariedad] [int] NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
	[codbarra14] [char](14) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_subproducto] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[subproducto] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idvariedad] ON [dbo].[subproducto] 
(
	[idvariedad] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[conexion]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[conexion](
	[id] [int] NOT NULL,
	[codigo] [int] NULL,
	[AliasConexion] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[servername] [char](60) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[initcatalogo] [char](60) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[origendata] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sourcetype] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[username] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pwdname] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[webservice] [char](60) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pathdatabase] [char](60) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sucursal] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pwdlen] [numeric](2, 0) NOT NULL,
	[userlen] [numeric](2, 0) NOT NULL,
	[idservpedido] [nchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[servpedido] [numeric](1, 0) NULL,
	[cantvdorpm] [numeric](3, 0) NULL,
	[passpedido] [char](50) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_conexion] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[prefijobco]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[prefijobco](
	[id] [int] NOT NULL,
	[idctabco] [int] NOT NULL,
	[idcomproba] [int] NOT NULL,
	[letra] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idimpresora] [int] NOT NULL,
	[formulario] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nrodesde] [numeric](10, 0) NOT NULL,
	[nrohasta] [numeric](10, 0) NOT NULL,
	[estado] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_prefijobco] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idcomproba] ON [dbo].[prefijobco] 
(
	[idcomproba] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctabco] ON [dbo].[prefijobco] 
(
	[idctabco] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[devolproducto]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[devolproducto](
	[id] [int] NOT NULL,
	[idrubro] [int] NOT NULL,
	[idproducto] [int] NOT NULL,
	[devolucion] [numeric](6, 2) NOT NULL,
 CONSTRAINT [PK_devolproducto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sucursal]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sucursal](
	[id] [int] NOT NULL,
	[idcentral] [int] NOT NULL,
	[idsucursal] [int] NOT NULL,
 CONSTRAINT [PK_sucursal] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcentral] ON [dbo].[sucursal] 
(
	[idcentral] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idsucursal] ON [dbo].[sucursal] 
(
	[idsucursal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seteoparam]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[seteoparam](
	[id] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cvalor] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[descripcion] [varchar](254) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_seteoparam] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [tipo] ON [dbo].[seteoparam] 
(
	[tipo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[prueba]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[prueba](
	[id] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[canalvta]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[canalvta](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[limitecred] [numeric](11, 2) NOT NULL,
	[minimofac] [numeric](11, 2) NOT NULL,
	[plazo] [numeric](3, 0) NOT NULL,
	[descuento] [numeric](6, 3) NOT NULL,
	[lista] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_canalvta] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_canalvt1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[canalvta] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabefac]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabefac](
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
	[diferida] [numeric](1, 0) NOT NULL,
	[idtiponcredito] [int] NOT NULL,
	[rendida] [numeric](1, 0) NOT NULL,
	[nropatron] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numcoe] [char](20) COLLATE Modern_Spanish_CI_AS NULL,
	[dni] [numeric](8, 0) NULL,
	[infoafip] [nchar](10) COLLATE Modern_Spanish_CI_AS NULL,
	[infocae] [numeric](1, 0) NULL,
	[cae] [char](14) COLLATE Modern_Spanish_CI_AS NULL,
	[talonario] [numeric](4, 0) NULL,
	[IdTipoCbte] [int] NULL,
	[vtocae] [datetime] NULL,
	[CAEtipo] [char](4) COLLATE Modern_Spanish_CI_AS NULL,
	[fechaFacEst] [datetime] NULL,
 CONSTRAINT [PK_cabefac] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_cabefa1] UNIQUE NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[cabefac] 
(
	[idmaopera] ASC,
	[cnombre] ASC,
	[signo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [cliente] ON [dbo].[cabefac] 
(
	[idctacte] ASC,
	[ctacte] ASC,
	[cnombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[cabefac] 
(
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[cabefac] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfletero] ON [dbo].[cabefac] 
(
	[idfletero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idlotemaop] ON [dbo].[cabefac] 
(
	[idlotemaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cabefac] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idrutavdor] ON [dbo].[cabefac] 
(
	[idrutavdor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idtipoiva] ON [dbo].[cabefac] 
(
	[idtipoiva] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idtiponcredito] ON [dbo].[cabefac] 
(
	[idtiponcredito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [infocae] ON [dbo].[cabefac] 
(
	[infocae] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [rendida] ON [dbo].[cabefac] 
(
	[rendida] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cateibba]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cateibba](
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[porperce] [numeric](7, 3) NOT NULL,
	[porrete] [numeric](7, 3) NOT NULL,
 CONSTRAINT [PK_cateibba] PRIMARY KEY NONCLUSTERED 
(
	[cuit] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[motanula]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[motanula](
	[id] [int] NOT NULL,
	[numero] [numeric](3, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_motanula] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_motanul1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[motanula] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[nmaopera]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[nmaopera](
	[id] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NOT NULL,
	[idcomproba] [int] NOT NULL,
	[numcomp] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[clasecomp] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idctacte] [int] NOT NULL,
	[importe] [numeric](10, 2) NOT NULL,
	[idprefijo] [int] NOT NULL,
	[copiatkt] [numeric](2, 0) NOT NULL,
	[sucursal] [numeric](3, 0) NOT NULL,
	[terminal] [numeric](3, 0) NOT NULL,
	[sector] [numeric](2, 0) NOT NULL,
	[iddetanrocaja] [int] NOT NULL,
	[turno] [numeric](2, 0) NOT NULL,
	[puestocaja] [numeric](3, 0) NOT NULL,
	[idoperador] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[idcotizadolar] [int] NOT NULL,
	[pefiscal] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechasis] [datetime] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[estado] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[enpatron] [numeric](1, 0) NULL CONSTRAINT [DF_nmaopera_enpatron]  DEFAULT ((0)),
	[facturado] [numeric](1, 0) NULL CONSTRAINT [DF_nmaopera_espedido]  DEFAULT ((0)),
 CONSTRAINT [PK_nmaopera] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [enpatron] ON [dbo].[nmaopera] 
(
	[enpatron] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [facturado] ON [dbo].[nmaopera] 
(
	[facturado] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[nmaopera] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuervari]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cuervari](
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
 CONSTRAINT [PK_cuervari] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[cuervari] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcuerfac] ON [dbo].[cuervari] 
(
	[idcuerfac] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cuervari] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[seteotermi]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[seteotermi](
	[id] [int] NOT NULL,
	[numero] [numeric](3, 0) NOT NULL,
	[sucursal] [numeric](3, 0) NOT NULL,
	[sector] [numeric](2, 0) NOT NULL,
	[puestocaja] [numeric](3, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[modpvta] [numeric](1, 0) NOT NULL,
	[grapmod] [numeric](1, 0) NOT NULL,
	[facsstock] [numeric](1, 0) NOT NULL,
	[facsdto] [numeric](1, 0) NOT NULL,
	[fecharec] [numeric](1, 0) NOT NULL,
	[anugentil] [numeric](1, 0) NOT NULL,
	[termiactiva] [numeric](1, 0) NOT NULL,
	[puestoactivo] [numeric](1, 0) NOT NULL,
	[puestospooler] [numeric](1, 0) NOT NULL,
	[serialdisk] [char](15) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_seteotermi] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_seteoterm1] UNIQUE NONCLUSTERED 
(
	[sucursal] ASC,
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[seteotermi] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabecartel]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cabecartel](
	[id] [int] NOT NULL,
	[detalle] [text] COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_cabecartel] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[anmaopera]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[anmaopera](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idafecta] [numeric](12, 0) NOT NULL,
	[detalle] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idmotanula] [numeric](12, 0) NOT NULL,
 CONSTRAINT [PK_anmaopera] PRIMARY KEY NONCLUSTERED 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_anmaoper1] UNIQUE NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idafecta] ON [dbo].[anmaopera] 
(
	[idafecta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmotanula] ON [dbo].[anmaopera] 
(
	[idmotanula] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[existenc]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[existenc](
	[id] [int] NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[iddeposito] [int] NOT NULL,
	[fecvto] [datetime] NOT NULL,
	[existe] [numeric](10, 2) NOT NULL,
	[existeant] [numeric](10, 2) NOT NULL,
	[kilos] [numeric](13, 3) NOT NULL,
	[kilosant] [numeric](13, 3) NOT NULL,
	[volumen] [numeric](13, 3) NOT NULL,
	[volumenant] [numeric](13, 3) NOT NULL,
	[existedisp] [numeric](10, 2) NOT NULL,
	[kilosdisp] [numeric](13, 3) NOT NULL,
	[volumendisp] [numeric](13, 3) NOT NULL,
 CONSTRAINT [PK_existenc] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_existen1] UNIQUE NONCLUSTERED 
(
	[idarticulo] ASC,
	[idsubarti] ASC,
	[iddeposito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[idasociado]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[idasociado](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idpadre] [numeric](12, 0) NOT NULL,
	[idhijo] [numeric](12, 0) NOT NULL,
	[origen] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_idasociado] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_idasociad1] UNIQUE NONCLUSTERED 
(
	[idhijo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[idasociado] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idpadre] ON [dbo].[idasociado] 
(
	[idpadre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cbioprecio]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cbioprecio](
	[id] [int] NOT NULL,
	[programa] [char](20) COLLATE Modern_Spanish_CI_AS NULL,
	[idarticulo] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[sucursal] [numeric](3, 0) NOT NULL,
	[terminal] [numeric](3, 0) NOT NULL,
	[costov] [numeric](11, 3) NOT NULL,
	[coston] [numeric](11, 3) NOT NULL,
	[costorepov] [numeric](11, 3) NOT NULL,
	[costorepon] [numeric](11, 3) NOT NULL,
	[internov] [numeric](11, 3) NOT NULL,
	[internon] [numeric](11, 3) NOT NULL,
	[prevta1v] [numeric](11, 3) NOT NULL,
	[prevta1n] [numeric](11, 3) NOT NULL,
	[prevta2v] [numeric](11, 3) NOT NULL,
	[prevta2n] [numeric](11, 3) NOT NULL,
	[prevta3v] [numeric](11, 3) NOT NULL,
	[prevta3n] [numeric](11, 3) NOT NULL,
	[prevta4v] [numeric](11, 3) NOT NULL,
	[prevta4n] [numeric](11, 3) NOT NULL,
	[costoa1v] [numeric](11, 3) NULL,
	[costoa1n] [numeric](11, 3) NULL,
	[costoa2v] [numeric](11, 3) NULL,
	[costoa2n] [numeric](11, 3) NULL,
	[costoa3v] [numeric](11, 3) NULL,
	[costoa3n] [numeric](11, 3) NULL,
	[costoa4v] [numeric](11, 3) NULL,
	[costoa4n] [numeric](11, 3) NULL,
	[costobonv] [numeric](11, 3) NULL CONSTRAINT [DF_cbioprecio_costobonv]  DEFAULT ((0)),
	[costobonn] [numeric](11, 3) NULL CONSTRAINT [DF_cbioprecio_costobonn]  DEFAULT ((0)),
 CONSTRAINT [PK_cbioprecio] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[cbioprecio] 
(
	[idarticulo] ASC,
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[cbioprecio] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fleteren]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fleteren](
	[id] [int] NOT NULL,
	[idfletero] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_fleteren] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[fleteren] 
(
	[id] ASC,
	[idfletero] ASC,
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idfletero] ON [dbo].[fleteren] 
(
	[idfletero] ASC,
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[fleteren] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[renmaope]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[renmaope](
	[id] [numeric](12, 0) NOT NULL,
	[idfleteren] [int] NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_renmaope] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idfleteren] ON [dbo].[renmaope] 
(
	[idfleteren] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[renmaope] 
(
	[idmaopera] ASC,
	[idfleteren] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[renflete]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[renflete](
	[id] [int] NOT NULL,
	[idfleteren] [int] NOT NULL,
	[idvendedor] [int] NOT NULL,
	[clase] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NULL CONSTRAINT [DF_renflete_switch]  DEFAULT ('00000'),
 CONSTRAINT [PK_renflete] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idfleteren] ON [dbo].[renflete] 
(
	[idfleteren] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[maopera]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[maopera](
	[id] [numeric](12, 0) NOT NULL,
	[origen] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
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
 CONSTRAINT [PK_maopera] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[maopera] 
(
	[id] ASC,
	[origen] ASC,
	[sucursal] ASC,
	[terminal] ASC,
	[iddetanrocaja] ASC,
	[idcomproba] ASC,
	[numcomp] ASC,
	[clasecomp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [clasecomp] ON [dbo].[maopera] 
(
	[clasecomp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fechasis] ON [dbo].[maopera] 
(
	[fechasis] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcomproba] ON [dbo].[maopera] 
(
	[idcomproba] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [iddetanrocaja] ON [dbo].[maopera] 
(
	[iddetanrocaja] ASC,
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idvendedor] ON [dbo].[maopera] 
(
	[idvendedor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [origen] ON [dbo].[maopera] 
(
	[origen] ASC,
	[clasecomp] ASC,
	[estado] ASC,
	[numcomp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [sucursal] ON [dbo].[maopera] 
(
	[sucursal] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[afecabecpra]    Script Date: 09/09/2021 13:50:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[afecabecpra](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopeentra] [numeric](12, 0) NOT NULL,
	[idmaopesale] [numeric](12, 0) NOT NULL,
	[idmaopefac] [numeric](12, 0) NOT NULL,
	[idmaopeord] [numeric](12, 0) NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idoperador] [int] NOT NULL,
	[fechaserver] [datetime] NOT NULL,
	[fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tablaasi]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tablaasi](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[tablaori] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idcuenta] [int] NOT NULL,
	[tipoconce] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[debehaber] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[importe] [numeric](11, 2) NOT NULL,
	[detalle] [varchar](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_tablaasi] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[tablaasi] 
(
	[id] ASC,
	[idmaopera] ASC,
	[idcuenta] ASC,
	[debehaber] ASC,
	[importe] ASC,
	[tablaori] ASC,
	[idorigen] ASC,
	[tipoconce] ASC,
	[detalle] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcuenta] ON [dbo].[tablaasi] 
(
	[idcuenta] ASC,
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[tablaasi] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[tablaasi] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[movpub]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movpub](
	[id] [numeric](12, 0) NOT NULL,
	[idorigen] [numeric](12, 0) NOT NULL,
	[origen] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fechasis] [datetime] NOT NULL,
	[programa] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[terminal] [numeric](3, 0) NOT NULL,
	[idoperador] [int] NOT NULL,
	[iddetanrocaja] [int] NOT NULL,
	[sucursal] [numeric](3, 0) NOT NULL,
	[idcotizadolar] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
	[neto] [numeric](11, 2) NOT NULL,
	[debe] [numeric](11, 2) NOT NULL,
	[haber] [numeric](11, 2) NOT NULL,
	[gastos] [numeric](11, 2) NOT NULL,
	[impuestos] [numeric](11, 2) NOT NULL,
	[sueldos] [numeric](11, 2) NOT NULL,
	[comisiones] [numeric](11, 2) NOT NULL,
	[concepto] [char](4) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[detalle] [varchar](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[periodo] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_movpub] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[movpub] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[camion]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[camion](
	[id] [int] NOT NULL,
	[numero] [numeric](3, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_camion] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_camio1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[camion] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cateibrng]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cateibrng](
	[id] [int] NOT NULL,
	[nombre] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[numero] [int] NOT NULL,
	[porperce] [numeric](6, 3) NOT NULL,
	[porrete] [numeric](6, 3) NOT NULL,
 CONSTRAINT [PK_cateibrng] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[movstock]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[movstock](
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
	[existedisp] [numeric](9, 2) NULL,
 CONSTRAINT [PK_movstock] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[movstock] 
(
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[movstock] 
(
	[idarticulo] ASC,
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idarticulo_fecha] ON [dbo].[movstock] 
(
	[idarticulo] ASC,
	[idsubarti] ASC,
	[fecha] ASC,
	[iddeposito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [iddeposito] ON [dbo].[movstock] 
(
	[iddeposito] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[movstock] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idorigen] ON [dbo].[movstock] 
(
	[idorigen] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[paraconta]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[paraconta](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[cnombre] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idcuenta] [int] NOT NULL,
	[impuesto] [numeric](1, 0) NOT NULL,
	[idejercicio] [int] NOT NULL,
	[switch] [char](10) COLLATE Modern_Spanish_CI_AS NULL,
	[idsucursal] [int] NULL,
 CONSTRAINT [PK_paraconta] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idcuenta] ON [dbo].[paraconta] 
(
	[idcuenta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[paraconta] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[forma]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[forma](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_forma] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_form1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[forma] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabemod]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabemod](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idejercicio] [int] NOT NULL,
	[switch] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_cabemod] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idejercici] ON [dbo].[cabemod] 
(
	[idejercicio] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [numero] ON [dbo].[cabemod] 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabeCombo]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cabeCombo](
	[id] [int] NOT NULL,
	[idpromocion] [int] NOT NULL,
	[feccorte] [datetime] NOT NULL,
 CONSTRAINT [PK_cabeCombo] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cuermod]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cuermod](
	[id] [int] NOT NULL,
	[idcabemod] [int] NOT NULL,
	[idcuenta] [int] NOT NULL,
	[cuenta] [int] NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[debehaber] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idclase] [int] NOT NULL,
	[nomclase] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tasa] [numeric](10, 3) NOT NULL,
 CONSTRAINT [PK_cuermod] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [cuenta] ON [dbo].[cuermod] 
(
	[cuenta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcabemod] ON [dbo].[cuermod] 
(
	[idcabemod] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idclase] ON [dbo].[cuermod] 
(
	[idclase] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcuenta] ON [dbo].[cuermod] 
(
	[idcuenta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EscalaGan]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EscalaGan](
	[id] [int] NOT NULL,
	[idconcepto] [int] NOT NULL,
	[impmin] [numeric](11, 2) NOT NULL,
	[impmax] [numeric](11, 2) NOT NULL,
	[baserete] [numeric](11, 2) NOT NULL,
	[porceri] [numeric](6, 2) NOT NULL,
	[porcerni] [numeric](6, 2) NOT NULL,
	[excedente] [numeric](11, 2) NOT NULL,
	[minimo] [numeric](11, 2) NOT NULL,
	[basenorete] [numeric](11, 2) NOT NULL,
 CONSTRAINT [PK_EscalaGan] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cabeconcilia]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[cabeconcilia](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[fecha] [datetime] NULL,
	[numcomp] [char](13) COLLATE Modern_Spanish_CI_AS NULL,
 CONSTRAINT [PK_cabeconcilia] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [fecha] ON [dbo].[cabeconcilia] 
(
	[fecha] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[cabeconcilia] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[gestion]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[gestion](
	[id] [int] NOT NULL,
	[programa] [image] NOT NULL,
	[nombrezip] [char](50) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecha] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[hora] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idprograma] [numeric](12, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ncabefac]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ncabefac](
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
	[signo] [numeric](2, 0) NOT NULL,
	[idfletero] [int] NOT NULL,
	[idfuerzavta] [int] NOT NULL,
	[idrutavdor] [int] NOT NULL,
	[ivari1] [numeric](11, 2) NOT NULL,
	[basegra1] [numeric](11, 2) NOT NULL,
	[tasa1] [numeric](5, 3) NOT NULL,
	[ivari2] [numeric](11, 2) NOT NULL,
	[basegra2] [numeric](11, 2) NOT NULL,
	[tasa2] [numeric](5, 3) NOT NULL,
	[ivari3] [numeric](11, 2) NOT NULL,
	[basegra3] [numeric](11, 2) NOT NULL,
	[tasa3] [numeric](5, 3) NOT NULL,
	[ivari4] [numeric](11, 2) NOT NULL,
	[basegra4] [numeric](11, 2) NOT NULL,
	[tasa4] [numeric](5, 3) NOT NULL,
	[ivari5] [numeric](11, 2) NOT NULL,
	[basegra5] [numeric](11, 2) NOT NULL,
	[tasa5] [numeric](6, 3) NOT NULL,
	[baseexe] [numeric](11, 2) NOT NULL,
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
	[subnumero] [char](3) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[listaprecio] [numeric](1, 0) NOT NULL,
	[idcategoria] [int] NOT NULL,
	[idfrio] [int] NOT NULL,
	[tasamuni] [numeric](1, 0) NOT NULL,
	[diferida] [numeric](1, 0) NOT NULL,
	[idtiponcredito] [int] NOT NULL,
 CONSTRAINT [PK_ncabefac] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idctacte] ON [dbo].[ncabefac] 
(
	[idctacte] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[ncabefac] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ncuervari]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ncuervari](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcuerfac] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[idvariedad] [int] NOT NULL,
	[cantidad] [numeric](6, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[volumen] [numeric](9, 3) NOT NULL,
	[cantorig] [numeric](6, 2) NOT NULL,
	[escambio] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_ncuervari] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idarticulo] ON [dbo].[ncuervari] 
(
	[idarticulo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcuerfac] ON [dbo].[ncuervari] 
(
	[idcuerfac] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[ncuervari] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idsubarti] ON [dbo].[ncuervari] 
(
	[idsubarti] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idvariedad] ON [dbo].[ncuervari] 
(
	[idvariedad] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dcuervari]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dcuervari](
	[id] [numeric](12, 0) NOT NULL,
	[idmaopera] [numeric](12, 0) NOT NULL,
	[idcuerfac] [numeric](12, 0) NOT NULL,
	[idarticulo] [int] NOT NULL,
	[idsubarti] [int] NOT NULL,
	[idvariedad] [int] NOT NULL,
	[cantidad] [numeric](6, 2) NOT NULL,
	[kilos] [numeric](9, 3) NOT NULL,
	[volumen] [numeric](9, 3) NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [id] ON [dbo].[dcuervari] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idcuerfac] ON [dbo].[dcuervari] 
(
	[idcuerfac] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idmaopera] ON [dbo].[dcuervari] 
(
	[idmaopera] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[origen]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[origen](
	[id] [int] NOT NULL,
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
 CONSTRAINT [PK_origen] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_orige1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[origen] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[Renumerasto]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Renumerasto]
@lnidejercicio int
AS
  SET NOCOUNT ON  
  
--  declare @id numeric(12)
--  declare @lnnumero int
--  declare @inc int
--  Declare @linea VarChar(1000)
--	declare CsrCabeAsi scroll Cursor 
--	For select id,numero from cabeasi where idejercicio=@lnidejercicio order by fecha,tipoasi,id

	--buscamos el ultimo id de la consulta
--	open CsrCabeasi
--	set @inc=0
--	fetch next from Csrcabeasi into @id,@lnnumero
--	while @@FETCH_STATUS = 0
--	begin	
--		select @inc=@inc+1	
--		set @linea=cast(@inc as varchar(100))
--		RAISERROR ('Lineas %s ',10,1,@linea) with nowait
--		update cabeasi set numero=@inc where id=@id 
--		fetch next from Csrcabeasi into @id,@lnnumero
--	end
--	close CsrCabeasi
--	DEALLOCATE CsrCabeasi

--declare @lnnumero int
--set @lnnumero=0
--update cabeasi set numero = 0
--update cabeasi set @lnnumero = numero = numero + 1 + @lnnumero from (select top(1000000) * from cabeasi where idejercicio=@lnidejercicio order by fecha,tipoasi,id) cabeasi



WITH Ca AS
(
SELECT *, ROW_NUMBER() OVER(ORDER BY fecha,tipoasi,id) AS RowNum FROM cabeasi where idejercicio=@lnidejercicio
)

update ca set numero =  Rownum 
print('Renumera asto')
print @lnidejercicio
UPDATE paravario set estado=0 where nombre='RENUASI'
GO
/****** Object:  StoredProcedure [dbo].[ActualizarID]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marcos Villarreal
-- Create date: 15/10/2009
-- Description:	Actualiza la tabla keysid desdes de alguna importacion
-- Modified date: 05/01/2011
-- Modified Descp.: Agregamos a la consulta [*]	 que obtiene el id maximo
--    el caso que el id no tiene sucursal tiene que ser menor al sucursal+id
-- Modified date: 26/11/2013
-- Modified Descp: Sacamos la busqueda sucursal. Ahora sacamos los valores de la sucursal
--    y buscamos en los numeros sisguientes para actualizar.
-- =============================================
CREATE PROCEDURE [dbo].[ActualizarID]
@lnSucursal int	
--No se usa mas, pero se deja para que no modificar las llamadas. 26/11/2013
AS
BEGIN
	SET NOCOUNT ON;
	declare @id numeric (12,0),@tabla varchar(20),@campo varchar(20),@tablaseek varchar(20),
	 @message varchar(80), @lcid varchar(15), @idmin numeric(12,0),@nlenid int;
	
	print('Sucursal Numero')
	print @lnSucursal

	declare CsrKeysid  cursor for
	SELECT table_name,column_name FROM information_schema.columns WHERE column_default IS NULL
	AND table_name <> 'sysdiagrams'
	and column_name='id' order by table_name
	OPEN CsrKeysid

	fetch next from CsrKeysid into @tablaseek,@campo
	SELECT Name FROM SysObjects WHERE Name='KEYSID' AND Type='U' 
	IF @@ROWCOUNT < 1
		CREATE TABLE Keysid ( Tabla Char(20), Nextid Integer, ctipocomp char(3) )    
	delete from Keysid
	--print @tablaseek
	--print  @id
	while @@FETCH_STATUS=0
		begin 
			print @tablaseek
			--Recuperamos el max id de la tabla que buscamos
			DECLARE @IntVariable numeric(12);
			DECLARE @SQLString nvarchar(500);
			DECLARE @ParmDefinition nvarchar(500);
			DECLARE @max_title varchar(30);
			DECLARE @IntVariableMin numeric(12);
			declare @Tama int;
			declare @cTama varchar(2);
			declare @SucursalMin numeric (12);
			declare @SucursalMax numeric (12);
			set @SucursalMin = 0
			set @SucursalMax = 0
			declare @hasta varchar(2);

			SET @SQLString = N'SELECT @length = length FROM SYSCOLUMNS WHERE ID =OBJECT_ID('''+@tablaseek+''') AND NAME=''ID'''
			SET @ParmDefinition =  N' @length int OUTPUT'
			EXECUTE 	SP_EXECUTESQL @SQLString, @ParmDefinition, @length = @Tama OUTPUT;
			
			--Mascaras con la sucursal incrustada segun el tamaño numerico
			
			--Modificado por Marcos 26/11/2013
			--Leon mantiene los datos unidos. 
			if @Tama = 4
				begin
				set @Tama = 10
				set @cTama = '10'
				set @hasta = '8'
				--SET @SucursalMin =  (@lnsucursal+10)*100000000
				--SET @SucursalMax = ( (@lnsucursal+10+1)*100000000)-1
				SET @SucursalMax = 99999999
				end
			else
				begin
				set @Tama = 12
				set @cTama = '12'
				set @hasta = '10'
				--SET @SucursalMin = (@lnsucursal+10)*10000000000
				--SET @SucursalMax = ((@lnsucursal+1+10)*10000000000)-1
				SET @SucursalMax = 9999999999
				end
			
			--[*]	
			--SET @SQLString = N'SELECT @max_id = max(id), @min_id =min(id)
			--FROM '+@tablaseek+' WHERE (id>=' +convert(varchar(12),@SucursalMin)+' and id<='+convert(varchar(12),@SucursalMax)+' )'
			--+' or ( id < '+convert(varchar(12),@SucursalMin)+') ';
			
			SET @SQLString = N'SELECT  @max_id = max(convert(int,right((convert(varchar('+@cTama+'),id)),'+@hasta+'))) FROM '+@tablaseek 
			SET @ParmDefinition = N' @max_id numeric(12,0) OUTPUT';

--			SET @SQLString = N'SELECT @max_id = max(id), @min_id =min(id)
--			FROM '+@tablaseek+' WHERE (convert(int,right(convert(varchar('+@cTama+'),id),'+convert(varchar(12),@Tama-2)+')) >= 1'
--			+' and convert(int,right(convert(varchar('+@cTama+'),id),'+convert(varchar(12),@Tama-2)+')) <='+convert(varchar(12),@SucursalMax)+' )'

--			SET @ParmDefinition = N' @max_id numeric(12,0) OUTPUT, @min_id numeric(12,0) OUTPUT';
			print @SQLString
			print @ParmDefinition 
			EXECUTE sp_executesql @SQLString, @ParmDefinition, @max_id = @IntVariable OUTPUT;
--			EXECUTE sp_executesql @SQLString, @ParmDefinition, @max_id = @IntVariable OUTPUT,	@min_id =@IntVariableMin OUTPUT;
			
			set @id = isnull(@IntVariable ,0)
			print @id
--------------			set @idmin = @IntVariableMin
--------------			
--------------			set @id =  isnull(@id,0000000000000)
--------------			set @idmin = isnull(@idmin,00000000000)
--------------			set @lcid = convert(varchar(15),@id)
--------------			--Si el tamaño de int =4 maximo de cadena es 10	sino 12
--------------			if @Tama = 10
--------------				begin
--------------				set @lcid = convert(varchar(10),@id)
--------------				end
--------------			else
--------------				begin
--------------				set @lcid = convert(varchar(12),@id)
--------------				end
--------------		--Extramemos del id la sucursal o no
--------------			set @nlenid= len(ltrim(rtrim(@lcid )))
--------------		
--------------			if @nlenid = @Tama
--------------			--Si el tamaño del campo es igual al maximo permitido entonces tiene la sucursal
--------------			--Ejemplo 11XXXXXXXX
--------------				set @lcid = substring(@lcid,3,len(@lcid))
--------------			else
--------------			--El campo no esta completo, eso quiere decir q NO tiene sucursal
--------------				set @lcid = @lcid
--------------			--end
--------------			if ltrim(@lcid)=''
--------------				set @id = 1
--------------			else
--------------				set @id = convert(numeric(12,0) ,@lcid)
		
		    --Insertamos en la tabla keysid el nuevo registro actualizado		
			INSERT INTO Keysid VALUES (@tablaseek, @id+1 , '' )         
   
			-- 'Actualizo'
			fetch CsrKeysid into @tablaseek,@campo
		end
	close CsrKeysid
	deallocate CsrKeysid
END
GO
/****** Object:  StoredProcedure [dbo].[NuevoIdsql]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[NuevoIdsql]
@Lcalias varchar(20),
@RetValor int OUTPUT,
@Valsuma int output  
AS
  SET NOCOUNT ON  
 set @retvalor=0 
 SELECT Name FROM SysObjects WHERE Name='KEYSID' AND Type='U' 
    IF @@ROWCOUNT < 1
       CREATE TABLE Keysid ( Tabla Char(20), RetValor Integer, ctipocomp char(3) )    
    SELECT Nextid FROM Keysid WHERE Tabla=@Lcalias    
 IF @@ROWCOUNT < 1    
    INSERT INTO Keysid VALUES (@Lcalias, 0, '' )            
   UPDATE Keysid          
          SET @RetValor = Nextid = NextId + @ValSuma WHERE Tabla=@Lcalias         
 RETURN
GO
/****** Object:  Table [dbo].[zmarcas]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zmarcas](
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[delogico] [bit] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[zmarcas].[delogico]' , @futureonly='futureonly'
GO
/****** Object:  Table [dbo].[zarticulo]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zarticulo](
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[seccion] [numeric](2, 0) NOT NULL,
	[marca] [numeric](4, 0) NOT NULL,
	[articulo] [numeric](5, 0) NOT NULL,
	[codigo_prv] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[codigo_emb] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[bonif1] [numeric](4, 2) NOT NULL,
	[preventa1] [numeric](11, 3) NOT NULL,
	[proveedor] [numeric](5, 0) NOT NULL,
	[cambio_pre] [bit] NOT NULL,
	[fechaulcpr] [datetime] NOT NULL,
	[fraccion] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[puntope] [numeric](9, 2) NOT NULL,
	[univenta] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[unibulto] [numeric](5, 0) NOT NULL,
	[tablaiva] [numeric](2, 0) NOT NULL,
	[peso] [numeric](11, 3) NOT NULL,
	[kilos] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sisabor] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[barras] [numeric](13, 0) NOT NULL,
	[interno] [numeric](11, 2) NOT NULL,
	[debaja] [bit] NOT NULL,
	[frio] [numeric](2, 0) NOT NULL,
	[secprv] [numeric](5, 0) NOT NULL,
	[costo] [numeric](11, 3) NOT NULL,
	[flete] [numeric](5, 3) NOT NULL,
	[bonifica] [numeric](4, 2) NOT NULL,
	[utilidad] [numeric](8, 3) NOT NULL,
	[util2] [numeric](8, 3) NOT NULL,
	[util3] [numeric](8, 3) NOT NULL,
	[preve2] [numeric](11, 3) NOT NULL,
	[preve3] [numeric](11, 3) NOT NULL,
	[preve4] [numeric](11, 3) NOT NULL,
	[bonies] [numeric](5, 2) NOT NULL,
	[bonies2] [numeric](5, 2) NOT NULL,
	[bonies3] [numeric](5, 2) NOT NULL,
	[minimo] [numeric](5, 0) NOT NULL,
	[minimo2] [numeric](5, 0) NOT NULL,
	[minimo3] [numeric](5, 0) NOT NULL,
	[bonif2] [numeric](4, 2) NOT NULL,
	[bonif3] [numeric](4, 2) NOT NULL,
	[bonif4] [numeric](4, 2) NOT NULL,
	[fechabon] [datetime] NOT NULL,
	[fechapre] [datetime] NOT NULL,
	[tasa] [numeric](8, 3) NOT NULL,
	[tasapata] [numeric](8, 3) NOT NULL,
	[ibdif] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[unicaja] [numeric](5, 0) NOT NULL,
	[litros] [numeric](8, 3) NOT NULL,
	[bajasto] [numeric](5, 0) NOT NULL,
	[envase] [char](5) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[sireparto] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[zarticulo].[cambio_pre]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[zarticulo].[debaja]' , @futureonly='futureonly'
GO
/****** Object:  Table [dbo].[zclientes]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[zclientes](
	[numero] [numeric](4, 0) NOT NULL,
	[nombre] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[direccion] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cp] [numeric](3, 0) NOT NULL,
	[localidad] [char](25) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[provincia] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipocuit] [numeric](1, 0) NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipo_pago] [numeric](1, 0) NOT NULL,
	[fechaulcpr] [datetime] NOT NULL,
	[fechaulpag] [datetime] NOT NULL,
	[bonif1] [numeric](2, 2) NOT NULL,
	[bonif2] [numeric](2, 2) NOT NULL,
	[bonif3] [numeric](2, 2) NOT NULL,
	[saldo] [numeric](11, 2) NOT NULL,
	[saldo_ant] [numeric](11, 2) NOT NULL,
	[saldoauto] [numeric](11, 2) NOT NULL,
	[telefono] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[depende] [numeric](3, 0) NOT NULL,
	[diasvto] [numeric](2, 0) NOT NULL,
	[vendedor] [numeric](2, 0) NOT NULL,
	[zona] [char](2) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[modem] [bit] NOT NULL,
	[borrado] [bit] NOT NULL,
	[leyenda] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[comision] [numeric](3, 2) NOT NULL,
	[deposito] [numeric](1, 0) NOT NULL,
	[lista] [numeric](1, 0) NOT NULL,
	[categoria] [numeric](2, 0) NOT NULL,
	[dias] [numeric](6, 0) NOT NULL,
	[codprv] [numeric](5, 0) NOT NULL,
	[sucprv] [numeric](3, 0) NOT NULL,
	[observa] [text] COLLATE Modern_Spanish_CI_AS NOT NULL,
	[observa2] [text] COLLATE Modern_Spanish_CI_AS NOT NULL,
	[noventa] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[vende2] [numeric](2, 0) NOT NULL,
	[saldo_a2] [numeric](11, 2) NOT NULL,
	[saldo2] [numeric](11, 2) NOT NULL,
	[siorden] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[debaja] [bit] NOT NULL,
	[barrio] [numeric](2, 0) NOT NULL,
	[cateibrn] [numeric](2, 0) NOT NULL,
	[ibrutos] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tnse] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[comodato] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[pibba] [char](1) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[convenio] [numeric](6, 4) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[zclientes].[modem]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[zclientes].[borrado]' , @futureonly='futureonly'
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[zclientes].[debaja]' , @futureonly='futureonly'
GO
/****** Object:  Table [dbo].[producto]    Script Date: 09/09/2021 13:50:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[producto](
	[id] [int] NOT NULL,
	[numero] [int] NOT NULL,
	[nombre] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[nombulto] [varchar](45) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[codalfa] [char](8) COLLATE Modern_Spanish_CI_AS NULL,
	[idctacte] [int] NOT NULL,
	[idmarca] [int] NOT NULL,
	[idctavta] [int] NOT NULL,
	[idctacpra] [int] NOT NULL,
	[idforma] [int] NOT NULL,
	[idunidad] [int] NOT NULL,
	[idtprod] [int] NOT NULL,
	[idtipovta] [int] NOT NULL,
	[idtamano] [int] NOT NULL,
	[idcatego] [int] NOT NULL,
	[idrubro] [int] NOT NULL,
	[idestado] [int] NOT NULL,
	[idubicacio] [int] NOT NULL,
	[idorigen] [int] NOT NULL,
	[nomodifica] [numeric](1, 0) NOT NULL,
	[incluirped] [numeric](1, 0) NOT NULL,
	[idiva] [int] NOT NULL,
	[idmoneda] [int] NOT NULL,
	[costo] [numeric](11, 3) NOT NULL,
	[flete] [numeric](11, 3) NOT NULL,
	[segflete] [numeric](11, 3) NOT NULL,
	[interno] [numeric](11, 3) NOT NULL,
	[bonif1] [numeric](6, 3) NOT NULL,
	[bonif2] [numeric](6, 3) NOT NULL,
	[bonif3] [numeric](6, 3) NOT NULL,
	[bonif4] [numeric](6, 3) NOT NULL,
	[costobon] [numeric](11, 3) NOT NULL,
	[costorepo] [numeric](11, 3) NOT NULL,
	[costoulcpra] [numeric](11, 3) NOT NULL,
	[feculcpra] [datetime] NOT NULL,
	[margen1] [numeric](6, 3) NOT NULL,
	[prevta1] [numeric](11, 3) NOT NULL,
	[prevtaf1] [numeric](11, 3) NOT NULL,
	[margen2] [numeric](6, 3) NOT NULL,
	[prevta2] [numeric](11, 3) NOT NULL,
	[prevtaf2] [numeric](11, 3) NOT NULL,
	[margen3] [numeric](6, 3) NOT NULL,
	[prevta3] [numeric](11, 3) NOT NULL,
	[prevtaf3] [numeric](11, 3) NOT NULL,
	[margen4] [numeric](6, 3) NOT NULL,
	[prevta4] [numeric](11, 3) NOT NULL,
	[prevtaf4] [numeric](11, 3) NOT NULL,
	[feculvta] [datetime] NOT NULL,
	[fecalta] [datetime] NOT NULL,
	[fecmodi] [datetime] NOT NULL,
	[unibulto] [numeric](4, 0) NOT NULL,
	[nofactura] [numeric](1, 0) NOT NULL,
	[nolista] [numeric](1, 0) NOT NULL,
	[espromocion] [numeric](1, 0) NOT NULL,
	[minimofac] [numeric](10, 0) NOT NULL,
	[peso] [numeric](7, 3) NOT NULL,
	[volumen] [numeric](7, 3) NOT NULL,
	[fracciona] [numeric](1, 0) NOT NULL,
	[puntope] [numeric](8, 0) NOT NULL,
	[switch] [char](10) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idenvase] [int] NOT NULL,
	[sugerido] [numeric](11, 3) NOT NULL,
	[idfrio] [int] NOT NULL,
	[idingbrutos] [int] NOT NULL,
	[divisible] [numeric](1, 0) NOT NULL,
	[desc1] [numeric](6, 3) NOT NULL,
	[desc2] [numeric](6, 3) NOT NULL,
	[desc3] [numeric](6, 3) NOT NULL,
	[min1] [numeric](10, 0) NOT NULL,
	[min2] [numeric](10, 0) NOT NULL,
	[min3] [numeric](10, 0) NOT NULL,
	[codartprod] [char](12) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[vtakilos] [numeric](1, 0) NOT NULL,
	[fecoferta] [datetime] NOT NULL,
	[internoporce] [numeric](9, 5) NOT NULL,
	[cprakilos] [numeric](1, 0) NOT NULL,
	[codbarra13] [char](13) COLLATE Modern_Spanish_CI_AS NULL,
	[codbarra14] [char](14) COLLATE Modern_Spanish_CI_AS NULL,
	[idctactesao] [int] NULL,
	[costoagre1] [numeric](11, 3) NULL CONSTRAINT [DF_producto_costoagre1_1]  DEFAULT ((0)),
	[costoagre2] [numeric](11, 3) NULL CONSTRAINT [DF_producto_costoagre2_1]  DEFAULT ((0)),
	[costoagre3] [numeric](11, 3) NULL CONSTRAINT [DF_producto_costoagre3_1]  DEFAULT ((0)),
	[costoagre4] [numeric](11, 3) NULL CONSTRAINT [DF_producto_costoagre4_1]  DEFAULT ((0)),
	[bloqueocdp] [numeric](1, 0) NULL CONSTRAINT [DF_producto_bloqueocdp]  DEFAULT ((0)),
	[bloqueosao] [numeric](1, 0) NULL CONSTRAINT [DF_producto_bloqueosao]  DEFAULT ((0)),
	[noexento567] [numeric](1, 0) NULL,
	[segstockcdp] [numeric](1, 0) NULL CONSTRAINT [DF_producto_segstock]  DEFAULT ((0)),
	[segstocksao] [numeric](1, 0) NULL CONSTRAINT [DF_producto_segstocksao]  DEFAULT ((0)),
 CONSTRAINT [PK_producto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_product1] UNIQUE NONCLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idrubro] ON [dbo].[producto] 
(
	[idrubro] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [nombre] ON [dbo].[producto] 
(
	[nombre] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[producto].[internoporce]' , @futureonly='futureonly'
GO
/****** Object:  Table [dbo].[ctacte]    Script Date: 09/09/2021 13:50:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ctacte](
	[id] [int] NOT NULL,
	[cnumero] [char](6) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cnombre] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cdireccion] [char](30) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[cpostal] [char](8) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idlocalidad] [int] NOT NULL,
	[idprovincia] [int] NOT NULL,
	[ctelefono] [char](20) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[email] [char](40) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[tipoiva] [int] NOT NULL,
	[cuit] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[idcategoria] [int] NOT NULL,
	[ctadeudor] [numeric](1, 0) NOT NULL,
	[ctaacreedor] [numeric](1, 0) NOT NULL,
	[ctalogistica] [numeric](1, 0) NOT NULL,
	[ctabanco] [numeric](1, 0) NOT NULL,
	[ctaotro] [numeric](1, 0) NOT NULL,
	[idplanpago] [int] NOT NULL,
	[idcanalvta] [int] NOT NULL,
	[fechalta] [datetime] NOT NULL,
	[observa] [text] COLLATE Modern_Spanish_CI_AS NOT NULL,
	[saldo] [numeric](10, 2) NOT NULL,
	[saldoant] [numeric](10, 2) NOT NULL,
	[estadocta] [numeric](1, 0) NOT NULL,
	[bonif1] [numeric](5, 3) NOT NULL,
	[bonif2] [numeric](5, 3) NOT NULL,
	[copiatkt] [numeric](2, 0) NOT NULL,
	[inscri01] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[fecins01] [datetime] NOT NULL,
	[inscri02] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[inscri03] [char](15) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[convenio] [numeric](6, 3) NOT NULL,
	[saldoauto] [numeric](10, 2) NOT NULL,
	[idbarrio] [int] NOT NULL,
	[lista] [int] NOT NULL,
	[idcateibrng] [int] NOT NULL,
	[ingbrutos] [char](13) COLLATE Modern_Spanish_CI_AS NOT NULL,
	[comision] [numeric](6, 3) NOT NULL,
	[fecultcompra] [datetime] NOT NULL,
	[fecultpago] [datetime] NOT NULL,
	[esrecodevol] [numeric](1, 0) NOT NULL,
	[totalizabonif] [numeric](1, 0) NOT NULL,
	[fechaafip] [datetime] NULL,
	[idsucursal] [int] NULL,
	[ctaresumen] [numeric](1, 0) NULL,
	[dni] [numeric](8, 0) NULL,
	[sere_codigo] [char](10) COLLATE Modern_Spanish_CI_AS NULL,
	[sere_sucursal] [char](10) COLLATE Modern_Spanish_CI_AS NULL,
	[sere_codpropio] [char](10) COLLATE Modern_Spanish_CI_AS NULL,
	[sere_sucpropio] [char](10) COLLATE Modern_Spanish_CI_AS NULL,
	[lat] [char](20) COLLATE Modern_Spanish_CI_AS NULL CONSTRAINT [DF_ctacte_lat]  DEFAULT ('0'),
	[lng] [char](20) COLLATE Modern_Spanish_CI_AS NULL CONSTRAINT [DF_ctacte_lng]  DEFAULT ('0'),
	[autodec567] [numeric](1, 0) NULL CONSTRAINT [DF_ctacte_autodec567]  DEFAULT ((0)),
 CONSTRAINT [PK_ctacte] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [UQ_ctact1] UNIQUE NONCLUSTERED 
(
	[cnumero] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [_all] ON [dbo].[ctacte] 
(
	[id] ASC,
	[cnumero] ASC,
	[cnombre] ASC,
	[cdireccion] ASC,
	[cpostal] ASC,
	[ctadeudor] ASC,
	[ctaacreedor] ASC,
	[ctalogistica] ASC,
	[ctabanco] ASC,
	[ctaotro] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [cnombre] ON [dbo].[ctacte] 
(
	[cnombre] ASC,
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ctaacreedo] ON [dbo].[ctacte] 
(
	[ctaacreedor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ctabanco] ON [dbo].[ctacte] 
(
	[ctabanco] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ctadeudor] ON [dbo].[ctacte] 
(
	[ctadeudor] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ctalogisti] ON [dbo].[ctacte] 
(
	[ctalogistica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [estadocta] ON [dbo].[ctacte] 
(
	[estadocta] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
EXEC sys.sp_bindefault @defname=N'[dbo].[UW_ZeroDefault]', @objname=N'[dbo].[ctacte].[esrecodevol]' , @futureonly='futureonly'
GO
/****** Object:  Trigger [tr_verificar_renumeracion_asientos]    Script Date: 09/09/2021 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Gabriel Guerrero>
-- Create date: <22-03-2010>
-- Description:	<Verifica si hay que renumerar asientos y marca el flag correspondiente>
-- Modificado : <30-04-2010 Marcos V. Sacamos el id del NuevoidSql>
-- =============================================
CREATE TRIGGER [dbo].[tr_verificar_renumeracion_asientos] ON [dbo].[cabeasi] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @Pestado int
	Declare @id int
	select @Pestado = p.estado from paravario p where nombre='RENUASI'
	IF @@ROWCOUNT < 1   
	Begin		
		--select @ID = isnull(max(p.id),0) from paravario p 
		--insert into paravario (id,nombre,estado,idorigen,importe,porce,detalle,fecha) 
		--values (@id+1,'RENUASI',0,0,0,0,'FLAG ASIENTOS BALANCEADOS',getdate())
		DECLARE @Tabla varchar(50);
		DECLARE @Incremento int;
		SET @Tabla = 'PARAVARIO'
		SET @Incremento = 1
		SET @Id = 0
		EXECUTE NuevoIdSQL @Tabla,  @Id output ,@Incremento
		insert into paravario (id,nombre,estado,idorigen,importe,porce,detalle,fecha) 
		values (@id,'RENUASI',0,0,0,0,'FLAG ASIENTOS BALANCEADOS',getdate())
		set @Pestado=0
	End
	if @Pestado=0
	Begin
		Declare CursorAsientos Cursor For
		select i.fecha from inserted i 
		Open CursorAsientos
		-- DECLARAR VARIABLES
		
		Declare @fecha datetime
		Declare @hay int

		-- RECORRER EL CURSOR
		Fetch Next From CursorAsientos
		Into @fecha
		-- Miramos que la instrucción FETCH se ejecutó correctamente.

		while @@FETCH_STATUS = 0
		Begin		
			-- Verificar si hay una fecha superior		
			select @hay = count(c.id) from cabeasi C where c.fecha>@fecha
			if @hay <>0
			begin           
				UPDATE paravario set estado=1 where nombre='RENUASI'
			end

			-- Recuperamos la siguiente fila
			Fetch Next From CursorAsientos
			Into @fecha
					
		End 

		-- Cerramos el cursor
		Close CursorAsientos

		-- Quita la referencia al cursor y el SQL Server libera la
		-- estructura de datos ocupada por el cursor.
		Deallocate CursorAsientos

	End

END
GO
