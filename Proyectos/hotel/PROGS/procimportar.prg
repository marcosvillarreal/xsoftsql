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
*Si el año es menor es mayor al actual 19
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
lcCadena = STRTRAN(lcCadena,"Á","A")
lcCadena = STRTRAN(lcCadena,"É","E")
lcCadena = STRTRAN(lcCadena,"Í","I")
lcCadena = STRTRAN(lcCadena,"Ó","O")
lcCadena = STRTRAN(lcCadena,"Ú","U")

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
PARAMETERS lcLocalidad,lcProvincia
LOCAL lcnombre
lcNombre = lclocalidad
lcLocalidad = STRTRAN(STRTRAN(lcLocalidad," ",""),".","") 
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
CASE STRTRAN(STRTRAN(lcLocalidad," ",""),".","")$"BAHIABLANCA-BAHjABLANCA-BBLANCA-BAHÍABLANCA-BAHIABCA"
	lcnombre = "BAHIA BLANCA"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="B. BLANCA" .OR. ALLTRIM(UPPER(lcLocalidad))  ="BAHjA BLANCA"
	lcnombre = "BAHIA BLANCA"
CASE "BAHABLANCA"$lcLocalidad OR "BAHIBLA"$lcLocalidad OR "BAHÌA"$lcLocalidad
	lcnombre = "BAHIA BLANCA"	
CASE "BLACA"$lcLocalidad OR "BLABCA"$lcLocalidad OR "BANCA"$lcLocalidad OR "BAHAI"$lcLocalidad OR "BHI"$lcLocalidad
	lcnombre = "BAHIA BLANCA"	
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $"BUENOSAIRES-CABA-CADEBSAIRES-CAPFEDERAL-CAPITAL-CIUDADBUE-CAPITALFEDERAL-CDAUTONOMABSAIRES-BS"
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE "CIUDADAUTONOMA"$STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") 
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"	
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $"CIUDADAUTONOMABUENOSAIRES"
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $"FLORES-"
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE ALLTRIM(UPPER(lcLocalidad))  = "CAP" .or. ALLTRIM(UPPER(lcLocalidad)) = "CIUDAD BS"  .or. ALLTRIM(UPPER(lcLocalidad)) = "CABA"
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE "CAPILLADELSE"$STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CAPILLA DEL SEÑOR"
CASE STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") $ "CASEROS"
	lcnombre = "CASEROS"
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
CASE  ALLTRIM(UPPER(lcLocalidad))  = "FERREIRA"
	lcnombre = "FERREYRA"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "E. ECHEVERRIA"
	lcnombre = "BARRIO ESTEBAN ECHEVERRIA"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "CNEL. DORREGO"
	lcnombre = "CORONEL DORREGO"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "CATRILLO"
	lcnombre = "CATRILO"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "BERNAL OESTE"
	lcnombre = "BERNAL"
CASE  ALLTRIM(UPPER(lcLocalidad))  = "BAL. LAS GRUTAS"
	lcnombre = "BALNEARIO LAS GRUTAS"
CASE ALLTRIM(UPPER(lcLocalidad))  = "ARROYITO DULCE"
	lcnombre = "ARROYO DULCE"
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
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="C. PATAGONES" .OR. ALLTRIM(UPPER(lcLocalidad))  ="C.PATAGONES"
	lcnombre = "CARMEN DE PATAGONES"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="CAPITAL FEDERALPATAGONES"
	lcnombre = "CARMEN DE PATAGONES"
CASE  ALLTRIM(UPPER(lcLocalidad))  ="EL CONDOR" OR "CÓNDOR"$ALLTRIM(UPPER(lcLocalidad))
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
	lcProvincia = "RIO NEGRO"
CASE "CAGLIERO"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "CARDENAL CAGLIERO"
CASE "CONDOR"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "BALNEARIO EL CONDOR"
CASE "VIEDMA"$ALLTRIM(UPPER(lcLocalidad)) OR "VIDMA"$ALLTRIM(UPPER(lcLocalidad))
	lcnombre = "VIEDMA"
	lcProvincia = "RIO NEGRO"
