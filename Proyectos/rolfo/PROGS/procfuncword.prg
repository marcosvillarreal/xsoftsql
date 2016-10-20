FUNCTION EnterLinea

oWord.Selection.TypeParagraph
RETURN 

FUNCTION Fuente
PARAMETERS lcFuente,lnTam,lbNegrita
lcFuente = IIF(PCOUNT()<1,"Calibri",lcFuente)
lnTam = IIF(PCOUNT()<2,8,lnTam)
lbNegrita = IIF(PCOUNT()<3,.f.,lbNegrita)

#DEFINE wdToggle 9999998

oWord.Selection.Font.Name = lcFuente
oWord.Selection.Font.Size = lnTam
oWord.Selection.Font.Bold = wdToggle
IF lbNegrita
	oWord.Selection.Font.Bold = wdToggle
ENDIF 
RETURN 