*** Construir el fichero para ftp
SET ALTERNATE TO indexkb.ftp
SET ALTERNATE ON
SET CONSOLE OFF
? "open distribuidores.jbs.com.ar"
? "DistriUrquiza"
? "1q2w3e4r5t"
? "cd /DistribuidoraUrquiza"
? "get index2.txt"
? "quit"
SET CONSOLE ON
SET ALTERNATE OFF
SET ALTERNATE TO
*** Llamar al comando ftp
RUN ftp -s:indexkb.ftp > c:\resultado.txt