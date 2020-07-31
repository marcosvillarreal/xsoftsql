use urquiza
go
--select '20062525' as CodDistri,CsrCtacte.cnumero as CodCliente
--,CsrCtacte.cuit,CsrCtacte.cnombre as NomCliente
--,CsrCtacte.cdireccion as DireCliente
--,CsrCtacte.cpostal,CsrLocalidad.nombre as NomLocalidad
--,convert(char(8),CsrCtacte.fechalta,112) as FecAlta
--,convert(char(8),CsrCtacte.fechalta,12) as FecAlta
--,CsrCtacte.email
--,isnull(CsrVendedor.numero,15) as CodVendedor
--,isnull(CsrVendedor.nombre,'DISTRIBUIDORA') as NomVendedor
--,isnull(CsrRuta.numero,0) as CodRuta
--,isnull(CsrRuta.nombre,'SIN RUTA') AS NomRuta
--From Ctacte as CsrCtacte
--Left Join Localidad as CsrLocalidad on CsrCtacte.idlocalidad = CsrLocalidad.id
--Left Join CuerRuta as CsrCuerRuta on CsrCtacte.id = CsrCuerRuta.idctacte
--Left Join CabeRuta as CsrCabeRuta on CsrCuerRuta.idcaberuta = CsrCabeRuta.id
--Left Join rutavdor as CsrRutaVdor on CsrCabeRuta.idrutavdor = CsrRutaVdor.id
--Left Join vendedor as CsrVendedor on CsrRutaVdor.idvendedor = CsrVendedor.id
--lEFT Join ruta as CsrRuta on CsrRutaVdor.idruta = CsrRuta.id
--Where CsrCtacte.ctadeudor = 1 and CsrCtacte.estadocta=0

go

--select '20062525' as CodDistri,CsrProducto.codartprod as CodProducto
--,isnull(CsrExistencia.existe,0) as cantidad,'EA' as univta,CsrProducto.costo
--,CsrProducto.prevta1

--From Producto as CsrProducto
--Left Join Existenc as CsrExistencia on CsrProducto.id = CsrExistencia.idarticulo 

--Where CsrProducto.idctacte IN (1100001943) and CsrExistencia.iddeposito = 1100000001


--select '20062525' as CodDistri,CsrCtacte.cnumero as CodCliente
--,CsrMaopera.clasecomp,convert(char(8),CsrCabefac.fecha,112) as FecComp
--,CsrProducto.codartprod as CodProducto,CsrProducto.unibulto
--,'EA' as UniVta,CsrCuerfac.totalsiva as Total,CsrCuerfac.preunitasiva as Preunita
--,CsrCuerfac.cantidad
--From Maopera as CsrMaopera
--Inner Join Cabefac as CsrCabefac on CsrMaopera.id = CsrCabefac.idmaopera
--Left Join Ctacte as CsrCtacte on CsrCabefac.idctacte = CsrCtacte.id
--Left Join Cuerfac as CsrCuerfac on CsrCabefac.id = CsrCuerfac.idcabeza and CsrCabefac.idmaopera = CsrCuerfac.idmaopera
--Left Join Producto as CsrProducto on CsrCuerfac.idarticulo = CsrProducto.id

--Where CsrMaopera.estado=0 and CsrMaopera.clasecomp in ('A','B','C')
--and CsrMaopera.numcomp <> '' and (CsrCabefac.fecha between '20180101' and '20180131')
--and CsrProducto.idctacte IN (1100001943)
--Order By CodCliente,CsrCabefac.fecha,CodProducto

