SELECT a.id,a.r01 as codigo,a.r02 as nombre
,131 as CodProveedor,1 as CodMarca,a.r31 as idrubro,r.r02 as nombre
-- ,a.r22 as IdDivisa
,d.r04 as codtasa -- 0 = 21.00, 1= 10.50
-- ,a.r03,a.r04,a.r05,a.r06,a.r07,a.r08,a.r09,a.r10
-- ,a.r11,a.r12,a.r13,a.r14,a.r15,a.r16,a.r17,a.r18,a.r19,a.r20
-- ,a.r21,a.r22 ,a.r23,a.r24,a.r25,a.r26,a.r27,a.r28,a.r29,a.r30
-- ,a.r32,a.r33,a.r34,a.r35,a.r36,a.r37,a.r38,a.r39,a.r40
-- ,a.r41,a.r42,a.r43
FROM gestionfrigo.art01 as a
left join gestionfrigo.art13 as r on a.r31 = r.id
left join gestionfrigo.vta10 as d on a.r22 = d.id
-- left join gestionfrigo.vta22 as pla on d.r04 = pla.id
where a.id > 0
