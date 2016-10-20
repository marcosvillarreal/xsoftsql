use leon
go
SELECT STR(Csrproducto.numero) as codigo,ISNULL(csrproducto.nombre,SPACE(30)) as articulo
,isnull(CsrFletero.numero,cast(0 as int))as codfletero,isnull(CsrFletero.nombre,SPACE(30)) as nomfletero
,isnull(CsrVendedor.numero,cast(0 as int))as CodVendedor,isnull(CsrVendedor.nombre,SPACE(30)) as nomvendedor
,isnull(CsrCtacte.cnumero,SPACE(6)) as ctacte,isnull(CsrCtacte.cnombre,SPACE(30)) as nomcliente
,isnull(CsrCategoria.nombre,space(15)) as categoria,isnull(CsrCategoiva.abrevia,space(4)) as tipoiva
,ISNULL(Csrrubro.numero,CAST(0 as numeric(4,0))) as Codrubro,ISNULL(Csrrubro.nombre,SPACE(30)) as nomrubro
,isnull((select sum(cast(CsrCuerpo.cantidad/CsrCuerpo.unibulto*CsrCabeza.signo as numeric(15,2))) from Cabefac as CsrCabeza
	left join cuerfac as CsrCuerpo on CsrCabeza.id = CsrCuerpo.idcabeza and CsrCabeza.idmaopera = CsrCuerpo.idmaopera
	left join maopera as CsrOpera on CsrCabeza.idmaopera = CsrOpera.id
	where CsrOpera.origen IN ('FAC','FPE') and  not (CsrOpera.clasecomp in ('K')) and CsrOpera.estado<>'1'
	and CsrOpera.idcomproba in(1,2,3,27,28,29,31,1100000062) 
	and Csrcabeza.fecha >= '20110901' AND Csrcabeza.fecha < '20111001'
	and CsrCuerfac.idarticulo = CsrCuerpo.idarticulo),cast(0 as numeric(12,3))) as UniPer02
,isnull((select sum(cast(CsrCuerpo.cantidad/CsrCuerpo.unibulto*CsrCabeza.signo as numeric(15,2))) from Cabefac as CsrCabeza
	left join cuerfac as CsrCuerpo on CsrCabeza.id = CsrCuerpo.idcabeza and CsrCabeza.idmaopera = CsrCuerpo.idmaopera
	left join maopera as CsrOpera on CsrCabeza.idmaopera = CsrOpera.id
	where CsrOpera.origen IN ('FAC','FPE') and  not (CsrOpera.clasecomp in ('K')) and CsrOpera.estado<>'1'
	and CsrOpera.idcomproba in(1,2,3,27,28,29,31,1100000062) 
	and Csrcabeza.fecha >= '20110801' AND Csrcabeza.fecha < '20110901'
	and CsrCuerfac.idarticulo = CsrCuerpo.idarticulo),cast(0 as numeric(12,3))) as UniPer01
,isnull((select SUM((case when CsrCuerpo.pesable = 1 
				then (CAST(Csrcuerpo.kilos *  CsrCabeza.signo  as numeric(18,2))) 
				else (CAST(Csrarticulo.peso * Csrcuerpo.cantidad *  CsrCabeza.signo  as numeric(18,2)))
		end)) from Cabefac as CsrCabeza
	left join cuerfac as CsrCuerpo on CsrCabeza.id = CsrCuerpo.idcabeza and CsrCabeza.idmaopera = CsrCuerpo.idmaopera
	left join maopera as CsrOpera on CsrCabeza.idmaopera = CsrOpera.id
	left join producto as Csrarticulo on Csrcuerpo.idarticulo = Csrarticulo.id
	where CsrOpera.origen IN ('FAC','FPE') and  not (CsrOpera.clasecomp in ('K')) and CsrOpera.estado<>'1'
	and CsrOpera.idcomproba in(1,2,3,27,28,29,31,1100000062) 
	and Csrcabeza.fecha >= '20110801' AND Csrcabeza.fecha < '20110901'
	and CsrCuerfac.idarticulo = CsrCuerpo.idarticulo
	),CAST(0  as numeric(18,2))) as KilosPer01
,isnull((select SUM((case when CsrCuerpo.pesable = 1 
				then (CAST(Csrcuerpo.kilos *  CsrCabeza.signo  as numeric(18,2))) 
				else (CAST(Csrarticulo.peso * Csrcuerpo.cantidad *  CsrCabeza.signo  as numeric(18,2)))
		end)) from Cabefac as CsrCabeza
	left join cuerfac as CsrCuerpo on CsrCabeza.id = CsrCuerpo.idcabeza and CsrCabeza.idmaopera = CsrCuerpo.idmaopera
	left join maopera as CsrOpera on CsrCabeza.idmaopera = CsrOpera.id
	left join producto as Csrarticulo on Csrcuerpo.idarticulo = Csrarticulo.id
	where CsrOpera.origen IN ('FAC','FPE') and  not (CsrOpera.clasecomp in ('K')) and CsrOpera.estado<>'1'
	and CsrOpera.idcomproba in(1,2,3,27,28,29,31,1100000062) 
	and Csrcabeza.fecha >= '20110901' AND Csrcabeza.fecha < '20111001'
	and CsrCuerfac.idarticulo = CsrCuerpo.idarticulo
	),CAST(0  as numeric(18,2))) as KilosPer02
