echo on
cd\
c:
cd prog*86*
cd winscp
winscp.com /ini=nul /script="J:\XSOFTSQL\PROYECTOS\LEON\danonesftp.txt"
copy C:\GMSOLUTIONS\LEON\danone_exp\*.csv C:\GMSOLUTIONS\LEON\danone_exp\hist\
del C:\GMSOLUTIONS\LEON\danone_exp\*.csv /Q
