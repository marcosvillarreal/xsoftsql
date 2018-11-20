use guerrero
go
Delete from dcuervari  Where dcuervari.idmaopera in 
		(select dmaopera.id from dmaopera 
		left join dcabefac on dmaopera.id = dcabefac.idmaopera
		where  dcabefac.fecha < '20180801'	)
			go
Delete from dcabedeta Where dcabedeta.idmaopera in 
		(select dmaopera.id from dmaopera 
		left join dcabefac on dmaopera.id = dcabefac.idmaopera
		where  dcabefac.fecha < '20180801'	)
go
Delete from dcuerfac Where dcuerfac.idmaopera in 
		(select dmaopera.id from dmaopera 
		left join dcabefac on dmaopera.id = dcabefac.idmaopera
		where  dcabefac.fecha < '20180801'	)
go
Delete from dpagos Where dpagos.idmaopera in 
		(select dmaopera.id from dmaopera 
		left join dcabefac on dmaopera.id = dcabefac.idmaopera
		where  dcabefac.fecha < '20180801'	)
go
Delete from dtablaasi Where dtablaasi.idmaopera in 
		(select dmaopera.id from dmaopera 
		left join dcabefac on dmaopera.id = dcabefac.idmaopera
		where  dcabefac.fecha < '20180801'	)
go
Delete from dmaopera Where dmaopera.id in 
		(select dmaopera.id from dmaopera 
		left join dcabefac on dmaopera.id = dcabefac.idmaopera
		where  dcabefac.fecha < '20180801'	)
go
Delete from dcabefac Where dcabefac.fecha < '20180801'

go