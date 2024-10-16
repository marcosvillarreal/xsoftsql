FUNCTION CDateEngSpa
PARAMETERS lcFecha
LOCAL lcDia,lcMes,lcAnio,ldFecha
STORE "" TO lcDia,lcMes,lcAnio

lcDia = LEFT(lcFecha,2)
lcMes = UPPER(SUBSTR(lcFecha,4,3))
lcAnio = RIGHT(lcFecha,2)

*Transformamos el mes ENE en 01
DO CASE 
CASE 'JAN'$lcMes
	lcMes="01"
CASE 'FEB'$lcMes
	lcMes="02"
CASE 'MAR'$lcMes
	lcMes="03"
CASE 'APR'$lcMes
	lcMes="04"
CASE 'MAY'$lcMes
	lcMes="05"
CASE 'JUN'$lcMes
	lcMes="06"
CASE 'JUL'$lcMes
	lcMes="07"
CASE 'AUG'$lcMes
	lcMes="08"
CASE 'SE'$lcMes
	lcMes="09"
CASE 'OCT'$lcMes
	lcMes="10"
CASE 'NOV'$lcMes
	lcMes="11"
CASE 'DEC'$lcMes
	lcMes="12"
ENDCASE 
*Si el a�o es menor es mayor al actual 19
IF VAL(lcAnio) > VAL(RIGHT(STR(YEAR(DATE()),4),2))
	lcAnio='19'+lcAnio
ELSE
	lcAnio = '20'+lcAnio
ENDIF 
ldFecha = CTOD(lcDia+"-"+lcMes+"-"+lcAnio)
RETURN ldfecha

FUNCTION LimpiarCadena
PARAMETERS lcCadena

lcCadena = STRTRAN(lcCadena,'"','')
lcCadena = STRTRAN(lcCadena,"'",'')
lcCadena = STRTRAN(lcCadena,'.','')

RETURN lcCadena

FUNCTION PelarAbrevia
PARAMETERS lcCadena

lcCadena = STRTRAN(lcCadena,'"','')
lcCadena = STRTRAN(lcCadena,"'",'')
lcCadena = STRTRAN(lcCadena,'.','')
lcCadena = STRTRAN(lcCadena,'-','')
lcCadena = STRTRAN(lcCadena,'/','')
lcCadena = STRTRAN(lcCadena,' ','')
lcCadena = STRTRAN(lcCadena,"�","A")
lcCadena = STRTRAN(lcCadena,"�","E")
lcCadena = STRTRAN(lcCadena,"�","I")
lcCadena = STRTRAN(lcCadena,"�","O")
lcCadena = STRTRAN(lcCadena,"�","U")

RETURN lcCadena

FUNCTION ArmarAbreviaX
PARAMETERS lcNombre,lcAlias,lnLeft,lbPrimeraLetra
lnLeft = IIF(PCOUNT()<3,1,lnLEft)
lbPrimeraLetra = IIF(PCOUNT()<4,.t.,lbPrimeraLetra)

*Buscando Abrevia
lcAbrevia	= PelarAbrevia(lcNombre)
lbencontro = .f.
lcCadena	= LEFT(lcNombre,1)
i = lnLeft
DO WHILE !lbencontro AND i <= LEN(lcAbrevia)
	lcCadena = IIF(lbPrimeraLetra,LEFT(lcCadena,1),'')+SUBSTR(lcAbrevia,i,lnLeft-1)
	SELECT (lcAlias)
	LOCATE FOR LEFT(switch,lnLeft)=LEFT(lcCadena,lnLeft)
	IF !LEFT(switch,lnLeft)=LEFT(lcCadena,lnLeft)
		lbEncontro = .t.
	ENDIF 
    
	i = i + 1
ENDDO          
IF !lbEncontro
	i = 0
	DO WHILE !lbencontro AND i+ASC('A') <= ASC('Z')
    	lcCadena = IIF(lbPrimeraLetra,LEFT(lcCadena,1),'')+CHR(ASC('A')+i)
    	SELECT (lcAlias)
    	LOCATE FOR LEFT(switch,lnLeft)$LEFT(lcCadena,lnLeft)
    	IF !LEFT(switch,lnLeft)$LEFT(lcCadena,lnLeft)
    		lbEncontro = .t.
    	ENDIF
    	i = i + 1 
	ENDDO          
ENDIF 
IF !lbEncontro
	lcCadena = '00000'
ENDIF 

RETURN LEFT(lcCadena,lnLeft)
*----------------------------------------------------
*---------------------------------------------------
*---------------------------------------------------
FUNCTION ArmarAbrevia
PARAMETERS lcNombre,lcAlias,lnLeft
lnLeft = IIF(PCOUNT()<3,1,lnLEft)

*Buscando Abrevia
lcAbrevia	= PelarAbrevia(lcNombre)
lbencontro = .f.
lcCadena	= LEFT(lcNombre,1)
*Buscamos posicion por posicion.
lnPos = 1
lcPalabra = ""
DO WHILE lnPos<=lnLeft
	i = lnPos
	*Buscamos en la palabra un digito que no exista
	DO WHILE !lbencontro AND i <= LEN(lcAbrevia)
		lcSiguiente = EsLetraNumero(SUBSTR(lcAbrevia,i,1))
		IF lcSiguiente$'?'
			i = i + 1 
			LOOP 
		ENDIF 
		lcCadena = lcPalabra +lcSiguiente
		SELECT (lcAlias)
		LOCATE FOR LEFT(switch,lnPos)=LEFT(lcCadena,lnPos)
		IF !LEFT(switch,lnPos)=LEFT(lcCadena,lnPos)
			lbEncontro = .t.
		ENDIF 
	    
		i = i + 1
	ENDDO   
	
	     
	*Le agregamos una letra del alfabeto  
	IF !lbEncontro
		i = 0
		DO WHILE !lbencontro AND i+ASC('A') <= ASC('Z')
	    	lcCadena = lcPalabra+CHR(ASC('A')+i)
	    	SELECT (lcAlias)
	    	LOCATE FOR LEFT(switch,lnLeft)$LEFT(lcCadena,lnLeft)
	    	IF !LEFT(switch,lnLeft)$LEFT(lcCadena,lnLeft)
	    		lbEncontro = .t.
	    	ENDIF
	    	i = i + 1 
		ENDDO 
		*Le agregamos un numerico
		IF !lbEncontro         
			i = 0
			DO WHILE !lbencontro AND i+ASC('1') <= ASC('9')
		    	lcCadena = lcPalabra+CHR(ASC('1')+i)
		    	SELECT (lcAlias)
		    	LOCATE FOR LEFT(switch,lnLeft)$LEFT(lcCadena,lnLeft)
		    	IF !LEFT(switch,lnLeft)$LEFT(lcCadena,lnLeft)
		    		lbEncontro = .t.
		    	ENDIF
		    	i = i + 1 
			ENDDO 
		ENDIF 
	ENDIF 
	lcPalabra = lcPalabra+'0'
	IF lbEncontro
		lcPalabra = lcCadena
		lbEncontro = .f.
	ENDIF 
	lnPos = lnPos + 1
