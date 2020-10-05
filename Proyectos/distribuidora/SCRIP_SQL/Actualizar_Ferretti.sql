use ferretti
go

-- Vendedor
--	passpreventamobile n(5)
--	activopm n(1)
-- Tabla Anulaciones.sql 
-- Cabefac
--	listaprecio n(2) update
--	nropatron c(15)
--  cotidolar n(11,2)
--  iddeposito delete
--  idareaneg delete
-- CateCtacte
--	secreenergia	numeric(1, 0)	delete
--	consumoint	numeric(1, 0)	delete
--	bonif1	numeric(9, 5)	Checked
--	remito	numeric(1, 0)	Checked
--	fechabonif	datetime	Checked
--	infonobleza	numeric(1, 0)	Checked
--CuerVariOrd
--	cantidad	numeric(11, 2)	Update
--CuerVari
--	cantidad	numeric(11, 2)	Unchecked Update
--	bonisiva	numeric(11, 3)	Checked Update
--	boniciva	numeric(11, 3)	Checked Update
--Conexion
--	pwdlen	numeric(2, 0)	Checked
--	userlen	numeric(2, 0)	Checked
--	idservpedido	char(10)	Checked
--	servpedido	numeric(1, 0)	Checked
--	cantvdorpm	numeric(3, 0)	Checked
--	passpedido	char(50)	Checked
--Marca
--	flete	numeric(6, 3)	Unchecked Update
--	flete2	numeric(6, 3)	Unchecked Update
--Categoiva
--	agrupaafip	char(1)	Checked
--	numero	agrupafip
--	1	M
--	3	C
--	4	C
--	5	M
--	7	C
--Ganancias.sql
--Empresa
--	retegan	numeric(1, 0)	Checked
--MovCtacte
--	totalcuota	int	Unchecked Delete
--	diasprom	int	Unchecked Delete
--	rendida	numeric(1, 0)	Checked
--	idrepartidor	int	Checked
--Provincia
--	LetraCPostal	char(1)	Checked
--	CodConvMult	char(3)	Checked
--	CodSicore	char(2)	Checked

--Id          LetraCpostal CodConvMult CodSicore
------------- ------------ ----------- ---------
--1100000001  C            901         00
--1100000002  B            902         01
--1100000003  K            903         02
--1100000004  U            907         17
--1100000005  E            908         05
--1100000006  X            904         03
--1100000007  W            905         04
--1100000008  H            906         16
--1100000009  P            909         18
--1100000010  L            911         21
--1100000011  F            912         08
--1100000012  M            913         07
--1100000013  J            918         10
--1100000014  D            919         11
--1100000015  Y            910         06
--1100000016  Z            920         23
--1100000017  S            921         12
--1100000018  G            922         13
--1100000019  T            924         14
--1100000020  Q            915         20
--1100000021  N            914         19
--1100000022  R            916         22
--1100000023  A            917         09
--1100000024  V            923         24
--MovCheque.sql
--ProdCodBarra.sql
--MapeoImpresora.sql
--Combo.sql
--Cuerfac
--	importado	numeric(1, 0)	Unchecked delete
--	uniboni	numeric(11, 3)	Checked delete
--	unibonisiva	numeric(11, 3)	Checked delete
--	unibonikilo	numeric(11, 3)	Checked delete
--	unibonikilosiva	numeric(11, 3)	Checked delete

--  listaprecio	numeric(2, 0)	Unchecked Update
--	totalsiva	numeric(11, 3)	Checked
--	totalciva	numeric(11, 3)	Checked
--	endolar	numeric(1, 0)	Checked
--	escombo	numeric(1, 0)	Checked
--	idprodcombo	int	Checked
--Movstock
--	existereal	numeric(9, 2)	Checked
--	existedisp	numeric(9, 2)	Checked
--Ctacte
--	internobonif	numeric(1, 0)	Checked
--	fechaafip	datetime	Checked
--	cdatosfac	char(30)	Checked
--	ctaresumen	numeric(1, 0)	Checked
--	dni	char(10)	Checked
--	ordenrep	int	Checked
--	autodec567	numeric(1, 0)	Checked

--AfipComproba
--	clasecomp c(2) update
--update afipcomproba set clasecomp=rtrim(ltrim(clasecomp))+'0'

--Clasecomp
--	tipo c(2)
--update clasecomp set tipo='00'

