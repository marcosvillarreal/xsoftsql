_screen.AutoCenter = .T.
SET SYSMENU OFF
SET STATUS OFF
SET STATUS BAR OFF
SET TALK OFF
SET CONSOLE OFF
SET RESOURCE OFF
SET DEVELOPMENT OFF
IF _vfp.StartMode != 0
	ON SHUTDOWN QUIT
ELSE
	SET DEFAULT TO "F:\WindowsScripts\Drawing Board\VB to VFP\" && Change to your development path
ENDIF

DO FORM vb2vfp


********************
FUNCTION ConvertVB2Vfp(lcVBCode)
********************
#DEFINE SIMPLEREPLACE 1
#DEFINE GETRIDOFREST 2
#DEFINE REPLACEANDRIDREST 3
#DEFINE DELETELINE 4
LOCAL lnCount, lnMax, lcWas, lcIs, lcVBCode

=HandleCRLF(lcVBCode)

lcVBCode = CHR(13)+CHR(10) + lcVBCode

lnMax = ALINES(aryCodeLines,lcVBCode, .T.) &&.T. Gets rid of leading and trailing spaces

=RemoveTabs(@aryCodeLines) &&Gets rid of leading and trailing tabs

=HandleIfElseif(@aryCodeLines)

=HandleSelectCase(@aryCodeLines)

=HandleMsgBox(@aryCodeLines)

=HandleConstants(@aryCodeLines)

lcVBCode = RebuildString(@aryCodeLines) && Put string back together

IF !USED("conversion")
	USE ADDBS(SYS(5)+CURDIR()) + "conversion.dbf" IN 0 ALIAS "conversion"
ENDIF
SELECT "conversion"
SCAN ALL
	lcWas = ALLTRIM(conversion.vbcode)
	lcIs = ALLTRIM(conversion.vfpcode)
	lcVBCode = STRTRAN(lcVBCode, &lcWas, &lcIs, -1, -1, conversion.repl_type)
ENDSCAN
USE IN SELECT("conversion")
RETURN strtran(lcVBCode,CHR(13) + CHR(10),"",1,1,1)

****************************
FUNCTION HandleCRLF(lcString)
****************************
	lcString = STRTRAN(lcString, CHR(13)+CHR(10), CHR(13), -1, -1, 1)
	lcString = STRTRAN(lcString, CHR(10), CHR(13), -1, -1, 1)
	lcString = STRTRAN(lcString, CHR(13), CHR(13)+CHR(10), -1, -1, 1)
	RETURN .T.
ENDFUNC

****************************
FUNCTION RemoveTabs(aryParam)
****************************
LOCAL lnCount, lnMax
lnMax = ALEN(aryParam)
FOR lnCount = 1 TO lnMax
	DO WHILE .T.
		IF LEFT(aryParam(lnCount),1) = CHR(9)
			aryParam(lnCount) = SUBSTR(aryParam(lnCount),2)
			LOOP
		ENDIF
		EXIT
	ENDDO
	DO WHILE .T.
		IF RIGHT(aryParam(lnCount),1) = CHR(9)
			aryParam(lnCount) = SUBSTR(aryParam(lnCount),1, LEN(aryParam(lnCount)) - 1)
			LOOP
		ENDIF
		EXIT
	ENDDO
ENDFOR
ENDFUNC

****************************
FUNCTION RebuildString(aryParam)
****************************
	EXTERNAL ARRAY aryParam
	LOCAL lnCount, lnMax, lcString
	lcString = ""
	lnMax = ALEN(aryParam)
	FOR lnCount = 1 TO lnMax
		lcString = lcString + ALLTRIM(aryParam(lnCount)) + CHR(13) + CHR(10)
	ENDFOR
	RETURN lcString
ENDFUNC