CASE "RAMOS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RAMOS MEJIA"
CASE "SANJAV" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN JAVIER"
CASE "CIUDAD DE BS AS" $ STRTRAN(STRTRAN(lcLocalidad,"-",""),".","")
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE "SAO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN ANTONIO OESTE"
CASE "SANTONIO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN ANTONIO OESTE"
CASE "SERRACOL" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") OR "SIERRAC" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SIERRA COLORADA"
CASE "SERRAGRAN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SIERRA GRANDE"
CASE "VALCHETA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VALCHETA"
*!*	CASE "VILLALONGA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
*!*		lcnombre = "VILLA LONGA"
CASE "IDEVI" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","") OR "ELJUNCAL" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN JAVIER"

CASE "AGUADA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "AGUADA CECILIO"
CASE "GRALACHA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL ACHA"
CASE "ANELO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "AÑELO"
CASE "CHANAR" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN PATRICIOS DEL CHAÑAR"  	
CASE "DCHANA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN PATRICIOS DEL CHAÑAR" 
CASE "RDELOSSAUCE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RINCON DE LOS SAUCES"  	
CASE "RINCONDESAU" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
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
	lcnombre = "TOMAS M DE ANCHORENA" 			
CASE "TMDEANCHOR" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "TOMAS M DE ANCHORENA" 			
CASE "TOMASMDEANO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "TOMAS M DE ANCHORENA" 	
CASE "ANCHORENA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ANCHORENA" 
CASE "SANTONIOOESTE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN ANTONIO OESTE"  	
CASE "SANAOESTE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN ANTONIO OESTE"  	
CASE "SANATONIOOESTE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN ANTONIO OESTE"  		
CASE "VIILAMAZA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA MAZA"  	
CASE "CIUDADBUEN" $lcLocalidad OR "BBCA"$lcLocalidad OR "BSAS"$lcLocalidad
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE "CIUDADDEBUENOS" $lcLocalidad OR "CASBAS"$lcLocalidad OR "CASBA"$lcLocalidad
	lcnombre = "CIUDAD DE BUENOS AIRES"
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"
CASE "JUNINDLANDES" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "JUNIN DE LOS ANDES"  		
CASE "JUNINDLOS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "JUNIN DE LOS ANDES"  	
CASE "SMDELOSANDES" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN MARTIN DE LOS ANDES"  		
CASE "CLPIEDRABUENA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "COMANDANTE LUIS PIEDRABUENA"  	
CASE "COMANDANTELUIS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "COMANDANTE LUIS PIEDRABUENA"  	
CASE "COLSANTAMARIA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "COLONIA SANTA MARIA"  		
CASE "CORONELZUAREZ" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CORONEL SUAREZ"  		
CASE "SANTATERESA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "COLONIA SANTA TERESA"  		
CASE "CUCHILLOCO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CUCHILLO CO"  		
CASE "DARREGUIERA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "DARREGUEIRA"  		
CASE "DOBLA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "DOBLAS"  		
CASE "LOVENTU" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "LOVENTUEL"  		
CASE "QUEMU" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "QUEMU QUEMU"  		
CASE "GRALPICO" $ STRTRAN(STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".",""),",","")
	lcnombre = "GENERAL PICO"  		
	lcProvincia = 'LA PAMPA'
CASE "GOBCRESPO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GOBERNADOR CRESPO" 	
CASE "SANRAFAEL" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN RAFAEL" 
CASE "SANMIGUELARCA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN MIGUEL ARCANGEL" 
CASE "SDELAVENTANA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SIERRA DE LA VENTANA" 
CASE "LAREFORMAVIEJ" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "LA REFORMA VIEJA" 
CASE "GRALSANMARTIN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL SAN MARTIN" 
CASE "PAZAHUIN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "PLAZA HUINCUL"
CASE "GRALFERNANDEZ" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL FERNANDEZ ORO"
CASE "BARILOCHE" $lcLocalidad OR "BARILO" $lcLocalidad OR "BARLOCH"$lcLocalidad
	lcnombre = "SAN CARLOS DE BARILOCHE"
	lcProvincia = 'NEUQUEN'
CASE "SCDEBARILOCHE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN CARLOS DE BARILOCHE"
	lcProvincia = 'NEUQUEN'
CASE "SANCARLOSDE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN CARLOS DE BARILOCHE"	
	lcProvincia = 'NEUQUEN'
