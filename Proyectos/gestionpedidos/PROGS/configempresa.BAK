&&Generar Conexion por empresa
nIdEmpresa = 12
cPassEmpresa = 'tuamor17'

CREATE CURSOR Conexion (id i, codigo i, aliasconexion c(30), servername c(60), initcatalogo c(60),origendata c(10);
,sourcetype c(10), username c(20), pwdname c(20), webservice c(60), pathdatabase c(60);
,pwdlen n(2), userlen n(2), idservpedido c(10), passpedido c(50), pmabrevia c(5),switch c(5);
,emprename c(20), emprepass c(20), euserlen n(2), epwdlen n(2))

llok = CargarXML(lcConectionString,'conexion.xml',"Conexion")

SELECT Conexion
GO TOP 
SCAN 
	IF codigo = 2
		cPass = 'pre!Venta11'
		cResult = EncriptarPM(cPass)
		nLen	= LEN(cResult)
		replace pwdname WITH cResult,pwdlen WITH nLen
		
		cUser = 'sa'
		cResult = EncriptarPM(cUser)
		nLen	= LEN(cResult)
		replace username WITH cResult,userlen WITH nLen
		
		cResult = EncriptarPM(ALLTRIM(str(nIdEmpresa)))
		nLen	= LEN(cResult)
		replace idservpedido WITH cResult
		
		cResult = EncriptarPM(cPassEmpresa)
		nLen	= LEN(cResult)
		replace emprepass WITH cResult,epwdlen WITH nLen
		
	ENDIF 
ENDSCAN  
GuardarXML(lcConectionString,'conexion.xml',"Conexion")

USE IN Conexion