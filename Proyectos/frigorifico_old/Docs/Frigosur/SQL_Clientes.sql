
SELECT 
 c.id,c.r17 as codigo,c.r00 as cnombre,c.r10 as cuit,c.r01 as cdireccion,c.r02 as cdirenro
 ,c.r03 as cdire_piso,c.r04 as cdire_dpto
 ,c.r05 as idlocalidad,loca.r02 as nomlocalidad,prov.r02 as nomprov
 ,c.r06 as ctelefono
 ,c.r07 as idcategoiva,categoiva.r01 as nomcategoiva
 ,c.r12 as ctelefono2,c.r18 as estado
-- -- ,c.r25 as idlista,
 ,l.id idlista,l.r01 as nomlista
 ,c.r26 as zona
 ,c.r27 as idvendedor, ve.r01 as codvendedor, ve.r02 as nomvendedor

-- ,c.r03,c.r04,c.r08,c.r09,c.r11,c.r13,c.r14,c.r15,c.r16,c.r17,c.r19,c.r20
 -- ,c.r21,c.r22,c.r23,c.r24,c.r28,c.r29,c.r30
 -- ,c.r31,c.r32,c.r33,c.r34,c.r35,c.r36,c.r37,c.r38,c.r39,c.r40
 -- ,c.r41,c.r42,c.r43,c.r44,c.r45
FROM gestionfrigo.vta01 as c
left join gestionfrigo.gral06 as categoiva on c.r07 = categoiva.id
left join gestionfrigo.art09 as l on c.r25 = l.id
left join gestionfrigo.gral02 as loca on c.r05 = loca.id
left join gestionfrigo.gral03 as prov on loca.r01 = prov.id
left join gestionfrigo.vta25 as ve on c.r27 = ve.id
where c.r17 > 0
-- where c.r17 = 9803
 order by c.r17
-- order by l.id