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

FUNCTION Ciudades
PARAMETERS lcLocalidad
LOCAL lcnombre
lcNombre = lclocalidad

DO CASE
CASE lcLocalidad = "CIUDAD ATLANTIDA"
	lcnombre = "BARRIO CIUDAD ATLANTIDA"
CASE "CERRI" $ STRTRAN(STRTRAN(lcLocalidad," ",""),".","")
	lcnombre = "GENERAL DANIEL CERRI"
CASE "PEH"$lcLocalidad
	lcnombre = "PEHUEN CO"
CASE "ARIAS"$lcLocalidad
	lcnombre = "VILLA GRAL. ARIAS"
CASE lcLocalidad  = "CNEL. DORREGO"
	lcnombre = "CORONEL DORREGO"
CASE lcLocalidad = "CIUDAD ATLANTIDA"
	lcnombre = "BARRIO CIUDAD ATLANTIDA"
CASE STRTRAN(STRTRAN(lcLocalidad," ",""),".","") $ "PALTA-PUNTAALTA-PATA-"
	lcnombre = "PUNTA ALTA"
CASE STRTRAN(STRTRAN(lcLocalidad," ",""),".","")$"BAHIABLANCA-BAHjABLANCA-BBLANCA-BAH�ABLANCA"
	lcnombre = "BAHIA BLANCA"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $"BUENOSAIRES-CABA-CADEBSAIRES-CAPFEDERAL-CAPITAL-CIUDADBUE-CAPITALFEDERAL-CDAUTONOMABSAIRES-BS"
	lcnombre = "CIUDAD DE BUENOS AIRES"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $"FLORES-"
	lcnombre = "CIUDAD DE BUENOS AIRES"
CASE "CAPILLADELSE"$STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CAPILLA DEL SE�OR"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "CASEROS"
	lcnombre = "CASEROS (PDO. 3 DE FEBRERO)"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "CIUDADELANORTE"
	lcnombre = "CIUDADELA"
CASE "SAGUIER" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SANTA CLARA DE SAGUIER"
CASE "ECHEVA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "BARRIO ESTEBAN ECHEVERRIA"
CASE "GALARZA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL GALARZA"
CASE "CAMPOS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL MANUEL CAMPOS"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "JOSELSUAREZ"
	lcnombre = "JOSE LEON SUAREZ"
CASE "LANUS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "LANUS"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "LAVALLOL"
	lcnombre = "LLAVALLOL"
CASE "ZAMORA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "LOMAS DE ZAMORA"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "MARDELPLATA"
	lcnombre = "MAR DEL PLATA"	
CASE "PAVON" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "PAVON"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "PILAR"
	lcnombre = "PILAR"
CASE "MEJIA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RAMOS MEJIA"
CASE "REMECO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "REMECO (DPTO. GUATRACHE)"
CASE "JOSEDELAESQUINA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN JOSE DE LA ESQUINA"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "ROSARIO"
	lcnombre = "ROSARIO"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "ISABEL"
	lcnombre = "BARRIO SANTA ISABEL"	
CASE "INSUPERABLE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA INSUPERABLE"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "VRETIRO"
	lcnombre = "BUEN RETIRO"	
CASE "GOBGALVEZ" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA GOBERNADOR GALVEZ"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "VTELOPEZ"
	lcnombre = "VICENTE LOPEZ"
CASE "CHAVES"$STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ADOLFO GONZALES CHAVES"
CASE ALLTRIM(UPPER(lcLocalidad))= "PARERA LP"
	lcnombre = "PARERA"
CASE  ALLTRIM(UPPER(lcLocalidad)) = "LA PAMPA"
	lcnombre = "SANTA ROSA"
CASE  ALLTRIM( UPPER(lcLocalidad) )= "LA MERCED"
	lcnombre = "COLONIA LA MERCED"
CASE  ALLTRIM( UPPER(lcLocalidad)) = "GRAL. DANIEL CERRI"
	lcnombre = "GENERAL DANIEL CERRI"
CASE  ALLTRIM( UPPER(lcLocalidad)) = "GRAL. CERRI"
	lcnombre = "GENERAL CERRI"
CASE  ALLTRIM( UPPER(lcLocalidad)) = "GRAL. RODRIGUEZ"
	lcnombre = "GENERAL RODRIGUEZ"
CASE ALLTRIM(UPPER(lcLocalidad)) = "GRAL. CONESA" .OR. ALLTRIM(UPPER(lcLocalidad))  = "GRAL. CONESAA" .OR. ALLTRIM(UPPER(lcLocalidad))  = "GRAL.CONESA"
	lcnombre = "GENERAL CONESA"
CASE "CONESA"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "GENERAL CONESA"
CASE ALLTRIM(UPPER(lcLocalidad))  = "G.CHAVEZ"
	lcnombre = "GONALEZ CHAVES"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "FERREIRA"
	lcnombre = "FERREYRA"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "E. ECHEVERRIA"
	lcnombre = "BARRIO ESTEBAN ECHEVERRIA"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "CNEL. DORREGO"
	lcnombre = "CORONEL DORREGO"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "CATRILLO"
	lcnombre = "CATRILO"
CASE ALLTRIM(UPPER(lcLocalidad))  = "CAP" .or. ALLTRIM(UPPER(lcLocalidad)) = "CIUDAD BS"
	lcnombre = "CIUDAD DE BUENOS AIRES"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "BERNAL OESTE"
	lcnombre = "BERNAL"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "BAL. LAS GRUTAS"
	lcnombre = "BALNEARIO LAS GRUTAS"
