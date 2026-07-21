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
CASE goapp.codempresa = 1 &&Tapia
	cEmpresa = 'Tapia'
	goapp.terminal = 1
CASE goapp.codempresa = 2 &&Juma
	cEmpresa = 'Juma'
	goapp.terminal = 1
CASE goapp.codempresa = 4 &&Quaglia
	cEmpresa = 'Quaglia'
	goapp.terminal = 3
CASE goapp.codempresa = 6 &&Libreria Lyris
	cEmpresa = 'Lyris'
	goapp.terminal = 4 && 19
CASE goapp.codempresa = 7 &&Garrone
	cEmpresa = 'Garrone'
	goapp.terminal = 1
CASE goapp.codempresa = 9 &&Kleja
	cEmpresa = 'Kleja'	
	goapp.terminal = 1
CASE goapp.codempresa = 10 &&Don jose
	cEmpresa = 'Montenegro'
	goapp.terminal = 5
CASE goapp.codempresa = 12 &&Don jose
	cEmpresa = 'Don Jose'	
	goapp.terminal = 13
CASE goapp.codempresa = 13 &&Sur
	cEmpresa = 'DistribuidoraSur'
	goapp.terminal = 17
CASE goapp.codempresa = 16 &&lns
	cEmpresa = 'LNS'
	goapp.terminal = 17
CASE goapp.codempresa = 19 &&km
	cEmpresa = 'KM'
	goapp.terminal = 1
CASE goapp.codempresa = 20 &&mendoza
	cEmpresa = 'Mendoza'
	goapp.terminal = 1
CASE goapp.codempresa = 21 &&gattari
	cEmpresa = 'Gattari'
	goapp.terminal = 1
CASE goapp.codempresa = 22 &&surlacteos
	cEmpresa = 'SurLacetos'
	goapp.terminal = 1
CASE goapp.codempresa = 23 &&SSG
	cEmpresa = 'SSG'
	goapp.terminal = 1
CASE goapp.codempresa = 24 &&Daniel
	cEmpresa = 'Daniel'	
	goapp.terminal = 1	
CASE goapp.codempresa = 25 &&Muller
	cEmpresa = 'DistMuller'
	goapp.terminal = 1
CASE goapp.codempresa = 26 &&Heladeria
	cEmpresa = 'Heladeria'	
	goapp.terminal = 1
CASE goapp.codempresa = 27 &&Fiambreria
	cEmpresa = 'Maruca F.'	
	goapp.terminal = 1
CASE goapp.codempresa = 28 &&Autoserivicio Teo
	cEmpresa = 'Teo'	
	goapp.terminal = 1
CASE goapp.codempresa = 29 &&El Calden
	cEmpresa = 'Calden'	
	goapp.terminal = 1
ENDCASE 	


OAVISAR.USUARIO('Empresa:'+cEmpresa+CHR(13)+'GOAPP.IDEJERCICIO = '+STR(GOAPP.IDEJERCICIO)+CHR(13);
+ 'GOAPP.IDUSUARIO = '+STR(GOAPP.IDUSUARIO)+CHR(13)+;
'GOAPP.SUCURSAL10 = '+STR(GOAPP.SUCURSAL10)+CHR(13)+;
'GOAPP.TERMINAL = ' +STR(goapp.terminal))
