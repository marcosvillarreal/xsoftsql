echo on
cd\
c:
cd prog*86*
cd winscp
winscp.com /ini=nul /script="J:\XSOFTSQL\PROYECTOS\DISTRIBUIDORA\nextbynftp.txt"
copy J:\APLICACIONES\GARRONE\*.csv J:\APLICACIONES\GARRONE\hist 
del J:\APLICACIONES\GARRONE\*.csv /Q
