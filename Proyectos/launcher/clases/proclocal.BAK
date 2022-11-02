FUNCTION DataCursor
PARAMETERS cName

DO CASE

CASE UPPER(RTRIM(cName)) = "PARACONFIG"
	CREATE CURSOR ParaConfig (sistema c(30), path c(200), grupo c(60), nrosistema i)
OTHERWISE
	RETURN .f.
ENDCASE

RETURN .t.
