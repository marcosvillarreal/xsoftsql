@echo on
cd \
cd prog*86*
cd winscp
winscp.com /ini=nul /script="c:\aplicaciones\leon\danonesftp.txt"

del c:\aplicaciones\danone_exp\* /Q

