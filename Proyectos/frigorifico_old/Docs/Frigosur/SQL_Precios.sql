SELECT a.r01,a.r02,p.id,p.r01
-- ,p.r02
-- ,ap.id,ap.r01,ap.r02,ap.r03
,ap.r04 as prevta
-- ,ap.r05,ap.r06,ap.r07,ap.r08,ap.r10
FROM gestionfrigo.art02 as ap
left join gestionfrigo.art01 as a on ap.r01 = a.id
left join gestionfrigo.art09 as p on ap.r02 = p.id
order by a.id