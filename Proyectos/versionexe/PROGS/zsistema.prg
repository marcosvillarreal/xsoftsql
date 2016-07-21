SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  

set classlib to
*-- CREACION DE OBJETO APLICACION

Set classlib to aplicacion.vcx additive && Objeto Aplicacion
   SET CLASSLIB  TO  reindexer ADDITIVE 
   SET CLASSLIB  TO  clasesgenerales ADDITIVE 
   SET CLASSLIB  TO  controles ADDITIVE 
   SET CLASSLIB  TO  iabm.vcx ADDITIVE 
   SET CLASSLIB  TO  calc.vcx ADDITIVE  && Calculadora   
   SET CLASSLIB  TO  cooldate.vcx ADDITIVE  
   SET CLASSLIB  TO  icontrolespersonalizados ADDITIVE 
   SET CLASSLIB TO odata ADDITIVE 

l='J:'
set talk off
   lcdd=L+'\xsoftsql\proyectos\versionexe\'
*-- RUTA
   _rutaclases =lcdd+'Clases'
   _rutaclased =L+'\xsoftsql\desarrollo\clases'
   _rutabmpd   =L+'\xsoftsql\desarrollo\graficos'
   _rutaprogs  =lcdd+'Progs'
   _rutamenu   =lcdd+'Menus'
   _rutadatos  =lcdd+'Datos'
   _rutabmps   =lcdd+'graphics'
   _rutaforms  =lcdd+'forms'
   _rutareports=lcdd+'reports' 
    _rutaformsDesarrollo =L+'\xsoftsql\desarrollo\forms'
   _rutaffc  =L+'\xsoftsql\desarrollo\clases\ffc'
      
   Set default to (lcdd) &&;(lcddc)

   Set path to &_rutaclases,&_rutaprogs,&_rutamenu,&_rutadatos,&_rutabmps,&_rutaforms;
               ,&_rutareports,&_rutaclased,&_rutabmpd,&_rutaformsDesarrollo,&_rutaffc

 STORE '' TO LcConectionString,LcDataSourceType,lcOrigenPublico,LcWebService
 STORE 0 TO Pnterminal,Pnsucursal

PUBLIC OAvisar
Oavisar=CREATEOBJECT('avisar')

Public goapp
goapp=createobject('app',.f.,.t.)

 =ObtenerServidor()
 
PUBLIC loConnDataSource,lcIdObjCon,lcIdObjneg,lcServidor,ObjNeg
 
IF LEN(TRIM(LcConectionString))#0

	Local  loCatchErr As Exception

	TRY 
	       DO case
		      CASE LcDataSourceType='ADO' OR LcDataSourceType='ODBC'
					loConnDataSource = createobject('ADODB.Connection')
					loConnDataSource.ConnectionString = LcConectionString
					loConnDataSource.CommandTimeout = 60
					loConnDataSource.ConnectionTimeout = 30

					Oavisar.proceso('S','Conectando con Base de Datos, tiempo de espera 30"' ,.f.,0)
					                              			    
					loConnDataSource.Open()
					                        			    
					Oavisar.proceso('N')
	                       			                           	  	
		CASE LcDataSourceType='NATIVE'
			     IF !DBUSED('&LcConectionString')        
			        OPEN DATABASE (LcConectionString) SHARED
			     ENDIF  
			     SET DATABASE TO (LcConectionString)
	      OTHERWISE 
	                ERROR 1429
		ENDCASE
	Catch To loCatchErr
 		 =Oavisar.proceso('N')	
		 =Oavisar.usuario('La conexión a la Base de Datos a fallado',0)
		CANCEL 
		CLEAR ALL 
		RETURN 
	ENDTRY 
	
ENDIF 

LOCAL lcCmd,lok,lcfechaSis,lchoraSis,lchoraExe,lcfechaExe

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT Csrsistema.* FROM sistema as Csrsistema
ENDTEXT 

IF USED("Csrsistema")
	USE IN Csrsistema
ENDIF

Orssistema = null 
Ocasistema = null
Orssistema= createobject('ADODB.RecordSet')
Orssistema.CursorLocation   = 3  && adUseClient
Orssistema.LockType         = 3  && adLockOptimistic
IF TYPE('loConnDataSource')='O'
   Orssistema.ActiveConnection = loConnDataSource