CASE "LASGRUTAS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "LAS GRUTAS"
CASE "SIERRAGRANDE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SIERRA GRANDE"	
	lcProvincia = "RIO NEGRO"	
CASE "PATAGONES" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CARMEN DE PATAGONES" 
CASE "GONZALEZCHAVEZ" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ADOLFO GONZALES CHAVES" 
CASE "CLAROMECO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CLAROMECO" 
CASE "RETA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RETA" 	
CASE "CIPOLLE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CIPOLLETTI" 	
	lcProvincia = "RIO NEGRO"
CASE "CIPPOLE" $lcLocalidad OR "CIPOLE" $lcLocalidad
	lcnombre = "CIPOLLETTI" 	
	lcProvincia = "RIO NEGRO"
CASE "CUTRALCO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CUTRAL CO" 	
CASE "CULTRALCO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CUTRAL CO" 	
CASE "GRALROCA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL ROCA" 	
CASE "GUAYMALLEN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN JOSE DE GUAYMALLEN" 
	lcProvincia = 'MENDOZA'	
CASE "BALNEARIOSAUCEGRANDE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAUCE GRANDE" 
CASE "CHACICO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CHASICO" 
CASE "ORENSESUR" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ORENSE" 
CASE "GENERALCAMPOS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "GENERAL MANUEL CAMPOS" 
CASE "VILLADOMINICO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA DOMINICO" 
CASE "LAADELA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "LA ADELA" 		 	
CASE "BERISSO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "BERISSO" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "CA¥ADONSECO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CAÑADON SECO" 		 
CASE "TIERRADELFUEGO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "USHUAIA" 		
CASE "CHOLE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "CHOELE CHOEL" 	
CASE "NEUQUEN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcProvincia = 'NEUQUEN'
CASE "NQN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcProvincia = 'NEUQUEN'
	lcnombre = "NEUQUEN" 		 
CASE "DESEADO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "PUERTO DESEADO" 		 
	lcProvincia = 'SANTA CRUZ'
CASE "ITUZAINGO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ITUZAINGÓ" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "JUNIN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "JUNÍN" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "MARDEPLATA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "MAR DEL PLATA" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "MORON" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "MORÓN" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "MTEGRANDE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "MONTE GRANDE" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "PIGUE" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "PIGUÉ" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "PLOTTIER" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcProvincia = 'NEUQUEN'
CASE "RANCHO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RANCHOS" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "RIOCOLORADO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RÍO COLORADO" 		 
	lcProvincia = 'RIO NEGRO'
CASE "RIOGALLEGOS" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "RÍO GALLEGOS" 		 
	lcProvincia = 'SANTA CRUZ'
CASE "PARAN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "PARANÁ" 		 
	lcProvincia = 'ENTRE RIOS'
CASE "SSDEJUJUY" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SAN SALVADOR DE JUJUY" 		 
	lcProvincia = 'JUJUY'
CASE "BALLESTER" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "VILLA BALLESTER" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "MADRYN" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "PUERTO MADRYN" 		 
	lcProvincia = 'CHUBUT'
CASE "TRELEW" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "TRELEW" 		 
	lcProvincia = 'CHUBUT'
CASE "9DEJULIO" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "9 DE JULIO" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "ASCASUBI" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "HILARIO ASCASUBI" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "BONZI" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ALDO BONZI" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "BONZI" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ALDO BONZI" 		 
	lcProvincia = 'BUENOS AIRES'
CASE ALLTRIM(UPPER(lcLocalidad))  = "G.CHAVEZ"
	lcnombre = "ADOLFO GONZALES CHAVES"
CASE "CHAVEZ"$lcLocalidad
	lcnombre = "ADOLFO GONZALES CHAVES" 		 
	lcProvincia = 'BUENOS AIRES'	
CASE "ACHAVEZ" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "ADOLFO GONZALES CHAVES" 		 
	lcProvincia = 'BUENOS AIRES'	
CASE "RIVADAVIA" $ lcLocalidad OR "CRIVAD" $ lcLocalidad
	lcnombre = "COMODORO RIVADAVIA" 		 
	lcProvincia = 'CHUBUT'			
CASE "STAROSA" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "SANTA ROSA" 		 
	lcProvincia = 'LA PAMPA'		
