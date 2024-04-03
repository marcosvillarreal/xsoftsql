*DO FORM frmreserva_v3_4

lnVersion = 0
TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT * FROM Paravario
where nombre = 'VERSIONRESERVA'
ENDTEXT 
=CrearCursorAdapter('FsrParaVario',lcCmd)
IF RECCOUNT('FsrParaVario')#0
	lnVersion = NVL(FsrParaVario.importe,0)
ENDIF 
	
	
lcDoForm = 'frmreserva_v3'
IF lnVersion > 0
	lcDoForm = lcDoForm + '_'+strtrim(lnVersion)
ENDIF 
DO FORM &lcDoForm
				