ENDIF 
OCAsistema = CREATEOBJECT("CursorAdapter")
WITH OCAsistema
    .Alias     = "Csrsistema"
    .DataSource = Orssistema
    .DataSourceType = LcDataSourceType
    .SelectCmd=lccmd
    .UseDedatasource=.f.
    .BufferModeOverride = 5
    .Name = "sistema"
    .UpdateType = 1
    .CursorSchema = "ID I, PROGRAMA C(50), FECHA C(8), HORA C(8)"
   .UpdateNameList = "ID sistema.ID, PROGRAMA sistema.programa, FECHA sistema.fecha, HORA sistema.hora"
   .UpdatableFieldList ="ID, PROGRAMA, FECHA, HORA"
    .CursorFill()    
ENDWITH 

IF AERROR(laError) > 0
	=Oavisar.Usuario("Error al obtener datos:"+laError[2],0)
ENDIF

STORE "" TO lcfechasis,lchorasis,lchoraExe,lcfechaexe

lcExe = 'gestion.exe'
lcRar = 'starossa.exe'

lcDir = "C:\APLICACIONES\STAROSSA\"

lcdd = lcDir + lcExe

x = Adir(lCarray, lcdd,"H")

lcfecha = ""
lchora = ""

IF x=1
	   lcfecha = DTOS(lcArray[1,3])
	   lchora  = lcarray[1,4]

	REPLACE programa WITH lcExe,fecha WITH lcfecha,hora WITH lchora IN Csrsistema
	
*!*		lok =tableupdate(1,.t.,"Csrsistema")
*!*		
*!*		IF AERROR(laError) > 0
*!*			=Oavisar.Usuario("Error al obtener datos:"+laError[2],0)
*!*		ENDIF
	      
	TEXT TO lcCmd TEXTMERGE NOSHOW 
	SELECT Csrgestion.* FROM gestion as Csrgestion
	ENDTEXT 

	IF USED("Csrgestion")
		USE IN Csrgestion
	ENDIF

	Orsgestion = null 
	Ocagestion = null
	Orsgestion= createobject('ADODB.RecordSet')
	Orsgestion.CursorLocation   = 3  && adUseClient
	Orsgestion.LockType         = 3  && adLockOptimistic
	IF TYPE('loConnDataSource')='O'
	   Orsgestion.ActiveConnection = loConnDataSource
	ENDIF 
	OCAgestion = CREATEOBJECT("CursorAdapter")
	WITH OCAgestion
	    .Alias     = "Csrgestion"
	    .DataSource = Orsgestion
	    .DataSourceType = LcDataSourceType
	    .SelectCmd=lccmd
	    .UseDedatasource=.f.
	    .BufferModeOverride = 5
	    .Name = "gestion"
	    .UpdateType = 1
	    .CursorSchema = "ID I, PROGRAMA M,NOMBREZIP C(50), FECHA C(8), HORA C(8)"
	   .UpdateNameList = "ID gestion.ID, PROGRAMA gestion.programa, NOMBREZIP gestion.NOMBREZIP, FECHA gestion.fecha, HORA gestion.hora"
	   .UpdatableFieldList ="ID, PROGRAMA, NOMBREZIP, FECHA, HORA"	    
	   .MapBinary = .T.
           .CursorFill()    	    
	ENDWITH 
	
	IF AERROR(laError) > 0
		=Oavisar.Usuario("Error al obtener datos:"+laError[2],0)
	ENDIF

	lcdd= lcdir + lcRar
			
  	REPLACE programa WITH FILETOSTR(lcdd),nombrezip WITH lcRar,fecha WITH lcfecha,hora WITH lchora IN Csrgestion
  	
	lok=tableupdate(1,.t.,"Csrgestion")
	
	IF AERROR(laError) > 0
		=Oavisar.Usuario("Error al obtener datos:"+laError[2],0)
	ENDIF


	lok =tableupdate(1,.t.,"Csrsistema")
	
	IF AERROR(laError) > 0
		=Oavisar.Usuario("Error al obtener datos:"+laError[2],0)
	ENDIF

	
ENDIF 