CASE "HUDSOLL" $ STRTRAN(STRTRAN(STRTRAN(lcLocalidad," ",""),"-",""),".","")
	lcnombre = "HUDSON" 		 
	lcProvincia = 'BUENOS AIRES'		
CASE "KORN" $ lcLocalidad OR "KODEL" $ lcLocalidad
	lcnombre = "ALEJANDRO KORN" 		 
	lcProvincia = 'BUENOS AIRES'		
CASE "ABASTO" $ lcLocalidad
	lcnombre = "ABASTO" 		 
	lcProvincia = 'BUENOS AIRES'		
CASE "ACASSU"$lcLocalidad OR "ACASUS"$lcLocalidad OR "ACAZUZO"$lcLocalidad
	lcnombre = "ABASTO" 		 
	lcProvincia = 'BUENOS AIRES'		
CASE "ADROG" $ lcLocalidad OR "AGROGUE" $ lcLocalidad
	lcnombre = "ADROGUÉ" 		 
	lcProvincia = 'BUENOS AIRES'	
CASE "ALBERDI" $ lcLocalidad OR "ALBERTI" $ lcLocalidad
	lcnombre = "ALBERTI" 		 
	lcProvincia = 'BUENOS AIRES'
CASE "ALLEN" $ lcLocalidad
	lcnombre = "ALLEN" 		 
	lcProvincia = 'RIO NEGRO'
CASE "BROW" $ lcLocalidad 
	lcnombre = "ALMIRANTE BROWN" 		 
	lcProvincia = 'BUENOS AIRES'	
CASE "ARREC" $ lcLocalidad 
	lcnombre = "ARRECIFES" 		 
	lcProvincia = 'BUENOS AIRES'	
CASE "ARROYOSECO" $ lcLocalidad 
	lcnombre = "ARROYO SECO" 		 
	lcProvincia = 'SANTA FE'	
CASE "ASCENCI"$ lcLocalidad 
	lcnombre = "ASCENSIÓN"
	lcProvincia = 'BUENOS AIRES'	
CASE "AVELLAN"$ lcLocalidad OR "AVELLLANEDA"$lcLocalidad
	lcnombre = "AVELLANEDA"
	lcProvincia = 'BUENOS AIRES'		
CASE "BANF"$ lcLocalidad OR "BAND"$lcLocalidad
	lcnombre = "BANFIELD"
	lcProvincia = 'BUENOS AIRES'			
CASE "ALMAGRO"$ lcLocalidad OR "CABALLITO"$lcLocalidad
	lcProvincia = "CIUDAD AUTONOMA DE BUENOS AIRES"	
CASE "AMEGHINO"$ lcLocalidad 
	lcnombre = "FLORENTINO AMEGHINO"
	lcProvincia = 'BUENOS AIRES'		
CASE "BELGRANO"$ lcLocalidad 
	lcnombre = "GENERAL BELGRANO"
	lcProvincia = 'BUENOS AIRES'		
CASE "BELLAVISTA"$ lcLocalidad 
	lcnombre = "BELLA VISTA"
	lcProvincia = 'BUENOS AIRES'			
CASE "BENAVIDE"$ lcLocalidad 
	lcnombre = "BENAVÍDEZ"
	lcProvincia = 'BUENOS AIRES'		
CASE "BERISO"$lcLocalidad OR "BERIZZO"$lcLocalidad
	lcnombre = "BERISSO"
	lcProvincia = 'BUENOS AIRES'	
CASE "BOLIVAR"$lcLocalidad 
	lcnombre = "BOLÍVAR"
	lcProvincia = 'BUENOS AIRES'		
CASE "BOULOGNE"$lcLocalidad OR "BOULO"$lcLocalidad OR "BULOGNE"$lcLocalidad
	lcnombre = "BOULOGNE SUR MER"
	lcProvincia = 'BUENOS AIRES'	
CASE "BRANDS"$lcLocalidad OR "BRANSEN"$lcLocalidad
	lcnombre = "BRANDSEN"
	lcProvincia = 'BUENOS AIRES'	
CASE "BURAT"$lcLocalidad
	lcnombre = "MAYOR BURATOVICH"
	lcProvincia = 'BUENOS AIRES'	
CASE "BURRACO"$lcLocalidad OR "BURSACO"$lcLocalidad OR "BURZAC"$lcLocalidad OR "BUSTACO"$lcLocalidad
	lcnombre = "BURZACO"
	lcProvincia = 'BUENOS AIRES'		
