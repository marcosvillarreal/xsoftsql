&&Prueba de Alerta de nueva version
LOCAL cResponse
cResponse = HayVersionExe("gestion.exe")

*oavisar.usuario(cResponse)

oAlert = createobject("deskalert","Titulo", cResponse)
*res = oAlert.NewAlert()