ENDDO 

RETURN LEFT(lcPalabra,lnLeft)

FUNCTION EsLetraNumero
PARAMETERS lcChar
	
	IF(ASC('A')<=ASC(lcChar) and ASC(lcChar)<=ASC('Z')) or ;
		(ASC('1')<=ASC(lcChar) and ASC(lcChar)<=ASC('9')) 
		lcChar = lcChar
	ELSE
		lcChar= '?'
	ENDIF 
	
RETURN lcChar


FUNCTION TablaProveedores
LPARAMETERS cNomProv
cNomProv = ALLTRIM(cNomProv)
*stop()
nCodP = 0		
DO CASE
CASE 'BAHIA AUTO'$cNomProv 
	nCodP = 72
CASE cNomProv$'ALFA' OR cNomProv$'ALA-ALBECA-ALDA-ALF-ALFE-ALFSA'
	nCodP= 3
CASE 'AMATR'$cNomProv OR 'AMATIA'$cNomProv
	nCodP = 205
CASE 'ARCORE'$cNomProv 
	nCodP = 297
CASE 'AUTOP'$cNomProv OR 'AUTOS DE'$cNomProv OR 'AUTP'$cNomProv OR 'AUTOS SE'$cNomProv OR 'AUTORA'$cNomProv
	nCodP = 252
CASE 'AUTON'$cNomProv OR 'AUTO'$cNomProv OR 'NAU'$cNomProv
	nCodP = 1
CASE 'ANS'$LEFT(cNomProv,3) OR 'ANG'$LEFT(cNomProv,3) OR 'AUT0'$LEFT(cNomProv,4)
	nCodP = 1
CASE 'BABAGUI'$LEFT(cNomProv,7) OR 'SHELL'$LEFT(cNomProv,5)
	nCodP = 256	
CASE 'BAHIA F'$cNomProv OR 'B.F'$cNomProv OR 'B/FIL'$cNomProv OR 'B FIL'$cNomProv
	nCodP = 178
CASE 'BAIA F'$cNomProv
	nCodP = 178
CASE 'BAL'$LEFT(cNomProv,3) OR 'BASAMO'=cNomProv
	nCodP = 96
CASE 'BARD'$LEFT(cNomProv,4) OR 'BARH'$LEFT(cNomProv,4)
	nCodP = 5
CASE 'BULON'$LEFT(cNomProv,5) OR 'BOLUN'$LEFT(cNomProv,5)
	nCodP = 251
CASE 'ANTONIO'$LEFT(cNomProv,7) OR 'ANTON'$cNomProv OR 'CARBU'$LEFT(cNomProv,5)
	nCodP = 241
CASE 'CV'$cNomProv OR 'C V'$cNomProv OR 'C.D.'$cNomProv OR 'C.V.'$cNomProv
	nCodP = 60
CASE 'CARLO'$cNomProv AND 'VAZQ'$cNomProv 
	nCodP = 60
CASE 'CASA'$cNomProv AND 'ERR'$cNomProv 
	nCodP = 369
CASE 'CEDIC'$cNomProv OR ('CEN'$cNomProv AND 'DIS'$cNomProv)
	nCodP = 306
CASE ('DISTRI'$cNomProv AND 'CORD'$cNomProv)
	nCodP = 306
CASE 'MOSOL'$cNomProv OR 'CROMO'$LEFT(cNomProv,5)
	nCodP = 220
CASE 'AMERICA'$LEFT(cNomProv,7) OR 'BRAE'$LEFT(cNomProv,4)
	nCodP = 330
CASE 'DAIMA'$LEFT(cNomProv,5) OR 'DAEM'$LEFT(cNomProv,4)
	nCodP = 330
CASE 'DISTRAL'=cNomProv OR 'DPF'$LEFT(cNomProv,3)
	nCodP = 330
CASE 'DARSU'=cNomProv OR 'DAR'$LEFT(cNomProv,3) OR 'DASU'$LEFT(cNomProv,4)
	nCodP = 180
CASE 'VALLE'=cNomProv OR 'DELLA'$cNomProv OR 'DEDIO'$LEFT(cNomProv,5)
	nCodP = 155
CASE 'DER'$LEFT(cNomProv,3)
	nCodP = 384
CASE 'DIESEL'$LEFT(cNomProv,6) OR 'D/MOTO'$LEFT(cNomProv,6)
	nCodP = 380
CASE 'DIMET'=cNomProv
	nCodP = 213
CASE 'DISMAR'$cNomProv
	nCodP = 164
CASE 'EL HOL'$cNomProv
	nCodP = 368
CASE 'ELECTR'$LEFT(cNomProv,6) OR 'ELECTO'$LEFT(cNomProv,6)
	nCodP = 239
CASE 'EMB'$LEFT(cNomProv,3) AND 'SUR'$cNomProv
	nCodP = 260
CASE 'ZURMAN'=cNomProv
	nCodP = 0 &&INPA
CASE 'MAN'$cNomProv OR 'ET'$LEFT(cNomProv,2) OR '20LA PAMPA'$cNomProv
	nCodP=18
CASE 'EXP'$LEFT(cNomProv,3) OR cNomProv$'EXPOY'
	nCodP=120
CASE 'FAMAS'$cNomProv OR 'AMASA'=cNomProv OR 'ALTAMIRA'=cNomProv
	nCodP=25
CASE 'FAMAZA'$cNomProv OR 'FAMSA'=cNomProv OR 'FANASA'=cNomProv
	nCodP=25
CASE 'GARMENDIA'$cNomProv 
	nCodP=193
CASE 'GABRIEL'$cNomProv 
	nCodP=24
CASE ('G'$cNomProv AND '3'$cNomProv) OR ('GRUP'$cNomProv AND '3'$cNomProv)
	nCodP=358
