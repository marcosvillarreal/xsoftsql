'pretend vb bas file - has example use in it too

IsLeapYear("2003")
IsLeapYear("2004")

Option Explicit

Private Sub IsLeapYear(strYear as String)
If Len(strYear) <> 0 Then
   intSelectedYear = Val(strYear)
 
   result = IIf(intSelectedYear Mod 4 = 0, 0, 1) - IIf(intSelectedYear Mod 100 = 0, 0, 1) + IIf(intSelectedYear Mod 400 = 0, 0, 1)

    If result = 0 Then
            MsgBox strYear & " is a Leap Year", vbInformation, "LEAP YEAR!"
	IsLeapYear = True
    Else
            MsgBox strYear & " is NOT a Leap Year", vbCritical, "NOT LEAP YEAR!"
	IsLeapYear = False
    End If
Else
    MsgBox "Invalid Input", vbCritical
End If
End Sub