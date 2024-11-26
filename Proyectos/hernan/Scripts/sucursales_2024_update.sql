use mildelicias_alsina
--script de actualizacion

--Definir los valores por sucursal
--Cambiar clientes a contado efecivo
--Parametros geerales, poder cambiar plan de pago
--Plan de Pago, valor de efectivo

--update paraconfig set idejercicio = 1100000024 where idejercicio = 1600000025
--update detanrocaja set idejercicio = 1100000024 where idejercicio = 1600000025
--update rubroctacon set idejercicio = 1100000024 where idejercicio = 1600000025
--update valorctacon set idejercicio = 1100000024 where idejercicio = 1600000025
--update plancue set idejercicio = 1100000024 where idejercicio = 1600000025
--update detaconta set id = 1100000024 where ejercicio = 14

--update paraconta set idcuenta = 1100017759 where idejercicio = 1600000025 and numero = 30
--update paraconta set idcuenta = 1100017764 where idejercicio = 1600000025 and numero in (1,22)
--update paraconta set idcuenta = 1100017783 where idejercicio = 1600000025 and numero in (2,33)
--update paraconta set idcuenta = 1100017787 where idejercicio = 1600000025 and numero in (13,14)
--update paraconta set idcuenta = 1100017818 where idejercicio = 1600000025 and numero in (3)
--update paraconta set idcuenta = 1100017819 where idejercicio = 1600000025 and numero in (34)
--update paraconta set idcuenta = 1100017821 where idejercicio = 1600000025 and numero in (35)
--update paraconta set idcuenta = 1100017822 where idejercicio = 1600000025 and numero in (7)
--update paraconta set idcuenta = 1100017827 where idejercicio = 1600000025 and numero in (4,5,26)
--update paraconta set idcuenta = 1100017841 where idejercicio = 1600000025 and numero in (31)
--update paraconta set idcuenta = 1100017845 where idejercicio = 1600000025 and numero in (15)
--update paraconta set idcuenta = 1100017848 where idejercicio = 1600000025 and numero in (16)
--update paraconta set idcuenta = 1100018016 where idejercicio = 1600000025 and numero in (18,19,21,24)
--update paraconta set idcuenta = 1100018017 where idejercicio = 1600000025 and numero in (20,23)
--update paraconta set idejercicio = 1100000024 where idejercicio = 1600000025 

