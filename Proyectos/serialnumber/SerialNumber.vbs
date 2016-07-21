On Error Resume Next

Set fso = CreateObject("Scripting.FileSystemObject")
Set drv = fso.Drives.Item("c")

If Err.Number >0 Then
	MsgBox "A is not a drive"
Else
	MsgBox drv.SerialNumber
End If 
On Error Goto 0