CASE 'GUSPAMAR'$cNomProv
	nCodP=59
CASE 'HORNES'$cNomProv OR 'HYH'=cNomProv
	nCodP=342
CASE 'IMPERIA'$cNomProv
	nCodP=103
CASE 'INCAH'$cNomProv OR 'INCAUE'$cNomProv
	nCodP=107
CASE 'HORNES'$cNomProv OR 'HYH'=cNomProv
	nCodP=342
CASE 'ITUR'$LEFT(cNomProv,4) OR 'ITUURIA'=cNomProv
	nCodP=50
CASE 'IVECAM'$cNomProv
	nCodP=405
CASE 'JUMA'$cNomProv OR 'JUNKO'=cNomProv
	nCodP=359
CASE 'PAMPA'$cNomProv OR 'LA PAM'$LEFT(cNomProv,6) OR 'LA PM'$LEFT(cNomProv,5)
	nCodP=30
CASE 'LABAR'$cNomProv OR 'LA BARE'$LEFT(cNomProv,7) OR 'LABERE'$cNomProv OR 'LOBARE'$cNomProv
	nCodP=109
CASE 'MB'$STRTRAN(STRTRAN(STRTRAN(cNomProv,'.',''),'-',''),'/','')
	nCodP=123
CASE 'MEGA'$LEFT(cNomProv,4)
	nCodP=399
CASE 'MORRONE'$cNomProv
	nCodP=339
CASE 'NEUQ'$cNomProv OR 'NEWQU'$cNomProv OR 'YERR'$cNomProv
	nCodP=108
CASE 'PANA'$LEFT(cNomProv,4)
	nCodP=262
CASE 'IERTT'$cNomProv OR 'PAPI'$LEFT(cNomProv,4) OR 'PAPER'$LEFT(cNomProv,5)
	nCodP=52
CASE 'ERTTEI'$cNomProv OR 'PAPPI'$LEFT(cNomProv,5) OR 'IERTEI'$LEFT(cNomProv,6)
	nCodP=52
CASE 'PAROL'$cNomProv OR 'APROLO'$LEFT(cNomProv,6) OR 'PAOLO'$cNomProv
	nCodP=17
CASE 'PARO'$LEFT(cNomProv,4) OR 'POROLO'$cNomProv OR 'SUD'$LEFT(cNomProv,3)
	nCodP=17
CASE 'IERTT'$cNomProv OR 'PAPI'$LEFT(cNomProv,4) OR 'PAPER'$LEFT(cNomProv,5)
	nCodP=52
CASE 'CORRADI'$cNomProv
	nCodP=303
CASE 'POZZO'$cNomProv
	nCodP=341
CASE 'PROF'$cNomProv OR 'PRO F'$LEFT(cNomProv,5)
	nCodP=235
CASE 'PRO SE'$STRTRAN(STRTRAN(STRTRAN(cNomProv,'.',' '),'-',' '),'/',' ')
	nCodP=40
CASE 'PROMESA'$cNomProv
	nCodP=314
CASE 'PROSER'$cNomProv OR 'PROV SER'$cNomProv OR 'PROVS'$cNomProv OR 'PROV SSE'$cNomProv
	nCodP=40
CASE 'PROV SE'$STRTRAN(STRTRAN(STRTRAN(cNomProv,'.',' '),'-',' '),'/',' ')
	nCodP=40
CASE 'PROTEC'$cNomProv
	nCodP=375
CASE 'PAPA'$LEFT(cNomProv,4) OR 'RAPA'$LEFT(cNomProv,4)
	nCodP=113
CASE 'GAGRI'$LEFT(cNomProv,5) OR 'HG'$STRTRAN(STRTRAN(STRTRAN(cNomProv,'.',' '),'-',' '),'/',' ')
	nCodP=24
CASE 'RINDE'$LEFT(cNomProv,5) OR 'REI'$LEFT(cNomProv,3)
	nCodP=305
CASE 'ROD'$LEFT(cNomProv,5) AND ('PART'$cNomProv OR 'MEC'$cNomProv)
	nCodP=316 	
CASE 'RODAM'$LEFT(cNomProv,5) OR 'RODAQ'$LEFT(cNomProv,5)
	nCodP=6 
CASE 'ROBERTO NANT'$cNomProv
	nCodP=327
CASE 'PARTICU'$LEFT(cNomProv,5)
	nCodP=316 
CASE ('RODA'$LEFT(cNomProv,4) AND ('PART'$cNomProv)) OR 'RODA'=cNomProv
	nCodP=316 	
CASE 'ROSSI'$cNomProv
	nCodP=201
CASE 'SEDEC'$LEFT(cNomProv,5) OR 'SID'$LEFT(cNomProv,3) OR 'SDIE'$LEFT(cNomProv,4)
	nCodP=43
CASE 'SIE'$LEFT(cNomProv,3) OR 'SISEC'$LEFT(cNomProv,5) OR 'SODE'$LEFT(cNomProv,4)
	nCodP=43
CASE 'SURPIE'$LEFT(cNomProv,6) OR 'SURPI'$LEFT(cNomProv,5) 
	nCodP=261
CASE 'TARANT'$cNomProv OR 'TARAT'$LEFT(cNomProv,5) OR 'TARQAN'$LEFT(cNomProv,6)
	nCodP=47
CASE 'SUS'$cNomProv OR 'SUP'$LEFT(cNomProv,3)
	nCodP=238
CASE 'TOYOTA'$cNomProv OR 'AISIN'$cNomProv
	nCodP=394
CASE 'TRAMA'$LEFT(cNomProv,5) OR 'CARRE'$LEFT(cNomProv,5)
	nCodP=216
CASE 'TRANS'$LEFT(cNomProv,5) OR 'TRANC'$LEFT(cNomProv,5) OR 'TRAS'$LEFT(cNomProv,4)
	nCodP=119
CASE 'VENTO'$cNomProv OR 'VEN'$LEFT(cNomProv,3) OR 'VEBT'$LEFT(cNomProv,4) OR 'VETO'$LEFT(cNomProv,4)
	nCodP=58
CASE 'WESTAF'$cNomProv
	nCodP=187
CASE 'WHURT'$cNomProv OR 'WUR'$LEFT(cNomProv,3)
	nCodP=99
CASE 'ZANONI'$cNomProv
	nCodP=291
CASE 'CRIS'$LEFT(cNomProv,4) OR 'CRIB'$LEFT(cNomProv,4)
	nCodP=417
