*---------------------------------------------------------
*----------ReEditReport
*---------------------------------------------------------
*Modificamos la caracteristica del reporte en ejecucion
*El reporte no debe estar compilado
FUNCTION ReEditReport
LPARAMETERS cReport, cProperty,cValor

*'PAPERLENGTH','9999'
IF NOT FILE(cReport)
	RETURN 
ENDIF 
IF USED('DataReporte')
	USE IN DataReporte
ENDIF 
*USE (cReport)  ALIAS DataReporte
USE (cReport) ALIAS DataReporte
SELECT DataReporte
GO TOP 
cMemo = DataReporte.Expr
i = AT(cProperty,cMemo)
IF i#0
	cCopia1 = SUBSTR(cMemo,1,i +LEN(cProperty)) + cValor
	&&Tengo que copiar lo que viene luego de la propiedad, pq nose si hay otras.
	j =  AT(CHR(13),SUBSTR(cMemo,i)) &&Detecto el salto de linea luego de la propiedad
	cCopia2 = SUBSTR(SUBSTR(cMemo,i),17)
	 cMemoNew = cCopia1 + cCopia2
	 oavisar.usuario(cMemoNew)
	 replace Expr WITH cMemoNew IN DataReporte
ELSE
	cMemoNew = cMemo + CHR(13) + cProperty + "=" + cValor
	replace Expr WITH cMemoNew IN DataReporte
ENDIF 
USE IN DataReporte
*----------------------------------------------------------
FUNCTION LeerSucursal

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrSucursal.* FROM CentroRecep as CsrSucursal WHERE numero = <<goapp.sucursal>>
ENDTEXT 
IF NOT CrearCursorAdapter('CsrSucursal',lcCmd)
	RETURN 
ENDIF 
IF RECCOUNT('CsrSucursal')#0
	goapp.sucursalidlocalidad = CsrSucursal.idlocalidad
	goapp.essucursal =  CsrSucursal.essucursal
	goapp.idzonasucursal = CsrSucursal.idzona
ENDIF 
USE IN CsrSucursal

ENDFUNC 

*------------------------------------------------
FUNCTION KitGrillaTildar_Refrescar
PARAMETERS toContenedor

IF UPPER(toContenedor.BaseClass) $ "CONTROL"
	RETURN 
ENDIF 

TRY 
	IF PEMSTATUS(toContenedor,'Objects',5)		
		FOR EACH loControl IN toContenedor.Objects
			IF UPPER(loControl.Class) = 'KITGRILLATILDAR'
				loControl.Refrescar()
			ENDIF 
			IF PEMSTATUS(loControl,'Objects',5)
				=KitGrillaTildar_Refrescar(loControl)
			ENDIF 
		ENDFOR 
	ENDIF 	
CATCH TO oError
	stop()
	*si capta error es porque la propiedad no existe o no es contenedor
	oavisar.usuario('error' + CHR(13)+toContenedor.Name+CHR(13)+loControl_Name+CHR(13)+ 'Error: '+ALLTRIM(oError.Details)+' Metodo: '+oError.Procedure+CHR(13)+;
						'Mensaje: '+ALLTRIM(oError.Message)+' Nro Error ['+ALLTRIM(STR(oError.ErrorNo))+']'+CHR(13)+;
						'Linea: '+ALLTRIM(oError.LineContents))
	
ENDTRY 
RETURN 

*----------------------------------------------------------------------------
*----------------------------------------------------------------------------

*----------------------------------------------------------------------------
FUNCTION CargarDashMenu

