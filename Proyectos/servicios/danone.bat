@echo on
cd \
cd prog*86*
cd winscp
winscp.com /ini=nul /script="c:\aplicaciones\tapia\danonesftp.txt"

copy c:\aplicaciones\danone_exp\*.csv c:\aplicaciones\danone_exp\exp

del c:\aplicaciones\danone_exp\* /Q

