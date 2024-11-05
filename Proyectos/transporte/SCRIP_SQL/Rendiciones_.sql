use elcoyote
go
select CsrZonaRen.id,CsrZonaRen.idzona,CsrZonaRen.numero,CsrZonaRen.fecha,CsrZonaRen.comision
,CsrZonaRen.comision2,CsrZonaRen.comibulto,CsrZona.numero
,SUM((case when CsrZona.comi_flete = 1 then CsrCabeza.flete + (case when isnull(CsrCabeza.rend_devol,0) =0 then CsrCabeza.ajuste else 0 end) else 0 end) 
+ (Case when CsrZona.comi_comicr =1 then CsrCabeza.comireembolso + CsrCabeza.ajuste_comicr else 0 end)
+ (case when CsrZona.comi_seguro = 1 then (case when isnull(CsrCabeza.rend_devol,0) =0 then CsrCabeza.seguro else 0 end) else 0 end)) as BaseComi
,CsrPlanPago.numero
,(case when CsrPlanPago.numero='CDO' and CsrCabeza.origen_pago='RTE' then sum(CsrCabeza.flete  + CsrCabeza.comireembolso  +  CsrCabeza.seguro + CsrCabeza.conexion)  else 0 end) as Contado_Rte
,(case when CsrPlanPago.numero='CDO' and CsrCabeza.origen_pago<>'RTE' then sum(CsrCabeza.flete  + CsrCabeza.comireembolso  +  CsrCabeza.seguro + CsrCabeza.conexion)  else 0 end) as Contado_Dest
,(case when CsrCabeza.rend_creembolso=1 then sum(CsrCabeza.creembolso)  else 0 end) as creembolso
,sum(CsrCabeza.iva) as IVA
from zonaren as CsrZonaRen
inner join renmaope as CsrCuerpo on CsrZonaRen.id = CsrCuerpo.idzonaren
inner join maopera as CsrMaopera on CsrCuerpo.idmaopera = CsrMaopera.id
inner join CabeRto as CsrCabeza on CsrCuerpo.idmaopera = CsrCabeza.idmaopera
left join Zona as CsrZona on CsrZonaren.idzona = CsrZona.id
left join PlanPago as CsrPlanPago on CsrCabeza.idplanpago = CsrPlanPago.id
where CsrZonaRen.Fecha > '20241031' and CsrZonaRen.id = 1500004234
group by CsrZonaRen.id,CsrZonaRen.idzona,CsrZonaRen.numero,CsrZonaRen.fecha,CsrZonaRen.comision
,CsrZonaRen.comision2,CsrZonaRen.comibulto,CsrZona.numero,CsrCabeza.origen_pago,CsrPlanPago.numero
,CsrCabeza.rend_creembolso
go
select * From renflete where idzonaren = 1500004234