CASE "BELEN"$lcLocalidad OR "ESCOBAR"$lcLocalidad
	lcnombre = "BELÉN DE ESCOBAR"
	lcProvincia = 'BUENOS AIRES'	
CASE "PRINGLES"$lcLocalidad OR "PRIBLES"$lcLocalidad OR "PRINGLER"$lcLocalidad OR "PRNGLES"$lcLocalidad
	lcnombre = "CORONEL PRINGLES"
	lcProvincia = 'BUENOS AIRES'		
CASE "SUAREZ"$lcLocalidad OR "SUEAREZ"$lcLocalidad OR "SUEREZ"$lcLocalidad OR "SUREZ"$lcLocalidad
	lcnombre = "CORONEL SUAREZ"
	lcProvincia = 'BUENOS AIRES'	
CASE "DORREGO"$lcLocalidad 
	lcnombre = "CORONEL DORREGO"
	lcProvincia = 'BUENOS AIRES'	
CASE "CALETA"$lcLocalidad OR "COLIVIA"$lcLocalidad
	lcnombre = "CALETA OLIVIA"
	lcProvincia = 'CHUBUT'	
CASE "CAMPABNA"$lcLocalidad OR "CAMPANIA"$lcLocalidad 
	lcnombre = "CALETA OLIVIA"
	lcProvincia = 'BUENOS AIRES'
CASE "CANNING"$lcLocalidad 
	lcnombre = "CANNING"
	lcProvincia = 'BUENOS AIRES'
CASE "CAPILLA"$lcLocalidad 
	lcnombre = "CAPILLA DEL SEÑOR"
	lcProvincia = 'BUENOS AIRES'
CASE "CARLOSCASAR"$lcLocalidad OR  "CASERES"$lcLocalidad OR  "CASPRES"$lcLocalidad OR "CASARES"$lcLocalidad
	lcnombre = "CARLOS CASARES"
	lcProvincia = 'BUENOS AIRES'
CASE "TEJEDOR"$lcLocalidad OR  "TESEROR"$lcLocalidad 
	lcnombre = "CARLOS TEJEDOR"
	lcProvincia = 'BUENOS AIRES'
CASE "CARMEN"$lcLocalidad 
	lcnombre = "CARMEN DE PATAGONES"
	lcProvincia = 'BUENOS AIRES'	
CASE "CASTEL"$lcLocalidad 
	lcnombre = "CASTELAR"
	lcProvincia = 'BUENOS AIRES'		
CASE "CATRIEL"$lcLocalidad 
	lcnombre = "CATRIEL"
	lcProvincia = 'RIO NEGRO'			
CASE "CATRILO"$lcLocalidad 
	lcnombre = "CATRILO"
	lcProvincia = 'LA PAMPA'	
CASE "CAÑUELA"$lcLocalidad 
	lcnombre = "CAÑUELAS"
	lcProvincia = 'BUENOS AIRES'	
CASE "CHASCOMUS"$lcLocalidad OR "CHASCOMU"$lcLocalidad
	lcnombre = "CHASCOMUS"
	lcProvincia = 'BUENOS AIRES'		
CASE "CHIVILCOY"$lcLocalidad OR "CHIVIL"$lcLocalidad
	lcnombre = "CHIVILCOY"
	lcProvincia = 'BUENOS AIRES'		
CASE "CHOELE"$lcLocalidad 
	lcnombre = "CHOELE-CHOEL"
	lcProvincia = 'RIO NEGRO'	
CASE "CHUBUT"$lcLocalidad 
	lcnombre = "TRELEW"
	lcProvincia = 'CHUBUT'	
CASE "CINCO SALTOS"$lcLocalidad 
	lcnombre = "CINCO SALTOS"
	lcProvincia = 'CHUBUT'	
CASE "CINCO SALTOS"$lcLocalidad 
	lcnombre = "CINCO SALTOS"
	lcProvincia = 'RIO NEGRO'	
CASE "CITY BELL"$lcLocalidad OR "CITIBELL"$lcLocalidad 
	lcnombre = "CITY BELL"
	lcProvincia = 'BUENOS AIRES'		