,isnull((select SUM((case when Csrcuerpo.pesable = 1 
			then CAST(round(((CsrCuerpo.preunitasiva)* Csrcuerpo.kilos -Csrcuerpo.bonisiva)*  CsrCabeza.signo,3)  as numeric(18,2))
			else ((case when Csrcuerpo.Univenta=1 or csrcuerpo.unibulto=1 
				then CAST(ROUND(((CsrCuerpo.preunitasiva) * Csrcuerpo.cantidad -Csrcuerpo.bonisiva)*  CsrCabeza.signo ,3) as numeric(18,2)) 
				else CAST(round((ROUND(((CsrCuerpo.preunitasiva) * csrcuerpo.unibulto),2) * (Csrcuerpo.cantidad/Csrcuerpo.unibulto) -Csrcuerpo.bonisiva)*  CsrCabeza.signo,3)  as numeric(18,2)) 
			end)) end)) from Cabefac as CsrCabeza
	left join cuerfac as CsrCuerpo on CsrCabeza.id = CsrCuerpo.idcabeza and CsrCabeza.idmaopera = CsrCuerpo.idmaopera
	left join maopera as CsrOpera on CsrCabeza.idmaopera = CsrOpera.id
	left join producto as Csrarticulo on Csrcuerpo.idarticulo = Csrarticulo.id
	where CsrOpera.origen IN ('FAC','FPE') and  not (CsrOpera.clasecomp in ('K')) and CsrOpera.estado<>'1'
	and CsrOpera.idcomproba in(1,2,3,27,28,29,31,1100000062) 
	and Csrcabeza.fecha >= '20110801' AND Csrcabeza.fecha < '20110901'
	and CsrCuerfac.idarticulo = CsrCuerpo.idarticulo
	),CAST(0  as numeric(18,2))) as NetoGravadoPer01
,isnull((select SUM((case when Csrcuerpo.pesable = 1 
			then CAST(round(((CsrCuerpo.preunitasiva)* Csrcuerpo.kilos -Csrcuerpo.bonisiva)*  CsrCabeza.signo,3)  as numeric(18,2))
			else ((case when Csrcuerpo.Univenta=1 or csrcuerpo.unibulto=1 
				then CAST(ROUND(((CsrCuerpo.preunitasiva) * Csrcuerpo.cantidad -Csrcuerpo.bonisiva)*  CsrCabeza.signo ,3) as numeric(18,2)) 
				else CAST(round((ROUND(((CsrCuerpo.preunitasiva) * csrcuerpo.unibulto),2) * (Csrcuerpo.cantidad/Csrcuerpo.unibulto) -Csrcuerpo.bonisiva)*  CsrCabeza.signo,3)  as numeric(18,2)) 
			end)) end)) from Cabefac as CsrCabeza
	left join cuerfac as CsrCuerpo on CsrCabeza.id = CsrCuerpo.idcabeza and CsrCabeza.idmaopera = CsrCuerpo.idmaopera
	left join maopera as CsrOpera on CsrCabeza.idmaopera = CsrOpera.id
	left join producto as Csrarticulo on Csrcuerpo.idarticulo = Csrarticulo.id
	where CsrOpera.origen IN ('FAC','FPE') and  not (CsrOpera.clasecomp in ('K')) and CsrOpera.estado<>'1'
	and CsrOpera.idcomproba in(1,2,3,27,28,29,31,1100000062) 
	and Csrcabeza.fecha >= '20110901' AND Csrcabeza.fecha < '20111001'
	and CsrCuerfac.idarticulo = CsrCuerpo.idarticulo
	),CAST(0  as numeric(18,2))) as NetoGravadoPer02
from cuerfac as Csrcuerfac
left join maopera as Csrmaopera on Csrcuerfac.idmaopera = Csrmaopera.id
left join cabefac as csrcabefac on Csrcuerfac.idcabeza = Csrcabefac.id
left join producto as Csrproducto on Csrcuerfac.idarticulo = Csrproducto.id
left join rubro as Csrrubro on Csrproducto.idrubro = CsrRubro.id
left join ctacte as CsrCtacte on CsrCabefac.idctacte = CsrCtacte.id
left join catectacte as CsrCategoria on CsrCtacte.idcategoria = Csrcategoria.id
left join categoiva as Csrcategoiva on Csrctacte.tipoiva = csrcategoiva.id
left join vendedor as csrvendedor on csrmaopera.idvendedor = csrvendedor.id
left join fletero as csrfletero on csrcabefac.idfletero = csrfletero.id 
where CsrMaopera.origen IN ('FAC','FPE') and  not (Csrmaopera.clasecomp in ('K')) and Csrmaopera.estado<>'1'
and Csrcabefac.fecha >= '20110801' AND Csrcabefac.fecha < '20111001' and Csrmaopera.Idvendedor>-1
and csrcuerfac.idarticulo>0 and Csrcabefac.Idctacte>-1 and Csrcuerfac.Idarticulo>-1 and Csrproducto.idestado in (1,2) 
and CsrCabefac.Idfletero >0  and CsrMaopera.idcomproba in(1,2,3,27,28,29,31,1100000062)
group by  CsrCuerfac.idarticulo,Csrproducto.numero,csrproducto.nombre,CsrFletero.numero,CsrFletero.nombre,CsrVendedor.numero,CsrVendedor.nombre
,CsrCtacte.cnumero,CsrCtacte.cnombre,CsrCategoria.nombre,CsrCategoiva.abrevia
,Csrrubro.numero,Csrrubro.nombre,CsrRubro.id
Order by CsrRubro.id,CsrProducto.numero