

LOCAL oParamEmail

oParamEmail = CREATEOBJECT('custom')
oParamEmail.AddProperty('cFile',"j:\remito_troque2.jpg")
oParamEmail.AddProperty('cSubject',"Prueba de Comprobante")
oParamEmail.AddProperty('cBody',"Estimado le acercamos su comprobante")
oParamEmail.AddProperty('cTo',"m.villarreal.8310@gmail.com")

LOCAL oEmail

oEmail = CREATEOBJECT('sendemail',oParamEmail)
IF VARTYPE(oEmail)$'O'
	oEmail.Show(1)
ENDIF 


oavisar.usuario('Salio')