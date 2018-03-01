use leon
go
	   SELECT Distinct CsrTablaasi.*,CsrParaconta.idcuenta,CsrParaconta.numero,Csrmaopera.origen as origen
	   ,LEFT(Csrmaopera.numcomp,1)+' '+SUBSTRING(Csrmaopera.numcomp,2,4)+'-'+RIGHT(Csrmaopera.numcomp,8) as numcomp
	   ,Csrmaopera.idcomproba as idcomproba,Csrmaopera.clasecomp as clasecomp,Csrcomprobante.cnombre as nomcomp
	   ,ISNULL(CsrCabefac.signo,0) as CabefacSigno,ISNULL(CsrCabecpra.signo,0) as Cabecprasigno,ISNULL(Csrmovctacte.signo,0) as MovCtactesigno,ISNULL(Csrmovbcocar.signo,0) as movbcocarsigno
	   ,ISNULL(CsrCtacte.cnombre,ISNULL(Csrcabefac.cnombre,ISNULL(Csrcabecpra.cnombre,ISNULL(CsrCtabco.cnombre,ISNULL(CsrCabeAsi.detalle,SPACE(30)))))) as cnombre,ISNULL(Csrmovbcocar.numero,CAST(0 as Numeric(10))) as Numcheque
	   ,ISNULL(CsrPlancue.cuenta,0000) as CtaContable,ISNULL(CsrPlancue.nombre,SPACE(30)) as NomContable,ISNULL(CsrCtaBco.cnumero,SPACE(6)) as CtaBco,ISNULL(Csrmovctacte.switch,'00000') as switchctacte
   	   ,ISNULL(Csrfletero.numero,0) as NumFlete,ISNULL(Csrfleteren.numero,0) as Numrfle,ISNULL(Csrfleteren.numero,0) as Numrfle,ISNULL(Csrtablaimp.idcuenta,0) as TablaImpidCta,ISNULL(Csrtablaimp.detalle,SPACE(30)) as Tablaimpdetalle
   	   ,ISNULL(CsrMovBcocar.importe,CAST(0 as numeric(11,2))) as movbcoimporte
	  	FROM Tablaasi as CsrTablaAsi 
	  	left join CabeAsi as CsrCabeasi on CsrTablaAsi.idmaopera=csrCabeasi.idmaopera
		LEFT JOIN ParaConta as CsrParaConta on  CsrTablaAsi.idcuenta = CsrParaConta.idcuenta
		left join maopera as Csrmaopera on Csrtablaasi.idmaopera = Csrmaopera.id
		--left join Tablaasi as Csrtablaasi on CsrTablaCaja.idmaopera = CsrTablaasi.idmaopera
	   left join comprobante as Csrcomprobante on Csrmaopera.idcomproba = Csrcomprobante.id
	   left join cabefac as Csrcabefac on Csrmaopera.origen='FAC' and Csrmaopera.id = CsrCabefac.idmaopera
	   left join cabecpra as Csrcabecpra on Csrmaopera.origen='CPR' and Csrmaopera.id = CsrCabecpra.idmaopera
	   left join movctacte as Csrmovctacte on Csrmaopera.origen IN ('COB','FAC','CPR','PAG','RFL') and Csrtablaasi.idmaopera = Csrmovctacte.idmaopera
	   left join Ctacte as Csrctacte on ISNULL(Csrmovctacte.idctacte,0) = Csrctacte.id
	   left join afebcocar as CsrAfeBcocar on CsrTablaasi.idorigen = CsrAfeBcocar.idorigen and CsrMaopera.id = CsrAfebcocar.idmaoperao	
	   left join movbcocar as CsrmovBcocar on (Csrtablaasi.idorigen = Csrmovbcocar.id and Csrmaopera.id = Csrmovbcocar.idmaopera AND  LEFT(CsrTablaasi.tablaori,1)<>'B') or ( CsrAfeBcocar.idafecta = CsrMovBcocar.id and CsrAfebcocar.idmaoperaa = CsrMovbcocar.idmaopera	AND  LEFT(CsrTablaasi.tablaori,1)='B')
	   left join Ctacte as CsrCtabco on ISNULL(CsrmovBcocar.idctabco,0) = CsrCtaBco.id
	   left join renmaope as Csrrenmaope ON Csrmaopera.id = Csrrenmaope.idmaopera
	   left join fleteren as Csrfleteren on ISNULL(Csrrenmaope.idfleteren,0) = Csrfleteren.id
	   left join fletero as Csrfletero on ISNULL(Csrfleteren.idfletero,0) = Csrfletero.id
	   left join plancue as Csrplancue on Csrtablaasi.idcuenta = Csrplancue.id
	   left join tablaimp as Csrtablaimp on CsrTablaasi.id = CsrTablaimp.idasiento
	   left join detanrocaja as Csrdetanrocaja on Csrmaopera.iddetanrocaja = Csrdetanrocaja.id		
	   WHERE 
		csrtablaasi.idmaopera in (110000597791,110000597796,110000597798,110000597801,110000597803,110000597804,
		110000597807,110000597809,110000597810,120000597779,120000597786,120000597790,120000597793,120000597799,120000597800)
		and (not CsrTablaasi.idcuenta in (1100001620,1100001621))  

order by csrtablaasi.id 