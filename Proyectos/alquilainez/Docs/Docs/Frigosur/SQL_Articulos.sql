select a.id, a.r01 as codigo, a.r02 as nombre
,a,r31 as idrubro, r.r00 as nomrubro
from art01 as a
left join vta10 as r on a.r22 = r.id
where a.id > 0