--Comprobante
--	clasetipo c(2)
--update comprobante set clasetipo='00'

--Rubro
--	saltopag	numeric(1, 0)	Checked
--	esexhibidor	numeric(1, 0)	Checked
--	bonif1	numeric(9, 2)	Checked
--	fechabonif	datetime	Checked
--	omitirlistas	numeric(1, 0)	Checked
--	switch	char(5)	Checked
--	codarba	char(6)	Checked
--	cfexentoiva	numeric(1, 0)	Checked
--	unitasa	numeric(1, 0)	Checked

--Plancue
--	switch	char(5)	Checked
--	ajusteinflacion	numeric(1, 0)	Checked

--InfoContab.sql

--ExtMaopera
--	Renombrar emaopera a extmaopera
--	oblealp delete
--	idactividad delete

--MovPub
--	idmovpub_old n(12)
--movpub_temp.sql

--Localidad
--	codarba n(8)
--	orden n(1)
--update localidad set codarba=0,orden=1

--Cbioprecio
	--bonif1v	numeric(5, 3)	Checked
	--bonif1n	numeric(5, 3)	Checked
	--bonif2v	numeric(5, 3)	Checked
	--bonif2n	numeric(5, 3)	Checked
	--bonif3v	numeric(5, 3)	Checked
	--bonif3n	numeric(5, 3)	Checked
	--bonif4v	numeric(5, 3)	Checked
	--bonif4n	numeric(5, 3)	Checked
	--costobonv	numeric(10, 3)	Checked
	--costobonn	numeric(10, 3)	Checked
	--fletev	numeric(10, 3)	Checked
	--fleten	numeric(10, 3)	Checked
	--segfletev	numeric(10, 3)	Checked
	--segfleten	numeric(10, 3)	Checked
	--internoporcev	numeric(10, 3)	Checked
	--internoporcen	numeric(10, 3)	Checked
	--tasav	numeric(4, 2)	Checked
	--tasan	numeric(4, 2)	Checked
	--endolarv	numeric(1, 0)	Checked
	--endolarn	numeric(1, 0)	Checked
	--cotidolar	numeric(11, 3)	Checked
	--idctacte	int	Checked
	--programa	nchar(30)	Checked
	--fleteporcev	numeric(11, 3)	Checked
	--fleteporcen	numeric(11, 3)	Checked


/****** Object:  Table [dbo].[bonirubro]    Script Date: 23/9/2020 19:54:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--CREATE TABLE [dbo].[bonirubro](
--	[id] [int] NOT NULL,
--	[idctacte] [int] NOT NULL,
--	[idrubro] [int] NOT NULL,
--	[bonifica] [numeric](6, 2) NOT NULL,
--	[fecha] [datetime] NOT NULL,
-- CONSTRAINT [PK_bonirubro] PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]


--CREATE TABLE [dbo].[MovLicita](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idctacte] [int] NOT NULL,
--	[idarticulo] [int] NOT NULL,
--	[idvariedad] [int] NOT NULL,
--	[cantidad] [numeric](9, 2) NOT NULL,
--	[sdocant] [numeric](9, 2) NOT NULL,
--	[preunita] [numeric](11, 3) NOT NULL,
--	[preunitasiva] [numeric](11, 3) NOT NULL,
--	[tasaiva] [numeric](6, 3) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[nrolicitacion] [char](15) NOT NULL,
-- CONSTRAINT [PK_MovLicita] PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--CREATE TABLE [dbo].[afelicita](
--	[id] [numeric](12, 0) NOT NULL,
--	[origen] [char](3) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idmovlicita] [numeric](12, 0) NOT NULL,
--	[idcuermaope] [numeric](12, 0) NOT NULL,
--	[idcuerfac] [numeric](12, 0) NOT NULL,
--	[afecta] [numeric](9, 2) NOT NULL,
-- CONSTRAINT [PK_afelicita] PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

--CREATE TABLE [dbo].[afecabecpra](
--	[id] [numeric](12, 0) NOT NULL,
--	[idorigen] [numeric](12, 0) NOT NULL,
--	[idmaoperao] [numeric](12, 0) NOT NULL,
--	[idafecta] [numeric](12, 0) NOT NULL,
--	[idmaoperaa] [numeric](12, 0) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[nrolote] [numeric](12, 0) NULL,
-- CONSTRAINT [PK_afecabecpra] PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]


SET ANSI_PADDING OFF
GO