CASE 'CO TEC'$LEFT(cNomProv,6) OR 'COTEC'$LEFT(cNomProv,5)
	nCodP=110
CASE 'BERMUD'$cNomProv OR 'JOSE L'$LEFT(cNomProv,6)
	nCodP=416
CASE 'EG'$LEFT(cNomProv,2) OR 'EGSA'$cNomProv OR 'ESGA'$cNomProv
	nCodP=26
CASE 'IMPA'$cNomProv OR 'ZURMAN'$cNomProv
	nCodP=56
CASE 'JEN'$LEFT(cNomProv,3) OR 'JEM'$LEFT(cNomProv,3) OR 'JFREN'$LEFT(cNomProv,3)
	nCodP=300
CASE 'MUZZ'$cNomProv OR 'FEMFR'$LEFT(cNomProv,5) OR 'FENFR'$LEFT(cNomProv,5)
	nCodP=300
CASE 'MAZZU'$cNomProv OR 'MUS'$LEFT(cNomProv,3) OR 'FENFR'$LEFT(cNomProv,5)
	nCodP=300
CASE 'EGUET'$cNomProv OR 'TERE'$LEFT(cNomProv,4) OR 'TREZ'$LEFT(cNomProv,4)
	nCodP=300
CASE 'TRINT'$cNomProv 
	nCodP=300
CASE 'GARRET'$cNomProv 
	nCodP=269
OTHERWISE
ENDCASE
RETURN nCodP

ENDFUNC 


FUNCTION Ciudades
PARAMETERS lcLocalidad
LOCAL lcnombre
lcNombre = lclocalidad
lcLocalidad = STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")

DO CASE
CASE lcLocalidad = "CIUDAD ATLANTIDA"
	lcnombre = "BARRIO CIUDAD ATLANTIDA"
CASE "CERRI" $ lcLocalidad
	lcnombre = "GENERAL DANIEL CERRI"
CASE "PEH"$lcLocalidad
	lcnombre = "PEHUEN CO"
CASE "ARIAS"$lcLocalidad
	lcnombre = "VILLA GRAL. ARIAS"
CASE lcLocalidad  = "CNEL. DORREGO"
	lcnombre = "CORONEL DORREGO"
CASE lcLocalidad = "CIUDAD ATLANTIDA"
	lcnombre = "BARRIO CIUDAD ATLANTIDA"
CASE lcLocalidad $ "PALTA-PUNTAALTA-PATA"
	lcnombre = "PUNTA ALTA"
CASE 'PUNTAALTA' $ lcLocalidad
	lcnombre = 'PUNTA ALTA'
CASE lcLocalidad$"BAHIABLANCA-BAHjABLANCA-BBLANCA-BAHABLANCA-BAHIABANCA"
	lcnombre = "BAHIA BLANCA"
CASE 'BAHIABLANCA' $ lcLocalidad
	lcnombre = 'BAHIA BLANCA'
CASE lcLocalidad$"BUENOSAIRES-CABA-CADEBSAIRES-CAPFEDERAL-CAPITAL-CIUDADBUE-CAPITALFEDERAL-CDAUTONOMABSAIRES-BS-BSAS"
	lcnombre = "CIUDAD DE BUENOS AIRES"
CASE lcLocalidad$"FLORES-"
	lcnombre = "CIUDAD DE BUENOS AIRES"
CASE "CAPILLADELSE"$lcLocalidad
	lcnombre = "CAPILLA DEL SE�OR"
CASE lcLocalidad$ "CASEROS"
	lcnombre = "CASEROS (PDO. 3 DE FEBRERO)"
CASE lcLocalidad$ "CIUDADELANORTE"
	lcnombre = "CIUDADELA"
CASE "DADELANORTE" $ lcLocalidad
	lcnombre = "CIUDADELA"
CASE "SAGUIER" $ lcLocalidad
	lcnombre = "SANTA CLARA DE SAGUIER"
CASE "ECHEVA" $ lcLocalidad
	lcnombre = "BARRIO ESTEBAN ECHEVERRIA"
CASE "GALARZA" $ lcLocalidad
	lcnombre = "GENERAL GALARZA"
CASE "CAMPOS" $ lcLocalidad
	lcnombre = "GENERAL MANUEL CAMPOS"
CASE lcLocalidad $ "JOSELSUAREZ"
	lcnombre = "JOSE LEON SUAREZ"
CASE "LANUS" $ lcLocalidad
	lcnombre = "LANUS"
CASE lcLocalidad $ "LAVALLOL"
	lcnombre = "LLAVALLOL"
CASE "ZAMORA" $ lcLocalidad
	lcnombre = "LOMAS DE ZAMORA"
CASE lcLocalidad $ "MARDELPLATA"
	lcnombre = "MAR DEL PLATA"	
CASE "PAVON" $ lcLocalidad
	lcnombre = "PAVON"
CASE lcLocalidad $ "PILAR"
	lcnombre = "PILAR"
CASE "MEJIA" $ lcLocalidad
	lcnombre = "RAMOS MEJIA"
CASE "REMECO" $ lcLocalidad
	lcnombre = "REMECO (DPTO. GUATRACHE)"
CASE "JOSEDELAESQUINA" $ lcLocalidad
	lcnombre = "SAN JOSE DE LA ESQUINA"
CASE lcLocalidad $ "ROSARIO"
	lcnombre = "ROSARIO"
CASE lcLocalidad $ "ISABEL"
	lcnombre = "BARRIO SANTA ISABEL"	
CASE "INSUPERABLE" $ lcLocalidad
	lcnombre = "VILLA INSUPERABLE"
CASE lcLocalidad $ "VRETIRO"
	lcnombre = "BUEN RETIRO"	
CASE "GOBGALVEZ" $ lcLocalidad
	lcnombre = "VILLA GOBERNADOR GALVEZ"
CASE lcLocalidad $ "VTELOPEZ"
	lcnombre = "VICENTE LOPEZ"
CASE "CHAVES" $ lcLocalidad
	lcnombre = "ADOLFO GONZALES CHAVES"
CASE '(RN)ALROCA' $ lcLocalidad
	lcnombre = "GENERAL ROCA"
CASE 'CABILDO' $ lcLocalidad
	lcnombre = 	'CABILDO'                       
CASE lcLocalidad $ 'CALETAOLIVIA'
	lcnombre = 'CALETA OLIVIA'
