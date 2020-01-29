LOCAL lcCmdConfig
LOCAL nIdDeposito 

TEXT TO lcCmdConfig TEXTMERGE NOSHOW 
select paraconfig.iddeposito from centrorecep
inner join paraconfig on centrorecep.id = paraconfig.idcentrorecep
where centrorecep.numero = <<goapp.sucursal>>
ENDTEXT 
IF NOT CrearCursorAdapter('FsrConfig',lcCmdConfig)
	RETURN 
ENDIF 
SELECT FsrConfig
GO TOP 
nIdDeposito = FsrConfig.iddeposito

LOCAL lcCmdPatron
TEXT TO lcCmdPatron TEXTMERGE NOSHOW 
select CsrNCuerfac.codigo, CsrProducto.nombre,isnull(CsrVariedad.numero,cast(0 as int)) as variedad
,sum(Case when isnull(CsrNCuervari.id,0)=0 then CsrNCuerfac.cantidad else CsrNCuervari.cantidad end) as CantPatron
,CsrExistenc.existe as Existe,CsrExistenc.existedisp as ExisteDisp
,CsrExistenc.existe - (sum(Case when isnull(CsrNCuervari.id,0)=0 then CsrNCuerfac.cantidad else CsrNCuervari.cantidad end) + CsrExistenc.existedisp)
as Diferencia
from FletePlanilla as CsrFletePlanilla
left join FleteCarga as CsrFleteCarga on CsrFletePlanilla.id = CsrFleteCarga.idfleteplan
left join NMaopera as CsrNMaopera on CsrFleteCarga.idmaopera = CsrNMaopera.id
left join NCuerfac as CsrNCuerfac on CsrNMaopera.id = CsrNCuerfac.idmaopera
left join NCuerVari as CsrNCuervari on CsrNCuerfac.id = CsrNCuervari.idcuerfac and  CsrNcuerfac.idmaopera = CsrNCuervari.idmaopera
left join Producto as CsrProducto on CsrNcuerfac.idarticulo = CsrProducto.id
left join Variedad as CsrVariedad on isnull(CsrNCuervari.idvariedad,0) = CsrVariedad.id
left join Existenc as CsrExistenc on CsrNCuerfac.idarticulo = CsrExistenc.idarticulo and isnull(CsrNCuervari.idsubarti,0) = CsrExistenc.idsubarti
where right(CsrFletePlanilla.switch,1)='1' and left(CsrNMaopera.switch,1)='0' and CsrExistenc.iddeposito = <<nIdDeposito>>
and left(CsrFletePlanilla.switch,1)='0' and LEFT(CsrNMaopera.estado,1)='0' and LEFT(CsrFleteCarga.switch,1)<>'2'
group by CsrNCuerfac.codigo, CsrProducto.nombre, CsrVariedad.numero, CsrNCuerVari.idvariedad
,CsrExistenc.existe ,CsrExistenc.existedisp,CsrNCuerfac.idarticulo
order by convert(int,CsrNCuerfac.codigo)
ENDTEXT 
=SaveSQL(lcCmdPatron,'ControlPatron')
IF !CrearCursorAdapter("FsrPatron",lcCmdPatron)
	RETURN 
ENDIF 

IF RECCOUNT('FsrPatron')#0
	SELECT FsrPAtron
	replace ALL diferencia WITH existe - (existedisp + cantpatron) 
	DELETE FROM FsrPAtron WHERE diferencia = 0
	COUNT FOR !DELETED() TO lnCount
	IF RECCOUNT('FsrPatron')#0 AND lnCount>0
		BROWSE 
		USE IN FsrPatron
		RETURN 
	ENDIF 
ENDIF 
USE IN FsrPatron
RETURN 
	
	