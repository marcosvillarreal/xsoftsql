select 
--CsrDeposito.id as iddeposito,CsrDeposito.nombre as nomdeposito,CsrDeposito.numero as numDeposito,
CsrRubro.id as idrubro
,CsrRubro.numero as numrubro,CsrRubro.nombre as nomrubro,CsrProducto.id as idarticulo,CsrProducto.nombre as nomarticulo
, CsrProducto.numero as numarticulo
--,isnull(CsrSubProducto.idvariedad,cast(0 as int)) as idvariedad,ISNULL(CsrSubProducto.nombre,SPACE(20)) as nomvariedad
,CAST(0 as numeric(11,2)) as Saldoant
,Sum((Case When CsrMaopera.clasecomp in ('L') then CsrMovStock.cantidad else cast(0 as numeric(11,2)) end )) as TotProduccion
,Sum((Case When CsrMaopera.clasecomp in ('A','B','X') then CsrMovStock.cantidad else cast(0 as numeric(11,2)) end )) as TotVentas
,Sum((Case When CsrMaopera.clasecomp in ('C') then CsrMovStock.cantidad else cast(0 as numeric(11,2)) end )) as TotDevoluciones
,Sum((Case When CsrMaopera.clasecomp in ('M') then CsrMovStock.cantidad else cast(0 as numeric(11,2)) end )) as TotDescuento
,Sum((Case When CsrMaopera.clasecomp in ('N') and CsrMovStock.signo= -1 then CsrMovStock.cantidad else cast(0 as numeric(11,2)) end )) as TotEnviado
,Sum((Case When CsrMaopera.clasecomp in ('N') and CsrMovStock.signo= 1 then CsrMovStock.cantidad else cast(0 as numeric(11,2)) end )) as TotRecibido

,(select sum((case when isnull(cuervari.id,0)=0 then cuerpo.cantidad else cuervari.cantidad end)) 
	from maopera 
	inner join cabeord as cabeza on maopera.id = cabeza.idmaopera 
	inner join concepto on cabeza.idconcepto = concepto.id
	inner join cuerord as cuerpo on cabeza.id = cuerpo.idcabeza 
	left join cuervariord as cuervari on cuerpo.id = cuervari.idcuerfac
	where Maopera.estado=1 and Maopera.clasecomp='N' and CsrProducto.id = Cuerpo.idarticulo 
		and isnull(CsrSubProducto.idvariedad,0) = isnull(Cuervari.idvariedad,0) and Cabeza.iddepentra = CsrDeposito.id and Cabeza.iddepsale = 1100000003
		and (Maopera.fechasis between '20140101' and '20140205') and concepto.estadomerc >= 0
) as TotEnvioDel002
,(select sum((case when isnull(cuervari.id,0)=0 then cuerpo.cantidad else cuervari.cantidad end)) 
	from maopera 
	inner join cabeord as cabeza on maopera.id = cabeza.idmaopera 
	inner join concepto on cabeza.idconcepto = concepto.id
	inner join cuerord as cuerpo on cabeza.id = cuerpo.idcabeza 
	left join cuervariord as cuervari on cuerpo.id = cuervari.idcuerfac
	where Maopera.estado=0 and Maopera.clasecomp='N' and CsrProducto.id = Cuerpo.idarticulo 
		and isnull(CsrSubProducto.idvariedad,0) = isnull(Cuervari.idvariedad,0) and Cabeza.iddepsale = CsrDeposito.id and Cabeza.iddepentra = 1100000003
		and (Maopera.fechasis between '20140101' and '20140205') and concepto.estadomerc >= 0
) as TotEntroEn002
,(select sum((case when isnull(cuervari.id,0)=0 then cuerpo.cantidad else cuervari.cantidad end)) 
	from maopera 
	inner join cabeord as cabeza on maopera.id = cabeza.idmaopera 
	inner join concepto on cabeza.idconcepto = concepto.id
	inner join cuerord as cuerpo on cabeza.id = cuerpo.idcabeza 
	left join cuervariord as cuervari on cuerpo.id = cuervari.idcuerfac
	where Maopera.estado=0 and Maopera.clasecomp='N' and CsrProducto.id = Cuerpo.idarticulo 
		and isnull(CsrSubProducto.idvariedad,0) = isnull(Cuervari.idvariedad,0) and Cabeza.iddepsale = CsrDeposito.id and Cabeza.iddepentra = 1100000004
		and (Maopera.fechasis between '20140101' and '20140205') and concepto.estadomerc >= 0
) as TotEntroEn003
,(select sum((case when isnull(cuervari.id,0)=0 then cuerpo.cantidad else cuervari.cantidad end)) 
	from maopera 
	inner join cabeord as cabeza on maopera.id = cabeza.idmaopera 
	inner join concepto on cabeza.idconcepto = concepto.id
	inner join cuerord as cuerpo on cabeza.id = cuerpo.idcabeza 
	left join cuervariord as cuervari on cuerpo.id = cuervari.idcuerfac
	where Maopera.estado=0 and Maopera.clasecomp='N' and CsrProducto.id = Cuerpo.idarticulo 
		and isnull(CsrSubProducto.idvariedad,0) = isnull(Cuervari.idvariedad,0) and Cabeza.iddepsale = CsrDeposito.id and Cabeza.iddepentra = 1100000005
		and (Maopera.fechasis between '20140101' and '20140205') and concepto.estadomerc >= 0
) as TotEntroEn004

From Rubro as CsrRubro
inner join Producto as CsrProducto on CsrRubro.id = CsrProducto.idrubro
left join SubProducto as CsrSubProducto on CsrProducto.id = CsrSubProducto.idarticulo
inner join MovStock as CsrMovStock on CsrProducto.id = CsrMovStock.idarticulo  and isnull(CsrSubproducto.id,cast(0 as int))= CsrMovStock.idsubarti
inner join Maopera as CsrMaopera on CsrMovStock.idmaopera = CsrMaopera.id
inner join Deposito as CsrDeposito on CsrMovStock.iddeposito = CsrDeposito.id
left join cabeord as CsrCabeOrd on CsrMovstock.idmaopera = CsrCabeOrd.idmaopera
Where CsrRubro.produccion = 1 and CsrProducto.id >0
and (CsrMovStock.fecha between '20140101' and '20140205') and Csrmaopera.estado = 0 and CsrMaopera.clasecomp<>'K'
and CsrMovStock.idDeposito = 1100000001 
Group By CsrDeposito.id,CsrDeposito.nombre,CsrDeposito.numero,CsrProducto.id,CsrProducto.nombre,CsrProducto.numero,CsrSubProducto.idvariedad,CsrSubProducto.nombre,CsrRubro.id,CsrRubro.nombre,CsrRubro.numero