CASE 'AGONZALEZCHAVE' $ lcLocalidad
	lcnombre = 'ADOLFO GONZALES CHAVES'
CASE 'ALLEN' $ lcLocalidad
	lcnombre = 'ALLEN'
CASE 'ALPACHIRI' $ lcLocalidad
	lcnombre = 'ALPACHIRI'	
CASE 'BOLIVAR' $ lcLocalidad
	lcnombre = 'BOLIVAR' 
CASE 'PATAGONES' $ lcLocalidad
	lcnombre = 'CARMEN DE PATAGONES'
CASE 'CRIVADAVIA' $ lcLocalidad
	lcnombre = 'COMODORO RIVADAVIA'
CASE 'SUAREZ' $ lcLocalidad
	lcnombre = 'CORONEL SUAREZ' 
CASE 'CATRILO' $ lcLocalidad
	lcnombre = 'CATRILO'
CASE 'CALAFATE' $ lcLocalidad
	lcnombre = 'CALAFATE'
CASE 'CHICHINALES' $ lcLocalidad
	lcnombre = 'CHICHINALES'
CASE 'CHINCHINALES' $ lcLocalidad
	lcnombre = 'CHICHINALES'
CASE 'CHIMPAY' $ lcLocalidad
	lcnombre = 'CHIMPAY' 
CASE 'CHOELE' $ lcLocalidad
	lcnombre = 'CHOELE CHOEL'
CASE 'CHOLILA' $ lcLocalidad
	lcnombre = 'CHOLILA' 
CASE 'CINCO SALTOS' $ lcLocalidad
	lcnombre = 'CINCO SALTOS'
CASE 'CIPOLLETTI' $ lcLocalidad
	lcnombre = 'CIPOLLETTI'
CASE 'ECHARREN' $ lcLocalidad
	lcnombre = 'COLONIA JULIA Y ECHARREN'
CASE 'DORRE' $ lcLocalidad
	lcnombre = 'CORONEL DORREGO' 
CASE 'PRINGLES' $ lcLocalidad
	lcnombre = 'CORONEL PRINGLES' 
CASE 'BELISLE' $ lcLocalidad
	lcnombre = 'CORONEL BELISLE'
CASE '17DEAGOSTO' $ lcLocalidad
	lcnombre = 'DIECISIETE DE AGOSTO'
CASE 'ELBOLSON' $ lcLocalidad
	lcnombre = 'EL BOLSON'
CASE 'ELCUY' $ lcLocalidad
	lcnombre = 'EL CUY'
CASE 'ESPASTILLAR' $ lcLocalidad
	lcnombre = 'ESPASTILLAR (PDO. SAAVEDRA)'
CASE 'ESQUEL' $ lcLocalidad
	lcnombre = 'ESQUEL'
CASE 'ACHA' $ lcLocalidad
	lcnombre = 'GENERAAL ACHA'
CASE 'CONESA' $ lcLocalidad
	lcnombre = 'GENERAL CONESA'
CASE 'CERRI' $ lcLocalidad
	lcnombre = 'GENERAL DANIEL CERRI'
CASE 'GODOY' $ lcLocalidad
	lcnombre = 'GENERAL ENRIQUE GODOY'
CASE 'LAMADRID' $ lcLocalidad
	lcnombre = 'GENERAL LA MADRID'
CASE 'GRALROCA' $ lcLocalidad
	lcnombre = 'GENERAL ROCA'
CASE 'GRALSANMARTIN' $ lcLocalidad
	lcnombre = 'GENERAL SAN MARTIN'
CASE 'GDORCOSTA' $ lcLocalidad
	lcnombre = 'GOBERNADOR COSTA'
CASE 'GUAMINI' $ lcLocalidad
	lcnombre = 'GUAMINI'
CASE 'GUATRACHE' $ lcLocalidad
	lcnombre = 'GUATRACHE'
CASE 'ASCASUBI' $ lcLocalidad
	lcnombre = 'HILARIO ASCASUBI'
CASE 'ELHOYO' $ lcLocalidad
	lcnombre = 'HOYO DE EPUYEN'
CASE 'HUANGUELEN' $ lcLocalidad
	lcnombre = 'HUANGUELEN'
CASE 'HUERGO' $ lcLocalidad
	lcnombre = 'INGENIERO HUERGO'
CASE 'WHITE' $ lcLocalidad
	lcnombre = 'INGENIERO WHITE'
CASE 'GUISASOLA' $ lcLocalidad
	lcnombre = 'JOSE A. GUISASOLA'
CASE 'JDESMARTIN' $ lcLocalidad
	lcnombre = 'JOSE DE SAN MARTIN'
CASE 'JNFERNANDEZ' $ lcLocalidad
	lcnombre = 'JUAN N. FERNANDEZ'
CASE 'LAADELA' $ lcLocalidad
	lcnombre = 'LA ADELA'
CASE 'LAMARQUE' $ lcLocalidad
	lcnombre = 'LAMARQUE'
CASE 'LASGRUTAS' $ lcLocalidad
	lcnombre = 'LAS GRUTAS'
CASE 'LASHERAS' $ lcLocalidad
	lcnombre = 'LAS HERAS'
CASE 'LELEQUE' $ lcLocalidad
	lcnombre = 'LELEQUE'
CASE 'LIBANO' $ lcLocalidad
	lcnombre = 'LIBANO'
CASE 'LOSMENUCOS' $ lcLocalidad
	lcnombre = 'LOS MENUCOS'
CASE 'LUISBELTRAN' $ lcLocalidad
	lcnombre = 'LUIS BELTRAN'
CASE 'MACACHIN' $ lcLocalidad
	lcnombre = 'MACACHIN'
CASE 'MAQUINCAHO' $ lcLocalidad
	lcnombre = 'MAQUINCHAO'
CASE 'BURATOVICH' $ lcLocalidad
	lcnombre = 'MAYOR BURATOVICH'
CASE 'CASCALLARES' $ lcLocalidad
	lcnombre = 'MICAELA CASCALLARES'
CASE 'RIGLOS' $ lcLocalidad
	lcnombre = 'MIGUEL RIGLOS'
CASE 'STEFANELLI' $ lcLocalidad
	lcnombre = 'PADRE ALEJANDRO STEFENELLI'
CASE 'PLOTTIER' $ lcLocalidad
	lcnombre = 'PLOTTIER'
CASE 'PUAN' $ lcLocalidad
	lcnombre = 'PUAN'