LOCAL lcCmd

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrDatamenu.* FROM DataMenu as CsrDataMenu WHERE LEFT(LTRIM(switch)+'0',1)='0'
and sec_tipoacce <> 9
ORDER BY sec_codacce
ENDTEXT 
=CrearCursorAdapter('CsrDataMenu',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrPerfil.* FROM Perfiles as CsrPerfil WHERE CsrPerfil.id = <<goapp.perfilusuario>>
ENDTEXT 
=CrearCursorAdapter('CsrPerfil',lcCmd)

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrSeguridad.* FROM Seguridad as CsrSeguridad WHERE CsrSeguridad.idperfil = <<goapp.perfilusuario>>
ENDTEXT 
=CrearCursorAdapter('CsrSeguridad',lcCmd)


RETURN 
*------------------------------------------------------------------------------
FUNCTION HayVersionExe
PARAMETERS lcExe

LOCAL lcCmd,lok,lcfechaSis,lchoraSis,lchoraExe,lcfechaExe,lcCurdir

DIMENSION lcMenPrioridad[3]
lcMenPrioridad[1] = "ALTA HUBO MODIFICACION DE TABLAS"
lcMenPrioridad[2] = "ALTA HUBO CAMBIO EN REGISTRACIONES"
lcMenPrioridad[3] = "MEDIA HUBO CAMBIO EN LISTADOS"

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT Csrsistema.* FROM sistema as Csrsistema
ENDTEXT 

IF USED("Csrsistema")
	USE IN Csrsistema
ENDIF

lcCurdir = TRIM(SYS(5))+TRIM(CURDIR())

lok =CrearCursorAdapter("Csrsistema",lcCmd)

STORE "" TO lcfechasis,lchorasis,lchoraExe,lcfechaexe,lcExe,lcRespuesta 

IF lok
	lcfechasis = CsrSistema.fecha
	lchorasis   = CsrSistema.hora	    
	lcExe          = lcCurdir+TRIM(CsrSistema.programa)     && guardo el nombre del ejecutable
	
	lnprioridad = IIF(CsrSistema.prioridad=0 or 	CsrSistema.prioridad > ALEN(lcMenPrioridad),1,CsrSistema.prioridad)
	lcMensaje = lcMenPrioridad[lnprioridad]	
	
	*stop()
    x = Adir(lCarray, lcExe,"H")
    
    lcfechaexe = '19000101'
	lchoraexe   = ''
	IF x=1
		lcfechaexe = DTOS(lcArray[1,3])
		lchoraexe   = lcarray[1,4]
	ENDIF
	
	lcfecsis = RIGHT(lcfechasis,2)+"/"+LEFT(RIGHT(lcfechasis,4),2)+"/"+LEFT(lcfechasis,4) + " "+lchorasis
	ltfecsis = CTOT(lcfecsis)
	lcfecexe = RIGHT(lcfechaexe,2)+"/"+LEFT(RIGHT(lcfechaexe,4),2)+"/"+LEFT(lcfechaexe,4) + " "+lchoraexe
	ltfecexe = CTOT(lcfecexe)
	
	IF ltfecexe < ltfecsis
	*IF lcfechaExe # lcfechasis OR lchoraExe # lchorasis
		lcRespuesta = "EXISTE UNA NUEVA VERSION DEL SISTEMA "+CHR(13)+CHR(13)+UPPER(lcExe)+CHR(13);
							+"Fecha :  "+RIGHT(lcfechasis,2)+"-"+SUBSTR(lcfechasis,5,2)+"-"+LEFT(lcfechasis,4)+"    hora :  "+lchorasis+CHR(13)+CHR(13);
							+"Prioridad : "+lcMensaje
		
	
	ENDIF	       	
ENDIF
   
IF USED("Csrsistema")
	USE IN Csrsistema 
ENDIF

RETURN lcRespuesta 


*-----------------------------------------------------------------------------
FUNCTION LeerConfigTermi

oConfigTermi = CREATEOBJECT("Custom")
oConfigTermi.AddProperty('FoxyPreviewer',"FALSE")
oConfigTermi.AddProperty('ShowBalloonTip',"FALSE")
oConfigTermi.AddProperty('FontName_TextBox',"Tahoma")
oConfigTermi.AddProperty('FontName_Header',"Tahoma")
oConfigTermi.AddProperty('FontName_Label',"Tahoma")
oConfigTermi.AddProperty('FontName_Column',"Tahoma")
oConfigTermi.AddProperty('MenuRibbon',"FALSE")
oConfigTermi.AddProperty('MenuDashBoard',"FALSE")
oConfigTermi.AddProperty('NetDriveFileCtacte','C:\Documentos')
oConfigTermi.AddProperty('NetDriveGS1','C:\GS1') &&Ruta de la carpeta donde se almacena gs1
oConfigTermi.AddProperty('ActivarSyncSucursal','FALSE')   &&se abre el regprocesosync al iniciar
oConfigTermi.AddProperty('NetDriveDevoluciones','J:\Devoluciones')  &&Ruta de la carpeta devoluciones en cobranzas
oConfigTermi.AddProperty('LogPrinter','FALSE')  &&Ruta de la carpeta devoluciones en cobranzas

LOCAL i,LenRegistro,Arc,lcActDato,lntamano,XX
i = 1

cFile = ADDBS(SYS(5)+CURDIR())+'SETUP.INI'

IF FILE(cFile)
	*stop()
	Adir(lCarray,cFile)
	lntamano = lCarray[1,2]
    
	Arc = FOPEN(cFile)
	LenRegistro = lntamano
	DO WHILE !FEOF(Arc)
		*lcActDato			=FREAD(Arc,LenRegistro)
		lcActDato = FGETS(Arc)
		i = AT(']',lcActDato) + 1
		IF i#1 &&No existe label. Por lo tanto es parte de el dato anterior
	   	    	lclabel = CHRTRAN(UPPER(LEFT(lcActDato,i-1)),']','')
	   	    	lclabel = CHRTRAN(lclabel,'[','')
	   	ELSE
	   		lcActDato = CHR(13)+lcActDato
	   	ENDIF 
	   	&&Solo lo haremos para los campos encriptados
		DO case
			CASE lclabel="FOXYPREVIEWER"
				oConfigTermi.FoxyPreviewer =  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="SHOWBALLOONTIP"
				oConfigTermi.ShowBalloonTip =  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="FONTNAME_TEXTBOX"
				oConfigTermi.FontName_TextBox=  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="FONTNAME_HEADER"
				oConfigTermi.FontName_Header=  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="FONTNAME_LABEL"
				oConfigTermi.FontName_Label=  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="FONTNAME_COLUMN"
				oConfigTermi.FontName_Column=  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="MENURIBBON"
				oConfigTermi.MenuRibbon=  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="MENUDASHBOARD"
				oConfigTermi.MenuDashBoard=  ALLTRIM(SUBSTR(lcActDato,i))
			CASE lclabel="NETDRIVEFILECTACTE"
				oConfigTermi.NetDriveFileCtacte=  ALLTRIM(SUBSTR(lcActDato,i))	
			CASE lclabel="NETDRIVEGS1"
				oConfigTermi.NetDriveGS1=  ALLTRIM(SUBSTR(lcActDato,i))	
			CASE lclabel="ACTIVARSYNCSUCURSAL"
				oConfigTermi.ActivarSyncSucursal=  ALLTRIM(SUBSTR(lcActDato,i))		
			CASE lclabel="NETDRIVEDEVOLUCIONES"
				oConfigTermi.NetDriveDevoluciones=  ALLTRIM(SUBSTR(lcActDato,i))		
			CASE lclabel="LOGPRINTER"
				oConfigTermi.LogPrinter=  ALLTRIM(SUBSTR(lcActDato,i))
				
		ENDCASE		 
	ENDDO 
                    
	FCLOSE(Arc)
ENDIF 
IF NOT FILE(cFile)
	Arc = FCREATE(cFile)
	LenRegistro = 100
	IF arc#0
		lclabel="[FoxyPreviewer]" + oConfigTermi.FoxyPreviewer 
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[ShowBalloonTip]" + oConfigTermi.ShowBalloonTip
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[MenuRibbon]" + oConfigTermi.MenuRibbon
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[MenuDashBoard]" + oConfigTermi.MenuDashBoard
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[FontName_TextBox]" + oConfigTermi.FontName_TextBox
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[FontName_Header]" + oConfigTermi.FontName_Header
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[FontName_Label]" + oConfigTermi.FontName_Label
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[FontName_Column]" + oConfigTermi.FontName_Column
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[NetDriveFileCtacte]" + oConfigTermi.NetDriveFileCtacte
		XX= FPUTS(Arc,lclabel,lenregistro)
		lclabel="[ActivarSyncSucursal]" + oConfigTermi.ActivarSyncSucursal
		XX= FPUTS(Arc,lclabel,lenregistro)	
		lclabel="[NetDriveDevoluciones]" + oConfigTermi.NetDriveDevoluciones
		XX= FPUTS(Arc,lclabel,lenregistro)	
		lclabel="[LogPrinter]" + oConfigTermi.LogPrinter
		XX= FPUTS(Arc,lclabel,lenregistro)		
	ENDIF 	
	FCLOSE(Arc)
ENDIF 

IF oConfigTermi.FoxyPreviewer = 'TRUE'

	*SET PROCEDURE TO LOCFILE("FoxyPreviewer.App") ADDITIVE 


ENDIF 

ENDFUNC 


*---------------------------------------------------------------------------------
FUNCTION CargarXML
PARAMETERS lcFile,lcAlias

lcPath = ''
IF LEN(LTRIM(lcPath)) = 0
	lcPath = ADDBS(SYS(5)+CURDIR())+'Config'
ENDIF 
IF LEN(LTRIM(lcFile)) = 0
	oavisar.programador('No se especifico el nombre del archivo xml a abrir.')
	RETURN .f.
ENDIF 

IF NOT DataCursor(lcAlias)
	oavisar.usuario('Estructura de tabla '+lcAlias+ ' no definida')
	RETURN .f.
ENDIF 

lcFile = ADDBS(lcPath) + lcFile
IF NOT FILE(lcFile)
	oavisar.programador('No se encontro el archivo'+CHR(13)+lcFile )
	RETURN .f.
ELSE
	SET SAFETY OFF 
*!*		IF USED(lcAlias)
*!*			USE IN (lcAlias)
*!*		ENDIF 
	SELECT(lcAlias)
	*vista()
	XMLTOCURSOR(lcFile,'',512+8192)
	SET SAFETY ON 	
	*SELECT * FROM cTempCursor INTO CURSOR &lcAlias READWRITE 
ENDIF 
RETURN .t.

*------------------------------------------------------------------------------------
FUNCTION GuardarXML
PARAMETERS lcFile,lcAlias

lcPath = ''
IF LEN(LTRIM(lcPath)) = 0
	lcPath = ADDBS(SYS(5)+CURDIR())+'Config'
ENDIF 
IF LEN(LTRIM(lcFile))=0
	oavisar.programador('No se especifico el nombre del archivo xml a guardar.')
	RETURN 
ENDIF 

lcFile = ADDBS(lcPath) + lcFile

SET SAFETY OFF 
CursorAdapterToXML(lcAlias,lcFile)
SET SAFETY ON
	
RETURN 

*-------------------------------------------------------------

FUNCTION LimpiarCadena
PARAMETERS lcCadena

lcCadena = STRTRAN(lcCadena,'"','')
lcCadena = STRTRAN(lcCadena,"'",'')
lcCadena = STRTRAN(lcCadena,'.','')
RETURN lcCadena
*----------------------------------------------------------------

FUNCTION TrazaQuery
PARAMETERS lcNameQueary,nTipo,tInicio
ntipo 	= IIF(PCOUNT()<2,0,ntipo)
tInicio	= IIF(PCOUNT()<3,DATETIME(),tInicio)

cTiempo = strtrim((DATETIME() - tInicio ),11)
IF VAL(ctiempo)=0
	RETURN 
ENDIF 
IF TYPE('Ocmd')='O'	
	cTiempo = strtrim((DATETIME() - tInicio ),11)
	
	IF nTipo = 0
		TEXT TO cCmdQuery TEXTMERGE NOSHOW 
		INSERT INTO logQuery (TERMINAL,PROGRAMA,NAMEQUERY,TIPO) VALUES (<<goapp.terminal>>,'<<goapp.programa>>','<<lcNameQueary>>',0)
		ENDTEXT 
	ELSE
		TEXT TO cCmdQuery TEXTMERGE NOSHOW 
		INSERT INTO logQuery (TERMINAL,PROGRAMA,NAMEQUERY,TIPO,RETARDO) VALUES (<<goapp.terminal>>,'<<goapp.programa>>','<<lcNameQueary>>',1,'<<cTiempo>>')
		ENDTEXT 
	ENDIF 
	=SaveSQL(cCmdQuery,'TrazaQuery')
  
	Oca = Ocmd
	Oca.commandtext = cCmdQuery
	Oca.commandtype = 1
	nintento = 0
	LOCAL loCatchErr As Exception
	ldebociclar = .t.
	DO WHILE ldebociclar AND nintento < 5
	   ldebociclar = .f.
		TRY 
		  Oca.execute()
		CATCH TO loCatchErr
	 	  ldebociclar = .t.
	 	  nintento = nintento + 1 
		ENDTRY   
	ENDDO 
	IF ldebociclar
		oavisar.usuario(loCatchErr.Message)
	ENDIF 
ENDIF 		

FUNCTION STOD
PARAMETERS oFecha

sFecha = oFecha
IF VARTYPE(oFecha)$'N'
	sFecha = STR(oFecha,8)
ENDIF 
sFecha = RIGHT(sFecha,2)+'-'+LEFT(RIGHT(sFecha,4),2)+'-'+LEFT(sFecha,4)

RETURN CTOD(sFecha)


*----------------------------------------------------------------------------
* FUNCION LeerVtoCertificado(OscParametros)
*----------------------------------------------------------------------------
* Funcion que valida la fecha de certificados electronicos
*----------------------------------------------------------------------------
FUNCTION LeerVtoCertificado
PARAMETERS OscParametros
LOCAL lcCmd,lok

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrParaVario.* FROM ParaVario as CsrParaVario
where nombre='CAE_VTO'
ENDTEXT 

IF !CrearCursorAdapter("CsrCursor",lcCmd)
	Oavisar.usuario('Error al obtener datos')
ENDIF 

IF RECCOUNT('CsrCursor') = 0
	oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso para determinar la fecha de vencimiento de los certificados electronicos'+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
	RETURN .T.
ENDIF 

dFechaFac	= stod(OscParametros.nrocajafac)
dFechaCert	= TTOD(CsrCursor.fecha)
IF dFechaFac >= dFechaCert
	oavisar.usuario('ADVERTENCIA'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos estan VENCIDOS'+CHR(13)+CHR(13)+'')
	RETURN .f.
ENDIF 

IF dFechaFac + 1  >= dFechaCert
	oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos venceran en MA�ANA '+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
	RETURN .T.
ENDIF 

IF dFechaFac + 2  >= dFechaCert
	oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos venceran en menos de 2 DIAS '+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
	RETURN .T.
ENDIF 

IF dFechaFac + 3  >= dFechaCert
	oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos venceran en menos de 3 DIAS '+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
	RETURN .T.
ENDIF 

IF dFechaFac + 7  >= dFechaCert
	oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos venceran en menos de 7 DIAS '+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
	RETURN .T.
ENDIF 

IF dFechaFac + 15  >= dFechaCert
	oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos venceran en menos de 15 DIAS '+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
	RETURN .T.
ENDIF 

*!*	IF GOMONTH(dFechaFac,1) >= dFechaCert AND DAY(dFechaFac) < 4
*!*		oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos venceran en menos de 1 MESES '+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
*!*		RETURN .T.
*!*	ENDIF 


*!*	IF GOMONTH(dFechaFac,2) >= dFechaCert AND DAY(dFechaFac) < 4
*!*		oavisar.usuario('OBSERVACION'+CHR(13)+CHR(13)+'Contacte a un usuario con permiso, los certificados electronicos venceran en menos de 2 MESES '+CHR(13)+CHR(13)+'PUEDE CONTINUAR')
*!*		RETURN .T.
*!*	ENDIF 



IF USED("CsrCursor")
	USE IN CsrCursor
ENDIF

RETURN .t.

*----------------------------------------------------
*---Pasaje a FTP
*----------------------------------------------------
FUNCTION FTP
Parameters oFTP,cPaso ,cOrig,cArch,cDesti 

lcrutadest = IIF(PCOUNT()<5,'',cDesti)

Wait Window "Conectando con el Servidor" Nowait 
lcrutafuen = ADDBS(cOrig) 
lcArchivo = cArch 
Wait Window "enviando "+Alltrim(lcArchivo)+" " Nowait 

cSend = "PUT "+lcrutafuen+Alltrim(lcArchivo)+" "+Alltrim(lcrutadest)+"/"+Alltrim(lcArchivo)+""
oFTP.EXECUTE(cPaso,cSend) && Agrega el archivo 
Do While oFTP.stillexecuting=.T. 
Loop && espera para que termine 
Enddo 

oFTP.EXECUTE(cPaso,"quit") && salir 
Wait Window "Cerrando conexi�n" Nowait 
Do While oFTP.stillexecuting=.T. 
Loop && espera 
Enddo 
oFTP.EXECUTE(cPaso,"close") && cerrar conexion 
Wait Window "Saliendo de la conexion" Nowait 
Do While oFTP.stillexecuting=.T. 
Loop 
Enddo


*-----------------------------------------------------
*--Redondeo
*-----------------------------------------------------

FUNCTION A_RED
parameters _aredondeo,_aimporte

if _Aredondeo<>0
   _Aimporte=red(_Aimporte,4)
   _Decimales=red((_Aimporte - int(_Aimporte) ),3)
   _resul=int(_decimales/_aredondeo)
   _resto=mod(_decimales,_Aredondeo)
   if _Resto>0
      _Aimporte=int(_Aimporte)+(_aredondeo*(_resul+1))
   endif
endif
return _Aimporte

Function ProximoRedondeo
	Lparameters nValue, nNearest
	Local nRemainder, nReturn

	nRemainder = Mod(m.nValue, m.nNearest)
	If m.nRemainder >= m.nNearest/2
		nReturn = m.nValue + (m.nNearest - m.nRemainder)
	Else
		nReturn = m.nValue - m.nRemainder
	Endif

	Return m.nReturn

Endfunc
*----------------------------------------------------
*-Retardo
*----------------------------------------------------
FUNCTION Retardo
LPARAMETERS nSec
*nSec = Numero de segundos de retardo
LOCAL nSecond1,nSecond2
nSecond1 = SECONDS()
nSecond2 = SECONDS()
DO WHILE nSecond1 + nSec > nSecond2
	nSecond2 = SECONDS()
ENDDO 
ENDFUNC 

*----------------------------------------------------
*-Quitar Acentos
*----------------------------------------------------
FUNCTION QuitarAcentos
LPARAMETERS ccadena
ccadena = CHRTRAN(ccadena, "����������","aeiouAEIOU") 
RETURN ccadena
ENDFUNC 

*-------------------------------------------------------
FUNCTION CursorAdapterToXML
PARAMETERS cAlias,cFileName,cEncoding,nOutputFormat,nFlags
cEncoding		= IIF(PCOUNT()<3,"iso-8859-1",cEncoding)
nOutputFormat	= IIF(PCOUNT()<4,1,nOutputFormat)
nFlags			= IIF(PCOUNT()<5,16,nFlags)
LOCAL cXMLLocal

SET SAFETY OFF 
CURSORTOXML(cAlias,"cXMLLocal",nOutputFormat,nFlags)
cXMLLocal=STRTRAN(cXMLLocal, 'encoding="Windows-1252"', 'encoding="'+cEncoding+'"')
= STRTOFILE(cXMLLocal,cFileName)
SET SAFETY ON 


*-----------------------------------------------------------
*-Copiar Cursor
*-----------------------------------------------------------
FUNCTION CopyCursor
LPARAMETERS tcSql, tcAlias
LOCAL lnSelect, lcSql
*** Guardar el �rea de trabajo
lnSelect = SELECT(0)
*** No existe el cursor
IF NOT USED( tcAlias )
  *** Crearlo directamente
  lcSql = tcSql + " INTO CURSOR " + tcAlias + " READWRITE"
  &lcSql
ELSE
  *** El cursor existe, utilizo un select seguro
  lcSql = tcSql + " INTO CURSOR curdummy"
  &lcSql
  *** Limpiar y actualizar el cursor de trabajo
  SELECT (tcAlias)
  ZAP IN (tcAlias)
  APPEND FROM DBF('curdummy')
  USE IN curdummy 
ENDIF
*** Restablecer el �rea de trabajo y devolver el estado
SELECT (lnSelect)
RETURN USED(tcAlias)

*------------------------------------------------------------
*-Mensaje de Error para operadores del sistema
*------------------------------------------------------------
FUNCTION VerErrorSQL
PARAMETERS nError

LOCAL cMensaje
DO CASE 
CASE nError=0
	cMensaje = ""
OTHERWISE 
	cMensaje = ""
ENDCASE
RETURN cMensaje
ENDFUNC 
*------------------------------------------------------------

FUNCTION IDKeyPlanCue
PARAMETERS nID,nEjercicio
nID = IIF(PCOUNT()<1,0,nId)
nEjercicio = IIF(PCOUNT()<2,goapp.ejercicio,nEjercicio)

IF nId = 0
	oavisar.usuario('El valor de identificador del plan de cuentas es 0.')
	RETURN .f.
ENDIF 
RETURN (nId*1000)+nEjercicio

*--------------------------------------------------------------
*--------------------------------------------------------------

FUNCTION ExisteCarpeta
PARAMETERS cRuta,lCrear
lCrear = IIF(PCOUNT()<2,.t.,lCrear)

SET SAFETY OFF 
IF (cRuta$SYS(5)) OR  LEN(cRuta)=0
	RETURN SYS(5)+'\'
ENDIF 
IF !DIRECTORY(cRuta)
	MKDIR &cRuta
ENDIF 	
SET SAFETY ON 

RETURN cRuta
*------------------------------------------------------
*------------------------------------------------------
FUNCTION LenTrim
PARAMETERS cDato

IF VARTYPE(cDato)<>'C'
	oavisar.usuario("Error Function LenTrim() requiere un dato caracter")
	RETURN 0
ENDIF 
RETURN LEN(ALLTRIM(cDato))
*-----------------------------------------------------
*-----------------------------------------------------
FUNCTION ObtenerSerialDisck

#DEFINE wbemFlagReturnImmediately 0x10
#DEFINE wbemFlagForwardOnly 0x20
*
LOCAL llError
*
ON ERROR llError = .F.
*
LOCAL loWMIService, loColumnas, loItem
LOCAL lcNameSpace, lcWQL, lcPC
*
STORE .NULL. TO loWMIService, loColumnas, loItem && Variables locales.
STORE SPACE( 0 ) TO lcWQL &&Sentencia SQL (WQL).
*
loWMIService = GETOBJECT("winmgmts:\\" ) 
*
lcWQL = "SELECT * FROM Win32_PhysicalMedia"
*
loColumnas = loWMIService.ExecQuery( lcWQL, "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)
*
cSerialNumber = ""
FOR EACH loItem IN loColumnas
	IF 'PHYSICALDRIVE0'$loItem.Tag
		cSerialNumber = loItem.SerialNumber
	ENDIF 
ENDFOR
*
RELEASE loWMIService, loColumnas, loItem

RETURN cSerialNumber


*----------------------------------------------------------------------------
* FUNCION ExcelVistaPreviaGrupo(Objeto,Grupos)
*----------------------------------------------------------------------------
* Crea el objeto que interactua para generar la salida por excel para vista previa
* El Objeto debe ser pasado por referencia
* Este objeto contendra las columnas por grupo
* Grupos = la cantidad de grupos.
*----------------------------------------------------------------------------
FUNCTION ExcelVistaPreviaGrupo
PARAMETERS loObjeto,lnGrupos
lnGrupos = IIF(PCOUNT()<2,0,lnGrupos)

loObjeto = CREATEOBJECT("Custom")
WITH loObjeto
	.AddProperty('recortarheader',.f.) &&Indica si el titulo se divide en filas
	.AddProperty('cuantos',lnGrupos)
	FOR i=1 TO lnGrupos
		&&Se vuelve a crear el objeto, pq sino todos hacen referencia al mismo
		ObjGrupo = CREATEOBJECT("Custom")
		ObjGrupo.AddProperty('NameGroup',"") &&Titulo del Grupo
		ObjGrupo.AddProperty('ListColumns',null)  &&Arreglo con los nombre de los campos
		ObjGrupo.AddProperty('Columns',0) &&Cantidad de columnas
		ObjGrupo.AddProperty('HeaderVisible',.t.)
		.AddProperty('Grupo'+strzero(i,3),ObjGrupo) 
		
		ObjGrupo=null
	NEXT 
ENDWITH 
RETURN

*-------------------------------------------------------
* FUNCTION AsociarColumnaGrupo
*-------------------------------------------------------
* Asocia un objeto columna al grupo
* cObjetoGrupo = Nombre del objeto grupo
* nGrupo = Numero del grupo a asociar
* nColumna = Cantidad de columnas a asociar
FUNCTION AsociarColumnaGrupo
PARAMETERS cObjetoGrupo,nGrupo,nColumna
cObjetoGrupo= IIF(PCOUNT()<1,"",cObjetoGrupo)
nGrupo		= IIF(PCOUNT()<2,0,nGrupo)
nColumna	= IIF(PCOUNT()<3,1,nColumna)

IF EMPTY(cObjetoGrupo) AND nGrupo>0
	oavisar.PROGRAMADOR("Falta definir el objeto grupo o el grupo")
	RETURN .f.
ENDIF 
LOCAL cObjeto,oObjeto,cGrupo,oGrupo

cObjeto = cObjetoGrupo + ".Grupo" + strzero(nGrupo,3)
oObjeto	= &cObjeto
=ExcelVistaPrevia(@oObjeto,nColumna,.t.,.f.)
cGrupo	= cObjetoGrupo + ".Grupo" + strzero(nGrupo,3)
oGrupo	= &cGrupo
oGrupo	= oObjeto
oGrupo.Columns = nColumna

RETURN 		
*----------------------------------------------------------------------
*FUNCTION ArmarComproba
*----------------------------------------------------------------------
* Formateamos la representacion del comprobante
* uniendo coomprobante+letra+talonario+numero
* Ejemplo ArmarComproba('FACTURA','A','0001','00012368')
*			= 'FACTURA A 0001-00012368'
* lcComproba = Nombre del comprobante
* lcLetra	 = Letra del comprobante
* lcTalonario= Talonario del comprobante
* lcNumcomp	 = Numero del comprobante
*----------------------------------------------------------------------
FUNCTION ArmarComproba
LPARAMETERS lcComproba,lcLetra,lcTalonario,lcNumComp,lCompleto
lcComproba	= IIF(PCOUNT()<1,'',lcComproba)
lcLetra		= IIF(PCOUNT()<2,'',lcLetra)
lcTalonario	= IIF(PCOUNT()<3,'',lcTalonario)
lcNumComp	= IIF(PCOUNT()<4,'',lcNumComp)
lCompleto	= IIF(PCOUNT()<5,.f.,lCompleto)
IF EMPTY(lcComproba)
	oavisar.usuario('ArmarComproba() falta definir descripci�n del comprobante')
	RETURN ""
ENDIF 
IF EMPTY(lcNumComp) AND NOT lCompleto
	oavisar.usuario('ArmarComproba() falta definir el numero del comprobante')
	RETURN ""
ENDIF 
IF lCompleto
	cNum = rtrim(lcComproba)
	RETURN LEFT(cNum,1)+" "+SUBSTR(cNum,2,4)+"-"+RIGHT(cNum,8)
ELSE
	RETURN ALLTRIM(lcComproba)+" "+lcLetra+" "+lcTalonario+"-"+lcNumComp
ENDIF 

*Funcion modificada para mandar la clave de busqueda
FUNCTION seek_dato
PARAMETERS tcdatobuscado,tbtipobusqueda,tbtabla,tbclave
tbtabla 	= IIF(PCOUNT()<3,"",tbtabla)
tbclave	= IIF(PCOUNT()<4,"",tbclave)
llok = .t.

IF tbtipobusqueda
	SET NEAR ON
ELSE
	SET NEAR OFF
ENDIF
IF LEN(LTRIM(tbtabla))=0 AND LEN(LTRIM(tbclave))=0
	SEEK(tcdatobuscado)
ELSE 
	llok = SEEK(tcdatobuscado,tbtabla,tbclave)
ENDIF 
SET NEAR OFF
RETURN llok

*---------------------------------------------------------------------------
* FUNCTION LeerCajaActivaOtroEjercicio(idejercicioaleer)
*---------------------------------------------------------------------------
*Si el ejercicio a leer es diferente al ejercicio del sistema.
*Configuramos el paraconfig para que use el ejercicioaleer y busque
*a su vez, la primera caja abierta en ese ejercicio.
*---------------------------------------------------------------------------
FUNCTION LeerCajaActivaOtroEjercicio(oForm,nidejercicioaleer,nUltima)
LOCAL nidejercicio
oform = IIF(PCOUNT()<1,null,oForm)
nidejercicio = IIF(PCOUNT()<2,goapp.idejercicio,nidejercicioaleer)
nUltima = IIF(PCOUNT()<3,0,nUltima)


IF ISNULL(oForm)
	RETURN 
ENDIF 
IF VARTYPE(oForm.buscarcajaactiva)$'XU'
	oForm.addproperty('buscarcajaactiva',.f.)
ENDIF 
IF VARTYPE(oForm.usarcajaactiva)$'XU'
	oForm.addproperty('usarcajaactiva',.t.)
ENDIF 


IF !USED('CsrParaConfig')
	RETURN 
ENDIF 
IF RECCOUNT('CsrParaconfig')=0
	RETURN 
ENDIF 
IF !oForm.buscarcajaactiva
	RETURN 
ENDIF 


IF nidejercicio != CsrParaConfig.idejercicio &&o goapp.idejercicioactual &&NO goapp.idejercicio
	oForm.usarcajaactiva = .f.
ENDIF 

IF !oForm.usarcajaactiva
	oForm.lnidejercicio	= goapp.idejercicio
		
	LOCAL oEjercicioActivo as Object 
	LeerEjercicioActivo (@oEjercicioActivo,1+nUltima) &&Si es 2, busca la caja mas cercana
	IF oEjercicioActivo.idcajaactual != 0
		
		replace iddetanrocaja WITH oEjercicioActivo.idcajaactual,nrocaja WITH oEjercicioActivo.cajaactual;
					,pefiscal WITH oEjercicioActivo.peFiscalCaja;
					,fecdesde WITH oEjercicioActivo.fecCajadesde;
					,fecHasta WITH oEjercicioActivo.fecCajahasta IN CsrParaConfig
	ELSE
		=Oavisar.usuario("Debe cambiar parametros diarios;"+CHR(13);
			+ "no se encontro CAJA ACTIVA ABIERTA"+CHR(13)+CHR(13);
			+"UTILES \\ PARAMETROS \\ PARAMETROS DIARIOS")
		
		replace iddetanrocaja WITH 0,nrocaja WITH 000000 ,pefiscal WITH "000000";
			,fecdesde WITH CTOD('01-01-1900') IN CsrParaConfig
			
	ENDIF 
	RELEASE oEjercicioActivo
ENDIF 
RETURN 
ENDFUNC 

*----------------------------------------------------------------------------
* FUNCION Grabar_Sec(tcTexto,tcArchivo,tcCarpeta)
*----------------------------------------------------------------------------
*Grabamos secuencias de comenados en un archivo
*tcTexto = Secuencia
*tcArchivo = Nombre del Archivo
*tcCarpeta = Ruta del archivo
*----------------------------------------------------------------------------
Function GRABAR_SEC

Parameters tcTexto,tcArchivo,tcCarpeta

Private plRet, pnFich, pnFichn, pnFtama, pnTammax, pnLongAc
Private pcChar, pnPos,Lcdirlog,Lcfilelog,Lcnewlog

*stop()
tcArchivo=IIF(PCOUNT()<2,'Secuencia'+DTOS(DATE())+'.txt',tcArchivo)
tcCarpeta=IIF(PCOUNT()<2,'Sec',tcCarpeta)

IF AT(":",tcCarpeta)=0
	Lcdirlog=Sys(5)+Sys(2003)+'\'+tcCarpeta
ELSE
	Lcdirlog = tcCarpeta
ENDIF 
Lcfilelog=ADDBS(Lcdirlog)+tcArchivo
LcNewlog= ADDBS(Lcdirlog)+'New'+ALLTRIM(tcArchivo)

If !Directory(Lcdirlog)
	Md (Lcdirlog)
Endif

plRet    = .T.
pnLongAc = 0
pnTammax = 600000
pnFtama = 0

tcTexto=Ttoc(Datetime())+' , '+tcTexto

If File(Lcfilelog)                && �Existe el archivo?
	pnFich = Fopen(Lcfilelog,12)  && S�: abrir lect./escrit.
	pnFtama=Fseek(pnFich, 0, 2)                     && Mueve el puntero a EOF
&& y devuelve el tama�o
Else
	pnFich = Fcreate(Lcfilelog)   && Si no, crearlo
Endif
If pnFich < 0                                       && Comprobar el error
&& abriendo el archivo
	plRet = .F.
	Wait 'No puedo abrir o crear el archivo de salida (fich)' Window Nowait
Else                                                && Si no hay error,
&& escribir en el archivo
	If pnFtama > pnTammax                           && Si el tama�o es mayor que el max
		pnFichn = Fcreate(Lcnewlog)    && Crear nuevo log
		If pnFichn < 0
			Wait 'No puedo abrir o crear el archivo de salida (fichn)' Window Nowait
		Else
			pnPos = Fseek(pnFich, -(pnTammax - 256), 1)
			pcChar = Fread(pnFich, 1)
			Do While pcChar <> Chr(10)
				pcChar = Fread(pnFich, 1)
			Enddo
			pnPos = Fseek(pnFich, 0, 1)
			Do While Not(Feof(pnFich))
				= Fputs(pnFichn,Fgets(pnFich))
			ENDDO
			
			=Fclose(pnFich)
			=Fclose(pnFichn)
			
			Delete File &Lcfilelog
			Rename &Lcnewlog To &Lcfilelog
			pnFich = Fopen(Lcfilelog,12)
			pnFtama=Fseek(pnFich, 0, 2)
		Endif
	Endif
	=Fputs(pnFich, tcTexto)
Endif
=Fclose(pnFich)                                    && Cerrar archivo

Return plRet

*----------------------------------------------------------------------------
* FUNCION TtoS(tFecha)
*----------------------------------------------------------------------------
* Crea la cadena con el formato de un datetime que reconoce SQL
* tFecha Fecha de tipo datetime 
*----------------------------------------------------------------------------
FUNCTION TtoS
PARAMETERS tFecha

cFecha = LEFT(TTOC(tFecha),10)
cFecha = DTOS(CTOD(cFEcha))
cHora = strzero(HOUR(tFecha),2)+":"+strzero(MINUTE(tFecha),2)+":"+strzero(SEC(tFecha),2)

RETURN cFEcha+" "+cHora

*----------------------------------------------------------------------------
* FUNCION ArmarFechaWhere(cCampo,cFechaDesde,cFechaHasta)
*----------------------------------------------------------------------------
* Crea la cadena con el campo de donde debe buscarse las fechas
* cCampo nombre del campo donde se hace refrencia a la busqueda
* cFechaDesde campo caracter de donde se debe buscar la fecha
* cFechaHasta campo caracter de donde se debe buscar la fecha
*----------------------------------------------------------------------------
FUNCTION ArmarFechaWhere
PARAMETERS cCampo,cFechaDesde,cFechaHasta

cCampo = ALLTRIM(IIF(PCOUNT()<1,"fecha",cCampo))
cFechaDesde = IIF(PCOUNT()<2,"",cFechaDesde)
cFechaHasta = IIF(PCOUNT()<3,"",cFechaHasta)
LOCAL lHayFechaDesde,lHayFechaHasta,cWhere
cWhere = ""
*Tres Posibilidades 
*Si existen ambas fechas se arma un between
*Si solo existe una si es desde entonces >= , sino es hasta entonces <=
lHayFechaDesde = IIF(LEN(LTRIM(cFechaDesde))#0,.t.,.f.)
lHayFechaHasta = IIF(LEN(LTRIM(cFechaHasta))#0,.t.,.f.)
IF lHayFechaDesde AND lHayFechaHasta
	cWhere = " (" + cCampo + " BETWEEN '"+DTOS(CTOD(cFechaDesde)) + "' and '" + DTOS(CTOD(cFechaHasta))+ "')"
ELSE
	cWhere = IIF(lHayFechaDesde OR lHayFechaHasta," " + cCampo + IIF(lHayFechaDesde," >= "," <= ") + " '" +DTOS(CTOD(IIF(lHayFechaDesde,cFechaDesde,cFechaHasta)))+"' ","")
ENDIF 
RETURN  cWhere
*----------------------------------------------------------------------------
* FUNCION ExcelVistaPrevia(Objeto,Columnas,Titulo)
*----------------------------------------------------------------------------
* Crea el objeto que interactua para generar la salida por excel para vista previa
* El Objeto debe ser pasado por referencia
* Columnas = la cantidad de columnas.
* Titulo = Por defecto determina si el titulos se divide en filas
*----------------------------------------------------------------------------
FUNCTION ExcelVistaPrevia
PARAMETERS loObjeto,lnColumnas,llTitulo,llInit
lnColumnas = IIF(PCOUNT()<2,0,lnColumnas)
lltitulo = IIF(PCOUNT()<3,.t.,llTitulo)
llInit	= IIF(PCOUNT()<4,.t.,llInit)

IF llInit
	loObjeto = CREATEOBJECT("Custom")
ENDIF 

WITH loObjeto
	.Addproperty('cuantos',lnColumnas) &&Indica la cantidad de columnas
	.AddProperty('recortarheader',lltitulo) &&Indica si el titulo se divide en filas
	
	FOR i=1 TO lnColumnas
		&&Se vuelve a crear el objeto, pq sino todos hacen referencia al mismo
		ObjColumna = CREATEOBJECT("Custom")
		ObjColumna.AddProperty('Header',"") &&Indica el nombre del encabezado
		ObjColumna.AddProperty('BodyFormat','')  &&Indica el formato del cuerpo
		ObjColumna.AddProperty('Ajusta',.f.) &&Siempre es verdadero. Si se quiere Que el ancho funcione
		ObjColumna.AddProperty('BodyWidth',-1) &&Determina en caso que exista un ancho especifico para la columna
		
		.AddProperty('Column'+strzero(i,3),ObjColumna) 
		
		ObjColumna=null
	NEXT 
ENDWITH 
RETURN 
*----------------------------------------------------------------------------
* FUNCION StoC(lcFecha)
*----------------------------------------------------------------------------
* De String fecha sin formato a String con formato
*----------------------------------------------------------------------------
FUNCTION StoC
PARAMETERS lcFecha
lcfecha = alltrim(lcFecha)
IF LEN(lcFecha)#8
	RETURN "01-01-1900"
ENDIF 
RETURN RIGHT(lcfecha,2)+"-"+LEFT(RIGHT(lcfecha,4),2)+"-"+LEFT(lcfecha,4)

*----------------------------------------------------------------------------
* FUNCION SaveSQL(lcCmd,lcArchivo,llgenera)
*----------------------------------------------------------------------------
* Guarda la consulta al motor
*----------------------------------------------------------------------------
FUNCTION SaveSQL
PARAMETERS lcCmd,lcArchivo,llgenera
llgenera = IIF(PCOUNT()<3,.f.,llgenera)

IF LEN(LTRIM(lcCmd))=0
	RETURN 
ENDIF 
IF LEN(LTRIM(lcArchivo))=0
	RETURN 
ENDIF 
lldesarrollo=(_vfp.startmode()#4)
lcRuta = SYS(5)+ "\tempsql\"+ALLTRIM(goapp.initcatalo)
IF VARTYPE(goapp.rutaaplicacion)$'C' AND NOT lldesarrollo
	lcRutaApli = IIF(LEN(ALLTRIM(goapp.rutaaplicacion))#0,goapp.rutaaplicacion,"")
	lcRutaApli = RTRIM(lcRutaApli) + IIF(RIGHT(lcRutaApli,1)="\" or LEN(LTRIM(lcRutaApli))=0,"","\") &&Si es vacio o tiene \. Mantiene lo mismo.
	lcRuta = IIF(LEN(LTRIM(lcRutaApli))#0,lcRutaApli+ "tempsql",lcRuta)	
ENDIF 
IF llgenera &&Determinamos que queres que siempre se guarde
	IF !DIRECTORY(lcRuta)
		MKDIR &lcRuta
	ENDIF 
ENDIF 
SET SAFETY OFF 
= STRTOFILE(lccmd,lcRuta+"\"+lcArchivo+".txt")
SET SAFETY ON 

RETURN 
*----------------------------------------------------------------------------
* FUNCION SaveFile(lcCmd,lcArchivo,llgenera)
*----------------------------------------------------------------------------
* Guarda la consulta al motor
*----------------------------------------------------------------------------
FUNCTION SaveFile
PARAMETERS lcCmd,lcArchivo,lcExten,llgenera
llgenera = IIF(PCOUNT()<4,.f.,llgenera)
lcExten = IIF(PCOUNT()<3,'txt',lcExten)

IF LEN(LTRIM(lcCmd))=0
	RETURN 
ENDIF 
IF LEN(LTRIM(lcArchivo))=0
	RETURN 
ENDIF 
lldesarrollo=(_vfp.startmode()#4)
lcRuta = SYS(5)+ "\tempsql\"+ALLTRIM(goapp.initcatalo)
IF VARTYPE(goapp.rutaaplicacion)$'C' AND NOT lldesarrollo
	lcRutaApli = IIF(LEN(ALLTRIM(goapp.rutaaplicacion))#0,goapp.rutaaplicacion,"")
	lcRutaApli = RTRIM(lcRutaApli) + IIF(RIGHT(lcRutaApli,1)="\" or LEN(LTRIM(lcRutaApli))=0,"","\") &&Si es vacio o tiene \. Mantiene lo mismo.
	lcRuta = IIF(LEN(LTRIM(lcRutaApli))#0,lcRutaApli+ "tempsql",lcRuta)	
ENDIF 
IF llgenera &&Determinamos que queres que siempre se guarde
	IF !DIRECTORY(lcRuta)
		MKDIR &lcRuta
	ENDIF 
ENDIF 
SET SAFETY OFF 
= STRTOFILE(lccmd,lcRuta+"\"+lcArchivo+"."+lcExten)
SET SAFETY ON 

RETURN 

*----------------------------------------------------------------------------
* FUNCION StrTrim(lnValor,lnTam,lcDec)
*----------------------------------------------------------------------------
* Funcion que devuelve la trasformacion de str sin espaciones vacios.
*----------------------------------------------------------------------------
FUNCTION StrTrim
PARAMETERS lnValor,lnTam,lnDec
lnValor = IIF(PCOUNT()<1,0,lnValor)
lnTam = IIF(PCOUNT()<2,10,lnTaM)
lnDec = IIF(PCOUNT()<3,0,lnDec)

RETURN ALLTRIM(STR(lnValor,lnTam,lnDec))
*----------------------------------------------------------------------------
* FUNCION DefaultVar(lcpropiedad,loValor,lcTypeDefault)
*----------------------------------------------------------------------------
* Funcion que determina si existe la propiedad, darle el valor, sino el valor
* 	por defecto.
*----------------------------------------------------------------------------
FUNCTION DefaultVar
PARAMETERS lcpropiedad,loValor,lcTypeDefault
	lcTypeDefault = IIF(PCOUNT()<3,varType(loValor),lcTypeDefault)
	*lcTypeDefault = IIF(PCOUNT()<3,Type('loValor'),lcTypeDefault)
	lbControla = IIF(PCOUNT()<3,.f.,.t.)
	
	lcCadenaPropiedad = "'"+lcPropiedad+"'"
	*lcEjemplo = "'"+'CsrEmpresa.id'+"'"
	IF !TYPE(&lcCadenaPropiedad)$'U'
		IF !VARTYPE(&lcPropiedad)$'X'
			IF lbControla
				IF !VARTYPE(&lcPropiedad)$lcTypeDefault
					RETURN loValor
				ENDIF 
			ENDIF 
			lcProperty = &lcCadenaPropiedad &&Tiene un valor string dentro de otro.
			loProperty = &lcProperty
			loValor = loProperty
		ENDIF 
		
		RETURN loValor
	ELSE
		RETURN loValor
	ENDIF 
	RETURN loValor
ENDFUNC 
*----------------------------------------------------------------------------
* FUNCION GuardaPagina(lnRecno)
*----------------------------------------------------------------------------
* Funcion que se utiliza en reportes, para guardar la ultima pagina generada
* en un Cursor, para luego almacenarla en otro sitio
*----------------------------------------------------------------------------
FUNCTION GuardaPagina
PARAMETERS lnRecno
*Esto se invoca en el ultimo groupo en propiedades on Entry = GuardaPagina(_pageno)
	replace ultpagina with nropagina + lnrecno in CsrEncabezado
RETURN 
*--------------------------------------------------
* FUNCION Stop()
*--------------------------------------------------
* Funcion que se utiliza en desarrollo para debug
*--------------------------------------------------
FUNCTION STOP()
	lldesarrollo=(_vfp.startmode()#4)
	IF lldesarrollo
		oavisar.proceso('N')
		DEBUG
		SUSPEND 
	ENDIF 
	RETURN
ENDFUNC  
*--------------------------------------------------
* FUNCION Vista()
*--------------------------------------------------
* Funcion que se utiliza en desarrollo para browse
*--------------------------------------------------
FUNCTION VISTA()
	lldesarrollo=(_vfp.startmode()#4)
	IF lldesarrollo
		oavisar.proceso('N')
		SELECT (ALIAS())
		BROWSE 
	ENDIF 
	RETURN
ENDFUNC  

*********************************************************
* Funcion: GRABAR_LOG
*
* Graba una linea en el log (en raiz\LOG.TXT)
*
* Parametros:
*
*       tctexto   - texto a grabar
*
* Ejemplos:
*
*       ret = GRABAR_LOG("Inicio de Programa")
*
* Retorno:
*
*        .T.    Grabacion correcta
*        .F.	Error en la grabacion
*
* Nota:
*
**********************************************************
Function GRABAR_LOG

Parameters tcTexto,tcArchivo,tcCarpeta

Private plRet, pnFich, pnFichn, pnFtama, pnTammax, pnLongAc
Private pcChar, pnPos,Lcdirlog,Lcfilelog,Lcnewlog

tcArchivo=IIF(PCOUNT()<2,'Log.txt',tcArchivo)
tcCarpeta=IIF(PCOUNT()<3,'Logs',tcCarpeta)

Lcdirlog=Sys(5)+Sys(2003)+'\'+tcCarpeta
Lcfilelog=Lcdirlog+'\'+tcArchivo
LcNewlog=Lcdirlog+'\'+'New'+ALLTRIM(tcArchivo)

If !Directory(Lcdirlog)
	Md (Lcdirlog)
Endif

plRet    = .T.
pnLongAc = 0
pnTammax = 60000
pnFtama = 0

tcTexto=Dtoc(DATE())+' '+time()+' , '+tcTexto

If File(Lcfilelog)                && �Existe el archivo?
	pnFich = Fopen(Lcfilelog,12)  && S�: abrir lect./escrit.
	pnFtama=Fseek(pnFich, 0, 2)                     && Mueve el puntero a EOF
&& y devuelve el tama�o
Else
	pnFich = Fcreate(Lcfilelog)   && Si no, crearlo
ENDIF
&&Para devolver la ruta
tcArchivo = lcFileLog

If pnFich < 0                                       && Comprobar el error
&& abriendo el archivo
	plRet = .F.
	Wait 'No puedo abrir o crear el archivo de salida (fich)' Window Nowait
Else                                                && Si no hay error,
&& escribir en el archivo
	If pnFtama > pnTammax                           && Si el tama�o es mayor que el max
		pnFichn = Fcreate(Lcnewlog)    && Crear nuevo log
		If pnFichn < 0
			Wait 'No puedo abrir o crear el archivo de salida (fichn)' Window Nowait
		Else
			pnPos = Fseek(pnFich, -(pnTammax - 256), 1)
			pcChar = Fread(pnFich, 1)
			Do While pcChar <> Chr(10)
				pcChar = Fread(pnFich, 1)
			Enddo
			pnPos = Fseek(pnFich, 0, 1)
			Do While Not(Feof(pnFich))
				= Fputs(pnFichn,Fgets(pnFich))
			ENDDO
			
			=Fclose(pnFich)
			=Fclose(pnFichn)
			
			Delete File &Lcfilelog
			Rename &Lcnewlog To &Lcfilelog
			pnFich = Fopen(Lcfilelog,12)
			pnFtama=Fseek(pnFich, 0, 2)
		Endif
	Endif
	=Fputs(pnFich, tcTexto)
Endif
=Fclose(pnFich)                                    && Cerrar archivo

Return plRet

*----------------------------------------
*
*----------------------------------------
Procedure Verifica_OCX
* CHECKOCX.PRG
* Programa para checar si estan registrados los controles OCX necesarios
* Junio, 22, 2004.
*
*
* Necesitamos tener una variable en alguna parte para saber si ya esta registrado o no�
* MOD: 14,Mayo,2008� Agregamos una funcion para detectar primero si el OCX esta registrado.
*       En caso de no estarlo debemos hacerlo.
*
* Checando si los controles ActiveX necesarios para el sistema estan registrados
*
* Listado con todos los con todos los controles OCX necesarios.
* Poner en el array tantos OCX como necesite el sistema. Este numero debera ser pasado
* mas adelante para el proceso.
*
* El array necesita 2 dimensiones o columnas, ya que la segunda correspondera al
* archivo fisico OCX y en donde se encuentra si es que esta en una subcarpeta.
* Ejs.
*  lstOCX(1,1) = "ctdropdate.ctdropdatectrl.2"
*  lstOCX(1,2) = "ctdropdate.ocx"
*   o
*  lstOCX(1,2) = "OCX\ctdropdate.ocx"
*
* Tambien usaremos una variable de parametro para hacer 1 de 3 cosas:
* 1) Check = Checar si el control esta registrado o no y registrarlo en su caso
* 2) RegALL = Registrar el control aunque ya estuviera registrado
* 3) UnRegALL = Desregistrar el control.
*
* La razon de estas opciones es que para aplicaciones portables necesitaremos desregistrar el control
* para que no quede huella en el sistema Host.
*
Parameters cOpcion
If Parameters() = 0
	Return
Endif
*stop()
Dimension lstOCX(14,2)
lstOCX(1,1) = "SSubTimer6.Gsubclass"
lstOCX(1,2) = "SSubTmr6.dll"
lstOCX(2,1) ="vbalLbar6.cListBarItem"
lstOCX(2,2) ="vbalLbar6.ocx"
lstOCX(3,1) ="MSComctlLib.TreeCtrl.2"
lstOCX(3,2) ="mscomctl.ocx"
lstOCX(4,1) ="msvcp71.dll"
lstOCX(4,2) ="msvcp71.dll"
lstOCX(5,1) ="msvcr70.dll"
lstOCX(5,2) ="msvcr70.dll"
lstOCX(6,1) ="COMCTL.progctrl.1"
lstOCX(6,2) ="COMCTL32.ocx"
lstOCX(7,1) ="MSMAPI.MAPISession.1"
lstOCX(7,2) ="MSMAPI32.ocx"
lstOCX(8,1) ="MSMAPI.MAPIMessages.1"
lstOCX(8,2) ="MSMAPI32.ocx"
lstOCX(9,1) ="HASAR.fiscal.1"
lstOCX(9,2) ="Fiscal051122.ocx"
lstOCX(10,1) ="EpsonFiscalInterface.dll"
lstOCX(10,2) ="EpsonFiscalInterface.dll"
lstOCX(11,1) ="HasarArgentina.ocx"
lstOCX(11,2) ="HasarArgentina.ocx"
lstOCX(12,1) ="qrcodelib.dll"
lstOCX(12,2) ="qrcodelib.dll"
lstOCX(13,1) ="BarCodeLibrary.dll"
lstOCX(13,2) ="BarCodeLibrary.dll"
lstOCX(14,1) ="CsFoxySmtp64.dll"
lstOCX(14,2) ="CsFoxySmtp64.dll"

* Hacer un ciclo con el ultimo numero que corresponde a la cantidad de OCX necesarios
* No calculamos porque nosotros le damos la cantidad
For i = 1 To Alen('lstocx',1)
	Do Case
	Case cOpcion = "Check"

		lCheck = OcxRegistrado( lstOCX( i, 1 ) ) && Llamamos la funcion que checa si esta registrado o no: (.T./.F.)
		If lCheck = .F.
* Si el control necesario no esta registrado en la PC, registremoslo
* Debemos pasarle a esta funcion el archivo OCX a registrar
			lRegistrado = OCXCmdReg( lstOCX( i, 2) )
*  ? "Archivo " + lstOCX( i,2) +" Ya NO ESTABA registrado. Pero ahora si lo esta"
		Else
*  ? "Archivo " + lstOCX( i,2)+ " Ya estaba registrado"
		Endif
	Case cOpcion = "RegALL"
		lRegistrado = OCXCmdReg( lstOCX( i, 2) )
	Case cOpcion = "UnRegALL"
		lRegistrado = OCXCmdUnReg( lstOCX( i, 2) )
	Endcase
NEXT
on error do errorsys

Return

Function OcxRegistrado(cClase)
Declare Integer RegOpenKey In Win32API ;
	Integer nHKey, String @cSubKey, Integer @nResult
Declare Integer RegCloseKey In Win32API ;
	Integer nHKey
nPos = 0
*stop()
lEsta = RegOpenKey(-2147483648, cClase, @nPos) = 0

If lEsta
	RegCloseKey(nPos)
Endif

Return lEsta
Endfunc

Function OCXRegistrar(cActiveX)
Declare Integer DLLSelfRegister In "vb6stkit.DLL" String lpDllName
* Debemos de poner una lista de los controles
lcFileOCX = Sys(5) + Curdir() + cActiveX
*lcFileOCX = "C:\DBITECH\Toolbox6\DBITech\Component Toolbox 6.0\Components\ctlist.ocx�
liRet = DLLSelfRegister( lcFileOCX )
If liRet = 0
	SelfRegisterDLL = .T.
* MESSAGEBOX( "Registrado OCX� )
Else
	SelfRegisterDLL = .F.
	Messagebox( 'Error - No registrado OCX' )
Endif
Endfunc

Function OCXCmdReg(cActiveX)
On Error
LOCAL lok
cRun='REGSVR32 /s ' +Sys(5) + Curdir()+ cActiveX
TRY 
	Run /N &cRun
	lok = .t.
CATCH TO oError
	Grabar_log('Error al registrar dll - ' + cActiveX )
	lok = .f.
ENDTRY 
*=Messagebox('Se ha registrado la siguiente librer�a : '+Sys(5) + Curdir()+ cActiveX)
RETURN lok
Endfunc

Function OCXCmdUnReg(cActiveX)
cRun='REGSVR32 /u /s ' + cActiveX
Run /N &cRun
ENDFUNC


FUNCTION Licencia

LOCAL cServidor,cInitCatalo,lcConectionStringLocal

cServidor = goapp.servidor
cInitCatalo = Goapp.InitCatalo

lcConectionStringLocal = LcConectionString

LcConectionString = "Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=gestionweb;";
			+"Data Source=api.preventamovil.com.ar\sqlexpress,49904;User ID=sa;pwd=pre!Venta11;"
			
goapp.servidor = "api.preventamovil.com.ar\sqlexpress,49904"
Goapp.InitCatalo = "gestionweb"

*stop()

lok = ExisteDSN()
IF lok			
	lok = ConeccionADO(.t.)
	IF NOT lok
		IF lldesarrollo
			oavisar.usuario('Conexion a licencia no realizada')
		ENDIF 
	ENDIF 
ELSE
	IF lldesarrollo
		oavisar.usuario('Conexion a licencia no realizada')
	ENDIF 
ENDIF 

IF lok
	TEXT TO lcCmd TEXTMERGE NOSHOW 
	SELECT * FROM Empresa
	ENDTEXT 
	IF NOT CrearCursorAdapter('CsrEmpreLicencia',lcCmd)
		RETURN 
	ENDIF 
	
	loConnDataSource.Close()
	
	SELECT CsrEmpreLicencia
	CursorAdapterToXML('CsrEmpreLicencia',ADDBS(SYS(5)+CURDIR())+"Temporal\Lic.XML")
ELSE
	
ENDIF 

goapp.servidor = cServidor 
Goapp.InitCatalo = cInitCatalo

LcConectionString = lcConectionStringLocal

ENDFUNC 

*---------------------------------------------------------------
*--------- Conexion a Base de Datos
*---------------------------------------------------------------
FUNCTION ConeccionADO
LPARAMETERS lLicencia

lLicencia = IIF(PCOUNT()<1,.f.,lLicencia)

Local  loCatchErr As Exception
LOCAL lok, cMensaje
lok = .t.
lcMensajeError= ''
DO case
	CASE LcDataSourceType='ADO' OR LcDataSourceType='ODBC'
		loConnDataSource = createobject('ADODB.Connection')
		loConnDataSource.ConnectionString = LcConectionString
		loConnDataSource.CommandTimeout = 0    && indefinidamente
		loConnDataSource.ConnectionTimeout = IIF(lLicencia,20,60)
		
		lcMensajeError = IIF(llicencia,'','La conexi�n a la Base de Datos a fallado'+CHR(13) +lcConectionString)
		
		TRY 
			Oavisar.proceso('S','Conectando con Base de Datos, tiempo de espera '+LTRIM(STR(loConnDataSource.ConnectionTimeout))+'"' ,.f.,0)
		CATCH 
			MESSAGEBOX('Falta definir objeto ocx para oavisar',0)
			RETURN .f.
		ENDTRY 
		
		TRY 				                              			    
			loConnDataSource.Open()
							                        			    
			Oavisar.proceso('N')
		Catch To loCatchErr
			=Oavisar.proceso('N')	
			IF LEN(LTRIM(lcMensajeError ))<>0
				oavisar.usuario(lcMensajeError )
			ENDIF 
			lok = .f.
		ENDTRY 
		                       			                           	  	
	CASE LcDataSourceType='NATIVE'
		IF !DBUSED('&LcConectionString')        
			OPEN DATABASE (LcConectionString) SHARED
		ENDIF  
		SET DATABASE TO (LcConectionString)
	OTHERWISE 
		ERROR 1429
ENDCASE

RETURN lok


FUNCTION ConeccionODBC
*!*	***Evitar que aparezca  la ventana de login
SQLSETPROP(0,"DispLogin",3)
lnconectorODBC =SQLSTRINGCONNECT(lcConectionODBC)
IF lnconectorODBC<0
	RETURN .f.
ENDIF 
RETURN .t.

FUNCTION ExisteDSN

IF LcDataSourceType="NATIVE"
   RETURN .t.
ENDIF 

#define ODBC_ADD_DSN  1    && Agregar Fuente de Datos
#define ODBC_CONFIG_DSN  2    && Configurar (editar) fuente de datos
#define ODBC_REMOVE_DSN  3    && Eliminar fuente de datos
#define ODBC_ADD_SYS_DSN  4    && Agregar un DSN de Sistema
#define ODBC_CONFIG_SYS_DSN  5    && Configurar un DSN de Sistema
#define ODBC_REMOVE_SYS_DSN  6    && Eliminar un DSN de Sistema 
#define vbAPINull          0    &&' NULL Pointer

DECLARE LONG SQLConfigDataSource IN ODBCCP32.DLL ;
LONG hwndParent, LONG fRequest, ;
STRING lpszDriver, STRING lpszAttributes

  LOCAL intRet, strDriver, strAttributes,lcdns

  strDriver = "SQL Server"
  
  lcdns = STRTRAN(Goapp.servidor,".","_")
  lcdns = ALLTRIM(LEFT(STRTRAN(lcdns,"\",""),8)) + "_"+ ALLTRIM(LEFT(TRIM(Goapp.InitCatalo),8))
  
  strAttributes = "SERVER="+TRIM(Goapp.Servidor )+ Chr(0)
  strAttributes = strAttributes + "DESCRIPTION="+TRIM(lcDns)+ Chr(0)
  strAttributes = strAttributes + "DSN="+TRIM(lcDns)  + Chr(0)
  strAttributes = strAttributes + "DATABASE="+TRIM(Goapp.InitCatalo)  + Chr(0)
*!*	  strAttributes = strAttributes + "UID="+Goapp.Usuario + Chr(0)
*!*	  strAttributes = strAttributes + "PWD="+Goapp.Pwd + Chr(0)
  
  intRet = SQLConfigDataSource(vbAPINull, ODBC_CONFIG_DSN , strDriver, strAttributes)   
  
	IF intRet > 0    
	      * ya existe el DNS
	      RETURN .t.      
	ELSE   
		intRet = SQLConfigDataSource(vbAPINull, ODBC_ADD_DSN, strDriver, strAttributes)     
		IF  intRet>0
			RETURN .t.
		ELSE 
			RETURN .f.
		ENDIF 
	ENDIF 		
ENDFUNC 