CASE "CIUDAD EVITA"$lcLocalidad 
	lcnombre = "CIUDAD EVITA"
	lcProvincia = 'BUENOS AIRES'	
CASE "CLAYP"$lcLocalidad 
	lcnombre = "CLAYPOLE"
	lcProvincia = 'BUENOS AIRES'	
CASE "CONESA"$lcLocalidad 
	lcnombre = "GENERAL CONESA"
	lcProvincia = 'RIO NEGRO'
CASE "CORDOBA"$lcLocalidad 
	lcnombre = "CORDOBA"
	lcProvincia = 'CORDOBA'		
CASE "CONCORDIA"$lcLocalidad 
	lcnombre = "CONCORDIA"
	lcProvincia = 'ENTRE RIOS'						
CASE "CORRIENTES"$lcLocalidad 
	lcnombre = "CORRIENTES"
	lcProvincia = 'CORRIENTES'		
CASE "CUTRAL"$lcLocalidad 
	lcnombre = "CUTRAL CO"
	lcProvincia = 'NEUQUEN'	
CASE "DAIREAUX"$lcLocalidad 
	lcnombre = "DAIREAUX"
	lcProvincia = 'BUENOS AIRES'		
CASE "GENERAL PICO"$lcLocalidad 
	lcnombre = "GENERAL PICO"
	lcProvincia = 'LA PAMPA'	
CASE "GENERAL ROCA"$lcLocalidad 
	lcnombre = "GENERAL ROCA"
	lcProvincia = 'RIO NEGRO'	
CASE "CAÑUELA"$lcLocalidad OR "CAÃ‘UELA"$lcLocalidad OR "CANUELA"$lcLocalidad
	lcnombre = "CAÑUELAS"
	lcProvincia = 'BUENOS AIRES'	
CASE "CENTENARIO"$lcLocalidad 
	lcnombre = "CENTENARIO"
	lcProvincia = 'NEUQUEN'		
CASE "DELVISO"$lcLocalidad 
	lcnombre = "DEL VISO"
	lcProvincia = 'BUENOS AIRES'		
CASE "ELPALOMAR"$lcLocalidad OR "ELPALMAR"$lcLocalidad
	lcnombre = "EL PALOMAR"
	lcProvincia = 'BUENOS AIRES'		
CASE "ELTALAR"$lcLocalidad 
	lcnombre = "EL TALAR"
	lcProvincia = 'BUENOS AIRES'	
CASE "ENSENA"$lcLocalidad OR "ENCENA"$lcLocalidad
	lcnombre = "ENSENADA"
	lcProvincia = 'BUENOS AIRES'	
CASE "EZPELETA"$lcLocalidad OR "EZPECE"$lcLocalidad OR "EZPOLE"$lcLocalidad
	lcnombre = "EZPELETA"
	lcProvincia = 'BUENOS AIRES'		
CASE "VARELA"$lcLocalidad 
	lcnombre = "FLORENCIO VARELA"
	lcProvincia = 'BUENOS AIRES'		
CASE "FLORIDA"$lcLocalidad 
	lcnombre = "FLORIDA"
	lcProvincia = 'BUENOS AIRES'		
CASE "FUNES"$lcLocalidad 
	lcProvincia = 'BUENOS AIRES'	
CASE "GARÍN"$lcLocalidad OR "GARIN"$lcLocalidad 
	lcnombre = "GARÍN"
	lcProvincia = 'BUENOS AIRES'		
CASE "GODOY"$lcLocalidad 
	lcnombre = "GODOY CRUZ"
	lcProvincia = 'MENDOZA'		
CASE "GONET"$lcLocalidad OR "GONNET"$lcLocalidad OR "GOMMET"$lcLocalidad
	lcnombre = "MANUEL BERNARDO GONNET"
	lcProvincia = 'BUENOS AIRES'		
CASE "CATAN"$lcLocalidad 
	lcnombre = "GONZÁLEZ CATÁN"
	lcProvincia = 'BUENOS AIRES'		
CASE "ALVEAR"$lcLocalidad 
	lcnombre = "GENERAL ALVEAR"
	lcProvincia = 'BUENOS AIRES'		
CASE "MADRID"$lcLocalidad 
	lcnombre = "GENERAL LA MADRID"
	lcProvincia = 'BUENOS AIRES'		
