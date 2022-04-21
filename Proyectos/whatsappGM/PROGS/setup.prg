*-- Seteos de VFP --
set century on
set date ital
set delete on
set exclu off
set multi on
set talk off
set notify off
set point to '.'
set separator to ','
set confirm on
set status off
set status bar off
set multilocks on
set autoincerror on
set escape off
set cursor on
Set EngineBehavior 80
SET MEMOWIDTH TO 8192
SET REPORTBEHAVIOR 90

DECLARE  INTEGER FindWindow IN WIN32API STRING , STRING  
DECLARE  INTEGER SetForegroundWindow IN WIN32API INTEGER  
DECLARE  INTEGER  ShowWindow  IN WIN32API INTEGER , INTEGER 
DECLARE INTEGER ShellExecute IN shell32.dll ; 
  INTEGER hndWin, ; 
  STRING cAction, ; 
  STRING cFileName, ; 
  STRING cParams, ;  
  STRING cDir, ; 
  INTEGER nShowWin