CASE 'MADRYN' $ lcLocalidad
	lcnombre = 'PUERTO MADRYN'
CASE 'SJULIA' $ lcLocalidad
	lcnombre = 'PUERTO SAN JULIA'
CASE 'PTOSTACRUZ' $ lcLocalidad
	lcnombre = 'PUERTO SANTA CRUZ'
CASE 'QUEMU QUEMU' $ lcLocalidad
	lcnombre = 'QUEMU QUEMU'
CASE 'QUINIHUAL' $ lcLocalidad
	lcnombre = 'QUI�IHUAL'
CASE 'COLORADO' $ lcLocalidad
	lcnombre = 'RIO COLORADO'
CASE 'GALLEGOS' $ lcLocalidad
	lcnombre = 'RIO GALLEGOS'
CASE 'RIOMAYO' $ lcLocalidad
	lcnombre = 'RIO MAYO'
CASE 'RIOTURBIO' $ lcLocalidad
	lcnombre = 'RIO TURBIO'
CASE 'SALLIQUELO' $ lcLocalidad
	lcnombre = 'SALLIQUELO'
CASE 'SANAOESTE' $ STRTRAN(lcLocalidad,",","")
	lcnombre = 'SAN ANTONIO OESTE'
CASE 'BARILOCHE' $ lcLocalidad
	lcnombre = 'SAN CARLOS DE BARILOCHE'
CASE 'SANCAYETANO' $ lcLocalidad
	lcnombre = 'SAN CAYETANO'
CASE 'BELLOCQ' $ lcLocalidad
	lcnombre = 'SAN FRANCISCO DE BELLOCQ'
CASE 'SANTAROSA' $ lcLocalidad
	lcnombre = 'SANTA ROSA'
CASE 'SARMIENTO' $ lcLocalidad
	lcnombre = 'SARMIENTO'
CASE 'SANPDELCHA' $ lcLocalidad
	lcnombre = 'SAN PATRICIO DEL CHA�AR'
CASE 'TANDIL' $ lcLocalidad
	lcnombre = 'TANDIL'
CASE 'TAPIALES' $ lcLocalidad
	lcnombre = 'TAPIALES'
CASE 'TECKA' $ lcLocalidad
	lcnombre = 'TECKA'
CASE 'TOAY' $ lcLocalidad
	lcnombre = 'TOAY'
CASE 'ARROYOS' $ lcLocalidad
	lcnombre = 'TRES ARROYOS'
CASE 'TREVELIN' $ lcLocalidad
	lcnombre = 'TREVELIN'
CASE 'VIEDMA' $ lcLocalidad
	lcnombre = 'VIEDMA'
CASE 'ANGOSTURA' $ lcLocalidad
	lcnombre = 'VILLA LA ANGOSTURA'
CASE 'VILLALONGA' $ lcLocalidad
	lcnombre = 'VILLA LONGA'
CASE 'VILLAMANZANO' $ lcLocalidad
	lcnombre = 'VILLA MANZANO'
CASE 'VILLAREGINA' $ lcLocalidad
	lcnombre = 'VILLA REGINA'
CASE 'SANVICENTE' $ lcLocalidad
	lcnombre = 'BARRIO SAN VICENTE'
CASE 'CORDOBA' $ lcLocalidad
	lcnombre = 'CORDOBA ESTAFETA N23'
CASE 'COSQ' $ lcLocalidad
	lcnombre = 'COSQUIN'
CASE 'FERREYRA' $ lcLocalidad
	lcnombre = 'FERREYRA (DPTO. CAPITAL)'
CASE 'HAEDONO' $ lcLocalidad
	lcnombre = 'HAEDO'
CASE 'ISIDROCASA' $ lcLocalidad
	lcnombre = 'ISIDRO CASANOVA'
CASE 'LDELMIRADOR' $ lcLocalidad
	lcnombre = 'LOMAS DEL MIRADOR'
CASE 'LAREJA' $ lcLocalidad
	lcnombre = 'LA REJA'
CASE 'LA TABLADA' $ lcLocalidad
	lcnombre = 'TABLADA'
CASE 'LANUS' $ lcLocalidad
	lcnombre = 'LANUS'
CASE 'LOMAHERMOSA' $ lcLocalidad
	lcnombre = 'VILLA LOMA HERMOSA'
CASE 'LOMAVERDE' $ lcLocalidad
	lcnombre = 'BARRIO LOMA VERDE'
CASE 'PIGUE' $ lcLocalidad
	lcnombre = 'PIGUE'
CASE 'EYRO' $ lcLocalidad
	lcnombre = 'PI�EYRO (PDO. AVELLANEDA)'
CASE 'RDEESCALADA' $ lcLocalidad
	lcnombre = 'REMEDIOS DE ESCALADA'
CASE 'TOAY' $ lcLocalidad
	lcnombre = 'TOAY'
CASE 'VBALLESTER' $ lcLocalidad
	lcnombre = 'VILLA BALLESTER'
CASE 'VMAIPU' $ lcLocalidad
	lcnombre = 'VILLA MAIPU'				
					
CASE '' $ lcLocalidad
	lcnombre = ''

ENDCASE

RETURN lcNombre


FUNCTION TablaMarcas
LPARAMETERS cMarca
LOCAL cNomMarca

cNomProveedor = ''		
DO CASE
CASE cMarca$"3 M"
	cNomMarca ='3M'
CASE cMarca$"ACINDAR"
	cNomMarca ='ACINDRA'
CASE cMarca$"AGRO INSUMO"
	cNomMarca ='AGRO INSUMOS'
CASE LEFT(cMarca,3)$"BER"
	cNomMarca ='BERMON'
CASE cMarca$"BIL-BEX"
	cNomMarca ='BIL-VEX'
CASE cMarca$"BIONENESIS"
	cNomMarca ="BIOGENESIS BAGO"
CASE cMarca$"BLACK & DEKER"
	cNomMarca ="BLACK & BECKER"
CASE cMarca$"BOLSA BAHIA"
	cNomMarca ="BOLSAS BAHIA"
CASE LEFT(cMarca,6)$"BRIGGS"
	cNomMarca ="BRIGGS & STRATTON"
CASE cMarca$"CARBUDUNDUM"
	cNomMarca ="CARBORUNDUM"
CASE cMarca$"CARRETELES"
	cNomMarca ="CARRETELES RAFA"
CASE LEFT(cMarca,5)$"CORTI"
	cNomMarca ="CORTRIFIL"