--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[movturno](
--	[id] [int] NOT NULL,
--	[iddetanrocaja] [int] NOT NULL,
--	[turno] [numeric](2, 0) NOT NULL,
--	[importe] [numeric](14, 2) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[signo] [numeric](1, 0) NOT NULL,
--	[fecupdate] [datetime] NULL,
--	[sucursal] [numeric](3, 0) NULL,
--	[sector] [numeric](2, 0) NULL,
--	[idareaneg] [int] NULL,
-- CONSTRAINT [PK_movturno] PRIMARY KEY CLUSTERED 
--(
--	[id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[movturno] ADD  CONSTRAINT [DF_movturno_fecupdate]  DEFAULT (getdate()) FOR [fecupdate]
--GO

--ALTER TABLE [dbo].[movturno] ADD  CONSTRAINT [DF_movturno_idareaneg]  DEFAULT ((0)) FOR [idareaneg]
--GO

--CREATE TABLE [dbo].[formsclave](
--	[form] [char](40) NULL,
--	[estado] [numeric](1, 0) NULL,
--	[clave] [char](10) NULL
--) ON [PRIMARY]
--GO

--insert into formsclave values ('regfacpub_del_afip',0,'hg')


--CREATE TABLE [dbo].[ancabefac](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idctacte] [int] NOT NULL,
--	[ctacte] [char](6) NOT NULL,
--	[cnombre] [char](35) NOT NULL,
--	[cdireccion] [char](30) NOT NULL,
--	[ctelefono] [char](15) NOT NULL,
--	[cpostal] [char](8) NOT NULL,
--	[idlocalidad] [int] NOT NULL,
--	[idprovincia] [int] NOT NULL,
--	[idtipoiva] [int] NOT NULL,
--	[cuit] [char](13) NOT NULL,
--	[idsubcta] [int] NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[idplanpago] [int] NOT NULL,
--	[total] [numeric](11, 2) NOT NULL,
--	[bonif1] [numeric](6, 3) NOT NULL,
--	[bonif2] [numeric](6, 3) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[listaprecio] [numeric](1, 0) NOT NULL,
--	[idfletero] [int] NOT NULL,
--	[idfuerzavta] [int] NOT NULL,
--	[idrutavdor] [int] NOT NULL,
--	[idcategoria] [int] NOT NULL,
--	[hojaactual] [int] NOT NULL,
--	[hojatotal] [int] NOT NULL,
--	[idlotemaopera] [numeric](12, 0) NOT NULL,
--	[signo] [numeric](2, 0) NOT NULL,
--	[idfrio] [int] NOT NULL,
--	[tasamuni] [numeric](1, 0) NOT NULL,
--	[diferida] [numeric](1, 0) NOT NULL,
--	[idtiponcredito] [int] NOT NULL,
--	[rendida] [numeric](1, 0) NOT NULL,
--	[iddeposito] [int] NOT NULL,
--	[idareaneg] [int] NOT NULL,
--	[facturado] [numeric](1, 0) NULL,
--	[dni] [char](10) NULL,
--	[infoafip] [numeric](1, 0) NULL,
--	[infocae] [numeric](1, 0) NULL,
--	[cae] [char](14) NULL,
--	[talonario] [numeric](4, 0) NULL,
--	[idtipocbte] [int] NULL,
--	[vtocae] [datetime] NULL,
--	[caetipo] [char](4) NULL,
--	[fechafacest] [datetime] NULL,
-- )
--GO

--CREATE TABLE [dbo].[ancuerfac](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idcabeza] [numeric](12, 0) NOT NULL,
--	[idarticulo] [int] NOT NULL,
--	[codigo] [char](8) NOT NULL,
--	[nombre] [varchar](40) NOT NULL,
--	[cantidad] [numeric](9, 2) NOT NULL,
--	[univenta] [numeric](1, 0) NOT NULL,
--	[unibulto] [int] NOT NULL,
--	[oricod] [char](1) NOT NULL,
--	[sdocant] [numeric](9, 2) NOT NULL,
--	[kilos] [numeric](9, 3) NOT NULL,
--	[volumen] [numeric](9, 3) NOT NULL,
--	[listaprecio] [numeric](1, 0) NOT NULL,
--	[precosto] [numeric](11, 3) NOT NULL,
--	[precostosiva] [numeric](11, 3) NOT NULL,
--	[preunita] [numeric](11, 3) NOT NULL,
--	[preunitasiva] [numeric](11, 3) NOT NULL,
--	[prearti] [numeric](11, 3) NOT NULL,
--	[preartisiva] [numeric](11, 3) NOT NULL,
--	[interno] [numeric](11, 3) NOT NULL,
--	[despor] [numeric](6, 3) NOT NULL,
--	[tasaiva] [numeric](6, 3) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[iddeposito] [int] NOT NULL,
--	[espromocion] [numeric](1, 0) NOT NULL,
--	[perceibruto] [numeric](1, 0) NOT NULL,
--	[escambio] [numeric](1, 0) NOT NULL,
--	[oferfecha] [datetime] NOT NULL,
--	[oferbonif] [numeric](6, 3) NOT NULL,
--	[oferbonifcant] [numeric](11, 3) NOT NULL,
--	[idfrio] [int] NOT NULL,
--	[pesable] [numeric](1, 0) NOT NULL,
--	[importado] [numeric](1, 0) NOT NULL,
--	[boniciva] [numeric](14, 8) NOT NULL,
--	[bonisiva] [numeric](14, 8) NOT NULL,
--	[uniboni] [numeric](11, 3) NULL,
--	[unibonisiva] [numeric](11, 3) NULL,
--	[unibonikilo] [numeric](11, 3) NULL,
--	[unibonikilosiva] [numeric](11, 3) NULL,
--	[totalciva] [numeric](11, 3) NULL,
--	[totalsiva] [numeric](11, 3) NULL,
--	[perceiva5329] [numeric](1, 0) NULL,
--)



--CREATE TABLE [dbo].[anmovctacte](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[ctacte] [char](6) NOT NULL,
--	[idctacte] [int] NOT NULL,
--	[subnumero] [char](3) NOT NULL,
--	[idsubcta] [int] NOT NULL,
--	[cuota] [numeric](2, 0) NOT NULL,
--	[importe] [numeric](11, 2) NOT NULL,
--	[saldo] [numeric](11, 2) NOT NULL,
--	[entrega] [numeric](11, 2) NOT NULL,
--	[vencimien] [datetime] NOT NULL,
--	[total] [numeric](11, 2) NOT NULL,
--	[detalle] [varchar](30) NOT NULL,
--	[pefiscal] [char](6) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[signo] [numeric](2, 0) NOT NULL,
--	[totalcuota] [int] NOT NULL,
--	[diasprom] [int] NOT NULL,
-- )



--CREATE TABLE [dbo].[ancuervari](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idcuerfac] [numeric](12, 0) NOT NULL,
--	[idarticulo] [int] NOT NULL,
--	[idsubarti] [int] NOT NULL,
--	[idvariedad] [int] NOT NULL,
--	[cantidad] [numeric](6, 2) NOT NULL,
--	[kilos] [numeric](9, 3) NOT NULL,
--	[volumen] [numeric](9, 3) NOT NULL,
-- )



