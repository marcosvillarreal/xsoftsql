Clear
Set Safety Off

Public yout


Do select_frx
Do image_to_clip

Procedure select_frx
m.yrep=Getenv("TEMP")
Set Defa To (yrep)

xflname = DTOC(DATE(),1)+[_]+CHRTRAN(TIME(),[:],[]) 

m.yout=m.yrep+'\'+xflname

If !Directory(m.yout)
	Md (m.yrep+'\'+xflname)
Endi

Local afile
*afile=Getfile('frx')

&& you can this following line for testing purpose
afile=(_Samples + "\Solution\Reports\Colors.frx")

If !Empty(m.afile)
	m.ext=Lower(Justext(m.afile))
	If m.ext<>[frx]
		Messagebox('Please select only frx',0+16,'Whatsapp',3000)
		Return
	Endif
Else
	Messagebox('Report not selected',0+64,'Whatsapp',3000)
	Return
Endif

#Define OutputNothing -1
#Define OutputEMF 100
#Define OutputJPEG 102
#Define OutputGIF 103
#Define OutputPNG 104
#Define OutputBMP 105
#Define OutputTIFF 101
#Define OutputTIFFM 201

oListener =Newobject("ReportListener")
oListener.ListenerType=3
Report Form (afile) Preview Object oListener

myext=[.]+Alltrim('JPG')
ntype=OutputJPEG
m.yout=m.yout

For nPageno=1 To oListener.PageTotal
	cOutputFile = m.yout+"\myreport"+Trans(nPageno)+myext
	oListener.OutputPage(nPageno, cOutputFile,m.ntype)
Next

*!*	If Not Inlist(ntype,OutputTIFFM,1000,1001)
*!*		Run/N "explorer"  &yout
*!*	Endi

reporlistener=Null
Release ReportListener
Endproc

Procedure image_to_clip

Declare Integer Sleep In kernel32 Integer
Declare Integer OpenClipboard In User32 Integer
Declare Integer CloseClipboard In User32
Declare Integer EmptyClipboard In User32
Declare Integer SetClipboardData In User32 Integer,Integer
Declare Integer LoadImage In WIN32API Integer,String,Integer,Integer,Integer,Integer
Declare Integer GetClipboardData In User32 Integer
Declare Integer GdipCreateBitmapFromHBITMAP In GDIPlus.Dll Integer, Integer, Integer @
Declare Integer GdipSaveImageToFile In GDIPlus.Dll Integer,String,String @,String @
Declare Long GdipCreateHBITMAPFromBitmap In GDIPlus.Dll Long nativeImage, Long @, Long
Declare Long GdipCreateBitmapFromFile In GDIPlus.Dll String FileName, Long @nBitmap
Declare Long    GdipCreateBitmapFromFile    In GDIPlus.Dll String FileName, Long @nBitmap
Declare Long CopyImage In WIN32API Long hImage, Long, Long, Long , Long

Declare Sleep In kernel32 Integer
Declare  Integer FindWindow In WIN32API String , String
Declare  Integer SetForegroundWindow In WIN32API Integer
Declare  Integer  ShowWindow  In WIN32API Integer , Integer
Declare Integer ShellExecute In shell32.Dll ;
	INTEGER hndWin, ;
	STRING cAction, ;
	STRING cFileName, ;
	STRING cParams, ;
	STRING cDir, ;
	INTEGER nShowWin

#Define CF_BITMAP 2
#Define CF_DIB 8
#Define IMAGE_BITMAP 0
#Define LR_LOADFROMFILE 16
#Define LR_MONOCHROME 0x00000001

fso=Createobject("scripting.filesystemobject")
fld=fso.getfolder(yout)

For Each fil In fld.Files

	Local m.oo
	m.oo=Newobject("image")
	m.oo.Picture=m.yout+"\"+(fil.Name)

	Local lnWidth,lnHeight
	lnWidth=m.oo.Width
	lnHeight=m.oo.Height

	nBitmap=0
	hbm=0
	GdipCreateBitmapFromFile(Strconv(m.yout+"\"+(fil.Name)+0h00,5),@nBitmap)
	GdipCreateHBITMAPFromBitmap(nBitmap,@hbm,0)
	lhBmp = CopyImage(hbm, 0, m.lnWidth, m.lnHeight,0)
	If OpenClipboard(0)!= 0
		EmptyClipboard()
		SetClipboardData(CF_BITMAP, lhBmp)
		CloseClipboard()
	Endif

	Local lt, lhwnd
	cPhone=[5492916436628]
	cmd='whatsapp://send?phone=&cPhone'
	=ShellExecute(0, 'open', cmd,'', '', 1)
	Wait "" Timeout 3
	lt = "Whatsapp"
	lhwnd = FindWindow (0, lt)
	If lhwnd!= 0
		SetForegroundWindow (lhwnd)
		ShowWindow (lhwnd, 1)
		ox = Createobject ( "Wscript.Shell" )
		ox.sendKeys ("^{v}")
		Sleep(2000)
		ox.sendKeys ( '{ENTER}' )

	Else
		Messagebox ("Whatsapp is not activated!" )
	Endif
Next

Endproc 