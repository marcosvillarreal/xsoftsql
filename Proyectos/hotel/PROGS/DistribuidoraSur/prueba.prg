DO setup
SET PROCEDURE  TO  proc.prg ADDITIVE  && Procedimientos generales
SET PROCEDURE  TO  syserror.prg ADDITIVE  
SET PROCEDURE TO z00_sur ADDITIVE 


cArchivo = "J:\Aplicaciones\DistribuidoraSur\recibidos.csv"
=LeerCuit(cArchivo)

SELECT CsrCuit
vista()

