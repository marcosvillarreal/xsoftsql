use distribuidorasur
go

   SELECT CsrMaopera.idvendedor,CsrMaopera.id as idorigen,Csrmaopera.origen as origen,CsrComprobante.cabrevia
   ,LEFT(Csrmaopera.numcomp,1)+'-'+substring(Csrmaopera.numcomp,2,4)+'-'+RIGHT(Csrmaopera.numcomp,8) as numcomp
   ,Csrmaopera.idcomproba as idcomproba,Csrmaopera.clasecomp as clasecomp,Csrcomprobante.cabrevia as nomcomp
   ,(case when isnull(CsrMovCtacte.id,-1) <> -1 then 0 else CsrCabefac.total end) as total_caja
   ,(case when isnull(CsrMovCtacte.id,-1) <> -1 then CsrMovCtacte.total else 0 end) as total_ctacte
   FROM  maopera as Csrmaopera 
   left join comprobante as Csrcomprobante on Csrmaopera.idcomproba = Csrcomprobante.id
   left join cabefac as Csrcabefac on Csrmaopera.id = CsrCabefac.idmaopera
   left join movctacte as Csrmovctacte on CsrMaopera.id = Csrmovctacte.idmaopera
   left join Ctacte as Csrctacte on ISNULL(Csrmovctacte.idctacte,0) = Csrctacte.id
   left join detanrocaja as Csrdetanrocaja on Csrmaopera.iddetanrocaja = Csrdetanrocaja.id		
   WHERE Csrmaopera.origen in ('FAC','FPE') and CsrMaopera.terminal  > 0
   and 		( CsrDetaNroCaja.fecdesde >= '20210607' and  CsrDetaNroCaja.fechasta <= '20210613' )
   and CsrMaopera.idvendedor = 1100000009
   ORDER BY Csrmaopera.id
   go
   SELECT CsrMaopera.idvendedor,CsrMaopera.id as idorigen,Csrmaopera.origen as origen,CsrComprobante.cabrevia
   ,LEFT(Csrmaopera.numcomp,1)+'-'+substring(Csrmaopera.numcomp,2,4)+'-'+RIGHT(Csrmaopera.numcomp,8) as numcomp
   ,Csrmaopera.idcomproba as idcomproba,Csrmaopera.clasecomp as clasecomp,Csrcomprobante.cabrevia as nomcomp
   ,0 as total_caja
   ,CsrMovBcocar.importe as total_ctacte
   FROM  maopera as Csrmaopera 
   left join comprobante as Csrcomprobante on Csrmaopera.idcomproba = Csrcomprobante.id
   left join movbcocar as CsrMovBcocar on Csrmaopera.id = CsrMovBcocar.idmaopera
   left join movbcodeta as CsrMovBcoDeta on CsrMovBcocar.id = CsrMovBcoDeta.idmovbcocar
   left join Ctacte as Csrctacte on ISNULL(CsrMovBcoDeta.idctaentrega,0) = Csrctacte.id
   left join detanrocaja as Csrdetanrocaja on Csrmaopera.iddetanrocaja = Csrdetanrocaja.id		
   WHERE Csrmaopera.origen in ('CAR') and CsrMaopera.terminal  > 0
   and 		( CsrDetaNroCaja.fecdesde >= '20210607' and  CsrDetaNroCaja.fechasta <= '20210613' )
   and CsrMaopera.idvendedor = 1100000009
   ORDER BY Csrmaopera.id
   go
   SELECT CsrRenCaja.idfletero as idvendedor,CsrMaopera.id as idorigen,Csrmaopera.origen as origen,CsrComprobante.cabrevia
   ,LEFT(Csrmaopera.numcomp,1)+'-'+substring(Csrmaopera.numcomp,2,4)+'-'+RIGHT(Csrmaopera.numcomp,8) as numcomp
   ,Csrmaopera.idcomproba as idcomproba,Csrmaopera.clasecomp as clasecomp,Csrcomprobante.cabrevia as nomcomp
   ,0 as total_caja
   ,CsrMovCaja.importe as total_ctacte
   FROM  maopera as Csrmaopera 
   left join comprobante as Csrcomprobante on Csrmaopera.idcomproba = Csrcomprobante.id
   left join movcaja as CsrMovCaja on Csrmaopera.id = CsrMovCaja.idmaopera
   left join RenCaja as CsrRenCaja on CsrMaopera.id = CsrRenCaja.idmaopera
   left join detanrocaja as Csrdetanrocaja on Csrmaopera.iddetanrocaja = Csrdetanrocaja.id		
   WHERE Csrmaopera.origen in ('ICA','ECA') and CsrMaopera.terminal  > 0
   and 		( CsrDetaNroCaja.fecdesde >= '20210607' and  CsrDetaNroCaja.fechasta <= '20210613' )
   and CsrRenCaja.idfletero = 1100000009
   ORDER BY Csrmaopera.id
   go
   SELECT csrfletero.id,ISNULL(csrarqueo.id,-1) as idorigen,ISNULL(SUM(csrcuerarqueo.importe),0) as Total,CsrMoneda.clasevalor
	FROM fletero as csrfletero 
	left join arqueo as Csrarqueo on Csrfletero.id = ISNULL(Csrarqueo.idfletero,0) 
	left join cuerarqueo as Csrcuerarqueo on Csrarqueo.id = Csrcuerarqueo.idarqueo
	left join denominacion as CsrDenominacion on Csrcuerarqueo.iddenominacion = CsrDenominacion.id
	left join moneda as CsrMoneda on CsrDenominacion.idmoneda = CsrMoneda.id
	where Csrarqueo.fecha = '20210611'
	group by csrfletero.id,csrarqueo.id,csrmoneda.clasevalor