CASE ALLTRIM(UPPER(lcLocalidad))  = "ARROYITO DULCE"
	lcnombre = "ARROYO DULCE"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="B. BLANCA" .OR. ALLTRIM(UPPER(lcLocalidad))  ="BAHjA BLANCA"
	lcnombre = "BAHIA BLANCA"
CASE "SAN BLAS"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "BAHIA SAN BLAS"
CASE ALLTRIM(UPPER(lcLocalidad))  = "SAN BLAS"
	lcnombre = "BAHIA SAN BLAS"
CASE ALLTRIM(UPPER(lcLocalidad))  ="BALN. EL CONDOR" .OR.ALLTRIM(UPPER(lcLocalidad)) ="BRIO. EL CONDOR"
	lcnombre = "BALNEARIO EL CONDOR"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="B.EL CONDOR"  .OR. ALLTRIM(UPPER(lcLocalidad)) ="B. EL CONDOR"
	lcnombre = "BALNEARIO EL CONDOR"
CASE  ALLTRIM(UPPER(lcLocalidad)) ="BUENOS AIRES" .OR.ALLTRIM(UPPER(lcLocalidad))  ="BS"
	lcnombre = "CIUDAD DE BUENOS AIRES"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="C. PATAGONES" .OR. ALLTRIM(UPPER(lcLocalidad))  ="C.PATAGONES"
	lcnombre = "CARMEN DE PATAGONES"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="CAPITAL FEDERALPATAGONES"
	lcnombre = "CARMEN DE PATAGONES"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="EL CONDOR" OR "C�NDOR"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "BALNEARIO EL CONDOR"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="GDOR. GALVEZ"
	lcnombre = "GALVEZ"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="GUADIA MITRE"
	lcnombre = "GUARDIA MITRE"
CASE  "MITRE"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "GUARDIA MITRE"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="JOSE CASAS"
	lcnombre = "JOSE B. CASAS"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="PATAGONES" .OR.ALLTRIM(UPPER(lcLocalidad))  ="C. DE PATAGONES" .OR. ALLTRIM(UPPER(lcLocalidad))  ="C.  PATAGONES"
	lcnombre = "CARMEN DE PATAGONES"
CASE ALLTRIM(UPPER(lcLocalidad))  ="SAN ANTONIO" .OR. ALLTRIM(UPPER(lcLocalidad))  ="SAN A " .OR. ALLTRIM(UPPER(lcLocalidad))  ="SAN A." .OR. ALLTRIM(UPPER(lcLocalidad))  ="S. A. O" .OR. ALLTRIM(UPPER(lcLocalidad))  ="SANANTONIO" 
	lcnombre = "SAN ANTONIO OESTE"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="STROEDER" .or. ALLTRIM(UPPER(lcLocalidad))  ="STREDER".OR.ALLTRIM(UPPER(lcLocalidad))  ="ESTROEDER"
	lcnombre = "EMPORIO STROEDER"
CASE ALLTRIM(UPPER(lcLocalidad))  ="VIEMA" .OR. ALLTRIM(UPPER(lcLocalidad))  ="VEDMA"
	lcnombre = "VIEDMA"
CASE "CAGLIERO"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "CARDENAL CAGLIERO"
CASE "CONDOR"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "BALNEARIO EL CONDOR"
CASE "VIEDMA"$ALLTRIM(UPPER(lcLocalidad)) OR "VIDMA"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "VIEDMA"
CASE "RAMOS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RAMOS MEJIA"
CASE "SANJAV" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN JAVIER"
CASE "CIUDAD DE BS AS" $ STRTRAN(STRTRAN(lcLocalidad,"-",""),".","")
	lcnombre = "CIUDAD DE BUENOS AIRES"
CASE "SAO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN ANTONIO OESTE"
CASE "SERRACOL" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") OR "SIERRAC" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SIERRA COLORADA"
CASE "SERRAGRAN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SIERRA GRANDE"
CASE "VALCHETA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VALCHETA"
CASE "VILLALONGA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA LONGA"
CASE "IDEVI" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") OR "ELJUNCAL" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN JAVIER"

CASE "AGUADA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "AGUADA CECILIO"
CASE "GRALACHA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL ACHA"
CASE "ANELO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "A�ELO"
CASE "CHANAR" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN PATRICIOS DEL CHA�AR"  	
CASE "DCHANA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN PATRICIOS DEL CHA�AR" 
CASE "RDELOSSAUCES" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RINCON DE LOS SAUCES"  	
CASE "EMBMARTINI" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "EMBAJADOR MARTINI"  	
CASE "INTALVEAR" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "INTENDENTE ALVEAR"  		
CASE "ALGDELAGUILA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ALGARROBO DEL AGUILA"  	
CASE "ANGUIL" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ALGARROBO DEL AGUILA"  	
CASE "ANGOSTURA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA LA ANGOSTURA" 
CASE "TMANCHORENA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "TOMAS M DE ANOCHERANA" 			
CASE "TMDEANCHOR" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "TOMAS M DE ANOCHERANA" 			
CASE "ANCHORENA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ANCHORENA" 
CASE "SANTONIOOESTE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN ANTONIO OESTE"  		
CASE "VIILAMAZA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA MAZA"  	
CASE "CIUDADBUEN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CIUDAD DE BUENOS AIRES"
 		

CASE "JUNINDLANDES" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "JUNIN DE LOS ANDES"  		

CASE "SMDELOSANDES" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN MARTIN DE LOS ANDES"  		
CASE "PATAGONES" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CARMEN DE PATAGONES"  	
 
ENDCASE

IF ASC(SUBSTR(lcLocalidad,4,1))=161
	lcnombre='PUNTA ALTA'
ENDIF 

RETURN lcNombre