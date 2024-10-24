*------------------------------------------------------------------------------
FUNCTION DataCursor
PARAMETERS cName

RETURN .f.
ENDFUNC 

*----------------------------------------------------------------------------
* FUNCION PeloCuit(lcCuit)
*----------------------------------------------------------------------------
FUNCTION pelocuit
PARAMETERS lccuit
lccuit=ALLTRIM(STRTRAN(lccuit,'-',''))
lccuit=ALLTRIM(STRTRAN(lccuit,'/',''))
lccuit=ALLTRIM(STRTRAN(lccuit,'.',''))
lccuit=LEFT(lccuit+space(11),11)
RETURN lccuit

*----------------------------------------------------------------------------
* FUNCION CargarRTFMemo(loMemo)
*----------------------------------------------------------------------------
* Funcion que devuelve en un cursor table auxiliar en un campo general el valor
* del rtf. Un campo memo acepta un valor en un campo general.
*----------------------------------------------------------------------------
FUNCTION CargarRTFMemo
PARAMETERS loMemo

lcruta =SYS(5)+ '\temporal\rtf\validar'
IF !DIRECTORY(lcRuta)
	MKDIR SYS(5)+ '\temporal\rtf\validar'
ENDIF 
lcFileName = SYS(5)+"\temporal\rtf\validar\aux"+DTOS(DATE())+".rtf"
IF !EMPTY(lcFileName)
	SET SAFETY OFF 
	lnidfile = STRTOFILE(loMemo,lcFileName)
	SET SAFETY ON 
ENDIF 

RETURN lcFileName
*----------------------------------------------------------------------------
* FUNCION LeerRTF(lcRuta)
*----------------------------------------------------------------------------
* Funcion que devuelve en un cursor table auxiliar en un campo general el valor
* del rtf. Un campo memo acepta un valor en un campo general.
*----------------------------------------------------------------------------
FUNCTION LeerRTF
PARAMETERS lcRuta,lcAlias,lcCampo
tSafety = SET("safety") &&Store SET status of Safety to a variable
SET SAFETY OFF &&Check to see if the Dcolor table exists
IF USED('temprtf')
	USE IN temprtf
ENDIF 
IF FILE("temprtf.dbf")
	DELETE FILE "drtf.dbf"
ENDIF 

CREATE TABLE temprtf (campotext g,campomemo m) 

IF !FILE(lcruta)
	RETURN 
ENDIF 

_rtfFile = lcruta
select temprtf 
APPEND BLANK
APPEND GENERAL campotext FROM &_rtfFile CLASS "RICHTEXT.RICHTEXTCTRL.1"
APPEND MEMO campomemo FROM &_rtfFile 

SELECT (lcAlias)
replace &lcCampo WITH Temprtf.campomemo 

USE IN temprtf
SET SAFETY &tSafety
RETURN 
*----------------------------------------------------------------------------
* FUNCION DevolverEjercicioContable(lcpefiscal,lnidejercicio,lnejercicio)
*----------------------------------------------------------------------------
* Funcion que devuelve el ejercicio contable perteneciene al periodo fiscal
*----------------------------------------------------------------------------
FUNCTION DevolverEjercicioContable
PARAMETERS lcpefiscal,lnidejercicio,lnejercicio
	lnidejercicio = 0
	lnejercicio = 0
	TEXT TO lcCmd TEXTMERGE NOSHOW 
	SELECT CsrControlEje.id,CsrControlEje.ejercicio FROM DetaConta as CsrControlEje 
	WHERE CsrControlEje.fecdesde <= '<<lcpefiscal+'01'>>' and 
	'<<lcpefiscal+'01'>>' <=CsrControlEje.fechasta
	ENDTEXT 
	IF !CrearCursorAdapter('CsrControlEje',lcCmd)
		RETURN .f.
	ENDIF 
	llok = .f.
	IF RECCOUNT('CsrControlEje')#0
		lnidejercicio = CsrControlEje.id
		llok = .t.
		lnejercicio = CsrControlEje.ejercicio
	ENDIF 
	USE IN CsrControlEje
	RETURN llok
ENDFUNC 

*------------------------------------------------------------
* FUNCION ArmarDocumento(lcnumero)
*------------------------------------------------------------
* Funcion le agrega los puntos  aun documento (DNI,LC...etc)
*------------------------------------------------------------
FUNCTION ArmarDocumento(lonum)
LOCAL lcDocumento,lcNumero
lcDocumento= ""
if type('loNum')='N'
	lcNumero=alltrim(str(loNum,15))
else
	lcNumero=loNum
endif
lcNumero = ALLTRIM(lcNumero)
DO WHILE !EMPTY(lcNumero)
	IF LEN(ALLTRIM(lcNumero))=0
		LOOP 
	ENDIF 
	lcDocumento = RIGHT(lcNumero,3)+IIF(LEN(lcDocumento)=0,"",".")+LTRIM(lcDocumento)
	lcNumero = LEFT(lcNumero,LEN(lcNumero)-3)
ENDDO 
RETURN lcDocumento
*------------------------------------------
* FUNCION NombreNi(lcnombre)
*------------------------------------------
* Funcion que cambia desde la importacion
* Poniendo � a los nombre
*------------------------------------------
FUNCTION NombreNi(lcnombre)
lni=0
IF '�'$lcnombre OR '�'$lcnombre
	FOR lni=1 to LEN(lcnombre)
		lc=SUBSTR(lcnombre,lni,1)
	 	IF '�'$lc OR '�'$lc
	 		lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('�')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
	 	ENDIF 
	 ENDFOR  
ENDIF 
RETURN lcnombre
ENDFUNC  
*----------------------------------------------------------
* FUNCION MaySTR(lcnombre)
*----------------------------------------------------------
* Funcion que convierte a mayusculas. Implentada para la �
*----------------------------------------------------------
FUNCTION MaySTR
PARAMETERS lcnombre
LOCAL lni,lc
lcnombre = ALLTRIM(UPPER(lcnombre))
IF '�'$lcnombre OR '�'$lcnombre
	FOR lni=1 to LEN(lcnombre)
		lc=SUBSTR(lcnombre,lni,1)
	 	IF '�'=lc OR '�'$lc
	 		lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('�')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
	 	ENDIF 
	 ENDFOR  
ENDIF 
RETURN lcnombre
*------------------------------------------
* FUNCION CargaTabla(lcBdd,lcAlias,lbZap)
*------------------------------------------
* Funcion abre las tablas locales de foxpro
* adjuntandole al alias 'Csr'+alias.
* lcBdd = Base de datos
* lcAlias = Nombre de la tabla
* lbZap = si es true, limpiamos la tabla antes.
*------------------------------------------
FUNCTION CargarTabla
PARAMETERS lcBdd,lcAlias,lbZap
LOCAL llok
llok = IIF(PCOUNT()<1,.f.,.t.)
llok = IIF(PCOUNT()<2,.f.,llok)
llok = IIF(EMPTY(lcbdd),.f.,llok)
llok = IIF(EMPTY(lcAlias),.f.,llok)
lbZap = IIF(PCOUNT()<3,.f.,lbZap)

IF len(lcbdd)=0 OR !llok
	oavisar.usuario('Error al localizar la base de datos a importar')
	RETURN .f.
ENDIF 

IF !llok
	Oavisar.usuario('No especifico el base de datos/alias para crear el cursor')
	RETURN .f.
ENDIF 
lcCsrAlias = 'Csr'+LTRIM(lcAlias)
lcArchivo = LTRIM(lcbdd)+'!'+LTRIM(lcAlias)
llok = .t.
TRY 
	IF USED(lcAlias)
		USE IN lcAlias
	ENDIF 
	USE &lcArchivo IN 0 ALIAS &lcCsrAlias EXCLUSIVE
	IF lbZap
		ZAP IN &lcCsrAlias
	ENDIF 
CATCH TO oError
	oavisar.usuario(oError.Details+CHR(13)+oError.LineContents+CHR(13);
					+Oerror.Message+STR(oError.ErrorNo)+CHR(13);
					+oError.Procedure)
	llok = .f.
ENDTRY
RETURN  llok
*------------------------------------------
* FUNCION RecuperarID(lcAlias,lnSucursal)
*------------------------------------------
* Funcion para generar el id = sucursal + id.
* lcAlias = Nombre de la tabla
* lnSucursal = numero d ela sucursal.
*------------------------------------------
FUNCTION RecuperarID
PARAMETERS lcAlias, lnsucursal
lnsucursal = lnsucursal + 10 
lnidentificador = 1
SELECT(lcAlias)
IF FSIZE('id')>4
	lntam = 10
ELSE 
   	lntam = 8
ENDIF 
IF RECCOUNT(lcAlias)>0
	GO BOTTOM 
	lnidentificador = VAL(SUBSTR(STR(id,lntam+2),3)) +1 
ENDIF 

lccadena = strzero(lnidentificador,lntam)
RETURN VAL(str(lnsucursal,2)+lccadena)
 

function NNUEVOID(TCALIAS,tcnombreids)
tcnombreids=iif(pcount()<2,'IDS',tcnombreids)
	local LCALIAS, ;
		LNID, ;
		LCOLDREPROCESS, ;
		LNOLDAREA

	LNOLDAREA = select()

	if parameters() < 1
		LCALIAS = upper(alias())
	else
		LCALIAS = upper(TCALIAS)
	endif

	LCOLDREPROCESS = set('REPROCESS')

	*-- Lock until user presses Esc
	set reprocess to automatic

	if !used('IDS')
		use &tcnombreids in 0 alias ids
	endif
	select IDS
	if seek(LCALIAS,'IDS', "table")
		if rlock()
			LNID = IDS.NEXTID
			replace IDS.NEXTID with IDS.NEXTID + 1
			unlock
		endif
	else
		=messagebox('No se encontro '+LCALIAS+' en IDS',16, ;
			'ERROR EN TABLA IDS')
		LNID=0
	endif

	select (LNOLDAREA)
	set reprocess to LCOLDREPROCESS

	return LNID
endfunc

*=====================================
*== CONVIERTE UN CURSOR EN MODIFICABLE
*=====================================
procedure hazmodificable

	lparameters m.alias

	use (dbf(m.alias)) in 0 again alias hazmodificable
	use in (m.alias)
	use (dbf("hazmodificable")) in 0 again alias (m.alias)
	use in hazmodificable

endproc

*===================================================
*== DEVOLVER REFERENCIAS DE OBJETOS DE NEGOCIOS HIJO
*===================================================
* PARAMETROS
*	toContenedor: contenedor en donde se buscan los hijos
*		las clases que se toman son las indicadas en la
*		funci�n lClaseContenedora, no se pasan clases tipo pageframe,
*		sino que se pasan las p�ginas del mismo, ya que no tiene
*		propiedad controls.
*	tcNombre: nombre del padre a buscar
*	taoHijos: devuelve las referencias (por referencia)
*	tnHijos: cantidad de hijos encontrados (por referencia), el valor inicial debe ser 0
* OBSERVACIONES:
*	El procedimiento busca coincidencias entre el valor de la propiedad cObjNegPadre
*		y el parametro tcNombre, los objetos que cumplen esta condici�n son agregados
*		a la matriz taoHijos
*	Para controles de tipo contenedor, realiza una llamada recursiva.
function GetObjNegHijosRef
parameters toContenedor,tcNombre,taoHijos,tnHijos

local loControl,lnInd,lnPages
FOR EACH loControl IN toContenedor.Controls
	if pemstatus(loControl,'cObjNegPadre',5) ;
		and upper(alltrim(loControl.cObjNegPadre))=upper(alltrim(tcNombre))
		tnHijos=tnHijos+1
		dimension taoHijos(tnHijos)		
		taoHijos(tnHijos)=loControl
	endif
	*-- LLAMADA RECURSIVA PARA CONTROLES DE TIPO CONTENEDOR
	if lClaseContenedora(loControl)      
		*-- PARA PAGEFRAMES, LLAMAR POR CADA PAGINA, YA QUE NO TIENE PROPIEDAD CONTROLS
		if upper(loControl.baseclass)='PAGEFRAME'
			FOR EACH loPages IN loControl.Pages
				=GetObjNegHijosRef(loPages,tcNombre,@taoHijos,@tnHijos)
			ENDFOR 
		else
			=GetObjNegHijosRef(loControl,tcNombre,@taoHijos,@tnHijos)		
		endif
	endif
