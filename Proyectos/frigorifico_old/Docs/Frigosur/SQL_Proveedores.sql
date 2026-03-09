SELECT p.id,p.r00 as cnombre,p.r01 as cdireccion,p.r02 as cdire_nro,p.r03 as cdire_piso,p.r04 as cdire_dpto
,p.r05 as idlocalidad,loca.r02 as nomlocalidad,prov.r02 as nomprov
,p.r06 as ctelefono
-- ,p.r07
,p.r08 as idcategoiva,categoiva.r01 as nomcategoiva,p.r09 as nroiibb
-- , p.r10
,p.r11 as cuit ,p.r12 as letra_default,p.r13 as ptvta_default
-- ,p.r14,p.r15
,p.r16 as idrubroprov,ruprove.r01 as nomrubroprov
-- ,p.r17
,p.r18 as cbu,p.r19 as ctelefono2
-- ,p.r20,p.r21,p.r22,p.r23,p.r24
-- ,p.r25 as idlista,p.r26 as zona
-- ,p.r27 ,p.r28
,p.r29 as ganestado -- 0_No / 1_Inscripto / 2_No_Inscripto
,ga.r00 as idganancia
,p.r38 as tipocta -- 0_ / 1_Contado / 2_Ctacte
,p.r43 as diasvto
-- ,p.r39,p.r40,p.r41,p.r42
-- ,p.r31,p.r32,p.r33,p.r34,p.r35,p.r36,p.r37
FROM gestionfrigo.com01 as p
left join gestionfrigo.gral06 as categoiva on p.r08 = categoiva.id
left join gestionfrigo.gral02 as loca on p.r05 = loca.id
left join gestionfrigo.gral03 as prov on loca.r01 = prov.id
left join gestionfrigo.com20 as ruprove on p.r16 = ruprove.id
left join gestionfrigo.tab43 as ga on p.r30 = ga.id
where p.id > 2
Order by p.id