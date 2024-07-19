goapp.idsucursal = 1100000001
GOAPP.IDUSUARIO =1
cEmpresa = ''
DO CASE 
CASE goapp.codempresa = 9 &&Kleja
	cEmpresa = 'Kleja'
	GOAPP.IDEJERCICIO = 1100000036
	GOAPP.IDEJERCICIOACTUAL = 1100000036	
	goapp.terminal = 1
	goapp.ejercicio = 14
CASE goapp.codempresa = 12 &&Don jose
	cEmpresa = 'Don Jose'
	GOAPP.IDEJERCICIO = 1100000012
	GOAPP.IDEJERCICIOACTUAL = 1100000012	
	goapp.terminal = 13
	goapp.ejercicio = 1
	goapp.idsucursal = 1100000001
CASE goapp.codempresa = 16 &&lns
	cEmpresa = 'LNS'
	GOAPP.IDEJERCICIO = 1100000001
	GOAPP.IDEJERCICIOACTUAL = 1100000001
	GOAPP.IDUSUARIO =1
	goapp.terminal = 17
	goapp.ejercicio = 1
	&&
	goapp.idsucursal = 1100000001
	GOAPP.SUCURSAL = 1
CASE goapp.codempresa = 19 &&km
	cEmpresa = 'KM'
	GOAPP.IDEJERCICIO = 1100000029
	GOAPP.IDEJERCICIOACTUAL = 1100000029
	GOAPP.IDUSUARIO =1
	goapp.terminal = 1
	goapp.ejercicio = 14
CASE goapp.codempresa = 20 &&mendoza
	cEmpresa = 'Mendoza'
	GOAPP.IDEJERCICIO = 1100000029
	GOAPP.IDEJERCICIOACTUAL = 1100000029
	GOAPP.IDUSUARIO =1
	goapp.terminal = 1
	goapp.ejercicio = 14
CASE goapp.codempresa = 21 &&mendoza
	cEmpresa = 'Gattari'
	GOAPP.IDEJERCICIO = 1100000029
	GOAPP.IDEJERCICIOACTUAL = 1100000029
	GOAPP.IDUSUARIO =1
	goapp.terminal = 1
	goapp.ejercicio = 14
ENDCASE 	


OAVISAR.USUARIO('Empresa:'+cEmpresa+CHR(13)+'GOAPP.IDEJERCICIO = '+STR(GOAPP.IDEJERCICIO)+CHR(13);
+ 'GOAPP.IDUSUARIO = '+STR(GOAPP.IDUSUARIO)+CHR(13)+;
'GOAPP.SUCURSAL10 = '+STR(GOAPP.SUCURSAL10)+CHR(13)+;
'GOAPP.TERMINAL = ' +STR(goapp.terminal))
