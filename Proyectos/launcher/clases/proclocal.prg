FUNCTION DataCursor
PARAMETERS cName

DO CASE

CASE UPPER(RTRIM(cName)) = "PARACONFIG"
	CREATE CURSOR ParaConfig  (sistema c(30), path c(200), grupo c(50), nrosistema i,pathupdateexe c(200), filelogo c(100))
OTHERWISE
	RETURN .f.
ENDCASE

RETURN .t.
