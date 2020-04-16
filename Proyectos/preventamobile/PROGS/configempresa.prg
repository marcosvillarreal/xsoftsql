&&Generar Conexion por empresa
nIdEmpresa = 12
cPassEmpresa = 'tuamor17'

=DataCursor('Conexion')

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