CASE "MADARIAGA"$lcLocalidad 
	lcnombre = "GENERAL JUAN MADARIAGA"
	lcProvincia = 'BUENOS AIRES'			
CASE "PACHECO"$lcLocalidad 
	lcnombre = "GENERAL PACHECO"
	lcProvincia = 'BUENOS AIRES'	
CASE "RODRIGUEZ"$lcLocalidad 
	lcnombre = "GENERAL RODRIGUEZ"
	lcProvincia = 'BUENOS AIRES'	
CASE "ALPACHIRI"$lcLocalidad 
	lcnombre = "ALPACHIRI"
	lcProvincia = 'LA PAMPA'		
CASE "ALTA GRACIA"$lcLocalidad 
	lcnombre = "ALTA GRACIA"
	lcProvincia = 'CORDOBA'	
CASE "CBA"$lcLocalidad  AND lcProvincia="CORDOBA"
	lcnombre = "CORDOBA"
	lcProvincia = 'CORDOBA'		
CASE "CHAJAR"$lcLocalidad 
	lcnombre = "CHAJARÍ   "
	lcProvincia = 'ENTRE RIOS'		
CASE "EL BOLSON"$lcLocalidad 
	lcnombre = "EL BOLSÓN"
	lcProvincia = 'NEUQUEN'			
CASE "EMPEDRADO"$lcLocalidad 
	lcProvincia = 'CORRIENTES'			
CASE "ESPERANZA"$lcLocalidad 
	lcProvincia = 'SANTA FE'			
CASE "FERNANDEZORO"$lcLocalidad 
	lcProvincia = 'RIO NEGRO'	
	lcnombre = "GENERAL FERNANDEZ ORO"		
CASE "GAIMAN"$lcLocalidad OR "GALMAN"$lcLocalidad 
	lcProvincia = 'CHUBUT'	
	lcnombre = "GAIMAN"
CASE "GOYA"$lcLocalidad 
	lcProvincia = 'CORRIENTES'	
CASE "HURLINGAN"$lcLocalidad OR "HURLINGAM"$lcLocalidad 
	lcnombre = "HURLINGHAM"	
CASE "MASCHWITZ"$lcLocalidad OR "MASCHKTIZ"$lcLocalidad 
	lcnombre = "INGENIERO MASCHWITZ"	
CASE "WHITE"$lcLocalidad 
	lcnombre = "INGENIERO WHITE"	
CASE "CASANOVA"$lcLocalidad 
	lcnombre = "ISIDRO CASANOVA"
CASE "ITUZAING"$lcLocalidad 
	lcnombre = "ITUZAINGÓ"	
CASE "JOSECPAZ"$lcLocalidad 
	lcnombre = "JOSÉ CLEMENTE PAZ"		
CASE "LUCILA"$lcLocalidad 
	lcnombre = "LA LUCILA"		
CASE "LAFERRERE"$lcLocalidad OR "LAFERRE"$lcLocalidad
	lcnombre = "GREGORIO DE LAFERRERE"	
CASE "HERAS"$lcLocalidad
	lcnombre = "GENERAL LAS HERAS"	
CASE "LUISBELTR"$lcLocalidad
	lcnombre = "LUIS BELTRÁN"
CASE "NDECUYO"$lcLocalidad
	lcnombre = "LUJÁN DE CUYO"	
CASE "MAIP"$lcLocalidad
	lcnombre = "MAIPÚ"	
CASE "MARDEAJ"$lcLocalidad
	lcnombre = "MAR DE AJÓ"	
CASE "MAIP"$lcLocalidad
	lcnombre = "MAIPÚ"	
CASE "MDP"$lcLocalidad OR "MDQ"$lcLocalidad
	lcnombre = "MAR DEL PLATA"		
CASE "TILLY"$lcLocalidad OR "TILLI"$lcLocalidad
	lcnombre = "RADA TILLY"		
CASE "ROCA"$lcLocalidad 
	lcnombre = "GENERAL ROCA"
CASE "SANNICOLAS"$lcLocalidad 
	lcnombre = "SAN NICOLÁS DE LOS ARROYOS"
			
ENDCASE

IF ASC(SUBSTR(lcLocalidad,4,1))=161
	lcnombre='PUNTA ALTA'
ENDIF 

RETURN lcNombre