****************************
FUNCTION HandleConstants(aryParam)
****************************
EXTERNAL ARRAY aryParam
LOCAL lnCount, lnMax
lnMax = ALEN(aryParam)
FOR lnCount = 1 TO lnMax
	IF ATC([Const ], aryParam(lnCount)) > 0
		aryParam(lnCount) = STRTRAN(aryParam(lnCount),[Private Const ], [#DEFINE ], -1, -1, 1)
		aryParam(lnCount) = STRTRAN(aryParam(lnCount),[Public Const ], [#DEFINE ], -1, -1, 1)
		aryParam(lnCount) = STRTRAN(aryParam(lnCount),[Const ], [#DEFINE ], -1, -1, 1)
		aryParam(lnCount) = STRTRAN(aryParam(lnCount),[=], [], -1, -1, 1)
		*!* As String, As Integer, etc will get removed later in code
	ENDIF
ENDFOR
ENDFUNC

****************************
FUNCTION HandleMsgBox(aryParam)
****************************
	EXTERNAL ARRAY aryParam
	LOCAL lnCount, lnMax, lnAtMsgBox, lcFirstHalf, lcSecondHalf, lnPosition
	lnMax = ALEN(aryParam)
	FOR lnCount = 1 TO lnMax
		lnAtMsgBox = ATC("MSGBOX ", aryParam(lncount))
		IF lnAtMsgBox > 0
			lnPosition = ATC("'", aryParam(lnCount))
			IF lnPosition > 0 && In Line Comment
				lcFirstHalf = LEFT(aryParam(lncount),lnPosition - 1)
				lcSecondHalf = " " + SUBSTR(aryParam(lncount),lnPosition)
			ELSE
				lcFirstHalf = aryParam(lncount)
				lcSecondHalf = ""
			ENDIF				
			lcFirstHalf = STRTRAN(lcFirstHalf,CHR(40), "", -1, -1, 1)
			lcFirstHalf = STRTRAN(lcFirstHalf,CHR(41), "", -1, -1, 1)
			aryParam(lncount) = "MESSAGEBOX(" + SUBSTR(lcFirstHalf,lnAtMsgBox + 7) + ")" + lcSecondHalf
		ENDIF
	ENDFOR
	
	RETURN .T.
ENDFUNC

****************************
FUNCTION HandleSelectCase(aryParam)
****************************
EXTERNAL ARRAY aryParam
DIMENSION aryIfElseIf(1,3)
LOCAL lnCount, lnMax, lnLevel, lnPosition, lcFirstHalf, lcSecondHalf
STORE 0 TO lnLevel
lnLevel = 1
lnMax = ALEN(aryParam)

FOR lnCount = 1 TO lnMax
	lnPosition = ATC("'", aryParam(lnCount))
	IF lnPosition > 0 &&In Line Comment
		lcFirstHalf = LEFT(aryParam(lncount),lnPosition - 1)
		lcSecondHalf = " " + SUBSTR(aryParam(lncount),lnPosition)
	ELSE
		lcFirstHalf = aryParam(lncount)
		lcSecondHalf = ""
	ENDIF				
	IF ATC("Select Case ", lcFirstHalf) > 0
		=MarkSelectCase(@aryParam,lnCount, lnMax)
		*!* Select can be used without case, how to differentiate this from Select SQL and such
*!*		ELSE
*!*			IF ATC("Select ", lcFirstHalf) > 0
*!*				aryParam(lncount) = STRTRAN(aryParam(lncount),"Select ", "Select Case ", -1, -1, 1)
*!*				=MarkSelectCase(@aryParam,lnCount, lnMax)
*!*			ENDIF
	ENDIF
ENDFOR

RETURN .T.
ENDFUNC

****************************
FUNCTION MarkSelectCase(aryParam, lnStart, lnMax)
****************************
EXTERNAL ARRAY aryParam
EXTERNAL ARRAY aryTemp
LOCAL lnCount, lnLevel, lcVarName, lcFirstHalf, lcSecondHalf, lnPosition, lnCount2, lnMax2, lcString
lnLevel = 0
lcVarName = ""
FOR lnCount = lnStart TO lnMax
	DO case
	CASE ATC("End Select", aryParam(lnCount)) > 0
		lnLevel = lnLevel - 1
		IF lnLevel = 0
			aryParam(lncount) = STRTRAN(aryParam(lncount),"End Select", "ENDCASE", -1, -1, 1)
			RETURN .F.
		ENDIF
	CASE ATC("Select Case ", aryParam(lnCount)) > 0
		lnLevel = lnLevel + 1
		IF lnLevel = 1
			aryParam(lncount) = STRTRAN(aryParam(lncount),"Select Case ", "", -1, -1, 1)
			lnPosition = ATC("'", aryParam(lnCount))
			IF lnPosition > 0 &&In Line Comment
					lcFirstHalf = LEFT(aryParam(lncount),lnPosition - 1)
					lcSecondHalf = " " + SUBSTR(aryParam(lncount),lnPosition)
			ELSE
				lcFirstHalf = aryParam(lncount)
				lcSecondHalf = ""
			ENDIF					
			lcVarName = ALLTRIM(lcFirstHalf)
			aryParam(lnCount) = "DO CASE " + lcSecondHalf
		ENDIF
	CASE ATC("Case Else", aryParam(lnCount)) > 0
		IF lnLevel = 1
			aryParam(lncount) = STRTRAN(aryParam(lncount),"Case Else", "OTHERWISE", -1, -1, 1)
		ENDIF
	CASE ATC("Case Is ", aryParam(lnCount)) > 0 
		IF lnLevel = 1
			aryParam(lncount) = STRTRAN(aryParam(lncount),"Case Is ", "Case " + lcVarName + " ", -1, -1, 1)
		ENDIF
	CASE ATC("Case ", aryParam(lnCount)) > 0 
		IF lnLevel = 1
			IF ATC(" to ", aryParam(lnCount)) > 0
				lnPosition = ATC("'", aryParam(lnCount))
				IF lnPosition > 0 &&In Line Comment
					lcString =  LEFT(aryParam(lncount),lnPosition - 1)
				ELSE
					lcString =  aryParam(lncount)
				ENDIF
				IF ATC(",", lcString) > 0
*!*						aryParam(lncount) = STRTRAN(aryParam(lncount),"Case ", "", -1, -1, 1) + CHR(41)
					lnPosition = ATC("'", aryParam(lnCount))
					IF lnPosition > 0 &&In Line Comment
*!*							lcFirstHalf = STRTRAN(LEFT(aryParam(lncount),lnPosition - 1),"Case ", "CASE BETWEEN(" + lcVarName + CHR(44) + " ", -1, -1, 1) + ") "
							lcFirstHalf = LEFT(aryParam(lncount),lnPosition - 1)
							lcSecondHalf = " " + SUBSTR(aryParam(lncount),lnPosition)
					ELSE
						lcFirstHalf = aryParam(lncount)
						lcSecondHalf = ""
					ENDIF					
					lnMax2 = ALINES(aryTemp, lcFirstHalf, .T., ",")
					lcFirstHalf = ""
					FOR lnCount2 = 1 TO lnMax2
						IF ATC(" to ", aryTemp(lnCount2)) > 0
							lcString = STRTRAN(aryTemp(lnCount2)," to ", CHR(44) + " ", -1, -1, 1)
							lcString = "BETWEEN(" + lcVarName + CHR(44) + " " + lcString + CHR(41)
						ELSE
							lcString = lcVarName + " = " + aryTemp(lnCount2)
						ENDIF
						lcFirstHalf = lcFirstHalf + lcString + " OR "
					ENDFOR
					lcFirstHalf = LEFT(lcFirstHalf, LEN(lcFirstHalf) - 4)
					aryParam(lncount) = "CASE " + lcFirstHalf + lcSecondHalf
				ELSE
					aryParam(lncount) = STRTRAN(aryParam(lncount)," to ", CHR(44) + " ", -1, -1, 1)
					lnPosition = ATC("'", aryParam(lnCount))
					IF lnPosition > 0 &&In Line Comment
						lcFirstHalf = STRTRAN(LEFT(aryParam(lncount),lnPosition - 1),"Case ", "CASE BETWEEN(" + lcVarName + CHR(44) + " ", -1, -1, 1) + ") "
						lcSecondHalf = " " + SUBSTR(aryParam(lncount),lnPosition)
						aryParam(lncount) = lcFirstHalf + lcSecondHalf
					ELSE
						aryParam(lncount) = STRTRAN(aryParam(lncount),"Case ", "CASE BETWEEN(" + lcVarName + CHR(44) + " ", -1, -1, 1) + CHR(41)
					endif
				endif
			ELSE
				aryParam(lncount) = STRTRAN(aryParam(lncount),"Case ", "Case " + lcVarName + " = ", -1, -1, 1)
				aryParam(lncount) = STRTRAN(aryParam(lncount),",", " OR " + lcVarName + " = ", -1, -1, 1)
			ENDIF
		ENDIF
	ENDCASE
ENDFOR
RETURN .F.
ENDFUNC


****************************
FUNCTION HandleIfElseif(aryParam)
****************************
EXTERNAL ARRAY aryParam
DIMENSION aryIfElseIf(1,3)
LOCAL lnCount, lnMax, lnLevel
STORE 0 TO lnLevel
lnLevel = 1
lnMax = ALEN(aryParam)

FOR lnCount = 1 TO lnMax
	IF ATC("IF ", aryParam(lnCount)) > 0
		=MarkIf(@aryParam,lnCount, lnMax, HasElseIf(@aryParam, lnCount + 1, lnMax))
	ENDIF
ENDFOR

RETURN .T.
ENDFUNC

****************************
FUNCTION MarkIf(aryParam, lnStart, lnMax, llHasElseIf)
****************************
EXTERNAL ARRAY aryParam
LOCAL lnCount, lnLevel
lnLevel = 0

FOR lnCount = lnStart TO lnMax
	DO case
	CASE ATC("END IF", aryParam(lnCount)) > 0
		lnLevel = lnLevel - 1
		IF lnLevel = 0
			IF llHasElseIf
				aryParam(lncount) = STRTRAN(aryParam(lncount),"END IF", "ENDCASE", -1, -1, 1)
			ELSE
				aryParam(lncount) = STRTRAN(aryParam(lncount),"END IF", "ENDIF", -1, -1, 1)
			endif
			RETURN .F.
		ENDIF
	CASE ATC("ELSEIF ", aryParam(lnCount)) > 0
		IF lnLevel = 1
			aryParam(lncount) = STRTRAN(aryParam(lncount),"ELSEIF ", "CASE ", -1, -1, 1)
			aryParam(lncount) = STRTRAN(aryParam(lncount)," THEN", "", -1, -1, 1)
		ENDIF
	CASE ATC("IF ", aryParam(lnCount)) > 0
		lnLevel = lnLevel + 1
		IF lnLevel = 1
			IF llHasElseIf
				aryParam(lncount) = STRTRAN(aryParam(lncount),"IF ", "DO CASE" + CHR(13) + CHR(10) + "CASE ", -1, -1, 1)
			endif
			aryParam(lncount) = STRTRAN(aryParam(lncount)," THEN", "", -1, -1, 1)
		ENDIF
	CASE ATC("ELSE", aryParam(lnCount)) > 0 
		IF lnLevel = 1 AND llHasElseIf
			aryParam(lncount) = STRTRAN(aryParam(lncount),"ELSE", "OTHERWISE", -1, -1, 1)
		ENDIF
	ENDCASE
ENDFOR
RETURN .F.
ENDFUNC

****************************
FUNCTION HasElseif(aryParam, lnStart, lnMax)
****************************
EXTERNAL ARRAY aryParam
LOCAL lnCount, lnLevel
lnLevel = 0
FOR lnCount = lnStart TO lnMax
	DO case
	CASE ATC("END IF", aryParam(lnCount)) > 0
		lnLevel = lnLevel - 1
		IF lnLevel = -1
			RETURN .F.
		ENDIF
	CASE ATC("ELSEIF ", aryParam(lnCount)) > 0 AND lnLevel <= 0
		RETURN .T.
	CASE ATC("IF ", aryParam(lnCount)) > 0
		lnLevel = lnLevel + 1
	ENDCASE
ENDFOR
RETURN .F.
ENDFUNC


*!* if MID() has 2 commas and is followed by an = sign then it works like STUFF()