ENDFOR 

*====================================
*== INDICA SI LA CLASE ES CONTENEDORA
*====================================
function lClaseContenedora
parameters toControl

local lcBC,lcnom
if !pemstatus(toControl,'baseclass',5)
   return .f.
endif
if vartype(toControl.baseclass)='U'
   return .f.
endif
lcBC=upper(toControl.baseclass)
lcnom=upper(toControl.name)
return inlist(lcBC,'CONTAINER','PAGEFRAME','PAGE','FORM')

function GetObjNegHijosRefInsDel
parameters toContenedor,tcNombre,taoHijos,tnHijos

local loControl,lnInd,lnPages
FOR EACH locontrol IN toContenedor.Controls
    
	if pemstatus(loControl,'cObjNegPadre',5) ;
		and upper(alltrim(loControl.cObjNegPadre))=upper(alltrim(tcNombre))
		    if pemstatus(loControl,'hijoInsDel',5) and loControl.hijoInsdel
         	   tnHijos=tnHijos+1
		       dimension taoHijos(tnHijos)		
		       taoHijos(tnHijos)=loControl
		    endif   
	endif
	*-- LLAMADA RECURSIVA PARA CONTROLES DE TIPO CONTENEDOR
	if lClaseContenedora(loControl)      
		*-- PARA PAGEFRAMES, LLAMAR POR CADA PAGINA, YA QUE NO TIENE PROPIEDAD CONTROLS
		if upper(loControl.baseclass)='PAGEFRAME'
			FOR EACH loPages IN loControl.Pages
				=GetObjNegHijosRefInsDel(loPages,tcNombre,@taoHijos,@tnHijos)
			ENDFOR 
		else
			=GetObjNegHijosRefInsDel(loControl,tcNombre,@taoHijos,@tnHijos)		
		endif
	endif
ENDFOR 


*========
*== VACIO
*========
function vacio
* Usado como origen de datos en columnas de grilla
*	que no muestran datos.
return ''

*==========
*== XSetAll
*==========
function XSetAll
Parameters tcGrupo, tcPropiedad, tuValor,toForm
local loControl
For Each loControl in toForm.Controls
	If Upper( loControl.Tag ) = Upper( tcGrupo )
		loControl.&tcPropiedad. = tuValor
	Endif
Next

Function Reporte
parameters nombreinforme,esvistaprevia

do case

	case esvistaprevia

		wait window 'Generando vista previa , aguarde ...' nowait

		SET RESOURCE OFF  
		PUSH KEY

		DEFINE WINDOW wPreview FROM 0,0 TO 1,1; 
		    TITLE 'Vista preliminar' in screen CLOSE float grow minimize zoom SYSTEM NAME oPreview
		    
		ZOOM WINDOW wPreview MAX

		ON KEY LABEL UPARROW; 
			MOUSE CLICK AT 5,oPreview.Width-8;
			PIXELS WINDOW wPreview

		ON KEY LABEL DNARROW; 
		    MOUSE CLICK AT oPreview.Height-22,oPreview.Width-8;
		    PIXELS WINDOW wPreview

		ON KEY LABEL LEFTARROW; 
		    MOUSE CLICK AT oPreview.Height-10,6; 
		    PIXELS WINDOW wPreview

		ON KEY LABEL RIGHTARROW; 
		    MOUSE CLICK AT oPreview.Height-10,oPreview.Width-22;
		    PIXELS WINDOW wPreview

		ON KEY LABEL HOME; 
		    MOUSE DBLCLICK AT 18,oPreview.Width-8;
		    PIXELS WINDOW wPreview

		ON KEY LABEL END;
		    MOUSE DBLCLICK AT oPreview.Height-35,oPreview.Width-8;
		    PIXELS WINDOW wPreview

		REPORT FORM (NombreInforme); 
		    TO PRINTER PROMPT PREVIEW WINDOW wPreview

		POP KEY
		SET RESOURCE ON
		wait clear
	other
		REPORT FORM (NombreInforme); 
		    TO PRINTER PROMPT NOCONSOLE
	endcase	
Endfunc

Function report_contarpaginas
PARAMETERS lc_report
LOCAL nPaginas
nPaginas = 0

DEFINE WINDOW x FROM 1,1 TO 2,2
ACTIVATE WINDOW x NOSHOW
REPORT FORM (lc_report) NOCONSOLE
nPaginas = _PAGENO
RELEASE WINDOW x
RETURN npaginas


FUNCTION ReportCopias
LPARAMETER lcFRX, lnCopias
LOCAL lcNewExpr, lnStartCopiesLine, lcStartAtCopiesLine, lnEndCopiesLine, ;
lnLenCopiesLine, lcTop, lcBottom, lcAlias
#DEFINE vfCRLF CHR(13) + CHR(10)

IF !(UPPER(RIGHT(lcFRX, 4)) = ".FRX")
lcFRX = lcFRX + ".FRX"
ENDIF
lcAlias = ALIAS()
SELECT 0
USE (lcFRX)
LOCATE FOR objType = 1 AND objCode = 53

IF EMPTY(EXPR)
        lcNewExpr = "COPIES=" + ALLT(STR(lnCopias)) + vfCRLF
ELSE
        lnStartCopiesLine = ATC("COPIES", EXPR)
        lcStartAtCopiesLine = SUBSTR(EXPR, lnStartCopiesLine)
        lnEndCopiesLine = ATC(vfCRLF, lcStartAtCopiesLine)
        lnLenCopiesLine = LEN(SUBSTR(lcStartAtCopiesLine, 1, lnEndCopiesLine))
        lcTop = SUBSTR(EXPR, 1, lnStartCopiesLine - 1)
        lcBottom = SUBSTR(EXPR, (LEN(lcTop) + lnLenCopiesLine))
        lcNewExpr  = lcTop + "COPIES=" + ALLT(STR(lnCopias)) + lcBottom
ENDIF

REPLACE EXPR WITH lcNewExpr
USE
IF !EMPTY(lcAlias)
SELECT (lcAlias)
ENDIF
ENDFUNC

FUNCTION UNZAP
PARAMETER Y
IF Y>0 .AND. USED()
   IF RECCOUNT()=0
      FILENAME=DBF()
      USE
      HANDLE=FOPEN(FILENAME,2)
      IF HANDLE>0
         BYTE=FREAD(HANDLE,32)
         BKUP_BYTE=BYTE
         FIELD_SIZE=ASC(SUBSTR(BYTE,11,1))+(ASC(SUBSTR(BYTE,12,1))*256)
         FILE_SIZE=FSEEK(HANDLE,0,2)
         BYTE8=CHR(INT(Y/(256*256*256)))
         BYTE7=CHR(INT(Y/(256*256)))
         BYTE6=CHR(INT(Y/256))
         BYTE5=CHR(MOD(Y,256))
         BYTE=SUBSTR(BYTE,1,4)+BYTE5+BYTE6+BYTE7+BYTE8+SUBSTR(BYTE,9)
         =FSEEK(HANDLE,0)
         =FWRITE(HANDLE,BYTE)
         =FCHSIZE(HANDLE,FILE_SIZE+(FIELD_SIZE*Y))
         =FCLOSE(HANDLE)
      ENDIF
      USE &FILENAME
   ENDIF
ENDIF

function sseek
	parameters tuExpr

	*-- GUARDAR VALOR DE NEAR
	local lcNearIni
	lcNearIni=set('near')
	set near on

	*-- BUSCAR DATO
	seek tuExpr

	*-- RESTABLECER NEAR
	set near &lcNearIni

	return .t.
endfunc


*-----------------------------
*-- VERIFICA N� DE CUIT VALIDO

FUNCTION vericuit
PARAMETER m_cuit,_sicartel
LOCAL _cuit,i,_digito,j,suma,RESTO,dv,sale
_sicartel=IIF(PCOUNT()<2,.t.,_sicartel)
if len(alltrim(m_cuit))=0
   return .f.
   *return .t.
endif
_cuit=''
sale = .F.
FOR i=1 TO LEN(m_cuit)
	IF SUBS(m_cuit,i,1)$'0123456789'
		_cuit=_cuit+SUBS(m_cuit,i,1)
	ENDIF
NEXT
IF LEN(_cuit)<>11
	sale=.F.
ELSE
	_digito=VAL(RIGHT(_cuit,1))
	j=2
	suma=0
	dv=0
	FOR i=10 TO 1 STEP -1
		suma = suma + VAL(SUBS(_cuit,i,1)) * j
		j = j + 1
		j=IIF(j=8,2,j)
	NEXT
	RESTO=MOD(suma,11)
	IF RESTO=0
		dv=0
	ELSE
		dv=11 - RESTO
		dv=IIF(dv=10,9,dv)
	ENDIF
	sale= IIF(_digito=dv,.T.,.F.)
ENDIF
if not sale .and. _sicartel
   =Oavisar.usuario('La c.u.i.t. es inv�lida',0)
endif
RETURN sale

FUNCTION cuit
PARAMETERS tCuit
local lcCuit
lcCuit=''
if type('tCuit')='N'
	lcCuit=alltrim(str(tCuit))
else
	lcCuit=tCuit
endif
if len(lcCuit)#11
	return ''
else
	RETURN LEFT(lcCuit,2)+'-'+SUBSTR(lcCuit,3,8)+'-'+RIGHT(lcCuit,1)
endif

FUNCTION limpiar_teclado
CLEAR TYPEAHEAD
KEYBOARD CHR(32)
INKEY()

FUNCTION buscardato
PARAMETERS tuvalor,tcalias,tcorden,tcnear
LOCAL lcestadonearini,lnreg
lcestadonearini=SET('near')
SET NEAR &tcnear
=SEEK(tuvalor,tcalias,tcorden)
lnreg=IIF(EOF(tcalias),0,RECNO(tcalias))
SET NEAR &lcestadonearini
RETURN lnreg

PROCEDURE isoperator
PARAMETERS ccar
RETURN INLIST(ccar,'*','/','+','-','^',' ','<','>','=',')')

PROCEDURE variables
PARAMETERS cexpr,avariab
* cExpr: expresi�n a evaluar
* aVariab(): nombre de variables encontradas en cExpr
* nI:entero, indice
* bInVar: l�gico, si se encuentra dentro de una variable
* cCar: cadena, caracter analizado actualmente
* nTamMat: numero de elementos de aVar

DIMENSION avariab(1)
binvar=.F.
ntammat=0

FOR ni=1 TO LEN(cexpr)
	ccar=SUBSTR(cexpr,ni,1) && Barre cada uno de los caracteres
	IF NOT binvar && Primera letra de una posible variable
		IF ISALPHA(ccar) OR ccar='_'
			binvar=.T.
			ntammat=ntammat+1
			DO redim WITH avariab, ntammat
			avariab(ntammat)=ccar
		ENDIF
	ELSE && Ya me encuentro en una variable
		IF ccar='(' && Significa que no era una variable, sino una funcion 'xxx('
			binvar=.F.
			ntammat=ntammat-1
			DO redim WITH avariab, ntammat
		ELSE
			IF isoperator(ccar) && Es un operador, llegamos al fin de la variable
				binvar=.F.
				cvaract=UPPER(avariab(ntammat))
				IF cvaract='AND' OR cvaract='NOT' OR cvaract='OR' && La variable es;
						en realidad un operador l�gico, por lo que lo excluimos
					ntammat=ntammat-1
					DO redim WITH avariab, ntammat
				ENDIF
			ELSE && Se agregan m�s letras (o n�meros) a la variable
				avariab(ntammat)=avariab(ntammat)+ccar
			ENDIF
		ENDIF
	ENDIF
NEXT ni

PROCEDURE redim
PARAMETERS amatriz, ntam
IF ntam>0 then
	DIMENSION amatriz(ntam)
ENDIF

*!*	FUNCTION seek_dato
*!*	PARAMETERS tcdatobuscado,tbtipobusqueda
*!*	IF tbtipobusqueda
*!*		SET NEAR ON
*!*	ELSE
*!*		SET NEAR OFF
*!*	ENDIF
*!*	SEEK(tcdatobuscado)
*!*	SET NEAR OFF
*!*	RETURN .T.

