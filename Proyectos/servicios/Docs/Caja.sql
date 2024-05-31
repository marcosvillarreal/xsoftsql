use laligabb
go
Select Csrcuerpo.estado as estado
,isnull(Csrcabefac.id,CsrMovCtacte.id) as idorigen
,CsrCuerpo.id as idmaopera
,LEFT(CsrCuerpo.numcomp,1)+' '+substring(CsrCuerpo.numcomp,2,4)+'-'+RIGHT(CsrCuerpo.numcomp,8) as numcomp
,CsrCtacte.cnumero as ctacte,CsrCtacte.cnombre as cnombre,CsrCtacte.id as idctacte
,substring(CsrCuerpo.numcomp,1,1) as letra
,ISNULL((Csrcabefac.total*Csrcabefac.signo),0) as total,isnull(CsrCabefac.signo,CsrMovCtacte.signo) as signo
,CsrSucursal.numero as numgrupo02,CsrSucursal.nombre as nomgrupo02,'0000' as numgrupo,SPACE(30) as nomgrupo
,Csrcuerpo.clasecomp as clasecomp,ISNULL(CsrCabefac.cae,'') as cae
,ISNULL(CsrCabefac.idplanpago,cast(0 as int)) as idplanpago,ISNULL(Csrplanpago.nombre,SPACE(10)) as nompago
,ISNULL(CsrCategoiva.abrevia,SPACE(4)) as nomcatego
,ISNULL(Csrcabefac.listaprecio,0) as lista
,Csrcomprobante.cabrevia as nomcompro
,CsrCuerpo.terminal,ISNULL(CsrUsuario.nombre,SPACE(20)) as usuario,CsrCuerpo.fechaserver as fechatotal
,ISNULL(CsrCabefac.idtiponcredito,CAST(0 AS INT)) AS idtiponcredito
,ISNULL(Csrconcepto.nombre,SPACE(30)) as concepto
,ISNULL(convert(char,Csrcabefac.fecha,5),SPACE(8)) as chrfecha
,ISNULL(convert(char,(select top 1 CsrMovCtacte.vencimien from MovCtacte as CsrMovCtacte
	where Csrcuerpo.id=CsrMovCtacte.idmaopera order by CsrMovCtacte.vencimien)
,5),SPACE(8)) as chrfechavto
,ISNULL(ISNULL((Select SUM(ISNULL((CsrMovCtacte.importe-CsrMovCtacte.entrega)*CsrMovCtacte.signo,0))
	from MovCtacte as CsrMovCtacte
	where Csrcuerpo.id=CsrMovCtacte.idmaopera),0),0) as importeCtaCte
,CAST(0 as numeric(16,2)) as importeCaja
,CAST(0 as numeric(16,2)) as importeTarjeta
,CAST(0 as numeric(16,2)) as importeBco
,CAST(0 as int) as idvalor
,ISNULL(convert(char,Csrcabefac.fecha,5),SPACE(8)) as chrfechafac
,ISNULL(convert(char,CsrCuerpo.fechasis,5),SPACE(8)) as chrfecha
from maopera as Csrcuerpo
left join centrorecep as CsrSucursal on CsrCuerpo.sucursal = CsrSucursal.numero
left join movctacte as CsrMovCtacte on CsrCuerpo.id = CsrMovCtacte.idmaopera
left join cabefac as Csrcabefac on Csrcuerpo.id = Csrcabefac.idmaopera
left join movbcocar as CsrMovBcocar on CsrCuerpo.id = CsrMovBcocar.idmaopera
left join usuarios as CsrUsuario on CsrCuerpo.idoperador = CsrUsuario.id
left join planpago as Csrplanpago on CsrCabefac.idplanpago = Csrplanpago.id
left join categoiva as Csrcategoiva on Csrcabefac.idtipoiva = Csrcategoiva.id
left join concepto as Csrconcepto on CsrCabefac.idtiponcredito = CsrConcepto.id
left join comprobante as Csrcomprobante on Csrcuerpo.idcomproba = Csrcomprobante.id
left join ctacte as Csrctacte on CsrCabefac.idctacte = CsrCtacte.id or CsrMovCtacte.idctacte = CsrCtacte.id
where 	Csrcuerpo.clasecomp<>'K' 	and (CsrCuerpo.fechasis Between '20240401' AND '20240531')   And Csrcuerpo.estado='0'
AND CsrCuerpo.idcomproba >0  and  CsrCuerpo.terminal >0

Order by  Csrcuerpo.id