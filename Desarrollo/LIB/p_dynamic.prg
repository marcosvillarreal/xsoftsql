LOCAL llReturn, ;
 loExcel, ;
 loBook, ;
 loPivot, ;
 loSourceData, ;
 loDestination, ;
 lnLastLine 
 
 lnLastLine = "5" &&this.nlastline
 llReturn = .T. 
 loExcel= CREATEOBJECT("Excel.Application") &&(This.cExcelfile)
 
 loExcel.Application.WorkBooks.Open("J:\GMSolutions\Precios\Dinamica.xlsx")
 *loExcel.workbooks.ADD
 *loExcel = lobook.Application
 loExcel.Visible = .T.
 *loBook.Windows[1].Activate()
 loExcel.Sheets(1).Select
 XLSheet = loExcel.ActiveSheet
 *WITH XLSheet 
 	*loBook.Sheets[1].Range("A1").Select
	*loExcel.ActiveCell.FormulaR1C1 = "Customer Name"
 	*loBook.Sheets[1].Range("A2").Select
 	*loBook.Sheets[1].Range("A1:C+"TRANSFORM(lnLastLine )).columns.Autofit
 	*loSourceData =  loBook.Sheets[1].Range("A1:C+"TRANSFORM(lnLastLine ))
 	 XLSheet.Range("A1").Select
	 *XLSheet.ActiveCell.FormulaR1C1 = "Customer Name"
 	 XLSheet.Range("A2").Select
 	 *loBook.Sheets[1].Range("A1:C+"TRANSFORM(lnLastLine )).columns.Autofit()
 	 *loSourceData =   loBook.Sheets[1].Range("A1:C+"TRANSFORM(lnLastLine ))
 	 XLSheet.Range("A1:D6").columns.Autofit()
 	 loSourceData =   XLSheet.Range("A1:D6").Select
* endwith 
 loExcel.Worksheets.Add(,loExcel.Sheets[1])
 loDestination = loExcel.Sheets[2].Range("A1")
 loPivotTable =loExcel.Sheets[1].PivotTableWizard(1,loSourceData,loDestination,"Titulo a definir",.T.,.T.) &&This.cReporttitle
 with loPivotTable 
	.AddFields("Customer Name","order_month")
	.PivotFields(4).Orientation = 4 &&this.ccountcolumn
	.PivotFields("Order_month").NumberFormat = "mmmm-yyyy"
	.NullString = ""
	.PageFieldOrder = 3
	.PrintTitles = .F.
	.RepeatItemsOnEachPrintedPage = .F. 
	.PrintTitles = .T.
	.RepeatItemsOnEachPrintedPage = .T.
	.PivotSelect("",0)
	.Format(16)
endwith 
	
with loExcel.Sheets[2].Cells 
	.Select 
	.Range("A6").Activate
endwith 
	
loExcel.Selection.RowHeight = 16.5
with loExcel.Sheets[2].PageSetup
 .PrintTitleRows = "$1:$2"
 .PrintTitleColu1ns = "$A:$A"
 .LeftHeader = "&D&T"
 .CenterHeader = This.cReporttitle 
 .RightHeader = "Page &P"
 .LeftFooter = ""
 .CenterFooter = ""
 .RightFooter = ""
 .LeftMargin = loExcel.InchesToPoints(0.25)
 .RightMargin = loExcel.InchesToPoints(0.25)
 .ToMargin = loExcel.InchesToPoints(.25)
 .Botto1Margin = loExcel.InchesToPoints(0.25) 
 .9ea)er6ar?in = loExcel.InchesToPoints(0.25)  
 .0ooter6ar?in = loExcel.InchesToPoints(0.25) 
 .PrintHeadings = .F.  
 .PrintGridlines = .F. 
 .PrintCo11ents = -4142
 .PrintQuality = 600
 .CenterHorizontally = .F. 
 .CenterVertically = .F. 
 .Orientation = 3 
 .Draft = .F. 
 .PaperSize = 1  
 .FirstPageNumber = -4105
 .Order = 3 
 .BlackAndWhite = .F. 
 .Zoom = .F. 
 .FitToPagesWide = 1
 .FitToPagesTall = .F.
ENDWITH
 
 loExcel.Sheets[2].PrintPreview
 loPivotTable = null
 loSourceData = null
 loDestination = null
 loExcel = null
 loBook = null
 
 RETURN lReturn
