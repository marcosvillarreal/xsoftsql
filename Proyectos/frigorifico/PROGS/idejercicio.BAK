goapp.idsucursal = 1100000001

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
	GOAPP.IDUSUARIO = 1 
	*GOAPP.IDUSUARIO = 1100000006 && Caro
	*GOAPP.IDUSUARIO = 14 && dEP
	*GOAPP.IDUSUARIO = 1100000014 && YESI
	
	goapp.terminal =1 &&4
	goapp.terminal =9 &&despacho
	*goapp.terminal = 6 &&yesi
	*goapp.terminal = 5 &&caro
	**goapp.terminal = 7 &&romina
	*goapp.terminal = 8 &&mable
	*GOAPP.IDUSUARIO = 1100000012 &&despacho
ENDCASE 	


OAVISAR.USUARIO('Empresa:'+cEmpresa+CHR(13)+'GOAPP.IDEJERCICIO = '+STR(GOAPP.IDEJERCICIO)+CHR(13);
+ 'GOAPP.IDUSUARIO = '+STR(GOAPP.IDUSUARIO)+CHR(13)+;
'GOAPP.SUCURSAL10 = '+STR(GOAPP.SUCURSAL10)+CHR(13)+;
'GOAPP.TERMINAL = ' +STR(goapp.terminal))
