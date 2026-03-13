goapp.idsucursal = 1100000001
GOAPP.IDUSUARIO =1
cEmpresa = ''

TEXT TO lcCmd TEXTMERGE NOSHOW 
select TOP 1 * from detaconta ORDER BY id desc
ENDTEXT 
IF NOT CrearCursorAdapter('CsrDetaConta',lcCmd)
	RETURN 
ENDIF 

goapp.idejercicio = CsrDetaConta.id
GOAPP.IDEJERCICIOACTUAL = goapp.idejercicio
goapp.ejercicio = CsrDetaConta.ejercicio

DO CASE 
CASE goapp.codempresa = 1 &&Frigorifico Sur
	cEmpresa = 'Sur'
	goapp.terminal = 2
ENDCASE 	


OAVISAR.USUARIO('Empresa:'+cEmpresa+CHR(13)+'GOAPP.IDEJERCICIO = '+STR(GOAPP.IDEJERCICIO)+CHR(13);
+ 'GOAPP.IDUSUARIO = '+STR(GOAPP.IDUSUARIO)+CHR(13)+;
'GOAPP.SUCURSAL10 = '+STR(GOAPP.SUCURSAL10)+CHR(13)+;
'GOAPP.TERMINAL = ' +STR(goapp.terminal))