FUNCTION strzero
PARAMETERS tcdato,tntamfinal,tndecimal
tndecimal = iif(pcount()<3,0,tndecimal)
local lcval
lcval = strtran(str(tcdato,tntamfinal,tndecimal),' ','0')
return lcval
*RETURN REPLICATE('0',tntamfinal-LEN(alltrim(str(tcdato)))) + alltrim(str(tcdato))

FUNCTION numtocod
PARAMETERS tnnum,tntamcod
RETURN strzero(ALLTRIM(STR(tnnum)),tntamcod)

FUNCTION strz
PARAMETER tnconv,tntam
LOCAL lcconv
lcconv=ALLTRIM(STR(tnconv))
lcconv=REPLICATE('0',tntam-LEN(lcconv))+lcconv
RETURN lcconv

FUNCTION strzc
PARAMETER tcconv,tntam
LOCAL lcconv
lcconv=ALLTRIM(tcconv)
lcconv=REPLICATE('0',tntam-LEN(lcconv))+lcconv
RETURN lcconv

FUNCTION NombreDia
PARAMETERS  fec

DIMENSION NomDia[7]
LOCAL lcnomdia
lcnomdia  = ""

Nomdia[1] = 'Domingo  '
NomDia[2]= 'Lunes    '
NomDia[3]= 'Martes   '
Nomdia[4]= 'Mi�rcoles'
Nomdia[5]= 'Jueves   '
Nomdia[6]= 'Viernes'
Nomdia[7]= 'Sabado'

DO CASE 	
	CASE VARTYPE(fec)="D"
		lcnomdia = Nomdia[dow(fec)]
	CASE VARTYPE(fec)="N" 
		IF fec >0 AND fec < 8
			lcnomdia = Nomdia[fec]
		ENDIF 			
ENDCASE

RETURN lcnomdia

PROCEDURE cargararbol
PARAMETERS tpadrebuscado,tnorden
*-- Declaraci�n de variables.
LOCAL lpadrebuscado
LOCAL lnregactual
LOCAL lnvalitemdata && Valor de Item Data
*-- Inicializaci�n de variables.
lpadrebuscado=tpadrebuscado
*-- Busqueda de lPadreBuscado
SELECT plancue
SET ORDER TO ctamadre
SEEK lpadrebuscado
*-- Desplazarse por todos los elementos que tienen como padre a lPadreBuscado;
para luego llamar a CargarArbol con cada uno de ellos.
DO WHILE !EOF() AND ctamadre=lpadrebuscado
	lnregactual=RECNO()
	REPLACE orden WITH tnorden
	tnorden=tnorden+1
	=cargararbol(codcta,@tnorden)
	GO lnregactual
	SKIP
ENDDO

FUNCTION posiciono_cuenta
LOCAL _cuenta
SELE cuerasto
_cuenta=cuerasto.codcta
SET ORDER TO gab
SEEK STR(_cuenta,10)+STR(goinfocont.nejeact*10^8+3,14)
=MESSAGEBOX(STR(cuerasto.codasto,14))
=MESSAGEBOX(STR(goinfocont.nejeact*10^8+3,14))
RETURN .T.

Function AFILL
parameters Amatriz,lvalor
local i
for i=1 to Alen(Amatriz)
   Amatriz[i] = lvalor
next
return .t.

function cleartec
clear typeahead
keyboard chr(32)
inkey()
return .t.

FUNCTION Truncar(tnNro, tnDec)
  LOCAL ln
  ln = 10 ^ tnDec
  RETURN ROUND(INT(tnNro*ln)/ln,tnDec)
ENDFUNC 

FUNCTION RED
parameters lnrimporte,lnrdecimal
lnrdecimal = iif(pcount()<2,2,lnrdecimal)
local nvar,lncinco,lncien,lcpic
*nvar = round(lnrimporte,lnrdecimal)
lcdecimals = VAL(SYS(2001,"DECIMALS"))
SET DECIMALS TO lnrdecimal

nvar = lnrimporte

*!*	qdecimal = 10 ** lnrdecimal
*!*	q5             = 0.5 /  qdecimal
*!*	nvar =IIF(nvar>=0,((nvar + q5) * qdecimal),((nvar - q5) * qdecimal))
*!*	nvar=INT(nvar)/qdecimal

DO case
       CASE lnrdecimal=2
*       		nvar = VAL(TRANSFORM(nvar,"9999999999999.99"))
			nvar = VAL(STR(nvar,18,2))
       CASE lnrdecimal=3
 *     		nvar = VAL(TRANSFORM(nvar,"999999999999.999"))
			nvar = VAL(STR(nvar,18,3))
       CASE lnrdecimal=4
  *   		nvar = VAL(TRANSFORM(nvar,"99999999999.9999"))       		
			nvar = VAL(STR(nvar,18,4))  
ENDCASE 

SET DECIMALS TO lcdecimals

return nvar

Function C_entro(_Cartel,_cc,_replica)
Local _line
_line = replicate(_replica,_cc)
_line = stuff(_line,Int(_cc/2)-Int(Len(_Cartel)/2),Len(_Cartel),_Cartel)
Return _line

*-----------------------------
*-- Digito Verificador

FUNCTION digiveri
PARAMETER m_cuit,lnlen,lbmensage
LOCAL _cuit,i,_digito,j,suma,RESTO,dv,sale
lbmensage=iif(pcount()<3,.t.,lbmensage)
if len(alltrim(m_cuit))=0
   return .t.
endif
_cuit=''
sale = .F.
FOR i=1 TO LEN(m_cuit)
	IF SUBS(m_cuit,i,1)$'0123456789'
		_cuit=_cuit+SUBS(m_cuit,i,1)
	ENDIF
NEXT
IF LEN(_cuit)<>lnlen
	sale=.F.
ELSE
	_digito=VAL(RIGHT(_cuit,1))
	j=2
	suma=0
	dv=0
	FOR i=lnlen-1 TO 1 STEP -1
		suma = suma + VAL(SUBS(_cuit,i,1)) * j
		j = j + 1
		j=IIF(j=8,2,j)
	NEXT
	RESTO=MOD(suma,11)
	IF RESTO=0
		dv=0
	ELSE
		dv=11 - RESTO
		dv=IIF(dv=10,9,dv)
	ENDIF
	sale= IIF(_digito=dv,.T.,.F.)
ENDIF
if !sale .and. lbmensage
   =Oavisar.usuario('El d�gito verificador es inv�lido',0)
endif
m_cuit = left(m_cuit,lnlen-1)+str(dv,1)
RETURN sale


*==============================================================
*===Redifinimos el tama�o de id cuando se convierte en string
*==============================================================
FUNCTION strid
PARAMETER tnconv,tntam
lntam = IIF(PCOUNT()<2,12,tntam)
LOCAL lcconv
lcconv=(STR(tnconv,lntam))
RETURN lcconv
*==============================================================
function mesarg
parameters lnmes
local lcmes[12]
lcmes[1] = 'Enero'
lcmes[2] = 'Febrero'
lcmes[3] = 'Marzo'
lcmes[4] = 'Abril'
lcmes[5] = 'Mayo'
lcmes[6] = 'Junio'
lcmes[7] = 'Julio'
lcmes[8] = 'Agosto'
lcmes[9] = 'Septiembre'
lcmes[10]= 'Octubre'
lcmes[11]= 'Noviembre'
lcmes[12]= 'Diciembre'        

return left(lcmes[lnmes]+space(10),10)

function Acosto
parameter lncosto,lncostobon,lncostosiva,lncostociva,lncostorepo
local lniva

lncostobon = lncosto - (lncosto *(lnbonif1/100))
lncostobon = lncostobon -(lncostobon*(lnbonif2/100))
lncostobon = lncostobon -(lncostobon*(lnbonif3/100))
lncostobon = round(lncostobon -(lncostobon*(lnbonif4/100)),4)

lncostosiva = round((lncostobon + lninterno),4)
lniva       = round(((lncostosiva - lninterno) * tablaiva.ivari/100),4)
lncostociva = round((lncostobon + lninterno + lniva),4)
lncostorepo = iif(lncostorepo=0,lncostosiva,lncostorepo)

return .t.

function preciobase
parameter lncosto,lnbonif1,lnbonif2,lnbonif3,lnbonif4,lninterno;
          ,lnprecioasiva,lnprecioaciva,lnpreciobsiva,lnpreciobciva,lnpreciocsiva,lnpreciocciva;
          ,lnutila,lnutilb,lnutilc,lncostorepo,lncostobon,lncostosiva,lncostociva;
          ,lnutilrepa,lnutilrepob,lnutilrepoc

Acosto(lncosto,@lncostobon,@lncostosiva,@lncostociva,@lncostorepo)

lnprecioaciva = masiva(lninterno,lnprecioasiva,.t.)
if lnutila<>0
   A_venta(@lnPrecioasiva,@lnprecioaciva,lnutila,lnCostosiva)
endif
f_min(lnprecioAsiva,@lnutilrepoa,lncostorepo,lninterno)

lnpreciobciva = masiva(lninterno,lnpreciobsiva,.t.)
if lnutilb<>0
   A_venta(@lnPreciobsiva,@lnpreciobciva,lnutilb,lnCostosiva)
endif
f_min(lnpreciobsiva,@lnutilrepob,lncostorepo,lninterno)

lnprecioCciva = masiva(lninterno,lnprecioCsiva,.t.)
if lnutilc<>0
   A_venta(@lnPrecioCsiva,@lnprecioCciva,lnutilc,lnCostosiva)
endif
f_min(lnprecioCsiva,@lnutilrepoc,lncostorepo,lninterno)

return .t.

function a_venta
parameter lnPreciosiva,lnpreciociva,lnutilidad,lnSobreCosto

lnpreciosiva = round((lnSobrecosto + lnsobrecosto * (lnutilidad/100)),4)
lnpreciociva = masiva(lninterno,lnpreciosiva,.t.)
lnpreciosiva = masiva(lninterno,lnpreciociva,.f.)
return .t.

function f_min
parameter lnpreciosiva,lnutil,lnsobrecosto,lninterno

local lnauxi

  auxi=lnSobrecosto
  if auxi<>0
     lnutil=(((lnpreciosiva/auxi)-1)*100)
     lnutil=round(lnutil,4)
     lnutil=iif(lnutil<0,0,lnutil)
  else
     lnutil=0
  endif
  
  if lnutil > 900
     =messagebox('Utilidad '+transform(lnutil,'@z 99999.999')+' demasiado grande';
                 ,48,'informaci�n al usuario')
  endif
return .t.

function masiva
parameter lninterno,lnprecio,llqhago

local lnbruto

lnbruto = lnprecio - lninterno

if llqhago
   lnprecio = lnbruto * (1+(pnivari/100))
else
   lnprecio = lnbruto / (1+(pnivari/100))
endif
lnprecio = lnprecio + lninterno

return round(lnprecio,4)

function Nrointerno
parameters _operacion
local _orden
_orden = 0
if !used('Orden')
   Use Orden in 0
endif
Sele Orden
go top
if eof()
   append blank
endif
do while !flock()
enddo
_orden = numero + 1
repl numero with numero + 1 
=tableupdate(1,.t.,'Orden')
Unlock
return _orden

function Cbanteafecta
parameters lcnuevofiltro
lcnuevofiltro = iif(pcount()<1,'',lcnuevofiltro)
local lclinea,lnrecno,lcidentre,lcafectado,lcalias,lcfiltroold
lcalias = alias()
lclinea    = ''
Sele CsrComprobante
lnrecno    = recno()
lcidentre  = Csrcomprobante.id
lcafectado = Csrcomprobante.afectado

lcfiltroold = filter()
if len(trim(lcnuevofiltro))#0
   set filter to &lcnuevofiltro
else
  set filter to 
endif  
go top
Scan for !eof()
    if id=lcidentre
       loop
    endif  
    if trim(clase)$lcafectado
       lclinea = lclinea + iif(len(trim(lclinea))=0,'','-') + STR(id,10)
    endif
