FUNCTION WordReporte
LOCAL lcRutaPlantilla

lcRutaPlantilla="C:\plantilla04A.dotx"

oavisar.proceso('S','Generando salida por Word')
RELEASE ALL LIKE o*
PUBLIC oWord
oWord = CREATEOBJECT("Word.Application") 
oWord.Documents.Open(lcRutaPlantilla,, .t.) && Este .t. es para abrirlo solo lectura 

=WordCrearTablaProductos()
=WordCargarProductos()

oavisar.proceso('S','Generando salida por Word')
lcFileName = DTOS(DATE())+strzero(HOUR(DATETIME()),2)+STRZERO(MINUTE(DATETIME()),2)+strzero(SEC(DATETIME()),2)
oWord.ActiveDocument.SaveAs("c:\empleado"+lcFileName+".doc") 
oWord.ActiveDocument.Close() 
oWord.Quit 
RELEASE oWord 
oavisar.proceso('N')

RETURN 

FUNCTION WordCrearTablaProductos

oavisar.proceso('S','Generando salida por Word - Productos')
#DEFINE True .t.
#DEFINE False .f.
#DEFINE lnColorAzul 6299648
#DEFINE lnColorRojo 192
#DEFINE lnColorVioleta 10498160
#DEFINE lnColorNegro -587137025

&&wdLineStyle
#define wdLineStyleSingle 1
#define wdLineStyleNone 0
#define wdLineWidth050pt 4

&&wdBorder
#DEFINE wdBorderBottom -3
#DEFINE wdBorderDiagonalDown -7
#DEFINE wdBorderDiagonalUp -8
#DEFINE wdBorderHorizontal -5
#DEFINE wdBorderLeft -2
#DEFINE wdBorderRight -4
#DEFINE wdBorderTop -1
#DEFINE wdBorderVertical -6

&&wdUnits
#DEFINE wdLine 5 
#DEFINE wdCharacter 1 
#DEFINE wdCell 12

#DEFINE wdExtend 1 &&wdMovementType
&&wdTextureIndex
#DEFINE wdTextureSolid 1000 
#DEFINE wdTextureNone 0 

#DEFINE wdAutoFitFixed 0 &&wdAutoFitBehavior
#DEFINE wdWord9TableBehavior &&wdDefaultTableBehavior
&&wdColor
#DEFINE wdColorAutomatic -16777216
&&wdPreferredWidthType
#DEFINE wdPreferredWidthPercent 2
&& wdDeleteCells
#DEFINE wdDeleteCellsEntireRow 2
&& wdCellVerticalAligment
#DEFINE wdCellAlignVerticalBottom 3
&& wdConstant
#DEFINE wdToggle 9999998

WITH oWord.Selection
	=Fuente("Trebuchet MS",20,.t.)
    .TypeText("A - Cotizaci�n")
    =EnterLinea()
    .MoveUp (wdLine,1)
    .EndKey (wdLine,wdExtend)
    With .Borders(wdBorderBottom)
        .LineStyle = oWord.Options.DefaultBorderLineStyle
        .LineWidth = oWord.Options.DefaultBorderLineWidth
        .Color = oWord.Options.DefaultBorderColor
    EndWith
    .MoveDown (wdLine,1)
    =EnterLinea()
    
	*---Creamos la Tabla de 11 Columnas
	oWord.ActiveDocument.Tables.Add(.Range,1,11,wdWord9TableBehavior, wdAutoFitFixed)
	=Fuente() &&Default
    With .Tables(1)
        *.Style("Tabla con cuadr�cula")
        .ApplyStyleHeadingRows = True
        .ApplyStyleLastRow = False
        .ApplyStyleFirstColumn = True
        .ApplyStyleLastColumn = False
        .ApplyStyleRowBands = True
        .ApplyStyleColumnBands = False
    ENDWITH
    
     *-----Encabezado-----------
    .Font.Color = lnColorAzul
    .TypeText("GRUPO")
    .MoveRight(wdCell)
    .Font.Color = lnColorRojo
    .TypeText("Marca")
    .MoveRight(wdCell)
    .Font.Color = lnColorVioleta
    .TypeText("Part No.")
    .MoveRight(wdCell)
    .Font.Color = lnColorNegro
     .TypeText("Descripci�n")
    .MoveRight(wdCell)
    .MoveRight(wdCell)
    .Font.Color = lnColorVioleta
     .TypeText("Precio unitario, USD, NETO GRAVADO")
     .MoveRight(wdCell)
	.Font.Color = lnColorNegro
     .TypeText("Cantidad")
    .MoveRight(wdCell)
    .Font.Color = lnColorRojo
     .TypeText("SubTotal USD, neto gravado")
    .MoveRight(wdCell)
    .Font.Color = lnColorNegro
     .TypeText("Alicuota IVA aplicable")
    .MoveRight(wdCell)
    .Font.Color = lnColorNegro
     .TypeText("IVA USD")
    .MoveRight(wdCell)
    .Font.Color = lnColorAzul
     .TypeText("SubTotal USD IVA incluido")
    .MoveLeft(wdCell,11)
    
	*---Tama�o de las Columnas
    .Tables(1).AutoFitBehavior (wdAutoFitFixed)
    .Tables(1).Columns(1).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(1).PreferredWidth = 7.1
    .Tables(1).Columns(2).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(2).PreferredWidth = 7.6
    .Tables(1).Columns(3).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(3).PreferredWidth = 6.7
    .Tables(1).Columns(4).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(4).PreferredWidth = 17.6
    .Tables(1).Columns(5).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(5).PreferredWidth = 1.8
    .Tables(1).Columns(6).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(6).PreferredWidth = 9.1
    .Tables(1).Columns(7).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(7).PreferredWidth = 7.9
    .Tables(1).Columns(8).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(8).PreferredWidth = 11.5
    .Tables(1).Columns(9).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(9).PreferredWidth = 7.9
    .Tables(1).Columns(10).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(10).PreferredWidth = 11.5
    .Tables(1).Columns(11).PreferredWidthType = wdPreferredWidthPercent
    .Tables(1).Columns(11).PreferredWidth = 10.8
    
    *---Seleccionamos Las 11 Primeras columnas de la Fila 1
    .MoveRight(wdCharacter,11,wdExtend)
    .Cells.VerticalAlignment = wdCellAlignVerticalBottom
    *---Le seteamos los colores
    .Shading.Texture = wdTextureNone
    .Shading.ForegroundPatternColor = wdColorAutomatic
    .Shading.BackgroundPatternColor = -654246093
    *---Bajamos una linea y mantenmos la fila seleccionada
    *.MoveDown(wdLine,1,wdExtend)
    *---Seteamos Fuente y Tama�o
    *.Font.Name = "Calibri"
    *.Font.Size = 8
    =Fuente("Calibri",8,)
    *---Bordeados
  *  stop()
    With .Tables(1)
    	.Borders(wdBorderLeft).LineStyle = wdLineStyleNone
        .Borders(wdBorderRight).LineStyle = wdLineStyleNone
        .Borders(wdBorderVertical).LineStyle = wdLineStyleNone
        .Borders(wdBorderDiagonalDown).LineStyle = wdLineStyleNone
        .Borders(wdBorderDiagonalUp).LineStyle = wdLineStyleNone
        With .Borders(wdBorderTop)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .Color = -587137025
        EndWith
        With .Borders(wdBorderBottom)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .Color = -587137025
        EndWith
        .Borders.Shadow = False
    EndWith
    With oWord.Options
        .DefaultBorderLineStyle = wdLineStyleSingle
        .DefaultBorderLineWidth = wdLineWidth050pt
        .DefaultBorderColor = -587137025
    ENDWITH
    
