TEXT TO lcCmd TEXTMERGE NOSHOW 
select TOP 1 * from detaconta ORDER BY id desc
ENDTEXT 
IF NOT CrearCursorAdapter('CsrDetaConta',lcCmd)
	RETURN 
ENDIF 

goapp.idejercicio = CsrDetaConta.id
GOAPP.IDEJERCICIOACTUAL = goapp.idejercicio
goapp.ejercicio = CsrDetaConta.ejercicio


GOAPP.IDUSUARIO =1100000008 &&1
goapp.terminal = 6
goapp.sucursal = 1
goapp.idsucursal = 1100000001
OAVISAR.USUARIO('GOAPP.IDEJERCICIO = '+STR(GOAPP.IDEJERCICIO)+CHR(13);
+ 'GOAPP.IDUSUARIO = '+STR(GOAPP.IDUSUARIO)+CHR(13)+;
'GOAPP.SUCURSAL10 = '+STR(GOAPP.SUCURSAL10)+CHR(13)+;
'GOAPP.TERMINAL = ' +STR(goapp.terminal)+CHR(13)+;
'GOAPP.SUCURSAL = ' + STR(goapp.sucursal);
;
)
