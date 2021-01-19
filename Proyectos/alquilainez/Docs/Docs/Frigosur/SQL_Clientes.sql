
SELECT  c.id,c.r17 as codigo,c.r00 as cnombre,c.r10 as cuit
,c.r01 as cdireccion,c.r02 as cdirenro
 ,c.r03 as cdire_piso,c.r04 as cdire_dpto
 ,c.r05 as idlocalidad,loca.r02 as nomlocalidad,prov.r02 as nomprov
 ,c.r06 as ctelefono
 ,c.r07 as idcategoiva,categoiva.r01 as nomcategoiva
 ,c.r12 as ctelefono2,c.r18 as estado
 ,l.id idlista,l.r01 as nomlista
 ,c.r26 as zona
 ,c.r27 as idvendedor, ve.r01 as codvendedor, ve.r02 as nomvendedor
FROM vta01 as c
left join gral06 as categoiva on c.r07 = categoiva.id
left join art09 as l on c.r25 = l.id
left join gral02 as loca on c.r05 = loca.id
left join gral03 as prov on loca.r01 = prov.id
left join vta25 as ve on c.r27 = ve.id
where c.r17 > 0
order by c.r17
