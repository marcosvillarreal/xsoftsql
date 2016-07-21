x=ADIR(larrayname,"c:\xsoftsql\proyectos\compufar\datos\*.DBF")
FOR I=1 TO X
    B="c:\xsoftsql\proyectos\compufar\datos\"+LARRAYNAME[I,1]
    USE &B 
    LIST STRUCTURE TO FILE C:\TMPCF\COMPUFAR.TXT ADDITIVE
    USE 
NEXT 