ENDSCAN
if len(trim(lcfiltroold))#0
	set filter to &lcfiltroold
else
  set filter to 
endif  
go lnrecno
Select(lcalias)
return lclinea

function Obtengonrocta
parameters lnrecnocta,lcidcuenta
lcidcuenta = iif(pcount()<2,"",lcidcuenta)
local lnnrocuenta,lcalias,lok
lcalias = Alias()

if lnrecnocta<>0
   Sele paraconta
   go lnrecnocta 
   lcidcuenta = idcuenta
endif
lok = seek(lcidcuenta,'plancue','cid')
lnnrocuenta = iif(lok,plancue.cuenta,0)

Select(lcalias)
return lcidcuenta

function localizar
parameters Lccsralias,lccbusqueda
local lcalias,lok
lcalias = Alias()
Select(lccsralias)
locate for &lccbusqueda
lok = iif(!eof() and &lccbusqueda,.t.,.f.)
Select(lcalias)
return lok

function CajaValida
parameters lnnrocaja,ldfechad,ldfechah
local ldfechacaja,lok
ldfechacaja = ctod(righ(str(lnnrocaja,8),2)+'-'+subs(str(lnnrocaja,8),5,2)+'-'+left(str(lnnrocaja,8),4))
if empty(ldfechacaja)
   =messagebox('El N�mero de caja '+strzero(lnnrocaja,8)+' no es valido',0,'Informaci�n al usuario')
   return .f.
endif
lok=seek(lnnrocaja,'tablacaja','nrocaja')
if lok
   ldfechad = tablacaja.fecdesde
   ldfechah = tablacaja.fechasta
endif
return .t.

Function Usar
lparameters mcdbf,mluse_ex,mcalias,mnbuffering
local lcaliasactivo
lcaliasactivo = alias()

mcalias     = iif(pcount()<3,mcdbf,mcalias)
mnbuffering = iif(pcount()<4,5,mnbuffering)

if used('&mcalias')
   return .t.
endif

if mluse_ex
   use &mcdbf in 0 alias &mcalias exclusive
else   
   use &mcdbf in 0 alias &mcalias shared
endif	
Select &Pcbasedbf           
cursorsetpro('BUFFERING',mnbuffering)     

if len(trim(lcaliasactivo))#0
   Select &lcaliasactivo
endif

return .t.

Function LeerXML(tcArchivo,oscreen)
   If !File( tcArchivo )
	   CREATE CURSOR temp (top n(12,0),left n(12,0),height n(12,0),width n(12,0))
	   INSERT into temp VALUES (_screen.Top,_screen.Left,_screen.Height,_screen.Width)
	   SELECT temp
	   scatter name oscreen
	   SET SAFETY off
	   CURSORTOXML('Temp',  tcArchivo, 1, 512)
	   SET SAFETY ON
	   Use In Temp
   Else
      XmlToCursor( tcArchivo, 'Cur_Temporal',512 )
      SELECT cur_temporal
      SCATTER NAME oscreen
      Use In Cur_Temporal
   EndIf
   Return .T.
ENDFUNC

Function GrabarXML(tcArchivo,oscreen)
   IF USED('temp')
      USE IN temp
   endif
   CREATE CURSOR temp (top n(12,0),left n(12,0),height n(12,0),width n(12,0))
   APPEND BLANK IN temp   
   SELECT temp
   gather name oscreen
   SET SAFETY off
   CURSORTOXML('Temp',  tcArchivo, 1, 512)
   SET SAFETY ON
   Use In Temp
   RELEASE oscreen
   Return .T.
   
ENDFUNC

Function LeerXMLClassID(tcArchivo)
   Public Array gaClassIDs[1]
   If !File( tcArchivo )
      =Oavisar.usuario('No se encuentra el archivo xml de configuraci�n',0)
      Quit
   Else
      XmlToCursor( tcArchivo, 'Cur_Temporal',512 )
      Select * From Cur_Temporal Into Array gaClassIDs
      Use In Cur_Temporal
   EndIf
   Return .T.
ENDFUNC

Function ObtenerClassID(tcObjeto,lcServidor,lcOriObj)
   Local lcClassID,niCount
   LcClassID = ''   
   For niCount = 1 To Alen(gaClassIDs,1)
      if ALLTRIM(Lower(gaClassIDs[niCount,1])) == ALLTRIM(Lower(tcObjeto))
         lcOriObj   = ALLTRIM(gaClassIds[niCount,2])         
         lcClassID  = ALLTRIM(gaClassIDs[niCount,3])
         lcServidor = ALLTRIM(gaClassIds[niCount,4])
         Exit
      EndIf
   Next
   Return lcClassID
ENDFUNC

Function CrearObjeto(tcObjeto)
      
   Local loObjeto, lcClassID,lcServidor,lcOriObj
   lcServidor = ""
   lcOriObj   = ""
   lcClassID = ObtenerClassID(tcObjeto,@lcServidor,@lcOriObj)
      
   If Empty(lcClassID) AND lcOriObj='COM'
      =Oavisar.programador('No se encuentra el class id del objeto ' + tcObjeto)
      QUIT 
   ELSE
      DO CASE 
         CASE lcOriObj='WS'         
              LoObjeto=Createobject("mssoap.soapclient30") && Creamos Objeto Soap
              LoObjeto.mssoapinit(LcServidor) 
              LoObjeto.ConnectorProperty("ConnectTimeout")=90000
         CASE LcOriObj='COM'
              loObjeto = CreateObjectex(lcClassID,lcServidor,"")               
         OTHERWISE 
              loObjeto = CREATEOBJECT('&lcClassID')              
      ENDCASE               
   EndIf
   Return loObjeto
ENDFUNC


FUNCTION ObtenerConfig
PARAMETERS lObjConfig

IF VARTYPE(Ofiscal)="O"
	RELEASE Ofiscal
ENDIF 
 Ofiscal =NEWOBJECT("fiscal","fiscal.vcx")
Ofiscal.objconfigfiscal(@lObjConfig,1)

lcPathCf		 	   = lObjConfig.PathCf
lnPuertoCom		   = lObjConfig.PuertoCom
lnModeloFiscal	   = lObjConfig.ModeloFiscal
lnVerificacionFiscal = lObjConfig.verificacionfiscal

lcDirDato = lcPathCf + "DATOS\"
lcDirExe   = lcPathCf + "EXE\"
lcDirFiscal  = lcPathCf  + "FISCAL\"

RETURN  .t.


FUNCTION ObtenerServidor

LOCAL lcServidor,lcUser,lcPwd

lcSvrcf = ""
lcSvrcfODBC = ""
LcConectionString   = lcSvrCf
LcDataSourceType  = "NATIVE"
LcOrigenPublico      = ""
LcWebService          = ""
lcServername           = ""
lsalgo				   = .f.

lcConectionODBC = lcSvrcfODBC

Oagregaobjeto = CREATEOBJECT("agregaobjeto")
lObjConfig = null
Oagregaobjeto.objconfigbd(@lObjConfig,1)
		
lcOrigenData	= lObjConfig.origendata
lcSourceType	= lObjConfig.sourcetype
lcServidor		= lObjConfig.servername
lcInitCatalo	= lObjConfig.initCatalogo
lcUser			= lObjConfig.username
lcPwd			= lObjConfig.pwdname
Pnsucursal	= lObjConfig.sucursal

Goapp.OrigenData	= LCorigendata
Goapp.SourceType	= LCsourcetype
Goapp.Servidor		= LCServidor
Goapp.InitCatalo		= LCinitCatalo
Goapp.Usuario		= LCUser
Goapp.Pwd			= Lcpwd
Goapp.sucursal		= Pnsucursal
Goapp.terminal		= 0 &&Pnterminal
   
IF lcSourceType="NATIVE"
	lcSvrCf =lcInitCatalo
	ELSE 
		IF LEN(TRIM(lcServidor))#0 AND LEN(TRIM(lcUser))#0 AND LEN(TRIM(lcPwd))#0
			lcSvrCf = "Provider=SQLOLEDB.1;Persist Security Info=False"
			lcSvrCf = lcSvrCf + ";Initial Catalog="+lcInitCatalo
			lcSvrCf = lcSvrCf + ";Data Source=" + lcServidor
			lcSvrCf = lcSvrCf + ";User ID="+lcUser
			lcSvrCf = lcSvrCf + ";pwd="+lcPwd + ";"
			
			lcSvrcfODBC = "Driver={SQL Server}"
			lcSvrcfODBC = lcSvrcfODBC + ";Server="+lcServidor
			lcSvrcfODBC = lcSvrcfODBC + ";Database="+lcInitCatalo
			lcSvrcfODBC = lcSvrcfODBC + ";Uid="+lcUser
			lcSvrcfODBC = lcSvrcfODBC + ";Pwd="+lcPwd + ";"
		ENDIF 		   
ENDIF 
   
 LcConectionString	= lcSvrCf
 LcDataSourceType	= lcSourceType
 LcOrigenPublico		= lcOrigenData
 LcWebService		= ''