ENDWITH 
oavisar.proceso('N')
RETURN 

FUNCTION WordCargarProductos

*!*	IF !USED('CsrAuxCuerfac')
*!*		RETURN 
*!*	ENDIF 

IF USED('CsrAuxCuerfac')
	USE IN CsrAuxCuerfac
ENDIF 

CREATE CURSOR CsrAuxCuerfac (nombre c(30),codigo c(8))
INSERT INTO CsrAuxCuerfac VALUES ('Producto 01','1')
INSERT INTO CsrAuxCuerfac VALUES ('Producto 02','2')

SELECT CsrAuxCuerfac
IF RECCOUNT('CsrAuxCuerfac')>=1
	WITH oWord.Selection
		.InsertRowsBelow(1)
		*---Seleccionamos Las 4 Primeras columnas de la Fila 1
		.MoveRight(wdCell)
    	.MoveRight(wdCharacter,4,wdExtend)
    	*---Le seteamos los colores
    	.Shading.Texture = wdTextureNone
    	.Shading.ForegroundPatternColor = wdColorAutomatic
    	.Shading.BackgroundPatternColor = -603914241
    	FOR lni=1 TO 6
    		.MoveRight(wdCell)
    	ENDFOR 
  		.MoveRight(wdCharacter,6,wdExtend)
  		.Shading.Texture = wdTextureNone
    	.Shading.ForegroundPatternColor = wdColorAutomatic
    	.Shading.BackgroundPatternColor = -603914241
    	
    	FOR lni=1 TO 6
    		.MoveLeft(wdCell)
    	ENDFOR 
	ENDWITH 
ENDIF

WITH oWord.Selection
	SELECT CsrAuxCuerfac
	GO TOP 
	DO WHILE !EOF() 
		*---------
		i =RECNO()
		SCATTER NAME OscCuerfac
		.TypeText('Rubro')
		.MoveRight(wdCell)
		.TypeText('Marca')
		.MoveRight(wdCell)
		.TypeText('Codigo')
		.MoveRight(wdCell)
		.TypeText('Descp')
		.MoveRight(wdCell)
		.MoveRight(wdCell)
		.TypeText('PRecio')
		.MoveRight(wdCell)
		.TypeText('Cantidad')
		.MoveRight(wdCell)
		.TypeText('PrecioUdS')
		.MoveRight(wdCell)
		.TypeText('%IVA')
		.MoveRight(wdCell)
		.TypeText('IVA UdS')
		.MoveRight(wdCell)
		.TypeText('Total')
		
		FOR lni=1 TO 10
    		.MoveLeft(wdCell)
    	ENDFOR 
		GO i
		*---------
		SKIP 
		IF !EOF()
			.InsertRowsBelow(1)
		ENDIF 
	ENDDO 
	With .Tables(1)
        With .Borders(wdBorderHorizontal)
            .LineStyle = wdLineStyleSingle
            .LineWidth = wdLineWidth050pt
            .Color = -587137025
        EndWith
	ENDWITH
ENDWITH 

RETURN 