CASE LEFT(cMarca,5)$"DAVID"
	cNomMarca ="DAVISON"
CASE LEFT(cMarca,5)$"DELTA"
	cNomMarca ="DELTA PANS"
CASE LEFT(cMarca,5)$"DISAH"
	cNomMarca ="DISAH BAHIA S.A."
CASE LEFT(cMarca,3)$"DOW"
	cNomMarca ="DOW AGROSCIENCE"
CASE cMarca$"FERRIEMD"
	cNomMarca ="FERRIMED"
CASE LEFT(cMarca,6)$"FOREST"
	cNomMarca ="FOREST & GARDEN"
CASE cMarca$"FRAMMER"
	cNomMarca ="FRAMER"
CASE cMarca$"GAMA"
	cNomMarca ="GAMMA"
CASE cMarca$"HEFA"
	cNomMarca ="HE-FA"
CASE LEFT(cMarca,4)$"INGE"
	cNomMarca ="INGERSOLL"
CASE LEFT(cMarca,4)$"INMU"
	cNomMarca ="INMUNO VET"
CASE LEFT(cMarca,9)$"INVERSBIO"
	cNomMarca ="INVERSBIO S.R.L."
CASE LEFT(cMarca,2)$"KO"
	cNomMarca ="KONIG"
CASE LEFT(cMarca,6)$"MET RI"
	cNomMarca ="MET. RIVERA"
CASE LEFT(cMarca,4)$"MILW"
	cNomMarca ="MILWAUKEE"
CASE cMarca$"MOLDPAST"
	cNomMarca ="MOLDPAS"
CASE cMarca$"NOVARTIS"
	cNomMarca ="NOVARTI"
CASE cMarca$"OLEO MAC"
	cNomMarca ="OLEO-MAC"
CASE cMarca$"POXIPOL"
	cNomMarca ="POXI-POL"
CASE LEFT(cMarca,5)$"PROQU"
	cNomMarca ="POQUIM"
CASE LEFT(cMarca,5)$"PROVI"
	cNomMarca ="PROVIDEAN"
CASE LEFT(cMarca,5)$"ROTTW" OR LEFT(cMarca,4)$"ROTW"
	cNomMarca ="ROTTWEILER"
CASE LEFT(cMarca,5)$"SANID" OR LEFT(cMarca,5)$"SANIN"
	cNomMarca ="SANIDAD GANADERA"
CASE cMarca$"SENOGA"
	cNomMarca ="SENOGAS"
CASE cMarca$"SIMPLI CROCK"
	cNomMarca ="SIMPLI-CROCK"
CASE cMarca$"SIN PAR"
	cNomMarca ="SIN-PAR"
CASE LEFT(cMarca,6)$"SIXCOM"
	cNomMarca ="SIXCOM S.A."
CASE LEFT(cMarca,3)$"SKI"
	cNomMarca ="SKILL"
CASE LEFT(cMarca,11)$"SOLA Y CIA."
	cNomMarca ="SOLA HECTOR"
CASE LEFT(cMarca,5)$"STIHL"
	cNomMarca ="STHIL"
CASE LEFT(cMarca,6)$"TECNOF"
	cNomMarca ="TECNOFARM S.R.L."
CASE LEFT(cMarca,7)$"TOP MAN"
	cNomMarca ="TOP-MAN"
CASE lentrim(cMarca)=0
	cNomMarca ="GENERAL"				
OTHERWISE
	cNomMarca = cMarca
ENDCASE
RETURN cNomMarca


FUNCTION TablaPrecios
LPARAMETERS cProv
LOCAL cNomProveedor

cNomProveedor = ''		
DO CASE
CASE "BERMON"$cProv
	cNomProveedor	= "ALEJANDRO BERMON"
CASE "HUCAL"$cProv
	cNomProveedor	= "AGRO HUCAL"
CASE "ALVEAR"$cProv
	cNomProveedor	= "AGRO ALVEAR"
CASE "AGROBULON"$STRTRAN(cProv," ","")
	cNomProveedor	= "AGRO BULON"
CASE "BULONFER"$cProv OR "BULNFER"$cProv OR "BUONFER"$cProv
	cNomProveedor	= "BULONFER S.A."
CASE "INSUMOS"$cProv
	cNomProveedor	= "AGRO INSUMOS"
CASE "BULLFLEX"$cProv
	cNomProveedor	= "CARAVANAS BULLFLEX"
CASE "AGROMAD"$cProv
	cNomProveedor	= "AGRO MADERAS"
CASE "AGRSUR"$cProv
	cNomProveedor	= "AGROSUR"
CASE "ANGAR"$cProv OR "AN-GAR"$cProv OR "AN GAR"$cProv
	cNomProveedor	= "AN-GAR"
CASE "ASCHER"$cProv
	cNomProveedor	= "ASCHERI & CIA."
CASE "CARDONE DANIEL"$cProv
	cNomProveedor	= "CARDONE DANIEL CARLOS"
CASE "ORTIZ"$cProv
	cNomProveedor	= "CARLOS P. ORTIZ"
CASE "BRAGA"$cProv
	cNomProveedor	= "CA�OS BRAGANZA"
CASE "CENTRO DE"$cProv
	cNomProveedor	= "CENTRO DE BATERIAS"
CASE "CODIMAT"$cProv
	cNomProveedor	= "CODIMAT S.A."
CASE "CONO SUR"$cProv
	cNomProveedor	= "CONO SUR S.A."
CASE "DELLA VALL"$cProv OR "DELA VALLE"$cProv OR "VALLA"$cProv
	cNomProveedor	= "DELLA VALLE Y CIA."
CASE "DISAH"$cProv
	cNomProveedor	= "DISAH BAHIA S.A."
CASE "LISBOA"$cProv
	cNomProveedor	= "DIST LISBOA"
CASE "GREGORIO"$cProv
	cNomProveedor	= "DIST GREGORIO"
CASE "FAMACO"$cProv
	cNomProveedor	= "FAMACON S.A."
CASE "FEDERICO GO"$cProv
	cNomProveedor	= "FEDERICO GONZALES"
CASE "Y FERN"$cProv
	cNomProveedor	= "FERNANDEZ Y FERNANDEZ"
CASE "FERRERO"$cProv OR "MEIFA"$cProv
	cNomProveedor	= "FERRERO MEIFA"
