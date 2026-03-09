echo on
cd\
c:
cd prog*86*
cd winscp
winscp.com /ini=nul /script="J:\XSOFTSQL\PROYECTOS\DISTRIBUIDORA\nextbynftp.txt"
copy J:\APLICACIONES\TAPIA\*.csv J:\APLICACIONES\TAPIA\hist 
del J:\APLICACIONES\TAPIA\*.csv /Q