lcConectionODBC	= lcSvrcfODBC
  
 lsalgo = IIF(LEN(TRIM(lcInitCatalo))#0,.t.,.f.)

RETURN  lsalgo

ENDFUNC


*lc = Encripta("MiClave", "MiLlave")

* Desencripta(lc, "MiLlave")

FUNCTION Encripta(tcCadena, tcLlave, tlSinDesencripta)
	lcRet = ""
	lc = ALLTRIM(tcCadena)
	
	for i=1 to LEN(lc)
    		lcRet=lcRet+chr(asc(substr(lc,i,1))+25+i)
	NEXT
	RETURN lcRet
ENDFUNC

FUNCTION Desencripta(tcCadena, tcLlave)
	lcRet = ""
	lc = tcCadena
	for i=1 to LEN(lc)
    		lcRet=lcRet+chr(asc(substr(lc,i,1))-25-i)
	NEXT
	RETURN RTRIM(lcRet)
ENDFUNC

*---------------------------------------------
* Funci�n usada por Encripta y Desencripta
*---------------------------------------------

FUNCTION GetClaves(tcLlave, tnClaveMul, tnClaveXor)

	LOCAL lc, ln

	lc = ALLTRIM(LOWER(tcLlave))

	tnClaveMul = 31
	tnClaveXor = 3131

	DO WHILE NOT EMPTY(lc)

		tnClaveMul = BITXOR(tnClaveMul,ASC(lc))

		tnClaveXor = BITAND((tnClaveXor+1)*(ASC(lc)+1),0xFFFF)

		lc = IIF(LEN(lc) > 1,SUBS(lc,2),"")

	ENDDO

ENDFUNC

FUNCTION Redondeo
PARAMETERS pnredondeo

LOCAL lcredondeo,lnredondeo

SET DECIMALS TO 3
lcredondeo = TRANSFORM(pnredondeo,'999999999.999')
lnredondeo = VAL(LEFT(lcredondeo,LEN(lcredondeo)-1))
SET DECIMALS TO 2

RETURN lnRedondeo 


FUNCTION  Proximomes
PARAMETERS  fec,meses

LOCAL dia_leido,anio_leido,mes_leido
mesanio='312831303130313130313031'
dia_leido=day(fec)
anio_leido=year(fec)
mes_leido=month(fec)
mes_leido=mes_leido+meses
if mes_leido > 12
   mes_leido=mes_leido-12
   anio_leido=anio_leido+1
   do while mes_leido > 12
      mes_leido=mes_leido-12
      anio_leido=anio_leido+1
   enddo
else
   if mes_leido<=0
      mes_leido=12
      anio_leido=anio_leido-1
   endif
endif
if dia_leido>val(substr(mesanio,mes_leido*2-1,2))
   dia_leido=val(substr(mesanio,mes_leido*2-1,2))
endif
fec=ctod(str(dia_leido,2)+'-'+str(mes_leido,2)+'-'+str(anio_leido,4))
return (fec)

FUNCTION  Semana
PARAMETERS  ldfecha

LOCAL  fecdesde,fechasta,dia,quesemana,j

fecdesde = ctod('01-'+Strzero(month(ldfecha),2)+'-'+Strzero(Year(ldfecha),4))
fechasta = gomo(fecdesde,1) - 1
quesemana=0
for j=1 to day(ldfecha)
    dia = ctod(strzero(j,2)+'-'+strzero(month(ldfecha),2)+'-'+strzero(year(ldfecha),4))
    if dow(dia)=1 OR  quesemana=0
       quesemana = quesemana + 1
    endif
Next
return quesemana

FUNCTION ULDIA(_mes_leido,_anio)
mesanio='312831303130313130313031'
if int(_anio/4)=_anio/4
   mesanio='312931303130313130313031'
endif
Return Val(subs(mesanio,_mes_leido*2-1,2))


FUNCTION Cbanteafecta
PARAMETERS lcnuevofiltro,lcAliasComp

lcnuevofiltro = IIF(pcount()<1,'',lcnuevofiltro)
lcAliasComp= IIF(PCOUNT()<2,"CsrComprobante",lcAliasComp)

local lclinea,lnrecno,lcidentre,lcafectado,lcalias
lcalias = alias()
lclinea    = ''

SELECT CsrComprobante
lnrecno    = recno()
lcidentre  = Csrcomprobante.id
lcafectado = Csrcomprobante.afectado

* lcAliasComp puede ser <> de Csrcomprobante ya que Csrcomprobante puede estar filtrado en el where del select 

SELECT(lcAliasComp)
GO TOP 
SCAN  FOR  !eof()
	IF len(trim(lcnuevofiltro))#0
	   IF &lcnuevofiltro#1
	       LOOP 
	   ENDIF 
	ENDIF 	     
	IF id=lcidentre
		LOOP 
	ENDIF   
	IF  trim(clase)$lcafectado
		lclinea = lclinea + iif(len(trim(lclinea))=0,'','-') + STR(id,10)
	ENDIF 
ENDSCAN 
GO  lnrecno
Select(lcalias)
RETURN  lclinea

FUNCTION MaySTR
PARAMETERS lcnombre
LOCAL lni,lc
lcnombre = ALLTRIM(UPPER(lcnombre))
IF '�'$lcnombre OR '�'$lcnombre
	FOR lni=1 to LEN(lcnombre)
		lc=SUBSTR(lcnombre,lni,1)
	 	IF '�'=lc OR '�'$lc
	 		lcnombre = ALLTRIM(SUBSTR(lcnombre,1,lni-1))+ALLTRIM('�')+ALLTRIM(SUBSTR(lcnombre,lni+1,LEN(lcnombre)))
	 	ENDIF 
	 ENDFOR  
ENDIF 
RETURN lcnombre

FUNCTION FArmoArray
PARAMETERS lnfila,lncantCol,lcArray00,lcarray01,lcarray02,lcarray03,lcarray04,lcarray05,lcarray06,lcarray07,lcarray08,lcarray09,lcarray10,lcarray11,lcarray12,lcarray13,lcarray14;
				,lcarray15,lcarray16,lcarray17,lcarray18,lcarray19,lcarray20,lcarray21,lcarray22,lcarray23,lcarray24,lcarray25,lcarray26

* lcarray00 viene array ocx
* lcarray01 viene modelo fiscal
* lcarray02  a lcarray26 comprobantes por tipo de modelo

LOCAL i,lcCol ,lcstringComp,lcvariable
lcStringComp = ""
lcvariable = "lcStringComp"

FOR i=1 TO lncantCol + 1
	lcCol = "lCarray"+strzero(i,2)
	IF i=1        
		lcArray00[lnfila,1] = &lcCol
	ELSE
		lcStringComp = lcStringComp + "-" + strzero(&lcCol,3)
	ENDIF 	         
NEXT 
lcArray00[lnfila,2] = &lcvariable

RETURN .t. 


FUNCTION CrearCursorAdapter
PARAMETERS lcaliasCursor,lccmdSelectCursor,loCursorbuffermodeoverride,lbCartel

IF USED(lcaliasCursor)
   USE IN (lcaliasCursor)
ENDIF

&&Si se obvia el parametro del buffer.
&&trae un falso. Asi que lo tomamos como un objeto.
IF PCOUNT()<3
	cursorbuffermodeoverride = 5
ELSE
	IF VARTYPE(loCursorbuffermodeoverride)='N'
		cursorbuffermodeoverride = loCursorbuffermodeoverride
	ELSE
		cursorbuffermodeoverride = 5
	ENDIF 
ENDIF 

lbcartel				=  IIF(PCOUNT()<4,.t.,lbCartel)
&&el CursorFill captura los errores, las veces que se necesite capturar de forma externa.
&&para informar que paso. Ejemplo los MICROCORTES

lccmdSelectCursor=  CHRTRAN(lccmdSelectCursor,CHR(9)," ")
lccmdSelectCursor= CHRTRAN(lccmdSelectCursor,CHR(13)," ")
lccmdSelectCursor= CHRTRAN(lccmdSelectCursor,CHR(10)," ")

Orslista = null 
Ocalista = null
Orslista= createobject('ADODB.RecordSet')
Orslista.CursorLocation   = 3  && adUseClient
Orslista.LockType         = 3  && adLockOptimistic
IF TYPE('loConnDataSource')='O'
   Orslista.ActiveConnection = loConnDataSource
ENDIF 
OCAlista = CREATEOBJECT("CursorAdapter")
WITH OCAlista
    .Alias     = lcaliasCursor
    .DataSource = Orslista
    .DataSourceType = LcDataSourceType
    .SelectCmd=lccmdSelectCursor
    .UseDedatasource=.f.
    .BufferModeOverride = cursorbuffermodeoverride 
    .Name = lcaliasCursor
    .UpdateType = 1
ENDWITH 

LOCAL lreturn
lreturn = .f.

IF !OCAlista.CursorFill()
	IF AERROR(laError) > 0 AND lbCartel 
		=Oavisar.Usuario("Error al obtener datos:"+laError[2]+" alias "+lcaliasCursor+CHR(13)+lccmdSelectCursor,0)
		oavisar.proceso('N')
	ENDIF
ELSE
	OCAlista.CursorDetach()
	lreturn = .t.   
ENDIF
        
RETURN lreturn

FUNCTION EjecutaMenu
PARAMETERS lcForm,lcparam1,lcparam2,lcparam3,lcparam4,lcparam5,lcparam6,lcparam7,lcparam8,lcparam9,lcparam10
	lcform = IIF(PCOUNT()<1,"",lcForm)
	lcparam1 = IIF(PCOUNT()<2,"",lcparam1)
	lcparam2 = IIF(PCOUNT()<3,"",lcparam2)
	lcparam3 = IIF(PCOUNT()<4,"",lcparam3)
	lcparam4 = IIF(PCOUNT()<5,"",lcparam4)
	lcparam5 = IIF(PCOUNT()<6,"",lcparam5)
	lcparam6 = IIF(PCOUNT()<7,"",lcparam6)
	lcparam7 = IIF(PCOUNT()<8,"",lcparam7)
	lcparam8 = IIF(PCOUNT()<9,"",lcparam8)
	lcparam9 = IIF(PCOUNT()<10,"",lcparam9)
	lcparam10 = IIF(PCOUNT()<11,"",lcparam10)
	LOCAL lcCmd,lok,_siactiva
	IF UPPER(lcForm) = "FRMMENU"
		TEXT TO lcCmd TEXTMERGE NOSHOW 
		SELECT Csrseteotermi.* FROM seteotermi as Csrseteotermi WHERE sucursal = <<Goapp.sucursal>> and numero=<<Goapp.terminal>> 
		ENDTEXT 
		IF USED("CsrSeteotermi")
			USE IN CsrSeteotermi
		ENDIF
		lok =CrearCursorAdapter("CsrSeteotermi",lcCmd)
		_siactiva=Csrseteotermi.termiactiva=1
	ELSE
		lok= .t. 
		_siactiva=1
	ENDIF
	* Ejecuto si terminal activa, siempre FRMLOGOUT, siempre perfilusuario 1=Admin
	IF lok
		IF _siactiva=1 OR UPPER(lcForm) = "FRMLOGOUT" OR Goapp.perfilusuario=1
			RELEASE OrsTerminal
			RELEASE OCaterminal
			IF LEN(TRIM(lcform))#0 
				DO CASE 
					CASE LEN(TRIM(lcparam1))=0
						DO FORM &lcForm
					CASE LEN(TRIM(lcparam2))=0
						DO FORM &lcForm WITH lcparam1
					CASE LEN(TRIM(lcparam3))=0
						DO FORM &lcForm WITH lcparam1,lcparam2
					CASE LEN(TRIM(lcparam4))=0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3
					CASE LEN(TRIM(lcparam5))=0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3,lcparam4
					CASE LEN(TRIM(lcparam6))=0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3,lcparam4,lcparam5
					CASE LEN(TRIM(lcparam7))=0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3,lcparam4,lcparam5,lcparam6
					CASE LEN(TRIM(lcparam8))=0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3,lcparam4,lcparam5,lcparam6,lcparam7
					CASE LEN(TRIM(lcparam9))=0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3,lcparam4,lcparam5,lcparam6,lcparam7,lcparam8
					CASE LEN(TRIM(lcparam10))=0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3,lcparam4,lcparam5,lcparam6,lcparam7,lcparam8,lcparam9
					CASE LEN(TRIM(lcparam10))#0
						DO FORM &lcForm WITH lcparam1,lcparam2,lcparam3,lcparam4,lcparam5,lcparam6,lcparam7,lcparam8,lcparam9,lcparm10
				ENDCASE 
			ELSE
				=Oavisar.usuario("OPCION NO DISPONIBLE")
			ENDIF 
		ELSE
			=Oavisar.usuario('LA TERMINAL SE ENCUENTRA BLOQUEADA'+CHR(13)+'CONSULTE CON EL ADMINISTRADOR',0) 
		ENDIF 
		RELEASE OrsTerminal
		RELEASE OCaterminal
	ENDIF 
	IF USED("CsrSeteotermi")
		USE IN CsrSeteotermi
	ENDIF
RETURN .t.


FUNCTION LeerEmpresa

LOCAL lcCmd,lok,lcpc

lcpc    = UPPER(TRIM(LEFT(SYS(0),(AT('#',SYS(0))-1))))

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT Csrempresa.* FROM empresa as Csrempresa
ENDTEXT 

IF USED("Csrempresa")
	USE IN Csrempresa 
ENDIF

lok =CrearCursorAdapter("Csrempresa",lcCmd)

IF lok

    GOapp.empresaid 				= Csrempresa.id
   GOapp.empresanombre		= Csrempresa.nombre
   GOapp.empresaramo			= Csrempresa.ramo
   GOapp.empresadireccion		= Csrempresa.direccion
   GOapp.empresacpostal		= Csrempresa.cpostal
   GOapp.empresalocalidad		= Csrempresa.localidad
   GOapp.empresaprovincia		= Csrempresa.provincia
   GOapp.empresatelefono		= Csrempresa.telefono
   GOapp.empresatipoiva			= Csrempresa.tipoiva
   GOapp.empresacuit			= Csrempresa.cuit
   GOapp.empresaibruto 			= Csrempresa.ibruto
   GOapp.empresacajapre		= Csrempresa.cajapre
   GOapp.empresaimpint			= Csrempresa.impint
   Goapp.empresaagenteibb        = Csrempresa.agenteibb
   GOapp.empresatag				= Csrempresa.tag
   goapp.empresarete			=Csrempresa.retenedora
   goapp.empresareteiva			= CsrEmpresa.reteiva
   Goapp.empresaincluyeiva		= IIF(CsrEmpresa.incluyeiva=1,.t.,.f.)
   Goapp.empresautilidad		= IIF(CsrEmpresa.utilidad=1,.t.,.f.)
   Goapp.empresautisobreflete	= IIF(CsrEmpresa.utisobreflete=1,.t.,.f.)
   Goapp.empresautisobreinterno = IIF(CsrEmpresa.utisobreinterno=1,.t.,.f.)
   Goapp.empresapagweb			= DefaultVar('CsrEmpresa.pagweb','')
   Goapp.empresaemail			= DefaultVar('CsrEmpresa.email','')
   goApp.rutaaplicacion			= DefaultVar('CsrEmpresa.rutaaplicacion',SYS(5)+Curdir())
  * oavisar.programador(goApp.rutaaplicacion)
ENDIF
   
IF USED("Csrseteotermi")
	USE IN Csrseteotermi 
ENDIF

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT Csrseteotermi.* FROM seteotermi as Csrseteotermi WHERE sucursal = <<Goapp.sucursal>> and nombre='<<lcpc>>'
ENDTEXT 

lok =CrearCursorAdapter("Csrseteotermi",lcCmd)
IF lok
   Goapp.terminal               = Csrseteotermi.numero
   Goapp.nombreterminal = Csrseteotermi.nombre
ENDIF

IF USED("Csrseteotermi")
	USE IN Csrseteotermi 
ENDIF

IF USED('CsrPAraVario')
	USE IN CsrPAraVario
ENDIF 

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT CsrParaVario.* FROM paravario as CsrParavario WHERE idorigen = <<Goapp.terminal>> and nombre='REPORTE<<strzero(goapp.terminal,4)>>'
ENDTEXT 
IF CrearCursorAdapter("Csrparavario",lcCmd)
	IF RECCOUNT('csrparavario')#0
		goapp.rutasalidareporte = CsrParaVario.detalle
	ENDIF 
ENDIF
 
IF USED('CsrPAraVario')
	USE IN CsrPAraVario
ENDIF 

RETURN .t.


FUNCTION LeerVersionExe
PARAMETERS lnopcion,lcExe

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

STORE "" TO lcfechasis,lchorasis,lchoraExe,lcfechaexe,lcExe

IF lok
	lcfechasis = CsrSistema.fecha
	lchorasis   = CsrSistema.hora	    
	lcExe          = lcCurdir+TRIM(CsrSistema.programa)     && guardo el nombre del ejecutable
	
	lnprioridad = IIF(CsrSistema.prioridad=0 or 	CsrSistema.prioridad > ALEN(lcMenPrioridad),1,CsrSistema.prioridad)
	lcMensaje = lcMenPrioridad[lnprioridad]	
	
       x = Adir(lCarray, lcExe,"H")
       
	IF x=1
		lcfechaexe = DTOS(lcArray[1,3])
		lchoraexe   = lcarray[1,4]
	ENDIF
	
	IF lcfechaExe # lcfechasis OR lchoraExe # lchorasis
		_screen.Visible = .t.
		_screen.lockscreen=.f.
		IF lnopcion=1
			=OAvisar.usuario("EXISTE UNA NUEVA VERSION DEL SISTEMA "+CHR(13)+CHR(13)+UPPER(lcExe)+CHR(13);
								+"Fecha :  "+RIGHT(lcfechasis,2)+"-"+SUBSTR(lcfechasis,5,2)+"-"+LEFT(lcfechasis,4)+"    hora :  "+lchorasis+CHR(13)+CHR(13);
								+"Prioridad : "+lcMensaje,0)
			lok = IIF(strzero(lnprioridad,2)$"01-02",.f.	,.t.)
		ELSE
			=OAvisar.usuario("EXISTE UNA NUEVA VERSION DEL SISTEMA "+CHR(13)+CHR(13)+UPPER(lcExe)+CHR(13);
								+"Fecha :  "+RIGHT(lcfechasis,2)+"-"+SUBSTR(lcfechasis,5,2)+"-"+LEFT(lcfechasis,4)+"    hora :  "+lchorasis+CHR(13)+CHR(13);
								+"Prioridad : "+lcMensaje,0)

		 	IF strzero(lnprioridad,2)$"01-02"
		 	    lok=6
		 	ELSE
		 		lok=Oavisar.usuario("Prioridad "+lcMensaje+CHR(13)+"Lo actualiza",4+32+256)		 		
		 	ENDIF 
		 	
			IF lok=6		 	
				Oavisar.proceso('S','Aguarde un instante, actualizando '+UPPER(lcExe),.f.,0)				
	                    INKEY(.5)
	                    										      
				TEXT TO lcCmd TEXTMERGE NOSHOW 
				SELECT Csrgestion.* FROM gestion as Csrgestion
				ENDTEXT 

				IF USED("Csrgestion")
					USE IN Csrgestion
				ENDIF

				lok    =CrearCursorAdapter("Csrgestion",lcCmd)
				
				IF lok
				     lcdd = lcCurdir+TRIM(Csrgestion.nombrezip)   && nombre del archivo zip a extraer				     
					STRTOFILE(Csrgestion.programa,lcdd)					
					 oShell = createobject("WScript.Shell")					 
					 IF FILE(lcdd)
						 oShell.run("&lcdd",0,.t.)
						 CLEAR EVENTS
					ENDIF 					 
					 oShell = null
				ENDIF 		   					
				Oavisar.proceso('N')
			ENDIF 			
			
		ENDIF 			
	ENDIF	       	
ENDIF
   
IF USED("Csrsistema")
	USE IN Csrsistema 
ENDIF

IF USED("CsrGestion")
	USE IN CsrGestion  
ENDIF 

RETURN lok


FUNCTION LeerParametrosDiario
PARAMETERS lnopcion
*1 = caja facturacion
*2 = caja activa
* 19/01/2012 - Marcos
* Modifique el valor por defecto, ya que solo hay pocos formularios que usan la fecha de fac.
lnopcion = IIF(PCOUNT()<1,2,lnopcion)

LOCAL lcCmd,lok,ldfechaserver,lreturn

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT Csrparaconfig.*,csrdetanrocaja.nrocaja as nrocaja,csrdetanrocaja.fecdesde as fecdesde
,csrdetanrocaja.fechasta as fechasta,Csrdetanrocaja.switch as switchCaja
,csrdetaconta.ejercicio,ISNULL(CsrDetaNrocajaFac.nrocaja,0) as nrocajafac
,ISNULL(Csrdetanrocajafac.switch,'00000') as switchCajaFac
FROM paraconfig as Csrparaconfig
left join detanrocaja as csrdetanrocaja on Csrparaconfig.iddetanrocaja = csrdetanrocaja.id
left join detaconta as csrdetaconta on CsrParaConfig.idejercicio = CsrDetaConta.id
left join detanrocaja as csrdetanrocajafac on Csrparaconfig.iddetafac = csrdetanrocajafac.id
ENDTEXT 

lok =CrearCursorAdapter("CsrParametros",lcCmd)
lreturn = .t.

*stop()
IF lok

	LOCAL lObjEjercicioActivo as Object 

	LeerEjercicioActivo(@lObjEjercicioActivo)
	SELECT CsrParametros

  	DO case 
		CASE lnopcion=1
    			lcmensaje = "fecha activa actual de facturaci�n "+DTOC(TTOD(Csrparametros.fechafac))+CHR(13);
						+"estado de la caja "+IIF(LEFT(Csrparametros.switchCajaFac,1)="1","CERRADA","ACTIVA")
		CASE lnopcion=2
    			lcmensaje = "caja activa actual "+STR(Csrparametros.nrocaja,8)+CHR(13);
    			+"estado de la caja "+IIF(LEFT(Csrparametros.switchCaja,1)="1","CERRADA","ACTIVA")
  	ENDCASE 
  	SCATTER NAME OscParametros
	&&Recuperamos el ejercicio a la cual pertenece la fecha de facturacion. Para registrar el asiento contable
	IF !LeerEjercicioActivoFac(OscParametros)
		RETURN .f.
	ENDIF 
	
	IF ((LEFT(Csrparametros.switchCaja,1)="1" AND  lnopcion=2) OR (lnopcion=1 AND  LEFT(Csrparametros.switchCajaFac,1)="1"))&& caja cerrada


		TEXT TO lccmd TEXTMERGE NOSHOW
		SELECT CsrDataMenu.* FROM Datamenu as csrdatamenu
		ENDTEXT 
							
		lok =CrearCursorAdapter("Csrdatamenu",lcCmd) 

		IF lok
			SELECT CsrDataMenu
			LOCATE FOR "PARADIARIO"$UPPER(sec_doacce)
			IF !EOF() AND "PARADIARIO"$UPPER(sec_doacce)
				TEXT TO lccmd TEXTMERGE NOSHOW
				SELECT Csrseguridad.* FROM seguridad as csrseguridad WHERE idmenu=<<Csrdatamenu.id>>				
				ENDTEXT 
										
				lok =CrearCursorAdapter("Csrseguridad",lcCmd) 

				IF goapp.perfilusuario=CsrSeguridad.idperfil
					=Oavisar.usuario("Contacte a un usuario con permiso para cambiar parametros diarios;"+CHR(13)+ lcmensaje +CHR(13)+CHR(13);
							+"UTILES \\ PARAMETROS \\ PARAMETROS DIARIOS")
				ELSE					
					=Oavisar.usuario("Debe cambiar parametros diarios;"+CHR(13)+ lcmensaje +CHR(13)+CHR(13);
							+"UTILES \\ PARAMETROS \\ PARAMETROS DIARIOS")
				ENDIF
				lreturn = .f.
								
				IF USED("Csrseguridad")
					USE IN Csrseguridad				
				ENDIF 			
			ENDIF 		
		ELSE 			
			=Oavisar.usuario("Debe cambiar parametros diarios;"+CHR(13)+ lcmensaje +CHR(13)+CHR(13);
							  +"UTILES \\ PARAMETROS \\ PARAMETROS DIARIOS")							    
				lreturn = .f.							
		ENDIF
				
		IF USED("CsrDatamenu")
			USE IN Csrdatamenu
		ENDIF		
	ELSE
		IF CsrParametros.nrocaja < lObjEjercicioActivo.nrocaja1 OR CsrParametros.nrocaja > lObjEjercicioActivo.nrocaja2
			=Oavisar.usuario("Contacte a un usuario con permiso para cambiar parametros diarios;"+CHR(13)+lcmensaje+CHR(13)+CHR(13);
				+"Caja "+TRANSFORM(CsrParametros.nrocaja,"99999999")+" no pertenece al ejercicio activo / seleccionado"+CHR(13)+CHR(13);
				+"Ejercicio activo / seleccionado "+STR(lObjEjercicioActivo.ejercicio,3)+CHR(13);
				+"fecha desde "+DTOC(TTOD(lObjEjercicioActivo.fecdesde))+" fecha hasta "+DTOC(TTOD(lObjEjercicioActivo.fechasta))+CHR(13);
				+"caja desde   "+TRANSFORM(lObjEjercicioActivo.Nrocaja1,"99999999")+"    caja hasta   "+TRANSFORM(lObjEjercicioActivo.nrocaja2,"99999999"),0)
			lreturn = .f.
		ENDIF 
	ENDIF 			
ENDIF 

IF USED("CsrParametros")
	USE IN CsrParametros
ENDIF
   
RETURN lreturn


*!*	FUNCTION ConeccionADO

*!*	Local  loCatchErr As Exception
*!*	LOCAL lok
*!*	lok = .t.
*!*	TRY 
*!*		DO case
*!*			CASE LcDataSourceType='ADO' OR LcDataSourceType='ODBC'
*!*				loConnDataSource = createobject('ADODB.Connection')
*!*				loConnDataSource.ConnectionString = LcConectionString
*!*				loConnDataSource.CommandTimeout = 0    && indefinidamente
*!*				loConnDataSource.ConnectionTimeout = 60

*!*				Oavisar.proceso('S','Conectando con Base de Datos, tiempo de espera '+LTRIM(STR(loConnDataSource.ConnectionTimeout))+'"' ,.f.,0)
*!*								                              			    
*!*				loConnDataSource.Open()
*!*								                        			    
*!*				Oavisar.proceso('N')
*!*			                       			                           	  	
*!*			CASE LcDataSourceType='NATIVE'
*!*				IF !DBUSED('&LcConectionString')        
*!*					OPEN DATABASE (LcConectionString) SHARED
*!*				ENDIF  
*!*				SET DATABASE TO (LcConectionString)
*!*			OTHERWISE 
*!*				ERROR 1429
*!*			ENDCASE
*!*	Catch To loCatchErr
*!*		=Oavisar.proceso('N')	
*!*		=Oavisar.usuario('La conexi�n a la Base de Datos a fallado'+CHR(13);
*!*						+CHR(13)+lcConectionString,0)
*!*		lok = .f.
*!*	ENDTRY 

*!*	RETURN lok


*!*	FUNCTION ConeccionODBC
*!*	*!*	***Evitar que aparezca  la ventana de login
*!*	SQLSETPROP(0,"DispLogin",3)
*!*	lnconectorODBC =SQLSTRINGCONNECT(lcConectionODBC)
*!*	IF lnconectorODBC<0
*!*		RETURN .f.
*!*	ENDIF 
*!*	RETURN .t.

*!*	FUNCTION ExisteDSN

*!*	IF LcDataSourceType="NATIVE"
*!*	   RETURN .t.
*!*	ENDIF 

*!*	#define ODBC_ADD_DSN  1    && Agregar Fuente de Datos
*!*	#define ODBC_CONFIG_DSN  2    && Configurar (editar) fuente de datos
*!*	#define ODBC_REMOVE_DSN  3    && Eliminar fuente de datos
*!*	#define ODBC_ADD_SYS_DSN  4    && Agregar un DSN de Sistema
*!*	#define ODBC_CONFIG_SYS_DSN  5    && Configurar un DSN de Sistema
*!*	#define ODBC_REMOVE_SYS_DSN  6    && Eliminar un DSN de Sistema 
*!*	#define vbAPINull          0    &&' NULL Pointer

*!*	DECLARE LONG SQLConfigDataSource IN ODBCCP32.DLL ;
*!*	LONG hwndParent, LONG fRequest, ;
*!*	STRING lpszDriver, STRING lpszAttributes

*!*	  LOCAL intRet, strDriver, strAttributes,lcdns

*!*	  strDriver = "SQL Server"
*!*	  
*!*	  lcdns = STRTRAN(Goapp.servidor,".","_")
*!*	  lcdns = ALLTRIM(LEFT(STRTRAN(lcdns,"\",""),8)) + "_"+ ALLTRIM(LEFT(TRIM(Goapp.InitCatalo),8))
*!*	  
*!*	  strAttributes = "SERVER="+TRIM(Goapp.Servidor )+ Chr(0)
*!*	  strAttributes = strAttributes + "DESCRIPTION="+TRIM(lcDns)+ Chr(0)
*!*	  strAttributes = strAttributes + "DSN="+TRIM(lcDns)  + Chr(0)
*!*	  strAttributes = strAttributes + "DATABASE="+TRIM(Goapp.InitCatalo)  + Chr(0)
*!*	*!*	  strAttributes = strAttributes + "UID="+Goapp.Usuario + Chr(0)
*!*	*!*	  strAttributes = strAttributes + "PWD="+Goapp.Pwd + Chr(0)
*!*	  
*!*	  intRet = SQLConfigDataSource(vbAPINull, ODBC_CONFIG_DSN , strDriver, strAttributes)   
*!*	  
*!*		IF intRet > 0    
*!*		      * ya existe el DNS
*!*		      RETURN .t.      
*!*		ELSE   
*!*			intRet = SQLConfigDataSource(vbAPINull, ODBC_ADD_DSN, strDriver, strAttributes)     
*!*			IF  intRet>0
*!*				RETURN .t.
*!*			ELSE 
*!*				RETURN .f.
*!*			ENDIF 
*!*		ENDIF 		
*!*	ENDFUNC 

*=======================================================================
*= Recupera la el ejercicio contable correspondiente a la caja activa
*=== Salidas
*===== Inicializa los valores en GOAPP
*=Invoca
*==== Main.prg
*=Modificado
*==== 30/12/2011 - Marcos
*==== 16/01/2012 - Marcos
*=======================================================================
FUNCTION LeerEjercicioPerfil

LOCAL lcCmd,lok,lnidejercicio


TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT TOP 1 Csrdetaconta.id as idejercicio,csrdetaconta.ejercicio as ejercicio
FROM paraconfig as Csrparaconfig
left join detanrocaja as csrdetanrocaja on CsrParaConfig.iddetanrocaja = CsrDetanrocaja.id
left join detaconta as csrdetaconta 
	on Csrdetanrocaja.nrocaja >= CsrDetaconta.nrocaja1 and CsrDetanrocaja.nrocaja <= csrdetaconta.nrocaja2
order by ejercicio desc 
ENDTEXT 

lok =CrearCursorAdapter("CsrCursor",lcCmd)

Goapp.ejercicioactual   = CsrCursor.ejercicio
Goapp.idejercicioactual = CsrCursor.idejercicio
Goapp.idejercicio       = CsrCursor.idejercicio
Goapp.ejercicio         = CsrCursor.ejercicio

lnidejercicio           = Goapp.idejercicio

IF LEFT(Goapp.switchperfil,1)="1"
	IF Goapp.idejercicio = 0
		Goapp.idejercicio = lnidejercicio
		Goapp.ejercicio   = Goapp.ejercicio &&Csrparaconfig.ejercicio
	ENDIF 
ENDIF 

IF USED("Csrparaconfig")
  USE IN Csrparaconfig
ENDIF

RETURN .t.
*=======================================================================
*= Recupera la correspondiente caja activa
*=== Parametros 
*===== lObjEjercicioActivo:objeto creado y parametrizado.
*===== lnhaycierre busca la primera caja sin cerrar
*=== Salidas
*===== lObjEjercicioActivo
*=Invoca
*==== LeerParametrosDiarios
*=Modificado
*==== 30/12/2011 - Marcos
*=======================================================================
FUNCTION LeerEjercicioActivo
PARAMETERS lObjEjercicioActivo,lnhaycierre

lnhaycierre = IIF(PCOUNT()<2,0,lnhaycierre)

IF VARTYPE(lObjEjercicioActivo)="O"
	RELEASE lObjEjercicioActivo
ENDIF 
lObjeto=NEWOBJECT("Agregaobjeto","odata.vcx")
lObjeto.objejercicioactivo(@lObjEjercicioActivo)

lObjEjercicioActivo.ejercicio = 0
lObjEjercicioActivo.fecdesde = {}
lObjEjercicioActivo.fechasta  = {}
lObjEjercicioActivo.Nrocaja1 = 0
lObjEjercicioActivo.nrocaja2  = 0
lObjEjercicioActivo.cajaactual  = 0
lObjEjercicioActivo.idcajaactual  = 0
lObjEjercicioActivo.fecCajadesde = {}
lObjEjercicioActivo.fecCajahasta  = {}

LOCAL lcCmd,lok

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT csrdetaconta.* FROM detaconta as Csrdetaconta WHERE Csrdetaconta.id = <<Goapp.idejercicio>>
ENDTEXT 

lok =CrearCursorAdapter("CsrCursor",lcCmd)

IF lok
	lObjEjercicioActivo.ejercicio = CsrCursor.ejercicio
	lObjEjercicioActivo.fecdesde  = CsrCursor.fecdesde
	lObjEjercicioActivo.fechasta  = CsrCursor.fechasta
	lObjEjercicioActivo.Nrocaja1  = CsrCursor.nrocaja1
	lObjEjercicioActivo.nrocaja2  = CsrCursor.nrocaja2
	lObjEjercicioActivo.peFiscalCaja = ""
	lObjEjercicioActivo.peFiscalCajaFac = ""
ENDIF


IF lnhaycierre=0
	TEXT TO lcCmd TEXTMERGE NOSHOW 
	SELECT csrdetanrocaja.id as id,csrdetanrocaja.nrocaja as nrocaja,csrdetanrocaja.fecdesde as fecdesde,csrdetanrocaja.fechasta as fechasta
	,Csrdetanrocaja.switch as switch,CsrDetanrocaja.pefiscal
	FROM paraconfig as Csrparaconfig
	left join detanrocaja as csrdetanrocaja on Csrparaconfig.iddetanrocaja = csrdetanrocaja.id
	Where Csrdetanrocaja.nrocaja >= <<lObjEjercicioActivo.Nrocaja1>> and Csrdetanrocaja.nrocaja <= <<lObjEjercicioActivo.Nrocaja2>>
	ENDTEXT 
	&&Buscamos la caja que pertenezca al rango del ejercicio
	&&Where CsrPAraConfig.idejercicio = <<goapp.idejercicio>>
ELSE
	TEXT TO lcCmd TEXTMERGE NOSHOW 
	SELECT csrdetanrocaja.id as id,csrdetanrocaja.nrocaja as nrocaja,csrdetanrocaja.fecdesde as fecdesde,csrdetanrocaja.fechasta as fechasta
	,Csrdetanrocaja.switch as switch,CsrDetanrocaja.pefiscal
	FROM detanrocaja as csrdetanrocaja
	where  Csrdetanrocaja.nrocaja >= <<lObjEjercicioActivo.Nrocaja1>> and Csrdetanrocaja.nrocaja <= <<lObjEjercicioActivo.Nrocaja2>>
	order by Csrdetanrocaja.nrocaja
	ENDTEXT 
ENDIF

lok =CrearCursorAdapter("CsrCursor",lcCmd)

IF lok
	IF lnhaycierre=1
		* busco la primer caja que este sin cerrar
		SELECT CsrCursor
		GO top
		SCAN 
			IF LEFT(switch,1)#"1"
				EXIT 
			ENDIF 			
		ENDSCAN 
	ENDIF 
	lObjEjercicioActivo.cajaactual     = CsrCursor.nrocaja
	lObjEjercicioActivo.idcajaactual  = CsrCursor.id
	lObjEjercicioActivo.fecCajadesde = CsrCursor.fecdesde
	lObjEjercicioActivo.fecCajahasta  = CsrCursor.fechasta
	lObjEjercicioActivo.peFiscalCaja = CsrCursor.pefiscal
ENDIF

RELEASE lObjeto

IF USED("CsrCursor")
	USE IN CsrCursor
ENDIF

RETURN .t.
*=======================================================================
*=============================================================================
*= Recupera la el ejercicio contable correspondiente a la caja de facturacion
*=== Parametros 
*===== OscParametros : objeto donde se encuentran el nrocaja
*=== Salidas
*===== carga en el goapp.idejerciciofac el valor del ejercicio contable
*=Invoca
*==== LeerParametrosDiarios
*=Creado
*==== 30/12/2011 - Marcos
*=============================================================================
FUNCTION LeerEjercicioActivoFac
PARAMETERS OscParametros
LOCAL lcCmd,lok

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT csrdetaconta.* FROM detaconta as Csrdetaconta 
WHERE Csrdetaconta.nrocaja1 <= <<OscParametros.nrocajafac>>
and <<OscParametros.nrocajafac>> <= CsrDetaconta.nrocaja2
ENDTEXT 

IF !CrearCursorAdapter("CsrCursor",lcCmd)
	Oavisar.usuario('Error al obtener datos')
ENDIF 

goapp.idejerciciofac = goapp.idejercicio
goapp.ejerciciofac = goapp.ejercicio

IF RECCOUNT('CsrCursor')#0
	goapp.idejerciciofac = CsrCursor.id
	goapp.ejerciciofac = CsrCursor.ejercicio
ELSE
	=Oavisar.usuario("Contacte a un usuario con permiso para agregar un nuevo ejercicio contable"+CHR(13)+CHR(13);
				+"Caja "+TRANSFORM(CsrParametros.nrocajafac,"99999999")+chr(13);
				+"     pertenece aun ejercicio inexistente"+CHR(13)+CHR(13);
				+"caja  facturaci�n "+TRANSFORM(OscParametros.nrocajafac,"99999999"),0)
ENDIF
IF USED("CsrCursor")
	USE IN CsrCursor
ENDIF

RETURN .t.
*=============================================================================
*=======================================================================
*= Recupera la el ejercicio contable correspondiente a una caja
*=== Parametros 
*===== lpnrocaja : nro de caja a buscar
*=== Salidas
*===== carga en el goapp.idejerciciocaja el valor del ejercicio contable
*=Invoca
*==== LisResOpe.scx
*=Creado
*==== 03/01/2012 - Gabriel
*=======================================================================
FUNCTION LeerEjercicioDeUnaCaja
PARAMETERS lpnrocaja
LOCAL lcCmd,lok

TEXT TO lcCmd TEXTMERGE NOSHOW 
SELECT csrdetaconta.* FROM detaconta as Csrdetaconta 
WHERE Csrdetaconta.nrocaja1 <= <<lpnrocaja>>
and <<lpnrocaja>> <= CsrDetaconta.nrocaja2
ENDTEXT 

IF !CrearCursorAdapter("CsrCursor",lcCmd)
	Oavisar.usuario('Error al obtener datos del detaconta')
ENDIF 

IF RECCOUNT('CsrCursor')#0
	goapp.idejercicioCaja = CsrCursor.id
	**goapp.ejercicioCaja = CsrCursor.ejercicio
ELSE
	=Oavisar.usuario("No se pudo leer el ejercicio de la caja "+ALLTRIM(STR(lpnrocaja)))
ENDIF

IF USED("CsrCursor")
	USE IN CsrCursor
ENDIF
RETURN .t.
*======================================================================
FUNCTION _XFVFPVERSION
LOCAL lnversion
lnversion = INT(VERSION(5)/100)
RETURN lnversion

FUNCTION _xfPrinterProperties
PARAMETERS lcPrinter,lctag,ldisplay
LOCAL lctagPrinter

lctagPrinter = ""
RETURN lcTagPrinter

FUNCTION CrearCursorDbf
PARAMETERS lcCursor

IF used('&lcCursor')
   USE  IN (lcCursor)
ENDIF

SET SAFETY  OFF 

DO CASE 
	CASE UPPER(lcCursor)="CSRPAGO"
	Create Cursor Csrpago (id i AUTOINC,numero n(3),cnombre c(25),fecha d,importe n(10,2),idcuenta i;
	              ,ctactebco c(6),titular c(30),banco c(30),localidad c(30),nrocheque n(12),idtipobco i;
	              ,fechavto d,entregado c(30),idvalor i,idprovincia i,tipocaja c(2),esclase c(1);
	              ,recibido c(30),nrotarjeta c(15),cupon c(15),cuota n(2),cuit c(13),idctabco i;
	              ,idmaopera n(12),idcheque M,detalle c(50),idctatitular i,idctaentregado i,idctarecibido i;
	              ,idlocalidad i,idbanco i,nroidentificador c(50),lccuit c(13))
	Sele Csrpago
ENDCASE 

SET  SAFETY  ON 

RETURN 

FUNCTION ControlFechaCaja
PARAMETERS ldfecha,ldfecdesde,ldFechasta
IF ldfecha < ldfecdesde OR ldfecha > ldfechasta
	RETURN .f.
ENDIF 

RETURN .t.

FUNCTION NumeroLetra(tnNumero,loObjCampos,lenCampo)
   LOCAL lnEntero, lnFraccion,lcenletras
   *-- Elegir si se REDONDEA o TRUNCA
   tnNumero = ROUND(tnNumero, 2)  && Redondeo a 2 decimales
*   tnNumero = INT(tnNumero*100)/100 && Trunco a dos decimales
   lnEntero = INT(tnNumero)
   lnFraccion = INT((tnNumero - lnEntero) * 100)
   lcenletras =  NaLetra(lnEntero, 0) + 'CON ' +  NaLetra(lnFraccion, 1) + 'CEN-TA-VOS.'
   
   =DIVIDELETRA(lcenletras,@loObjCampos,lenCampo)

ENDFUNC

FUNCTION NaLetra(tnNro, tnFlag)
   IF EMPTY(tnFlag)
      tnFlag = 0
   ENDIF
   LOCAL lnEntero, lcRetorno, lnTerna, lcMiles, ;
      lcCadena, lnUnidades, lnDecenas, lnCentenas
   lnEntero = INT(tnNro)
   lcRetorno = ''
   lnTerna = 1
   DO WHILE lnEntero > 0
      lcCadena = ''
      lnUnidades = MOD(lnEntero, 10)
      lnEntero = INT(lnEntero / 10)
      lnDecenas = MOD(lnEntero, 10)
      lnEntero = INT(lnEntero / 10)
      lnCentenas = MOD(lnEntero, 10)
      lnEntero = INT(lnEntero / 10)

      *--- Analizo la terna
      DO CASE
         CASE lnTerna = 1
            lcMiles = ''
         CASE lnTerna = 2 AND (lnUnidades + lnDecenas + lnCentenas # 0)
            lcMiles = 'MIL '
         CASE lnTerna = 3 AND (lnUnidades + lnDecenas + lnCentenas # 0)
            lcMiles = IIF(lnUnidades = 1 AND lnDecenas = 0 AND ;
               lnCentenas = 0, 'MI-LLON ', 'MI-LLO-NES ')
         CASE lnTerna = 4 AND (lnUnidades + lnDecenas + lnCentenas # 0)
            lcMiles = 'MIL MI-LLO-NES '
         CASE lnTerna = 5 AND (lnUnidades + lnDecenas + lnCentenas # 0)
            lcMiles = IIF(lnUnidades = 1 AND lnDecenas = 0 AND ;
               lnCentenas = 0, 'BI-LLON ', 'BI-LLO-NES ')
         CASE lnTerna > 5
            lcRetorno = ' ERROR: NUMERO DEMASIADO GRANDE '
            EXIT
      ENDCASE

      *--- Analizo las unidades
      DO CASE
         CASE lnUnidades = 1
            lcCadena = IIF(lnTerna = 1 AND tnFlag = 0, 'U-NO ', 'UN ')
         CASE lnUnidades = 2
            lcCadena = 'DOS '
         CASE lnUnidades = 3
            lcCadena = 'TRES '
         CASE lnUnidades = 4
            lcCadena = 'CUA-TRO '
         CASE lnUnidades = 5
            lcCadena = 'CIN-CO '
         CASE lnUnidades = 6
            lcCadena = 'SEIS '
         CASE lnUnidades = 7
            lcCadena = 'SIE-TE '
         CASE lnUnidades = 8
            lcCadena = 'O-CHO '
         CASE lnUnidades = 9
            lcCadena = 'NUE-VE '
      ENDCASE

      *--- Analizo las decenas
      DO CASE
         CASE lnDecenas = 1
            DO CASE
               CASE lnUnidades = 0
                  lcCadena = 'DIEZ '
               CASE lnUnidades = 1
                  lcCadena = 'ON-CE '
               CASE lnUnidades = 2
                  lcCadena = 'DO-CE '
               CASE lnUnidades = 3
                  lcCadena = 'TRE-CE '
               CASE lnUnidades = 4
                  lcCadena = 'CA-TOR-CE '
               CASE lnUnidades = 5
                  lcCadena = 'QUIN-CE '
               OTHER
                  lcCadena = 'DIE-CI-' + lcCadena
            ENDCASE
         CASE lnDecenas = 2
            lcCadena = IIF(lnUnidades = 0, 'VEIN-TE ', 'VEIN-TI-') + lcCadena
         CASE lnDecenas = 3
            lcCadena = 'TREIN-TA ' + IIF(lnUnidades = 0, '', 'Y ') + lcCadena
         CASE lnDecenas = 4
            lcCadena = 'CUA-REN-TA ' + IIF(lnUnidades = 0, '', 'Y ') + lcCadena
         CASE lnDecenas = 5
            lcCadena = 'CIN-CUEN-TA ' + IIF(lnUnidades = 0, '', 'Y ') + lcCadena
         CASE lnDecenas = 6
            lcCadena = 'SE-SEN-TA ' + IIF(lnUnidades = 0, '', 'Y ') + lcCadena
         CASE lnDecenas = 7
            lcCadena = 'SE-TEN-TA ' + IIF(lnUnidades = 0, '', 'Y ') + lcCadena
         CASE lnDecenas = 8
            lcCadena = 'O-CHEN-TA ' + IIF(lnUnidades = 0, '', 'Y ') + lcCadena
         CASE lnDecenas = 9
            lcCadena = 'NO-VEN-TA ' + IIF(lnUnidades = 0, '', 'Y ') + lcCadena
      ENDCASE

      *--- Analizo las centenas
      DO CASE
         CASE lnCentenas = 1
            lcCadena = IIF(lnUnidades = 0 AND lnDecenas = 0, ;
               'CIEN ', 'CIEN-TO- ') + lcCadena
         CASE lnCentenas = 2
            lcCadena = 'DOS-CIEN-TOS ' + lcCadena
         CASE lnCentenas = 3
            lcCadena = 'TRES-CIEN-TOS ' + lcCadena
         CASE lnCentenas = 4
            lcCadena = 'CUA-TRO-CIEN-TOS ' + lcCadena
         CASE lnCentenas = 5
            lcCadena = 'QUI-NIEN-TOS ' + lcCadena
         CASE lnCentenas = 6
            lcCadena = 'SEIS-CIEN-TOS ' + lcCadena
         CASE lnCentenas = 7
            lcCadena = 'SE-TE-CIEN-TOS ' + lcCadena
         CASE lnCentenas = 8
            lcCadena = 'O-CHO-CIEN-TOS ' + lcCadena
         CASE lnCentenas = 9
            lcCadena = 'NO-VE-CIEN-TOS ' + lcCadena
      ENDCASE

      *--- Armo el retorno terna a terna
      lcRetorno = lcCadena + lcMiles + lcRetorno
      lnTerna = lnTerna + 1
   ENDDO
   IF lnTerna = 1
      lcRetorno = 'CERO '
   ENDIF
   RETURN lcRetorno
ENDFUNC

*-----------------------------------------
* FUNCTION FechaHoraCero(ldfecha)
*-----------------------------------------
* Pone en cero la hora
*-----------------------------------------
FUNCTION FechaHoraCero
PARAMETERS ldfechahora

ldfechahoracero = DATETIME(YEAR(ldfechahora),MONTH(ldfechahora),DAY(ldfechahora),0,0,0)

RETURN ldfechahoracero


*----------------------------------------
* FUNCTION BeepFP(tnSound)
*----------------------------------------
* Ejecuta el sonido predeterminado del sistema
* USO: ? Beep(0)
*----------------------------------------
FUNCTION BeepFP(tnSound)
tnSound = IIF(VARTYPE(tnSound) = "N", tnSound, 1)
DECLARE INTEGER MessageBeep IN WIN32API ;
INTEGER nSound
RETURN IIF(MessageBeep(tnSound) = 1, .T., .F.)
ENDFUNC 

FUNCTION  DIVIDELETRA
parameters nroletras,loObjCampos,lenCampo
LOCAL  i,k,p,j,cadena1,subca,salir,cadena

store 1 to i,p
j = 0
if len(strtran(nroletras,'-',''))<=lenCampo
   loObjcampos.campo1=strtran(nroletras,'-','')
   return
endif
k=len(alltrim(nroletras))
cadena1=alltrim(nroletras)
subca=''
salir = .t.
do while salir
   cadena=subs(cadena1,i,k-i+1)
   if at(' ',cadena) >1
      subca=subca+SUBS(cadena,1,AT(' ',cadena)-1)+' '
      else
         if at('-',cadena) <1
             subca=subca+cadena
             salir = .f.
         endif
   endif
   subca=strtran(subca,'-','')
   if len(subca)<=ancho
      i= i + AT(' ',subs(cadena1,i,k-i+1))
      else
         i= i - iif(subs(cadena1,i,1)=' ',1,0)
         do while !subs(cadena1,i,1)$'! '
            i = i - 1
         enddo
         subca=strtran(subs(cadena1,p,i-p+1),'-','')
         p = i
         j = j + 1
         lcquecampo = "loObjCampos.campo"+LTRIM(STR(j))
         &lcquecampo = ltrim(subca)
         subca=''
   endif
enddo
j = j + 1
lcquecampo = "loObjCampos.campo"+LTRIM(STR(j))
&lcquecampo = ltrim(subca)
RETURN 

FUNCTION createStruct( toReflection, tcTypeName )
  LOCAL loPropertyValue, loTemp
  loPropertyValue = createobject( "relation" )
  toReflection.forName( tcTypeName).createobject(@loPropertyValue)
  return ( loPropertyValue )
ENDPROC 

FUNCTION ConvertToUrl (strFile)
    strFile = STRTRAN(strFile, "\", "/")
    strFile = STRTRAN(strFile, ":", "|")
    strFile = STRTRAN(strFile, "", "20%")
    strFile = "file:///" + strFile 
    RETURN strFile
ENDPROC 
       