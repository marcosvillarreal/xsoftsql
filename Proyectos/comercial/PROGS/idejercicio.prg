lcEmpresa = ''

TEXT TO lcCmd TEXTMERGE NOSHOW 
select TOP 1 * from detaconta ORDER BY ejercicio desc
ENDTEXT 
IF NOT CrearCursorAdapter('CsrDetaConta',lcCmd)
	RETURN 
ENDIF 

goapp.idejercicio = CsrDetaConta.id
goapp.idejerciciofac = CsrDetaConta.id
DO CASE 
CASE goapp.codempresa = 1 &&
	lcEmpresa = 'Fortin'
	*goapp.idejercicio = 1100000027
	goapp.terminal = 12
	goapp.idusuario = 1
CASE goapp.codempresa = 2 &&
	lcEmpresa = 'Cachitos'
	*goapp.idejercicio = 1100000027
	goapp.terminal = 12
	goapp.idusuario = 1

CASE goapp.codempresa = 3 
	lcEmpresa = 'Maroña-HGarcia'&&
	*goapp.idejercicio = 1100000027
	goapp.terminal = 12
	goapp.idusuario = 1
CASE goapp.codempresa = 4 
	lcEmpresa = 'DelPuerto'&&
	*goapp.idejercicio = 1100000029
	goapp.terminal = 1
	goapp.idusuario = 1
CASE goapp.codempresa = 5 
	lcEmpresa = 'MundoHierros'&&
	*goapp.idejercicio = 1100000027
	goapp.terminal = 12
	goapp.idusuario = 1
CASE goapp.codempresa = 6 
	lcEmpresa = 'PuntoF'&&
	*goapp.idejercicio = 1100000027
	goapp.terminal = 15
	goapp.idusuario = 1
CASE goapp.codempresa = 7 
	lcEmpresa = 'Campisi'&&
	*goapp.idejercicio = 1100000027
	goapp.terminal = 15
	goapp.idusuario = 1
CASE goapp.codempresa = 8
	lcEmpresa = 'FerreLa25'&&
	*goapp.idejercicio = 1100000027
	goapp.terminal = 2
	goapp.idusuario = 1
CASE goapp.codempresa = 9
	lcEmpresa = 'SurSeco'&&
	*goapp.idejercicio = 1200000029
	goapp.terminal = 2
	goapp.idusuario = 1
	goapp.sucursal = 2
CASE goapp.codempresa = 10
	lcEmpresa = 'Ferrimac'&&
	*goapp.idejercicio = 1100000026
	goapp.terminal = 12
	goapp.idusuario = 1
CASE goapp.codempresa = 11 
	lcEmpresa = 'Antartida'&&
	*goapp.idejercicio = 1100000027
	goapp.terminal = 12
	goapp.idusuario = 1

ENDCASE 
*goapp.codempresa = 1

TEXT TO lccmd TEXTMERGE noshow
SELECT Usuarios.*,Perfiles.switch 
FROM usuarios
left join perfiles on usuarios.idperfil= perfiles.id 
WHERE usuarios.id = <<goapp.idusuario>> 
ENDTEXT
IF CrearCursorAdapter('CSRUSR',lcCmd)

 	goapp.perfilusuario=csrusr.idperfil
   goapp.switchUsuario = csrusr.switch
   goapp.nombreusuario=csrusr.nombre
   goapp.switchPerfil = CsrUsr.switch
   goapp.usuariotempleate = NVL(CsrUsr.templeate,1)
   goapp.usuarioidemail = NVL(CsrUsr.idemail,0)

	oavisar.usuario(lcEmpresa + CHR(13)+'goapp.idejercicio = '+LTRIM(STR(goapp.idejercicio))+CHR(13);
				+'GOAPP.SUCURSAL10 = '+STR(GOAPP.SUCURSAL10)+CHR(13);
				+'Goapp.terminal =' + STR(goapp.terminal))
	USE IN CSRUSR
ENDIF 