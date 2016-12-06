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


FUNCTION TablaProveedores
LPARAMETERS cCodAlfa
LOCAL cNomProveedor

cNomProveedor = ''		
DO CASE
CASE LEFT(cCodAlfa,5)$"APICA-APICB-APICC-APICD-APICM-APICN-APIPU"
	cNomProveedor ='PURIFICADORES ARGENTINOS S.A.'
CASE LEFT(cCodAlfa,4)$"NAPA-NAPD-NAPM-NAPP-NAPT-NAPX"
	cNomProveedor ='POYNAL S.R.L.'
CASE LEFT(cCodAlfa,5)$"NAPZB-NRWD-NRFUS-NRVAR" AND VAL(RIGHT(cCodAlfa,3))>=400 AND VAL(RIGHT(cCodAlfa,3))<=499
	cNomProveedor ='PROV. SERV. S.A.'
CASE LEFT(cCodAlfa,5)$"NRATR"
	cNomProveedor ='ARGENSIL S.R.L.'
CASE LEFT(cCodAlfa,5)$"NRSIL"
	cNomProveedor ='PROCHEM S.A.'
CASE LEFT(cCodAlfa,5)$"NRFUL"
	cNomProveedor ='FERREIRA CARLOS ALBERTO'
CASE LEFT(cCodAlfa,5)$"LUBRI" OR (LEFT(cCodAlfa,5)$"NRLUB" AND VAL(RIGHT(cCodAlfa,4))<=2999)
	cNomProveedor ='FERCOL LUBRICANTES S.R.L.'
CASE LEFT(cCodAlfa,5)$"NRLUB" AND VAL(RIGHT(cCodAlfa,4))>=3000 AND VAL(RIGHT(cCodAlfa,4))<=5000
	cNomProveedor ='EXCO S.R.L.'
CASE LEFT(cCodAlfa,5)$"NRCEP" AND VAL(RIGHT(cCodAlfa,4))>=100 AND VAL(RIGHT(cCodAlfa,4))<=999
	cNomProveedor ='INTERCLEAN BRUSH CO. S.R.L.'
CASE LEFT(cCodAlfa,5)$"NRCEP" AND VAL(RIGHT(cCodAlfa,4))>=1000 AND VAL(RIGHT(cCodAlfa,4))<=2500
	cNomProveedor ='FS-FRANCISCO SALZANO SAICIA'
CASE LEFT(cCodAlfa,4)$"NAPA-NAPD-NAPM-NAPP-NAPT-NAPX"
	cNomProveedor ='FS-FRANCISCO SALZANO SAICIA'
CASE LEFT(cCodAlfa,5)$"NRTEP" AND VAL(RIGHT(cCodAlfa,4))>=1 AND VAL(RIGHT(cCodAlfa,4))<=29
	cNomProveedor ='TEXTIL DOSS S.R.L.'
CASE LEFT(cCodAlfa,5)$"NRTEP" AND VAL(RIGHT(cCodAlfa,4))>=30 AND VAL(RIGHT(cCodAlfa,4))<60
	cNomProveedor ='SILVETEX S.A.'
CASE cCodAlfa$"NRTEP0060"
	cNomProveedor ='LUPAÑOS SH DE RAMIREZ FP Y MJ'
CASE LEFT(cCodAlfa,5)$"NRTEP" AND VAL(RIGHT(cCodAlfa,4))>=70 AND VAL(RIGHT(cCodAlfa,4))<=90
	cNomProveedor ='INTERCLEAN BRUSH CO. S.R.L.'
CASE LEFT(cCodAlfa,5)$"NRCIC"
	cNomProveedor ='FERNANDO CICARE'
CASE LEFT(cCodAlfa,4)$"RNB-RNE-RNF-RNH-RNJ-RNL" OR LEFT(cCodAlfa,5)$"WEFAP-WEWAP"
	cNomProveedor ='R. NETO S.A.'
CASE LEFT(cCodAlfa,5)$"CUMIN" AND VAL(RIGHT(cCodAlfa,4))>=7000 AND VAL(RIGHT(cCodAlfa,4))<=7999
	cNomProveedor ='POLVER S.R.L.'
CASE LEFT(cCodAlfa,5)$"FABRA"
	cNomProveedor ='EMIRIAN SA'
CASE LEFT(cCodAlfa,5)$"NRELK-NRELT"
	cNomProveedor ='DAMIANI JULIO'
CASE LEFT(cCodAlfa,5)$"NRAB"
	cNomProveedor ='EST.MET.POWER S.A.I.C.F.I'
CASE LEFT(cCodAlfa,5)$"NRFUS-NRWD4"
	cNomProveedor ='PROV. SERV. S.A.'
CASE LEFT(cCodAlfa,5)$"NRGAS"
	cNomProveedor ='BROGAS S.C.A.'
CASE LEFT(cCodAlfa,5)$"NRPEN"
	cNomProveedor ='J.V.S. INTERAMERICANA S.A.'
CASE (LEFT(cCodAlfa,5)$"NRACC-NRCOL") OR cCodAlfa='NRTEOP0080'
	cNomProveedor ='T & T S.A.' 
CASE cCodAlfa = "FERRETERIA"
	cNomProveedor = 'ROLFO SRL'
CASE LEFT(cCodAlfa,5)$""
	cNomProveedor = ''									
OTHERWISE
ENDCASE
RETURN cNomProveedor

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
	lcnombre = "CAPILLA DEL SEÑOR"
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
	lcnombre = 'QUIÑIHUAL'
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
	lcnombre = 'SAN PATRICIO DEL CHAÑAR'
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
	lcnombre = 'PIÑEYRO (PDO. AVELLANEDA)'
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