CASE "FERRI"$cProv OR "FERREM"$cProv
	cNomProveedor	= "FERRIMED S.A."
CASE "TITO"$cProv
	cNomProveedor	= "FERRETERIA TITO"
CASE "GIORDA"$cProv
	cNomProveedor	= "GIORDANINO"
CASE "GOMA T"$cProv
	cNomProveedor	= "GOMATODO"
CASE "SIMPA"$cProv
	cNomProveedor	= "GRUPO SIMPA S.A."
CASE "INCAHUEN"$cProv OR "INCH"$cProv
	cNomProveedor	= "INCAHUEN S.R.L."
CASE "INGERS"$cProv OR "INGRES"$cProv
	cNomProveedor	= "INGERSOL"
CASE "IPESA"$cProv
	cNomProveedor	= "IPESA SILO"
CASE "ITURRIA"$cProv
	cNomProveedor	= "ITURRIA S.A."
CASE "GALLARDO"$cProv
	cNomProveedor	= "JAVIER NESTOR GALLARDO"
CASE "JEREZ"$cProv 
	cNomProveedor	= "JEREZ HNOS."
CASE "AGUDA"$cProv
	cNomProveedor	= "LA AGUADA"
CASE ("LA FERETERA"$cProv OR "LA FERREE"$cProv) AND  NOT "TITA"$cProv
	cNomProveedor	= "LA FERRETERA"
CASE "MECANO"$cProv OR "INCH"$cProv
	cNomProveedor	= "MECANO GANADERO S.A."
CASE "MERIAL"$cProv 
	cNomProveedor	= "MERIAL ARGENTINA S.A."
CASE "METALTECN"$cProv 
	cNomProveedor	= "METALTECNICA S.R.L."
CASE "METFER"$cProv 
	cNomProveedor	= "METFER"
CASE "MEYER"$cProv
	cNomProveedor	= "MEYER SACIF"
CASE "MOLDPLA"$cProv 
	cNomProveedor	= "MOLDPLAS PAMPERO S.R.L."
CASE "OVER"$cProv 
	cNomProveedor	= "OVER S.A."
CASE "PAPIERT"$cProv 
	cNomProveedor	= "PAPIERTEI"	
CASE "MEGALUX"$cProv 
	cNomProveedor	= "PINTURAS MEGALUX S.R.L."
CASE "PROQUI"$cProv 
	cNomProveedor	= "PROQUIM"
CASE "RC"$LEFT(cProv ,2)
	cNomProveedor	= "RC DISTRIBUCIONES"
CASE "REGA"$cProv 
	cNomProveedor	= "REGA S.A."
CASE "RICHMOND"$cProv 
	cNomProveedor	= "RICHMOND VET PHARMA"
CASE "RUEDAGRO"$cProv 
	cNomProveedor	= "RUEDAGRO S.R.L."
CASE "SEERY"$cProv 
	cNomProveedor	= "SEERY MARTIN"
CASE "SIA LOGISTICA"$cProv 
	cNomProveedor	= "SIA LOGISTICA S.A."
CASE "SIMPA"$cProv 
	cNomProveedor	= "SIMPA S.A."
CASE "SIXCOM"$cProv 
	cNomProveedor	= "SIXCOM S.A."
CASE "SOC. IND."$cProv OR "SOCIEDAD IND"$cProv
	cNomProveedor	= "SOCIEDAD INDUSTRIAL ARGENTINA"
CASE "SOLMONI"$cProv OR "SOMONI"$cProv
	cNomProveedor	= "SOLMONI CARLOS"
CASE "STHIL"$cProv OR "STIHL"$cProv
	cNomProveedor	= "STIHL MONOIMPLEMENTOS S.A."
CASE "TECNOFARM"$cProv 
	cNomProveedor	= "TECNOFARM S.R.L."
CASE "TECNOSAN"$cProv 
	cNomProveedor	= "TECNOSAN S.R.L."
CASE "TERAR"$cProv 
	cNomProveedor	= "TERRAR"
CASE "TEXILO"$cProv 
	cNomProveedor	= "TEXILO S.A."
CASE "TUBO"$cProv 
	cNomProveedor	= "TUBOFORTE S.A."
CASE "URIARTE"$cProv OR "URIANTE"$cProv
	cNomProveedor	= "URIARTE TALDEA S.A."
CASE "VENTACO"$cProv 
	cNomProveedor	= "VENTACO S.A."
CASE "VIFAVET"$cProv 
	cNomProveedor	= "VIFAVET S.A."
CASE "VILLA NUEVA"$cProv 
	cNomProveedor	= "VILLA NUEVA S.A."
CASE "VON FRANK"$cProv 
	cNomProveedor	= "VON FRANKEN S.A.I.C."
CASE "WURTH"$cProv 
	cNomProveedor	= "WURTH ARGENTINA S.A."

CASE lentrim(cProv)=0
	cNomProveedor ="GENERICO"				
OTHERWISE
	cNomProveedor = cProv
ENDCASE
RETURN cNomProveedor

*------------------------------------------
* FUNCION ObtenerID(lcAlias,lnSucursal)
*------------------------------------------
* Funcion para generar el id = sucursal + id.
* lcAlias = Nombre de la tabla
* lnSucursal = numero d ela sucursal.
*------------------------------------------
FUNCTION ObtenerID
PARAMETERS lcAlias
TEXT TO lcCmdOb TEXTMERGE NOSHOW 
SELECT MAX(id) as max_id FROM <<lcAlias>> 
ENDTEXT 
IF NOT CrearCursorAdapter('CsrObtener',lcCmdOb)
	thisform.release 
	RETURN -1
ENDIF 
RETURN CsrObtener.max_id +1 

FUNCTION CargarUbicacion
PARAMETERS nCodigo
LOCAL nCodUbi
nCodUbi = 1
cCodigo = strzero(nCodigo,3)
TRY 
	IF cCodigo$"001,002,003,004,005,006,007,008,009,010,011,012,013,014,120,121,129,141,156,163,164,165,193,194,195,196,197,198,199" ;
	or cCodigo$"200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,318,219,220,221,222,223,224,283,284,285,286,287,288,290,291,292,293,294"
		nCodUbi = 2
	ENDIF 
CATCH TO oError
	oavisar.usuario(strtrim(nCodigo)+" "+oError.Message)
	nCodUbi = 0
ENDTRY 
SELECT CsrUbicacion
LOCATE FOR VAL(numero) = nCodUbi

RETURN CsrUbicacion.id