--CREATE TABLE [dbo].[ancabeasi](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idejercicio] [int] NOT NULL,
--	[numero] [numeric](12, 0) NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[tipoasi] [char](1) NOT NULL,
--	[detalle] [char](40) NOT NULL,
--	[fechacarga] [datetime] NOT NULL,
--	[estado] [numeric](1, 0) NULL,
--	[switch] [char](5) NULL,
--)


--CREATE TABLE [dbo].[antablaimp](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idorigen] [numeric](12, 0) NOT NULL,
--	[tablaori] [char](4) NOT NULL,
--	[idasiento] [numeric](12, 0) NOT NULL,
--	[idcuenta] [int] NOT NULL,
--	[tipoconce] [char](2) NOT NULL,
--	[importe] [numeric](11, 3) NOT NULL,
--	[tasa] [numeric](9, 6) NOT NULL,
--	[baseimp] [numeric](11, 3) NOT NULL,
--	[nombre] [char](10) NOT NULL,
--	[detalle] [varchar](30) NOT NULL,
--	[idprovincia] [int] NOT NULL,
-- )
--GO


--CREATE TABLE [dbo].[anmovbcocar](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[origen] [char](3) NOT NULL,
--	[importe] [numeric](11, 2) NOT NULL,
--	[idtipomov] [int] NOT NULL,
--	[numero] [numeric](10, 0) NOT NULL,
--	[idctabco] [int] NOT NULL,
--	[banco] [varchar](25) NOT NULL,
--	[localidad] [varchar](25) NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[fechavto] [datetime] NOT NULL,
--	[cuit] [char](13) NOT NULL,
--	[titular] [varchar](25) NOT NULL,
--	[recibido] [varchar](25) NOT NULL,
--	[entregado] [varchar](25) NOT NULL,
--	[detalle] [varchar](30) NOT NULL,
--	[signo] [numeric](2, 0) NOT NULL,
--	[switch] [char](5) NOT NULL,
--)
--GO

--CREATE TABLE [dbo].[anmovcaja](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idorigen] [numeric](12, 0) NOT NULL,
--	[tablaori] [char](4) NOT NULL,
--	[clase] [char](1) NOT NULL,
--	[importe] [numeric](11, 2) NOT NULL,
--	[detalle] [varchar](30) NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[idvalor] [int] NOT NULL,
-- )
--GO


--CREATE TABLE [dbo].[anmovstock](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idorigen] [numeric](12, 0) NOT NULL,
--	[idarticulo] [int] NOT NULL,
--	[idsubarti] [int] NOT NULL,
--	[codigo] [char](8) NOT NULL,
--	[fecha] [datetime] NOT NULL,
--	[iddeposito] [int] NOT NULL,
--	[cantidad] [numeric](9, 2) NOT NULL,
--	[kilos] [numeric](9, 3) NOT NULL,
--	[volumen] [numeric](9, 3) NOT NULL,
--	[importe] [numeric](11, 3) NOT NULL,
--	[switch] [char](5) NOT NULL,
--	[signo] [numeric](2, 0) NOT NULL,
-- )
--GO

--CREATE TABLE [dbo].[antablaasi](
--	[id] [numeric](12, 0) NOT NULL,
--	[idmaopera] [numeric](12, 0) NOT NULL,
--	[idorigen] [numeric](12, 0) NOT NULL,
--	[tablaori] [char](4) NOT NULL,
--	[idcuenta] [int] NOT NULL,
--	[tipoconce] [char](2) NOT NULL,
--	[debehaber] [char](1) NOT NULL,
--	[importe] [numeric](11, 2) NOT NULL,
--	[detalle] [varchar](40) NOT NULL
--) 
--GO

